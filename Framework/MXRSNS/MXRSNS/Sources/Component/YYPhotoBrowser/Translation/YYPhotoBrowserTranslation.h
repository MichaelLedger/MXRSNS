//
//  YYPhotoBrowserTranslation.h
//  YYPhotoBrowserLikeWX
//
//  Created by yuyou on 2017/12/5.
//  Copyright © 2017年 yy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRBookSNSUploadImageInfo.h"

//typedef void(^EndBlock)(void);

@interface YYPhotoBrowserTranslation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign) BOOL photoBrowserShow;//图片浏览器是显示还是隐藏
//@property (nonatomic,strong) EndBlock endBlock;
@property (nonatomic,strong) UIView *photoBrowserMainScrollView;//图片浏览页主控件，转场时要隐藏它
@property (nonatomic, strong)NSArray <MXRBookSNSUploadImageInfo *>*imageInfoArray;//图片信息数组
@property (nonatomic,strong) NSMutableArray *imageViewArray;//外部的图片控件数组，转场时隐藏对应的
@property (nonatomic,strong) NSMutableArray <NSValue *>*imageViewFrameArray;//外部图片控件的frame数组，转场时需要
@property (nonatomic,assign) CGRect backImageFrame;//退回时的image的frame
/** 这个参数请最后设置，因为它的setter方法中用到了以上参数 */
@property (nonatomic,assign) NSInteger currentIndex;//当前是从在哪个图片返回

@end
