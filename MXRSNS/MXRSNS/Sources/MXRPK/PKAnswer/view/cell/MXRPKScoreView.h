//
//  MXRPKScoreView.h
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/23.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXRPKScoreView : UIView

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGFloat scoreTotalLength;
@property (nonatomic, assign) CGFloat scoreLength;
@property (nonatomic, strong) UIColor *scoreViewBackgoundColor;
- (void)setLength:(CGFloat)length correct:(BOOL)isCorrect animated:(BOOL)animated;

@end
