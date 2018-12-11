//
//  MXRSelectLocalImageProxy.m
//  xuanquTupian
//
//  Created by yuchen.li on 16/8/24.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import "MXRSelectLocalImageProxy.h"
#import "MXRImageInformationModel.h"
#import "MXRGetLocalImageController.h"
#import <Photos/Photos.h>
#import "MXRLocalAlbumModel.h"
@implementation MXRSelectLocalImageProxy

+(instancetype)getInstance{
    static dispatch_once_t onceToken;
    static MXRSelectLocalImageProxy *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MXRSelectLocalImageProxy alloc]init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _totalAlbumDataArray      = [[NSMutableArray alloc]init];
        _imageInfoModelArray      = [[NSMutableArray alloc]init];
        _preSelectImageModelArray = [[NSMutableArray alloc]init];
        _bookSNSAlbumModel        = [[MXRLocalAlbumModel alloc]init];
    }
    return self;
}

-(void)removeAllImageInfoModelArrayData{
    [_imageInfoModelArray removeAllObjects];
}

-(void)resetAllAlbumArrayData{
    [_totalAlbumDataArray removeAllObjects];
}

-(void)addCameraPhotoItem{
    if (IOS8_OR_LATER) {
        UIImage *image = MXRIMAGE(@"img_selectImage_photo");
        PHAsset *asset = [[PHAsset alloc]init];
        MXRImageInformationModel *model = [[MXRImageInformationModel alloc]initWithImage:image WithAsset: asset WithIsLastSelectImage:NO withIsAddCamera:NO];
        [_imageInfoModelArray insertObject:model atIndex:0];
    }else{
        UIImage *image = MXRIMAGE(@"img_selectImage_photo");
        ALAssetsGroup *group = [[ALAssetsGroup alloc]init];
        MXRImageInformationModel *model = [[MXRImageInformationModel alloc]initWithImage:image WithGroup:group WithIsSelectViewShow:NO IsShowIamge:NO];
        [_imageInfoModelArray insertObject:model atIndex:0];
    }
}
-(void)becomeImagestateToUncheck{
    for (MXRImageInformationModel *model in _imageInfoModelArray) {
        [model.dic setObject:@"0" forKey:@"flga"];
        [model setSelectOrderWith:0];
    }
}

-(void)removeAllPreselectImageInfoModelData{
    [_preSelectImageModelArray removeAllObjects];
}

-(void)setDataArrayWith:(NSMutableArray<MXRLocalAlbumModel *> *)dataArray{
    _totalAlbumDataArray = dataArray;
}

-(void)setThunMailDataArrayWith:(NSMutableArray<MXRImageInformationModel *> *)thunMailDataArray{
    _imageInfoModelArray = thunMailDataArray;
}

-(void)setPreSelectImageModelArrayWith:(NSMutableArray<MXRImageInformationModel *> *)preSelectImageModelArray{
    _preSelectImageModelArray = preSelectImageModelArray;
}

-(void)setBookSNSAlbumModelWith:(MXRLocalAlbumModel *)bookSNSAlbumModel{
    _bookSNSAlbumModel = bookSNSAlbumModel;
}

- (void)setMXRMaxCount:(NSInteger)maxCount
{
    _maxCount = maxCount;
}

- (void)setMXRIsAddCamera:(BOOL)isAddCamera
{
    _isAddCamera = isAddCamera;
}

- (void)prepareSeletPHAsset:(PHAssetMediaType)mediaType localAlbumModel:(MXRLocalAlbumModel *)albumModel isAddPhotoItem:(BOOL)addPhotoItem
{
    [self removeAllImageInfoModelArrayData];
    for (PHAsset *asset in albumModel.fetchResult) {
        if (asset.mediaType == mediaType) {
            MXRImageInformationModel *model = [[MXRImageInformationModel alloc]initWithImage:nil WithAsset:asset WithIsLastSelectImage:YES withIsAddCamera:YES];
            [self.imageInfoModelArray addObject:model];
        }
    }
    if (addPhotoItem) [self addCameraPhotoItem];
    [self setMXRIsAddCamera:addPhotoItem];
}

- (BOOL)unselectImageChangeStatusWithModel:(MXRImageInformationModel *)imageInfoModel {
    if (imageInfoModel.asset.mediaType == PHAssetMediaTypeImage) {
        [self doRemoveImageWithModel:imageInfoModel];
    }else if(imageInfoModel.asset.mediaType == PHAssetMediaTypeVideo) {
        [self doRemoveVideoWithModel:imageInfoModel];
    }else if(imageInfoModel.asset.mediaType == PHAssetMediaTypeUnknown){
        DLOG(@"type Unknown");
    }else{
        DLOG(@"Audio");
    }
    [imageInfoModel.dic setValue:@"0" forKey:@"flga"];
    [self rearrangeSelectOrder];
    return YES;
}

- (BOOL)selectImageChangeStatusWithModel:(MXRImageInformationModel *)imageInfoModel
{
 
    if (imageInfoModel.asset.mediaType == PHAssetMediaTypeImage) {
        [self doSelectImage:imageInfoModel];
    }else if(imageInfoModel.asset.mediaType == PHAssetMediaTypeVideo){
        [ self doSelectVideoWithModel:imageInfoModel callBack:^(BOOL isOkay) {
            
        }];
    }else if(imageInfoModel.asset.mediaType == PHAssetMediaTypeUnknown){
        DLOG(@"TypeUnknow");
    }else{
        DLOG(@"Audio");
    }
    [imageInfoModel.dic setValue:@"1" forKey:@"flga"];
    return YES;
}

/**
 选择图片

 @param imageInfoModel
 */
- (void)doSelectImage:(MXRImageInformationModel *)imageInfoModel{
    [self.preSelectImageModelArray addObject:imageInfoModel];
    [imageInfoModel setSelectOrderWith: self.preSelectImageModelArray.count];
    if (IOS8_OR_LATER) {
        [[MXRGetLocalImageController getInstance]getImageByModel:imageInfoModel withCallBack:^(BOOL isOk) {
            //从iclound云上获取不到高清图，取一个缩略图
            if (!isOk) {
                [[MXRGetLocalImageController getInstance]getThumnailImageByModel:imageInfoModel callBack:^(BOOL isOkay) {
                    
                }];
            }else{
                
            }
        }];
    }else{
        
    }
    
}
    

- (void)doSelectVideoWithModel:(MXRImageInformationModel *)imageInfoModel callBack:(void(^)(BOOL isOkay))callBack{
    
    [[MXRSelectLocalImageProxy getInstance].preSelectImageModelArray addObject:imageInfoModel];
    [[MXRGetLocalImageController getInstance]getImageByModel:imageInfoModel withCallBack:^(BOOL isOk) {
        //获取不到高清图，取一个缩略图
        if (!isOk) {
            [[MXRGetLocalImageController getInstance]getThumnailImageByModel:imageInfoModel callBack:^(BOOL isOkay) {
                if (callBack) {
                    callBack(isOkay);
                }
            }];
            
        }else{
            if (callBack) callBack(isOk);
        }
    }];
    [imageInfoModel setSelectOrderWith: self.preSelectImageModelArray.count];
}
/**
 在 预选数组中 移除model 和 视频
 */
- (void)doRemoveVideoWithModel:(MXRImageInformationModel *)imageInfoModel{
    [imageInfoModel.dic setValue:@"0" forKey:@"flga"];
    [imageInfoModel setSelectOrderWith:0];
    NSInteger i = 0,j = 0;
    for (MXRImageInformationModel *model in self.preSelectImageModelArray) {
        if ([model.asset isEqual:imageInfoModel.asset]) {
            j++;
            break;
        }
        i++;
    }
    // 在 预选数组中删除该图片信息
    if (j > 0) {
        if (self.preSelectImageModelArray.count > i) {
            [self.preSelectImageModelArray removeObjectAtIndex:i];
        }
    }
}
/**
 在 预选数组中 移除model 和 图片
 */
- (void)doRemoveImageWithModel:(MXRImageInformationModel *)imageInfoModel{
    [imageInfoModel.dic setValue:@"0" forKey:@"flga"];
 
    [imageInfoModel setSelectOrderWith:0];
    NSInteger i = 0,j = 0;
    for (MXRImageInformationModel *model in self.preSelectImageModelArray) {
        if ([model.asset isEqual:imageInfoModel.asset]) {
            j++;
            break;
        }
        i++;
    }
    // 在 预选数组中删除该图片信息
    if (j>0) {
        MXRImageInformationModel *model = self.preSelectImageModelArray[i];
        [model setSelectOrderWith:0];
        [self.preSelectImageModelArray removeObject:model];
    }
}
/**
 重新 排序
 */
- (void)rearrangeSelectOrder{
    for (int index = 0; index < [MXRSelectLocalImageProxy getInstance].preSelectImageModelArray.count; index++) {
        MXRImageInformationModel *imageModel = [MXRSelectLocalImageProxy getInstance].preSelectImageModelArray[index];
        [self.imageInfoModelArray enumerateObjectsUsingBlock:^(MXRImageInformationModel *  obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([imageModel.asset.localIdentifier isEqual:obj.asset.localIdentifier]) {
                [obj setSelectOrderWith:index + 1];
                *stop = YES;
            }
        }];
    }
}

- (void)setupLastSelectAlbumInfoAndAddImageToPreselectImageModelArray:(UIImage *)image
{
    PHAssetCollection  *allImageCollection   = [[MXRGetLocalImageController getInstance] getAllImageAlbumInformation];
    MXRLocalAlbumModel *totalImageAlbumModel = [[MXRLocalAlbumModel alloc]initWithPHAssetCollection:allImageCollection];
    //设置 上次选择的相册为 全部照片 相册
    [self setBookSNSAlbumModelWith:totalImageAlbumModel];
    PHAsset *asset = totalImageAlbumModel.fetchResult[0];
    MXRImageInformationModel *model = [[MXRImageInformationModel alloc]initWithImage:image WithAsset:asset WithIsLastSelectImage:NO withIsAddCamera:NO];
    [[MXRSelectLocalImageProxy getInstance]selectImageChangeStatusWithModel:model];

}

- (void)setupLastSelectAlbumInfoAndAddVideoToPreselectImageModelArray:(NSURL *)url
{
    PHAssetCollection  *allImageCollection   = [[MXRGetLocalImageController getInstance] getAllImageAlbumInformation];
    MXRLocalAlbumModel *totalImageAlbumModel = [[MXRLocalAlbumModel alloc]initWithPHAssetCollection:allImageCollection];
    //设置 上次选择的相册为 全部照片 相册
    [[MXRSelectLocalImageProxy getInstance] setBookSNSAlbumModelWith:totalImageAlbumModel];
    PHAsset *asset = totalImageAlbumModel.fetchResult[0];
    MXRImageInformationModel *model = [[MXRImageInformationModel alloc]initWithVideoPath:url asset:asset isSelectLastVideo:NO isAddCamera:NO];
    [[MXRSelectLocalImageProxy getInstance]selectImageChangeStatusWithModel:model];
}

- (void)selectAlbumCountNoneZero
{
    __block NSMutableArray *albumArray = [[NSMutableArray alloc]init];
    [self.totalAlbumDataArray enumerateObjectsUsingBlock:^(MXRLocalAlbumModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.fetchResult.count != 0) {
            [albumArray addObject:obj];
        }
    }];
    [self setDataArrayWith:albumArray];
    
}
@end
