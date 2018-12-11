//
//  MXRJsonUtil.h
//  huashida_home
//
//  Created by 周建顺 on 16/3/23.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRJsonUtil : NSObject
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+(NSString*)arrayToJson:(NSArray *)array;
@end
