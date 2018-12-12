//
//  MXRPKNetworkManager.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKNetworkManager.h"
#import "GlobalBusyFlag.h"
#import "MXRPKUrl.h"
#import "MXRNetworkManager.h"

@implementation MXRPKNetworkManager

#pragma mark - shareManager
+(instancetype)shareManager
{
    static MXRPKNetworkManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:nil];
    });
    
    return manager;
}

+ (void)getQAListWithId:(MXRGetQAListWithIdR *)param
                success:(void (^)(MXRPKQuestionLibModel *))success
                failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@/%@", ServiceURL_PK_GetQAListWithId, param.qaId];
    [MXRNetworkManager mxr_get:url parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        MXRPKQuestionLibModel *pkQuestionLibModel = [MXRPKQuestionLibModel mxr_modelWithJSON:response.body];
        if (success) {
            success(pkQuestionLibModel);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)submitPKAnswers:(MXRSubmitPKAnswersR *)param
                success:(void (^)(MXRPKSubmitResultModel *))success
                failure:(void (^)(id))failure
{
    [MXRNetworkManager mxr_post:ServiceURL_PK_SubmitPkAnswers parameters:[param mxr_modelToJSONObject] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            MXRPKSubmitResultModel *submitReuslt = [MXRPKSubmitResultModel mxr_modelWithJSON:response.body];
            if (success) {
                success(submitReuslt);
            }
        }
        else
        {
            if (failure) {
                failure(response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@">>>> submit qa answer error: %@", error);
        if (failure) {
            failure(error);
        }
    }];
}

+(void)getPKHomeSuccess:(successCallback)success failure:(failureCallback)failure{
    [MXRNetworkManager mxr_get:ServiceURL_PK_QA_CLASSIFYS parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            
            NSArray *array = [NSArray mxr_modelArrayWithClass:[MXRPKHomeResponeModel class] json:response.body];
            
            if (success) {
                success(array);
            }
        }else{
            if (failure) {
                failure(MXRServerStatusFail, response.errMsg);
            }
        }
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        MXRServerStatus status = MXRServerStatusNetworkError;
        if (error.code == NSURLErrorCancelled) {
            status = MXRServerStatusNetworkCanceled;
        }
        
        if (failure) {
            failure(status, error);
        }
    }];
}


/**
 获取pk勋章列表服务
 
 @param success 返回pk勋章列表信息model
 @param failure 错误信息
 */
+(void)requestUserPKMedalListSuccess:(void(^)(MXRPKMedalInfoModel *pkMedalListInfo))success failure:(failureCallback)failure {
    [[GlobalBusyFlag sharedInstance] showBusyFlagOnWindow];
    [MXRNetworkManager mxr_get:ServiceURL_PK_MedalList parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess && response.body) {
            MXRPKMedalInfoModel *pkMedalList = [MXRPKMedalInfoModel mxr_modelWithJSON:response.body];
            
            //手动排序 V5.16.0 by MT.X
//            NSMutableArray <MXRPKMedalDetailModel *> *activeMedals = [NSMutableArray array];
//            NSMutableArray <MXRPKMedalDetailModel *> *inactiveMedals = [NSMutableArray array];
//            [pkMedalList.medalVos enumerateObjectsUsingBlock:^(MXRPKMedalDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (obj.isHold) {
//                    [activeMedals addObject:obj];
//                } else {
//                    [inactiveMedals addObject:obj];
//                }
//            }];
//            NSArray <MXRPKMedalDetailModel *> *rearrangeMedals = [activeMedals arrayByAddingObjectsFromArray:inactiveMedals];
//            pkMedalList.medalVos = rearrangeMedals;
            
            if (success) {
                success(pkMedalList);
            }
        }else {
            if (failure) {
                failure(MXRServerStatusFail, response.errMsg);
            }
        }
        [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
    }failure:^(NSURLSessionTask *task, NSError *error) {
        MXRServerStatus status = MXRServerStatusNetworkError;
        if (error.code == NSURLErrorCancelled) {
            status = MXRServerStatusNetworkCanceled;
        }
        
        if (failure) {
            failure(status, error);
        }
        [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
    }];
}

+(void)getPKHomeRankingInfoSuccess:(successCallback)success failure:(failureCallback)failure{
    [MXRNetworkManager mxr_get:ServiceURL_PK_RANKING_INFO parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            
            MXRPKHomeRankingInfoResponseModel *model = [MXRPKHomeRankingInfoResponseModel mxr_modelWithJSON:response.body];
            
            if (success) {
                success(model);
            }
        }else{
            if (failure) {
                failure(MXRServerStatusFail, response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        MXRServerStatus status = MXRServerStatusNetworkError;
        if (error.code == NSURLErrorCancelled) {
            status = MXRServerStatusNetworkCanceled;
        }

        if (failure) {
            failure(status, error);
        }
    }];
}


/**
 获取PK对象信息
 @param callBack 成功或者失败
 */
+(void)getPKUserInfoWithSuccess:(void (^)(MXRPKUserInfoModel *pkUserInfoModel))success
                        failure:(failureCallback)failure {
    [MXRNetworkManager mxr_get:ServiceURL_PK_Search parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess && response.body) {
            
            MXRPKQuestionLibModel *pkQuestionLibModel = [MXRPKQuestionLibModel mxr_modelWithJSON:response.body[@"questionAndAnswerModel"]];
            MXRRandomOpponentResult *randomOpponentResult = [MXRRandomOpponentResult mxr_modelWithJSON:response.body[@"randomOpponentResult"]];
            MXRPKUserInfoModel *pkInfoModel = [[MXRPKUserInfoModel alloc] initWithMXRPKQuestionLibModel:pkQuestionLibModel randomOpponentResult:randomOpponentResult];
            
            if (success) {
                success(pkInfoModel);
            }
        }else {
            if (failure) {
                failure(MXRServerStatusFail, response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        MXRServerStatus status = MXRServerStatusNetworkError;
        if (error.code == NSURLErrorCancelled) {
            status = MXRServerStatusNetworkCanceled;
        }
        
        if (failure) {
            failure(status, error);
        }
    }];
}

+ (void)requestPKChallengeInfoSuccess:(void (^)(MXRPKChallengeResponseModel *))success failure:(failureCallback)failure {
    [MXRNetworkManager mxr_get:ServiceURL_PK_Challenge_Info parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess && response.body) {
            MXRPKChallengeResponseModel *model = [MXRPKChallengeResponseModel mxr_modelWithJSON:response.body];
            if (success) {
                success(model);
            }
        } else {
            if (failure) {
                failure(MXRServerStatusFail, response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        MXRServerStatus status = MXRServerStatusNetworkError;
        if (error.code == NSURLErrorCancelled) {
            status = MXRServerStatusNetworkCanceled;
        }
        
        if (failure) {
            failure(status, error);
        }
    }];
}

+ (void)loadPKRankListsuccess:(void(^)(MXRNetworkResponse *response))success
                      failure:(void(^)(id error))failure {
    [MXRNetworkManager mxr_get:ServiceURL_PK_Rankings parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)fetchPropShopListWithPageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize Success:(void (^)(MXRPKPropShopResponseModel *))success failure:(failureCallback)failure {
    [MXRNetworkManager mxr_get:ServiceURL_PK_Challenge_Props parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess && response.body) {
            MXRPKPropShopResponseModel *model = [MXRPKPropShopResponseModel mxr_modelWithJSON:response.body];
            if (success) {
                success(model);
            }
        } else {
            if (failure) {
                failure(MXRServerStatusFail, response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        MXRServerStatus status = MXRServerStatusNetworkError;
        if (error.code == NSURLErrorCancelled) {
            status = MXRServerStatusNetworkCanceled;
        }
        
        if (failure) {
            failure(status, error);
        }
    }];
}

+ (void)purchasePropWithPropId:(NSInteger)propId coinNum:(NSInteger)coinNum success:(void (^)(MXRNetworkResponse *))success failure:(void (^)(id))failure {
    NSDictionary *param = @{@"propId" : @(propId),
                            @"coinNum" : @(coinNum)
                            };
    [MXRNetworkManager mxr_post:ServiceURL_PK_Challenge_Props_Buy parameters:param success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)challengeShareWithType:(NSInteger)type Success:(void (^)(MXRNetworkResponse *))success failure:(void (^)(id))failure {
    [MXRNetworkManager mxr_post:[NSString stringWithFormat:@"%@?type=%ld", ServiceURL_PK_Challenge_Share, type] parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
