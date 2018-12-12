//
//  MXRPKPropSectionHeader.m
//  huashida_home
//
//  Created by MountainX on 2018/10/22.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKPropSectionHeader.h"

#define kLineWidth 1.f
#define kMargin 10.f

@interface MXRPKPropSectionHeader ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *bgIv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewLeadingConstraint;

@end

@implementation MXRPKPropSectionHeader

+ (instancetype)sectionHeader {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MXRPKPropShopViewController" owner:nil options:nil];
    __block MXRPKPropSectionHeader *header;
    [nibs enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MXRPKPropSectionHeader class]]) {
            header = obj;
            *stop = YES;
        }
    }];
    return header;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _titleLabel.text = MXRLocalizedString(@"MXR_Prop_Purchase", @"道具购买");
    
    [self setupGradientBg];
    [self addCornerMask];
}

- (void)setupGradientBg {
    CAGradientLayer *gradient = self.bgIv.gradientLayer;
    gradient.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE - 2 * kMargin, self.bgIv.bounds.size.height);
    
    gradient.colors = @[(id)RGBHEX(0x15D4EC).CGColor, (id)RGBHEX(0x09A9D4).CGColor];
    gradient.startPoint = CGPointMake(0.5f, 0.0f);
    gradient.endPoint = CGPointMake(0.5f, 1.0f);
    [self.bgIv.layer insertSublayer:gradient atIndex:0];
}

- (void)addCornerMask {
    CGRect rect = CGRectMake(kLineWidth, kLineWidth, SCREEN_WIDTH_DEVICE - 2 * kMargin - kLineWidth * 2, _contentView.bounds.size.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE - 2 * kMargin, _contentView.bounds.size.height);
    maskLayer.path = maskPath.CGPath;
    _contentView.layer.mask = maskLayer;
}

- (void)drawRect:(CGRect)rect {
    
    // 线的宽度
    
    CGFloat lineWidth = kLineWidth;
    
    // 根据线的宽度 设置画线的位置
    
    CGRect rect1 = CGRectMake(_contentViewLeadingConstraint.constant + lineWidth * 0.5, lineWidth * 0.5, rect.size.width - 2 * _contentViewLeadingConstraint.constant - lineWidth , rect.size.height);
    
    // 获取图像上下文
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置线的宽度
    
    CGContextSetLineWidth(context, lineWidth);
    
    // 设置线的颜色
    
    CGContextSetStrokeColorWithColor(context, MXRCOLOR_999999.CGColor);
    
    // 设置虚线和实线的长度
    
//    CGFloat lengths[] = { 2.5, 1.5 };
//
//    CGContextSetLineDash(context, 0, lengths,1);
    
    // 画矩形path 圆角5度
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect1 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12.f, 12.f)];
    
    // 添加到图形上下文
    
    CGContextAddPath(context, bezierPath.CGPath);
    
    // 渲染
    
    CGContextStrokePath(context);
}

@end
