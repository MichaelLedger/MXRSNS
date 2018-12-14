//
//  SandboxFile.m
//  SKY
//
//  Created by mac  on 12-9-19.
//  Copyright (c) 2012年 SKY. All rights reserved.
//

#import "SandboxFile.h"
#include <sys/xattr.h>

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation SandboxFile

/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取程序的Home目录路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)GetHomeDirectoryPath
{
    return NSHomeDirectory();
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取document目录路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)GetDocumentPath
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取Cache目录路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)GetCachePath
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取Library目录路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)GetLibraryPath
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取Tmp目录路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)GetTmpPath
{
    return NSTemporaryDirectory();
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊返回Documents下的指定文件路径(加创建)
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)GetDirectoryForDocuments:(NSString *)dir
{
    NSError* error;
    NSString* path = [[self GetDocumentPath] stringByAppendingPathComponent:dir];
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
    {
        #if defined(DEBUG)
        DLOG(@"create dir error: %@",error.debugDescription);
        #endif
    }
    return path;
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊返回Caches下的指定文件路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)GetDirectoryForCaches:(NSString *)dir
{
    NSError* error;
    NSString* path = [[self GetCachePath] stringByAppendingPathComponent:dir];
    
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
    {
        #if defined(DEBUG)
        DLOG(@"create dir error: %@",error.debugDescription);
        #endif
    }
    [SandboxFile addSkipBackupAttributeToItemAtURL:path];//不备份
    
    return path;
}

/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊创建目录文件夹
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)CreateList:(NSString *)List ListName:(NSString *)Name
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *FileDirectory=[List stringByAppendingPathComponent:Name];
    if ([self IsFileExists:Name])
    {
        #if defined(DEBUG)
        DLOG(@"exist,%@",Name);
        #endif
    }
    else
    {
        [fileManager createDirectoryAtPath:FileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        [SandboxFile addSkipBackupAttributeToItemAtURL:FileDirectory];//不备份
    }
    return FileDirectory;
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊写入NsArray文件
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(BOOL)WriteFileArray:(NSArray *)ArrarObject SpecifiedFile:(NSString *)path
{
    return [ArrarObject writeToFile:path atomically:YES];
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊写入NSDictionary文件
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(BOOL)WriteFileDictionary:(NSMutableDictionary *)DictionaryObject SpecifiedFile:(NSString *)path
{
    return [DictionaryObject writeToFile:path atomically:YES];
}
/*
  ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
  ＊是否存在该文件
  ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
  */
+(BOOL)IsFileExists:(NSString *)filepath
{
   return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊删除指定文件
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(BOOL)DeleteFile:(NSString *)filepath
{
    BOOL ret = YES;
    if([[NSFileManager defaultManager]fileExistsAtPath:filepath])
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filepath error:&error];
        ret = error?NO:YES;
    }
    return ret;
    
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取目录列表里所有的文件名
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSArray *)GetSubpathsAtPath:(NSString *)path
{
    NSFileManager *fileManage=[NSFileManager defaultManager];
    NSArray *file=[fileManage subpathsAtPath:path];
    return file;
}
+(void)deleteAllForDocumentsDir:(NSString *)dir
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:[self GetDirectoryForDocuments:dir] error:nil];
    for (NSString* filename in fileList) {
        [fileManager removeItemAtPath:[self GetPathForDocuments:filename inDir:dir] error:nil];
    }
}

/*
 删除制定文件夹下面的所有文件
 @params path NSString 文件夹路径
 @return Boolean 返回是否删除成功
 */
+(BOOL)delteFilesUnderFolder:(NSString*)path{
    if([SandboxFile IsFileExists:path]){
        NSArray *files= [SandboxFile GetSubpathsAtPath:path];
        for (NSString *subPath in files) {
            [SandboxFile DeleteFile:[path stringByAppendingPathComponent:subPath]];
        }
        return true;
    }else{
        return false;
    }
}


#pragma mark- 获取文件的数据
+(NSData *)GetDataForPath:(NSString *)path
{
    return [[NSFileManager defaultManager] contentsAtPath:path];
}
+(NSData *)GetDataForResource:(NSString *)name inDir:(NSString *)dir
{
    return [self GetDataForPath:[self GetPathForResource:name inDir:dir]];
}
+(NSData *)GetDataForDocuments:(NSString *)name inDir:(NSString *)dir
{
    return [self GetDataForPath:[self GetPathForDocuments:name inDir:dir]];
}



#pragma mark- 获取文件路径
+(NSString *)GetPathForResource:(NSString *)name
{
    return [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:name];
}
+(NSString *)GetPathForResource:(NSString *)name inDir:(NSString *)dir
{
    return [[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:dir] stringByAppendingPathComponent:name];
}
+ (NSString *)GetPathForDocuments:(NSString *)filename
{
    return [[self GetDocumentPath] stringByAppendingPathComponent:filename];
}
+(NSString *)GetPathForDocuments:(NSString *)filename inDir:(NSString *)dir
{
    return [[self GetDirectoryForDocuments:dir] stringByAppendingPathComponent:filename];
}
+(NSString *)GetPathForCaches:(NSString *)filename
{
    return [[self GetCachePath] stringByAppendingPathComponent:filename];
}
+(NSString *)GetPathForCaches:(NSString *)filename inDir:(NSString *)dir
{
    return [[self GetDirectoryForCaches:dir] stringByAppendingPathComponent:filename];
}

#pragma mark- 设置Do Not Backup扩展属性
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSString*) path
{
    if (SYSTEM_VERSION_LESS_THAN(@"5.1"))
    {
        const char* folderPath = [path fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(folderPath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    else
    {
#ifndef __IPHONE_5_1
#define NSURLIsExcludedFromBackupKey @"NSURLIsExcludedFromBackupKey"
#endif
        NSError *error = nil;
        NSURL* url = [NSURL fileURLWithPath:path];
        BOOL success = [url setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey
                                       error: &error];
        return success;
    }
}

+ (float)fileSizeForDir:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float size =0;
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    if (array == nil || array.count == 0) {
        return size;
    }
    for(int i = 0; i<[array count]; i++)
    {
        NSString *component = [array objectAtIndex:i];
        if ([component isEqualToString:@".DS_Store"]) {
            continue;
        }
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size += fileAttributeDic.fileSize;
        }
        else
        {
            size += [self fileSizeForDir:fullPath];
        }
    }
    return size;
}

@end
