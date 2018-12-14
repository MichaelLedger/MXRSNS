//
//  UIViewController+MXRUIFit.h
//  huashida_home
//
//  Created by 周建顺 on 2017/9/20.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController(MXRUIFit)

/**
 适配iPhoneX中的状态栏
 自定义的状态栏需要适配，系统的不需要处理
 如果使用xib适配，使用此方法。若是storyboard使用guidline适配
 
 @param topView <#topView description#>
 */
-(void)fitIphoneXStatusBarWithTopView:(UIView*)topView;

-(void)fitIphoneXStatusBarWithBottomView:(UIView*)bottomView;

@end
