//
//  MXRPKQuestionListController.m
//  huashida_home
//
//  Created by MountainX on 2018/8/8.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKQuestionListController.h"
#import "MXRNetworkManager.h"
#import "MXRPKUrl.h"

NSString *const PKQuestionListErrorDomain = @"PKQuestionListErrorDomain";
NSError *PKQuestionErrorWithMessage(NSString *message)
{
    NSDictionary <NSErrorUserInfoKey, id> *errorInfo = @{NSLocalizedDescriptionKey : message};
    return [[NSError alloc] initWithDomain:PKQuestionListErrorDomain code:0 userInfo:errorInfo];
}

@implementation MXRPKQuestionListController

+ (void)requestQuestionListWithCategoryId:(NSUInteger)categoryId page:(NSUInteger)page pageNum:(NSUInteger)pageNum success:(void(^)(MXRNetworkResponse *response))successs failure:(void(^)(NSError *error))failure {
    NSDictionary *param = @{@"type" : @(0),
                            @"page" : @(page),
                            @"rows" : @(pageNum),
                            @"classifyId" : @(categoryId)
                            };
    [MXRNetworkManager mxr_get:ServiceURL_PK_Question_List parameters:param success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            if (successs) {
                successs(response);
            }
        } else {
            if (failure) {
                failure(PKQuestionErrorWithMessage(autoString(response.errMsg)));
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
