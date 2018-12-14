//
//  MXRPKChallengeResponseModel.m
//  huashida_home
//
//  Created by MountainX on 2018/10/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKChallengeResponseModel.h"

@implementation MXRPKRadarModel

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mxr_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mxr_modelEncodeWithCoder:aCoder];
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    return [self mxr_modelCopy];
}

#pragma mark - MXRModelDelegate
//+ (NSDictionary<NSString *,id> *)mxr_modelCustomPropertyMapper
//{
//}

@end

@implementation MXRPKChallengeResponseModel

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mxr_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mxr_modelEncodeWithCoder:aCoder];
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    return [self mxr_modelCopy];
}

#pragma mark - MXRModelDelegate
+ (NSDictionary<NSString *,id> *)mxr_modelContainerPropertyGenericClass
{
    return @{@"qaChallengeUserAnswerStats":[MXRPKRadarModel class]};
}

#pragma mark - LKModel
+ (NSArray *)getPrimaryKeyUnionArray {
    return @[@"userId"];
}

@end
