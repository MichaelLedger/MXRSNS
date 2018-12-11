//
//  MXRTabBarViewController.h
//  huashida_home
//
//  Created by 周建顺 on 16/6/16.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//  Tabbar基类

#import <UIKit/UIKit.h>
//#import "UITabBar+CenterButton.h"
@class MXRUserNotificationResponseModel;
@interface MXRTabBarViewController : UITabBarController

+(instancetype)tabBarViewController;

-(void)setup;

-(void)setTabBarItemImageWithIndex:(NSInteger)index WithIsShow:(BOOL)isShow;

/**
 显示个人中心的未读消息数量

 @param index
 @param notificationModel
 */
//- (void)setTabbarItemStatusWithIndex:(NSInteger )index model:(MXRUserNotificationResponseModel *)notificationModel;

/**
 依据未读消息数量刷新tabbar和应用角标
 */
- (void)reloadTabbarItemAndIconBadgeNumberAccordingToUnreadMsgCount;

/**
 隐藏气泡
 */
- (void)hideNotiBubbleView;

/**
 展示气泡
 */
- (void)showNotiBubbleView:(NSUInteger)count;

@end
