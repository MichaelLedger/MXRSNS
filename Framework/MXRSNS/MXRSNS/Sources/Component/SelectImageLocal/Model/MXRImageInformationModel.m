//
//  MXRImageInformationModel.m
//  xuanquTupian
//
//  Created by yuchen.li on 16/8/25.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import "MXRImageInformationModel.h"
#import <Photos/Photos.h>
@implementation MXRImageInformationModel

-(instancetype)initWithImage:(UIImage*)image WithAsset:(PHAsset*)asset WithIsLastSelectImage:(BOOL)isLastSelectImage withIsAddCamera:(BOOL)isAddCamera{
    
    if (self = [super init]) {
        _dic = [NSMutableDictionary new];
        [_dic setObject:asset.localIdentifier forKey:@"IDID"];
        [_dic setObject:@"0" forKey:@"flga"];
        _asset = asset;
        _isLastSelectImage = isLastSelectImage;
        _isAddCamera = isAddCamera;
    }
    return self;
}

-(instancetype)initWithImage:(UIImage*)image WithGroup:(ALAssetsGroup*)group WithIsSelectViewShow:(BOOL)isSelectViewShow IsShowIamge:(BOOL)isShowImage{
    if (self = [super init]) {
        _dic = [NSMutableDictionary new];
        [_dic setObject:image forKey:@"img"];
        [_dic setObject:@"0" forKey:@"flga"];
        _group = group;
        _isLastSelectImage = isSelectViewShow;
        _isAddCamera = isShowImage;
    }
    return self;

}

- (instancetype)initWithVideoPath:(NSURL *)videoUrl asset:(PHAsset *)asset isSelectLastVideo:(BOOL)isLastSelectVideo isAddCamera:(BOOL)isAddCamera
{
    if (self = [super init]) {
        _videoURL = videoUrl;
        _asset    = asset;
        [_dic setObject:@"0" forKey:@"flga"];
        _isLastSelectImage = isLastSelectVideo;
        _isAddCamera       = isAddCamera;
    }
    return self;
}
-(void)setAssetImageWith:(UIImage *)assetImage
{
    _assetImage = assetImage;
}

-(void)setVideoURLWith:(NSURL *)videoURL
{
    _videoURL = videoURL;
}

-(void)setVideoDataWith:(NSData*)videoData
{
    _videoData = videoData;
}

- (void)setSelectOrderWith:(NSInteger)selectOrder
{
    _selectOrder = selectOrder;
}

//- (void)setMaxCountWith:(NSInteger)maxCount
//{
//    _maxCount = maxCount;
//}
@end
