//
//  MXRPKQuestionResultViewController.m
//  huashida_home
//
//  Created by MountainX on 2018/8/8.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKQuestionResultViewController.h"
#import "MXRPKQuestionResultTableViewCell.h"
#import "MXRPKQuestionResultBookTableViewCell.h"
#import "MXRPKQuestionResultRankTableViewCell.h"

#import "UIImageView+WebCache.h"

//#import "MXRNewShareView.h"
//#import "MXRMissionCompleteShareView.h"
#import "MXRScreenShotHelper.h"
#import "Notifications.h"
#import "UserInformation.h"
#import "GlobalBusyFlag.h"
#import "SDWebImageManager.h"
#import "MXRUserHeaderView.h"

@interface MXRPKQuestionResultViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *userIv;
@property (weak, nonatomic) IBOutlet UILabel *userRankLabel;
@property (weak, nonatomic) IBOutlet MXRUserHeaderView *userHeaderView;

@end

@implementation MXRPKQuestionResultViewController

#pragma mark - Convience Initialization
- (instancetype)initWithPKUserInfoModel:(MXRPKUserInfoModel *)infoModel submitResultModel:(MXRPKSubmitResultModel *)submitResultModel {
    if (self = [super init]) {
        _infoModel = infoModel;
        _submitResultModel = submitResultModel;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = MXRLocalizedString(@"MXR_PK_MC_TITLE", @"完成闯关");
    
    self.disablePopGestureRecognizer = YES;// 禁止侧滑返回
    
    self.view.backgroundColor = MXRCOLOR_F3F4F6;
    self.tableView.backgroundColor = MXRCOLOR_F3F4F6;
    
    [self addObservers];
    
    [self reloadBottomView];
}

-(void)dealloc{
    DLOG_METHOD
    [self removeObservers];
}

#pragma mark - Observers
-(void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(share:) name:Notification_RNNoti_MissionCompleteInviteFriends object:nil];
}

-(void)removeObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_RNNoti_MissionCompleteInviteFriends object:nil];
}

- (void)backAction:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    mxr_dispatch_main_async_safe(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RNNoti_ColseMissionCompleye object:nil];// 关闭答题
    });
}

- (void)reloadBottomView {
    [_userIv sd_setImageWithURL:[NSURL URLWithString:[UserInformation modelInformation].userImage] placeholderImage:MXRIMAGE(@"icon_common_xiaomeng")];
    
    NSString *mineRankStr = MXRLocalizedString(@"MXR_PK_MC_MINE_RANK", @"我排在第");
    NSString *rankNumStr = [NSString stringWithFormat:@"%ld", _submitResultModel.currentRankingSort];
    NSString *positionStr = MXRLocalizedString(@"MXR_PK_MC_RANK_POSITION", @"位");
    NSString *rankStr = [NSString stringWithFormat:@"%@%@%@", mineRankStr, rankNumStr, positionStr];
    NSMutableAttributedString *rankAttr = [[NSMutableAttributedString alloc] initWithString:rankStr];
    [rankAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_333333 range:NSMakeRange(0, mineRankStr.length)];
    [rankAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_2FB8E2 range:NSMakeRange(mineRankStr.length, rankNumStr.length)];
    [rankAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_333333 range:NSMakeRange(mineRankStr.length + rankNumStr.length, positionStr.length)];
    _userRankLabel.attributedText = rankAttr;
    
    if ([[UserInformation modelInformation].userImage isKindOfClass:[NSString class]]) {
        self.userHeaderView.headerUrl = [UserInformation modelInformation].userImage;
    }else if([[UserInformation modelInformation].userImage isKindOfClass:[UIImage class]]){
        self.userHeaderView.placeHolderheaderImage = (UIImage *)[UserInformation modelInformation].userImage;
    }else {
        self.userHeaderView.placeHolderheaderImage = MXRIMAGE(@"icon_common_default_head");
    }
    self.userHeaderView.vip = [UserInformation modelInformation].vipFlag;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return (_infoModel.pkQuestionLibModel.recommendBook && _infoModel.pkQuestionLibModel.recommendBook.bookGuid) ? 1 : 0;
        case 2:
            return _submitResultModel.rankingList.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            MXRPKQuestionResultTableViewCell *cell = [MXRPKQuestionResultTableViewCell cellWithTableView:tableView];
            cell.submitResultModel = _submitResultModel;
            cell.qaId = [_infoModel.pkQuestionLibModel.qaId integerValue];
            cell.qaName = autoString(_infoModel.pkQuestionLibModel.name);
            cell.bookGuid = autoString(_infoModel.pkQuestionLibModel.recommendBook.bookGuid);
            cell.mineResult = _infoModel.mineResult;
            cell.pkQuestionLibModel = _infoModel.pkQuestionLibModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 1:
        {
            MXRPKQuestionResultBookTableViewCell *cell = [MXRPKQuestionResultBookTableViewCell cellWithTableView:tableView];
            cell.book = _infoModel.pkQuestionLibModel.recommendBook;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 2:
        {
            MXRPKQuestionResultRankTableViewCell *cell = [MXRPKQuestionResultRankTableViewCell cellWithTableView:tableView];
            [cell autoRank:indexPath];
            MXRPKQARankModel *rankModel = [_submitResultModel.rankingList objectAtIndex:indexPath.row];
            cell.rankModel = rankModel;
            return cell;
        }
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerHeight;
    switch (section) {
        case 0:
            headerHeight = CGFLOAT_MIN;
            break;
        case 1:
            headerHeight = 50;
            break;
        case 2:
            headerHeight = 50;
            break;
        default:
            headerHeight = CGFLOAT_MIN;
            break;
    }
    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat headerHeight;
    switch (section) {
        case 0:
            headerHeight = CGFLOAT_MIN;
            break;
        case 1:
            headerHeight = 50;
            break;
        case 2:
            headerHeight = 50;
            break;
        default:
            headerHeight = CGFLOAT_MIN;
            break;
    }
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, headerHeight)];
    header.backgroundColor = [UIColor whiteColor];
    if (section == 1) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH_DEVICE - 16 * 2, headerHeight)];
        titleLabel.text = MXRLocalizedString(@"MXR_PK_MC_MORE_KNOWLEDGE_InBook", @"这本书里还有很多意想不到的知识哦！");
        titleLabel.textColor = MXRCOLOR_333333;
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [header addSubview:titleLabel];
    } else if (section == 2) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, (headerHeight - 14) / 2, 3, 14)];
        line.backgroundColor = MXRCOLOR_2FB8E2;
        [header addSubview:line];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame) + 16, 0, SCREEN_WIDTH_DEVICE - 16 * 2 - CGRectGetMaxX(line.frame), headerHeight)];
        titleLabel.text = MXRLocalizedString(@"MXR_PK_MC_RANKING", @"TOP10光荣榜");
        titleLabel.textColor = MXRCOLOR_333333;
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [header addSubview:titleLabel];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat footerHeight;
    switch (section) {
        case 0:
            footerHeight = 8;
            break;
        case 1:
            footerHeight = 8;
            break;
        case 2:
            footerHeight = CGFLOAT_MIN;
            break;
        default:
            footerHeight = CGFLOAT_MIN;
            break;
    }
    return footerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat footerHeight;
    switch (section) {
        case 0:
            footerHeight = 8;
            break;
        case 1:
            footerHeight = 8;
            break;
        case 2:
            footerHeight = CGFLOAT_MIN;
            break;
        default:
            footerHeight = CGFLOAT_MIN;
            break;
    }
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, footerHeight)];
    footer.backgroundColor = MXRCOLOR_F3F4F6;
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 分享截屏
- (void)share:(NSNotification*)notification{
    
    NSURL *userIconUrl = [NSURL URLWithString:[UserInformation modelInformation].userImage];
    if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:userIconUrl]) {
        DLOG(@"has icon")
        [self shareAfterUserIconLoadComplete:notification];
    }else{
        
        DLOG(@"no icon")
        [[GlobalBusyFlag sharedInstance] showBusyFlagOnView:self.view];
        @MXRWeakObj(self);
        [[SDWebImageManager sharedManager] downloadImageWithURL:userIconUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [[GlobalBusyFlag sharedInstance] hideBusyFlag];
            [selfWeak shareAfterUserIconLoadComplete:notification];
        }];
    }
    
    
}

- (void)shareAfterUserIconLoadComplete:(NSNotification*)notification{
    /*
     
     accuracy = 33;
     bookGuid = 9C3B4FE511E94239999C037CE7CC0196;
     qaId = 7;
     bookName
     */
    NSDictionary *userInfo = notification.userInfo;
    NSString *qaName = [userInfo valueForKey:@"qaName"];
    NSString *bookGuid = [userInfo valueForKey:@"bookGuid"];
    NSString *accuracy = [[userInfo valueForKey:@"accuracy"] stringValue];
    NSString *qaId = [[userInfo valueForKey:@"qaId"] stringValue];
    
//    MXRMissionCompleteShareViewParam *param = [[MXRMissionCompleteShareViewParam alloc] init];
//    param.qaName = qaName;
//    param.qaId = qaId;
//    param.accuracy = accuracy;
//    MXRMissionCompleteShareView *share = [MXRMissionCompleteShareView missionCompleteShareView];
//    share.param = param;
//
//
//    UIImage *originalShotImg = [share createShareImageWithoutQRCode];
//    UIImage *composeShotImg = [share createShareImage];
//
//    NSString *shareText = [NSString stringWithFormat:MXRLocalizedString(@"MXRMissionCompleteShare_Text_Accuracy_Above60", @"哈哈，我的答题正确率在%@%%哦，你能更厉害吗？") , accuracy];
//
//    if ([accuracy integerValue]<60) {
//        shareText = MXRLocalizedString(@"MXRMissionCompleteShare_Text_Accuracy_Under60", @"我正在参加脑力大挑战，快来和我PK吧！");
//    }
//
//    if (composeShotImg != nil) {
//        MXRNewShareView *shareView = [[MXRNewShareView alloc] initWithShareImg:composeShotImg MXQShareContent:shareText  bookGUID:bookGuid QAID:qaId originalImg:originalShotImg];
//        shareView.delegate = self;
//        [shareView showInView:nil];
//    } else {
//        [MXRConstant showAlert:MXRLocalizedString(@"MXRMissionCompleteShare_Error", @"分享失败") andShowTime:1.0];
//    }
    
}


#pragma mark - MXRNewShareViewDelegate
-(void)PresentToVc:(UIViewController*)vc animation:(BOOL)animation
{
    mxr_dispatch_main_sync_safe(^(){
        [self presentViewController:vc animated:animation completion:nil];
    });
}

-(void)pushToVc:(UIViewController*)vc animation:(BOOL)animation
{
    CATransition *anim = [CATransition animation];
    [anim setDuration:0.3f];
    [anim setType:kCATransitionPush];
    [anim setSubtype:kCATransitionFromRight];
    [[[[UIApplication sharedApplication] keyWindow] layer] addAnimation:anim forKey:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:nil];
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
