//
//  MXRBookSNSDetailManager.m
//  huashida_home
//
//  Created by shuai.wang on 16/10/11.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSDetailManager.h"
#import "MXRBookSNSDetailCommentListModel.h"
#import "MXRBookSNSPraiseListModel.h"
#import "MXRSNSShareModel.h"
#import "GlobalFunction.h"
#import "MXRBookSNSMomentStatusNoUploadManager.h"
#import "MXRDeviceUtil.h"

@implementation MXRBookSNSDetailManager

+(instancetype)getInstance {
    static MXRBookSNSDetailManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MXRBookSNSDetailManager alloc] init];
    });
    return manager;
}
-(instancetype)init{
    if (self= [super init]) {
         _noNetCommentList = [[NSMutableArray alloc] init];
    }
    return  self;
}
-(MXRBookSNSDetailCommentListModel *)cacheCommentModelWithContent:(NSString *)content withCommentListModel:(MXRBookSNSDetailCommentListModel *)model withListModelFuncType:(ListModelFuncType)funcType {

    MXRBookSNSDetailCommentListModel *listDodel = nil;
    NSDictionary *dic = nil;
    
    if (funcType == ListModelFuncOfAddPreaseComment) {
        NSInteger isPraise;
        if (model.hasPraised == 0) {
            isPraise = 1;
        }
        else{
            isPraise = 0;
        }
        dic = @{@"id":@(model.iD),
                @"dynamicId":@(model.dynamicId),
                @"userId":@(model.userId),
                @"userName":autoString(model.userName),
                @"userLogo":autoString(model.userLogo),
                @"createTime":autoString(model.createTime),
                @"content":autoString(model.content),
                @"praiseNum":@(model.praiseNum+1),
                @"srcUserId":@(model.srcUserId),
                @"srcUserName":autoString(model.srcUserName),
                @"srcId":@(model.srcId),
                @"deleteFlag":@(model.deleteFlag),
                @"srcStatus":@(model.srcStatus),
                @"srcContent":autoString(model.srcContent),
                @"hasPraised":@(isPraise),
                @"topSort":@(model.sort)
                };
    }
    
    if (funcType == ListModelFuncOfCanclePreaseComment) {
        NSInteger isPraise;
        if (model.hasPraised == 0) {
            isPraise = 1;
        }
        else{
            isPraise = 0;
        }
        dic = @{@"id":@(model.iD),
                @"dynamicId":@(model.dynamicId),
                @"userId":@(model.userId),
                @"userName":autoString(model.userName),
                @"userLogo":autoString(model.userLogo),
                @"createTime":autoString(model.createTime),
                @"content":autoString(model.content),
                @"praiseNum":@(model.praiseNum-1),
                @"srcUserId":@(model.srcUserId),
                @"srcUserName":autoString(model.srcUserName),
                @"srcId":@(model.srcId),
                @"deleteFlag":@(model.deleteFlag),
                @"srcStatus":@(model.srcStatus),
                @"srcContent":autoString(model.srcContent),
                @"hasPraised":@(isPraise),
                @"topSort":@(model.sort)
                };
    }

    if (funcType == ListModelFuncOfDeleteComment) {
        dic = @{@"id":@(model.iD),
                @"dynamicId":@(model.dynamicId),
                @"userId":@(model.userId),
                @"userName":autoString(model.userName),
                @"userLogo":autoString(model.userLogo),
                @"createTime":autoString(model.createTime),
                @"content":autoString(model.content),
                @"praiseNum":@(model.praiseNum),
                @"srcUserId":@(model.srcUserId),
                @"srcUserName":autoString(model.srcUserName),
                @"srcId":@(model.srcId),
                @"deleteFlag":@(0),
                @"srcStatus":@(1),
                @"srcContent":autoString(model.srcContent),
                @"hasPraised":@(model.hasPraised)
                };
    }

    listDodel = [[MXRBookSNSDetailCommentListModel alloc] initWithDictionary:dic withModelType:ListModelOfCache withModelFuncType:funcType withDataType:cacheDataType withCommentType:defaultCommentType];
   
    return listDodel;
}

-(MXRBookSNSPraiseListModel *)cacheDynamicPraiseInfoRefrashWithModel:(MXRSNSShareModel *)model {
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSDictionary *dic = @{@"iD":@"",
                          @"dynamicId":@([model.momentId integerValue]),
                          @"userId":@([[UserInformation modelInformation].userID integerValue]),
                          @"userName":autoString([UserInformation modelInformation].userNickName),
                          @"userLogo":autoString([UserInformation modelInformation].userImage),
                          @"createTime":[NSString stringWithFormat:@"%f",interval]
                          };
    MXRBookSNSPraiseListModel *praiseModel = [[MXRBookSNSPraiseListModel alloc] initWithDictionary:dic];
    return praiseModel;
}

//  本地  创建新评论
-(MXRBookSNSDetailCommentListModel *)cacheCreateCommentModelWithContent:(NSString *)content withCommentListModel:(MXRSNSShareModel *)model withListModelFuncType:(ListModelFuncType)funcType {
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSDictionary *  dic = @{@"id":@(arc4random()%99999),
                            @"dynamicId":@([model.momentId integerValue]),
                            @"userId":@([[UserInformation modelInformation].userID integerValue]),
                            @"userName":[UserInformation modelInformation].userNickName,
                            @"userLogo":[UserInformation modelInformation].userImage,
                            @"createTime":[NSString stringWithFormat:@"%f",interval],
                            @"content":autoString(content),
                            @"praiseNum":@(0),
                            @"srcUserId":@(0),
                            @"srcUserName":@"",
                            @"srcId":@(0),
                            @"deleteFlag":@(0),
                            @"srcStatus":@(0),
                            @"srcContent":@"",
                            @"hasPraised":@(0),
                            @"topSort":@(0)
                            };
    MXRBookSNSDetailCommentListModel *  listDodel = [[MXRBookSNSDetailCommentListModel alloc] initWithDictionary:dic withModelType:ListModelOfCache withModelFuncType:funcType withDataType:cacheDataType withCommentType:noNetWorkCreateComment];
    [_noNetCommentList addObject:listDodel];
    return listDodel;
}

//  本地  回复评论
-(MXRBookSNSDetailCommentListModel *)cacheReplyCommentModelWithContent:(NSString *)content withCommentListModel:(MXRBookSNSDetailCommentListModel *)model withListModelFuncType:(ListModelFuncType)funcType {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    
    NSDictionary * dic = @{@"id":@(arc4random()%99999),
                           @"dynamicId":@(model.dynamicId),
                           @"userId":@([[UserInformation modelInformation].userID integerValue]),
                           @"userName":[UserInformation modelInformation].userNickName,
                           @"userLogo":[UserInformation modelInformation].userImage,
                           @"createTime":[NSString stringWithFormat:@"%f",interval],
                           @"content":autoString(content),
                           @"praiseNum":@(0),
                           @"srcUserId":@(model.userId),
                           @"srcUserName":autoString(model.userName),
                           @"srcId":@(model.iD),
                           @"deleteFlag":@(0),
                           @"srcStatus":@(0),
                           @"srcContent":autoString(@""),
                           @"hasPraised":@(0),
                           @"topSort":@(0)
                           };
    MXRBookSNSDetailCommentListModel *  listDodel = [[MXRBookSNSDetailCommentListModel alloc] initWithDictionary:dic withModelType:ListModelOfCache withModelFuncType:funcType withDataType:cacheDataType withCommentType:noNetWorkCreateComment];
    [_noNetCommentList addObject:listDodel];
    return listDodel;
}

//   本地缓存举报信息
-(MXRBookSNSDetailCommentListModel *)cacheReportCommentModelWithContent:(NSString *)content withCommentListModel:(MXRBookSNSDetailCommentListModel *)model withListModelFuncType:(ListModelFuncType)funcType{
    
    NSDictionary *dic = @{@"id":@(model.iD),
                          @"dynamicId":@(model.dynamicId),
                          @"userId":@(model.userId),
                          @"userName":autoString(model.userName),
                          @"userLogo":autoString(model.userLogo),
                          @"createTime":autoString(model.createTime),
                          @"content":autoString(model.content),
                          @"praiseNum":@(model.praiseNum-1),
                          @"srcUserId":@(model.srcUserId),
                          @"srcUserName":autoString(model.srcUserName),
                          @"srcId":@(model.srcId),
                          @"deleteFlag":@(model.deleteFlag),
                          @"srcStatus":@(model.srcStatus),
                          @"srcContent":autoString(model.srcContent),
                          @"hasPraised":@(model.hasPraised),
                          @"reportReason":autoString(content)
                          };
    MXRBookSNSDetailCommentListModel *listDodel = [[MXRBookSNSDetailCommentListModel alloc] initWithDictionary:dic withModelType:ListModelOfCache withModelFuncType:funcType withDataType:cacheDataType withCommentType:defaultCommentType];
    return listDodel;
}

/*
 *     缓存数据到本地等待有网络下上传
 */
-(void)cacheDetailCommentDataForBookSNSManagerWithModel:(MXRBookSNSDetailCommentListModel *)cacheListModel {
    [[MXRBookSNSMomentStatusNoUploadManager getInstance] addCommentNoUploadModelWithUserHandleNoUploadStatusType:MXRBookSNSUserHandleNoUploadStatusTypeComment andBookSNSComment:cacheListModel andHandleUserId:[UserInformation modelInformation].userID];
}

-(void)deleteAllObject {
    [_noNetCommentList removeAllObjects];
}


-(MXRSNSCommentModel *)conversionMXRBookSNSDetailCommentListModel:(MXRBookSNSDetailCommentListModel *)model {

    MXRSNSCommentModel *commentMode = [[MXRSNSCommentModel alloc] init];
    commentMode.commentID = model.iD;
    commentMode.srcId = model.srcId;
    commentMode.srcUserId = model.srcUserId;
    commentMode.srcStatus = model.srcStatus;
    commentMode.userId = model.userId;
    commentMode.userName = model.userName;
    commentMode.delFlag = model.deleteFlag;
    commentMode.srcUserName = model.srcUserName;
    commentMode.content = model.content;
    commentMode.srcContent = model.srcContent;
    commentMode.sort = model.sort;
    
    return commentMode;
}

-(NSMutableArray<MXRSNSCommentModel *> *)conversionMXRBookSNSDetailCommentList:(NSArray<MXRBookSNSDetailCommentListModel *> *)commentList {
    NSMutableArray *commentArray = [NSMutableArray array];
    if (commentList.count > 0) {
        
        for (MXRBookSNSDetailCommentListModel *commentListModel in commentList) {
            if (commentArray.count < 2) {
                [commentArray addObject:[self conversionMXRBookSNSDetailCommentListModel:commentListModel]];
            }else{
                break;
            }
        }
        
    }
    return commentArray;
}
@end
