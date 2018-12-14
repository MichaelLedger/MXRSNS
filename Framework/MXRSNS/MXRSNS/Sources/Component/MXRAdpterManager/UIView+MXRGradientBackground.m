//
//  UIView+MXRGradientBackground.m
//  huashida_home
//
//  Created by Martin.liu on 2017/11/14.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "UIView+MXRGradientBackground.h"
#import <objc/runtime.h>

static char kGradientLayerKey;

@implementation UIView (MXRGradientBackground)

- (CAGradientLayer *)gradientLayer
{
    CAGradientLayer *gradientLayer = objc_getAssociatedObject(self, &kGradientLayerKey);
    if (!gradientLayer) {
        gradientLayer = [CAGradientLayer layer];
        objc_setAssociatedObject(self, &kGradientLayerKey, gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return gradientLayer;
}

- (void)mxr_setGradientWithColors:(NSArray *)colors direction:(MXRUIViewLinearGradientDirection)direction
{
    CAGradientLayer *gradient = self.gradientLayer;
    gradient.frame = self.bounds;
    
    NSMutableArray *mutableColors = colors.mutableCopy;
    for (int i = 0; i < colors.count; i++) {
        UIColor *currentColor = colors[i];
        [mutableColors replaceObjectAtIndex:i withObject:(id)currentColor.CGColor];
    }
    gradient.colors = mutableColors;
    
    switch (direction) {
        case MXRUIViewLinearGradientDirectionVertical: {
            gradient.startPoint = CGPointMake(0.5f, 0.0f);
            gradient.endPoint = CGPointMake(0.5f, 1.0f);
            break;
        }
        case MXRUIViewLinearGradientDirectionHorizontal: {
            gradient.startPoint = CGPointMake(0.0f, 0.5f);
            gradient.endPoint = CGPointMake(1.0f, 0.5f);
            break;
        }
        case MXRUIViewLinearGradientDirectionDiagonalFromLeftToRightAndTopToDown: {
            gradient.startPoint = CGPointMake(0.0f, 0.0f);
            gradient.endPoint = CGPointMake(1.0f, 1.0f);
            break;
        }
        case MXRUIViewLinearGradientDirectionDiagonalFromLeftToRightAndDownToTop: {
            gradient.startPoint = CGPointMake(0.0f, 1.0f);
            gradient.endPoint = CGPointMake(1.0f, 0.0f);
            break;
        }
        case MXRUIViewLinearGradientDirectionDiagonalFromRightToLeftAndTopToDown: {
            gradient.startPoint = CGPointMake(1.0f, 0.0f);
            gradient.endPoint = CGPointMake(0.0f, 1.0f);
            break;
        }
        case MXRUIViewLinearGradientDirectionDiagonalFromRightToLeftAndDownToTop: {
            gradient.startPoint = CGPointMake(1.0f, 1.0f);
            gradient.endPoint = CGPointMake(0.0f, 0.0f);
            break;
        }
    }
    [self.layer insertSublayer:gradient atIndex:0];
}

- (void)mxr_setGradientBackGoundStyle:(MXRUIViewGradientStyle)style direction:(MXRUIViewLinearGradientDirection)direction
{
    NSArray *colors = nil;
    switch (style) {
        case MXRUIViewGradientStyleLightGreen:
            colors = @[MXRCOLOR_80F0EA, MXRCOLOR_29AAFE];
            break;
        case MXRUIViewGradientStylePink:
            colors = @[MXRCOLOR_DDB4FE, MXRCOLOR_FF76B9];
            break;
        case MXRUIViewGradientStyleLightGreen2:
            colors = @[MXRCOLOR_29AAFE, MXRCOLOR_80F0EA];
            break;
        case MXRUIViewGradientStyleDarkGreen:
            colors = @[MXRCOLOR_29AAFE, MXRCOLOR_80F0EA];
            break;
        case MXRUIViewGradientStyle_F3F4F6_White:
            colors = @[MXRCOLOR_F3F4F6, [UIColor whiteColor]];
            break;
        case MXRUIViewGradientStyleDarkGreenMain:
            colors = @[MXRCOLOR_29AAFE, MXRCOLOR_80F0EA];
            break;
        case MXRUIViewGradientStyle_009FD8_022D71:
             colors = @[RGBHEX(0x009FD8), RGBHEX(0x022D71)];
            break;
        case MXRUIViewGradientStyle_80F0EA_29AAFE:
            colors = @[RGBHEX(0x80F0EA), RGBHEX(0x29AAFE)];
            break;
        case MXRUIViewGradientStyle_VIPButton:
            colors = @[RGBHEX(0xF5D895), RGBHEX(0xD29228)];
            break;
        case MXRUIViewGradientStyle_FF405F_FF7A4D:
            colors = @[RGBHEX(0xFF405F), RGBHEX(0xFF7A4D)];
            break;
        case MXRUIViewGradientStyle_FF7A4D_FF405F:
            colors = @[RGBHEX(0xFF7A4D), RGBHEX(0xFF405F)];
            break;
        case MXRUIViewGradientStyle_FF6A5C_FF392F:
            colors = @[RGBHEX(0xFF6A5C), RGBHEX(0xFF392F)];
            break;
        case MXRUIViewGradientStyle_F5D895_D29228:
            colors = @[RGBHEX(0xF5D895), RGBHEX(0xD29228)];
            break;
        case MXRUIViewGradientStyle_B4EC51_429321:
            colors = @[RGBHEX(0xB4EC51), RGBHEX(0x429321)];
            break;
        case MXRUIViewGradientStyle_FAD961_F76B1C:
            colors = @[RGBHEX(0xFAD961), RGBHEX(0xF76B1C)];
            break;
        default:
            break;
    }
    if (colors && colors.count > 1) {
        [self mxr_setGradientWithColors:colors direction:direction];
    }
}

- (void)mxr_setGradientBackGoundStyle:(MXRUIViewGradientStyle)style
{
    [self mxr_setGradientBackGoundStyle:style direction:MXRUIViewLinearGradientDirectionHorizontal];
}

@end
