//
//  NSString+NSDate.h
//  huashida_home
//
//  Created by yuchen.li on 17/2/14.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSDate)

/**
 创建不同格式的时间
 
 @param dateFormat 时间格式  @"yyyy-MM-dd HH:mm:ss"  @"yyyy-MM-dd HH:mm:ss:sss"
 @return 时间
 */
+(NSString *)creatCurrentTimeWithFormatter:(NSString*)dateFormat;

/**
 创建 时间
 
 @param dateFormat 时间格式  @"yyyy-MM-dd HH:mm:ss"  @"yyyy-MM-dd HH:mm:ss:sss"
 @return 今天的日期  2017-02-13 00:00:00
 */
+(NSString *)getTodayTimeWithFormatter:(NSString *)dateFormat;

/**
 获得某个时区下的当前时间
 
 @param timeZoneName 区域名字  @"Asia/Shanghai"
 @param dateFormatter 时间格式 @"yyyy-MM-dd HH:mm:ss"
 @return 该区域当前时间的字符串  2017-02-14 08:43:10
 */
+(NSString *)createCurrentTimeWithLocalZone:(NSString *)timeZoneName dateFormatter:(NSString *)dateFormatter;

/**
 获取某个时间 至 1970 的时间间隔

 @param timeString 时间格式的字符串 @“2017-02-14 08:43:10”
 @return 浮点型的时间间隔
 */
+(CGFloat )getTimeIntervalFromTimeStringSince1970:(NSString *)timeString;

/**
 获取某个时间 和 当前时间 的时间间隔

 @param timeString @“2017-02-14 08:43:10”
 @return 两个时间的差值
 */
+(CGFloat )getTimeIntervalFromCurrentTimeSinceTimeString:(NSString *)timeString;

/**
 将时间字符串改为 刚刚  几分钟前 几小时前 几天前

 @param sourceDateStr 时间字符串 包括 时间戳 和 标准格式的时间字符串
 @return 间隔字段  eg：刚刚  几分钟前 几小时前 几天前
 */
+(NSString*)convertTimeWithDateStr:(NSString*)sourceDateStr;


/**
 获取当前时间的时间戳

 @return 当前时间的时间戳
 */
+(NSString *)getCurrentTimeData;

/**
 字符串转为日期

 @param dateStr 日期字符串
 @return 日期
 */
+(NSDate *)convertToDate:(NSString *)dateStr;

@end
