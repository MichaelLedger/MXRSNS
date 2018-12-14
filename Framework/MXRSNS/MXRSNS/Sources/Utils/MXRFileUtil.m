//
//  MXRFileUtil.m
//  huashida_home
//
//  Created by 周建顺 on 16/1/20.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRFileUtil.h"

@implementation MXRFileUtil

+ (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+(BOOL) directoryAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if ([manager fileExistsAtPath:filePath isDirectory:&isDirectory]){
        
        return isDirectory;
    }
    return NO;
}



//遍历文件夹获得文件夹大小，返回多少M
+ (long long ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize;
    
}

+ (void) makeSureDirectoryExist:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isDirExit = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if (!(isDirExit&&isDir))
    {
        NSError * fError = nil;
        BOOL result = [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&fError];
        
        if ( !result )
        {
#if defined(DEBUG)
            DLOG(@"获取书本fileList创建目录:%@失败，原因:%@",directoryPath,fError);
#endif
        }
    }
}



@end
