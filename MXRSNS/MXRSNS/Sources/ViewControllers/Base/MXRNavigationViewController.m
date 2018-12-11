//
//  MXRNavigationViewController.m
//  HuaShiDa
//
//  Created by zhenyu.wang on 14-7-18.
//  Copyright (c) 2014年 mxrcorp. All rights reserved.
//

#import "MXRNavigationViewController.h"
//#import "MXRNewBookShelfViewController.h"
//#import "MXRNewBookStoreViewController.h"
//#import "MXRPersonViewController.h"
//#import "MXRBookSNSViewController.h"
//#import "MXRBuyViewController.h"
//#import "UIViewController+Ex.h"
//#import "AppDelegate.h"
//#import "MXRBandelPhoneCheckViewController.h"
//#import "AboutOurViewController.h"
//#import "UIView+MXRSnapshot.h"
//#import "MXRComingSoonViewController.h"
//#import "MXRBookCityHomeNaviTabViewController.h"
//#import "MXRARClassroomVC.h"        // AR课堂

@interface MXRNavigationViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic) BOOL pushing;

@end

@implementation MXRNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak MXRNavigationViewController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        
    {
        self.interactivePopGestureRecognizer.delegate = (id)weakSelf;
       
    }
    
     self.delegate = (id)weakSelf;
    self.pushing = NO;
    
    /*V5.8.0 add navigationBar BackgroundImage by MT.X*/
    /*版本更新会有问题，采用本地图片，方便修改*/
//    NSString *savePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"bg_nav_gradient.png"];
//    UIImage *gradientImage = [[UIImage alloc] initWithContentsOfFile:savePath];
//    if (!gradientImage) {
//        UIView *colorView = [[UIView alloc] init];
//        [colorView setFrame:CGRectMake(0, 0, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height + STATUS_BAR_HEIGHT)];
//
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = colorView.bounds;
//        //MXRCOLOR_29AAFE  MXRCOLOR_80F0EA
//        gradient.colors = [NSArray arrayWithObjects:
//                           (id)MXRCOLOR_29AAFE.CGColor,
//                           (id)MXRCOLOR_80F0EA.CGColor,
//                           nil];
//        gradient.startPoint = CGPointMake(0, .5);
//        gradient.endPoint = CGPointMake(1, .5);
//        [colorView.layer addSublayer:gradient];
//
//        UIImage *gradientImage = [colorView mxr_snapshotImage];
//
//        [UIImagePNGRepresentation(gradientImage) writeToFile:savePath atomically:YES];
    
          /*UIImageWriteToSavedPhotosAlbum(gradientImage, nil, nil, nil);*/
    
//    }
//    UIImage *gradientImage = [UIImage imageNamed:@"bg_nav_gradient.png"];
    
//    self.navigationBar.backgroundColor = [UIColor whiteColor];
//    self.navigationBar.barTintColor = [UIColor whiteColor];
//    [self.navigationBar setBackgroundImage:gradientImage forBarMetrics:UIBarMetricsDefault];
    /*V5.8.0 add navigationBar BackgroundImage by MT.X*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 旋转

-(BOOL)shouldAutorotate
{
    return [self.viewControllers.lastObject shouldAutorotate];
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    //return UIInterfaceOrientationMaskLandscapeRight;
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

#pragma mark --- 状态栏
-(UIStatusBarStyle)preferredStatusBarStyle{
    return [self.viewControllers.lastObject preferredStatusBarStyle];
}


#pragma mark --
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.pushing) {
        return;
    }else{
        self.pushing = YES;
    }

//    if (
//        [viewController isKindOfClass:[MXRNewBookShelfViewController class]]||
//#if defined(MXRARCLASSROOMDISPLAY) && defined(MXRBOOKCITY)
//        // 梦想圈不在tab中了
//#else
//        [viewController isKindOfClass:[MXRBookSNSViewController class]]||
//#endif
//        [viewController isKindOfClass:[MXRPersonViewController class]] ||
//        [viewController isKindOfClass:[MXRComingSoonViewController class]] ||
//        [viewController isKindOfClass:[MXRBookCityHomeNaviTabViewController class]] ||
//        [viewController isKindOfClass:[MXRARClassroomVC class]]) {
//
//    }else{
//        if ([MXRAdpterManager currentAppType] == MXRAppTypeBookCity) {
//            if ([viewController isKindOfClass:[MXRNewBookStoreViewController class]]) {
//                viewController.hidesBottomBarWhenPushed = NO;
//            }else {
//                viewController.hidesBottomBarWhenPushed = YES;
//            }
//        }else {
//            viewController.hidesBottomBarWhenPushed = YES;
//        }
//    }
//
//    if ([viewController isKindOfClass:[MXRBuyViewController class]]||[viewController isKindOfClass:[AboutOurViewController class]]) {
//        // 进入购买梦想钻页面，改为竖屏
//        if (APP_DELEGATE.landOrPortraitBool) {
//            [viewController interfaceOrientationToProtrait];
//        }
//    }


    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return [super popViewControllerAnimated:animated];
}

-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    
}

#pragma mark - navigation delegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.pushing = NO;
}

#pragma mark - navigation
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

//    if ([viewController isKindOfClass:[MXRNewBookShelfViewController class]]) {
//        [MXRClickUtil event:@"Bookshelf_Click"];
//    }else if ([viewController isKindOfClass:[MXRNewBookStoreViewController class]]) {
//        [MXRClickUtil event:@"goToBookStore"];
//    }else if ([viewController isKindOfClass:[MXRBookSNSViewController class]]){
//        [MXRClickUtil event:@"DreamCircle_Click"];
//    }else if ([viewController isKindOfClass:[MXRPersonViewController class]]){
//        [MXRClickUtil event:@"MyMeun_Click"];
//    }
}




@end
