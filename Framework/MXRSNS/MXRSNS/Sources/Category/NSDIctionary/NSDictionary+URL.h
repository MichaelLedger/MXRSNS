//
//  NSDictionary+URL.h
//  huashida_home
//
//  Created by MountainX on 2017/11/10.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (URL)


/**
 将请求参数字典转换为参数字符串

 @param urlstr 请求地址
 @return 拼接了字典所有参数的地址
 */
- (NSString *)URLRequestStringWithURLStr:(NSString *)urlstr;

@end
