//
//  MXRLocalAlbumModel.m
//  xuanquTupian
//
//  Created by yuchen.li on 16/8/25.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import "MXRLocalAlbumModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <objc/message.h>
@implementation MXRLocalAlbumModel
//seven
-(instancetype)initWtihGroup:(ALAssetsGroup*)group{
    if (self=[super init]) {
        _imageTotalCount  = [group numberOfAssets];
        _albumName        = [group valueForProperty:ALAssetsGroupPropertyName];
        CGImageRef imageR = [group posterImage];
        _imageObject      = [UIImage imageWithCGImage:imageR];
        _group            = group;
    }
    return self;
}

//获得缩略图 相簿名 相片数量
-(instancetype)initWithPHAssetCollection:(PHAssetCollection *)collection{
    if (self=[super init]) {
        _albumName = collection.localizedTitle;
        _assetCollection = collection;
        
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        _imageTotalCount = [result countOfAssetsWithMediaType: PHAssetMediaTypeImage];
        _videoTotalCount = [result countOfAssetsWithMediaType: PHAssetMediaTypeVideo];
    
        PHFetchOptions *photosOptions = [[PHFetchOptions alloc] init];
        photosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:collection options:photosOptions];
        _fetchResult = assets;
        if (assets.count > 0) {
            PHAsset*asset = assets[0];
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            // 同步获得图片, 只会返回1张图片
            options.synchronous = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            options.networkAccessAllowed = YES;
            // 是否要原图
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize cellSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/3.0, [UIScreen mainScreen].bounds.size.width/3.0);
            CGSize size = CGSizeMake(cellSize.width * scale, cellSize.height/2.0 * scale);
            // 从asset中获得图片
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (result) {
                    _imageObject=result;
                    
                }
            }];
        }
    }
    return self;

}
-(void)setImageObjectWith:(UIImage *)imageObject{
    _imageObject = imageObject;
}

-(void)setImageTotalCountWith:(NSInteger)imageTotalCount{
    _imageTotalCount = imageTotalCount;
}

-(void)setAlbumNameWith:(NSString *)albumName{
    _albumName = albumName;
}
-(void)setAssetCollectionWith:(PHAssetCollection *)assetCollection{
    _assetCollection = assetCollection;
}
-(void)setFetchResultWith:(PHFetchResult *)fetchResult{
    _fetchResult = fetchResult;
}
-(void)setGroupWith:(ALAssetsGroup *)group{
    _group = group;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    MXRLocalAlbumModel *model = [[[self class]allocWithZone:zone]init];
    [model setImageObjectWith:self.imageObject];
    [model setImageTotalCountWith:self.imageTotalCount];
    [model setAlbumNameWith:self.albumName];
    [model setAssetCollectionWith:self.assetCollection];
    [model setFetchResultWith:self.fetchResult];
    [model setGroupWith:self.group];
    return model;
}
@end
