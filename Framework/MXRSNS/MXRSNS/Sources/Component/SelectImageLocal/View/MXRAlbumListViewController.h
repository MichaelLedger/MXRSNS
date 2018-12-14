//
//  MXRSecondSelectImageViewController.h
//  xuanquTupian
//
//  Created by yuchen.li on 16/8/24.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRSelectImageLocalViewController.h"
@class PHAssetCollection,PHFetchResult;

@interface MXRAlbumListViewController : MXRDefaultViewController
@property (nonatomic, assign) MXRSelctImageOperationType operationType;

/**
 

 @param mediaType 类型
 @param operationType 数据操作类型
 @param completionHandler 完成的回调
 @return 
 */
- (instancetype)initWithMediaType:(PHAssetMediaType)mediaType
                    operationType:(MXRSelctImageOperationType)operationType
                completionHandler:(void(^)(NSMutableArray *imageDataArray))completionHandler;


/**
 DIY 私信

 @param maxCount 选择的最大数量
 @param mediaType PHAsset 类型
 @param completionHandler 选择完成的回调
 @return 
 */
- (instancetype)initForDIYMaxCount:(NSInteger)maxCount
                         mediaType:(PHAssetMediaType)mediaType
                 completionhandler:(void(^)(NSMutableArray *imageDataArray))completionHandler;
@end
