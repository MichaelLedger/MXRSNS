//
//  MXRWrongAnalysisAnswerTextCell.m
//  huashida_home
//
//  Created by MountainX on 2018/8/16.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRWrongAnalysisAnswerTextCell.h"

@interface MXRWrongAnalysisAnswerTextCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateIv;
@property (weak, nonatomic) IBOutlet UIView *shadowBg;

@end

@implementation MXRWrongAnalysisAnswerTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgView.layer.borderColor = MXRCOLOR_93D75C.CGColor;
    _bgView.layer.borderWidth = 1.f;
    
    _answerLabel.layer.shadowColor = MXRCOLOR_666666.CGColor;
    _answerLabel.layer.shadowOffset = CGSizeMake(5, 5);
    
    _shadowBg.layer.cornerRadius = 8.f;
    _shadowBg.layer.shadowOpacity = 0.5f;
    _shadowBg.layer.shadowOffset = CGSizeMake(1, 2);
    _shadowBg.layer.shadowColor = MXRCOLOR_666666.CGColor;
}

- (void)setAnswer:(MXRPKAnswerOption *)answer {
    _answer = answer;
    _answerLabel.text = autoString(_answer.word);
    
    if (answer.correct) {
        [self renderSelectRightUI];
    } else {
        if (_selectedAnswers && [_selectedAnswers containsObject:@(answer.answerId)]) {
            [self renderSelectWrongUI];
        } else {
            [self renderUnselectUI];
        }
    }
}

- (void)renderSelectRightUI {
    _stateIv.image = MXRIMAGE(@"icon_analysis_select_right");
    _stateIv.backgroundColor = MXRCOLOR_93D75C;
    _bgView.layer.borderColor = MXRCOLOR_93D75C.CGColor;
}

- (void)renderSelectWrongUI {
    _stateIv.image = MXRIMAGE(@"icon_analysis_select_wrong");
    _stateIv.backgroundColor = MXRCOLOR_FAD22F;
    _bgView.layer.borderColor = MXRCOLOR_FAD22F.CGColor;
}

- (void)renderUnselectUI {
    _stateIv.image = nil;
    _stateIv.backgroundColor = MXRCOLOR_DDDDDD;
    _bgView.layer.borderColor = MXRCOLOR_DDDDDD.CGColor;
}

@end
