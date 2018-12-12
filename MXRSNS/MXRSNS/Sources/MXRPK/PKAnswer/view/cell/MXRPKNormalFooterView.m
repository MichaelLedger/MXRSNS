//
//  MXRPKNormalFooterView.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKNormalFooterView.h"

@implementation MXRPKNormalFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.askHelpBtn.backgroundColor = [UIColor whiteColor];
    self.askHelpBtn.layer.masksToBounds = YES;
    self.askHelpBtn.layer.cornerRadius = 8;
}

- (void)setShareStyle:(BOOL)isShareStyle
{
    if (isShareStyle) {
        self.askHelpBtn.backgroundColor = MXRCOLOR_MAIN;
        [self.askHelpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        self.askHelpBtn.backgroundColor = [UIColor whiteColor];
        [self.askHelpBtn setTitleColor:MXRCOLOR_29AAFE forState:UIControlStateNormal];
    }
}

@end
