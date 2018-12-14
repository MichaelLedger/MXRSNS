//
//  MXRSNSCommentView.m
//  huashida_home
//
//  Created by shuai.wang on 2017/8/1.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSNSCommentView.h"
#import "NSString+Ex.h"
#define Space 20.f
@implementation MXRSNSCommentView


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.senderButton setTitle:MXRLocalizedString(@"SEND_BUTTON",@"发送") forState:UIControlStateNormal];
    [self.senderButton setTitleColor:MXRCOLOR_FFFFFF forState:UIControlStateNormal];
    self.senderButton.titleLabel.font = MXRFONT_14;
    [self.senderButton.layer setMasksToBounds:YES];
    [self.senderButton.layer setCornerRadius:2.5];
    self.senderButton.backgroundColor = MXRCOLOR_2FB8E2;
    self.senderBtnWidth.constant = [NSString caculateText:MXRLocalizedString(@"SEND_BUTTON",@"发送") andTextLabelSize:CGSizeMake(200, 40) andFont:MXRFONT_14].width + Space;
    
    [self.textField.layer setMasksToBounds:YES];
    [self.textField.layer setCornerRadius:2.5];
    self.textField.backgroundColor = MXRCOLOR_FFFFFF;
    self.textField.placeholder = MXRLocalizedString(@"Comment_Please_InputComment_Content", @"请输入评论内容");
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = MXRCOLOR_E7E7E7.CGColor;
}

@end
