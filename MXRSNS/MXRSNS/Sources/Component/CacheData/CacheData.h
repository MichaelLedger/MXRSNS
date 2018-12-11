//
//  CacheData.h
//  DreamMultimediaBook
//
//  Created by zhenyu.wang on 13-12-14.
//  Copyright (c) 2013年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheData : NSObject

+ (BOOL)fileExist:(NSString *)fileName;
+ (void)deleteFileWithFileName:(NSString *)fileName;
+ (BOOL)writeApplicationData:(id)data  writeFileName:(NSString *)fileName;
+ (id)readApplicationData:(NSString *)fileName;
+ (id)readApplicationDict:(NSString *)fileName;
+ (id)readApplicationStr:(NSString *)fileName;
+ (void)removeCacheData:(NSString *)fileName;
+ (BOOL)write:(NSString *)str  writeFileName:(NSString *)fileName;

+ (BOOL)writeApplicationDataWithArray:(NSArray*)array  writeFileName:(NSString *)fileName;
+  (NSArray*)readApplicationArrayWithFileName:(NSString *)fileName;

+(id)readApplicationObjectWithFileName:(NSString *)fileName;
+ (BOOL)writeApplicationDataWithObject:(id<NSCoding>)object  writeFileName:(NSString *)fileName;

+ (BOOL)writeApplicationDataWithObject:(id<NSCoding>)object  writeFilePath:(NSString *)filePath;
+(id)readApplicationObjectWithFilePath:(NSString *)filePath;
@end
