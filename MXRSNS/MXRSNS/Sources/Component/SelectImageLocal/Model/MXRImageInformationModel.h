//
//  MXRImageInformationModel.h
//  xuanquTupian
//
//  Created by yuchen.li on 16/8/25.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/PHAssetResource.h>
#import <AssetsLibrary/AssetsLibrary.h>
typedef NS_ENUM (NSInteger,MXRImageInfomationType){
    MXRImageInfomationTypeDefault     = 0,
    MXRImageInfomationTypeShareImage  = 1,
    MXRImageInfomationTypeShareVideo  = 2,
    MXRImageInfomationTypeShareMXQSNS = 3
};

@interface MXRImageInformationModel : NSObject
@property (nonatomic, strong, readonly)NSMutableDictionary *dic;
@property (nonatomic, strong, readonly)PHAsset  *asset;
@property (nonatomic, strong, readonly)ALAssetsGroup *group;
/**
 * 梦想圈  YES 上次选中的图片; NO 不是上次选中的图片 或者 视频
 */
@property (nonatomic, assign, readonly) BOOL isLastSelectImage;
/**
 *  判定是否添加照相功能 YES 添加（私信 梦想圈 ） NO 不添加 (图片分享)
 */
@property (nonatomic, assign, readonly) BOOL isAddCamera;

@property (nonatomic, assign, readonly) NSInteger selectOrder;             // 选择的顺序

@property (nonatomic, strong,readonly)UIImage *assetImage;                  // 在图片展示时为空，在 选择中 时才会有值

@property (nonatomic, strong,readonly)NSURL *videoURL;                      // 视频的URL

@property (nonatomic, strong,readonly)NSData *videoData;                    // 视频的二进制数据

@property (nonatomic, assign, readonly) NSInteger maxCount;                 // 最大的选择数量
-(instancetype)initWithImage:(UIImage *)image
                   WithGroup:(ALAssetsGroup *)group
        WithIsSelectViewShow:(BOOL)isSelectViewShow
                 IsShowIamge:(BOOL)isShowImage;

/**
 单张照片信息

 @param image UIImage   默认的情况下传 nil ,通过 照相机 拍照 选择照片时 传 UIImage
 @param asset PHAsset   包含照片信息的 phasset   不可为nil
 @param isLastSelectImage 梦想圈  1 上次选中的图片; 0 不是上次选中的图片
 @param isAddCamera 是否添加照相功能 YES 添加 NO 不添加  只有第一个model为YES
 @return
 */
-(instancetype)initWithImage:(UIImage *)image
                   WithAsset:(PHAsset *)asset
       WithIsLastSelectImage:(BOOL)isLastSelectImage
             withIsAddCamera:(BOOL)isAddCamera;

/**
 单个视频的信息
 
 @param videoUrl 视频的地址
 @param asset 包含视频信息的PHAsset
 @param isLastSelectVideo 梦想圈  1 上次选中的视频; 0 不是上次选中的视频
 @param isAddCamera 是否添加拍摄视频功能 YES 添加 NO 不添加  只有第一个model为YES
 @return
 */
- (instancetype)initWithVideoPath:(NSURL *)videoUrl
                            asset:(PHAsset *)asset
                isSelectLastVideo:(BOOL)isLastSelectVideo
                      isAddCamera:(BOOL)isAddCamera;

// 属性的set方法 
- (void)setAssetImageWith:(UIImage *)assetImage;
- (void)setVideoURLWith:(NSURL *)videoURL;
- (void)setVideoDataWith:(NSData*)videoData;
- (void)setSelectOrderWith:(NSInteger)selectOrder;
//- (void)setMaxCountWith:(NSInteger)maxCount;
@end
