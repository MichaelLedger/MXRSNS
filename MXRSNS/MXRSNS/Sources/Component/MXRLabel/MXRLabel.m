//
//  MXRLabel.m
//  huashida_home
//
//  Created by MXRtin.liu on 2017/9/4.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRLabel.h"

@interface MXRLabel()

/**
 tmp edgeinsets
 */
@property (nonatomic, assign) UIEdgeInsets tmpEdgeInsets;

@end

@implementation MXRLabel

@synthesize edgeInsets;

- (void)drawRect:(CGRect)rect

{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
    
}


- (CGSize)intrinsicContentSize

{
    
    CGSize size = [super intrinsicContentSize];
    
    size.width += self.edgeInsets.left + self.edgeInsets.right;
    
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    
    return size;
    
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsetsV
{
    self.tmpEdgeInsets = edgeInsetsV;
    edgeInsets = edgeInsetsV;
    [self setNeedsDisplay];
}

@end
