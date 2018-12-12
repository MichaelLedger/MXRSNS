//
//  MXRWrongAnalysisAnswerImageCell.m
//  huashida_home
//
//  Created by MountainX on 2018/8/16.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRWrongAnalysisAnswerImageCell.h"
//#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface MXRWrongAnalysisAnswerImageCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *stateIv;
@property (weak, nonatomic) IBOutlet UIImageView *answerIv;
@property (weak, nonatomic) IBOutlet UILabel *answerTextLabel;
@property (weak, nonatomic) IBOutlet UIView *shadowBg;

@end

@implementation MXRWrongAnalysisAnswerImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgView.layer.borderWidth = 1.f;
//    _bgView.layer.borderColor = MXRCOLOR_FAD22F.CGColor;
    
    _shadowBg.layer.cornerRadius = 8.f;
    _shadowBg.layer.shadowOpacity = 0.5f;
    _shadowBg.layer.shadowOffset = CGSizeMake(1, 2);
    _shadowBg.layer.shadowColor = MXRCOLOR_666666.CGColor;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_answerTextLabel.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8,8)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _answerTextLabel.bounds;
//    maskLayer.path = maskPath.CGPath;
//    _answerTextLabel.layer.mask = maskLayer;
//}

- (void)setAnswer:(MXRPKAnswerOption *)answer {
    _answer = answer;
    [_answerIv sd_setImageWithURL:[NSURL URLWithString:_answer.pic]];
    _answerTextLabel.text = autoString(_answer.word);
    
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
