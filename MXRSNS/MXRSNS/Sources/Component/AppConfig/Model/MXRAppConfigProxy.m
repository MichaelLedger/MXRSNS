//
//  MXRAppConfigProxy.m
//  huashida_home
//
//  Created by weiqing.tang on 2018/5/29.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRAppConfigProxy.h"

@implementation MXRAppConfigProxy

+(instancetype)getInstance {
    static MXRAppConfigProxy *proxy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxy = [[MXRAppConfigProxy alloc] init];
    });
    return proxy;
}

-(instancetype)init {
    if (self = [super init]) {
        _configArray = [NSMutableArray array];
    }
    return self;
}

-(void)addMXRAppConfigModelToConfigArray:(MXRAppConfigModel *)configModel {
    [_configArray addObject:configModel];
}

@end
