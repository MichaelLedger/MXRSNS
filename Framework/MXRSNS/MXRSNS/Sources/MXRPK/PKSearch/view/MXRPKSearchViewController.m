//
//  MXRPKSearchViewController.m
//  huashida_home
//
//  Created by shuai.wang on 2018/1/16.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKSearchViewController.h"
//#import "AppDelegate.h"
#import "MXRPKConstants.h"
#import "UIImageView+WebCache.h"
#import "MXRPKNetworkManager.h"
#import "UIImage+Extend.h"
#import "MXRUserHeaderView.h"

@interface MXRPKSearchViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *currentUserBgImage;  //pk完成时当前用户的头像背景
@property (weak, nonatomic) IBOutlet UIImageView *currentUserImage;  //pk匹配完成时当前用户的头像
@property (weak, nonatomic) IBOutlet MXRUserHeaderView *currentUserHeaderView;

@property (weak, nonatomic) IBOutlet UILabel *currentUserName;  //pk匹配完成时当前用户的昵称
@property (weak, nonatomic) IBOutlet UIImageView *pkUserBgImage;  //pk对象的头像背景
@property (weak, nonatomic) IBOutlet UIImageView *pkUserImage;   //pk对象的图像
@property (weak, nonatomic) IBOutlet MXRUserHeaderView *pkUserHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *pkUserName;   //pk对象的昵称
@property (weak, nonatomic) IBOutlet UIImageView *pkSearchPrompt;  //中间的匹配搜索提示
@property (weak, nonatomic) IBOutlet UIImageView *unknowUserIcon;  //未知用户头像
@property (weak, nonatomic) IBOutlet UILabel *unknowLable;   //未知Lable
@property (weak, nonatomic) IBOutlet UILabel *pkSearchingCurrentUserName;  //pk搜索中当前的用户昵称
@property (weak, nonatomic) IBOutlet UIImageView *pkSearcingImageView;  //搜索中的背景图
@property (weak, nonatomic) IBOutlet UIImageView *pkSearchingCurrentUserCycle;   //搜索中用户头像外的红色圆框
@property (weak, nonatomic) IBOutlet UIImageView *pkSearchingCurrentUserIcon;   //搜索中的用户头像
@property (weak, nonatomic) IBOutlet MXRUserHeaderView *pkSearchingCurrentUserHeaderView;

@property (weak, nonatomic) IBOutlet UIButton *refreshButton;   //刷新按钮
@property (weak, nonatomic) IBOutlet UILabel *refreshLable;     //刷新提示Lable

@property (nonatomic) CGRect currentUserBgImageFrame;
@property (nonatomic) CGRect pkUserBgImageFrame;
@property (nonatomic) CGRect pkSearchPromptFrame;
@property (nonatomic) CGRect pkUserImageFrame;
@property (nonatomic) CGRect currentUserImageFrame;
@property (nonatomic) CGRect pkUserNameFrame;
@property (nonatomic) CGRect currentUserNameFrame;

@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic, strong) MXRPKUserInfoModel *pkUserInfoModel;
@end

@implementation MXRPKSearchViewController

+(instancetype)pkSearchViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:PK_STORYBOARD_NAME bundle:[NSBundle bundleForClass:[self class]]];
    MXRPKSearchViewController *vc = [sb instantiateViewControllerWithIdentifier:PK_SEGUE_SHOW_PK_SEARCH];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self searchPKOpponentInfo];
}

-(void)searchPKOpponentInfo {
    self.pkSearchingCurrentUserHeaderView.headerUrl = [UserInformation modelInformation].userImage;
    BOOL isUserVIP = [UserInformation modelInformation].vipFlag;
    self.pkSearchingCurrentUserHeaderView.vip = isUserVIP;
    self.pkSearchingCurrentUserName.text = [UserInformation modelInformation].userNickName;
    self.refreshLable.text = MXRLocalizedString(@"MXRPKSearch_Refresh_Prompt", @"很可能是网络问题，点击刷新按钮再试一次吧");
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    
    [self requestPKOpponentInfo];
}

-(void)requestPKOpponentInfo {
    @MXRWeakObj(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [MXRPKNetworkManager getPKUserInfoWithSuccess:^(MXRPKUserInfoModel *pkUserInfoModel) {
            selfWeak.pkUserInfoModel = pkUserInfoModel;
            selfWeak.pkSearchPrompt.image = MXRIMAGE(@"img_pk_matchSuccess");
            //关闭定时器
            [selfWeak.timer setFireDate:[NSDate distantFuture]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [selfWeak showPKSearchSuccessViewWithAnimation];
            });
           
        } failure:^(MXRServerStatus status, id result) {
            [selfWeak showPKSearchFailViewWithAnimation];
        }];
    });
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //取消定时器
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark - private  / UI
//搜索中图片自传
-(void)onTimer:(NSTimer *)timer {
    static int angle = 0;
    angle += 3;
    self.pkSearcingImageView.transform = CGAffineTransformMakeRotation(angle*M_PI/180);
    if (angle>= 360) {
        angle = angle%360;
    }
}
#pragma mark -展示pk搜索失败动画
-(void)showPKSearchFailViewWithAnimation {
    //关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    self.pkSearchingCurrentUserHeaderView.hidden = YES;
    self.pkSearchingCurrentUserCycle.hidden = YES;
    self.pkSearcingImageView.hidden = YES;
    self.pkSearchingCurrentUserName.hidden = YES;
    self.pkSearchPrompt.image = MXRIMAGE(@"icon_pk_matchFail");

    self.refreshButton.hidden = NO;
    self.refreshLable.hidden = NO;
}

#pragma mark -展示pk搜索成功动画
-(void)showPKSearchSuccessViewWithAnimation {
    self.pkUserName.text = self.pkUserInfoModel.randomOpponentResult.userName;
    self.currentUserName.text = [UserInformation modelInformation].userNickName;
    [self resetAnimationOriginalFrame];
    [self showPKSuccessBefore];
    [self showCurrentUserWithAnimation];
    BOOL isCurrentUserVIP = [UserInformation modelInformation].vipFlag;
    self.currentUserHeaderView.vip = isCurrentUserVIP;
}

-(void)resetAnimationOriginalFrame {
    //动画前预置头像初始动画位置及透明度，记录原始图片位置
    self.currentUserImageFrame = self.currentUserHeaderView.frame;
    self.currentUserBgImageFrame = self.currentUserBgImage.frame;
    self.pkUserBgImageFrame = self.pkUserBgImage.frame;
    self.pkUserImageFrame = self.pkUserHeaderView.frame;
    self.pkSearchPromptFrame = self.pkSearchPrompt.frame;
    self.pkUserNameFrame = self.pkUserName.frame;
    self.currentUserNameFrame = self.currentUserName.frame;
}

-(void)showPKSuccessBefore {
    //关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    
    self.pkSearchPrompt.alpha = 0;
    self.pkSearchingCurrentUserHeaderView.hidden = YES;
    self.pkSearchingCurrentUserCycle.hidden = YES;
    self.pkSearcingImageView.hidden = YES;
    self.unknowLable.hidden = YES;
    self.unknowUserIcon.hidden = YES;
    self.pkSearchingCurrentUserName.hidden = YES;
    self.pkSearchPrompt.image = MXRIMAGE(@"img_pk_search_vs");

    self.currentUserHeaderView.headerUrl = [UserInformation modelInformation].userImage;
    self.pkUserHeaderView.headerUrl = self.pkUserInfoModel.randomOpponentResult.userIcon;
    BOOL isThatUserVIP = self.pkUserInfoModel.randomOpponentResult.vipFlag;
    self.pkUserHeaderView.vip = isThatUserVIP;
    
}

-(void)showCurrentUserWithAnimation {
    self.currentUserHeaderView.frame = CGRectMake(SCREEN_WIDTH_DEVICE/2, SCREEN_HEIGHT_DEVICE/2, 0, 0);
    self.currentUserBgImage.frame = CGRectMake(SCREEN_WIDTH_DEVICE/2, SCREEN_HEIGHT_DEVICE/2, 0, 0);
    self.currentUserName.frame = CGRectMake(SCREEN_WIDTH_DEVICE/2, SCREEN_HEIGHT_DEVICE/2, 0, 0);
    @MXRWeakObj(self);
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         selfWeak.currentUserBgImage.hidden = NO;
                         selfWeak.currentUserBgImage.frame = selfWeak.currentUserBgImageFrame;
                         
                         selfWeak.currentUserHeaderView.hidden = NO;
                         selfWeak.currentUserHeaderView.frame = selfWeak.currentUserImageFrame;
                         
                         selfWeak.currentUserName.hidden = NO;
                         selfWeak.currentUserName.frame = selfWeak.currentUserNameFrame;
                     }
                     completion:^(BOOL finished) {
                         
                         [selfWeak showPKUserWithAnimation];
                     }
     ];
}

-(void)showPKUserWithAnimation {
    self.pkUserHeaderView.frame = CGRectMake(SCREEN_WIDTH_DEVICE/2, SCREEN_HEIGHT_DEVICE/2, 0, 0);
    self.pkUserBgImage.frame = CGRectMake(SCREEN_WIDTH_DEVICE/2, SCREEN_HEIGHT_DEVICE/2, 0, 0);
    self.pkUserName.frame = CGRectMake(SCREEN_WIDTH_DEVICE/2, SCREEN_HEIGHT_DEVICE/2, 0, 0);
    @MXRWeakObj(self);
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         selfWeak.pkUserBgImage.hidden= NO;
                         selfWeak.pkUserBgImage.frame = selfWeak.pkUserBgImageFrame;

                         selfWeak.pkUserHeaderView.hidden = NO;
                         selfWeak.pkUserHeaderView.frame = selfWeak.pkUserImageFrame;
                         
                         selfWeak.pkUserName.hidden = NO;
                         selfWeak.pkUserName.frame = selfWeak.pkUserNameFrame;
                     }
                     completion:^(BOOL finished) {
                         selfWeak.pkUserName.alpha = 1;
                         [selfWeak showVSImageViewWithAnimation];
                     }
     ];
}

-(void)showVSImageViewWithAnimation {
    self.pkSearchPrompt.frame = [UIScreen mainScreen].bounds;
    @MXRWeakObj(self);
    [UIView animateWithDuration:0.1 animations:^{
        selfWeak.pkSearchPrompt.alpha = 1;
        CGFloat pkSearchPromptWidth = SCREEN_WIDTH_DEVICE*(150.f/375.f);
        CGFloat pkSearchPromptHeight = pkSearchPromptWidth*(176.f/290.f);
        selfWeak.pkSearchPrompt.frame = CGRectMake((SCREEN_WIDTH_DEVICE-pkSearchPromptWidth)/2, (SCREEN_HEIGHT_DEVICE-pkSearchPromptHeight)/2, pkSearchPromptWidth, pkSearchPromptHeight);
    } completion:^(BOOL finished) {
        //因为跳转答题页前需要先退出pk搜索，这样就会看到退出到pk首页的画面，为了达到更好的过渡效果，在window上加一层视图，已达到完美过渡的效果
        UIImage *image = [UIImage getImageFromView:self.view];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.tag = PK_TRANSITION_ANIMATION_TAG;
//        [APP_DELEGATE.window addSubview:imageView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //跳转PK答题界面
            if ([selfWeak.delegate respondsToSelector:@selector(dismissMXRPKSearchViewControllerWithMXRPKUserInfoModel:)]) {
                [selfWeak.delegate dismissMXRPKSearchViewControllerWithMXRPKUserInfoModel:selfWeak.pkUserInfoModel];
            }
        });
    }];
}

#pragma mark - 点击事件Action
/**
 返回按钮
 */
-(IBAction)onBackButtonClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 刷新重试按钮
 */
- (IBAction)onPKSearchRefreshButtonclick:(id)sender {
    [self.timer setFireDate:[NSDate distantPast]];
    
//    self.pkSearchingCurrentUserIcon.hidden = NO;
    self.pkSearchingCurrentUserHeaderView.hidden = NO;
    self.pkSearchingCurrentUserCycle.hidden = NO;
    self.pkSearcingImageView.hidden = NO;
    self.pkSearchingCurrentUserName.hidden = NO;
    self.pkSearchPrompt.image = MXRIMAGE(@"img_pk_searchingUser");
    
    self.refreshButton.hidden = YES;
    self.refreshLable.hidden = YES;
    
    [self requestPKOpponentInfo];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {

}
@end
