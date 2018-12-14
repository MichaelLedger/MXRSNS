//
//  MXRCommonResourceManager.h
//  huashida_home
//
//  Created by 周建顺 on 2017/1/20.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BookInfoForShelf;
@class FileInfo;

@class MXRDownloadFilesResponseModel;
@class MXRBaseResourceModel;
@class MXRDownloadListRecordModel;


@interface MXRLocalResourceManager : NSObject

/**
 删除该图书与公共库的关联，删除完成后判断该图书包含的公共库是否被其他图书引用，如果没有则删除对应公共库
 
 @param bookGUID 图书
 */
+(void)deleteResourceWithBookGUID:(NSString*)bookGUID;



/**
 判断文件是否已下载
 
 @param down <#down description#>
 @param bookinfo <#bookinfo description#>
 @return <#return value description#>
 */
+(BOOL)checkFileIsDownloadedWithResourceModel:(MXRBaseResourceModel *)resourceModel;


/**
 标记为完成 更新数据库
 
 @param fileDownloadString <#fileDownloadString description#>
 */
+(void)setFileDownloadComplete:(NSString*)fileDownloadString normalResources:(NSArray*)normalFiles resStoreResources:(NSArray*)resStoreFiles;


/**
 创建下载文件
 
 @param book <#book description#>
 @param resourceModel <#resourceModel description#>
 @return <#return value description#>
 */
+(FileInfo*)createFileInfoWithBookInfo:(BookInfoForShelf*)book resourceModel:(MXRBaseResourceModel *)resourceModel;

/**
 删除下载的资源文件
 
 @param resourceModel <#resourceModel description#>
 @return <#return value description#>
 */
+(BOOL)deleteFileWithResourceModel:(MXRBaseResourceModel *)resourceModel;


/**
 删除下载的资源文件,资源库资源如果还有图书引用则不删除
 
 @param resourceModel <#resourceModel description#>
 @return <#return value description#>
 */
+(BOOL)safeDeleteFileWithResourceModel:(MXRBaseResourceModel *)resourceModel;


@end




/**
 下载资源列表相关
 */
@interface MXRLocalResourceManager(DownloadList)



/**
 获取图书普通资源
 
 @param bookGUID
 @return 图书普通资源
 */
+ (NSArray *)bookNormalResourcesWithBookGUID:(NSString*)bookGUID;


/**
 获取图书资源商店资源
 
 @param bookGUID
 @return 图书资源商店资源
 */
+ (NSArray*)bookResStoreResourcesWithBookGUID:(NSString*)bookGUID;

/**
 获取预览页资源
 
 @param bookGUID
 @return 预览页资源
 */
+ (NSArray*)getPreListWithBookGUID:(NSString*)bookGUID;



/**
 
 获取图书中资源商店资源的数量
 @param bookGUID
 @return 图书中资源商店资源的数量
 */
+(NSInteger)resStoreResourceCountWithBookGUID:(NSString*)bookGUID;

/**
 获取图书中普通资源的数量
 
 @param bookGUID
 @return 图书中普通资源的数量
 */
+(NSInteger)normalResourceCountWithBookGUID:(NSString*)bookGUID;




/**
 去除url后面的随机后缀
 
 @param originalStr <#originalStr description#>
 @return <#return value description#>
 */
+(NSString *) fileDownload_pathWithoutRandomSuffix:(NSString *) originalStr;



/**
 处理编辑器预览图书下载信息
 
 @param book 图书
 @param downloadList 下载列表
 */
+ (void)hanldeEdirPreviewBook:(BookInfoForShelf*)book downloadList:(NSArray*)downloadList;

/**
 处理审核图书下载信息
 
 @param book <#book description#>
 @param downloadFilesInfo <#downloadFilesInfo description#>
 */
+ (void)hanldeAuditBook:(BookInfoForShelf*)book downloadFilesInfo:(MXRDownloadFilesResponseModel*)downloadFilesInfo;

#pragma mark --




#pragma mark --


/**
 检测是否需要更新下载列表
 
 @param book <#book description#>
 @return <#return value description#>
 */
+(BOOL)checkIsNeedUpdateDownloadList:(BookInfoForShelf*)book;

/**
 判读是否请求过下载列表
 
 @param book <#book description#>
 @return YES表示请求过下载列表
 */
+(BOOL)checkHasDownloadList:(BookInfoForShelf*)book;



/**
 请求下载列表
 */
+(NSURLSessionDataTask *)requestDownloadListWithBookInfo:(BookInfoForShelf*)book  success:(void(^)(NSArray *normalArray, NSArray *reStoreList))success failure:(void(^)(NSString* errorMsg))failure;



/**
 请求编辑器一审二审下载列表

 @param book <#book description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionDataTask *)requestAuditBookDownloadListWithBookInfo:(BookInfoForShelf*)book  success:(void(^)(NSArray *normalArray, NSArray *reStoreList))success failure:(void(^)(NSString* errorMsg))failure;


/**
 获取diy审核图书下载列表

 @param book <#book description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
+(NSURLSessionDataTask *)requestDiyReviewBookDownloadListWithBookInfo:(BookInfoForShelf*)book  success:(void(^)(NSArray *normalArray, NSArray *reStoreList))success failure:(void(^)(NSString* errorMsg))failure;


/**
 获取图书下载资源的请求记录
 
 @param bookGUID
 @return 图书下载资源的请求记录
 */
+(MXRDownloadListRecordModel*)bookDownloadListRecordWithBookGUID:(NSString*)bookGUID;

/**
 保存文件列表请求记录
 
 @param model <#model description#>
 @param bookGUID <#bookGUID description#>
 @param updateTime <#updateTime description#>
 */
+(void)updateDownloadListRecord:(MXRDownloadFilesResponseModel *)model bookGUID:(NSString*)bookGUID updateTime:(NSString*)updateTime;



@end



/**
 图书预览
 */
@interface MXRLocalResourceManager(Preview)


/**
 获取说有预览的mark图片

 @param bookGUID <#bookGUID description#>
 @return <#return value description#>
 */
+ (NSMutableArray *)getPreviewMarkImagesWithBookGUID:(NSString*)bookGUID;

//+(FileInfo*)createPreviewFileInfoWithBookInfo:(BookInfoForShelf*)book resourceModel:(MXRBaseResourceModel *)resourceModel;

/*
 * 处理filelist中文件名为绝对路径的问题
 */
+(NSString*)getPathWithFilePath:(NSString*)filePath bookGUID:(NSString*)bookGUID;

@end


/**
 扫二维码预览资源
 */
@interface MXRLocalResourceManager(QRResourcePreview)


/**
 创建下载文件对象

 @param resourceModel <#resourceModel description#>
 @return <#return value description#>
 */
+(FileInfo*)qrResourcePreview_createPreviewFileInfoWithResourceModel:(MXRBaseResourceModel *)resourceModel;


/**
 获取资源文件的路径,文件下载的原始路径

 @param resourceModel <#resourceModel description#>
 @return <#return value description#>
 */
+(NSString*)qrResourcePreview_downloadQRPreviewDestPath:(MXRBaseResourceModel *)resourceModel;


/**
 获取文件路径，如果是zip文件，则是文件加压后的文件夹路径

 @param resourceModel <#resourceModel description#>
 @return <#return value description#>
 */
+(NSString*)qrResourcePreview_getFilePathWithResourceModel:(MXRBaseResourceModel *)resourceModel;

/**
 判断文件是否已经存在，若是压缩包，则判断压缩包解压后的文件夹是否存在

 @param resourceModel <#resourceModel description#>
 @return <#return value description#>
 */
+(BOOL)qrResourcePreview_CheckIsDownloadedWithResource:(MXRBaseResourceModel *)resourceModel;

@end



