//
//  MXRUIButton.m
//  huashida_home
//
//  Created by Martin.liu on 2017/11/14.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRUIButton.h"

@implementation MXRUIButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (_imagePosition == MXRUIButtonImagePositionLeft) {
        return;
    }
    
    CGRect imageFrame = self.imageView.frame;
    CGRect labelFrame = self.titleLabel.frame;
    
    labelFrame.origin.x = imageFrame.origin.x - self.imageEdgeInsets.left + self.imageEdgeInsets.right;
    imageFrame.origin.x += labelFrame.size.width;
    
    self.imageView.frame = imageFrame;
    self.titleLabel.frame = labelFrame;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_imagePosition == MXRUIButtonImagePositionLeft) {
        return;
    }
    
    CGRect imageFrame = self.imageView.frame;
    CGRect labelFrame = self.titleLabel.frame;
    
    labelFrame.origin.x = imageFrame.origin.x - self.imageEdgeInsets.left + self.imageEdgeInsets.right;
    imageFrame.origin.x += labelFrame.size.width;
    
    self.imageView.frame = imageFrame;
    self.titleLabel.frame = labelFrame;
}

@end
