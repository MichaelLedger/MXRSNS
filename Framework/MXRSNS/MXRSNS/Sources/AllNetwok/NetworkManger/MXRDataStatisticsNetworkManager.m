//
//  MXRDataStatisticsNetworkManager.m
//  huashida_home
//
//  Created by 周建顺 on 15/7/30.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "MXRDataStatisticsNetworkManager.h"
#import "ALLNetworkURL.h"

#import "AFNetworking.h"
#import "GlobalFunction.h"
//#import "MXRAddBookResult.h"
#import "NSMutableURLRequest+Ex.h"
#import "MXRNetworkManager.h"
//#import "MXRCapsuleToysModel.h"

@interface MXRDataStatisticsNetworkManager ()

@end

@implementation MXRDataStatisticsNetworkManager

+(instancetype)defaultInstance{
    static MXRDataStatisticsNetworkManager *instance;
    static dispatch_once_t pre;
    dispatch_once(&pre, ^{
        instance = [[MXRDataStatisticsNetworkManager alloc] init];
    });
    
    return instance;
}


/**
 binner 点击统计
 */
-(void)binnerClickDataWithBinnerId:(NSString*)binnerId callback:(defaultCallback)callback{

    NSDictionary *param = @{@"DeviceID":getCurrentUserIdAsscationDevice(),@"BannerId":autoString(binnerId)};
    
    NSString *urlString = ServiceURL_DATA_BINNER_CLICK;
    [MXRNetworkManager mxr_post:urlString parameters:param success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess){
            DLOG(@"mxrError:binner 统计成功");
        }else{
            DLOG(@"mxrError:binner 统计失败:%@",response.errMsg);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        DLOG(@"mxrError:binner 统计失败:%@",error);
    }];
}

/**
 分享次数统计
 */
-(void)shareCountDataWithBookGUID:(NSString*)bookGUID callback:(defaultCallback)callback{

    NSDictionary *param = @{@"DeviceID":getCurrentUserIdAsscationDevice(),
                            @"bookGuid":bookGUID};
    
    NSString *urlString = ServiceURL_DATA_SHARE_COUNT;
    [MXRNetworkManager mxr_post:urlString parameters:param success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess){
            DLOG(@"分享次数 统计成功");
        }else{
            DLOG(@"mxrError:分享次数 统计失败:%@",response.errMsg);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        DLOG(@"mxrError:分享次数 统计失败:%@",error);
    }];
}

/**
 分钟
 */
-(void)readingDurationDataWithBookGUID:(NSString*)bookGUID duration:(NSNumber*)duration callback:(defaultCallback)callback{
    
    if (getCurrentUserIdAsscationDevice() == nil) {
        return;
    }
    NSInteger bookSource = 0;
//    if ([MXRCapsuleToysModel isExistWithBookGuid:bookGUID]) {
//        bookSource = 1;
//    }
    NSDictionary *param = @{@"deviceId":getCurrentUserIdAsscationDevice(),
                            @"bookGuid":bookGUID,
                            @"readingDuration":duration,
                            @"bookSource":@(bookSource)
                            };
    NSString *urlString = ServiceURL_DATA_READING_DURATION;
    [MXRNetworkManager mxr_post:urlString parameters:param success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess){
            DLOG(@"阅读时长 统计成功");
        }else{
            DLOG(@"mxrError:阅读时长 统计失败:%@",response.errMsg);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        DLOG(@"mxrError:阅读时长 统计失败:%@",error);
    }];
}

/*
 * 报错
 */
//-(void)addErrorBookWithBookGuid:(NSString*)bookGUID pageNo:(NSString*)pageNo{
//    
//    
//    NSDictionary *param = @{@"deviceId":getCurrentUserIdAsscationDevice(),
//                            @"bookGuid":bookGUID,
//                            @"pageNo":pageNo};
//    
//    NSString *str = [MXRJsonUtil dictionaryToJson:param];
//    NSString *encodeStr = [MXRBase64 encodeBase64WithString:str];
//    
//    NSURL *url = [NSURL URLWithString:ServiceURL_DATA_ADD_ERROR_BOOK_PAGE];
//    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
//    
//    requestM.HTTPBody=[encodeStr dataUsingEncoding:NSUTF8StringEncoding];
//    requestM.HTTPMethod=@"POST";
//    [requestM addMXRHeader];
//    
//    
//    [MXRNetworkManager mxr_request:requestM success:^(NSURLResponse *URLresponse, id responseObject) {
//        MXRNetworkResponse *response = [MXRNetworkResponse mxr_modelWithJSON:responseObject];
//        
//        if (response.isSuccess){
//            DLOG(@"报错成功");
//        }else{
//            DLOG(@"报错失败:%@",response.errMsg);
//        }
//    } failure:^(NSURLResponse *URLresponse, id error) {
//        DLOG(@"报错失败:%@",error);
//    }];
//    
//
//}
/*
 * 获取举报图书的具体内容
 */
-(void)getReportBookDetailInfoWithCallBack:(defaultCallback)callback{
    NSString *urlString = ServiceURL_DATA_GET_REPORT_LIST;
    [MXRNetworkManager mxr_get:urlString parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess){
            callback(MXRServerStatusSuccess,response.body,nil);
        }else{
            callback(MXRServerStatusFail,nil,nil);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSError *errorObj = error;
        if (errorObj.code == NSURLErrorCancelled) {
            callback(MXRServerStatusNetworkCanceled,nil,nil);
        }else{
            callback(MXRServerStatusFail,nil,nil);
        }
    }];
}
/*
 * 举报（Diy 类型图书）
 */

-(void)reportDiyBookWithBookGuid:(NSString *)bookGUID reportContent:(NSString *)reportContent callback:(defaultCallback)callback{
    
    NSDictionary *param = @{@"deviceID":getCurrentUserIdAsscationDevice(),
                            @"bookGUID":bookGUID,
                            @"reportContent":reportContent};
    // 代码质量优化 M by liulong
    NSString *urlString = ServiceURL_DATA_REPORT_BOOK;
    [MXRNetworkManager mxr_post:urlString parameters:param success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess){
            callback(MXRServerStatusSuccess,nil,nil);
            DLOG(@"举报成功");
        }else{
            callback(MXRServerStatusFail,nil,nil);
            DLOG(@"举报失败:%@",response.errMsg);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSError *errorObj = error;
        if (errorObj.code == NSURLErrorCancelled) {
            callback(MXRServerStatusNetworkCanceled,nil,nil);
        }else{
            callback(MXRServerStatusFail,nil,nil);
        }
    }];
}

/*
 *  用户对图书点赞
 */
//-(void)userLikeBookWithUserId:(NSString *)userId andBookGuid:(NSString *)bookGuid andCallBack:(defaultCallback )callback{
//
//    NSDictionary *param = @{@"userID":userId,
//                            @"bookGUID":bookGuid};
//
//    NSString *str = [MXRJsonUtil dictionaryToJson:param];
//    NSString *encodeStr = [MXRBase64 encodeBase64WithString:str];
//
//    NSURL *url = [NSURL URLWithString:SuffixURL_BookDetail_PraiseBook];
//    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
//
//    requestM.HTTPBody=[encodeStr dataUsingEncoding:NSUTF8StringEncoding];
//    requestM.HTTPMethod=@"POST";
//    [requestM addMXRHeader];
//
//    [MXRNetworkManager mxr_request:requestM success:^(NSURLResponse *URLresponse, id responseObject) {
//       MXRNetworkResponse *response = [MXRNetworkResponse mxr_modelWithJSON:responseObject];
//
//        if (response.isSuccess){
//            callback(MXRServerStatusSuccess,nil,nil);
//            DLOG(@"点赞成功");
//        }else{
//            callback(MXRServerStatusFail,nil,nil);
//            DLOG(@"点赞失败:%@",response.errMsg);
//        }
//    } failure:^(NSURLResponse *URLresponse, id error) {
//        NSError *errorObj = error;
//        if (errorObj.code == NSURLErrorCancelled) {
//            callback(MXRServerStatusNetworkCanceled,nil,nil);
//        }else{
//            callback(MXRServerStatusFail,nil,nil);
//        }
//    }];
//
//
//}

/*
 *  用户对图书取消赞
 */
//-(void)userCancleLikeBookWithUserId:(NSString *)userId andBookGuid:(NSString *)bookGuid andCallBack:(defaultCallback )callback{
//
//    NSDictionary *param = @{@"userID":userId,
//                            @"bookGUID":bookGuid};
//    NSString *str = [MXRJsonUtil dictionaryToJson:param];
//    NSString *encodeStr = [MXRBase64 encodeBase64WithString:str];
//
//    NSURL *url = [NSURL URLWithString:SuffixURL_BookDetail_CancelPraiseBook];
//    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
//
//    requestM.HTTPBody=[encodeStr dataUsingEncoding:NSUTF8StringEncoding];
//    requestM.HTTPMethod=@"POST";
//    [requestM addMXRHeader];
//
//    [MXRNetworkManager mxr_request:requestM success:^(NSURLResponse *URLresponse, id responseObject) {
//        MXRNetworkResponse *response = [MXRNetworkResponse mxr_modelWithJSON:responseObject];
//
//        if (response.isSuccess){
//            callback(MXRServerStatusSuccess,nil,nil);
//            DLOG(@"取消点赞成功");
//        }else{
//            callback(MXRServerStatusFail,nil,nil);
//            DLOG(@"取消点赞失败:%@",response.errMsg);
//        }
//    } failure:^(NSURLResponse *URLresponse, id error) {
//        NSError *errorObj = error;
//       if (errorObj.code == NSURLErrorCancelled) {
//            callback(MXRServerStatusNetworkCanceled,nil,nil);
//        }else{
//            callback(MXRServerStatusFail,nil,nil);
//        }
//    }];
//
//}
-(void)shareCountDataWithBookGUID:(NSString *)bookGuid andShareContent:(NSString *)shareContent andShareWay:(NSInteger)shareWay andCallBack:(defaultCallback)callback{
    
    NSDictionary *param = @{@"shareContent":autoString(shareContent),
                            @"shareWay":[NSNumber numberWithInteger:shareWay],
                            @"bookGuid":autoString(bookGuid),
                            @"sharerId":[UserInformation modelInformation].userID,
                            @"deviceId":getCurrentUserIdAsscationDevice(),
                            @"shareType":@"bookShare"
                            };
    // 代码质量优化 M by liu long
    NSString *urlStirng = ServiceURL_DataCollection_Share;
    [MXRNetworkManager mxr_post:urlStirng parameters:param success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        
    }];
}
@end
