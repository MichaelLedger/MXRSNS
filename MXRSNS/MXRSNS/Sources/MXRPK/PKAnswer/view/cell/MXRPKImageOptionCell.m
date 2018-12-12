//
//  MXRPKImageOptionCell.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/19.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKImageOptionCell.h"
#import "UIImageView+WebCache.h"
#import "MXRPKResponseModel.h"
#import <NSString+MAREX.h>
@interface MXRPKImageOptionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *answerTextContainer;
@property (weak, nonatomic) IBOutlet UILabel *answerTextLabel;

@property (nonatomic, strong) MXRPKAnswerOption *answerOptionModel;

@end

@implementation MXRPKImageOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 8;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 5;
}

- (void)setMxr_selected:(BOOL)mxr_selected
{
    _mxr_selected = mxr_selected;
    self.imageView.layer.borderColor = _mxr_selected ? MXRCOLOR_93D75C.CGColor : [UIColor whiteColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
//    self.mxr_selected = selected;
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[NSString class]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:data ?: @""] placeholderImage:nil];
    }
    if ([data isKindOfClass:[MXRPKAnswerOption class]]) {
        MXRPKAnswerOption *model = data;
        self.answerOptionModel = model;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.pic ?: @""] placeholderImage:nil];
        if ([model.word mar_stringByTrim].length > 0) {
            self.answerTextContainer.hidden = NO;
            self.answerTextLabel.text = model.word;
        }
        else
            self.answerTextContainer.hidden = YES;
    }
}

- (void)showResult
{
//    if (self.answerOptionModel.correct) {
//        self.imageView.layer.borderColor = MXRCOLOR_93D75C.CGColor;
//    }
//    else if (self.mxr_selected)
//    {
//        self.imageView.layer.borderColor = MXRCOLOR_FAD22F.CGColor;
//    }
//    else
//    {
//        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    }
    if (self.mxr_selected) {
        if (self.answerOptionModel.correct) {
            self.imageView.layer.borderColor = MXRCOLOR_93D75C.CGColor;
        }
        else
        {
           self.imageView.layer.borderColor = MXRCOLOR_FAD22F.CGColor;
        }
    }
    else
    {
        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

@end
