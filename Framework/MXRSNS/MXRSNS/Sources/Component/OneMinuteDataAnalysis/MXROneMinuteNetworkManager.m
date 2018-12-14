//
//  MXROneMinuteNetworkManager.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/7/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXROneMinuteNetworkManager.h"
#import "ALLNetworkURL.h"
#import "NSObject+MXRModel.h"
///datacollection/collection/behaviors/60s

#define SuffixURL_OneMuniteCollection @"datacollection/collection/behaviors/60s" // 一分钟统计
#define ServiceURL_OneMuniteCollection   URLStringCat(MXRBASE_API_URL(), SuffixURL_OneMuniteCollection)

@implementation MXROneMinuteNetworkManager

+ (void)postOneMinute:(MXROneMinuteDataModel *)param success:(void (^)(MXRNetworkResponse *))success failure:(void (^)(id))failure
{
    NSString *url = ServiceURL_OneMuniteCollection;
    [MXRNetworkManager mxr_post:url parameters:[param mxr_modelToJSONObject] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
        if (response.isSuccess) {
//            DLOG(@">>>>> one Minute Success");
        }
        else
        {
//            DLOG(@">>>>> 1One Minute error : %@", response.errMsg);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        DLOG(@">>>>> 2One Minute error : %@", [error localizedDescription]);
        if (failure) {
            failure(error);
        }
    }];
}

@end
