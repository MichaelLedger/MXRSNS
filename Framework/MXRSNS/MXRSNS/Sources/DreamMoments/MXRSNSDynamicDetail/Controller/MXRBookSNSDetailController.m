//
//  MXRBookSNSDetailController.m
//  huashida_home
//
//  Created by shuai.wang on 16/9/26.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//
#import "MXRBookSNSDetailController.h"
#import "NSMutableURLRequest+Ex.h"
#import "ALLNetworkURL.h"
//#import "MXRBaseGiftCoinNum.h"
#import "GlobalFunction.h"
#import "MXRJsonUtil.h"
#import "MXRBase64.h"
#import "GlobalBusyFlag.h"
#import "MXRSNSShareModel.h"
#import "MXRNetworkManager.h"


#define HAS_DELETE_DYNAMIC @"hasDeleteDynamic"
#define HAS_DELETE_DYNAMIC_WHEN_COMMENT @"HAS_DELETE_DYNAMIC_WHEN_Comment"
#define HAS_DELETE_DYNAMIC_WHEN_REPLY_COMMENT @"HAS_DELETE_DYNAMIC_WHEN_REPLY_COMMENT"
#define KNotificationNoMoreData @"NoMoreData"
static NSString * srcDeleteMomentErrcode = @"203002";    //该动态已删除
static NSString * srcCommentHasDeletedErrcode = @"203003";   //原评论已删除
@implementation MXRBookSNSDetailController

+(instancetype)getInstance {
    static MXRBookSNSDetailController* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MXRBookSNSDetailController alloc] init];
    });
    return instance;
}

/*
 *    梦想圈动态详情评论列表数据
 */
-(void)requestBookSNSDetailDataWithPage:(NSInteger)page dynamicId:(NSString *)dynamicId uid:(NSString *)uid withCallBack:(void(^)(BOOL isOk, MXRBookSNSDetailModel *bookSNSDetailModel))callBack {

    [[GlobalBusyFlag sharedInstance] showBusyFlagOnWindow];

    NSInteger pageRows = 20;
    NSDictionary *paramDict = @{@"uid":autoString([MXRBase64 encodeBase64WithString:uid]),
                                @"page":@(page),
                                @"rows":@(pageRows)
                                };
  
    NSString *urlString = ServiceURL_Book_SNS_Detail_Data(dynamicId);
    [MXRNetworkManager mxr_get:urlString parameters:paramDict success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        
        if (response.isSuccess && response.body)
        {
            MXRBookSNSDetailModel *model = [[MXRBookSNSDetailModel alloc] initWithDictionary:response.body];
            if (model.commentsModel.list.count < pageRows) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationNoMoreData object:nil];
            }
            if (callBack) {
                callBack(YES, model);
            }
        }
        else{
            if ([[(NSNumber *)response.errCode stringValue] isEqualToString:srcDeleteMomentErrcode]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:HAS_DELETE_DYNAMIC object:nil];
            }
            if (callBack) {
                callBack(NO, nil);
            }
        }
        [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
        DLOG(@"Error: %@", error);
        if (callBack) {
            callBack(NO, nil);
        }
    }];
}

/*
 *    获取动态点赞用户列表
 */
-(void)requestBookSNSPraiseListWithDynamicId:(NSString *)dynamicId uid:(NSString *)uid page:(NSInteger)page WithCallBack:(void(^)(BOOL isOk,MXRServerStatus status,MXRBookSNSPraiseModel *model))callBack {

    NSDictionary *paramDict = @{@"uid":autoString([MXRBase64 encodeBase64WithString:uid]),
                                @"page":@(page),
                                @"rows":@(30)
                                };

    NSString *urlString = ServiceURL_Book_SNS_Praise_List(dynamicId);
    [[GlobalBusyFlag sharedInstance] showBusyFlagOnWindow];
    [MXRNetworkManager mxr_get:urlString parameters:paramDict success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {

        if (response.isSuccess && response.body)
        {
            MXRBookSNSPraiseModel *model = [[MXRBookSNSPraiseModel alloc] initWithDictionary:response.body];
            if (callBack) {
                callBack(YES,MXRServerStatusSuccess,model);
            }
        }else{
    
            if (callBack) {
                callBack(NO,MXRServerStatusFail,nil);
            }
        }
        [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
        DLOG(@"Error: %@", error);
        if (callBack) {
            callBack(NO,MXRServerStatusNetworkError,nil);
        }
    }];
}

/*
 *    发布评论
 */
-(void)createNewCommentForDynamicWithDyId:(NSString *)dyId userId:(NSString *)userId userName:(NSString *)userName userLogo:(NSString *)userLogo content:(NSString *)content withCallBack:(void(^)(BOOL isOk, MXRBookSNSDetailCommentListModel *model))callBack{
    [[GlobalBusyFlag sharedInstance] showBusyFlagOnWindow];
    
    NSDictionary *params = @{@"dyId"    :@([dyId longLongValue]),
                             @"userId"  :@([userId intValue]),
                             @"userName":autoString(userName),
                             @"userLogo":autoString(userLogo),
                             @"content" :autoString(content)
                             };
    NSString *str = [MXRJsonUtil dictionaryToJson:params]; // 队列转字符串
    NSString *encodeStr = [MXRBase64 encodeBase64WithString:str]; // 加密

    [MXRNetworkManager mxr_post:ServiceURL_Community_Comments_Create parameters:encodeStr success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {

        if (response.isSuccess && response.body) {
            MXRBookSNSDetailCommentListModel *model= [[MXRBookSNSDetailCommentListModel alloc] initWithDictionary:response.body withModelType:ListModelOfUpload withModelFuncType:ListModelFuncOfSendComment withDataType:defaultDataType withCommentType:defaultCommentType];
            
            if (callBack) {
                callBack(YES, model);
            }
        }
        else{
            if ([[(NSNumber *)response.errCode stringValue] isEqualToString:srcDeleteMomentErrcode]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:HAS_DELETE_DYNAMIC_WHEN_COMMENT object:content];
            }
        }
        [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
    } failure:^(NSURLSessionTask *task, NSError *error) {
        DLOG(@"Error=%@",error);
        [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
        if (callBack) {
            callBack(NO, nil);
        }
    }];
}
/*
 *    回复评论
 */
-(void)replyCommentForDynamicWithDyId:(NSString *)dyId userId:(NSString *)userId userName:(NSString *)userName userLogo:(NSString *)userLogo content:(NSString *)content srcUserId:(NSInteger)srcUserId srcUserName:(NSString *)srcUserName srcContent:(NSString *)srcContent srcId:(NSInteger)srcId withCallBack:(void(^)(BOOL isOk, MXRBookSNSDetailCommentListModel *model))callBack {
    [[GlobalBusyFlag sharedInstance] showBusyFlagOnWindow];
    
    NSDictionary *params = @{@"dyId"        :@([dyId intValue]),
                             @"userId"      :@([userId intValue]),
                             @"userName"    :autoString(userName),
                             @"userLogo"    :autoString(userLogo),
                             @"content"     :autoString(content),
                             @"srcUserId"   :@(srcUserId),
                             @"srcUserName" :autoString(srcUserName),
                             @"srcContent"  :autoString(srcContent),
                             @"srcId"       :@(srcId),
                             };
    NSString *str = [MXRJsonUtil dictionaryToJson:params]; // 队列转字符串
    NSString *encodeStr = [MXRBase64 encodeBase64WithString:str]; // 加密
    
    [MXRNetworkManager mxr_post:ServiceURL_Community_Comments_Relpy parameters:encodeStr success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response) {
            if (response.isSuccess && response.body) {
                MXRBookSNSDetailCommentListModel *model= [[MXRBookSNSDetailCommentListModel alloc] initWithDictionary:response.body withModelType:ListModelOfUpload withModelFuncType:ListModelFuncOfSendReplyComment withDataType:defaultDataType withCommentType:defaultCommentType];
                
                if (callBack) {
                    callBack(YES, model);
                }
            } else {
                if ([[response.errCode stringValue] isEqualToString:srcDeleteMomentErrcode]) {
                    if (response.errMsg && [response.errMsg isKindOfClass:[NSString class]] && response.errMsg.length > 0) {
                        [MXRConstant showAlert:response.errMsg andShowTime:1.f];
                    } else {
                        [MXRConstant showAlert:MXRLocalizedString(@"MomentHasBeenDeleted", @"该动态已删除") andShowTime:1.f];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:HAS_DELETE_DYNAMIC_WHEN_REPLY_COMMENT object:content];
                } else if ([[(NSNumber *)response.errCode stringValue] isEqualToString:srcCommentHasDeletedErrcode]) {
                    if (response.errMsg && [response.errMsg isKindOfClass:[NSString class]] && response.errMsg.length > 0) {
                        [MXRConstant showAlert:response.errMsg andShowTime:1.f];
                    } else {
                        [MXRConstant showAlert:MXRLocalizedString(@"CommentHasBeenDeleted", @"原评论已删除") andShowTime:1.f];
                    }
                } else {
                    if (response.errMsg && [response.errMsg isKindOfClass:[NSString class]] && response.errMsg.length > 0) {
                        [MXRConstant showAlert:response.errMsg andShowTime:1.f];
                    }
                }
            }
            [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
        if (callBack) {
            callBack(NO, nil);
        }
    }];
}
/*
 *    动态详情页对评论  点赞
 */
-(void)addPraiseForDynamicWithID:(NSInteger)iD uid:(NSInteger)uid dyId:(NSInteger)dyId userName:(NSString *)userName userLogo:(NSString *)userLogo withCallBack:(void(^)(BOOL isOk))callBack{
    NSDictionary *params = @{@"id":@(iD),
                             @"uid":@(uid),
                             @"dyId":@(dyId),
                             @"userName":autoString(userName),
                             @"userLogo":autoString(userLogo),
                             };
    NSString *str = [MXRJsonUtil dictionaryToJson:params]; // 队列转字符串
    NSString *encodeStr = [MXRBase64 encodeBase64WithString:str]; // 加密
    
    [MXRNetworkManager mxr_post:ServiceURL_Community_Comments_Like parameters:encodeStr success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response)
        {
            if ([[response.errCode stringValue] isEqualToString:@"0"]) {
                if (callBack) {
                    callBack(YES);
                }
            }else{
                if (callBack) {
                    callBack(NO);
                }
            }
        }else{
            if (callBack) {
                callBack(NO);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        DLOG(@"******error:%@",error);
        if (callBack) {
            callBack(NO);
        }
    }];
}

/*
 *    动态详情页对评论  取消赞
 */
-(void)canclePraiseForDynamicWithID:(NSInteger)iD uid:(NSInteger)uid withCallBack:(void(^)(BOOL isOk))callBack{
    NSDictionary *params = @{@"id":@(iD),
                             @"uid":@(uid)
                             };
    NSString *str = [MXRJsonUtil dictionaryToJson:params]; // 队列转字符串
    NSString *encodeStr = [MXRBase64 encodeBase64WithString:str]; // 加密
    [MXRNetworkManager mxr_post:ServiceURL_Community_Comments_Cancel parameters:encodeStr success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response)
        {
            if ([[response.errCode stringValue] isEqualToString:@"0"]) {
                if (callBack) {
                    callBack(YES);
                }
            }else{
                if (callBack) {
                    callBack(NO);
                }
            }
        }else{
            if (callBack) {
                callBack(NO);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        DLOG(@"******error:%@",error);
        if (callBack) {
            callBack(NO);
        }
    }];
}

/*
 *    动态详情页对评论   删除
 */
-(void)deleteCommentWithCid:(NSInteger)cid dynamicId:(NSInteger)dynamicId withCallBack:(void(^)(BOOL isOk))callBack {
    NSString *cidString = [MXRBase64 encodeBase64WithString:[NSString stringWithFormat:@"%ld",(long)cid]];
//    NSDictionary *paramDict = @{@"cid":autoString(cidString)};
    NSString * url = [NSString stringWithFormat:@"%@?cid=%@",ServiceURL_Community_Delete_Comment((long)dynamicId),autoString(cidString)];
    
    [MXRNetworkManager mxr_delete:url parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response) {
            if ([[response.errCode stringValue] isEqualToString:@"0"]) {
                if (callBack) {
                    callBack(YES);
                }
            }else {
                if (callBack) {
                    callBack(NO);
                }
            }
        }else{
            if (callBack) {
                callBack(NO);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (callBack) {
            callBack(NO);
        }
    }];
}

//V5.9.5  梦想圈动态举报  reportId传梦想圈动态评论Id
-(void)reportCommentWithReportId:(NSInteger)reportId reportReason:(NSString *)reportReason withCallBack:(void(^)(BOOL isOk))callBack {
    CHECK_PARAM_NOT_NIL(reportReason);
    NSDictionary *params = @{@"userId":@([MAIN_USERID integerValue]),
                             @"reportId":@(reportId),
                             @"reportReason":autoString(reportReason)
                             };
    NSString *str = [MXRJsonUtil dictionaryToJson:params]; // 队列转字符串
    NSString *encodeStr = [MXRBase64 encodeBase64WithString:str]; // 加密

    [MXRNetworkManager mxr_post:ServiceURL_Community_Comments_Report parameters:encodeStr success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response) {
            if ([[response.errCode stringValue] isEqualToString:@"0"]) {
                if (callBack) {
                    callBack(YES);
                }
            }else{
                if (callBack) {
                    callBack(NO);
                }
            }
        }else{
            if (callBack) {
                callBack(NO);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (callBack) {
            callBack(NO);
        }
    }];
}
@end
