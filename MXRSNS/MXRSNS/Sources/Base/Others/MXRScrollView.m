//
//  MXRScrollView.m
//  huashida_home
//
//  Created by 周建顺 on 16/6/24.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRScrollView.h"

@implementation MXRScrollView


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // 当触发滑动返回时，禁止滑动
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;
    
}

#pragma mark -
// && self.contentOffset.x <= 0 &&  && location.x < 30

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:self];
            if (point.x > 0 && self.contentOffset.x <= 0 && location.x < 30 ) {
                return YES;
            }
        }
    }
    return NO;
}

@end
