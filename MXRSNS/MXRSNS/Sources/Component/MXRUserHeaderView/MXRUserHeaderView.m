//
//  MXRUserHeaderView.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/8/27.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRUserHeaderView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "MXRLabel.h"

@interface MXRUserHeaderView ()
@property (nonatomic, strong) UIImageView *userHeaderImageView;
@property (nonatomic, strong) UIImageView *vipImageView;
@property (nonatomic, strong) UIView *borderView;

@property (nonatomic, strong) MXRLabel *vipLabel;
@property (nonatomic, strong) CAGradientLayer *vipLabelBackLayer;

@property (nonatomic, strong) MASConstraint *userHeaderImageViewEdges;
@property (nonatomic, strong) MASConstraint *borderViewEdges;
@property (nonatomic, strong) MASConstraint *vipImageViewEdges;

@end

@implementation MXRUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setupViews];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    [self setupViews];
    return self;
}

- (void)setupViews
{
    _vip = NO;
    _hasOutsideBorder = NO;
    _placeHolderheaderImage = MXRIMAGE(@"icon_common_default_head");
    _userHeaderPadding = 1;
    _userHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.userHeaderImageView];
    if (self.userHeaderImageViewEdges) {
        self.userHeaderImageViewEdges.mas_equalTo(UIEdgeInsetsMake(_userHeaderPadding, _userHeaderPadding, _userHeaderPadding, _userHeaderPadding));
    }
    else
    {
        @weakify(self)
        [self.userHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            weak_self.userHeaderImageViewEdges = make.edges.mas_equalTo(UIEdgeInsetsMake(_userHeaderPadding, _userHeaderPadding, _userHeaderPadding, _userHeaderPadding));
        }];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.userHeaderImageView.layer.masksToBounds = YES;
    CGFloat cornerRadius = MIN(CGRectGetWidth(self.userHeaderImageView.frame), CGRectGetHeight(self.userHeaderImageView.frame))/2;
    self.userHeaderImageView.layer.cornerRadius = cornerRadius;
    // 梦想圈专有
    if (_hasVIPLabel) {
        self.userHeaderImageView.layer.borderColor = RGB(0xE0, 0xE0, 0xE0).CGColor;
        self.userHeaderImageView.layer.borderWidth = 1;
    }
    
    if (_hasOutsideBorder) {
        self.borderView.bounds = self.bounds;
        cornerRadius = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))/2;
        self.borderView.layer.cornerRadius = cornerRadius;
    }
    
    if (_vip && _hasVIPLabel) {
        self.vipLabelBackLayer.masksToBounds = YES;
        self.vipLabelBackLayer.cornerRadius = MAX(3, CGRectGetHeight(self.vipLabel.frame) / 2);
        
        self.vipLabelBackLayer.frame = self.vipLabel.frame;
        self.vipLabelBackLayer.colors = [NSArray arrayWithObjects:
                           (id)RGBHEX(0xFF6A5C).CGColor,
                           (id)RGBHEX(0xFF392F).CGColor,
                           nil];
        self.vipLabelBackLayer.startPoint = CGPointMake(0, .5);
        self.vipLabelBackLayer.endPoint = CGPointMake(1, .5);
//        [self.vipLabel.layer insertSublayer:self.vipLabelBackLayer atIndex:0];
        [self.layer addSublayer:self.vipLabelBackLayer];
        [self bringSubviewToFront:self.vipLabel];
    }
    else
        [_vipLabelBackLayer removeFromSuperlayer];
}

- (UIImageView *)userHeaderImageView
{
    if (!_userHeaderImageView) {
        _userHeaderImageView = [UIImageView new];
        _userHeaderImageView.image = self.placeHolderheaderImage;
    }
    return _userHeaderImageView;
}

- (UIView *)borderView
{
    if (!_borderView) {
        _borderView = [UIView new];
        _borderView.layer.masksToBounds = YES;
        _borderView.backgroundColor = [UIColor clearColor];
        _borderView.layer.borderColor = MXRCOLOR_MAIN.CGColor;
        _borderView.layer.borderWidth = 1;
        [self addSubview:_borderView];
        @weakify(self)
        [_borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            weak_self.borderViewEdges = make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _borderView;
}

- (UIImageView *)vipImageView
{
#ifdef MXRBOOKCITY
    if (!_vipImageView) {
        _vipImageView = [UIImageView new];
        _vipImageView.image = MXRIMAGE(@"icon_common_vipuserheader");
        _vipImageView.contentMode = UIViewContentModeScaleAspectFit;
        _vipImageView.hidden = YES;
        [self addSubview:_vipImageView];
        CGFloat padding = 0;
        CGFloat userHeaderImageWidth = (CGRectGetWidth(self.frame) - _userHeaderPadding * 2 );
        padding = _userHeaderPadding - userHeaderImageWidth * 1 / 4;
        UIEdgeInsets vipEdge = UIEdgeInsetsMake(padding, padding, padding, padding);
        @weakify(self)
        [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            weak_self.vipImageViewEdges = make.edges.mas_equalTo(vipEdge);
        }];
    }
#endif
    return _vipImageView;
}

- (MXRLabel *)vipLabel
{
#ifdef MXRBOOKCITY
    if (!_vipLabel) {
        _vipLabel = [[MXRLabel alloc] init];
        [self addSubview:_vipLabel];
        _vipLabel.text = @"VIP会员";

        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:ceilf(MXRFONTSIZE(8))];
        if (!font) {
            font = MXRFONT(8);
        }
        _vipLabel.font = font;
        _vipLabel.textAlignment = NSTextAlignmentCenter;
        _vipLabel.edgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
        // 防止cell点击颜色变成透明
        //        _vipLabel.layer.backgroundColor = RGBHEX(0xFF392F).CGColor;
        _vipLabel.textColor = [UIColor whiteColor];
        [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_bottom).mas_offset(@(10 - _userHeaderPadding));
            make.centerX.mas_equalTo(self);
        }];
        _vipLabel.userInteractionEnabled = NO;
    }
#endif
    return _vipLabel;
}

- (CAGradientLayer *)vipLabelBackLayer
{
#ifdef MXRBOOKCITY
    if (!_vipLabelBackLayer) {
        _vipLabelBackLayer = [CAGradientLayer layer];
    }
#endif
    return _vipLabelBackLayer;
}

#pragma mark - Setter
- (void)setHeaderUrl:(NSString *)headerUrl
{
    _headerUrl = headerUrl;
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:_headerUrl ?: @""] placeholderImage:self.placeHolderheaderImage];
}

- (void)setHeaderImage:(UIImage *)headerImage
{
    _headerImage = headerImage;
    self.userHeaderImageView.image = _headerImage;
}

- (void)setVip:(BOOL)vip
{
    _vip = vip;
    if ([_vipImageView superview] || _vip) {
        self.vipImageView.hidden = !_vip;
    }
    _vipLabel.hidden = !vip;
    [self setNeedsLayout];
}

- (void)setHasVipCrown:(BOOL)hasVipCrown
{
    _hasVipCrown = hasVipCrown;
    if (_hasVipCrown) {
        self.vipImageView.image = MXRIMAGE(@"icon_common_vipcrownuserheader");
    }
    else
        self.vipImageView.image = MXRIMAGE(@"icon_common_vipuserheader");
    [self setVip:_vip];
}

- (void)setHasVIPLabel:(BOOL)hasVIPLabel
{
    _hasVIPLabel = hasVIPLabel;
    if (_hasVIPLabel) {
        [self vipLabel];
    }
    _vipLabel.hidden = !_vip;
    [self setNeedsLayout];
}


- (void)setHasOutsideBorder:(BOOL)hasOutsideBorder
{
    self.userHeaderImageView.backgroundColor = [UIColor whiteColor];
    _hasOutsideBorder = hasOutsideBorder;
    self.borderView.hidden = !hasOutsideBorder;
}

- (void)setUserHeaderPadding:(CGFloat)userHeaderPadding
{
    if (_userHeaderPadding != userHeaderPadding) {
        _userHeaderPadding = userHeaderPadding;
        
        CGFloat padding = _userHeaderPadding;
        if (self.userHeaderImageViewEdges) {
            self.userHeaderImageViewEdges.mas_equalTo(UIEdgeInsetsMake(_userHeaderPadding, _userHeaderPadding, _userHeaderPadding, _userHeaderPadding));
        }
        
        padding = MAX(_userHeaderPadding - 1, 0);
        UIEdgeInsets borderInsets = UIEdgeInsetsMake(padding, padding, padding, padding);
        if (self.borderViewEdges) {
            self.borderViewEdges.mas_equalTo(borderInsets);
        }
        else{
            @weakify(self)
            [_borderView mas_makeConstraints:^(MASConstraintMaker *make) {
                weak_self.borderViewEdges = make.edges.mas_equalTo(borderInsets);
            }];
        }
        
        CGFloat userHeaderImageWidth = (CGRectGetWidth(self.frame) - _userHeaderPadding * 2 );
        padding = _userHeaderPadding - userHeaderImageWidth * 1 / 4;
        UIEdgeInsets vipEdge = UIEdgeInsetsMake(padding, padding, padding, padding);
        if (self.vipImageViewEdges) {
            self.vipImageViewEdges.mas_equalTo(vipEdge);
        }
        else{
            @weakify(self)
            [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                weak_self.vipImageViewEdges = make.edges.mas_equalTo(vipEdge);
            }];
        }
        
        [self layoutIfNeeded];
    }
}


@end
