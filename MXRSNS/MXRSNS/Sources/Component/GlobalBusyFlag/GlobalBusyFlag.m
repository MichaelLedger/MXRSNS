//
//  GlobalBusyFlag.m
//  AiYiKe
//
//  Created by bin.yan on 14-10-8.
//  Copyright (c) 2014年 mxrcorp. All rights reserved.
//

#import "GlobalBusyFlag.h"
#import "MBProgressHUD.h"
//#import "AppDelegate.h"
#import "DimensMacro.h"
#import "BUUtil.h"

@interface GlobalBusyFlag()
@property (strong, nonatomic) MBProgressHUD * g_hud;
@property (strong, nonatomic) MBProgressHUD *specialHUD;
@property (strong, nonatomic) UIView *fullView;
//双目模式使用
@property (strong, nonatomic) NSMutableArray *g_hudArray;
@property (strong, nonatomic) UIImageView *loadingImageView;
@property (strong, nonatomic) CABasicAnimation* rotationAnimation;
@end


@implementation GlobalBusyFlag
@synthesize g_hud;
@synthesize g_hudArray;
@synthesize specialHUD;
+ (id)sharedInstance
{
    static GlobalBusyFlag * g_class;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        g_class = [[GlobalBusyFlag alloc] init];
    });
    return g_class;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        g_hud = [[MBProgressHUD alloc] init];
        g_hud.userInteractionEnabled  = NO;
        g_hud.color = [UIColor clearColor];
        g_hudArray = [[NSMutableArray alloc] init];
        specialHUD = [[MBProgressHUD alloc] init];
        specialHUD.userInteractionEnabled = NO;
        specialHUD.hidden = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)willEnterForeground:(NSNotification*)noti{
    if (g_hud&&[g_hud superview]&&(!g_hud.hidden)) {
         [g_hud show:YES];
    }
}
-(void)showBusyFlagOnWindowWithMessage:(NSString *)msg{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        specialHUD.hidden = NO;
        [specialHUD show:YES];
        specialHUD.labelText = msg;
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        specialHUD.center = window.center;
        [window addSubview:specialHUD];
    });
}
- (void)showBusyFlagOnView:(UIView *)containView withMessage:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        specialHUD.hidden = NO;
        [specialHUD show:YES];
        specialHUD.labelText = msg;
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        if (!window){
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        if ([window subviews].count > 0) {
            
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
                specialHUD.center = [[[window subviews] firstObject] center];
                [[[window subviews] firstObject] addSubview:specialHUD];
            }else{
                // 横屏
                specialHUD.center =  CGPointMake(SCREEN_HEIGHT_DEVICE_ABSOLUTE/2, SCREEN_WIDTH_DEVICE_ABSOLUTE/2);
                [[[window subviews] firstObject] addSubview:specialHUD];
            }
            
        }
    });
}


- (void)showBusyFlagOnView:(UIView *)containView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        g_hud.hidden = NO;
        g_hud.center = containView.center;
        g_hud.userInteractionEnabled = NO;
        g_hud.customView.userInteractionEnabled = NO;
        [g_hud show:YES];
        [containView addSubview:g_hud];
    });
}

- (void)showBusyFlagOnView:(UIView *)containView enableTouch:(BOOL)enable{
    [self showBusyFlagOnView:containView];
    dispatch_async(dispatch_get_main_queue(), ^{
        g_hud.hidden = NO;
        g_hud.center = containView.center;
        g_hud.userInteractionEnabled = enable;
        g_hud.customView.userInteractionEnabled = enable;
        [g_hud show:YES];
        [containView addSubview:g_hud];
    });

}

- (void)showBusyFlagOnView:(UIView *)containView andFlagCenter:(CGPoint )point{
    dispatch_async(dispatch_get_main_queue(), ^{
        g_hud.hidden = NO;
        g_hud.center = point;
        g_hud.userInteractionEnabled = NO;
        g_hud.customView.userInteractionEnabled = NO;
        [g_hud show:YES];
        [containView addSubview:g_hud];
    });
}
- (void)showBusyFlagFullScreenOnView:(UIView *)containView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        g_hud.hidden = NO;
        g_hud.center = containView.center;
        [g_hud show:YES];
        self.fullView = [[UIView alloc] initWithFrame:containView.frame];
        [self.fullView addSubview:g_hud];
        [containView addSubview:self.fullView];
    });
}


- (void)hideBusyFlag
{
    dispatch_async(dispatch_get_main_queue(), ^{
        g_hud.hidden = YES;
        specialHUD.hidden = YES;
        if (self.fullView) {
            [self.fullView removeFromSuperview];
        }
        [g_hud removeFromSuperview];
        [specialHUD removeFromSuperview];
    });
}

- (void)showBusyFlagOnWindow{
    dispatch_async(dispatch_get_main_queue(), ^{
        g_hud.hidden = NO;
        [g_hud show:YES];
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
         g_hud.center = CGPointMake(SCREEN_WIDTH_DEVICE/2, SCREEN_HEIGHT_DEVICE/2);
        [window addSubview:g_hud];
    });
    
}

- (void)hideBusyFlagOnWindow{
    dispatch_async(dispatch_get_main_queue(), ^{
        g_hud.hidden = YES;
        
        if (self.fullView) {
            [self.fullView removeFromSuperview];
        }
        [g_hud removeFromSuperview];
    });

}


-(void)showTwoBusyFlagOnWindow{
    dispatch_async(dispatch_get_main_queue(), ^{
     
      
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        if (!window){
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        if ([window subviews].count > 0) {
            CGRect frame   = [[[window subviews] firstObject] frame];
            CGPoint center = [[[window subviews] firstObject] center];
            for (int i=0; i < 2; ++i) {
                MBProgressHUD *hud=[[MBProgressHUD alloc] init];
                hud.color = [UIColor clearColor];
                hud.hidden = NO;
                [g_hud show:YES];
                hud.center = CGPointMake( i==0?(center.x - frame.size.width/4):(center.x + frame.size.width/4),center.y);
                [[[window subviews] firstObject] addSubview:hud];
                [g_hudArray addObject:hud];
            }
           
        }
    });
}
-(void)hideTwoBusyFlagOnWindow{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSUInteger i=0,count = g_hudArray.count; i < count; ++i) {
            [[g_hudArray objectAtIndex:i] removeFromSuperview];
        }
    });
}

-(void)showMBHUD:(UIView*)view text:(NSString*)content delay:(float)delay{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.labelText = content;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:delay];
}

-(void)showMBHUD:(UIView*)view text:(NSString*)content delay:(float)delay radius:(CGFloat)radius{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = content;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:delay];
    hud.transform = CGAffineTransformMakeRotation(radius);
}

-(void)showMBHUD:(UIView*)view text:(NSString*)content dealy:(CGFloat)delay WithImageName:(NSString*)imageName
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = content;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:MXRIMAGE(imageName)];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:delay];
}
-(void)showDownloadIamgeLoading{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadingImageView removeFromSuperview];
        [[[UIApplication sharedApplication].windows lastObject] addSubview:self.loadingImageView];
        if (self.loadingImageView.layer.animationKeys.count == 0) {
            [self.loadingImageView.layer addAnimation:self.rotationAnimation forKey:@"animation"];
        }
    });
}
-(void)hideDownloadIamgeLoading{

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadingImageView removeFromSuperview];
        [self.loadingImageView.layer removeAllAnimations];
    });
}
-(UIImageView*)loadingImageView
{
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH_DEVICE_ABSOLUTE/2.0-15, SCREEN_HEIGHT_DEVICE_ABSOLUTE/2.0-15, 30, 30)];
        _loadingImageView.image = MXRIMAGE(@"anim_chatloading");
        [_loadingImageView.layer addAnimation:self.rotationAnimation forKey:nil];
    }
    return _loadingImageView;
}
-(CABasicAnimation*)rotationAnimation
{
    if (!_rotationAnimation) {
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        _rotationAnimation.duration = 0.8;
        _rotationAnimation.cumulative = YES;
        _rotationAnimation.repeatCount = 100000;
    }
    return _rotationAnimation;
}
@end
