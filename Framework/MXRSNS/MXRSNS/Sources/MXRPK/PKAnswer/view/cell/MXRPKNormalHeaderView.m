//
//  MXRPKNormalHeaderView.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKNormalHeaderView.h"
#import "MXRPKResponseModel.h"
#import <MAREXT/MARLabel.h>
@interface MXRPKNormalHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *questionTypeImageView;
@property (weak, nonatomic) IBOutlet MARLabel *questionTypeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *shareTipImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_shareTipImageTop;

@end

@implementation MXRPKNormalHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.questionTypeLabel.text = nil;
    self.questionTypeLabel.edgeInsets = UIEdgeInsetsMake(5, 35, 18, 35);
    [self setShareStyle:NO];
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[NSString class]]) {
        self.questionContentLabel.text = data;
    }
    if ([data isKindOfClass:[MXRPKQuestionModel class]]) {
        MXRPKQuestionModel *model = data;
        self.questionContentLabel.text = model.questionContent.word;
        NSInteger countOfCorrectAnswer = [self correctOptionSet:model].allObjects.count;
        if (countOfCorrectAnswer > 1) {
            self.questionTypeLabel.text = [NSString stringWithFormat:@"%ld个答案", (long)countOfCorrectAnswer];
            self.questionTypeImageView.image = MXRIMAGE(@"icon_pk_mutiple_choose");
        }
        else
        {
            self.questionTypeLabel.text = @"单选";
            self.questionTypeImageView.image = MXRIMAGE(@"icon_pk_single_choose");
        }
    }
}

- (void)setShareStyle:(BOOL)isShareStyle
{
    if (isShareStyle) {
        self.constraint_shareTipImageTop.constant = 15;
    }
    else
        self.constraint_shareTipImageTop.constant = -100;
    [self layoutIfNeeded];
    self.shareTipImageView.hidden = !isShareStyle;
}

- (NSMutableSet *)correctOptionSet:(MXRPKQuestionModel *)model
{
    NSMutableSet *correctSet = [NSMutableSet setWithCapacity:1<<3];
    for (int i = 0; i < model.answers.count; i ++) {
        MXRPKAnswerOption *option = model.answers[i];
        if (option.correct) {
            [correctSet addObject:@(i)];
        }
    }
    return correctSet;
}

@end
