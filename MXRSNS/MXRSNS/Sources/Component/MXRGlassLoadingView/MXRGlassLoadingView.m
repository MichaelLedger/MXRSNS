//
//  MXRGlassLoadingView.m
//  huashida_home
//
//  Created by 周建顺 on 15/11/19.
//  Copyright © 2015年 mxrcorp. All rights reserved.
//

#import "MXRGlassLoadingView.h"
#import "GlobalFunction.h"

@interface MXRGlassLoadingView()

@property (weak, nonatomic) IBOutlet UIImageView *xiaoMengImageView;
@property (weak, nonatomic) IBOutlet UIImageView *planeImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end

@implementation MXRGlassLoadingView

#pragma mark -- 获得loading动画数组
static inline NSArray * getLoadingAnimotionArray(NSString * t){
    
    return @[MXRIMAGE(@"anim_xiaomeng_01"),
             MXRIMAGE(@"anim_xiaomeng_02"),
             MXRIMAGE(@"anim_xiaomeng_03"),
             MXRIMAGE(@"anim_xiaomeng_04"),
             MXRIMAGE(@"anim_xiaomeng_05"),
             MXRIMAGE(@"anim_xiaomeng_06"),
             MXRIMAGE(@"anim_xiaomeng_07"),
             MXRIMAGE(@"anim_xiaomeng_08")];
}

+(instancetype)glassLoadingView{
    MXRGlassLoadingView *loadingView = nil;
//    for (UIView *view in APP_DELEGATE.window.subviews) {
//        if ([view isKindOfClass:[MXRGlassLoadingView class]]) {
//            loadingView = (MXRGlassLoadingView *)view;
//        }
//    }
    if (loadingView) {
        [loadingView randomDisplayTip];
        return loadingView;
    }else{
        loadingView = [[[NSBundle mainBundle] loadNibNamed:@"MXRGlassLoadingView" owner:nil options:nil] lastObject];
        loadingView.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE>SCREEN_HEIGHT_DEVICE?SCREEN_HEIGHT_DEVICE:SCREEN_WIDTH_DEVICE, SCREEN_WIDTH_DEVICE<SCREEN_HEIGHT_DEVICE?SCREEN_HEIGHT_DEVICE:SCREEN_WIDTH_DEVICE);
        [loadingView startProgress];
        [loadingView randomDisplayTip];
        return loadingView;
    }
}


/**
 创新点加上文字提示
 */
- (void)randomDisplayTip
{
    // 暂时先隐藏
//    if (APPCURRENTTYPE == MXRAppTypeBookCity) {
//        NSArray* tipArray = MXRCITYLOADTIPARRAY;
//        NSString *tipStr = [tipArray objectAtIndex:arc4random_uniform((uint32_t)[tipArray count])];
//        self.tipLabel.text = tipStr;
//    }
}

-(void)addXiaoMengAnimation{
    self.xiaoMengImageView.animationImages = getLoadingAnimotionArray(nil);
    self.xiaoMengImageView.animationDuration = 1.6f;
    self.xiaoMengImageView.animationRepeatCount = 0;
    [self.xiaoMengImageView startAnimating];
}

-(void)addPlaneAnimationImages{
    // 使用此方法可以使用代理
    //创建CAKeyframeAnimation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.duration = 8.0f;
    animation.repeatCount = 1;
    //animation.
    animation.calculationMode = @"discrete";
    animation.fillMode = @"forwards";
    animation.removedOnCompletion = NO;
    
    //存放图片的数组
    NSMutableArray *array = [NSMutableArray array];
    for(NSUInteger i = 1;i < 10 ;i++) {
        
        NSString * imgStr = [NSString stringWithFormat:@"anim_bookShelf_loading_plane_%lu",(unsigned long)i];
        UIImage *img = MXRIMAGE(imgStr);
        CGImageRef cgimg = img.CGImage;
        [array addObject:(__bridge UIImage *)cgimg];
    }
    
    animation.values = array;
    
    [self.planeImageView.layer addAnimation:animation forKey:@"planeAnmimation"];
}
-(void)startProgress{
    [self addPlaneAnimationImages];
    [self addXiaoMengAnimation];
}
-(void)stopProgress{
    [self.planeImageView.layer removeAnimationForKey:@"planeAnmimation"];
    self.planeImageView.image = MXRIMAGE(@"anim_bookShelf_loading_plane_10");
}
-(void)dealloc{
    DLOG_METHOD;
}


@end
