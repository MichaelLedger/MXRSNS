//
//  MXRPromptView.m
//  huashida_home
//
//  Created by 周建顺 on 15/6/4.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//
#import "AppDelegate.h"
#import "MXRPromptView.h"
#import "UtilMacro.h"
#import "TTTAttributedLabel.h"
#import <objc/runtime.h>
#import "MXRGlassLoadingView.h"
#define SEPARATE_VIEW_COLOR RGB(236, 236, 236)
#define ScreenW ([[UIScreen mainScreen] bounds].size.width)
#define ScreenH ([[UIScreen mainScreen] bounds].size.height)
#define MSG_LABEL_MARGIN 24
#define BUTTON_HEIGHT 45
#define VIEW_H_MARGIN 25

#define SEPARATE_VIEW_MARGIN 1

#define FONT_DETAIL_LABEL  [UIFont systemFontOfSize:15]


@interface MXRPromptView()<UIAlertViewDelegate>{
    MXRPromptView *strongSelf;
}
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, weak) id<MXRPromptViewDelegate> mxrStrongDelegate;
@property (nonatomic, strong) UIWindow *overlayWindow;
@end

@implementation MXRPromptView

-(void)cleanValue{
    self.mxrDelegate = nil;
    self.mxrStrongDelegate = nil;
    self.alertController = nil;
    self.alertView = nil;
    self.buttonTapBlock = nil;
    strongSelf = nil;
    self.recordData = nil;
    self.isNotFromal = NO;
}

-(BOOL)isShowning{
    return     self.alertController != nil|| self.alertView != nil;
}


/*
 * cancelButton 右侧的按钮，otherButton左侧按钮
 */
-(instancetype)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id<MXRPromptViewDelegate>)customDelegate cancelButtonTitle:(NSString*)cancelTitle otherButtonTitle:(NSString*)otherTitle{
     [self removeMXRGlassLoadingView];
    self = [super init];
    if (self) {
        if (!title) {
            title = MXRLocalizedString(@"PROMPT", @"提示");
        }
        if (!IOS8_OR_LATER) {
            self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:customDelegate cancelButtonTitle:otherTitle otherButtonTitles:cancelTitle,nil];
            self.alertView.delegate = self;
            //防止ios7自动释放掉PromotView
            strongSelf = self;
        }
        else{
        
            self.alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction1 = nil;
            UIAlertAction *alertAction2 = nil;
            if (otherTitle && ![otherTitle isEqualToString:@""]) {
                alertAction1 = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([self.mxrDelegate respondsToSelector:@selector(promptView:didSelectAtIndex:)]) {
                        [self.mxrDelegate promptView:self didSelectAtIndex:0];
                    }
                    
                    if (self.buttonTapBlock) {
                        self.buttonTapBlock(self,0);
                    }
                    

                    [self cleanValue];
                }];
            }
            if (cancelTitle && ![cancelTitle isEqualToString:@""]) {
                alertAction2 = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([self.mxrDelegate respondsToSelector:@selector(promptView:didSelectAtIndex:)]) {
                        [self.mxrDelegate promptView:self didSelectAtIndex:1];
                    }
        
                    if (self.buttonTapBlock) {
                        self.buttonTapBlock(self,1);
                    }

                    [self cleanValue];
                }];
            }
            if (alertAction1) {
                [self.alertController addAction:alertAction1];
            }
            if (alertAction2) {
                [self.alertController addAction:alertAction2];
            }
        
        }
        self.mxrDelegate = customDelegate;

    }
    return self;
}

-(instancetype)initWithTitle:(NSString*)title message:(NSString*)message attributedMessage:(NSAttributedString*)attributedString delegate:(id<MXRPromptViewDelegate>)customDelegate cancelButtonTitle:(NSString*)cancelTitle otherButtonTitle:(NSString*)otherTitle
{
    [self removeMXRGlassLoadingView];
    self = [super init];
    if (self) {
        if (!title) {
            title = MXRLocalizedString(@"PROMPT", @"提示");
        }
        if (!IOS8_OR_LATER) {
            self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:customDelegate cancelButtonTitle:otherTitle otherButtonTitles:cancelTitle,nil];
            self.alertView.delegate = self;
        }
        else{
            self.alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            if (attributedString && ![attributedString isEqualToAttributedString:[[NSAttributedString alloc] initWithString:@""]]) {
                [self.alertController setValue:attributedString forKey:@"attributedMessage"];
            }
            
            UIAlertAction *alertAction1 = nil;
            UIAlertAction *alertAction2 = nil;
            if (otherTitle && ![otherTitle isEqualToString:@""]) {
                alertAction1 = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([self.mxrDelegate respondsToSelector:@selector(promptView:didSelectAtIndex:)]) {
                        [self.mxrDelegate promptView:self didSelectAtIndex:0];
                    }
              
                    if (self.buttonTapBlock) {
                        self.buttonTapBlock(self,0);
                    }
                    

                    [self cleanValue];
                }];
            }
            if (cancelTitle && ![cancelTitle isEqualToString:@""]) {
                alertAction2 = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([self.mxrDelegate respondsToSelector:@selector(promptView:didSelectAtIndex:)]) {
                        [self.mxrDelegate promptView:self didSelectAtIndex:1];
                    }

                    if (self.buttonTapBlock) {
                        self.buttonTapBlock(self,1);
                    }
                    [self cleanValue];

                }];
            }
            if (alertAction1) {
                [self.alertController addAction:alertAction1];
            }
            if (alertAction2) {
                [self.alertController addAction:alertAction2];
            }
            
        }
        self.mxrDelegate = customDelegate;

    }
    return self;

}





/**
 cancelButton 右侧的按钮，otherButton左侧按钮

 @param title <#title description#>
 @param message <#message description#>
 @param customDelegate <#customDelegate description#>
 @param cancelTitle <#cancelTitle description#>
 @param otherTitle <#otherTitle description#>
 @param buttonTapBlock <#buttonTapBlock description#>
 @return <#return value description#>
 */
-(instancetype)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id<MXRPromptViewDelegate>)customDelegate cancelButtonTitle:(NSString*)cancelTitle otherButtonTitle:(NSString*)otherTitle buttonTapBlock:(PromptViewButtonTapBlock) buttonTapBlock{
    [self removeMXRGlassLoadingView];
    self = [self initWithTitle:title message:message delegate:customDelegate cancelButtonTitle:cancelTitle otherButtonTitle:otherTitle];
    if (self) {
        self.buttonTapBlock = buttonTapBlock;
    }
    return self;
}

-(instancetype)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id<MXRPromptViewDelegate>)customDelegate otherButtonTitles:(NSArray*)otherTitles buttonTapBlock:(PromptViewButtonTapBlock) buttonTapBlock{
    [self removeMXRGlassLoadingView];
    self = [super init];
    if (self) {
        if (!title) {
            title = MXRLocalizedString(@"PROMPT", @"提示");
        }
        
        self.buttonTapBlock = buttonTapBlock;
        
        if (!IOS8_OR_LATER) {
            self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:customDelegate cancelButtonTitle:nil otherButtonTitles:otherTitles.count>=1?otherTitles[0]:nil,otherTitles.count>=2?otherTitles[1]:nil,otherTitles.count>=2?otherTitles[2]:nil,nil];
            self.alertView.delegate = self;
        }
        else{
            
            self.alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *alertAction1 = nil;
            UIAlertAction *alertAction2 = nil;
            UIAlertAction *alertAction3 = nil;
            if (otherTitles.count>=1 && ![otherTitles[0] isEqualToString:@""]) {
                alertAction1 = [UIAlertAction actionWithTitle:otherTitles[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([self.mxrDelegate respondsToSelector:@selector(promptView:didSelectAtIndex:)]) {
                        [self.mxrDelegate promptView:self didSelectAtIndex:0];
                    }
                    
                    if (self.buttonTapBlock) {
                        self.buttonTapBlock(self,0);
                    }
                    
                    [self cleanValue];
                }];
            }
            if (otherTitles.count>=2 && ![otherTitles[1] isEqualToString:@""]) {
                alertAction2 = [UIAlertAction actionWithTitle:otherTitles[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([self.mxrDelegate respondsToSelector:@selector(promptView:didSelectAtIndex:)]) {
                        [self.mxrDelegate promptView:self didSelectAtIndex:1];
                    }
                    
                    if (self.buttonTapBlock) {
                        self.buttonTapBlock(self,1);
                    }
                    
                    [self cleanValue];
                }];
            }
            if (otherTitles.count>=3 && ![otherTitles[2] isEqualToString:@""]) {
                alertAction3 = [UIAlertAction actionWithTitle:otherTitles[2] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([self.mxrDelegate respondsToSelector:@selector(promptView:didSelectAtIndex:)]) {
                        [self.mxrDelegate promptView:self didSelectAtIndex:2];
                    }
                    
                    if (self.buttonTapBlock) {
                        self.buttonTapBlock(self,2);
                    }
                    
                    [self cleanValue];
                }];
            }
            if (alertAction1) {
                [self.alertController addAction:alertAction1];
            }
            if (alertAction2) {
                [self.alertController addAction:alertAction2];
            }
            if (alertAction3) {
                [self.alertController addAction:alertAction3];
            }
            
        }
        self.mxrDelegate = customDelegate;
        
    }
    return self;

}

-(instancetype)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id<MXRPromptViewDelegate>)customDelegate otherButtonTitles:(NSArray*)otherTitles
{
    return [self initWithTitle:title message:message delegate:customDelegate otherButtonTitles:otherTitles buttonTapBlock:nil];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.mxrDelegate) {
        [self.mxrDelegate promptView:self didSelectAtIndex:(buttonIndex)];
    }

    if (self.buttonTapBlock) {
        self.buttonTapBlock(self,buttonIndex);
    }
    [self.alertView removeFromSuperview];
    self.alertView = nil;
    [self cleanValue];
}

-(void)showInLastViewController{

    if (IOS8_OR_LATER) {
        UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController *topVC;
        if (appRootVC.presentedViewController) {
            topVC = appRootVC.presentedViewController;
            if ([[topVC.childViewControllers lastObject] presentedViewController]) {
                topVC = [[topVC.childViewControllers lastObject] presentedViewController];
            }
        }else{
//            AppDelegate* app =  (AppDelegate*)[UIApplication sharedApplication].delegate;
//            topVC = app.navigationController;
        }
    
        [topVC presentViewController:self.alertController animated:NO completion:nil];
    }
    else
    {
         [self.alertView show];
    }
    
}

-(void)removeMXRGlassLoadingView{
//    for (UIView *view in APP_DELEGATE.window.subviews) {
//        if ([view isKindOfClass:[MXRGlassLoadingView class]]) {
//            MXRGlassLoadingView *loadingView = (MXRGlassLoadingView *)view;
//            if (loadingView.betweenTwoBook) {
//                [view removeFromSuperview];
//            }
//        }
//    }
}

-(void)showInCustomWindow{
    if (IOS8_OR_LATER) {
    
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.overlayWindow.transform = window.transform;
        self.overlayWindow.frame = window.frame;
        [self.overlayWindow setHidden:NO];
        //   [self.overlayWindow makeKeyAndVisible];
        UIViewController *vc = self.overlayWindow.rootViewController;
        [vc presentViewController:self.alertController animated:NO completion:nil];
    
    }else{
        [self.alertView show];
    }

   
}

- (UIWindow *)overlayWindow;
{
    if(_overlayWindow == nil) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = YES;
        _overlayWindow.windowLevel = UIWindowLevelStatusBar;
        _overlayWindow.rootViewController = [[UIViewController alloc] init];
        _overlayWindow.rootViewController.view.backgroundColor = [UIColor clearColor];
    }
    return _overlayWindow;
}


-(void)showOnViewController:(UIViewController *)vc{
    if (IOS8_OR_LATER) {
        [vc presentViewController:self.alertController animated:NO completion:nil];
    }
    else
    {
        [self.alertView show];
    }
}

-(void)hiden{
    
    if (IOS8_OR_LATER) {
        [self.alertController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.alertView dismissWithClickedButtonIndex:5 animated:NO];
    }
    [self cleanValue];
    
    if (self.overlayWindow) {
        self.overlayWindow.rootViewController = nil;
        [self.overlayWindow setHidden:YES];
        [self.overlayWindow removeFromSuperview];
        self.overlayWindow = nil;
    }
}


-(void)hideOnView{
    [self hiden];
}

-(void)dealloc{
    DLOG_METHOD;
}
@end


