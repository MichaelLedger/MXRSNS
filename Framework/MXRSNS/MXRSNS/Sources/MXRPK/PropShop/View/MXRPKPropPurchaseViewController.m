//
//  MXRPKPropPurchaseViewController.m
//  huashida_home
//
//  Created by MountainX on 2018/10/22.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKPropPurchaseViewController.h"
#import "MXRRoundMaskView.h"
#import "Masonry.h"

//#import "MXRBuyViewController.h"
#import "MXRNavigationViewController.h"
//#import "MXRUserInfoNetwrokManager.h"
//#import "MXRUserInfoRequestModel.h"
//#import "MXRPersonNewController.h"
#import "GlobalBusyFlag.h"
#import "MXRPKNetworkManager.h"

@interface MXRPKPropPurchaseViewController ()

/*---------梦想币不足弹窗---------*/
@property (weak, nonatomic) IBOutlet UIView *rechargeView;
@property (weak, nonatomic) IBOutlet UILabel *rechargeTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *rechargeConfirmBtn;

/*---------购买成功弹窗---------*/
@property (weak, nonatomic) IBOutlet UIView *purchaseSuccessView;
@property (weak, nonatomic) IBOutlet UILabel *purchaseSuccessTitleLabel;

/*---------确认购买弹窗---------*/
@property (weak, nonatomic) IBOutlet UIView *purchaseAlertView;
@property (weak, nonatomic) IBOutlet UIButton *purchaseAlertCloseBtn;
@property (weak, nonatomic) IBOutlet UIView *maskContentView;
@property (weak, nonatomic) IBOutlet UILabel *purchaseAlertTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseAlertNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *purchaseAlertCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *purchaseAlertConfirmBtn;

@end

@implementation MXRPKPropPurchaseViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBA(0, 0, 0, 0.4);
    
    [self hideAll];
    
    [self addObserver];
    [self loadPersonMXZInfo];
    
    [self addRoundMask];
    [self setupUI];
}

- (void)dealloc {
    DLOG_METHOD
    [self removeObserver];
}

#pragma mark - Add Observer
- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configUI) name:Notification_ReloadPersonInfo object:nil];
}

#pragma mark - Remove Observer
- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 获取用户梦想钻信息
- (void)loadPersonMXZInfo {
    NSString *userId =  [UserInformation modelInformation].userID;
    if (userId !=nil && ![userId isEqualToString:@""] && ![userId isEqualToString:@"0"]) {
        //获取梦想钻等信息
//        MXRGetUserInfoR *getUserinfoR = [MXRGetUserInfoR new];
//        getUserinfoR.user = userId;
//        @MXRWeakObj(self);
//        [[GlobalBusyFlag sharedInstance] showBusyFlagOnWindow];
//        [MXRUserInfoNetwrokManager getUserInfo:getUserinfoR success:^(MXRNetworkResponse *response) {
//            [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
//            if (!response) {
//                DERROR(@"getPersonInfoData response object is null");
//                [MXRConstant showAlert:MXRLocalizedString(@"BADNET_ALERT", @"当前网络不佳") andShowTime:1.f];
//                [selfWeak dismissViewControllerAnimated:NO completion:nil];
//                return;
//            }
//            if (response.isSuccess) {
//
//                MXRGetUserInfoResponseModel *getuserInfoModel = [MXRGetUserInfoResponseModel mxr_modelWithJSON:response.body];
//                [[MXRPersonNewController getInstance] updateUserInfoWithModel:getuserInfoModel];
//                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ReloadPersonInfo object:nil];
//            }
//            else
//            {
//                DERROR(@"serverPesponse error");
//                [MXRConstant showAlert:MXRLocalizedString(@"BADNET_ALERT", @"当前网络不佳") andShowTime:1.f];
//                [selfWeak dismissViewControllerAnimated:NO completion:nil];
//            }
//        } failure:^(id error) {
//            [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
//            DERROR(@"serverPesponse error");
//            [MXRConstant showAlert:MXRLocalizedString(@"BADNET_ALERT", @"当前网络不佳") andShowTime:1.f];
//            [selfWeak dismissViewControllerAnimated:NO completion:nil];
//        }];
    }
}

#pragma mark - 添加弧形蒙版
- (void)addRoundMask {
    MXRRoundMaskView *maskView = [[MXRRoundMaskView alloc] init];
    maskView.backgroundColor = [UIColor whiteColor];
    maskView.passthroughViews = @[self.purchaseAlertCloseBtn];
    [self.maskContentView addSubview:maskView];
    [self.maskContentView bringSubviewToFront:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.maskContentView);
        make.bottom.equalTo(self.maskContentView.mas_bottom).offset(1);
        make.width.equalTo(self.maskContentView);
        make.height.equalTo(self.maskContentView.mas_width).multipliedBy(0.15);
    }];
}

#pragma mark - 国际化
- (void)setupUI {
    /*---------梦想币不足弹窗---------*/
    _rechargeTitleLabel.text = @"对不起，梦想钻不足";
    [_rechargeCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_rechargeConfirmBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    
    /*---------购买成功弹窗---------*/
    _purchaseSuccessTitleLabel.text = @"恭喜你，购买道具成功！";
    
    /*---------确认购买弹窗---------*/
    _purchaseAlertTitleLabel.text = @"确认购买道具";
    _purchaseAlertNumLabel.text = [NSString stringWithFormat:@"%ld", _shopModel.coinNum];
    [_purchaseAlertCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_purchaseAlertConfirmBtn setTitle:@"确认" forState:UIControlStateNormal];
}

#pragma mark - 根据用户梦想钻个数显示对应的弹窗
- (void)configUI {
    NSInteger userDiamond = [UserInformation modelInformation].userDiamonad;
    if (userDiamond > _shopModel.coinNum) {
        [self showPurchaseAlertView];
    } else {
        [self showRechargeView];
    }
}

#pragma mark - 隐藏全部
- (void)hideAll {
    _rechargeView.hidden = YES;
    _purchaseSuccessView.hidden = YES;
    _purchaseAlertView.hidden = YES;
}

#pragma mark - 显示梦想币不足弹窗
- (void)showRechargeView {
    _rechargeView.hidden = NO;
    _purchaseSuccessView.hidden = YES;
    _purchaseAlertView.hidden = YES;
}

#pragma mark - 显示购买成功弹窗
- (void)showPurchaseSuccessView {
    _rechargeView.hidden = YES;
    _purchaseSuccessView.hidden = NO;
    _purchaseAlertView.hidden = YES;
}

#pragma mark - 显示确认购买弹窗
- (void)showPurchaseAlertView {
    _rechargeView.hidden = YES;
    _purchaseSuccessView.hidden = YES;
    _purchaseAlertView.hidden = NO;
}

#pragma mark - Events
- (IBAction)rechargeCancelBtnClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)rechargeConfirmBtnClicked:(UIButton *)sender {
//    MXRBuyViewController *vc = [MXRBuyViewController buyViewController];
//    MXRNavigationViewController *navi = [[MXRNavigationViewController alloc] initWithRootViewController:vc];
//    vc.buyTypeFromPage = MXRBuyTypeFromCourse;
//    vc.isPresent = YES;
//    [[self topViewController] presentViewController:navi animated:YES completion:nil];
}

- (IBAction)purchaseAlertCloseBtnClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)purchaseAlertCancelBtnClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)purchaseAlertConfirmBtnClicked:(UIButton *)sender {
    @MXRWeakObj(self);
    [[GlobalBusyFlag sharedInstance] showBusyFlagOnWindow];
    [MXRPKNetworkManager purchasePropWithPropId:_shopModel.propId coinNum:_shopModel.coinNum success:^(MXRNetworkResponse *response) {
        [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
        if (response.isSuccess) {
            [selfWeak showPurchaseSuccessView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [selfWeak dismissViewControllerAnimated:NO completion:nil];
            });
        } else {
            [MXRConstant showAlert:MXRLocalizedString(@"BADNET_ALERT", @"当前网络不佳") andShowTime:1.f];
            [selfWeak dismissViewControllerAnimated:NO completion:nil];
        }
    } failure:^(id error) {
        [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
        [MXRConstant showAlert:MXRLocalizedString(@"BADNET_ALERT", @"当前网络不佳") andShowTime:1.f];
        [selfWeak dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
