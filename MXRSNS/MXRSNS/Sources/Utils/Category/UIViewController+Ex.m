//
//  UIViewController+Ex.m
//  huashida_home
//
//  Created by 周建顺 on 15/8/14.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "UIViewController+Ex.h"
#import <objc/runtime.h>
#import "MXRDataStatisticsNetworkManager.h"
#import "AppDelegate.h"

@implementation UIViewController(Ex)


//是否转为竖屏
- (void)toProtrait{
    //    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationPortrait];
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    self.navigationController.view.transform = CGAffineTransformMakeRotation(-2*M_PI);//-360/180.0
    self.navigationController.view.bounds = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE);
    [UIView commitAnimations];
}

//是否转为横屏
- (void)toLand{
    
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    self.navigationController.view.transform = CGAffineTransformMakeRotation(M_PI*(90)/180.0);
    self.navigationController.view.bounds = CGRectMake(0, 0, SCREEN_HEIGHT_DEVICE, SCREEN_WIDTH_DEVICE);
    [UIView commitAnimations];
    //    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeRight];
}


//是否转为竖屏
- (void)interfaceOrientationToProtrait{
    
//    APP_DELEGATE.landOrPortraitBool = NO;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];//这句话是防止手动先把设备置为竖屏,导致下面的语句失效.
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];

    
}


//是否转为横屏
- (void)interfaceOrientationToLandRight{
    
//    APP_DELEGATE.landOrPortraitBool = YES;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];//这句话是防止手动先把设备置为横屏,导致下面的语句失效.
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
    
}


@end


#pragma mark - ——————————————用于统计阅读时长——————————————
/*
 *阅读时长统计说明：
 *1.普通图书离线页面、扫一扫页面在启动时调用startRecordReadDuration开始纪录阅读时长，在viewWillDisapper的时候发送阅读时长给服务端并且重置（readDuration和startReadTime）。在viewWillAppear中调用continueRecordReadDuration重置startReadTime，在程序ResignActive时记录readDuration，在程序EnterForeground重置startReadTime
 *
 *2.彩蛋、绘本、认知卡、课程表、普通书模型页：启动时调用startRecordReadDuration开始纪录阅读时长，在退出前发送阅读时长给服务端并且重置（readDuration和startReadTime），在viewWillAppear中调用continueRecordReadDuration重置startReadTime，在程序ResignActive时记录readDuration，在程序EnterForeground重置startReadTime
 */

static const void *StartReadTimeKey = &StartReadTimeKey;
static const void *ReadDurationKey = &ReadDurationKey;

@implementation UIViewController(ReadingTime)

-(NSDate *)startReadTime{
    return objc_getAssociatedObject(self, StartReadTimeKey);
}

-(void)setStartReadTime:(NSDate *)startReadTime{
    objc_setAssociatedObject(self, StartReadTimeKey, startReadTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber*)readDuration{
    return objc_getAssociatedObject(self, ReadDurationKey);
}

-(void)setReadDuration:(NSNumber *)readDuration{
    objc_setAssociatedObject(self, ReadDurationKey, readDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark 开始记录
-(void)startRecordReadDuration{
    self.readDuration = [NSNumber numberWithInteger:0];
    self.startReadTime = [NSDate date];
}

-(void)continueRecordReadDuration{
    self.startReadTime = [NSDate date];
}

-(void)pauseRecordReadDuration{
    NSInteger read  = -[self.startReadTime timeIntervalSinceNow] + [self.readDuration integerValue];
    self.readDuration = [NSNumber numberWithInteger:read];
    self.startReadTime = nil;
}

#pragma mark    将数据发送到服务端
-(void)sendReadDurationToServerWith:(NSString *)bookGUID{
    
    if (!bookGUID) {
        return;
    }
    // 统计读书时间
    NSTimeInterval duration = -[self.startReadTime timeIntervalSinceNow] + [self.readDuration integerValue];
    int seconds = duration / 1;// 11/25 服务端让改成记录秒。
    [[MXRDataStatisticsNetworkManager defaultInstance] readingDurationDataWithBookGUID:bookGUID duration:[NSNumber numberWithInt:seconds] callback:nil];
    self.readDuration = @0;
    self.startReadTime = [NSDate date];
}

#pragma mark    失去焦点的时候调用
-(void)readDurationInResignActive{
    [self pauseRecordReadDuration];
}

#pragma mark  获得焦点或者进入前台的时候调用
-(void)readDurationInEnterForeground{
    [self continueRecordReadDuration];
}

@end


@implementation UIViewController(EdgePopGestureRecognizer)

/**
 *  滑动返回可用，viewWillDisappear 中调用
 */
-(void)enableInteractivePopGestureRecognizer{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

/**
 *  禁用滑动返回，viewDidAppear中调用
 */
-(void)disableInteractivePopGestureRecognizer{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

@end
static const void *readActionKey = &readActionKey;
static const void *hotActionKey  = &hotActionKey;

@implementation UIViewController (MXRDataAnalyze)
/*
 =============================================================================
 阅读行为
 */
- (MXRDataReadAction *)readAction{
    return objc_getAssociatedObject(self, readActionKey);
}

- (void)setReadAction:(MXRDataReadAction *)readAction{
    objc_setAssociatedObject(self, readActionKey, readAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)createReadActionAccount:(NSString *)account pageNumber:(NSString *)pageNumber bookId:(NSString *)bookId readSessionId:(NSString *)readSessionId{
    if (!self.readAction) {
        self.readAction = [[MXRDataReadAction alloc]initWithAccount:account pageNumber:pageNumber bookId:bookId];
        [self.readAction setMXRReadSessionId:readSessionId];
    }
}

- (void)endReadActionWithStatus:(MXRDataUserActionStatus)status{
    if (self.readAction) {
        [self.readAction configureEndActionTime];
        [self.readAction changeActionStatus:status];
        [MXRDataAnalyze saveUesrAction:self.readAction];
        [self setReadAction:nil];
    }
}
/*
 =============================================================================
 热点行为
 */
- (MXRDataHotPointAction *)hotPointAction{
    return objc_getAssociatedObject(self, hotActionKey);
}

- (void)setHotPointAction:(MXRDataHotPointAction *)hotPointAction{
    objc_setAssociatedObject(self, hotActionKey, hotPointAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)createHotPointActionReadSessionId:(NSString *)readSessionId userAccount:(NSString *)userAccount hotId:(NSString *)hotId{
//暂时更换SDK统计 后续删除
//    if (!self.hotPointAction) {
//        self.hotPointAction = [[MXRDataHotPointAction alloc]initWithAccount:userAccount hotId:hotId];
//        [self.hotPointAction setMXRReadSessionId:readSessionId];
//    }
}

- (void)endHotPointActionStatus:(MXRDataUserActionStatus)status{
//暂时更换SDK统计 后续删除
//    if (self.hotPointAction) {
//        [self.hotPointAction configureEndActionTime];
//        [self.hotPointAction changeActionStatus:status];
//        [MXRDataAnalyze saveUesrAction:self.hotPointAction];
//        [self setHotPointAction:nil];
//    }
}
/*
 =============================================================================
 私信通知点击行为
 */

- (MXRDataNotificationAction *)notifictionAction{
    return  objc_getAssociatedObject(self , _cmd);
}

- (void)setNotifictionAction:(MXRDataNotificationAction *)notifictionAction{
    objc_setAssociatedObject(self, @selector(notifictionAction), notifictionAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)saveNotifictionActionWithAccount:(NSString *)account moduleId:(NSInteger)moduleId moduleType:(NSInteger)moduleType actionType:(NSInteger)actionType
{
    self.notifictionAction = [[MXRDataNotificationAction alloc]initWithAccount:account moduleId:moduleId moduleType:moduleType actionType:actionType userId:[[UserInformation modelInformation].userID integerValue]];
    [MXRDataAnalyze saveUesrAction:self.notifictionAction];

}

/*
 =============================================================================
 私信 通知里面的链接点击行为
 */

- (MXRDataNotificationLinkAction *)notificationLinkAction{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNotificationLinkAction:(MXRDataNotificationLinkAction *)notificationLinkAction{

    objc_setAssociatedObject(self, @selector(notificationLinkAction), notificationLinkAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)saveNotifiactionLinkActionWithAccount:(NSString *)account moduleId:(NSInteger)moduleId moduleType:(NSInteger)moduleType actionType:(NSInteger)actionType linkName:(NSString *)linkName linkType:(MXRNotificationLinkType)linkType
{
    self.notificationLinkAction = [[MXRDataNotificationLinkAction alloc]initWithAccount:account moduleId:moduleId moduleType:moduleType actionType:actionType userId:[[UserInformation modelInformation].userID integerValue]linkName:linkName linkType:linkType];
    [MXRDataAnalyze saveUesrAction:self.notificationLinkAction];
}


@end

@implementation UIViewController (Presentation)

- (void)showAtTop {
    UIViewController *topVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while ([[topVc.childViewControllers  lastObject] presentedViewController]) {
        topVc = [[topVc.childViewControllers lastObject] presentedViewController];
    }
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [topVc presentViewController:self animated:YES completion:nil];
}

@end

@implementation UINavigationController (Presentation)

- (void)showAtTop {
    UIViewController *topVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while ([[topVc.childViewControllers  lastObject] presentedViewController]) {
        topVc = [[topVc.childViewControllers lastObject] presentedViewController];
    }
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [topVc presentViewController:self animated:YES completion:nil];
}

@end

@implementation UIViewController (Current)

- (BOOL)isCurrentViewController {
    UIViewController * viewControllerNow = [UIViewController currentViewController];
    return [viewControllerNow  isKindOfClass:[self class]];
}

+(UIViewController*) findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
}

+(UIViewController*) currentViewController {
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
    
}

@end
