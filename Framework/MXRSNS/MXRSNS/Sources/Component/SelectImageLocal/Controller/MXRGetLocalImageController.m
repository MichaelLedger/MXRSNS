//
//  MXRGetLocalImageController.m
//  xuanquTupian
//
//  Created by yuchen.li on 16/8/25.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import "MXRGetLocalImageController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MXRLocalAlbumModel.h"
#import "MXRSelectLocalImageProxy.h"
#import "MXRImageInformationModel.h"
//#import "MXRPromptView.h"
#import "MXRMediaUtil.h"
#import "MXRAlbumListViewController.h"
#import "MXRNavigationViewController.h"
#import "MXRSelectImageLocalViewController.h"
//#import "AppDelegate.h"
#import "MXRShareVideoViewController.h"
@interface MXRGetLocalImageController()

@end

@implementation MXRGetLocalImageController
{
    ALAssetsLibrary* _assetsLibrary;
    NSMutableArray*_albumsArray;
}
+(instancetype)getInstance
{
    static MXRGetLocalImageController* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MXRGetLocalImageController alloc] init];
    });
    return instance;
}

//-(void)promptView:(MXRPromptView *)promptView didSelectAtIndex:(NSUInteger)index{
//
//
//
//}

//获取相册信息
-(void)getAlbumInformationMediaType:(PHAssetMediaType )mediaType{
    
    [MXRMediaUtil checkPhotoAlbumAuthorizationCallBack:^(BOOL isAuthority) {
        [[MXRSelectLocalImageProxy getInstance].totalAlbumDataArray removeAllObjects];
        if ([UIDevice currentDevice].systemVersion.floatValue<8.0) {
        
            _assetsLibrary = [[ALAssetsLibrary alloc] init];
            _albumsArray = [[NSMutableArray alloc] init];
            [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if (group) {
                    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                    if (group.numberOfAssets > 0) [_albumsArray addObject:group];
                } else {
                    if ([_albumsArray count] > 0) {
                        // 把所有的相册储存完毕，可以展示相册列表
                        for (ALAssetsGroup *group in _albumsArray) {
                            MXRLocalAlbumModel *model = [[MXRLocalAlbumModel alloc]initWtihGroup:group];
                            [[MXRSelectLocalImageProxy getInstance].totalAlbumDataArray addObject:model];
                        }
                    } else {
                        // 没有任何有资源的相册，输出提示
                    }
                }
            } failureBlock:^(NSError *error) {
            }];
        }else{
            [self  getAlbumListInfoMeidaType:mediaType];
        }
    }];
}
- (void)getAlbumListInfoMeidaType:(PHAssetMediaType)mediaType
{
    //2 209  所有图片
    PHFetchResult<PHAssetCollection *> *assetSmartCollection5 = [PHAssetCollection fetchAssetCollectionsWithType:2 subtype:209 options:nil];
    if (assetSmartCollection5.count>0) {
        for (PHAssetCollection *assetCollection in assetSmartCollection5) {
            [self enumerateAssetsInAssetCollection:assetCollection mediaType:mediaType];
        }
    }
    //  2 206 最近添加
    PHFetchResult<PHAssetCollection *> *assetSmartCollection4 = [PHAssetCollection fetchAssetCollectionsWithType:2 subtype:206 options:nil];
    if (assetSmartCollection4.count>0) {
        NSInteger index = 0;
        for (PHAssetCollection *assetCollection in assetSmartCollection4) {
            index++;
            [self enumerateAssetsInAssetCollection:assetCollection mediaType:mediaType];
        }
    }
    // 用户自己创建的相册  1 2
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:1 subtype:2 options:nil];
    //有count个自定义相册
    if (assetCollections.count>0) {
        for (PHAssetCollection *assetCollection in assetCollections) {
            //得到每个自定义相册
            [self enumerateAssetsInAssetCollection:assetCollection mediaType:mediaType];
        }
    }
    //  1  3
    PHFetchResult<PHAssetCollection *> *assetCollections2 = [PHAssetCollection fetchAssetCollectionsWithType:1 subtype:3 options:nil];
    if (assetCollections2.count>0) {
        // 遍历所有的自定义相簿
        for (PHAssetCollection *assetCollection in assetCollections2) {
            [self enumerateAssetsInAssetCollection:assetCollection mediaType:mediaType];
        }
    }
    // 1 4
    PHFetchResult<PHAssetCollection *> *assetCollections3 = [PHAssetCollection fetchAssetCollectionsWithType:1 subtype:4 options:nil];
    if (assetCollections3.count>0) {
        for (PHAssetCollection *assetCollection in assetCollections3) {
            [self enumerateAssetsInAssetCollection:assetCollection mediaType:mediaType];
        }
    }
    // 遍历所有的自定义相簿
    //  1 5
    PHFetchResult<PHAssetCollection *> *assetCollections4 = [PHAssetCollection fetchAssetCollectionsWithType:1 subtype:5 options:nil];
    if (assetCollections4.count>0) {
        // 遍历所有的自定义相簿
        for (PHAssetCollection *assetCollection in assetCollections4) {
            [self enumerateAssetsInAssetCollection:assetCollection mediaType:mediaType];
        }
        
    }
    // 1 6
    PHFetchResult<PHAssetCollection *> *assetCollections5 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumImported options:nil];
    if (assetCollections5.count>0) {
        for (PHAssetCollection *assetCollection in assetCollections5) {
            [self enumerateAssetsInAssetCollection:assetCollection mediaType:mediaType];
        }
    }
    if ([UIDevice currentDevice].systemVersion.floatValue>=9.0) {
        // 2  210
        PHFetchResult<PHAssetCollection *> *assetSmartCollection7 = [PHAssetCollection fetchAssetCollectionsWithType:2 subtype:210 options:nil];
        if (assetSmartCollection7.count>0) {
            for (PHAssetCollection *assetCollection in assetSmartCollection7) {
                [self enumerateAssetsInAssetCollection:assetCollection mediaType:mediaType];
            }
        }
        // 2 211
        PHFetchResult<PHAssetCollection *> *assetSmartCollection8 = [PHAssetCollection fetchAssetCollectionsWithType:2 subtype:211 options:nil];
        if (assetSmartCollection8.count > 0) {
            for (PHAssetCollection *assetCollection in assetSmartCollection8) {
                [self enumerateAssetsInAssetCollection:assetCollection mediaType:mediaType];
            }
        }
    }
    
    // 2 207
    PHFetchResult<PHAssetCollection *> *assetSmartCollection6=[PHAssetCollection fetchAssetCollectionsWithType:2 subtype:207 options:nil];
    if (assetSmartCollection6.count > 0) {
        for (PHAssetCollection *assetCollection in assetSmartCollection6) {
            [self enumerateAssetsInAssetCollection:assetCollection mediaType:mediaType];
        }
    }
    //2 203
    PHFetchResult<PHAssetCollection *> *assetSmartCollection3 = [PHAssetCollection fetchAssetCollectionsWithType:2 subtype:203 options:nil];
    if (assetSmartCollection3.count > 0) {
        for (PHAssetCollection *assetCollection in assetSmartCollection3) {
            [self enumerateAssetsInAssetCollection:assetCollection mediaType:mediaType];
        }
        
    }
    //获得智能相册
    //2 201
    PHFetchResult<PHAssetCollection *> *assetSmartCollection2 = [PHAssetCollection fetchAssetCollectionsWithType:2 subtype:201 options:nil];
    if (assetSmartCollection2.count>0) {
        for (PHAssetCollection *assetCollection in assetSmartCollection2) {
            [self enumerateAssetsInAssetCollection:assetCollection mediaType:mediaType];
        }
    }
    // 2 200
    PHFetchResult<PHAssetCollection *> *assetSmartCollection1 = [PHAssetCollection fetchAssetCollectionsWithType:2 subtype:200 options:nil];
    if (assetSmartCollection1.count>0) {
        for (PHAssetCollection *assetCollection in assetSmartCollection1) {
            [self enumerateAssetsInAssetCollection:assetCollection mediaType:mediaType];
        }
    }
}


- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection mediaType:(PHAssetMediaType )mediaType {
    
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    if (mediaType == PHAssetMediaTypeUnknown) {
        // 筛选 图片 和 视频
        NSInteger totalCount = 0 ;
        for (int i = 1; i < 3; i++) {
            totalCount = totalCount + [result countOfAssetsWithMediaType:i];
        }
//        if (totalCount == 0) return;
        //将Album的基本信息存入dataArray
        MXRLocalAlbumModel *model = [[MXRLocalAlbumModel alloc]initWithPHAssetCollection:assetCollection];
        [[MXRSelectLocalImageProxy getInstance].totalAlbumDataArray addObject:model];
    
    }else{
//        if ([result countOfAssetsWithMediaType:mediaType] == 0) return;
        //将Album的基本信息存入dataArray
        MXRLocalAlbumModel *model = [[MXRLocalAlbumModel alloc]initWithPHAssetCollection:assetCollection];
        [[MXRSelectLocalImageProxy getInstance].totalAlbumDataArray addObject:model];
    }
}
-(void)getImageByModel:(MXRImageInformationModel *)model withCallBack:(void (^)(BOOL))callBack{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = YES;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size =  CGSizeMake(500.0 * scale, 500.0 * scale * (float) model.asset.pixelHeight / (float)model.asset.pixelWidth);
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            UIImage *image = result;
            [model setAssetImageWith: image];
            if (callBack) callBack(YES);
        }else{
            if (callBack) callBack(NO);
        }
    }];
}
-(void)getThumnailImageByModel:(MXRImageInformationModel *)model callBack:(void (^)(BOOL))callBack{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = YES;
    CGSize size =  CGSizeMake(300,300);
    [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            UIImage *image = result;
            [model setAssetImageWith:image];
            if (callBack){
                callBack(YES);
            }
            
        }else{
            if (callBack){
                callBack(NO);
            }
        }
    }];
}

-(void)getIamgeByGroup:(ALAssetsGroup*)group WithCallBack:(void(^)(BOOL isOkay))callBack{
    [[MXRSelectLocalImageProxy getInstance] removeAllImageInfoModelArrayData];
    [[MXRSelectLocalImageProxy getInstance] addCameraPhotoItem];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            //缩略图
            UIImage *img = [UIImage imageWithCGImage:result.aspectRatioThumbnail];
            if (img) {
                MXRImageInformationModel *model = [[MXRImageInformationModel alloc]initWithImage:img WithGroup:group WithIsSelectViewShow:YES IsShowIamge:YES];
                [[MXRSelectLocalImageProxy getInstance].imageInfoModelArray addObject:model];
            }
            if (index + 1 == group.numberOfAssets) {
                if (callBack) callBack(YES);
            }
        }else{
            
            
        }
    }];
}

-(NSInteger)getSelectImageCount{
    NSInteger count = 0;
    for (NSInteger i = 0; i < [MXRSelectLocalImageProxy getInstance].imageInfoModelArray.count ; i++)
    {
        MXRImageInformationModel* model = [[MXRSelectLocalImageProxy getInstance].imageInfoModelArray  objectAtIndex:i];
        BOOL flag = [[model.dic objectForKey:@"flga"] boolValue];
        if (flag) count++;
    }
    return count;
}

/**
 根据名字检查是否存在某一相册

 @param albumName
 @return
 */
-(BOOL)checkAlbumExistWithAlbumName:(NSString *)albumName{
    BOOL isExitAlbum = NO;
    if (IOS8_OR_LATER) {
        [[MXRGetLocalImageController getInstance]getAlbumInformationMediaType:PHAssetMediaTypeImage];
        for (MXRLocalAlbumModel *albumModel in [MXRSelectLocalImageProxy getInstance].totalAlbumDataArray) {
            if ([albumModel.assetCollection.localizedTitle isEqualToString:albumName]) {
                isExitAlbum = YES;
                break;
            }
        }
    }else{
        
    }
    return isExitAlbum;
}
/**
 
 将视频存入相册
 1，判断该相册是否存在。
 2，如果相册中不存在该相册 新建一个相册，然后存入该相册，如果存在该相册直接将视频存入相册。

 @param albumName
 @param saveImage
 @param completion
 */
- (void)saveImageToAlbumWithAlbumName:(NSString *)albumName saveImage:(UIImage *)saveImage completion:(void (^)(BOOL success))completion{
    if (IOS8_OR_LATER) {
        BOOL isExitFourDismensionAlbum  =  [self checkAlbumExistWithAlbumName:albumName];
        if (!isExitFourDismensionAlbum) {
            __block PHObjectPlaceholder *albumPlaceholder;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
                albumPlaceholder = changeRequest.placeholderForCreatedAssetCollection;
            } completionHandler:^(BOOL success, NSError *error) {
                if (success) {
                    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumPlaceholder.localIdentifier] options:nil];
                    PHAssetCollection *assetCollection = fetchResult.firstObject;
                    // Add it to the photo library
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:saveImage];
                        PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                        [assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];
                    } completionHandler:^(BOOL success, NSError *error) {
                        if (completion){
                            completion(success);
                        }
                    }];
                } else {
                    DLOG(@"Error creating album: %@", error);
                    if (completion){
                        completion(success);
                    }
                }
            }];
            
        }else{

            [self saveToExistAlbumWithImage:saveImage albumName:albumName completion:^(BOOL success) {
                if (completion) {
                    completion(success);
                }
            }];
        }
    }
}


/**
 将图片保存到已存在的相册中
 
 @param saveImage
 @param albumName
 @param completion
 */
- (void)saveToExistAlbumWithImage:(UIImage *)saveImage albumName:(NSString *)albumName completion:(void(^)(BOOL success))completion{
    if(IOS8_OR_LATER){
        PHAssetCollection *fourDismentionBookStoreCollection = [self findAssetCollectionWithAlbumName:albumName];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:saveImage];
            PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:fourDismentionBookStoreCollection];
            [assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];
        } completionHandler:^(BOOL success, NSError *error) {
            if (error) DLOG(@"save Image error:%@",error);
            if (completion){
                completion(success);
            }
        }];
    }
    
}

/**
 保存图片至 胶卷相机相册

 @param image
 @param completionHandler
 */
-(void)saveImageToAllImageAlbumWithImage:(UIImage *)image CompletionHandler:(void (^)(BOOL))completionHandler
{
    if (IOS8_OR_LATER) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError *error) {
            if(!success) DLOG(@"write error : %@",error);
            if (completionHandler) completionHandler(success);
        }];
    }
}

/**
 根据 PHAsset 删除图片

 @param asset
 @param completionHandler
 */
-(void)deleteImageFromAlbumWithAsset:(PHAsset *)asset CompletionHandler:(void (^)(BOOL))completionHandler{
    if (IOS8_OR_LATER) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest deleteAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError *error) {
            if (!success) DLOG(@"delete Image Fail:%@",error);
            if (completionHandler) completionHandler(success);
        }];
    }
}

/**
 获取某个相册下 所有的 PHAssetCollection

 @param albumName 相册名字
 @return 
 */
- (PHAssetCollection *)findAssetCollectionWithAlbumName:(NSString *)albumName{
    if (IOS8_OR_LATER) {
        [[MXRGetLocalImageController getInstance]getAlbumInformationMediaType:PHAssetMediaTypeUnknown];
        PHAssetCollection *fourDismentionBookStoreCollection;
        for (MXRLocalAlbumModel *albumModel in [MXRSelectLocalImageProxy getInstance].totalAlbumDataArray) {
            if ([albumModel.assetCollection.localizedTitle isEqualToString:albumName]) {
                fourDismentionBookStoreCollection = albumModel.assetCollection;
                break;
            }
        }
        return fourDismentionBookStoreCollection;
    }else{
        return nil;
    }
}


/**
 
 将视频存入相册
 1，判断该相册是否存在。
 2，如果相册中不存在该相册 新建一个相册，然后存入该相册，如果存在该相册直接将视频存入相册。

 @param albumName
 @param videoPath
 @param completion
 */
- (void)saveVideoToAlbumWithAlbumName:(NSString *)albumName videoPath:(NSString *)videoPath completion:(void (^)(BOOL success))completion{
    [self judgeIsExistAlbumWithAlbumName:albumName createCompleteHandler:^(BOOL isOkay, BOOL isNew, PHObjectPlaceholder *albumPlaceholder) {
        //第一次创建4D书城的回调
        if(isOkay && isNew && albumPlaceholder){
            [self saveVideoToOneAlbumWithPHObjectPlaceholder:albumPlaceholder videoPath:videoPath completionHandler:^(BOOL isOkay) {
                if (completion) {
                    completion(isOkay);
                }
            }];
            //无需新建4D书城的回调
        }else if(isOkay && !isNew ){
            [self saveVideoToExistAlbum:albumName videoPath:videoPath completionHandler:^(BOOL success) {
                if (completion) {
                    completion(success);
                }
            }];
        }
    }];
}

/**
 向已存在的相册中存视频

 @param albumName
 @param videoPath
 @param completionHandler
 */
-(void)saveVideoToExistAlbum:(NSString *)albumName videoPath:(NSString*)videoPath completionHandler:(void (^)(BOOL))completionHandler{
    if(IOS8_OR_LATER){
        PHAssetCollection *fourDismentionBookStoreCollection =[self findAssetCollectionWithAlbumName:albumName];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:videoPath]];
            PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:fourDismentionBookStoreCollection];
            [assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];;
        } completionHandler:^( BOOL success, NSError *error ) {
            if (error)   DLOG( @"Could not save movie to photo library: %@", error );
            if (completionHandler) completionHandler(success);
        }];
    }else{
    }
}

/**
 跟据 PHAsset 获取视频路径 并 赋值给该model

 @param infoModel
 @param completionHandler
 */
-(void)getVideoFromAlbumWithPHAsset:(MXRImageInformationModel *)infoModel completionHandler:(void (^)(BOOL))completionHandler{
    if (IOS8_OR_LATER) {
            if (infoModel.asset.mediaType == PHAssetMediaTypeVideo) {
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            PHImageManager *manager = [PHImageManager defaultManager];
            [manager requestAVAssetForVideo:infoModel.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                
                if ([asset isKindOfClass:[AVURLAsset class]]) {
                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
                    NSURL *url = [urlAsset URL];
                    if (url) [infoModel setVideoURLWith:url];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    if (data) {
                        [infoModel setVideoDataWith:data];
                        if (completionHandler) completionHandler(YES);
                    }else{
                        if (completionHandler) completionHandler(NO);
                    }
                }else if([asset isKindOfClass:[AVComposition class]]){
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = paths.firstObject;
                    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeSlowMoVideo-%d.mov",arc4random() % 1000]];
                    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
                    
                    //Begin slow mo video export
                    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
                    exporter.outputURL = url;
                    exporter.outputFileType = AVFileTypeQuickTimeMovie;
                    exporter.shouldOptimizeForNetworkUse = YES;
                    
                    [exporter exportAsynchronouslyWithCompletionHandler:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                                NSURL *URL = exporter.outputURL;
                                if (url) [infoModel setVideoURLWith:URL];
                                NSData *data = [NSData dataWithContentsOfURL:url];
                                if (data) {
                                    [infoModel setVideoDataWith:data];
                                    if (completionHandler) completionHandler(YES);
                                }else{
                                    if (completionHandler) completionHandler(NO);
                                }
                            }
                        });
                    }];
                }else{
                    return;
                }
            
            }];
        }else{
            assert(0);
        }
    }
}

/**
 根据 PHObjectPlaceholder 存视频 在新建完相册之后调用

 @param albumPlaceholder
 @param path
 @param completionHandler
 */
-(void)saveVideoToOneAlbumWithPHObjectPlaceholder:(PHObjectPlaceholder*)albumPlaceholder videoPath:(NSString*)path completionHandler:(void (^)(BOOL isOkay))completionHandler{
    if (IOS8_OR_LATER) {
        PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumPlaceholder.localIdentifier] options:nil];
        PHAssetCollection *assetCollection = fetchResult.firstObject;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            if ( [PHAssetResourceCreationOptions class] ) {
                PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                options.shouldMoveFile = YES;
                PHAssetCreationRequest *assetChangeRequest = [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:[NSURL URLWithString:path]];
                PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                [assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];;
            }
            else {
                [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL URLWithString:path]];
            }
        } completionHandler:^( BOOL success, NSError *error ) {
            if (completionHandler) completionHandler(success);
        }];
    }else{
        
    }
}

/**
 判断是否存在某个相册 若不存在该相册 则创建并返回该相册的 PHObjectPlaceholder

 @param albumName
 @param completHandler
 */
-(void)judgeIsExistAlbumWithAlbumName:(NSString *)albumName createCompleteHandler:(void(^)(BOOL isOkay,BOOL isNew,PHObjectPlaceholder*albumPlaceholder))completHandler{
    if (IOS8_OR_LATER) {
        BOOL isExitFourDismensionAlbum = NO;
        [[MXRGetLocalImageController getInstance]getAlbumInformationMediaType:PHAssetMediaTypeUnknown];
        for (MXRLocalAlbumModel *albumModel in [MXRSelectLocalImageProxy getInstance].totalAlbumDataArray) {
            if ([albumModel.assetCollection.localizedTitle isEqualToString:albumName]) {
                isExitFourDismensionAlbum = YES;
                break;
            }
        }
        if (!isExitFourDismensionAlbum) {
            __block PHObjectPlaceholder *albumPlaceholder;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
                albumPlaceholder = changeRequest.placeholderForCreatedAssetCollection;
            } completionHandler:^(BOOL success, NSError *error) {
                if (success) {
                    if (completHandler) completHandler(YES,YES,albumPlaceholder);
                } else {
                    if (completHandler) completHandler(NO,YES,nil);
                }
            }];
        }else{
            if (completHandler) completHandler(YES,NO,nil);
        }
    }else{
    }
}

- (PHAssetCollection *)getAllImageAlbumInformation
{
    //获取  所有的 系统相册
    PHFetchResult<PHAssetCollection *> *assetSmartCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    return  [assetSmartCollection firstObject];
}

- (PHFetchResult *)getAllPHAssetFromPHAssetCollection:(PHAssetCollection *)assetCollection
{
    PHFetchOptions * photosOptions = [[PHFetchOptions alloc] init];
    photosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    //asset的集合
    PHFetchResult <PHAsset *> * assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:photosOptions];
    return assetResult;
}

- (void)presentToSelectImageLocalType:(PHAssetMediaType)mediaType maxCount:(NSInteger)maxCount isAddPhotoItem:(BOOL)isAddPhotoItem  presentCompletion:(void (^)(BOOL))completion selectDoneCompletion:(void (^)(NSMutableArray *))selectDoneCompletion
{
    [MXRMediaUtil checkPhotoAlbumAuthorizationCallBack:^(BOOL isAuthority) {
        if (isAuthority) {
            void (^completionHandler)(NSMutableArray *imageDataArray);
            completionHandler = ^ (NSMutableArray *imageDataArray){
                if (selectDoneCompletion) selectDoneCompletion(imageDataArray);
            };
            [[MXRSelectLocalImageProxy getInstance]setMXRIsAddCamera:isAddPhotoItem];
            [[MXRGetLocalImageController getInstance]getAlbumInformationMediaType:mediaType];
            MXRLocalAlbumModel *model ;
            if ([MXRSelectLocalImageProxy getInstance].totalAlbumDataArray.count >= 2) {
                model = [MXRSelectLocalImageProxy getInstance].totalAlbumDataArray[1];
            }else if([MXRSelectLocalImageProxy getInstance].totalAlbumDataArray.count == 1){
                model = [MXRSelectLocalImageProxy getInstance].totalAlbumDataArray[0];
            }
             [[MXRSelectLocalImageProxy getInstance]prepareSeletPHAsset:mediaType localAlbumModel:model isAddPhotoItem:isAddPhotoItem];
            MXRSelectImageLocalViewController *selectImageVC = [[MXRSelectImageLocalViewController alloc]initWith:maxCount mediaType:mediaType albumModel:model  operationType:MXRSelctImageOperationTypeDIY  completionhandler:completionHandler];
            MXRAlbumListViewController *albumListVC = [[MXRAlbumListViewController alloc]initForDIYMaxCount:maxCount mediaType:mediaType completionhandler:completionHandler];
            MXRNavigationViewController *navi = [[MXRNavigationViewController alloc] initWithRootViewController:albumListVC];
            [navi pushViewController:selectImageVC animated:NO];
            UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            UIViewController *topVC;
            if (appRootVC.presentedViewController) {
                topVC = appRootVC.presentedViewController;
                if ([[topVC.childViewControllers lastObject] presentedViewController]) {
                    topVC = [[topVC.childViewControllers lastObject] presentedViewController];
                }
                [(MXRNavigationViewController *)topVC presentViewController:navi animated:YES completion:^{
                    if (completion) completion(YES);
                }];
            }else{
//                AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                [del.navigationController presentViewController:navi animated:YES completion:^{
//                    if (completion) completion(YES);
//                }];
            }
        }else{
            return ;
        }
    }];
}

- (void)presentToSelectImageLocalType:(PHAssetMediaType)mediaType maxCount:(NSInteger)maxCount isAddPhotoItem:(BOOL)isAddPhotoItem  lastSelectAlbumModel:(MXRLocalAlbumModel *)lastAlbumModel lastSelectModelArray:(NSMutableArray<MXRImageInformationModel *> *)lastSelectImageModelArray  presentCompletion:(void (^)(BOOL))presentCompletion selectDoneCompletion:(void (^)(NSMutableArray *))selectDoneCompletion
{
    [[MXRSelectLocalImageProxy getInstance] setMXRIsAddCamera:isAddPhotoItem];
    __block MXRLocalAlbumModel * lastAlbumInfoModel = lastAlbumModel;
    [MXRMediaUtil checkPhotoAlbumAuthorizationCallBack:^(BOOL isAuthority) {
        if (isAuthority) {
            if (IOS8_OR_LATER) {
                //获取所有相册信息
                [[MXRGetLocalImageController getInstance]getAlbumInformationMediaType:mediaType];
                //第一次选择图片
                if (lastAlbumInfoModel == nil) {
                    if ([MXRSelectLocalImageProxy getInstance].totalAlbumDataArray.count == 0) return ;
                        lastAlbumInfoModel = [[MXRSelectLocalImageProxy getInstance].totalAlbumDataArray firstObject];
                }
                // 清空上一次选择的图片
                [[MXRSelectLocalImageProxy getInstance]removeAllImageInfoModelArrayData];
                [lastAlbumInfoModel.fetchResult enumerateObjectsUsingBlock:^(PHAsset *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.mediaType == mediaType) {
                        MXRImageInformationModel *imageInfoModel = [[MXRImageInformationModel alloc]initWithImage:nil WithAsset:obj WithIsLastSelectImage:YES withIsAddCamera:YES];
                        //获取选中的图片（设置为选中状态）
                        [lastSelectImageModelArray enumerateObjectsUsingBlock:^(MXRImageInformationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj.asset.localIdentifier isEqual:imageInfoModel.asset.localIdentifier]) {
                                [imageInfoModel setSelectOrderWith:idx + 1];
                                [imageInfoModel.dic setValue:@"1" forKey:@"flga"];
                            }
                        }];
                        [[MXRSelectLocalImageProxy getInstance].imageInfoModelArray addObject:imageInfoModel];
                    }else{
                        //DLOG(@"筛选图片");
                    }
                }];
              [[MXRSelectLocalImageProxy getInstance] setPreSelectImageModelArrayWith:[lastSelectImageModelArray mutableCopy]];
                MXRImageInformationModel *thunModel = [MXRSelectLocalImageProxy getInstance].imageInfoModelArray.firstObject;
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 防止 相机 出错
                    if (thunModel.isAddCamera && isAddPhotoItem) {
                        [[MXRSelectLocalImageProxy getInstance]addCameraPhotoItem];
                    }
                    void (^completionHandler)(NSMutableArray *imageDataArray);
                    completionHandler = ^ (NSMutableArray *imageDataArray){
                        if (selectDoneCompletion)  selectDoneCompletion(imageDataArray);
                    };

                    MXRSelectImageLocalViewController *VC = [[MXRSelectImageLocalViewController alloc]initWithMaxCount:maxCount mediaType:mediaType operationType:MXRSelctImageOperationTypeBookSNS albumModel:lastAlbumModel bookGuid:nil completion:completionHandler];
                    MXRAlbumListViewController *albumVC = [[MXRAlbumListViewController alloc]initWithMediaType:mediaType operationType:MXRSelctImageOperationTypeBookSNS completionHandler:completionHandler];
                    MXRNavigationViewController *navi = [[MXRNavigationViewController alloc] initWithRootViewController:albumVC];
                    [navi pushViewController:VC animated:NO];
                    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
                    UIViewController *topVC;
                    if (appRootVC.presentedViewController) {
                        topVC = appRootVC.presentedViewController;
                        if ([[topVC.childViewControllers lastObject] presentedViewController]) {
                            topVC = [[topVC.childViewControllers lastObject] presentedViewController];
                        }
                        [(MXRNavigationViewController *)topVC presentViewController:navi animated:YES completion:^{
                            if (presentCompletion) presentCompletion (YES);
                        }];
                    }else{
//                        AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                        [del.navigationController presentViewController:navi animated:YES completion:^{
//                            if (presentCompletion) presentCompletion (YES);
//                        }];
                    }
                });
            }
        }
    }];
}

- (void)presentToShareImageWithShareBookGuid:(NSString *)shareBookGuid  presnetComletion:(void(^)())presentCompletion
{
    
    [MXRMediaUtil checkPhotoAlbumAuthorizationCallBack:^(BOOL isAuthority) {
        if (isAuthority) {
            [[MXRSelectLocalImageProxy getInstance]setMXRIsAddCamera:NO];
            [[MXRGetLocalImageController getInstance]getAlbumInformationMediaType:PHAssetMediaTypeUnknown];
            MXRLocalAlbumModel *fourDismensionAlbumModel;
            if ([MXRSelectLocalImageProxy getInstance].totalAlbumDataArray.count <= 0) return ;
            for (MXRLocalAlbumModel *albumModel in [MXRSelectLocalImageProxy getInstance].totalAlbumDataArray) {
                if ([albumModel.assetCollection.localizedTitle isEqualToString:MXRLocalizedString(@"WZYShare_4DStore", @"4D书城")]) {
                    fourDismensionAlbumModel = albumModel;
                    break;
                }
            }
            if (!fourDismensionAlbumModel) fourDismensionAlbumModel = [[MXRSelectLocalImageProxy getInstance].totalAlbumDataArray firstObject];
            [[MXRSelectLocalImageProxy getInstance]removeAllImageInfoModelArrayData];
            for (PHAsset *asset in fourDismensionAlbumModel.fetchResult) {
                MXRImageInformationModel *model = [[MXRImageInformationModel alloc]initWithImage:nil WithAsset:asset WithIsLastSelectImage:YES withIsAddCamera:YES];
                [[MXRSelectLocalImageProxy getInstance].imageInfoModelArray addObject:model];
                
            }
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
//            APP_DELEGATE.landOrPortraitBool = NO;
            MXRSelectImageLocalViewController *VC = [[MXRSelectImageLocalViewController alloc]initWithMaxCount:9 mediaType:PHAssetMediaTypeUnknown operationType:MXRSelctImageOperationTypeShare albumModel:fourDismensionAlbumModel bookGuid:shareBookGuid completion:^(NSMutableArray *imageDataArray) {
            }];
            VC.hideBackButton = YES;
            MXRAlbumListViewController *secVC = [[MXRAlbumListViewController alloc]initWithMediaType:PHAssetMediaTypeUnknown operationType:MXRSelctImageOperationTypeShare completionHandler:^(NSMutableArray *imageDataArray) {
                
            }];
            MXRNavigationViewController *navi = [[MXRNavigationViewController alloc] initWithRootViewController:secVC];
            [navi pushViewController:VC animated:NO];
            UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            UIViewController *topVC;
            if (appRootVC.presentedViewController) {
                topVC = appRootVC.presentedViewController;
                if ([[topVC.childViewControllers lastObject] presentedViewController]) {
                    topVC = [[topVC.childViewControllers lastObject] presentedViewController];
                }
                [(MXRNavigationViewController *)topVC presentViewController:navi animated:YES completion:^{
                    if (presentCompletion) presentCompletion();
                }];
            }else{
//                AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                [del.navigationController presentViewController:navi animated:YES completion:^{
//                    if (presentCompletion) presentCompletion();
//                }];
            }
        }
    }];
}

- (void)pushPlayAndShareVideoWithShareBookGuid:(NSString *)shareBookGuid{
    
    [MXRMediaUtil checkPhotoAlbumAuthorizationCallBack:^(BOOL isAuthority) {
        if (isAuthority) {
            [[MXRSelectLocalImageProxy getInstance]setMXRIsAddCamera:NO];
            [[MXRGetLocalImageController getInstance]getAlbumInformationMediaType:PHAssetMediaTypeUnknown];
            MXRLocalAlbumModel *fourDismensionAlbumModel;
            if ([MXRSelectLocalImageProxy getInstance].totalAlbumDataArray.count <= 0) return ;
            for (MXRLocalAlbumModel *albumModel in [MXRSelectLocalImageProxy getInstance].totalAlbumDataArray) {
                if ([albumModel.assetCollection.localizedTitle isEqualToString:MXRLocalizedString(@"WZYShare_4DStore", @"4D书城")]) {
                    fourDismensionAlbumModel = albumModel;
                    break;
                }
            }
            if (!fourDismensionAlbumModel) fourDismensionAlbumModel = [[MXRSelectLocalImageProxy getInstance].totalAlbumDataArray firstObject];
            [[MXRSelectLocalImageProxy getInstance]removeAllImageInfoModelArrayData];
            for (PHAsset *asset in fourDismensionAlbumModel.fetchResult) {
                MXRImageInformationModel *model = [[MXRImageInformationModel alloc]initWithImage:nil WithAsset:asset WithIsLastSelectImage:YES withIsAddCamera:YES];
                [[MXRSelectLocalImageProxy getInstance].imageInfoModelArray addObject:model];
                
            }
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
//            APP_DELEGATE.landOrPortraitBool = NO;
            
            
            NSIndexPath *indexPrew = [NSIndexPath indexPathForItem:0 inSection:0];
            MXRShareVideoViewController *shareVC = [[MXRShareVideoViewController alloc]initWithIndexPath:indexPrew mediaType:PHAssetMediaTypeUnknown shareBookGuid:shareBookGuid operationType:MXRSelctImageOperationTypeShare completionHandler:^(NSMutableArray *imageDataArray) {
                
            }];
            MXRImageInformationModel *model = [MXRSelectLocalImageProxy getInstance].imageInfoModelArray[0];
            shareVC.imageModelDataArray = [@[model] mutableCopy];
//            shareVC.delegate = self;
            shareVC.lastAlbumInfoModel = fourDismensionAlbumModel;
            
            
            UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            UIViewController *topVC;
            if (appRootVC.presentedViewController) {
                topVC = appRootVC.presentedViewController;
                if ([[topVC.childViewControllers lastObject] presentedViewController]) {
                    topVC = [[topVC.childViewControllers lastObject] presentedViewController];
                }
                [(MXRNavigationViewController *)topVC pushViewController:shareVC animated:YES];
            }else{
//                AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                [del.navigationController pushViewController:shareVC animated:YES];
            }
        }
    }];
}


- (BOOL)checkSelectedPHAssetInfoIsValid
{
    NSInteger originalImageArrayCount = [MXRSelectLocalImageProxy getInstance].preSelectImageModelArray.count;
    NSInteger selectCount = [[MXRGetLocalImageController getInstance]getSelectImageCount];
    if (originalImageArrayCount == 0) return NO;
    if (selectCount == 0) return NO;
    if (selectCount != originalImageArrayCount) return NO;
    return YES;
}
@end
