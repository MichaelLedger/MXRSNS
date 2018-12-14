//
//  MXRPKPropSectionFooter.m
//  huashida_home
//
//  Created by MountainX on 2018/10/22.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKPropSectionFooter.h"

#define kMargin 10.f

@interface MXRPKPropSectionFooter ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewLeadingConstraint;

@end

@implementation MXRPKPropSectionFooter

+ (instancetype)sectionFooter {
    NSArray *nibs = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"MXRPKPropShopViewController" owner:nil options:nil];
    __block MXRPKPropSectionFooter *header;
    [nibs enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MXRPKPropSectionFooter class]]) {
            header = obj;
            *stop = YES;
        }
    }];
    return header;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addCornerMask];
}

- (void)addCornerMask {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE - 2 * kMargin, _contentView.bounds.size.height) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE - 2 * kMargin, _contentView.bounds.size.height);
    maskLayer.path = maskPath.CGPath;
    _contentView.layer.mask = maskLayer;
}

- (void)drawRect:(CGRect)rect {
    
    // 线的宽度
    
    CGFloat lineWidth = 1.f;
    
    // 根据线的宽度 设置画线的位置
    
    CGRect rect1 = CGRectMake(_contentViewLeadingConstraint.constant + lineWidth * 0.5, - lineWidth * 0.5, rect.size.width - 2 * _contentViewLeadingConstraint.constant - lineWidth , _contentViewHeightConstraint.constant);
    
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
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect1 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(12.f, 12.f)];
    
    // 添加到图形上下文
    
    CGContextAddPath(context, bezierPath.CGPath);
    
    // 渲染
    
    CGContextStrokePath(context);
}

@end
