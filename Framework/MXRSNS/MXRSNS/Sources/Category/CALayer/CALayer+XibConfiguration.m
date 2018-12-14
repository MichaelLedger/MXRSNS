//
//  CALayer+XibConfiguration.m
//  huashida_home
//
//  Created by MountainX on 2017/10/26.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

- (void)setBorderUIColor:(UIColor *)borderUIColor {
    self.borderColor = borderUIColor.CGColor;//设置的UIColor转化为CGColor
}

- (UIColor *)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
