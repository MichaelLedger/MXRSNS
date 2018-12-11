//
//  MXROneMinuteNetworkManager.h
//  huashida_home
//
//  Created by Martin.Liu on 2018/7/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXROneMinuteDataModel.h"
#import "MXRNetworkManager.h"

@interface MXROneMinuteNetworkManager : NSObject

+ (void)postOneMinute:(MXROneMinuteDataModel *)param
              success:(void (^)(MXRNetworkResponse *response))success
              failure:(void (^)(id error))failure;


@end
