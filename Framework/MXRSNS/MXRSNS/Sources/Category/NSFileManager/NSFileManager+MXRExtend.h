//
//  NSFileManager+MXRExtend.h
//  huashida_home
//
//  Created by 周建顺 on 2017/2/14.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager(MXRExtend)


/**
 判断文件是否损坏
 1.文件不存在，文件就为损坏
 2.如果文件存在且文件字节长度为0的话文件就为损坏

 @param path 文件路径
 @return 文件是否损坏
 */
+ (BOOL)mxr_checkIsErrorFile:(NSString*)path;

@end
