//
//  MXRSelectLocalImageProxy.h
//  xuanquTupian
//
//  Created by yuchen.li on 16/8/24.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@class MXRImageInformationModel,MXRLocalAlbumModel;
@interface MXRSelectLocalImageProxy : NSObject
+(instancetype)getInstance;

/**
 * 相册信息
 */
@property (nonatomic, strong, readonly)NSMutableArray <MXRLocalAlbumModel *> *totalAlbumDataArray;
/**
 * 相册中的图片,视频信息
 */
@property (nonatomic, strong, readonly)NSMutableArray <MXRImageInformationModel *>*imageInfoModelArray;
/**
 * 预选的图片,视频 信息
 */
@property (nonatomic, strong, readonly)NSMutableArray<MXRImageInformationModel *> *preSelectImageModelArray;

/**
 * bookSNSSendDetail 记录上次选择的哪个相册（只有梦想圈选择照片时需要记录）
 */
@property (nonatomic, strong,readonly) MXRLocalAlbumModel *bookSNSAlbumModel;

@property (nonatomic, assign, readonly) NSInteger maxCount;                 // 最大选择数
@property (nonatomic, assign, readonly) BOOL isAddCamera;               // 是否添加照相功能

-(void)removeAllImageInfoModelArrayData;
-(void)resetAllAlbumArrayData;
-(void)removeAllPreselectImageInfoModelData;
-(void)addCameraPhotoItem;
-(void)becomeImagestateToUncheck;

- (void)setDataArrayWith:(NSMutableArray<MXRLocalAlbumModel *> *)dataArray;
- (void)setThunMailDataArrayWith:(NSMutableArray<MXRImageInformationModel*>*)thunMailDataArray;
- (void)setPreSelectImageModelArrayWith:(NSMutableArray<MXRImageInformationModel *> *)preSelectImageModelArray;
- (void)setBookSNSAlbumModelWith:(MXRLocalAlbumModel *)bookSNSAlbumModel;
- (void)setMXRMaxCount:(NSInteger)maxCount;
- (void)setMXRIsAddCamera:(BOOL)isAddCamera;

/**
 查询 相对应类型的数据 在 控制器 跳转之前调用
 
 @param mediaType 图片 视频 等
 @param albumModel 相册信息
 @param addPhotoItem YES 添加照相功能, NO 不添加照相功能
 */
- (void)prepareSeletPHAsset:(PHAssetMediaType)mediaType
            localAlbumModel:(MXRLocalAlbumModel *)albumModel
             isAddPhotoItem:(BOOL)addPhotoItem;

/**
 取消选择某张照片 并改变状态

 @param imageInfoModel
 @param imageModelArray 
 */
- (BOOL)unselectImageChangeStatusWithModel:(MXRImageInformationModel *)imageInfoModel;
/**
 选中某张照片 并改变状态

 @param imageInfoModel
 @return 是否成功
 */
- (BOOL)selectImageChangeStatusWithModel:(MXRImageInformationModel *)imageInfoModel;

/**
 对选中的次序重新排序
 */
- (void)rearrangeSelectOrder;


/**
 通过相机拍摄得到的图片  
 1,找到 胶卷相机相册。
 2,获取 胶卷相机中的第一个image和asset，新建一个 MXRImageInformationModel
 3,将 新建的 MXRImageInformationModel 放入preSelectImageModelArray

 @param image 图片
 */
- (void)setupLastSelectAlbumInfoAndAddImageToPreselectImageModelArray:(UIImage *)image;


/**
 通过相机拍摄得到的视频
 1,找到 胶卷相机相册。
 2,获取 胶卷相机中的第一个PHAsset，新建一个 MXRImageInformationModel
 3,将 新建的 MXRImageInformationModel 放入preSelectImageModelArray
 @param url 
 */
- (void)setupLastSelectAlbumInfoAndAddVideoToPreselectImageModelArray:(NSURL *)url ;

/**
 筛选 相册中 照片数量不为 0 的相册
 */
- (void)selectAlbumCountNoneZero;

@end
