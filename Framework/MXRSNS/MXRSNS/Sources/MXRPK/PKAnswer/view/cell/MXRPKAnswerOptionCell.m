//
//  MXRPKAnswerOptionCell.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKAnswerOptionCell.h"
#import "MXRPKResponseModel.h"
#define MXRPKAnswerOptionCorrectImageName @"icon_pk_answer_correct"
#define MXRPKAnswerOptionIncorrectImageName @"icon_pk_answer_incorrect"

@interface MXRPKAnswerOptionCell ()
@property (weak, nonatomic) IBOutlet UIView *shadowContainerView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *optionBackImageView;

@property (nonatomic, strong) MXRPKAnswerOption *answerOptionModel;
@end

@implementation MXRPKAnswerOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 6;
    self.shadowContainerView.layer.cornerRadius = 6;
    self.shadowContainerView.layer.shadowColor=[UIColor grayColor].CGColor;
    self.shadowContainerView.layer.shadowOffset=CGSizeMake(2,2);
    self.shadowContainerView.layer.shadowOpacity=0.3;
    self.shadowContainerView.backgroundColor = [UIColor clearColor];
    self.checkImageView.hidden = YES;
    
    self.contentLabel.text = nil;
    self.checkImageView.hidden = YES;
//    self.checkImageView.image = [UIImage imageNamed:@"icon_pk_answer_selected"];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
//    self.mxr_selected = selected;
}

- (void)setMxr_selected:(BOOL)mxr_selected
{
    _mxr_selected = mxr_selected;
    if (_mxr_selected) {
        self.containerView.backgroundColor = MXRCOLOR_93D75C;
    }
    else
    {
       self.containerView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[NSString class]]) {
        self.contentLabel.text = data;
    }
    if ([data isKindOfClass:[MXRPKAnswerOption class]]) {
        MXRPKAnswerOption *model = data;
        _answerOptionModel = model;
        self.contentLabel.text = model.word;
    }
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.optionBackImageView.hidden = YES;
}

- (void)setShareCellStyle
{
    self.containerView.backgroundColor = [UIColor clearColor];
    self.optionBackImageView.hidden = NO;
    
}

- (void)showResult
{
//    if (self.answerOptionModel.correct) {
//        self.containerView.backgroundColor = MXRCOLOR_93D75C;
//        self.checkImageView.hidden = NO;
//        self.checkImageView.image = [UIImage imageNamed:MXRPKAnswerOptionCorrectImageName];
//    }
//    else if (self.mxr_selected)
//    {
//        self.containerView.backgroundColor = MXRCOLOR_FAD22F;
//        self.checkImageView.hidden = NO;
//        self.checkImageView.image = [UIImage imageNamed:MXRPKAnswerOptionIncorrectImageName];
//    }
//    else
//    {
//        self.containerView.backgroundColor = [UIColor whiteColor];
//        self.checkImageView.hidden = YES;
//    }
    if (self.mxr_selected) {
        if (self.answerOptionModel.correct) {
            self.containerView.backgroundColor = MXRCOLOR_93D75C;
            self.checkImageView.hidden = NO;
            self.checkImageView.image = MXRIMAGE(MXRPKAnswerOptionCorrectImageName);
        }
        else
        {
            self.containerView.backgroundColor = MXRCOLOR_FAD22F;
            self.checkImageView.hidden = NO;
            self.checkImageView.image = MXRIMAGE(MXRPKAnswerOptionIncorrectImageName);
        }
    }
    else
    {
        self.containerView.backgroundColor = [UIColor whiteColor];
        self.checkImageView.hidden = YES;
    }
}

@end
