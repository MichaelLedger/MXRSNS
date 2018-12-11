//
//  NSString+Ex.h
//  huashida_home
//
//  Created by 周建顺 on 15/6/5.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Ex)


+(NSString*)encodeUrlString:(NSString*)unencodedString;
//URLDEcode
+(NSString *)decodeUrlString:(NSString*)encodedString;
#pragma mark  去除两端空格
-(NSString*)stringByTrimmingWhiteSpace;

#pragma mark 去除两端空格和回车
-(NSString*)stringByTrimmingWhiteSpaceAndNewline;

#pragma mark 判断是否为空字符串
+ (BOOL) isBlankString:(NSString *)string;

#pragma mark 去除两端\t和\n
-(NSString*)stringByTrimmingWhiteTabbleAndEnter;
/**
 *判断是否含有中文
 */
+(BOOL)isContainsChinese:(NSString *)str;

+(instancetype) stringWithKeyWord:(NSString *)keyword webaddress:(NSString *)webaddress;

/**
 *  将字典或者数组转化为JSON串
 *
 *  @param data <#data description#>
 *
 *  @return <#return value description#>
 */
+(NSString*)jsonStringFromArrayOrDict:(id)data;
/**
 *  把手机号码转成密文形式
 */
+(NSString *)setSpecailString:(NSString *)sender;


/*用逗号分隔字符串*/
+(NSArray *)cupWordsByCommaForString:(NSString *)senderString;
/*根据label长度得到文字高度*/
+(CGSize )caculateText:(NSString *)text andTextLabelSize:(CGSize )size andFont:(UIFont *)font andParagraphStyle:(NSMutableParagraphStyle *)style;

/**
 *  计算有行间距的字符串高度
 *
 *  @param str   字符串
 *  @param font  字体大小
 *  @param width 宽度
 *  @param space 行间距
 *
 *  @return 字符串高度
 */
+ (CGFloat)getHeightOfString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width andLineSpace:(CGFloat)space;

+(CGSize )caculateText:(NSString *)text andTextLabelSize:(CGSize )size andFont:(UIFont *)font ;


/**
 计算字符串的长度，中文算两个长度，数字符号算一个长度
 @author Martin.liu
 */
- (NSUInteger)mxr_caculateUnicodeLength;

/**
 URL字符串添加参数

 @param key 参数键
 @param value 参数值
 @return 拼接了参数的URL字符串
 */
-(NSString *)urlAppendCompnentWithKey:(NSString *)key value:(NSString *)value;

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)mar_isNotBlank;

@end


