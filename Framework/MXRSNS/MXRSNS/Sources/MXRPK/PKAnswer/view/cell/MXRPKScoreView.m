//
//  MXRPKScoreView.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/23.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKScoreView.h"
#import "Masonry.h"

@interface MXRPKScoreView ()

@property (nonatomic, strong) UIView *scoreView;
@property (nonatomic, strong) UIView *scoreConatinerView;
@property (nonatomic, strong) MASConstraint *scoreViewHeight;
@end

@implementation MXRPKScoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    _scoreTotalLength = 1;
    _scoreViewBackgoundColor = MXRCOLOR_MAIN;
    [self addSubview:self.imageView];
    [self addSubview:self.scoreConatinerView];
    [self.scoreConatinerView addSubview:self.scoreView];
    
    __weak __typeof(self) weakSelf = self;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf).mas_offset(@(0));
        make.top.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(22, 20));
    }];
    
    @weakify(self)
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.scoreConatinerView);
        make.bottom.mas_equalTo(weakSelf.scoreConatinerView).mas_offset(@(-2));
        make.leading.mas_equalTo(weakSelf.scoreConatinerView).mas_offset(@(2));
        weak_self.scoreViewHeight = make.height.mas_equalTo(@(0));
    }];
    
    [self.scoreConatinerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom).mas_offset(@(10));
        make.width.mas_equalTo(@(14));
        make.centerX.mas_equalTo(weakSelf.imageView);
        make.bottom.mas_equalTo(weakSelf).mas_offset(@(0));
    }];
    
}

- (UIView *)scoreConatinerView
{
    if (!_scoreConatinerView) {
        _scoreConatinerView = [[UIView alloc] init];
    }
    return _scoreConatinerView;
}

- (UIView *)scoreView
{
    if (!_scoreView) {
        _scoreView = [[UIView alloc] init];
    }
    return _scoreView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (void)setScoreViewBackgoundColor:(UIColor *)scoreViewBackgoundColor
{
    _scoreViewBackgoundColor = scoreViewBackgoundColor;
    self.scoreView.backgroundColor = scoreViewBackgoundColor;
}

- (CGFloat)scoreTotalLength
{
    return MAX(1, _scoreTotalLength);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scoreConatinerView.layer.masksToBounds = YES;
    self.scoreConatinerView.layer.borderColor = MXRCOLOR_MAIN.CGColor;
    self.scoreConatinerView.layer.borderWidth = 1;
    self.scoreConatinerView.layer.cornerRadius = CGRectGetWidth(self.scoreConatinerView.frame)/2;
    
    self.scoreView.layer.masksToBounds = YES;
    self.scoreView.layer.cornerRadius = 5;
}

- (void)setLength:(CGFloat)length correct:(BOOL)isCorrect animated:(BOOL)animated
{
    NSString *imageName = @"icon_pk_score_incorrect";
    if (isCorrect) {
        imageName = @"icon_pk_score_correct";
    }
    self.imageView.image = MXRIMAGE(imageName);
    CGFloat mutiply = MIN(1, (float)length / (float)self.scoreTotalLength);

    [UIView animateWithDuration:0.25 animations:^{
        self.scoreViewHeight.mas_offset(@(CGRectGetHeight(self.scoreConatinerView.frame) * mutiply -4));
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
