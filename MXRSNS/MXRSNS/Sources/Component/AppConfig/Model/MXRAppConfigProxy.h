//
//  MXRAppConfigProxy.h
//  huashida_home
//
//  Created by weiqing.tang on 2018/5/29.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRAppConfigModel.h"

@interface MXRAppConfigProxy : NSObject
@property (nonatomic, strong, readonly) NSMutableArray *configArray;

+(instancetype)getInstance;

-(void)addMXRAppConfigModelToConfigArray:(MXRAppConfigModel *)configModel;
@end
