//
//  NSString+Ex.m
//  huashida_home
//
//  Created by 周建顺 on 15/6/5.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "NSString+Ex.h"
#import <UIKit/UIKit.h>
#import "MXRConstant.h"
//#import "GlobalFunction.h"
#import "TTTAttributedLabel.h"

@implementation NSString(Ex)

+(NSString*)encodeUrlString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString =  (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)autoString(unencodedString),
                                                              
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              
                                                              NULL,
                                                              
                                                              kCFStringEncodingUTF8));
    return encodedString;
}
//URLDEcode
+(NSString *)decodeUrlString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)autoString(encodedString),
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}
#pragma mark  去除两端空格
-(NSString*)stringByTrimmingWhiteSpace{
    NSString *temp = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return temp;
    
}
#pragma mark 去除两端\t和\n
-(NSString*)stringByTrimmingWhiteTabbleAndEnter{
    NSString *text = [[[self stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""]
                      stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return text;
}
#pragma mark 去除两端空格和回车
-(NSString*)stringByTrimmingWhiteSpaceAndNewline{
    NSString *temp = [self stringByTrimmingWhiteSpace];
    NSString *text = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    return text;
}

#pragma mark 判断是否为空字符串
+ (BOOL) isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}
+(NSString *)setSpecailString:(NSString *)sender{
    
    if ([NSString isBlankString:sender]) {
        return nil;
    }
    NSMutableString *result = [[NSMutableString alloc] initWithString:sender];
    NSRange range = [sender rangeOfString:@"@"];
    int location = range.location;
    int leight = range.length;
    if (leight) {
        if (location - 1 > 1) {
            for (int i = 1; i <= (location - 1); i++) {
                [result replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
        }
    }else{
        if (result.length>=11) {
            [result replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }else{
            return result;
        }
        
    }
    return result;
}

/**
 *判断是否含有中文
 */
+(BOOL)isContainsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
    
}

+(instancetype) stringWithKeyWord:(NSString *)keyword webaddress:(NSString *)webaddress
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",keyword];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags options:NSRegularExpressionCaseInsensitive error:&error];
    
    // 执行匹配的过程
    // NSString *webaddress=@"http://wgpc.wzsafety.gov.cn/dd/adb.htm?adc=e12&xx=lkw&dalsjd=12";
    NSArray *matches = [regex matchesInString:webaddress options:0 range:NSMakeRange(0, [webaddress length])];
    for (NSTextCheckingResult *match in matches) {

        NSString *tagValue = [webaddress substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        //    DLOG(@"分组2所对应的串:%@\n",tagValue);
        return tagValue;
    }
    return nil;
}

/**
 *  将字典或者数组转化为JSON串
 *
 *  @param theData 字典或者数组
 *
 *  @return <#return value description#>
 */
+ (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:0
                                                         error:&error];

    if ([jsonData length] >0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

/**
 *  将字典或者数组转化为JSON串
 *
 *  @param data <#data description#>
 *
 *  @return <#return value description#>
 */
+(NSString*)jsonStringFromArrayOrDict:(id)data{
    
    if (![NSJSONSerialization isValidJSONObject:data]) {
        return nil;
    }

    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:0
                                                         error:&error];
    
    if (jsonData&&[jsonData length] >0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}

+(NSArray *)cupWordsByCommaForString:(NSString *)senderString{
    NSArray *tempArray = [senderString componentsSeparatedByString:@","];
    NSMutableArray *finailArray = [NSMutableArray array];
    for (int i = 0; i < tempArray.count; i ++) {
        NSString *aWord = tempArray[i];
        if (!aWord || [aWord isEqualToString:@""]) {
            continue;
        }
        
        [finailArray addObject:aWord];
    }
    return finailArray;
}
+(CGSize )caculateText:(NSString *)text andTextLabelSize:(CGSize)size andFont:(UIFont *)font andParagraphStyle:(NSMutableParagraphStyle *)style{

    CGSize t_size = [TTTAttributedLabel sizeThatFitsAttributedString:[[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style}] withConstraints:size limitedToNumberOfLines:0];
    return t_size;
}

+ (CGFloat)getHeightOfString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width andLineSpace:(CGFloat)space {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:space];
    NSDictionary *attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:style};
    CGSize retSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    return retSize.height;
}

+(CGSize )caculateText:(NSString *)text andTextLabelSize:(CGSize )size andFont:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize textSize = [text  boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return textSize;
}

- (NSUInteger)mxr_caculateUnicodeLength
{
    if (!self) {
        return 0;
    }
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self dataUsingEncoding:enc];
    return [da length];

}

- (NSString *)urlAppendCompnentWithKey:(NSString *)key value:(NSString *)value {
    /*
     http://192.168.0.125:10122/html/user_Bill.html?uid=KAoAAAB2TXVxdg==&v=5.9.4&t=ios&appId=10000000000000000000000000000001&culture=zh-cn
    特别注意：该方法对进行Base64加密后参数value不能准确读取 (uid = nil)
     */
    NSDictionary *params = [self getURLParameters:self];
    if (params && [params.allKeys containsObject:key]) {
        //已经拼接了参数
        DLOG(@"%@====无需重复拼接参数:%@,%@", self, key, value);
        return self;
    }
    
    NSMutableString *string = [[NSMutableString alloc]initWithString:autoString(self)];
    @try {
        NSRange range = [string rangeOfString:@"?"];
        if (range.location != NSNotFound) {//找到了
            //如果?是最后一个直接拼接参数
            if (string.length == (range.location + range.length)) {
                string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
            }else{//如果不是最后一个需要加&
                if([string hasSuffix:@"&"]){//如果最后一个是&,直接拼接
                    string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
                }else{//如果最后不是&,需要加&后拼接
                    string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,value]];
                }
            }
        }else{//没找到
            if([string hasSuffix:@"&"]){//如果最后一个是&,去掉&后拼接
                string = (NSMutableString *)[string substringToIndex:string.length-1];
            }
            string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"?%@=%@",key,value]];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    return string.copy;
}

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters:(NSString *)urlStr {
    
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            
            NSString *value;
            if (key) {
                // 进行优化，处理value中含有'='的情况
                if (keyValuePair.length > key.length + 1) {
                    value = [[keyValuePair substringFromIndex:key.length+1] stringByRemovingPercentEncoding];
                } else {
                    value = [pairComponents.lastObject stringByRemovingPercentEncoding];
                }
            } else {
                value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            }
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}

- (BOOL)mar_isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

@end

