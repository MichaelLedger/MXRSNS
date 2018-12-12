//
//  MXRCommonResourceManager.m
//  huashida_home
//
//  Created by 周建顺 on 2017/1/20.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRLocalResourceManager.h"
#import "BookInfoForShelf.h"
#import "NSString+Ex.h"
//#import "MXRFilesDownload.h"
#import "MXRConstant.h"
//#import "BookShelfManger.h"
#import "NSString+Ex.h"
//#import "MXRNormalResourceModel.h"
//#import "MXRResStoreResourceModel.h"
//#import "MXRDownloadFilesResponseModel.h"
//#import "MXRDownloadListRecordModel.h"
//#import "MXRDownloadFilesRequestModel.h"
//#import "MXRDownloadNetworkManager.h"

//#import "MXRDownloadFileModel.h"



@implementation MXRLocalResourceManager



/**
 普通资源：删除数据库中普通资源的记录
 
 @param bookGUID 图书
 */
//+(void)deleteResourceWithBookGUID:(NSString*)bookGUID{
//    if (!bookGUID) {
//        return;
//    }
//    NSArray *array = [MXRResStoreResourceModel searchWithWhere:@{@"bookGUID":bookGUID}];
//
//    // 删除图书相关联的普通资源
//    [MXRNormalResourceModel deleteWithWhere:@{@"bookGUID":bookGUID}];
//    [MXRResStoreResourceModel deleteWithWhere:@{@"bookGUID":bookGUID}];
//
//    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        MXRResStoreResourceModel *model = obj;
//        [self safeDeleteFileWithResourceModel:model];
//    }];
//
//    // 删除下载记录
//    [MXRDownloadListRecordModel deleteWithWhere:@{@"bookGUID":bookGUID}];
//
//}



/**
 判断文件是否已下载
 
 @param down <#down description#>
 @param bookinfo <#bookinfo description#>
 @return <#return value description#>
 */
//+(BOOL)checkFileIsDownloadedWithResourceModel:(MXRBaseResourceModel *)resourceModel{
//
//    if (resourceModel.isDownloed) {
//        NSString *filePath = [self getFilePathWithResourceModel:resourceModel];
//
//        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//            return YES;
//        }
//        // 没找到，重新设置为未下载
//        resourceModel.downloaded = NO;
//        [resourceModel updateToDB];
//    }else{
//        NSString *filePath = [self getFilePathWithResourceModel:resourceModel];
//        // 为了兼容包版本5.4.0，后续版本可以删除
//        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//            resourceModel.downloaded = YES;
//            [resourceModel updateToDB];
//            return YES;
//        }
//    }
//    return NO;
//}



/**
 标记为完成
 
 @param fileDownloadString <#fileDownloadString description#>
 */
//+(void)setFileDownloadComplete:(NSString*)fileDownloadString normalResources:(NSArray*)normalFiles resStoreResources:(NSArray*)resStoreFiles;{
//
//    NSString *fileName = [self fileDownload_pathWithoutRandomSuffix:fileDownloadString];
//
//    __block BOOL isResStore = NO;
//    [resStoreFiles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        MXRResStoreResourceModel *model = obj;
//
//        if ([model.fileName isEqualToString:fileName]) {
//            model.downloaded = YES;
//            [model updateToDB];
//            isResStore = YES;
//            *stop = YES;
//        }
//    }];
//
//    if (!isResStore) {
//        [normalFiles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            MXRNormalResourceModel *model = obj;
//
//            if ([model.fileName isEqualToString:fileName]) {
//                model.downloaded = YES;
//                [model updateToDB];
//                *stop = YES;
//            }
//        }];
//    }
//
//
//
//}




//+(FileInfo*)createFileInfoWithBookInfo:(BookInfoForShelf*)book resourceModel:(MXRBaseResourceModel *)resourceModel{
//    NSString *url = resourceModel.fileName;
//    if ([url length]>0) {
//
//        FileInfo * fi = [[FileInfo alloc] init];
//
//        fi.isReWrite = NO;
//        fi.downloadState = MXRFileInfoDownloadStateUndownload;
//        fi.fileMD5 = resourceModel.fileMD5;
//        fi.allBytesSize = [resourceModel.fileSize longLongValue];
//
//        fi.urlStr = [self getFileDownloadUrlWithBookInfo:book resourceModel:resourceModel];
//        fi.fileStorePath = [self getFileDownloadDestinationPathWithResourceModel:resourceModel];
//        fi.fileName = resourceModel.fileName;
//
//
//
//        unsigned long long fileSize = 0;
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        // 判断之前是否下载过 如果有下载重新构造Header
//        if ([fileManager fileExistsAtPath:fi.fileStorePath]) {
//            NSError *error = nil;
//            fileSize = [fileManager attributesOfItemAtPath:fi.fileStorePath
//                                                     error:&error].fileSize;
//
//            if (!error) {
//                fi.alreadyBytesSize = fileSize;
//            }
//
//        }else if([fileManager fileExistsAtPath:fi.fileTempStorePath]){
//
//            NSError *error = nil;
//            fileSize = [fileManager attributesOfItemAtPath:fi.fileTempStorePath
//                                                     error:&error].fileSize;
//
//            if (!error) {
//                fi.alreadyBytesSize = fileSize;
//            }
//        }
//
//        resourceModel.downloaded = NO;
//        [resourceModel updateToDB];
//
//        return fi;
//    }
//
//    return nil;
//}


/**
 删除下载的资源文件
 
 @param resourceModel <#resourceModel description#>
 @return <#return value description#>
 */
//+(BOOL)deleteFileWithResourceModel:(MXRBaseResourceModel *)resourceModel{
//    NSString *path = [self getFilePathWithResourceModel:resourceModel];
//    NSError *error;
//    BOOL isSuccess = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
//    DLOG(@"******\n删除文件%@, \n文件：%@，\n本地路径：%@ \n******\n", isSuccess?@"成功":([NSString stringWithFormat:@"失败:%@",error.localizedDescription]), resourceModel, path);
//
//    return isSuccess;
//}

/**
 删除下载的资源文件,资源库资源如果还有图书引用则不删除
 
 @param resourceModel <#resourceModel description#>
 @return <#return value description#>
 */
//+(BOOL)safeDeleteFileWithResourceModel:(MXRBaseResourceModel *)resourceModel{
//    
//    if ([resourceModel isKindOfClass:[MXRResStoreResourceModel class]]) {
//        NSInteger count = [MXRBaseResourceModel rowCountWithWhere:@"fileName = %@", resourceModel.fileName];
//        
//        if (count>0) {
//            // 还有文件在使用，不需要删除
//            return YES;
//        }else{
//            // 没有文件使用删除
//            return [self deleteFileWithResourceModel:resourceModel];
//        }
//        
//    }else{
//        return [self deleteFileWithResourceModel:resourceModel];
//    }
//    
//}


#pragma mark - 私有方法


//+(NSString*)getFileDownloadUrlWithBookInfo:(BookInfoForShelf*)bookInfo resourceModel:(MXRBaseResourceModel *)resourceModel{
//
//    if (bookInfo) {
//        return  [NSString encodeUrlString:[NSString stringWithFormat:@"%@?%@",resourceModel.fileName,[MXRConstant mxrReplaceStr:bookInfo.creatTime]]];
//    }else{
//        return resourceModel.fileName;
//    }
//
//}

/*
 * 获取下载资源解压后的文件夹路径，如果不是文件夹直接返回文件
 */
//+(NSString*)getFilePathWithResourceModel:(MXRBaseResourceModel *)resourceModel{
//    if ([[[resourceModel.fileName pathExtension] uppercaseString] isEqualToString:@"ZIP"]) {
//        return [[self getFileDownloadDestinationPathWithResourceModel:resourceModel] stringByDeletingPathExtension];
//    }
//    return [self getFileDownloadDestinationPathWithResourceModel:resourceModel];
//}


/*
 * 普通资源下载到的本地路径,zip包或者文件
 */
//+(NSString*)getFileDownloadDestinationPathWithResourceModel:(MXRBaseResourceModel *)resourceModel{
//
//    return [resourceModel downloadDestPath];
//}


+(NSString*)urlStrDeleteHttpOrHttps:(NSString*)intputUrl{
    if ([intputUrl rangeOfString:@"http://"].location != NSNotFound) {
        return [[intputUrl componentsSeparatedByString:@"http://"] lastObject];
    }else if ([intputUrl rangeOfString:@"https://"].location != NSNotFound) {
        return [[intputUrl componentsSeparatedByString:@"https://"] lastObject];
    }else if ([intputUrl rangeOfString:@"http:/"].location != NSNotFound) {
        return [[intputUrl componentsSeparatedByString:@"http:/"] lastObject];
    }else if ([intputUrl rangeOfString:@"https:/"].location != NSNotFound) {
        return [[intputUrl componentsSeparatedByString:@"https:/"] lastObject];
    }
    return [intputUrl copy];
}



@end


@implementation MXRLocalResourceManager(DownloadList)




/**
 获取图书普通资源

 @param bookGUID
 @return 图书普通资源
 */
//+ (NSArray *)bookNormalResourcesWithBookGUID:(NSString*)bookGUID{
//    NSArray *normalFiles = [MXRNormalResourceModel searchWithWhere:@{@"bookGUID":bookGUID}];
//    return normalFiles;
//
//}



/**
 获取图书资源商店资源

 @param bookGUID
 @return 图书资源商店资源
 */
//+ (NSArray*)bookResStoreResourcesWithBookGUID:(NSString*)bookGUID{
//    NSArray *resStoreFiles = [MXRResStoreResourceModel searchWithWhere:@{@"bookGUID":bookGUID}];
//    return resStoreFiles;
//}

/**
 获取预览页资源
 
 @param bookGUID
 @return 预览页资源
 */
//+ (NSArray*)getPreListWithBookGUID:(NSString*)bookGUID{
//    if (!bookGUID) {
//        return nil;
//    }
//
//    MXRDownloadListRecordModel *model = [[MXRDownloadListRecordModel searchWithWhere:@{@"bookGUID":bookGUID}] lastObject];
//    if (model&&model.preViewPages) {
//        NSArray *normalArray = [MXRNormalResourceModel searchWithWhere:@{@"bookGUID":bookGUID,@"sortIndex":model.preViewPages}];
//        NSArray *resStoreArray = [MXRResStoreResourceModel searchWithWhere:@{@"bookGUID":bookGUID,@"sortIndex":model.preViewPages}];
//        NSMutableArray *array = [NSMutableArray arrayWithArray:normalArray];
//        [array addObjectsFromArray:resStoreArray];
//        [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            MXRBaseResourceModel *model1 = obj1;
//            MXRBaseResourceModel *model2 = obj2;
//
//            if (model1.sortIndex > model2.sortIndex) {
//                return NSOrderedDescending;
//
//            }else if(model1.sortIndex < model2.sortIndex){
//
//                return NSOrderedAscending;
//
//            }else{
//                return NSOrderedSame;
//
//            }
//        }];
//        return array;
//    }
//
//    return nil;
//}


/**
 获取图书下载资源的请求记录

 @param bookGUID
 @return 图书下载资源的请求记录
 */
//+(MXRDownloadListRecordModel*)bookDownloadListRecordWithBookGUID:(NSString*)bookGUID{
//
//    MXRDownloadListRecordModel *record = [[MXRDownloadListRecordModel searchWithWhere:@{@"bookGUID":bookGUID}] lastObject];
//    return record;
//}


/**
 
 获取图书中资源商店资源的数量
 @param bookGUID
 @return 图书中资源商店资源的数量
 */
//+(NSInteger)resStoreResourceCountWithBookGUID:(NSString*)bookGUID{
//    NSUInteger countResStore = [MXRResStoreResourceModel rowCountWithWhere:@{@"bookGUID":bookGUID}];
//    return countResStore;
//}


/**
 获取图书中普通资源的数量

 @param bookGUID
 @return 图书中普通资源的数量
 */
//+(NSInteger)normalResourceCountWithBookGUID:(NSString*)bookGUID{
//    NSUInteger countNor = [MXRNormalResourceModel rowCountWithWhere:@{@"bookGUID":bookGUID}];
//    return countNor;
//}




/**
 去除url后面的随机后缀

 @param originalStr <#originalStr description#>
 @return <#return value description#>
 */
+(NSString *) fileDownload_pathWithoutRandomSuffix:(NSString *) originalStr
{
    NSRange range = [originalStr rangeOfString:@"?"];
    if( range.location == NSNotFound )
    {
        return originalStr;
    }
    
    NSRange subStrRange = NSMakeRange(0, range.location);
    return [originalStr substringWithRange:subStrRange];
}

#pragma mark --

/**
 检测是否需要更新下载列表
 
 @param book <#book description#>
 @return <#return value description#>
 */
//+(BOOL)checkIsNeedUpdateDownloadList:(BookInfoForShelf*)book{
//
//    MXRDownloadListRecordModel *record = [MXRLocalResourceManager bookDownloadListRecordWithBookGUID:book.bookGUID];
//    if (record) {
//        if ( [record.updateTime isEqualToString:book.creatTime]) {
//            NSUInteger countResStore = [MXRLocalResourceManager resStoreResourceCountWithBookGUID:book.bookGUID];
//            NSUInteger countNor = [MXRLocalResourceManager normalResourceCountWithBookGUID:book.bookGUID];
//
//            if (countNor>0||countResStore>0) {
//                return NO;
//            }
//
//        }
//    }
//
//    return YES;
//}


/**
 判读是否请求过下载列表

 @param book <#book description#>
 @return YES表示请求过下载列表
 */
+(BOOL)checkHasDownloadList:(BookInfoForShelf*)book{
    MXRDownloadListRecordModel *record = [MXRLocalResourceManager bookDownloadListRecordWithBookGUID:book.bookGUID];
    if (record) {
        NSUInteger countResStore = [MXRLocalResourceManager resStoreResourceCountWithBookGUID:book.bookGUID];
        NSUInteger countNor = [MXRLocalResourceManager normalResourceCountWithBookGUID:book.bookGUID];
        
        if (countNor>0||countResStore>0) {
            return YES;
        }
        return NO;
    }
    
    return NO;
}






#pragma mark --- 请求下载列表

/**
 获取下载列表
 1.获取数据
 2.保存获取记录到数据库
 3.将下载列表写入数据库
 4.如果是更新，则dif返回需要更新的文件
 */
//+(NSURLSessionDataTask *)requestDownloadListWithBookInfo:(BookInfoForShelf*)book  success:(void(^)(NSArray *normalArray, NSArray *reStoreList))success failure:(void(^)(NSString* errorMsg))failure{
//
//    MXRDownloadFilesRequestModel *reuqestModel = [MXRDownloadFilesRequestModel new];
//    reuqestModel.guid = book.bookGUID;
//
//    NSURLSessionDataTask *task = [[MXRDownloadNetworkManager sharedInstance] requestDownloadFilesWithModel:reuqestModel success:^(id result) {
//
//        if ([result isKindOfClass:[MXRDownloadFilesResponseModel class]]) {
//
//            // 保存下载记录
//            MXRDownloadFilesResponseModel *model = result;
//            [MXRLocalResourceManager updateDownloadListRecord:model bookGUID:book.bookGUID updateTime:book.creatTime];
//
//            NSDictionary *dict =  [self handelFileList:model.fileList book:book];
//
//            if (success) {
//                success([dict valueForKey:@"normal"], [dict valueForKey:@"resStore"]);
//            }
//        }else{
//            if (failure) {
//                failure(nil);
//            }
//        }
//
//    } failure:^(MXRServerStatus status, id result) {
//        if (failure) {
//            failure(nil);
//        }
//    }];
//
//    return task;
//}


//+(NSURLSessionDataTask *)requestAuditBookDownloadListWithBookInfo:(BookInfoForShelf*)book  success:(void(^)(NSArray *normalArray, NSArray *reStoreList))success failure:(void(^)(NSString* errorMsg))failure{
//
//    MXRDownloadFilesRequestModel *reuqestModel = [MXRDownloadFilesRequestModel new];
//    reuqestModel.guid = book.bookGUID;
//
//    NSURLSessionDataTask *task = [[MXRDownloadNetworkManager sharedInstance] requestAuditDownloadInfoWithModel:reuqestModel success:^(id result) {
//
//        if ([result isKindOfClass:[MXRAuditDownloadInfoModel class]]) {
//
//            // 保存下载记录
//            MXRAuditDownloadInfoModel *model = result;
//            [MXRLocalResourceManager updateDownloadListRecord:model.bookModel bookGUID:model.bookGuid updateTime:model.createDate];
//
//            NSDictionary *dict =  [self handelFileList:model.bookModel.fileList book:book];
//
//            if (success) {
//                success([dict valueForKey:@"normal"], [dict valueForKey:@"resStore"]);
//            }
//        }else{
//            if (failure) {
//                failure(nil);
//            }
//        }
//
//    } failure:^(MXRServerStatus status, id result) {
//        if (failure) {
//            failure(nil);
//        }
//    }];
//
//    return task;
//}
//
//+(NSURLSessionDataTask *)requestDiyReviewBookDownloadListWithBookInfo:(BookInfoForShelf*)book  success:(void(^)(NSArray *normalArray, NSArray *reStoreList))success failure:(void(^)(NSString* errorMsg))failure{
//
//    MXRDownloadFilesRequestModel *reuqestModel = [MXRDownloadFilesRequestModel new];
//    reuqestModel.guid = book.bookGUID;
//
//    NSURLSessionDataTask *task = [[MXRDownloadNetworkManager sharedInstance] requestDiyReviewDownloadInfoWithModel:reuqestModel success:^(id result) {
//
//        if ([result isKindOfClass:[MXRAuditDownloadInfoModel class]]) {
//
//            // 保存下载记录
//            MXRAuditDownloadInfoModel *model = result;
//            [MXRLocalResourceManager updateDownloadListRecord:model.bookModel bookGUID:model.bookGuid updateTime:model.createDate];
//
//            NSDictionary *dict =  [self handelFileList:model.bookModel.fileList book:book];
//
//            if (success) {
//                success([dict valueForKey:@"normal"], [dict valueForKey:@"resStore"]);
//            }
//        }else{
//            if (failure) {
//                failure(nil);
//            }
//        }
//
//    } failure:^(MXRServerStatus status, id result) {
//        if (failure) {
//            failure(nil);
//        }
//    }];
//
//    return task;
//}



/**
 获取需要更新/下载的正常/商店资源字典

 @param fileList 资源文件数组
 @param book 书架图书信息
 @return 正常/商店资源字典
 */
//+(NSDictionary*)handelFileList:(NSArray*)fileList book:(BookInfoForShelf*)book{
//
//    // 更新filelist在内存中的缓存
//    BookInfoForShelf *localBook =  [BookShelfManger getBookWithId:book.bookGUID];
//    [localBook needUpdateResourceList];
//    [book needUpdateResourceList];
//
//    if (book.isNeedUpdate) {
//        // 处理更新
//        return [self diffFileList:fileList book:book];
//    }else{
//        // 处理下载
//        NSMutableArray *resStoreFiles = [NSMutableArray new];
//        NSMutableArray *normalFiles = [NSMutableArray new];
//        [fileList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            MXRDownloadFileModel *fileModel = obj;
//            MXRBaseResourceModel *resModel;
//            if (fileModel.fileType == MXRDownloadFileTypeResStore) {
//                resModel = [[MXRResStoreResourceModel alloc] initWithFileModel:fileModel bookGUID:book.bookGUID];
//                [resStoreFiles addObject:resModel];
//            }else{
//                resModel = [[MXRNormalResourceModel alloc] initWithFileModel:fileModel bookGUID:book.bookGUID];
//                [normalFiles addObject:resModel];
//            }
//
//            // 保存到数据库
//            [resModel updateToDB];
//
//        }];
//
//
//        NSMutableDictionary *dict = [NSMutableDictionary new];
//
//        if (normalFiles&&normalFiles.count>0) {
//            [dict setValue:normalFiles forKey:@"normal"];
//        }
//
//        if (resStoreFiles&&resStoreFiles.count>0) {
//            [dict setValue:resStoreFiles forKey:@"resStore"];
//        }
//
//        return [dict copy];
//
//    }
//}


#pragma mark -- 更新

//+(NSDictionary*)diffFileList:(NSArray*)fileList book:(BookInfoForShelf*)book{
//    // 新文件
//    NSMutableArray *resStoreFiles = [NSMutableArray new];
//    NSMutableArray *normalFiles = [NSMutableArray new];
//    [fileList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        MXRDownloadFileModel *fileModel = obj;
//        MXRBaseResourceModel *resModel;
//        if (fileModel.fileType == MXRDownloadFileTypeResStore) {
//            resModel = [[MXRResStoreResourceModel alloc] initWithFileModel:fileModel bookGUID:book.bookGUID];
//            [resStoreFiles addObject:resModel];
//        }else{
//            resModel = [[MXRNormalResourceModel alloc] initWithFileModel:fileModel bookGUID:book.bookGUID];
//            [normalFiles addObject:resModel];
//        }
//
//    }];
//
//    // 旧的文件
//    NSArray *resStoreFilesOld = [MXRResStoreResourceModel searchWithWhere:@{@"bookGUID":book.bookGUID}];
//    NSArray *normalFilesOld = [MXRNormalResourceModel searchWithWhere:@{@"bookGUID":book.bookGUID}];
//
//
//    // diff
//    NSArray *needDownloadNormalFiles = [self diffNormalResourceWithNewList:normalFiles oldList:normalFilesOld];
//    NSArray *needDownloadResStoreFiles = [self diffResStoreResourceWithNewList:resStoreFiles oldList:resStoreFilesOld];
//
//    NSMutableDictionary *dict = [NSMutableDictionary new];
//
//    if (needDownloadNormalFiles&&needDownloadNormalFiles.count>0) {
//        [dict setValue:needDownloadNormalFiles forKey:@"normal"];
//    }
//
//    if (needDownloadResStoreFiles&&needDownloadResStoreFiles.count>0) {
//        [dict setValue:needDownloadResStoreFiles forKey:@"resStore"];
//    }
//
//    return [dict copy];
//
//}

/**
 获取需要更新的文件，删除本地不使用的文件
 */
//+(NSArray*)diffNormalResourceWithNewList:(NSArray*)new oldList:(NSArray*)old{
//
//    NSMutableArray *needUpdateList = [NSMutableArray new];
//
//    // 建立索引
//    NSMutableDictionary *oldDict = [NSMutableDictionary new];
//    for (MXRBaseResourceModel *resModel in old) {
//        [oldDict setObject:resModel forKey:resModel.fileName];
//    }
//
//    // 检测需要更新的文件
//    NSMutableArray *sameModelsInOld = [NSMutableArray new]; // 交集
//
//    [new enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        MXRBaseResourceModel *newResModel = obj;
//        MXRBaseResourceModel *oldResModel = [oldDict objectForKey:newResModel.fileName];
//        if (oldResModel) {
//            // 存在旧文件，检测是否需要更新
//            if ([newResModel.fileMD5 isEqualToString:oldResModel.fileMD5]) {
//                // md5一样文件不需要更新，
//
//            }else{
//                // 需要更新
//
//                [needUpdateList addObject:newResModel];
//
//
//                // 1.删除本地旧文件,不需要检测关联情况，所有图书共用一个资源，直接删除后，重新下载更新
//                [MXRLocalResourceManager deleteFileWithResourceModel:oldResModel];
//                // 2.更新数据库
//                [newResModel updateToDB];
//            }
//
//            [sameModelsInOld addObject:oldResModel];
//
//
//        }else{
//            // 新的文件直接加入加载列表
//
//            [needUpdateList addObject:newResModel];
//            [newResModel updateToDB];
//        }
//
//    }];
//
//
//    // 删除旧的文件
//    NSMutableArray *needDeleteOldFiles = [NSMutableArray arrayWithArray:old];
//    [needDeleteOldFiles removeObjectsInArray:sameModelsInOld];
//    [needDeleteOldFiles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        MXRBaseResourceModel *oldResModel = obj;
//        [oldResModel deleteToDB];
//
//        // 1.删除本地旧文件
//        // 因为当前图书已经不使用该资源，所以需要检测是否还有其他图书引用，如果没有则删除资源
//        [MXRLocalResourceManager safeDeleteFileWithResourceModel:oldResModel];
//    }];
//
//
//    return [needUpdateList copy];
//}
//
//
//+(NSArray*)diffResStoreResourceWithNewList:(NSArray*)new oldList:(NSArray*)old{
//
//
//    return [self diffNormalResourceWithNewList:new oldList:old];
//}
//
//
//
//#pragma mark -
//
//
//
///**
// 保存文件列表请求记录
//
// @param model <#model description#>
// @param bookGUID <#bookGUID description#>
// @param updateTime <#updateTime description#>
// */
//+ (void)updateDownloadListRecord:(MXRDownloadFilesResponseModel *)model bookGUID:(NSString*)bookGUID updateTime:(NSString*)updateTime{
//    // 保存下载记录
//    MXRDownloadListRecordModel *record = [[MXRDownloadListRecordModel alloc] initWithBookGUID:bookGUID updateTime:updateTime];
//    record.preViewPages = model.preViewPages;
//    [record updateToDB];
//
//}
//
//
//
//#pragma mark - edirPreview downloadList
//
//
///**
//  处理编辑器预览图书下载信息
//
// @param book 图书
// @param downloadList 下载列表
// */
//+ (void)hanldeEdirPreviewBook:(BookInfoForShelf*)book downloadList:(NSArray*)downloadList{
//
//    // 不需要预览列表
//    [MXRLocalResourceManager updateDownloadListRecord:nil bookGUID:book.bookGUID updateTime:book.creatTime];
//
//    [self handelFileList:downloadList book:book];
//}
//
//
///**
// 处理审核图书下载信息
//
// @param book <#book description#>
// @param downloadFilesInfo <#downloadFilesInfo description#>
// */
//+ (void)hanldeAuditBook:(BookInfoForShelf*)book downloadFilesInfo:(MXRDownloadFilesResponseModel*)downloadFilesInfo{
//    // 需要预览列表
//    [MXRLocalResourceManager updateDownloadListRecord:downloadFilesInfo bookGUID:book.bookGUID updateTime:book.creatTime];
//    [self handelFileList:downloadFilesInfo.fileList book:book];
//}


@end


@implementation MXRLocalResourceManager(Preview)

+ (NSMutableArray *)getPreviewMarkImagesWithBookGUID:(NSString*)bookGUID
{
    
    NSString * direString= [NSString stringWithFormat:@"%@/%@/preview/UserPicture", Caches_Directory, bookGUID];
    NSMutableArray *pathArray = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:direString error:nil];
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        NSString *fullPath = [direString stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                // ignore .DS_Store
                if (![[fileName substringToIndex:1] isEqualToString:@"."]) {
                    [pathArray addObject:fullPath];
                }
            }
        }
    }
    
    return pathArray;
}

//+(FileInfo*)createPreviewFileInfoWithBookInfo:(BookInfoForShelf*)book resourceModel:(MXRBaseResourceModel *)resourceModel{
//    NSString *url = resourceModel.fileName;
//    if ([url length]>0) {
//
//        FileInfo * fi = [[FileInfo alloc] init];
//
//        fi.isReWrite = NO;
//        fi.downloadState = MXRFileInfoDownloadStateUndownload;
//        fi.fileMD5 = resourceModel.fileMD5;
//        fi.allBytesSize = [resourceModel.fileSize longLongValue];
//
//        fi.urlStr = [self getFileDownloadUrlWithBookInfo:book resourceModel:resourceModel];
//        fi.fileStorePath = resourceModel.downloadPreviewDestPath;
//        fi.fileName = resourceModel.fileName;
//
//
//
//        unsigned long long fileSize = 0;
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        // 判断之前是否下载过 如果有下载重新构造Header
//        if ([fileManager fileExistsAtPath:fi.fileStorePath]) {
//            NSError *error = nil;
//            fileSize = [fileManager attributesOfItemAtPath:fi.fileStorePath
//                                                     error:&error].fileSize;
//
//            if (!error) {
//                fi.alreadyBytesSize = fileSize;
//            }
//
//        }else if([fileManager fileExistsAtPath:fi.fileTempStorePath]){
//
//            NSError *error = nil;
//            fileSize = [fileManager attributesOfItemAtPath:fi.fileTempStorePath
//                                                     error:&error].fileSize;
//
//            if (!error) {
//                fi.alreadyBytesSize = fileSize;
//            }
//        }
//
////        resourceModel.downloaded = NO;
////        [resourceModel updateToDB];
//
//        return fi;
//    }
//
//    return nil;
//}

/*
 * 处理filelist中文件名为绝对路径的问题
 */
+(NSString*)getPathWithFilePath:(NSString*)filePath bookGUID:(NSString*)bookGUID{
    NSArray *strs = [filePath componentsSeparatedByString:bookGUID];
    if (strs.count>1) {
        return  [strs lastObject];
    }
    
    return filePath;
}

@end


@implementation MXRLocalResourceManager(QRResourcePreview)

//+(FileInfo*)qrResourcePreview_createPreviewFileInfoWithResourceModel:(MXRBaseResourceModel *)resourceModel{
//    NSString *url = resourceModel.fileName;
//    if ([url length]>0) {
//
//        FileInfo * fi = [[FileInfo alloc] init];
//
//        fi.isReWrite = NO;
//        fi.downloadState = MXRFileInfoDownloadStateUndownload;
//        fi.fileMD5 = resourceModel.fileMD5;
//        fi.allBytesSize = [resourceModel.fileSize longLongValue];
//
//        fi.urlStr = [self getFileDownloadUrlWithBookInfo:nil resourceModel:resourceModel];
//        fi.fileStorePath = [self qrResourcePreview_downloadQRPreviewDestPath:resourceModel];
//        fi.fileName = resourceModel.fileName;
//
//
//
//        unsigned long long fileSize = 0;
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        // 判断之前是否下载过 如果有下载重新构造Header
//        if ([fileManager fileExistsAtPath:fi.fileStorePath]) {
//            NSError *error = nil;
//            fileSize = [fileManager attributesOfItemAtPath:fi.fileStorePath
//                                                     error:&error].fileSize;
//
//            if (!error) {
//                fi.alreadyBytesSize = fileSize;
//            }
//
//        }else if([fileManager fileExistsAtPath:fi.fileTempStorePath]){
//
//            NSError *error = nil;
//            fileSize = [fileManager attributesOfItemAtPath:fi.fileTempStorePath
//                                                     error:&error].fileSize;
//
//            if (!error) {
//                fi.alreadyBytesSize = fileSize;
//            }
//        }
//
//        //        resourceModel.downloaded = NO;
//        //        [resourceModel updateToDB];
//
//        return fi;
//    }
//
//    return nil;
//}

//+(NSString*)qrResourcePreview_downloadQRPreviewDestPath:(MXRBaseResourceModel *)resourceModel{
//    return  [resourceModel downloadQRPreviewDestPath];
//}
//
//+(NSString*)qrResourcePreview_getFilePathWithResourceModel:(MXRBaseResourceModel *)resourceModel{
//    NSString *downloadPath =  [resourceModel downloadQRPreviewDestPath];
//
//    if ([[[resourceModel.fileName pathExtension] uppercaseString] isEqualToString:@"ZIP"]) {
//        return [downloadPath stringByDeletingPathExtension];
//    }
//    return downloadPath;
//}

+(BOOL)qrResourcePreview_CheckIsDownloadedWithResource:(MXRBaseResourceModel *)resourceModel{
    NSString *path = [self qrResourcePreview_getFilePathWithResourceModel:resourceModel];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDownloaded = [fileManager fileExistsAtPath:path];
    return isDownloaded;
}

@end


