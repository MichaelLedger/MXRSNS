//
//  MXRGetLocalImageController.h
//  xuanquTupian
//
//  Created by yuchen.li on 16/8/25.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class MXRImageInformationModel,ALAssetsGroup,MXRLocalAlbumModel;

@interface MXRGetLocalImageController : NSObject
+(instancetype)getInstance;
/**
 * 获取所有的相册信息
 */
- (void)getAlbumInformationMediaType:(PHAssetMediaType)mediaType;
/**
 * 获取图片 iOS8.0之前
 */
- (void)getIamgeByGroup:(ALAssetsGroup*)group WithCallBack:(void(^)(BOOL isOkay))callBack;
/**
 * 获取特定大小的图片 iOS 8.0之后
 */
- (void)getImageByModel:(MXRImageInformationModel*)model withCallBack:(void (^)(BOOL isOk))callBack;
/**
 * 大图获取失败之后 ，获取一个比较小的图片
 */
- (void)getThumnailImageByModel:(MXRImageInformationModel *)model
                      callBack:(void (^)(BOOL))callBack;
/**
 * 获取选中的图片的数量
 */
- (NSInteger)getSelectImageCount;
/**
 *  保存图片到某一相册
 */
- (void)saveImageToAlbumWithAlbumName:(NSString *)albumName
                            saveImage:(UIImage *)saveImage
                           completion:(void (^)(BOOL success))completion;
/**
 *  保存图片到 所有照片 相册
 */
-(void)saveImageToAllImageAlbumWithImage:(UIImage*)image CompletionHandler:(void(^)(BOOL isOkay))completionHandler;
/**
 * 根据PHAsset删除相册的图片
 */
-(void)deleteImageFromAlbumWithAsset:(PHAsset*)asset CompletionHandler:(void(^)(BOOL isOkay))completionHandler;

/**
 * 保存视频到某一相册
 */
- (void)saveVideoToAlbumWithAlbumName:(NSString *)albumName videoPath:(NSString *)videoPath completion:(void (^)(BOOL success))completion;


/**
 *  从asset中获取视频路径
 */
-(void)getVideoFromAlbumWithPHAsset:(MXRImageInformationModel*)infoModel completionHandler:(void(^)(BOOL))completionHandler;
/**
 获取 胶卷相机 相册的集合

 @return 所有照片 相册的集合
 */
- (PHAssetCollection *)getAllImageAlbumInformation;



/**
 获取 某个相册集合下 所有的phasset

 @param assetCollection 相册信息中的PHAsset 集合
 @return NSArray    PHFetchResult <PHAsset *>
 */
- (PHFetchResult *)getAllPHAssetFromPHAssetCollection:(PHAssetCollection *)assetCollection;


/*
================================================跳转方法===================================================
 
 */


/**
 
 DIY  私信  等 普通选择图片和信息     图书 和 视频的 跳转 方式 选择类型, 若为 图片  回调的数组 即为 图片数组 , 若选择的是视频 ，返回的则为 视频的NSData数组

 @param mediaType PHAssetMediaType
 @param maxCount 最大的选择数
 @param isAddPhotoItem  Yes 添加相机 NO 不添加相机
 @param completion 跳转完成的回调
 @param selectDoneCompletion 选择完图片的回调
 */
- (void)presentToSelectImageLocalType:(PHAssetMediaType)mediaType
                             maxCount:(NSInteger)maxCount
                       isAddPhotoItem:(BOOL)isAddPhotoItem
                    presentCompletion:(void(^)(BOOL finished))completion
                 selectDoneCompletion:(void (^)(NSMutableArray *imageObjectArray))selectDoneCompletion;

/**
 梦想圈 一类  需要记录上一次选中的图片或者视频      跳转 选图片

 @param mediaType 选择的类型 PHAssetMediaType
 @param maxCount 选择的最大数量
 @param isAddPhotoItem 是否添加相机功能
 @param lastAlbumModel 上次选择的相册信息
 @param lastSelectImageModelArray 上次选择的 图片模型数组
 @param completion   跳转完成的回调
 @param selectDoneCompletion 选择完成的回调
 */
- (void)presentToSelectImageLocalType:(PHAssetMediaType)mediaType
                             maxCount:(NSInteger)maxCount
                       isAddPhotoItem:(BOOL)isAddPhotoItem
                 lastSelectAlbumModel:(MXRLocalAlbumModel *)lastAlbumModel
                 lastSelectModelArray:(NSMutableArray<MXRImageInformationModel *> *)lastSelectImageModelArray  presentCompletion:(void (^)(BOOL))presentCompletion
                 selectDoneCompletion:(void (^)(NSMutableArray *))selectDoneCompletion;


/**
 进入到某一特定相册 一类的跳转方式  不支持 多相册选择 并且没有 选择完成的回调

 @param shareBookGuid
 */
- (void)presentToShareImageWithShareBookGuid:(NSString *)shareBookGuid presnetComletion:(void(^)())presentCompletion;

/**
  进入播放和分享视频页面 V5.12.0 by minjing.lin
 */
- (void)pushPlayAndShareVideoWithShareBookGuid:(NSString *)shareBookGuid;

/*
 ============================================== 工具 ==========================================================
 */

/**
 点击 发送 确定的时候使用 判断 选择的图片和assetModel 数量是否一致

 @return
 */
- (BOOL)checkSelectedPHAssetInfoIsValid;
@end
