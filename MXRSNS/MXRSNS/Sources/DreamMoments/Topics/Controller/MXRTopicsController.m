//
//  MXRTopicsController.m
//  huashida_home
//
//  Created by dingyang on 16/9/26.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRTopicsController.h"
#import "AFNetworking.h"
#import "ALLNetworkURL.h"
#import "GlobalFunction.h"
#import "NSMutableURLRequest+Ex.h"
#import "MXRJsonUtil.h"
#import "MXRTopicProxy.h"
#import "MXRTopicModel.h"
#import "MXRNetworkManager.h"
#import "MXRNetworkManager.h"
@interface MXRTopicsController()
@end
@implementation MXRTopicsController
+(instancetype)getInstance{
    static MXRTopicsController *search = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        search = [[MXRTopicsController alloc] init];
    });
    return search;
}
#pragma mark Request
/******************************************************************************/
-(void)getDynamicForTopicByUid:(NSString *)auid topicId:(NSString *)atopicId pageIndex:(NSInteger)apage rows:(NSInteger)arows andCallBack:(void(^)(BOOL isSuccess, id sender))callback{
    if (!auid || [auid isEqualToString:@""]) {
        auid = [UserInformation modelInformation].userID;
    }
    CHECK_PARAM_NOT_NIL(atopicId);
    NSString *auserID = [MXRBase64 encodeBase64WithString:auid];
    NSDictionary *parametersDic = @{@"uid":autoString(auserID),
                                    @"rows":@(20)//固定20，否则接口排序有问题
                                    };

    NSString *topicGetParUrl = [NSString stringWithFormat:@"%@/%@/dynamics",ServiceURL_BASE_TOPICS_DETAIL,atopicId];
    [MXRNetworkManager mxr_get:topicGetParUrl parameters:parametersDic success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess && response.body) {
            MXRTopicModel *model = [[MXRTopicModel alloc] initWithDictionary:(NSDictionary *)response.body];
            [[MXRTopicProxy getInstence] setCurrentModel:model];
            if (callback) {
                callback(YES, nil);
            }
        }else{
            if (callback) {
                callback(NO, response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (callback) {
             callback(NO, nil);
        }
    }];
    
}
/******************************************************************************/
-(void)getDynamicForTopicByUid:(NSString *)auid name:(NSString *)aname pageIndex:(NSInteger)apage rows:(NSInteger)arows andCallBack:(void(^)(BOOL isSuccess, id sender))callback{
    if (!auid || [auid isEqualToString:@""]) {
        auid = [UserInformation modelInformation].userID;
    }
    CHECK_PARAM_NOT_NIL(auid);
    CHECK_PARAM_NOT_NIL(aname);
    NSString *auserID = [MXRBase64 encodeBase64WithString:auid];
    NSString *aName = [MXRBase64 encodeBase64WithString:aname];
    NSDictionary *parametersDic = @{
                                    @"uid":autoString(auserID),
                                    @"name":autoString(aName),
                                    @"rows":@(20)//固定20，否则接口排序有问题
                                    };
    
    NSString *topicGetParUrl = [NSString stringWithFormat:@"%@/name/dynamics",ServiceURL_BASE_TOPICS_DETAIL];
    [MXRNetworkManager mxr_get:topicGetParUrl parameters:parametersDic success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess && response.body) {
            MXRTopicModel *model = [[MXRTopicModel alloc] initWithDictionary:(NSDictionary *)response.body];
            [[MXRTopicProxy getInstence] setCurrentModel:model];
            if (callback) {
                callback(YES, nil);
            }
        }else{
            if (callback) {
                callback(NO, response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (callback) {
            callback(NO, nil);
        }
    }];
}
/******************************************************************************/
-(void)getPreviousDynamicForTopicByUid:(NSString *)auid topicId:(NSString *)atopicId timeStamp:(NSString *)atimeStamp orderNum:(NSString *)aorderNum andCallBack:(void(^)(BOOL isSuccess, id sender))callback{
    if (!auid || [auid isEqualToString:@""]) {
        auid = [UserInformation modelInformation].userID;
    }
    CHECK_PARAM_NOT_NIL(auid);
    CHECK_PARAM_NOT_NIL(atopicId);
    CHECK_PARAM_NOT_NIL(atimeStamp);
    NSString *auserID = [MXRBase64 encodeBase64WithString:auid];
    NSDictionary *parametersDic = @{@"uid":autoString(auserID),@"timestamp":autoString(atimeStamp),@"orderNum":autoString(aorderNum),
                                    @"rows":@(20)//固定20，否则接口排序有问题
                                    };
    NSString *topicGetParUrl = [NSString stringWithFormat:@"%@/%@/dynamics/previous",ServiceURL_BASE_TOPICS_DETAIL,atopicId];
    
    [MXRNetworkManager mxr_get:topicGetParUrl parameters:parametersDic success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess && response.body) {
            MXRTopicModel *model = [[MXRTopicModel alloc] initWithDictionary:(NSDictionary *)response.body];
            [[MXRTopicProxy getInstence] setCurrentModel:model];
            if (callback) {
                callback(YES, nil);
            }
        }else{
            if (callback) {
                callback(NO, response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (callback) {
            callback(NO, nil);
        }
    }];
}
/******************************************************************************/
-(void)getNextDynamicForTopicByUid:(NSString *)auid topicId:(NSString *)atopicId timeStamp:(NSString *)atimeStamp orderNum:(NSString *)aorderNum andCallBack:(void(^)(BOOL isSuccess, id sender))callback{
    if (!auid) {
        auid = [UserInformation modelInformation].userID;
    }
    NSString *auserID = [MXRBase64 encodeBase64WithString:auid];
    NSDictionary *parametersDic = @{@"uid":autoString(auserID),@"timestamp":autoString(atimeStamp),@"orderNum":autoString(aorderNum),
                                    @"rows":@(20)//固定20，否则接口排序有问题
                                    };

    NSString *topicGetParUrl = [NSString stringWithFormat:@"%@/%@/dynamics/next",ServiceURL_BASE_TOPICS_DETAIL,atopicId];
    [MXRNetworkManager mxr_get:topicGetParUrl parameters:parametersDic success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess && response.body) {
            MXRTopicModel *model = [[MXRTopicModel alloc] initWithDictionary:(NSDictionary *)response.body];
            [[MXRTopicProxy getInstence] setCurrentModel:model];
            if (callback) {
                callback(YES, nil);
            }
        }else{
            if (callback) {
                callback(NO, response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (callback) {
            callback(NO, nil);
        }
    }];
}
/******************************************************************************/

-(void)collectTopicShareWithTopicId:(NSString *)topicId andShareWay:(NSInteger)shareWay andShareUserId:(NSString *)shareUserId andCallBack:(void (^)(BOOL))callback{
    
    NSDictionary *parametersDic = @{@"topicId":autoString(topicId),
                                    @"shareWay":[NSNumber numberWithInteger:shareWay],
                                    @"sharerId":autoString(shareUserId),
                                    @"deviceId":getCurrentUserIdAsscationDevice()};
    
    NSString *urlString = ServiceURL_Community_Topics_Collect_Share;
    [MXRNetworkManager mxr_post:urlString parameters:parametersDic success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            if (callback) callback(YES);
        }else{
            if (callback) callback(NO);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (callback) callback(NO);
    }];
}
@end
