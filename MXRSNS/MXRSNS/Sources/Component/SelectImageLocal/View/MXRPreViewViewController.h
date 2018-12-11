//
//  MXRPreViewViewController.h
//  huashida_home
//
//  Created by yuchen.li on 16/8/29.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookInfoForShelf.h"
#import "MXRSelectImageLocalViewController.h"

@protocol MXRPreViewViewDelegate <NSObject>
-(void)goToDismiss;
@end

@class MXRLocalAlbumModel,MXRImageInformationModel;
@interface MXRPreViewViewController : MXRDefaultViewController

@property (nonatomic, weak) id <MXRPreViewViewDelegate> delegate;
@property (nonatomic, strong) MXRLocalAlbumModel *lastAlbumInfoModel;                              // 用来记录上次选中的相册信息
@property (nonatomic, strong)NSMutableArray <MXRImageInformationModel *> *imageModelDataArray;       //数据源
@property (nonatomic, assign) MXRSelctImageOperationType operationType;                            //操作类型

/**
 梦想圈 和 分享

 @param indexPath 数据源的位置
 @param mediaType PHAsset类型
 @param bookGuid 分享的bookGuid
 @param operationType 操作类型
 @param completionHandler 选择完成的回调
 @return
 */
- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath
                        mediaType:(PHAssetMediaType)mediaType
                    shareBookGuid:(NSString *)bookGuid
                    operationType:(MXRSelctImageOperationType)operationType
                completionHandler:(void(^)(NSMutableArray *imageDataArray))completionHandler;

/**
 DIY  私信

 @param indexPath 数据源的位置
 @param mediaType PHAsset类型
 @param completionHandler
 @return 
 */
- (instancetype)initForDIYIndexPath:(NSIndexPath *)indexPath
                          mediaType:(PHAssetMediaType)mediaType
                  completionHandler:(void(^)(NSMutableArray *imageDataArray))completionHandler;
@end
