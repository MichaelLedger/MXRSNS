//
//  MXRPKMedalInfoModel.m
//  huashida_home
//
//  Created by shuai.wang on 2018/1/20.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKMedalInfoModel.h"

@implementation MXRPKMedalDetailModel
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mxr_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mxr_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mxr_modelCopy];
}

@end


@implementation MXRPKMedalInfoModel
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mxr_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mxr_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mxr_modelCopy];
}


+ (NSDictionary<NSString *,id> *)mxr_modelContainerPropertyGenericClass
{
    return @{@"medalVos":[MXRPKMedalDetailModel class]};
}
@end
