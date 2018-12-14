//
//  MXRPKQuestionResultController.h
//  huashida_home
//
//  Created by MountainX on 2018/8/10.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRNetworkResponse.h"

@interface MXRPKQuestionResultController : NSObject

+ (void)purchaseWrongAnalysisWithQAId:(NSInteger)qaId success:(void(^)(MXRNetworkResponse *response))success failure:(void(^)(NSError *error))failure;

@end
