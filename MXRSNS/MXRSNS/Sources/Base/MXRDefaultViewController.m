//
//  MXRDefaultViewController.m
//  huashida_home
//
//  Created by 周建顺 on 16/6/21.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRDefaultViewController.h"
#import "MXRLoadFailedView.h"
#import "Masonry.h"
#import "UIImage+Extend.h"
#import "GlobalBusyFlag.h"
//#import "MXRPromptView.h"
//#import "BookInfoForShelf.h"
#import "GlobalFunction.h"
//#import "MXRGlassLoadingView.h"
//#import "MXRSubCategoryViewController.h"
#import "Notifications.h"

#define MXRBookDownloadCompleteNotification @"MXR_BOOK_DOWNLOAD_COMPLETE_NOTIFICATION" // 下载成功
#define MXRBookDownloadFailNotification @"MXR_BOOK_DOWNLOAD_FAIL_NOTIFICATION" // 下载失败
#define DOWNLOAD_FAIL @"ShowTheDownloadIsFail"
#define SYSTEM_VERSION_GREATER(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
@interface MXRDefaultViewController ()
    
@property (nonatomic, strong) MXRLoadFailedView *loadFailedView;
@property (nonatomic, strong) UIView *recordView;
@property (nonatomic, assign) NSInteger recordCount;

@end

@implementation MXRDefaultViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.recordCount=0;
//    UIViewController * rootvc = self.navigationController.viewControllers[0];
//    if ([rootvc isEqual:self])
//    { //这里必须要把栈低的vc的interactivePopGestureRecognizer挂掉  不然会有些意想不到的bug
//        [self removeInteractivePopGestureRecognizer];
//    }else
//    {
//        if (!self.disablePopGestureRecognizer)
//        {
//            [self addInteractivePopGestureRecognizer];
//        }
//    }
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.hideBackButton)
    {
        self.navigationItem.hidesBackButton = YES;
    }else
    {
        [self showDefaultBackButton];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.mxr_preferredNavigationBarHidden animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickAppStatusBar) name:Notification_ClickAppStatusBar object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIViewController * rootvc = self.navigationController.viewControllers[0];
    if ([rootvc isEqual:self])
    { //这里必须要把栈低的vc的interactivePopGestureRecognizer挂掉  不然会有些意想不到的bug
        [self removeInteractivePopGestureRecognizer];
    }else
    {
        if (!self.disablePopGestureRecognizer)
        {
            [self addInteractivePopGestureRecognizer];
        } else {
            [self removeInteractivePopGestureRecognizer];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_ClickAppStatusBar object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)didMoveToParentViewController:(UIViewController *)parent {
//    [super didMoveToParentViewController:parent];
//    if (!parent) {
//        [self innerHideNetworkErrorView];
//    }
//}

-(void)setBackTitle:(NSString *)backTitle{
    _backTitle = [backTitle copy];
}


-(void)setNavTitleLabelText:(NSString *)title{
        self.title = title;
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleDefault;
    return UIStatusBarStyleLightContent;
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationSlide;
}

#pragma mark - 导航条按钮
    
/**
 *  添加返回按钮
 */
-(void)addBackButton{
    [self leftBarButtonItems:nil supplementBackButton:YES];
}

/**
 *  添加左侧按钮
 *
 *  @param leftBarButtonItems            左侧按钮
 *  @param leftItemsSupplementBackButton 是否存在返回按钮，yes表示会在leftBarButtonItems以外添加一个额外的返回按钮
 */
-(void)leftBarButtonItems:(NSArray*)leftBarButtonItems supplementBackButton:(BOOL)leftItemsSupplementBackButton{

    if (leftItemsSupplementBackButton)
    {
        // 存在返回按钮
        NSString *buttonTitle;
        if (self.backTitle) {
            buttonTitle = self.backTitle;
        }else{
            if (self.navigationController.childViewControllers.count > 1)
            {
                UIViewController *preVC = [self.navigationController.childViewControllers objectAtIndex:(self.navigationController.childViewControllers.count - 2)];
                buttonTitle = preVC.title;
            }
            if (!buttonTitle)
            {
                buttonTitle = MXRLocalizedString(@"Return", @"返回");
            }
        }
        UIBarButtonItem *backItem = [self createCustomButtonWithTitle:buttonTitle target:self action:@selector(backAction:)];
//        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSpacer.width = -10;//负数在iOS11失效
//        NSMutableArray *new = [NSMutableArray arrayWithArray:@[negativeSpacer,backItem]];
//        [new addObjectsFromArray:leftBarButtonItems];
//        self.navigationItem.leftBarButtonItems= new;
        
        //自定义返回按钮
        self.navigationItem.leftBarButtonItem = backItem;
        //隐藏系统返回按钮
        self.navigationItem.leftItemsSupplementBackButton = NO;
    } else {
        self.navigationItem.leftBarButtonItems= leftBarButtonItems;
        //隐藏系统返回按钮
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
}
    
    
-(void)showDefaultBackButton{
    if (self.navigationController.childViewControllers.count>1) {
        [self addBackButton];
    }
    
}
    
-(UIBarButtonItem*)createCustomButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    if (!title) {
        title =MXRLocalizedString(@"Return", @"返回");
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    /*V5.8.0 modified by MT.X*/
//    [button setImage:[UIImage imageNamedUseTintColor:@"icon_gray_left_arrow"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamedUseTintColor:@"icon_gray_left_arrow_pre"] forState:UIControlStateHighlighted];
    
    [button setImage:[UIImage imageNamedRenderingModeAlwaysOriginal:@"icon_white_left_arrow"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamedRenderingModeAlwaysOriginal:@"icon_white_left_arrow"] forState:UIControlStateHighlighted];
//    button.tintColor = MXRCOLOR_2FB8E2;
    /*V5.8.0 modified by MT.X*/
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];

    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
//    button.layer.borderColor = [UIColor redColor].CGColor;
//    button.layer.borderWidth = SINGLE_LINE_WIDTH;
    if (SYSTEM_VERSION_GREATER(@"7")) {
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    }
    
    self.backButton = button;

    
    self.backButtonWith = button.frame.size.width;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return backItem;
}
    
#pragma mark 导航手势

-(void)addInteractivePopGestureRecognizer{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)removeInteractivePopGestureRecognizer{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
    


#pragma mark - 子类可以重写的方法
-(void)backAction:(id)sender{
//    [self innerHideNetworkErrorView];
    // martin modify
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
//    [self.navigationController popViewControllerAnimated:YES];
}
    
#pragma mark - 网络连接错误
    
-(void)showNetworkErrorWithRefreshCallback:(void(^)(void))refreshCallback{
    [self showNetworkErrorOnView:self.view refreshCallback:refreshCallback];
}
    
-(void)showNetworkErrorOnView:(UIView*)onView refreshCallback:(void(^)(void))refreshCallback{
    
    MXRLoadFailedView *loadFailedView ;
    if (self.loadFailedView) {
        loadFailedView = self.loadFailedView;
        if (self.loadFailedView.superview) {
            [self.loadFailedView removeFromSuperview];
        }
    }else{
        loadFailedView = [MXRLoadFailedView loadFailedView];
    }
    @MXRWeakObj(self);
    if (refreshCallback) {
        loadFailedView.refreshTapped = ^(MXRLoadFailedView *sender){
            
            //当连续点击7次时，弹出弹框提示
            if (selfWeak.recordCount == 0) {
                selfWeak.recordView = selfWeak.view;
                selfWeak.recordCount ++;
            }
            else{
                /*解决内存泄漏问题 by MT.X*/
                if ([selfWeak.recordView isKindOfClass:[selfWeak.view class]]) {
                    selfWeak.recordCount ++;
                }else{
                    selfWeak.recordCount = 0;
                }
                if (selfWeak.recordCount >= 7) {
//                    MXRPromptView *tipView = [[MXRPromptView alloc]initWithTitle: MXRLocalizedString(@"MXBManager_Prompt",@"提示")    message:MXRLocalizedString(@"DDYTipChangeNet",@"网络真的连不上，换个网试试吧") delegate:nil cancelButtonTitle:MXRLocalizedString(@"OKay",@"好的") otherButtonTitle:nil];
//                    [tipView showInLastViewController];
                }
            }
            
        
            refreshCallback();
         
            if ([MXRDeviceUtil isReachable]) {
                [selfWeak hideNetworkErrorView];//如果有网，则隐藏
            } else {
                [selfWeak hideNetworkErrorViewNotRemove];
                if (selfWeak.recordCount < 6) {
                    [[GlobalBusyFlag sharedInstance] showBusyFlagOnWindow];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (selfWeak.recordCount < 6) {
                        [[GlobalBusyFlag sharedInstance] hideBusyFlag];
                    }
                    [selfWeak showNetworkErrorView];
                });
            }

        };
    }
    
    [onView addSubview:loadFailedView];
    loadFailedView.translatesAutoresizingMaskIntoConstraints = NO;
    UIEdgeInsets edge = UIEdgeInsetsZero;
    if (self.navigationController.navigationBarHidden) {
        edge = UIEdgeInsetsMake(TOP_BAR_HEIGHT, 0, 0, 0);
    }
    
    /*----Exception----V5.8.3----by MT.X*/
//    if ([self isKindOfClass:[MXRSubCategoryViewController class]]) {
//        edge = UIEdgeInsetsZero;
//    }
    /*----Exception----V5.8.3----by MT.X*/
    
    [loadFailedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(onView).mas_offset(edge);
    }];
    self.loadFailedView = loadFailedView;
}
-(void)innerHideNetworkErrorView{
    @MXRWeakObj(self);
    [selfWeak.loadFailedView removeFromSuperview];
    selfWeak.loadFailedView = nil;
}

-(void)hideNetworkErrorView{
    @MXRWeakObj(self);
    selfWeak.recordCount=0;
    [selfWeak.loadFailedView removeFromSuperview];
    selfWeak.loadFailedView = nil;
}
-(void)hideNetworkErrorViewNotRemove {
    @MXRWeakObj(self);
    selfWeak.loadFailedView.alpha = 0;
    selfWeak.loadFailedView.userInteractionEnabled = NO;
}
-(void)showNetworkErrorView {
    @MXRWeakObj(self);
    selfWeak.loadFailedView.alpha = 1;
    selfWeak.loadFailedView.userInteractionEnabled = YES;
}
//-(void)promptView:(MXRPromptView *)promptView didSelectAtIndex:(NSUInteger)index{
//
//}

- (void)clickAppStatusBar{}


/**
 监听屏幕旋转,解决在转屏时小梦loading视图错乱的问题
 @param notif
 5.5.0版本  图书推荐页里面进入另一本图书添加小梦loading
 */
-(void)orientationDidChange:(NSNotification *)notif {
//    APP_DELEGATE.window.frame = [UIScreen mainScreen].bounds;
//    [APP_DELEGATE.window layoutSubviews];
//    for (UIView *view in APP_DELEGATE.window.subviews) {
//        if ([view isKindOfClass:[MXRGlassLoadingView class]]) {
//            view.frame = [UIScreen mainScreen].bounds;
//            [view layoutSubviews];
//        }
//    }
}
@end

@implementation MXRDefaultViewController (NavigtaionBar)

+(UIBarButtonItem*) createDefaultBackButtonWithTitle:(NSString *)title backgroundImage:(UIImage*)backgroundImage
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    if (!title) {
        title = MXRLocalizedString(@"Return", @"返回");
    }
    
    backItem.title = title;
    if(backgroundImage == nil)
//        backgroundImage = [UIImage imageNamed:@"icon_gray_left_arrow"];
        /*V5.8.0 modified by MT.X*/
        backgroundImage = [UIImage imageNamedRenderingModeAlwaysOriginal:@"icon_white_left_arrow"];
        /*V5.8.0 modified by MT.X*/
    //图片右侧2像素将被拉伸，所以图片右侧需要有两像素的透明空白
    [backItem setBackButtonBackgroundImage:[backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backgroundImage.size.width-4, 0, 1)]
                                  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    backItem.tintColor = RGB(255, 255, 255);
    return backItem;
}

+(UIBarButtonItem*) createDefaultBackButtonWithTitle:(NSString *)title{
//    return  [self createDefaultBackButtonWithTitle:title backgroundImage:[UIImage imageNamed:@"icon_gray_left_arrow"]];
    /*V5.8.0 modified by MT.X*/
    return [self createDefaultBackButtonWithTitle:title backgroundImage:[UIImage imageNamedRenderingModeAlwaysOriginal:@"icon_white_left_arrow"]];
    /*V5.8.0 modified by MT.X*/
}
    
@end


@implementation MXRDefaultViewController(MXR_NAVI)

//- (UIViewController*)topViewController
//{
//    return [self topViewControllerWithRootViewController:APP_DELEGATE.window.rootViewController];
//}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


@end
