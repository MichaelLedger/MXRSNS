//
//  NSString+NSDate.m
//  huashida_home
//
//  Created by yuchen.li on 17/2/14.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "NSString+NSDate.h"
#import <UIKit/UIKit.h>
#import "MXRMacro.h"

@implementation NSString (NSDate)
+(NSString *)creatCurrentTimeWithFormatter:(NSString *)dateFormat{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    return  [formatter stringFromDate:[NSDate date]];
}

+(NSString *)getTodayTimeWithFormatter:(NSString *)dateFormat{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit |                                  NSYearCalendarUnit) fromDate:[NSDate date]];
    NSDate *todayDate = [calendar dateFromComponents:components];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:todayDate];
}

+(NSString *)createCurrentTimeWithLocalZone:(NSString *)timeZoneName dateFormatter:(NSString *)dateFormatter{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter	=  [[NSDateFormatter alloc] init];
    [formatter	setDateFormat:dateFormatter];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:date];
}

+(CGFloat)getTimeIntervalFromTimeStringSince1970:(NSString *)timeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * someDayDate = [formatter dateFromString:timeString];
    return  [someDayDate timeIntervalSince1970];

}

+(CGFloat)getTimeIntervalFromCurrentTimeSinceTimeString:(NSString *)timeString{
   NSString *currentTimeString = [self getTodayTimeWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
    CGFloat currentInterval = [self getTimeIntervalFromTimeStringSince1970:currentTimeString];
    CGFloat oneDayInterval  = [self getTimeIntervalFromTimeStringSince1970:timeString];
    return currentInterval - oneDayInterval;
}

+(NSString*)convertTimeWithDateStr:(NSString*)sourceDateStr{
    if(!sourceDateStr)
    {
        return @"";
    }
    
    if([sourceDateStr rangeOfString:@"-"].location == NSNotFound &&  [sourceDateStr rangeOfString:@"/"].location == NSNotFound)
    {//时间戳 进行转换
        NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
        formatter1.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [formatter1 setDateStyle:NSDateFormatterMediumStyle];
        [formatter1 setTimeStyle:NSDateFormatterShortStyle];
        [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        // 毫秒值转化为秒
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:[sourceDateStr doubleValue]/ 1000.0];
        sourceDateStr = [formatter1 stringFromDate:date];
    }
    NSString *wishStr = nil;
    NSString *dateStr = [sourceDateStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
    [newFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [newFormatter stringFromDate:currentDate];
    
    NSString *currentZeroDateStr;
    if (sourceDateStr.length > 19) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        currentZeroDateStr = [NSString stringWithFormat:@"%@ 00:00:00.000",currentDateStr];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        currentZeroDateStr = [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    }
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];//东八区
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];//GMT+0时区
    
    NSDate *strDate = [formatter dateFromString:dateStr];
    if (!strDate) {
        return dateStr;
    }

    NSDate *currentZeroDate = [formatter dateFromString:currentZeroDateStr];
    [newFormatter setDateFormat:@"yyyy"];
    NSString *currentYearStr = [newFormatter stringFromDate:currentDate];
    NSTimeInterval secondsZeroInterval= [currentZeroDate timeIntervalSinceDate:strDate];
    NSTimeInterval secondsInterval= [currentDate timeIntervalSinceDate:strDate];
    if (secondsInterval<=60) {
        wishStr = MXRLocalizedString(@"justNow", @"刚刚");
    }
    else if(secondsInterval<3600)
    {
        int minute = (int)secondsInterval/60;
        wishStr = [NSString stringWithFormat:@"%d%@", minute, minute == 1 ? MXRLocalizedString(@"oneminuteAgo", @"分钟前") :  MXRLocalizedString(@"minuteAgo", @"分钟前")];
    }
    else if(secondsInterval<3600*24)
    {
        int hour = (int)secondsInterval/3600;
        wishStr = [NSString stringWithFormat:@"%d%@", hour, hour == 1 ? MXRLocalizedString(@"onehourAgo", @"小时前") : MXRLocalizedString(@"hourAgo", @"小时前")];
    }
    else if (secondsZeroInterval<3600*24)
    {
        wishStr = MXRLocalizedString(@"yestday", @"昨天");
    }
    else if (secondsZeroInterval<3600*24*7)
    {
        int day = (int)secondsZeroInterval/(3600*24)+1;
        wishStr = [NSString stringWithFormat:@"%d%@", day, day == 1 ? MXRLocalizedString(@"onedayAgo", @"天前") : MXRLocalizedString(@"dayAgo", @"天前")];
    }
    else{ //超过8天
        if([dateStr rangeOfString:currentYearStr].location != NSNotFound) //今年
        {
            [newFormatter setDateFormat:@"MM-dd"];
            wishStr = [newFormatter stringFromDate:strDate];
        }
        else{ //往年
            [newFormatter setDateFormat:@"yyyy-MM-dd"];
            wishStr = [newFormatter stringFromDate:strDate];
        }
        
    }
    
    return wishStr;
}

+(NSString *)getCurrentTimeData {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
}

+(NSDate *)convertToDate:(NSString *)dateStr {
    NSDate *date;
    if (!dateStr || ![dateStr isKindOfClass:[NSString class]]) {
        date = [NSDate dateWithTimeIntervalSince1970:0];
    } else if([dateStr rangeOfString:@"-"].location == NSNotFound &&  [dateStr rangeOfString:@"/"].location == NSNotFound){//时间戳 进行转换
        //毫秒值转化为秒
        date = [NSDate dateWithTimeIntervalSince1970:[dateStr doubleValue]/1000.0];
    } else {
        //统一样式
        NSString *unifiedDateStr = [dateStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        //确定时间格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];//东八区
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSString *dateFormat_1 = @"yyyy-MM-dd HH:mm:ss.SSS";
        NSString *dateFormat_2 = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateFormat_3 = @"yyyy-MM-dd";
        NSArray <NSString *> *dateFormats = [NSArray arrayWithObjects:dateFormat_1, dateFormat_2, dateFormat_3, nil];
        [dateFormats enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (unifiedDateStr.length == obj.length) {
                [formatter setDateFormat:obj];
                *stop = YES;
            }
        }];
        if (!formatter.dateFormat) {
            date = [NSDate dateWithTimeIntervalSince1970:0];
        } else {
            date = [formatter dateFromString:unifiedDateStr];
        }
    }
    return date;
}

@end
