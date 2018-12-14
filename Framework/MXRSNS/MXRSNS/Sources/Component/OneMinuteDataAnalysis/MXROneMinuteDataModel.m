//
//  MXROneMinuteDataModel.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/7/16.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXROneMinuteDataModel.h"
#import "MXRGlobalUtil.h"
#import "MXRDeviceUtil.h"
//#import <UIDevice+MAREX.h>
//#import <NSString+MAREX.h>

@implementation MXROneMinuteDataModel

- (instancetype)init
{
    if (self = [super init]) {
        _startTimeInterval = [[NSDate new] timeIntervalSince1970];
        _dataList = [NSMutableArray arrayWithCapacity:1<<5];
        _userId = [UserInformation modelInformation].userID;
        _deviceId = [MXRDeviceUtil getCurrentUserIdAsscationDevice]?:@"";
//        _mobileType = [[UIDevice currentDevice] mar_machineModelName];
        _mobileOSVersion = [[UIDevice currentDevice] systemVersion];
    }
    return self;
}

+ (NSArray<NSString *> * )mxr_modelPropertyBlacklist
{
    return @[@"startTimeInterval", @"endTimeInterval"];
}

- (NSString *)startTime
{
    if (self.startTimeInterval > 0) {
        MXRGLOBALUTIL.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.sss";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.startTimeInterval];
        return [MXRGLOBALUTIL.dateFormatter stringFromDate:date];
    }
    return nil;
}

- (NSString *)endTime
{
    if (self.endTimeInterval > 0) {
        MXRGLOBALUTIL.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.sss";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.endTimeInterval];
        return [MXRGLOBALUTIL.dateFormatter stringFromDate:date];
    }
    return nil;
}

- (NSInteger)duration
{
    if (_startTimeInterval > 0 && _endTimeInterval > 0) {
        return _endTimeInterval - _startTimeInterval;
    }
    return _duration;
}

- (NSMutableArray<MXROneMinuteItemModel *> *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithCapacity:1 << 5];
    }
    return _dataList;
}

//- (NSMutableArray<MXROneMinuteItemModel *> *)dataList
//{
//    if (!_dataList) {
//        _dataList = [NSMutableArray arrayWithCapacity: 1<<5];
//    }
//    return _dataList;
//}

@end

@implementation MXROneMinuteItemModel

- (instancetype)init
{
    if (self = [super init]) {
        _startTimeInterval = [[NSDate new] timeIntervalSince1970];
//        _uuid = [NSString mar_stringWithUUID];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[MXROneMinuteItemModel class]]) {
        MXROneMinuteItemModel *model = object;
        return [model.uuid isEqual:self.uuid];
    }
    return NO;
}

- (NSUInteger)hash
{
    return [self.uuid hash];
}

+ (NSArray<NSString *> * )mxr_modelPropertyBlacklist
{
    return @[@"startTimeInterval", @"endTimeInterval"];
}

- (NSString *)startTime
{
    if (self.startTimeInterval > 0) {
        MXRGLOBALUTIL.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.sss";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.startTimeInterval];
        return [MXRGLOBALUTIL.dateFormatter stringFromDate:date];
    }
    return nil;
}

- (NSString *)endTime
{
    if (self.endTimeInterval > 0) {
        MXRGLOBALUTIL.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.sss";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.endTimeInterval];
        return [MXRGLOBALUTIL.dateFormatter stringFromDate:date];
    }
    return nil;
}

- (NSMutableArray<MXROneMinuteItemModel *> *)eventList
{
    if (!_eventList) {
        _eventList = [NSMutableArray arrayWithCapacity: 1<<5];
    }
    return _eventList;
}

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

@end
