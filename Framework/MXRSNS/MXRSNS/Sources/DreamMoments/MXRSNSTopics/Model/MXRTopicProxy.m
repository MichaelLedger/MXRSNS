//
//  MXRTopicProxy.m
//  huashida_home
//
//  Created by dingyang on 16/9/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRTopicProxy.h"

@implementation MXRTopicProxy
+(instancetype)getInstence{
    static MXRTopicProxy  *proxy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxy = [[MXRTopicProxy alloc] init];
    });
    return proxy;
}
-(void)clearCurrentModel{
    self.lastModel = self.currentModel;
    self.currentModel = nil;
}
@end
