//
//  MXRRoundMaskView.m
//  huashida_home
//
//  Created by MountainX on 2017/12/28.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRRoundMaskView.h"

@interface MXRRoundMaskView ()

@property (nonatomic, assign)BOOL isLocked;//正在寻找点击响应视图，避免连续点击造成的错误判断

@end

@implementation MXRRoundMaskView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    CGPoint touch = [self convertPoint:point toView:self.superview];
//    if ([self.superview pointInside:touch withEvent:event]) {
//        return self.superview;
//    }
//    return [super hitTest:point withEvent:event];
    
    if (_isLocked) {
        return nil;
    }
    
    if (!self.passthroughViews || self.passthroughViews.count == 0) {
        return self;
    } else {
        __block UIView *hitView = [super hitTest:point withEvent:event];
        if (hitView == self) {
            _isLocked = YES;
            CGPoint superPoint = [self.superview convertPoint:point fromView:self];
            UIView *superHitView = [self.superview hitTest:superPoint withEvent:event];//耗时
            _isLocked = NO;
            if ([self isPassthroughView:superHitView]) {
                hitView = superHitView;
            }
        }
        return hitView;
    }
}

- (BOOL)isPassthroughView:(UIView *)view {
    if (view == nil) {
        return NO;
    }
    if (![view isKindOfClass:[UIView class]]) {
        return NO;
    }
    if ([self.passthroughViews containsObject:view]) {
        return YES;
    }
    return [self isPassthroughView:view.superview];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //CGContextRef
//    CGContextRef context = UIGraphicsGetCurrentContext();
////    CGContextSetRGBStrokeColor(context,100,60,80,1.0);//画笔线的颜色
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);//画笔线的颜色
//
//    //创建一个矩形
////    CGContextAddRect(context, rect);
////    CGContextStrokePath(context);//绘制
////    CGContextSetFillColorWithColor(context,[UIColor redColor].CGColor);
////    CGContextFillRect(context, rect);
//
//    //创建颜色有两种方法
//    //方法一
////    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
////    CGFloat components[] = {0.0,0.0,1.0,1.0};//颜色元素
////    CGColorRef fillColor = CGColorCreate(colorspace, components);
////    CGContextSetFillColorWithColor(context, fillColor);//填充颜色
////    //释放颜色空间
////    CGColorSpaceRelease(colorspace);
////    CGColorRelease(fillColor);
//
//    //方法二
//    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);//填充颜色
//
//    CGFloat width = rect.size.width;
//    CGFloat height = rect.size.height;
//
//    //线的宽度
//    CGContextSetLineWidth(context, 10.f);
//
//    CGContextMoveToPoint(context, 0, height);
//    CGContextAddLineToPoint(context, 0, 0);
//    [self calculateCircleWithPt1:CGPointMake(0, 0) pt2:CGPointMake(width / 2, height) pt3:CGPointMake(width, 0) callback:^(CGPoint center, CGFloat radius) {
//        if (!CGPointEqualToPoint(center, CGPointZero)) {
//            CGContextMoveToPoint(context, center.x, center.y);
//            CGContextAddArc(context, center.x, center.y, radius, 0, M_PI, 0);
//            CGContextMoveToPoint(context, width, 0);
//            CGContextAddLineToPoint(context, width, height);
////            CGContextClosePath(context);
//            CGContextAddLineToPoint(context, 0, height);
//            CGContextDrawPath(context, kCGPathFillStroke);//绘制路径
//            /*
//             typedef CF_ENUM (int32_t, CGPathDrawingMode) {
//             kCGPathFill,
//             kCGPathEOFill,
//             kCGPathStroke,
//             kCGPathFillStroke,
//             kCGPathEOFillStroke
//             };
//             */
//        } else {
//            CGContextAddLineToPoint(context, width, 0);
//            CGContextAddLineToPoint(context, width, height);
////            CGContextClosePath(context);
//            CGContextAddLineToPoint(context, 0, height);
//            CGContextDrawPath(context, kCGPathFillStroke);//绘制路径
//        }
//    }];

    //CAShapeLayer & UIBezierPath
//    UIColor *color = [UIColor redColor];
//    [color set];
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0, height)];
//    [path moveToPoint:CGPointMake(width, height)];
//    [path moveToPoint:CGPointMake(width, 0)];
//    path.lineWidth = 5.f;
//    path.lineCapStyle = kCGLineCapRound;//拐角
//    path.lineJoinStyle = kCGLineJoinRound;//终点
//
//    [self calculateCircleWithPt1:CGPointMake(0, 0) pt2:CGPointMake(width / 2, height / 2) pt3:CGPointMake(width, 0) callback:^(CGPoint center, CGFloat radius) {
//        if (!CGPointEqualToPoint(center, CGPointZero)) {
//            [path addQuadCurveToPoint:CGPointZero controlPoint:center];
//            [path fill];
//
//            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//            maskLayer.frame = self.bounds;
//            maskLayer.path = path.CGPath;
//            self.layer.mask = maskLayer;
//        }
//    }];
    
//    UIColor *color = [UIColor redColor];
//    [color set];
    
    CGSize finalSize = rect.size;
    CGFloat layerHeight = finalSize.height;//finalSize.height * 0.8
    CAShapeLayer *bottomCurveLayer = [[CAShapeLayer alloc]init];
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(0, finalSize.height - layerHeight)];
    [path addLineToPoint:CGPointMake(0, finalSize.height - 1)];
    [path addLineToPoint:CGPointMake(finalSize.width, finalSize.height - 1)];
    [path addLineToPoint:CGPointMake(finalSize.width, finalSize.height - layerHeight)];
    [path addQuadCurveToPoint:CGPointMake(0, finalSize.height - layerHeight) controlPoint:CGPointMake(finalSize.width / 2, finalSize.height * 1.2)];
//    path.lineWidth = 10.f;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    bottomCurveLayer.path = path.CGPath;
    bottomCurveLayer.fillColor = [UIColor whiteColor].CGColor;
//    bottomCurveLayer.strokeColor = [UIColor whiteColor].CGColor;
//    [self.layer addSublayer:bottomCurveLayer];
    self.layer.mask = bottomCurveLayer;
}

- (void)dealloc {
    self.passthroughViews = nil;
}

- (void)calculateCircleWithPt1:(CGPoint)pt1 pt2:(CGPoint)pt2 pt3:(CGPoint)pt3 callback:(void(^)(CGPoint center, CGFloat radius))callback {
    CGFloat x1 = pt1.x; CGFloat y1 = pt1.y;
    CGFloat x2 = pt2.x; CGFloat y2 = pt2.y;
    CGFloat x3 = pt3.x; CGFloat y3 = pt3.y;
    
    CGFloat a = x1 - x2;
    CGFloat b = y1 - y2;
    CGFloat c = x1 - x3;
    CGFloat d = y1 - y3;
    CGFloat e = ((x1 * x1 - x2 * x2) + (y1 * y1 - y2 * y2)) / 2;
    CGFloat f = ((x1 * x1 - x3 * x3) + (y1 * y1 - y3 * y3)) / 2;
    double det = b * c - a * d;
    if (fabs(det) < (10 ^ -5)) {
        if (callback){
            callback(CGPointZero, 0);
        }
        
    }
    
    CGFloat x0 = -(d * e - b * f) / det;
    CGFloat y0 = -(a * f - c * e) / det;
    if (callback) {
        callback(CGPointMake(x0, y0), hypot(x1 - x0, y1 - y0));
    }
    
}


@end
