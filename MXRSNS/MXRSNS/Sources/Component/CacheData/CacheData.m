//
//  CacheData.m
//  DreamMultimediaBook
//
//  Created by zhenyu.wang on 13-12-14.
//  Copyright (c) 2013年 mxrcorp. All rights reserved.
//

#import "CacheData.h"

#define Publication_CacheData_Directory [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/CacheData"]

@implementation CacheData

+ (BOOL)fileExist:(NSString *)fileName{  
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew = [paths stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileNameNew]) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)deleteFileWithFileName:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileNameNew])
    {
        [fileManager removeItemAtPath:fileNameNew error:NULL];
    }
}


+ (BOOL)writeApplicationData:(id)data  writeFileName:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileNameNew])
    {
        [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:nil error:nil];
        return [data writeToFile:fileNameNew atomically:YES];//将NSData类型对象data写入文件，文件名为FileName
    }else{
        return [data writeToFile:fileNameNew atomically:YES];
    }
}

+ (BOOL)writeApplicationDataWithArray:(NSArray*)array  writeFileName:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:nil error:nil];
    NSData *writeData = [NSKeyedArchiver archivedDataWithRootObject:array];
    
    if (![fileManager fileExistsAtPath:fileNameNew])
    {
        return [writeData writeToFile:fileNameNew atomically:YES];//将NSData类型对象data写入文件，文件名为FileName
    }else{
        return [writeData writeToFile:fileNameNew atomically:YES];
    }
}

+ (BOOL)writeApplicationDataWithObject:(id<NSCoding>)object  writeFileName:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:nil error:nil];
    NSData *writeData = [NSKeyedArchiver archivedDataWithRootObject:object];
    
    if (![fileManager fileExistsAtPath:fileNameNew])
    {
        return [writeData writeToFile:fileNameNew atomically:YES];//将NSData类型对象data写入文件，文件名为FileName
    }else{
        return [writeData writeToFile:fileNameNew atomically:YES];
    }
}

+ (BOOL)writeApplicationDataWithObject:(id<NSCoding>)object  writeFilePath:(NSString *)filePath
{
    NSString *dirPath = [filePath stringByDeletingLastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = FALSE;
    
    BOOL isDirExist = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    
    
    if(!(isDirExist && isDir)){
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    

    NSData *writeData = [NSKeyedArchiver archivedDataWithRootObject:object];
    
    if (![fileManager fileExistsAtPath:filePath])
    {
        return [writeData writeToFile:filePath atomically:YES];//将NSData类型对象data写入文件，文件名为FileName
    }else{
        return [writeData writeToFile:filePath atomically:YES];
    }
}


+ (BOOL)write:(NSString *)str  writeFileName:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileNameNew])
    {
        [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:nil error:nil];
//        return[str writeToFile:fileNameNew atomically:YES];//将NSData类型对象data写入文件，文件名为FileName
        return [str writeToFile:fileNameNew atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else
        return NO;
}

+ (id)readApplicationData:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    NSMutableArray *myData = [[NSMutableArray alloc] initWithContentsOfFile:fileNameNew];
    return myData;
}

+ (id)readApplicationDict:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    NSDictionary *myData = [[NSDictionary alloc] initWithContentsOfFile:fileNameNew];
    return myData;
}

+(NSArray*)readApplicationArrayWithFileName:(NSString *)fileName{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:fileNameNew];
    
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;

}

+(id)readApplicationObjectWithFileName:(NSString *)fileName{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:fileNameNew];
    if (!data) return nil;
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return obj;
    
}

+(id)readApplicationObjectWithFilePath:(NSString *)filePath{
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return obj;
    
}

+ (id)readApplicationStr:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
//    NSString *myData = [[NSString alloc] initWithContentsOfFile:fileNameNew];
    NSString *myData = [[NSString alloc] initWithContentsOfFile:fileNameNew encoding:NSUTF8StringEncoding error:nil];
    return myData;
}

+ (void)removeCacheData:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:fileNameNew error:nil];
}

@end
