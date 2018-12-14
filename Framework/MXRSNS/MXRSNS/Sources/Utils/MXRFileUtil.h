//
//  MXRFileUtil.h
//  huashida_home
//
//  Created by 周建顺 on 16/1/20.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRFileUtil : NSObject

+ (long long) fileSizeAtPath:(NSString*) filePath;
+ (long long ) folderSizeAtPath:(NSString*) folderPath;

/**
 确保文件夹存在，不存在则创建文件夹
 */
+ (void) makeSureDirectoryExist:(NSString *)directoryPath;

+(BOOL) directoryAtPath:(NSString*) filePath;

@end
