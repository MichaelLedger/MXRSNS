//
//  MXRClickUtil.m
//  huashida_home
//
//  Created by shuai.wang on 2017/9/13.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRClickUtil.h"
#import <UMMobClick/MobClick.h>
#import "MXROneMinuteDataAnalysis.h"

@implementation MXRClickUtil
+(void)event:(NSString *)eventId {
    [MobClick event:eventId];
    if ([MXROneMinuteDataAnalysis isInAnalysisTime])
    {
        MXROneMinuteItemModel *model = [MXROneMinuteItemModel new];
        model.type = @"event";
        model.name = eventId;
        [MXROneMinuteDataAnalysis addItemData:model];
    }
}

+ (void)beginEvent:(NSString *)eventId
{
    [MobClick beginEvent:eventId];
}

+ (void)endEvent:(NSString *)eventId
{
    [MobClick endEvent:eventId];
}

+(void)beginLogPageView:(NSString *)pageName {
    [MobClick beginLogPageView:pageName];
}

+ (void)endLogPageView:(NSString *)pageName {
    [MobClick endLogPageView:pageName];
}

+(void)event:(NSString *)eventId attributes:(NSDictionary *)attributes{
    [MobClick event:eventId attributes:attributes];
}

@end
