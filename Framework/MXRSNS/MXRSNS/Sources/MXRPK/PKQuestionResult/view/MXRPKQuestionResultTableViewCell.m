//
//  MXRPKQuestionResultTableViewCell.m
//  huashida_home
//
//  Created by MountainX on 2018/8/8.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKQuestionResultTableViewCell.h"
#import "MXRPKQuestionResultController.h"
//#import "AppDelegate.h"
//#import "MXBNetwork.h"
//#import "MXRChangeMXBManager.h"
//#import "MXRGainMXBByTaskViewController.h"
#import "UIViewController+Ex.h"
#import "MXRWrongAnalysisViewController.h"

@interface MXRPKQuestionResultTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *resultIv;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UIButton *analysisBtn;
@property (weak, nonatomic) IBOutlet UIButton *againBtn;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UILabel *unlockMXBLabel;
@property (weak, nonatomic) IBOutlet UIImageView *unlockMXBBadgeIv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *analysisBtnTopConstraint;

@end

@implementation MXRPKQuestionResultTableViewCell

static NSString *const cellIdentifier = @"MXRPKQuestionResultTableViewCell";
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    MXRPKQuestionResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MXRPKQuestionResultTableViewCell" owner:nil options:nil] firstObject];
        [cell resetUI];
    }
    return cell;
}

- (void)resetUI {
    _unlockMXBLabel.transform = CGAffineTransformMakeRotation(M_PI * (30.0/180));
    
    [_analysisBtn setTitle:MXRLocalizedString(@"MXR_PK_MC_WRONG_ANALYSIS", @"答案解析") forState:UIControlStateNormal];
    [_againBtn setTitle:MXRLocalizedString(@"MXR_PK_MC_TRY_IT_AGAIN", @"再测一次") forState:UIControlStateNormal];
    [_inviteBtn setTitle:MXRLocalizedString(@"MXR_PK_MC_INVITE_FRIENDS", @"邀请好友PK") forState:UIControlStateNormal];
}

- (void)setMineResult:(MXRRandomOpponentResult *)mineResult {
    _mineResult = mineResult;
    
    if (mineResult.accuracy < 60) {
        _resultIv.image = MXRIMAGE(@"icon_missionCompleteResultUnder60");
        
        NSString *rateOnlyStr = MXRLocalizedString(@"MXR_PK_MC_EMM_ACCURACY_RATE_ONLY", @"啊哦，答题正确率只有");
        NSString *accuracyNumStr = [NSString stringWithFormat:@"%ld%%", _mineResult.accuracy];
        NSString *retryStr = MXRLocalizedString(@"MXR_PK_MC_CHALLENGE_IT_AGAIN", @"，再挑战一次吧！");
        NSString *accuracyStr = [NSString stringWithFormat:@"%@%@%@", rateOnlyStr, accuracyNumStr, retryStr];
        NSMutableAttributedString *accuracyAttr = [[NSMutableAttributedString alloc] initWithString:accuracyStr];
        [accuracyAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_333333 range:NSMakeRange(0, rateOnlyStr.length)];
        [accuracyAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_FF001F range:NSMakeRange(rateOnlyStr.length, accuracyNumStr.length)];
        [accuracyAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_333333 range:NSMakeRange(accuracyStr.length - retryStr.length, retryStr.length)];
        _accuracyLabel.attributedText = accuracyAttr;
    } else {
        _resultIv.image = MXRIMAGE(@"icon_missionCompleteResult");
        
        NSString *congratulationStr = MXRLocalizedString(@"MXR_PK_MC_CONGRATULATIONS", @"真棒，答题正确率");
        NSString *accuracyNumStr = [NSString stringWithFormat:@"%ld%%", _mineResult.accuracy];
        NSString *surpassStr = MXRLocalizedString(@"MXR_PK_MC_BETTER_THAN", @"超越了");
        NSString *challengerNumStr = [NSString stringWithFormat:@"%ld", _submitResultModel.surpassPersons];
        NSString *challengerStr = MXRLocalizedString(@"MXR_PK_MC_CHALLENGER", @"名挑战者");
        NSString *accuracyStr = [NSString stringWithFormat:@"%@%@\n%@%@%@", congratulationStr, accuracyNumStr, surpassStr, challengerNumStr, challengerStr];
        NSMutableAttributedString *accuracyAttr = [[NSMutableAttributedString alloc] initWithString:accuracyStr];
        [accuracyAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_333333 range:NSMakeRange(0, congratulationStr.length)];
        [accuracyAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_2FB8E2 range:NSMakeRange(congratulationStr.length, accuracyNumStr.length)];
        [accuracyAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_333333 range:NSMakeRange(congratulationStr.length + accuracyNumStr.length + 1, surpassStr.length)];
        [accuracyAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_FF001F range:NSMakeRange(congratulationStr.length + accuracyNumStr.length + surpassStr.length + 1, challengerNumStr.length)];
        [accuracyAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_333333 range:NSMakeRange(congratulationStr.length + accuracyNumStr.length + surpassStr.length + challengerNumStr.length + 1, challengerStr.length)];
        _accuracyLabel.attributedText = accuracyAttr;
    }
    
    if (_mineResult.accuracy >= 100) {
        _analysisBtn.hidden = YES;
        _unlockMXBLabel.hidden = YES;
        _unlockMXBBadgeIv.hidden = YES;
        _analysisBtnTopConstraint.constant = 32 - 60;
    } else {// 显示答案解析
        if (_submitResultModel.isNeedMxbAnalysis == 0 && _submitResultModel.isNeedMxbAnalysisNum > 0) {//错题解析需要梦想币
            _unlockMXBLabel.hidden = NO;
            _unlockMXBBadgeIv.hidden = NO;
        } else {
            _unlockMXBLabel.hidden = YES;
            _unlockMXBBadgeIv.hidden = YES;
        }
        _analysisBtn.hidden = NO;
        _analysisBtnTopConstraint.constant = 32;
    }
}

- (void)setSubmitResultModel:(MXRPKSubmitResultModel *)submitResultModel {
    _submitResultModel = submitResultModel;
    
    if (_submitResultModel.isNeedMxbAnalysis == 0 && _submitResultModel.isNeedMxbAnalysisNum > 0) {//错题解析需要梦想币
        _unlockMXBLabel.hidden = NO;
        _unlockMXBBadgeIv.hidden = NO;
        _unlockMXBLabel.text = [NSString stringWithFormat:@"%ld%@", _submitResultModel.isNeedMxbAnalysisNum,MXRLocalizedString(@"MY_MXB", @"梦想币")];
    } else {
        _unlockMXBLabel.hidden = YES;
        _unlockMXBBadgeIv.hidden = YES;
    }
}

- (IBAction)analysisBtnClicked:(UIButton *)sender {
    DLOG_METHOD
    if (_submitResultModel.isNeedMxbAnalysis == 0 && _submitResultModel.isNeedMxbAnalysisNum > 0) {//错题解析需要梦想币
        // 提示是否购买错题解析（MXR_PK_RESULT_SURE_TO_BUY）
        @MXRWeakObj(self);
        NSString *title = [NSString stringWithFormat:@"%@%@?", MXRLocalizedString(@"MXR_PK_RESULT_SURE_TO_BUY", @"确认购买") , MXRLocalizedString(@"MXR_PK_MC_WRONG_ANALYSIS", @"答案解析")];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:MXRLocalizedString(@"PROMPT", @"提示") message:title preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:MXRLocalizedString(@"SURE", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [MXRPKQuestionResultController purchaseWrongAnalysisWithQAId:_qaId success:^(MXRNetworkResponse *response) {
                DLOG(@"购买成功进入错题解析");
                selfWeak.submitResultModel.isNeedMxbAnalysis = 1;// 已解锁
                selfWeak.unlockMXBLabel.hidden = YES;
                selfWeak.unlockMXBBadgeIv.hidden = YES;
                
                // 直接进入错题解析
                MXRWrongAnalysisViewController *vc = [[MXRWrongAnalysisViewController alloc] initWithNibName:@"MXRWrongAnalysisViewController" bundle:[NSBundle bundleForClass:[self class]]];
                vc.pkQuestionLibModel = selfWeak.pkQuestionLibModel;
                vc.mineResult = selfWeak.mineResult;
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
        vc.pkQuestionLibModel = self.pkQuestionLibModel;
        vc.mineResult = self.mineResult;
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

- (IBAction)retryBtnClicked:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RNNoti_MissionTryAgain object:nil];
}

- (IBAction)inviteBtnClicked:(UIButton *)sender {
    NSDictionary *params = @{@"bookGuid" : _bookGuid,
                             @"qaId" : @(_qaId),
                             @"accuracy" : @(_mineResult.accuracy),
                             @"qaName" : _qaName
                             };
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RNNoti_MissionCompleteInviteFriends object:nil userInfo:params];
}


@end
