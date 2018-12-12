//
//  UIViewController+MXRUIFit.m
//  huashida_home
//
//  Created by 周建顺 on 2017/9/20.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "UIViewController+MXRUIFit.h"

#import "Masonry.h"

@implementation UIViewController(MXRUIFit)


/**
 适配iPhoneX中的状态栏
 自定义的状态栏需要适配，系统的不需要处理

 @param topView <#topView description#>
 */
-(void)fitIphoneXStatusBarWithTopView:(UIView*)topView{
    
    if (!topView) {
        return;
    }
    if ([self.view respondsToSelector:@selector(safeAreaLayoutGuide)]) {
#if defined(__IPHONE_11_0)
        UILayoutGuide *topViewGuide = [self.view safeAreaLayoutGuide];
        [topView.topAnchor constraintEqualToAnchor:topViewGuide.topAnchor].active = YES;
#endif
    }
    else
    {
        id topViewGuide = self.topLayoutGuide;
        NSDictionary *views = @{@"topGuide":topViewGuide,@"topView":topView};
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[topView]" options:0 metrics:nil views:views];
        [self.view addConstraints:constraints];
    }
}



-(void)fitIphoneXStatusBarWithBottomView:(UIView*)bottomView{
    
    if (!bottomView) {
        return;
    }
    if ([self.view respondsToSelector:@selector(safeAreaLayoutGuide)]) {
#if defined(__IPHONE_11_0)
        UILayoutGuide *viewGuide = [self.view safeAreaLayoutGuide];
        [bottomView.topAnchor constraintEqualToAnchor:viewGuide.bottomAnchor].active = YES;
#endif
    }
    else
    {
//        id bottomLayoutGuide = self.bottomLayoutGuide;
//        NSDictionary *views = @{@"bottomGuide":bottomLayoutGuide,@"bottomView":bottomView};
//        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomView]-0-[bottomGuide]" options:0 metrics:nil views:views];
//        [self.view addConstraints:constraints];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).mas_offset(0);
        }];
    }
}

@end
