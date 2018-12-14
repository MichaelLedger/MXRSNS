//
//  MXRDefaultViewController.h
//  huashida_home
//
//  Created by 周建顺 on 16/6/21.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//  视图控制器基类

/*
 * MXRDefaultViewController 2016.9.21 添加统一的网络错误提示
 *  全屏显示网络错误
 *-(void)showNetworkErrorWithRefreshCallback:(void(^)(void))refreshCallback;
 *  全屏网络错误到指定的view 上
 *-(void)showNetworkErrorOnView:(UIView*)onView refreshCallback:(void(^)(void))refreshCallback;
 * 隐藏网络错误
 *-(void)hideNetworkErrorView;
 */

#import <UIKit/UIKit.h>



@interface MXRDefaultViewController : UIViewController


/**
 导航是否隐藏
 */
@property (nonatomic) BOOL mxr_preferredNavigationBarHidden;

@property (nonatomic,copy) NSString *backTitle;
/**
 *  在push前调用，是否显示返回按钮
 */
@property (nonatomic) BOOL hideBackButton;
@property (nonatomic) CGFloat backButtonWith;
@property (nonatomic,strong) UIButton *backButton;
/**
 *  在push前调用，滑动返回是否可用
 */
@property (nonatomic) BOOL disablePopGestureRecognizer;

/**
 *  滑动返回可用，viewWillDisappear 中调用
 */
-(void)addInteractivePopGestureRecognizer;
/**
 *  禁用滑动返回，viewDidAppear中调用
 */
-(void)removeInteractivePopGestureRecognizer;

/**
 *  重新设置左侧按钮
 *
 *  @param leftBarButtonItems            左侧按钮
 *  @param leftItemsSupplementBackButton 是否保留返回按钮，YES表示保存
 */
-(void)leftBarButtonItems:(NSArray*)leftBarButtonItems supplementBackButton:(BOOL)leftItemsSupplementBackButton;


/**
 *  返回按钮触发的action,默认pop，子类可覆盖重写
 *
 *  @param sender <#sender description#>
 */
-(void)backAction:(id)sender;

/**
 *  设置title
 *
 *  @param title <#title description#>
 */
-(void)setNavTitleLabelText:(NSString*)title;

/**
 *  添加返回按钮，不在navigationController中或者作为navigationController的root的话，是不显示返回按钮的，如果在这种情况下需要显示，就调用此方法
 */
-(void)addBackButton;
    

#pragma mark - 网络连接错误
/*
 *  全屏显示网络错误
 */
-(void)showNetworkErrorWithRefreshCallback:(void(^)(void))refreshCallback;
/*
 *  全屏网络错误到指定的view 上
 */
-(void)showNetworkErrorOnView:(UIView*)onView refreshCallback:(void(^)(void))refreshCallback;
/*
 * 隐藏网络错误
 */
-(void)hideNetworkErrorView;

-(void)hideNetworkErrorViewNotRemove;
-(void)showNetworkErrorView;

// 自定义点击App的状态栏事件
- (void)clickAppStatusBar;
@end

@interface MXRDefaultViewController(MXR_NAVI)

- (UIViewController*)topViewController;
- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;
@end


