//
//  MXRCountDownView.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/21.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRCountDownView.h"
#import <POP.h>
#import "Masonry.h"

@interface MXRCountDownView ()
@property (nonatomic, strong) CAShapeLayer* fixedLayer;
@property (nonatomic, strong) CAShapeLayer* indicatorLayer;
@property (nonatomic, strong) UILabel* countLabel;
@end

@implementation MXRCountDownView
{
    CGFloat borderWidth;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _maxValue = 10000;
    borderWidth = 5;
    self.backgroundColor = [UIColor clearColor];
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.text = @"0";
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = MXRFONT(18.f);
        _countLabel.adjustsFontSizeToFitWidth = YES;
        _countLabel.backgroundColor = MXRCOLOR_MAIN;
//        [_countLabel sizeToFit];
        [self addSubview:_countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.leading.mas_equalTo(self).with.mas_offset(@(12));
            make.top.mas_equalTo(self).with.mas_offset(@(12));
        }];
    }
    return _countLabel;
}

- (void)setValue:(NSInteger)value
{
    if (_value != value) {
        _value = MIN(value, _maxValue);
    }
    [self layoutAnimatedLayer];
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        [self layoutAnimatedLayer];
    }
    else
    {
        [_indicatorLayer pop_removeAnimationForKey:@"indicatorCountDown"];
        [_indicatorLayer removeFromSuperlayer];
        _indicatorLayer = nil;
        [_fixedLayer removeFromSuperlayer];
        _fixedLayer = nil;
        [self.countLabel pop_removeAnimationForKey:@"labelCount"];
        [self.countLabel removeFromSuperview];
        self.countLabel = nil;
    }
}

- (void)setFrame:(CGRect)frame {
    if(!CGRectEqualToRect(frame, super.frame)){
        [super setFrame:frame];
        
    }
    if (self.superview) {
        [self layoutAnimatedLayer];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _countLabel.layer.masksToBounds = YES;
    _countLabel.layer.cornerRadius = CGRectGetWidth(_countLabel.frame) / 2;
}

- (void)layoutAnimatedLayer
{
    NSInteger countDown = _value;
    CGFloat round = (_maxValue - countDown) / 30.f * M_PI * 2;
    if (!_fixedLayer) {
        _fixedLayer = [CAShapeLayer layer];
    }
    
    UIBezierPath* fixedPath = [UIBezierPath bezierPath] ;
    //    [fixedPath addArcWithCenter:CGPointMake(self.width/2,self.height/2) radius:MIN(self.width, self.height)/2 - borderWidth startAngle: -M_PI/2  endAngle:-M_PI/2 + round  clockwise:YES];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    [fixedPath addArcWithCenter:CGPointMake(width/2,height/2) radius:MIN(width, height)/2 - borderWidth startAngle: 0  endAngle:M_PI * 2  clockwise:YES];
    _fixedLayer.path = fixedPath.CGPath;
    _fixedLayer.fillColor = [UIColor clearColor].CGColor;
    _fixedLayer.strokeColor = [UIColor colorWithWhite:0.2 alpha:0.2].CGColor;
    _fixedLayer.lineWidth = borderWidth;
    CGRect fixFrame = self.frame;
    fixFrame.origin = CGPointZero;
    _fixedLayer.frame = fixFrame;
    [self.layer addSublayer:_fixedLayer];
    
    if (!_indicatorLayer) {
        _indicatorLayer = [CAShapeLayer layer];
    }
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(width/2, height/2) radius:MIN(width, height)/2 - borderWidth startAngle:-M_PI/2 + round endAngle:-M_PI/2 + M_PI*2 clockwise:YES];
    _indicatorLayer.path = path.CGPath;
    _indicatorLayer.fillColor = [UIColor clearColor].CGColor;
    _indicatorLayer.strokeColor = RGBHEX(0xFF7A4D).CGColor; // [UIColor whiteColor].CGColor;
    _indicatorLayer.lineWidth = borderWidth;
    fixFrame = self.frame;
    fixFrame.origin = CGPointZero;
    _indicatorLayer.frame = fixFrame;
    [self.layer addSublayer:_indicatorLayer];
    
    [_indicatorLayer pop_removeAnimationForKey:@"indicatorCountDown"];
    POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeStart];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = countDown;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    [_indicatorLayer pop_addAnimation:animation forKey:@"indicatorCountDown"];
    
    [self.countLabel pop_removeAnimationForKey:@"labelCount"];
    
    
    POPAnimatableProperty* propperty = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
        [prop setReadBlock:^(id obj, CGFloat values[]) {
            values[0] = [[obj description] floatValue];
        }];
        [prop setWriteBlock:^(id obj, const CGFloat values[]) {
            [obj setText:[NSString stringWithFormat:@"%.f",values[0]]];
        }];
       
    }];
    POPBasicAnimation* anim = [POPBasicAnimation animation];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.property = propperty;
    anim.fromValue = @(_value);
    anim.toValue = @(0);
    anim.duration = _value;
    __weak __typeof(self) weakSelf = self;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            weakSelf.value = 0;
            if (self.finishCallback) {
                self.finishCallback();
            }
        }
    }];
    [self.countLabel pop_addAnimation:anim forKey:@"labelCount"];
}

@end
