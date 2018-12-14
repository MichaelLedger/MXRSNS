//
//  MXRPKResultViewController.m
//  huashida_home
//
//  Created by MountainX on 2018/8/21.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKResultViewController.h"
#import "MXRPKQuestionResultBookTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+MXRGradientBackground.h"
#import "MXRPKQuestionResultController.h"
#import "MXRWrongAnalysisViewController.h"
//#import "MXBNetwork.h"
//#import "MXRChangeMXBManager.h"
//#import "MXRGainMXBByTaskViewController.h"
#import "UIViewController+Ex.h"
//#import "AppDelegate.h"
//#import "MXBManager.h"
#import "MXRUserHeaderView.h"

#define KHeaderHeight 50.f

@interface MXRPKResultViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *tableViewHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnTopConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *resultIv;
@property (weak, nonatomic) IBOutlet UIView *leftLogoBg;
@property (weak, nonatomic) IBOutlet UIImageView *leftLogoIv;
@property (weak, nonatomic) IBOutlet UIView *rightLogoBg;
@property (weak, nonatomic) IBOutlet UIImageView *rightLogoIv;
@property (weak, nonatomic) IBOutlet UIImageView *leftCrownIv;
@property (weak, nonatomic) IBOutlet UIImageView *rightCrownIv;
@property (weak, nonatomic) IBOutlet UILabel *leftUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftAccuracyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAccuracyTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *againBtn;
@property (weak, nonatomic) IBOutlet UIButton *analysisBtn;
@property (weak, nonatomic) IBOutlet UILabel *unlockCoinNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *unlockCoinBadgeIv;
@property (weak, nonatomic) IBOutlet UILabel *shareHintLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *analysisBtnHeightConstraint;

@property (weak, nonatomic) IBOutlet MXRUserHeaderView *leftUserHeaderView;
@property (weak, nonatomic) IBOutlet MXRUserHeaderView *rightUserHeaderView;

@property (weak, nonatomic) IBOutlet UIView *gainMXBView;
@property (weak, nonatomic) IBOutlet UIButton *gainMXBNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *gainMXBBtn;

@end

@implementation MXRPKResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mxr_preferredNavigationBarHidden = YES;// 隐藏导航
    self.disablePopGestureRecognizer = YES;// 禁止侧滑返回

    [self internationalization];
    
    [self setupUI];
    
    
}

#pragma mark - ModifyUI
- (void)setupUI {
    UIImage *crownImg = MXRIMAGE(@"icon_crown");
    self.rightCrownIv.image = [[UIImage alloc] initWithCGImage:crownImg.CGImage scale:crownImg.scale orientation:UIImageOrientationUpMirrored];
    self.backBtnTopConstraint.constant = STATUS_BAR_HEIGHT;
    
    self.leftLogoIv.layer.borderWidth = 5.f;
    self.leftLogoIv.layer.borderColor = MXRCOLOR_FFFFFF.CGColor;
    self.rightLogoIv.layer.borderWidth = 5.f;
    self.rightLogoIv.layer.borderColor = MXRCOLOR_FFFFFF.CGColor;
    [self.leftLogoBg mxr_setGradientBackGoundStyle:MXRUIViewGradientStyle_FF405F_FF7A4D];
    [self.rightLogoBg mxr_setGradientBackGoundStyle:MXRUIViewGradientStyle_80F0EA_29AAFE];
    
    self.leftUserNameLabel.text = [UserInformation modelInformation].userNickName;
    self.rightUserNameLabel.text = self.infoModel.randomOpponentResult.userName;
    
    [self.leftLogoIv sd_setImageWithURL:[NSURL URLWithString:[UserInformation modelInformation].userImage] placeholderImage:MXRIMAGE(@"icon_common_xiaomeng")];
    [self.rightLogoIv sd_setImageWithURL:[NSURL URLWithString:autoString(self.infoModel.randomOpponentResult.userIcon)] placeholderImage:MXRIMAGE(@"icon_common_xiaomeng")];
    
    //VIP专属边框
    if ([[UserInformation modelInformation].userImage isKindOfClass:[NSString class]]) {
        self.leftUserHeaderView.headerUrl = [UserInformation modelInformation].userImage;
    }else if([[UserInformation modelInformation].userImage isKindOfClass:[UIImage class]]){
        self.leftUserHeaderView.placeHolderheaderImage = (UIImage *)[UserInformation modelInformation].userImage;
    }else {
        self.leftUserHeaderView.placeHolderheaderImage = MXRIMAGE(@"icon_common_default_head");
    }
    self.leftUserHeaderView.vip = [UserInformation modelInformation].vipFlag;

    if (self.infoModel.randomOpponentResult.userId == [[UserInformation modelInformation].userID integerValue]) {
        if ([[UserInformation modelInformation].userImage isKindOfClass:[NSString class]]) {
            self.rightUserHeaderView.headerUrl = [UserInformation modelInformation].userImage;
        }else if([[UserInformation modelInformation].userImage isKindOfClass:[UIImage class]]){
            self.rightUserHeaderView.placeHolderheaderImage = (UIImage *)[UserInformation modelInformation].userImage;
        }else {
            self.rightUserHeaderView.placeHolderheaderImage = MXRIMAGE(@"icon_common_default_head");
        }
        self.rightUserHeaderView.vip = [UserInformation modelInformation].vipFlag;
    }else{
        self.rightUserHeaderView.headerUrl = autoString(self.infoModel.randomOpponentResult.userIcon);
        self.rightUserHeaderView.vip = self.infoModel.randomOpponentResult.vipFlag;
    }
    
    self.leftAccuracyLabel.text = [NSString stringWithFormat:@"%ld%%", self.infoModel.mineResult.accuracy];
    self.rightAccuracyLabel.text = [NSString stringWithFormat:@"%ld%%", self.infoModel.randomOpponentResult.accuracy];
    
    if (self.infoModel.mineResult.accuracy > self.infoModel.randomOpponentResult.accuracy) {
        self.resultIv.image = MXRIMAGE(@"icon_pkSuccess");
        self.leftCrownIv.hidden = NO;
        self.rightCrownIv.hidden = YES;
        
        [self.againBtn setTitle:MXRLocalizedString(@"MXR_PK_RESULT_CONTINUE", @"继续PK") forState:UIControlStateNormal];
        [self.againBtn setTitleEdgeInsets:UIEdgeInsetsMake(-18, 0, 0, 0)];
        self.shareHintLabel.hidden = NO;
    } else  {
        if (self.infoModel.mineResult.accuracy < self.infoModel.randomOpponentResult.accuracy) {
            self.resultIv.image = MXRIMAGE(@"icon_pkFailure");
            self.leftCrownIv.hidden = YES;
            self.rightCrownIv.hidden = NO;
        } else {
            self.resultIv.image = MXRIMAGE(@"icon_pkTie");
            self.leftCrownIv.hidden = YES;
            self.rightCrownIv.hidden = YES;
        }
        [self.againBtn setTitle:MXRLocalizedString(@"MXR_PK_RESULT_RETRY", @"再战一局") forState:UIControlStateNormal];
        [self.againBtn setTitleEdgeInsets:UIEdgeInsetsZero];
        self.shareHintLabel.hidden = YES;
    }
    
    // 全部正确则隐藏错题解析
    if (self.infoModel.mineResult.accuracy >= 100) {
        self.analysisBtn.hidden = YES;
        self.analysisBtnHeightConstraint.constant = -50;
        
        self.unlockCoinBadgeIv.hidden = YES;
        self.unlockCoinNumLabel.hidden = YES;
    } else {
        self.analysisBtn.hidden = NO;
        self.analysisBtnHeightConstraint.constant = 50;
        
        if (self.submitResultModel.isNeedMxbAnalysis == 0 && self.submitResultModel.isNeedMxbAnalysisNum > 0) {
            self.unlockCoinBadgeIv.hidden = NO;
            self.unlockCoinNumLabel.hidden = NO;
            self.unlockCoinNumLabel.text = [NSString stringWithFormat:@"%ld%@", self.submitResultModel.isNeedMxbAnalysisNum, MXRLocalizedString(@"MY_MXB", @"梦想币")];
            self.unlockCoinNumLabel.transform = CGAffineTransformMakeRotation(M_PI * (30.0/180));
        } else {
            self.unlockCoinBadgeIv.hidden = YES;
            self.unlockCoinNumLabel.hidden = YES;
        }
    }
    
    // 获赠梦想币
    [self.gainMXBBtn mxr_setGradientBackGoundStyle:MXRUIViewGradientStyle_FF7A4D_FF405F direction:MXRUIViewLinearGradientDirectionVertical];
    if (self.submitResultModel.awardMxbNum > 0) {
        self.gainMXBView.hidden = NO;
    } else {
        self.gainMXBView.hidden = YES;
    }
    
    CGFloat height = [self.tableViewHeader systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = self.tableViewHeader.frame;
    frame.size.height = height;
    self.tableViewHeader.frame = frame;
    
    self.tableView.tableHeaderView = self.tableViewHeader;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Internationalization
- (void)internationalization {
    self.title = MXRLocalizedString(@"MXR_PK_RESULT_TITLE", @"PK结果");
    self.titleLabel.text = MXRLocalizedString(@"MXR_PK_RESULT_TITLE", @"PK结果");
    
    [self.againBtn setTitle:MXRLocalizedString(@"MXR_PK_RESULT_CONTINUE", @"继续PK") forState:UIControlStateNormal];
    [self.analysisBtn setTitle:MXRLocalizedString(@"MXR_PK_RESULT_ANALYSIS", @"答案解析") forState:UIControlStateNormal];
    self.leftAccuracyTitleLabel.text = MXRLocalizedString(@"MXR_PK_RESULT_ACCURACY", @"正确率");
    self.rightAccuracyTitleLabel.text = MXRLocalizedString(@"MXR_PK_RESULT_ACCURACY", @"正确率");
    self.shareHintLabel.text = MXRLocalizedString(@"MXR_PK_RESULT_SHOT_TO_SHARE", @"截图分享炫耀下战绩吧!");
    [self.gainMXBNumBtn setTitle:[NSString stringWithFormat:MXRLocalizedString(@"MXR_PK_RESULT_GAINMXB", @"PK获胜，赢得%ld梦想币"), self.submitResultModel.awardMxbNum] forState:UIControlStateNormal];
    [self.gainMXBBtn setTitle:MXRLocalizedString(@"MXR_PK_RESULT_DRAW", @"领取") forState:UIControlStateNormal];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (_infoModel.pkQuestionLibModel.recommendBook && _infoModel.pkQuestionLibModel.recommendBook.bookGuid && _infoModel.pkQuestionLibModel.recommendBook.bookGuid.length > 0) ? 1 : 0;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MXRPKQuestionResultBookTableViewCell *cell = [MXRPKQuestionResultBookTableViewCell cellWithTableView:tableView];
    cell.book = _infoModel.pkQuestionLibModel.recommendBook;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_infoModel.pkQuestionLibModel.recommendBook && _infoModel.pkQuestionLibModel.recommendBook.bookGuid && _infoModel.pkQuestionLibModel.recommendBook.bookGuid.length > 0) {
        return KHeaderHeight;
    } else {
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_infoModel.pkQuestionLibModel.recommendBook && _infoModel.pkQuestionLibModel.recommendBook.bookGuid && _infoModel.pkQuestionLibModel.recommendBook.bookGuid.length > 0) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, KHeaderHeight)];
        header.backgroundColor = MXRCOLOR_FFFFFF;
        UILabel *sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH_DEVICE - 2 * 16, KHeaderHeight)];
        sectionTitleLabel.text = MXRLocalizedString(@"MXR_PK_MC_MORE_KNOWLEDGE_InBook", @"这本书里还有很多意想不到的知识哦！");
        sectionTitleLabel.textColor = MXRCOLOR_333333;
        sectionTitleLabel.font = [UIFont boldSystemFontOfSize:15];
        [header addSubview:sectionTitleLabel];
        return header;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Events
- (IBAction)backBtnClicked:(id)sender {
    mxr_dispatch_main_async_safe(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RNNoti_ColseMissionCompleye object:nil];
    });
}

- (IBAction)againBtnClicked:(UIButton *)sender {
    mxr_dispatch_main_async_safe(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RNNoti_PKAgain object:nil];
    });
}

- (IBAction)analysisBtnClicked:(UIButton *)sender {
    DLOG_METHOD
    if (_submitResultModel.isNeedMxbAnalysis == 0 && _submitResultModel.isNeedMxbAnalysisNum > 0) {//错题解析需要梦想币
        // 提示是否购买错题解析（MXR_PK_RESULT_SURE_TO_BUY）
        @MXRWeakObj(self);
        NSString *title = [NSString stringWithFormat:@"%@%@?", MXRLocalizedString(@"MXR_PK_RESULT_SURE_TO_BUY", @"确认购买") , MXRLocalizedString(@"MXR_PK_MC_WRONG_ANALYSIS", @"答案解析")];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:MXRLocalizedString(@"PROMPT", @"提示") message:title preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:MXRLocalizedString(@"SURE", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [MXRPKQuestionResultController purchaseWrongAnalysisWithQAId:autoInteger(self.infoModel.pkQuestionLibModel.qaId) success:^(MXRNetworkResponse *response) {
                DLOG(@"购买成功进入错题解析");
                selfWeak.submitResultModel.isNeedMxbAnalysis = 1;// 已解锁
                selfWeak.unlockCoinNumLabel.hidden = YES;
                selfWeak.unlockCoinBadgeIv.hidden = YES;
                
                // 直接进入错题解析
                MXRWrongAnalysisViewController *vc = [[MXRWrongAnalysisViewController alloc] initWithNibName:@"MXRWrongAnalysisViewController" bundle:[NSBundle bundleForClass:[self class]]];
                vc.pkQuestionLibModel = selfWeak.infoModel.pkQuestionLibModel;
                vc.mineResult = selfWeak.infoModel.mineResult;
                UIViewController *topVc = [UIApplication sharedApplication].keyWindow.rootViewController;
                while ([[topVc.childViewControllers  lastObject] presentedViewController]) {
                    topVc = [[topVc.childViewControllers lastObject] presentedViewController];
                }
                if ([topVc isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *nav = (UINavigationController *)topVc;
                    [nav pushViewController:vc animated:YES];
                } else {
                    [topVc.navigationController pushViewController:vc animated:YES];
                }
            } failure:^(NSError *error) {
                DLOG(@"购买失败提示赚取梦想币（MXR_PK_RESULT_LACK_OF_MXB）");
                [selfWeak earnMXB:selfWeak.submitResultModel.isNeedMxbAnalysisNum];
            }];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:MXRLocalizedString(@"CANCEL", @"取消") style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:confirmAction];
        [alert addAction:cancelAction];
        [alert showAtTop];
    } else {
        // 直接进入错题解析
        MXRWrongAnalysisViewController *vc = [[MXRWrongAnalysisViewController alloc] initWithNibName:@"MXRWrongAnalysisViewController" bundle:[NSBundle bundleForClass:[self class]]];
        vc.pkQuestionLibModel = self.infoModel.pkQuestionLibModel;
        vc.mineResult = self.infoModel.mineResult;
        UIViewController *topVc = [UIApplication sharedApplication].keyWindow.rootViewController;
        while ([[topVc.childViewControllers  lastObject] presentedViewController]) {
            topVc = [[topVc.childViewControllers lastObject] presentedViewController];
        }
        if ([topVc isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)topVc;
            [nav pushViewController:vc animated:YES];
        } else {
            [topVc.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)earnMXB:(NSInteger)needMXBCount {
    //V5.9.3 梦想钻转梦想币开关
    BOOL hideMXZExchangeEntrance = [[NSUserDefaults standardUserDefaults] boolForKey:HideMXZExchangeEntrance];
    if (hideMXZExchangeEntrance) {
//        MXBNetwork *mxbNetwork = [[MXBNetwork alloc] init];
//        [mxbNetwork getMengXiangBiOfUser:[UserInformation modelInformation].userID withCallBack:^(BOOL isServerOK, NSString *mxb) {
//            //            [UserInformation modelInformation].userTotalCount = [mxb integerValue];
//            //            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ForReloadMXBData object:nil];
//
//            mxr_dispatch_main_async_safe(^{
//                MXRGainMXBByTaskViewController *gainMXBByTaskVC = [[MXRGainMXBByTaskViewController alloc] init];
//                gainMXBByTaskVC.ownMXBCount = [UserInformation modelInformation].userTotalCount;
//                gainMXBByTaskVC.needMXBCount = needMXBCount;
//                gainMXBByTaskVC.oldNeedMXBCount = 0;
//                [gainMXBByTaskVC show];
//            })
//        }];
    } else {
//        mxr_dispatch_main_async_safe(^{
//            MXRChangeMXBManager *manager = [[MXRChangeMXBManager alloc] initWithViewController:APP_DELEGATE.navigationController];
//            [manager changeMXBCoinWithSuccessBlock:nil];
//        })
    }
}

- (IBAction)gainMXBBtnClicked:(UIButton *)sender {
    self.gainMXBView.hidden = YES;
//    [[MXBManager sharedInstance] coinComeTogetherAnimationWithCoinCount:self.submitResultModel.awardMxbNum];
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
