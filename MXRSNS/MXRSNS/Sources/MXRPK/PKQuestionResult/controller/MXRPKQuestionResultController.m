//
//  MXRPKQuestionResultController.m
//  huashida_home
//
//  Created by MountainX on 2018/8/10.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKQuestionResultController.h"
#import "MXRNetworkManager.h"
#import "MXRPKUrl.h"
#import "NSDictionary+URL.h"

NSString *const PurchaseAnalysisErrorDomain = @"PurchaseAnalysisErrorDomain";
NSError *PurchaseAnalysisErrorWithMessage(NSString *message)
{
    NSDictionary <NSErrorUserInfoKey, id> *errorInfo = @{NSLocalizedDescriptionKey : message};
    return [[NSError alloc] initWithDomain:PurchaseAnalysisErrorDomain code:0 userInfo:errorInfo];
}

@implementation MXRPKQuestionResultController

+ (void)purchaseWrongAnalysisWithQAId:(NSInteger)qaId success:(void (^)(MXRNetworkResponse *))success failure:(void (^)(NSError *))failure {
    //服务端要求参数拼接在URL后面
    NSDictionary *params = @{@"qaInfoId" : @(qaId)};
    NSString *url = [params URLRequestStringWithURLStr:ServiceURL_PK_Purchase_Analysis];
    [MXRNetworkManager mxr_post:url parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            if (success) {
                success(response);
            }
        } else {
            if (failure) {
                failure(PurchaseAnalysisErrorWithMessage(autoString(response.errMsg)));
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
