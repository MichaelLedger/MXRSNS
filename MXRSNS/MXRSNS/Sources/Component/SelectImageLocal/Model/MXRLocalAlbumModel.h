//
//  MXRLocalAlbumModel.h
//  xuanquTupian
//
//  Created by yuchen.li on 16/8/25.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MXRImageInformationModel;
@class PHAssetCollection,PHFetchResult,PHAsset;
@class ALAssetsGroup;
@interface MXRLocalAlbumModel : NSObject <NSMutableCopying>

@property (nonatomic, strong, readonly) UIImage  *imageObject;                                 // 图片封面
@property (nonatomic, strong, readonly) ALAssetsGroup *group;
@property (nonatomic, strong, readonly) NSString *albumName;                                   // 相册名字
@property (nonatomic, strong, readonly) PHAssetCollection *assetCollection;
@property (nonatomic, strong, readonly) PHFetchResult *fetchResult;                            // PHFetchResult<PHAsset *>
@property (nonatomic, assign, readonly) NSInteger imageTotalCount;                             // 图片总数
@property (nonatomic, assign, readonly) NSInteger videoTotalCount;                             // 视频总数

//Seven
-(instancetype)initWtihGroup:(ALAssetsGroup*)group;
-(instancetype)initWithPHAssetCollection:(PHAssetCollection*)collection;

-(void)setImageObjectWith:(UIImage *)imageObject;
-(void)setImageTotalCountWith:(NSInteger)imageTotalCount;
-(void)setAlbumNameWith:(NSString *)albumName;
-(void)setAssetCollectionWith:(PHAssetCollection *)assetCollection;
-(void)setFetchResultWith:(PHFetchResult *)fetchResult;
-(void)setGroupWith:(ALAssetsGroup *)group;



@end

