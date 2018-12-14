//
//  MXRHeader.h
//  huashida_home
//
//  Created by weiqing.tang on 2017/9/8.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRHeader : NSObject


/*
 创建包头
 @return 返回包头的json字符串
 */
+(NSString*)createHeader;


/*
 创建包头,强制修改userid为0（特殊要求：切换账户时注册用户，userid必须为0，否则会注册为上一个登录账户）
 @return 返回包头的json字符串
 */
+(NSString*)createHeaderAndForceUserIdToZero;

@end
