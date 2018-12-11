//
//  UIView+MXRFrame.m
//  huashida_home
//
//  Created by yuchen.li on 17/2/28.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "UIView+MXRFrame.h"

@implementation UIView (MXRFrame)
- (CGFloat)mxr_left {
    return self.frame.origin.x;
}

- (void)setMxr_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)mxr_top {
    return self.frame.origin.y;
}

- (void)setMxr_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)mxr_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setMxr_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)mxr_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMxr_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)mxr_width {
    return self.frame.size.width;
}

- (void)setMxr_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)mxr_height {
    return self.frame.size.height;
}

- (void)setMxr_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)mxr_centerX {
    return self.center.x;
}

- (void)setMxr_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)mxr_centerY {
    return self.center.y;
}

- (void)setMxr_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)mxr_origin {
    return self.frame.origin;
}

- (void)setMxr_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)mxr_size {
    return self.frame.size;
}

- (void)setMxr_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}
@end
