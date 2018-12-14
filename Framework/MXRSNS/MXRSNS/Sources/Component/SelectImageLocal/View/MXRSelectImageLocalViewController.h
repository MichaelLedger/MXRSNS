//
//  MXRSelectImageLocalViewController.h
//  xuanquTupian
//
//  Created by yuchen.li on 16/8/24.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "BookInfoForShelf.h"

@class MXRLocalAlbumModel,MXRImageInformationModel;
@interface MXRSelectImageLocalViewController : MXRDefaultViewController
@property (nonatomic, strong) PHAssetCollection *assetCollection ;
@property (nonatomic, assign) MXRSelctImageOperationType operationType;

/**

 @param maxCount 选择的最大数量
 @param mediaType 数据类型
 @param operationType 操作类型
 @param albumModel 单个相册信息
 @param bookGuid 分享的bookGuid
 @param completion 选择完成的回调
 @return
 */
- (instancetype)initWithMaxCount:(NSInteger)maxCount
                       mediaType:(PHAssetMediaType)mediaType
                   operationType:(MXRSelctImageOperationType)operationType
                      albumModel:(MXRLocalAlbumModel *)albumModel
                        bookGuid:(NSString *)bookGuid
                      completion:(void(^)(NSMutableArray *imageDataArray))completion;

/**
 DIY 私信      PHAssetMediaTypeUnknown = 0,
              PHAssetMediaTypeImage   = 1,
              PHAssetMediaTypeVideo   = 2,
              PHAssetMediaTypeAudio   = 3,

 @param maxCount 选择的最大数量
 @param functype
 @return 
 */
- (instancetype)initWith:(NSInteger)maxCount
               mediaType:(PHAssetMediaType)mediaType
              albumModel:(MXRLocalAlbumModel *)albumModel
           operationType:(MXRSelctImageOperationType)operationType
       completionhandler:(void (^)(NSMutableArray *))completionHandler;
@end
