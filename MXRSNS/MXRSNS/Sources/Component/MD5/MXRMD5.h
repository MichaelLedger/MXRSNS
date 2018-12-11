//
//  MXRMD5.h
//  huashida_home
//
//  Created by 周建顺 on 15/12/23.
//  Copyright © 2015年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRMD5 : NSObject

/*
 * 获取文件md5
 */
+ (NSString*)getFileMD5WithPath:(NSString*)path;

/*
 * 获取字符串md5
 */
+ (NSString *) md5:(NSString *)str;

@end
