//
//  UIView+MXRSnapshot.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/10/20.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "UIView+MXRSnapshot.h"

@implementation UIView (MXRSnapshot)

- (UIImage *)mxr_snapshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    // have issue somtehings
//    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
//        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
//    }
//    else
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

@end
