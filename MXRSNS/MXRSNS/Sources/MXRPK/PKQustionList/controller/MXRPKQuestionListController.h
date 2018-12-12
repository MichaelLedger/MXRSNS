//
//  MXRPKQuestionListController.h
//  huashida_home
//
//  Created by MountainX on 2018/8/8.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRNetworkManager.h"

@interface MXRPKQuestionListController : NSObject

+ (void)requestQuestionListWithCategoryId:(NSUInteger)categoryId page:(NSUInteger)page pageNum:(NSUInteger)pageNum success:(void(^)(MXRNetworkResponse *response))successs failure:(void(^)(NSError *error))failure;

@end
