//
//  NSFileManager+MXRExtend.m
//  huashida_home
//
//  Created by 周建顺 on 2017/2/14.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "NSFileManager+MXRExtend.h"

@implementation NSFileManager(MXRExtend)

- (BOOL)mxr_checkIsErrorFile:(NSString*)path{
    
    if ([self fileExistsAtPath:path]) {
        long long filesize =  [[self attributesOfItemAtPath:path
                                                             error:NULL] fileSize];
        return filesize == 0;
    }else{
        return YES;
    }
    
    return NO;
}


+ (BOOL)mxr_checkIsErrorFile:(NSString*)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        long long filesize =  [[fileManager attributesOfItemAtPath:path
                                                      error:NULL] fileSize];
        return filesize == 0;
    }else{
        return YES;
    }
    
    return NO;
}


@end
