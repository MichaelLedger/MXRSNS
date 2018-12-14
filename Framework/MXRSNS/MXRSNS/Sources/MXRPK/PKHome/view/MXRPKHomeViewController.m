//
//  MXRPKHomeViewController.m
//  huashida_home
//
//  Created by 周建顺 on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKHomeViewController.h"

#import "WaterfallColectionLayout.h"
#import "SDWebImageManager.h"

#import "MXRPKConstants.h"
#import "MXRPKSearchViewController.h"

#import "MXRPKNetworkManager.h"

#import "MXRPKHomeNormalCollectionViewCell.h"
#import "MXRPKHomeDoubleCollectionViewCell.h"
//#import "MXRPKHomeHeaderView.h"

#import "MXRPKHomeCellViewModel.h"
#import "MXRPKHomeCellDoubleViewModel.h"
#import "MXRPKHomeHeaderViewModel.h"
#import "MXRPKAnswerVC.h"
#import "MXRPKNormalAnswerVC.h"
//#import "AppDelegate.h"
#import "UserInformation.h"
#import "GlobalBusyFlag.h"
#import "MXRPKHomeShareView.h"
//#import "MXRNewShareView.h"
#import "MXRPKAnswerVC.h"

#import "MXRPKQuestionListViewController.h"
#import "MXRNavigationViewController.h"

#import "MXRPKHomeNewHeaderView.h"
#import "MXREgretGameViewController.h"
#import "MXRPKRankListViewController.h"
#import "MXRPKPropShopViewController.h"

#import "MXRPKChallengeShareView.h"
#import "MXRDeviceUtil.h"

//#import "MXRVIPMainViewController.h"
#import "UserDefaultKey.h"
#import "MXRAlertViewController.h"
#import "MXRUserBehaviour.h"

#define MXR_PK_HOME_COLLECTIONVIEW_HEADER_SIZE CGSizeMake(200, 178)
#define MXR_PK_HOME_COLLECTIONVIEW_EDGEINSETS  UIEdgeInsetsMake(10, 25, 18, 25)
#define MXR_PK_HOME_COLLECTIONVIEW_LINE_SPACE 15.f
#define MXR_PK_HOME_COLLECTIONVIEW_INTER_SPACE 19.f

#define MXR_PK_HOME_COLLECTIONVIEW_CELL_WIDTH ((SCREEN_WIDTH_DEVICE_ABSOLUTE - MXR_PK_HOME_COLLECTIONVIEW_EDGEINSETS.left - MXR_PK_HOME_COLLECTIONVIEW_EDGEINSETS.right - MXR_PK_HOME_COLLECTIONVIEW_INTER_SPACE)/2.f)
#define MXR_PK_HOME_COLLECTIONVIEW_CELL_NORMAL_HEIGHT (MXR_PK_HOME_COLLECTIONVIEW_CELL_WIDTH/(152.f/139.f))
#define MXR_PK_HOME_COLLECTIONVIEW_CELL_DOUBLE_HEIGHT (MXR_PK_HOME_COLLECTIONVIEW_CELL_NORMAL_HEIGHT*2 + MXR_PK_HOME_COLLECTIONVIEW_LINE_SPACE)

#define MXR_PK_HOME_HEADER_SIZE CGSizeMake(SCREEN_WIDTH_DEVICE, SCREEN_WIDTH_DEVICE - 2 * 30 + 700)

#define MXR_PK_HOME_HEADER_IDENTIFIER @"pkHomeNewHeader"
#define MXR_PK_HOME_CELL_NORAML_IDENTIFIER @"pkHomeCellNormal"
#define MXR_PK_HOME_CELL_DOUBLE_IDENTIFIER @"pkHomeCellDouble"


@interface MXRPKHomeViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MXRPKSearchViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) MXRPKHomeHeaderViewModel *headerViewModel;

@end

@implementation MXRPKHomeViewController

+(instancetype)pkHomeViewController{
     UIStoryboard *sb = [UIStoryboard storyboardWithName:PK_STORYBOARD_NAME bundle:[NSBundle bundleForClass:[self class]]];
    MXRPKHomeViewController *vc = [sb instantiateViewControllerWithIdentifier:PK_VC_ID_MXRPKHomeViewController];
    return vc;
}

-(void)dealloc{
    DLOG_METHOD
    [self removeObservers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObservers];
    [self setup];
    self.collectionView.contentInset = UIEdgeInsetsMake(18, 0, 0, 0);
    
    [self loadCache];
    [self showVIPPrivilegeAlert];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gainProp) name:Notification_Share_Success object:nil];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_Share_Success object:nil];
}

#pragma mark - 分享获取道具
-  (void)gainProp {
    @MXRWeakObj(self);
    [MXRPKNetworkManager challengeShareWithType:1 Success:^(MXRNetworkResponse *response) {
        if (response.isSuccess && response.body) {
            NSDictionary *dict = response.body;
            NSInteger reliveCardNum = [[dict objectForKey:@"reliveCardNum"] integerValue];
            NSInteger removeWrongCardNum = [[dict objectForKey:@"removeWrongCardNum"] integerValue];
            if (reliveCardNum > 0 || removeWrongCardNum > 0) {
                [selfWeak loadPKChallengeData];//及时刷新数据
                NSString *hintText = [NSString stringWithFormat:@"%@!", MXRLocalizedString(@"MXBManager_Share_Success", @"分享成功")];
                if (reliveCardNum > 0) {
                    hintText = [hintText stringByAppendingString:[NSString stringWithFormat:@"%@+%ld", MXRLocalizedString(@"MXR_CHALLENGE_RESURGENCECARD", @"复活卡"), reliveCardNum]];
                }
                if (removeWrongCardNum > 0) {
                    hintText = [hintText stringByAppendingString:[NSString stringWithFormat:@"%@+%ld", MXRLocalizedString(@"MXR_CHALLENGE_EXCLUDEERRORCARD", @"除错卡"), removeWrongCardNum]];
                }
                
                [MXRConstant showAlert:hintText andShowTime:1.f];
            }
        }
    } failure:^(id error) {
        DLOG_METHOD
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
-(void)setup{
    [self.collectionView registerNib:[UINib nibWithNibName:@"MXRPKHomeNewHeaderView" bundle:[NSBundle bundleForClass:[self class]]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MXR_PK_HOME_HEADER_IDENTIFIER];
    
    self.title = MXRLocalizedString(@"MXR_PK_QUESTIONS", @"问答");
    
    self.headerViewModel.medalsCount = 3;
    self.headerViewModel.userIcon = [UserInformation modelInformation].userImage;
    self.headerViewModel.nickName = [UserInformation modelInformation].userNickName;
    self.headerViewModel.records = [NSString stringWithFormat:MXRLocalizedString(@"MXRPKHomeViewController_PK_Records", @"0胜 0负 0平"), @(0),@(0),@(0)];
}

#pragma mark - VIP特权弹窗(用户首次进入问答页面，弹窗提示VIP特权。该弹窗只显示一次，确定后再不显示。)
- (void)showVIPPrivilegeAlert {
    BOOL shown = [MXRUserBehaviour currentUserBehaviour].shownVIPPrivilegeAlert;
    if (!shown) {
        MXRAlertViewController *vc = [[MXRAlertViewController alloc] initWithAlertType:MXRAlertTypeOK title:MXRLocalizedString(@"MXR_PK_VIP_PRIVILEGE_TITLE", @"") alertContent:MXRLocalizedString(@"MXR_PK_VIP_PRIVILEGE_CONTENT", @"") okBtnTitle:MXRLocalizedString(@"SURE", @"确定") cancelBtnTitle:nil confirmBtnTitle:nil];
        vc.okBlock = ^{
            MXRUserBehaviour *behaviour = [MXRUserBehaviour currentUserBehaviour];
            behaviour.shownVIPPrivilegeAlert = YES;
            [behaviour updateToDB];
        };
        vc.hideCloseBtn = YES;
        [vc show];
    }
}

#pragma mark -

-(void)loadCache{
    NSMutableArray *cachedData = [NSKeyedUnarchiver unarchiveObjectWithFile:[[SandboxFile GetDirectoryForCaches:@"PK"] stringByAppendingPathComponent:@"PKHomeComponents.data"]];
    if (cachedData) {
        self.datas = cachedData;
        [self.collectionView reloadData];
    }
}

-(void)loadData{

    [[GlobalBusyFlag sharedInstance] showBusyFlagOnView:self.view];
    @MXRWeakObj(self)
    [MXRPKNetworkManager getPKHomeSuccess:^(id result) {
        
        [selfWeak refreshViewWith:result];
        [[GlobalBusyFlag sharedInstance] hideBusyFlag];
        
    } failure:^(MXRServerStatus status, id result) {
        [[GlobalBusyFlag sharedInstance] hideBusyFlag];
    }];
    
    [self loadRecord];
    [self loadPKChallengeData];
}

// 加载战绩
-(void)loadRecord{
    @MXRWeakObj(self)
    MXRPKHomeRankingInfoResponseModel *cachedModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[[SandboxFile GetDirectoryForCaches:@"PK"] stringByAppendingPathComponent:@"PKHomeRankingInfo.data"]];
    if (cachedModel) {
        [self.headerViewModel updateDataWithModel:cachedModel];
    }
    
    //获取PK勋章列表信息 V5.16.0 add by MT.X
    [MXRPKNetworkManager requestUserPKMedalListSuccess:^(MXRPKMedalInfoModel *pkMedalListInfo) {
        selfWeak.headerViewModel.medalInfoModel = pkMedalListInfo;
        selfWeak.headerViewModel.medalsCount = pkMedalListInfo.medalVos.count;
    } failure:^(MXRServerStatus status, id result) {
    }];
    
    [MXRPKNetworkManager getPKHomeRankingInfoSuccess:^(id result) {
        if ([result isKindOfClass:[MXRPKHomeRankingInfoResponseModel class]]) {
            [NSKeyedArchiver archiveRootObject:result toFile:[[SandboxFile GetDirectoryForCaches:@"PK"] stringByAppendingPathComponent:@"PKHomeRankingInfo.data"]];
            [selfWeak.headerViewModel updateDataWithModel:result] ;
        }
        
        
    } failure:^(MXRServerStatus status, id result) {
        
    }];
}

- (void)loadPKChallengeData {
    @MXRWeakObj(self)
    [MXRPKNetworkManager requestPKChallengeInfoSuccess:^(MXRPKChallengeResponseModel *pkChallengeInfo) {
        selfWeak.headerViewModel.challengeInfoModel = pkChallengeInfo;
        selfWeak.headerViewModel.challengeInfoModel.vipFlag = [UserInformation modelInformation].vipFlag;//V5.18.0 新增VIP充值按钮
        [selfWeak setupShareBtn];
    } failure:^(MXRServerStatus status, id result) {
        
    }];
}

- (void)setupShareBtn {
    UIBarButtonItem *rightShareButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"btn_bookdetail_navi_share"] style:UIBarButtonSystemItemDone target:self action:@selector(shareBtnClicked:)];
    self.navigationItem.rightBarButtonItems = @[rightShareButtonItem];
}

-(void)refreshViewWith:(NSArray*)datas{
    NSMutableArray *array = [NSMutableArray new];
    MXRPKHomeCellDoubleViewModel *doubleVM = [MXRPKHomeCellDoubleViewModel new];
     doubleVM.localImageName = @"icon_pk_home_random_pk";
    [array addObject:doubleVM];

    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MXRPKHomeCellViewModel *mv = [[MXRPKHomeCellViewModel alloc] initWithModel:obj];
        [array addObject:mv];
        
    }];
    
    self.datas = array;
    
    [NSKeyedArchiver archiveRootObject:array toFile:[[SandboxFile GetDirectoryForCaches:@"PK"] stringByAppendingPathComponent:@"PKHomeComponents.data"]];
    
    [self.collectionView reloadData];
}

-(void)loadTestData{
    NSMutableArray *array = [NSMutableArray new];
    
    MXRPKHomeCellDoubleViewModel *doubleVM = [MXRPKHomeCellDoubleViewModel new];
    [array addObject:doubleVM];
    
    for (int i = 0; i < 30; i++) {
        MXRPKHomeCellViewModel *mv = [MXRPKHomeCellViewModel new];
        [array addObject:mv];
    }
    MXRPKHomeCellDoubleViewModel *doubleVM2 = [MXRPKHomeCellDoubleViewModel new];
    doubleVM2.localImageName = @"icon_pk_home_random_pk";
    [array addObject:doubleVM2];
    
    for (int i = 0; i < 2; i++) {
        MXRPKHomeCellViewModel *mv = [MXRPKHomeCellViewModel new];
        [array addObject:mv];
    }
    self.datas = array;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    
    if ([segue.identifier isEqualToString:PK_SEGUE_SHOW_PK_SEARCH]) {
        MXRPKSearchViewController * pkSearch = segue.destinationViewController;
        pkSearch.delegate = self;
    }
}

#pragma mark - observers

-(void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryPKAgain:) name:Notification_RNNoti_PKAgain object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRecord) name:Notification_PK_Submit_Answer object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo) name:Notification_ReloadPersonInfo object:nil];
}

-(void)removeObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)tryPKAgain:(NSNotification*)notification{
    @MXRWeakObj(self)
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        [selfWeak performSegueWithIdentifier:PK_SEGUE_SHOW_PK_SEARCH sender:selfWeak];
    }];
}

#pragma mark - getters setters
-(MXRPKHomeHeaderViewModel *)headerViewModel{
    if (!_headerViewModel) {
        _headerViewModel = [MXRPKHomeHeaderViewModel new];
    }
    return _headerViewModel;
    
}


#pragma mark - UICollectionView datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;//V5.16.0 UI调整
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return MXR_PK_HOME_COLLECTIONVIEW_LINE_SPACE;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return MXR_PK_HOME_COLLECTIONVIEW_INTER_SPACE;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return MXR_PK_HOME_COLLECTIONVIEW_EDGEINSETS;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    id vm = [self.datas objectAtIndex:indexPath.item];
    
    if ([vm isKindOfClass:[MXRPKHomeCellViewModel class]]) {
         return CGSizeMake(MXR_PK_HOME_COLLECTIONVIEW_CELL_WIDTH, MXR_PK_HOME_COLLECTIONVIEW_CELL_NORMAL_HEIGHT);
    }else if([vm isKindOfClass:[MXRPKHomeCellDoubleViewModel class]]){
        
        return CGSizeMake(MXR_PK_HOME_COLLECTIONVIEW_CELL_WIDTH, MXR_PK_HOME_COLLECTIONVIEW_CELL_DOUBLE_HEIGHT);
    }
    
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return MXR_PK_HOME_HEADER_SIZE;
    //return MXR_PK_HOME_COLLECTIONVIEW_HEADER_SIZE;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     id vm = [self.datas objectAtIndex:indexPath.item];
    
    if ([vm isKindOfClass:[MXRPKHomeCellViewModel class]]) {
        MXRPKHomeNormalCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:MXR_PK_HOME_CELL_NORAML_IDENTIFIER forIndexPath:indexPath];
        cell.viewModel = vm;
        return cell;
    }else if([vm isKindOfClass:[MXRPKHomeCellDoubleViewModel class]]){
        MXRPKHomeDoubleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MXR_PK_HOME_CELL_DOUBLE_IDENTIFIER forIndexPath:indexPath];
        cell.viewModel = (MXRPKHomeCellDoubleViewModel*)vm;
        return cell;
    }
    
    
    return nil;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    @MXRWeakObj(self);
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MXRPKHomeNewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MXR_PK_HOME_HEADER_IDENTIFIER forIndexPath:indexPath];
        view.headerViewModel = self.headerViewModel;
        view.goMedalsBlock = ^(MXRPKHomeNewHeaderView *sender) {
            [selfWeak performSegueWithIdentifier:PK_SEGUE_SHOW_PK_MEDAL sender:selfWeak];
        };
        view.beginPKBlock = ^{
            [MXRClickUtil event:@"Test_pk_btn"];
            [selfWeak performSegueWithIdentifier:PK_SEGUE_SHOW_PK_SEARCH sender:selfWeak];
        };
        view.beginChallengeBlock = ^{
            if (selfWeak.headerViewModel.challengeInfoModel.totalNum - selfWeak.headerViewModel.challengeInfoModel.usedNum <= 0) {
                [MXRConstant showAlert:MXRLocalizedString(@"MXR_PK_NO_CHANCE", @"挑战机会用完，明天再来吧～") andShowTime:1.f];
            } else if (![MXRDeviceUtil isReachable]) {//断网状态下禁止进入个人挑战赛，避免无法返回
                [MXRConstant showAlertBadNetwork];
            } else {
                MXREgretGameViewController *egretVc = [[MXREgretGameViewController alloc] init];
                MXREgretInterfaceModel *model = [[MXREgretInterfaceModel alloc] init];
                model.rebootNums =  selfWeak.headerViewModel.challengeInfoModel.reliveCardNum;
                model.skillNums = selfWeak.headerViewModel.challengeInfoModel.removeWrongCardNum;
                model.lives = selfWeak.headerViewModel.challengeInfoModel.totalNum - selfWeak.headerViewModel.challengeInfoModel.usedNum < 0 ? 0 : (selfWeak.headerViewModel.challengeInfoModel.totalNum - selfWeak.headerViewModel.challengeInfoModel.usedNum);
                model.mxzNums = [UserInformation modelInformation].userDiamonad;
                model.maxRights = selfWeak.headerViewModel.challengeInfoModel.bestRecord < 0 ? 0 : selfWeak.headerViewModel.challengeInfoModel.bestRecord;
                egretVc.model = model;
                [selfWeak.navigationController pushViewController:egretVc animated:YES];
            }
        };
        view.jumpToRankBlock = ^{
            MXRPKRankListViewController *rankVc = [[MXRPKRankListViewController alloc] init];
            [selfWeak.navigationController pushViewController:rankVc animated:YES];
        };
        view.jumpToPropBlock = ^{
            MXRPKPropShopViewController *propVc = [[MXRPKPropShopViewController alloc] initWithNibName:@"MXRPKPropShopViewController" bundle:[NSBundle bundleForClass:[self class]]];
            propVc.headerViewModel = selfWeak.headerViewModel;
            [selfWeak.navigationController pushViewController:propVc animated:YES];
        };
        view.jumpToVIPBlock = ^{
//            MXRVIPMainViewController *vc = [[MXRVIPMainViewController alloc] init];
//            [selfWeak.navigationController pushViewController:vc animated:YES];
        };
        return view;
    }

    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    id vm = [self.datas objectAtIndex:indexPath.item];
    
    if ([vm isKindOfClass:[MXRPKHomeCellViewModel class]]) {
        MXRPKHomeCellViewModel *model = (MXRPKHomeCellViewModel *)vm;
        MXRPKQuestionListViewController *vc = [[MXRPKQuestionListViewController alloc] init];
        vc.categoryId = [model.classifyId integerValue];
//        [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        
    }else if([vm isKindOfClass:[MXRPKHomeCellDoubleViewModel class]]){
        [MXRClickUtil event:@"Test_pk_btn"];
        [self performSegueWithIdentifier:PK_SEGUE_SHOW_PK_SEARCH sender:self];
      
    }

}
#pragma mark - MXRPKSearchViewControllerDelegate
-(void)dismissMXRPKSearchViewControllerWithMXRPKUserInfoModel:(MXRPKUserInfoModel *)pkUserInfoModel {
    @MXRWeakObj(self);
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC;
    if (appRootVC.presentedViewController) {
        topVC = appRootVC.presentedViewController;
        if ([[topVC.childViewControllers lastObject] presentedViewController]) {
            topVC = [[topVC.childViewControllers lastObject] presentedViewController];
        }
        [(MXRNavigationViewController *)topVC dismissViewControllerAnimated:NO completion:^{
            [selfWeak goToPKQuestionWithMXRPKUserInfoModel:pkUserInfoModel];
        }];
    }
}

-(void)goToPKQuestionWithMXRPKUserInfoModel:(MXRPKUserInfoModel *)pkUserInfoModel{
    CATransition *animation = [CATransition animation];
    animation.duration =1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type =@"rippleEffect";
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    MXRPKAnswerVC *pkAnswerVC = [[MXRPKAnswerVC alloc] initWithNibName:@"MXRPKAnswerVC" bundle:[NSBundle bundleForClass:[self class]]];
    pkAnswerVC.pkUserInfoModel = pkUserInfoModel;
    
    MXRNavigationViewController *navi = [[MXRNavigationViewController alloc] initWithRootViewController:pkAnswerVC];
    [self.navigationController presentViewController:navi animated:NO completion:^{
//        UIImageView *imageView = (UIImageView *)[APP_DELEGATE.window viewWithTag:PK_TRANSITION_ANIMATION_TAG];
//        [imageView removeFromSuperview];
    }];
}

#pragma mark - actions
#pragma mark - 新版分享雷达图
- (void)shareBtnClicked:(UIBarButtonItem *)sender {
    NSString *userImageUrl = [UserInformation modelInformation].userImage;
    NSURL *userIconUrl = [NSURL URLWithString: userImageUrl];
    if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:userIconUrl]) {
        [self beginShare];
    }else{
        [[GlobalBusyFlag sharedInstance] showBusyFlagOnView:self.view];
        @MXRWeakObj(self);
        [[SDWebImageManager sharedManager] downloadImageWithURL:userIconUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [[GlobalBusyFlag sharedInstance] hideBusyFlag];
            [selfWeak beginShare];
        }];
    }
}

- (void)beginShare {
    MXRPKChallengeShareView *share = [MXRPKChallengeShareView shareView];
    share.headerViewModel = self.headerViewModel;
    [self.view addSubview:share];
    [self.view insertSubview:share atIndex:0];
    UIImage *shareImage = [UIImage getImageFromView:share];
//    UIImageWriteToSavedPhotosAlbum(shareImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    [share removeFromSuperview];
    
//    MXRNewShareView *shareView = [[MXRNewShareView alloc] initWithShareImg:shareImage MXQShareContent:@""  bookGUID:nil QAID:nil originalImg:shareImage];
//    shareView.delegate = self;
//    [shareView showInView:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    DLOG(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

#pragma mark  分享截屏
- (void)shareClicked{
    
    NSString *userImageUrl = self.headerViewModel.userIcon;
    
    NSURL *userIconUrl = [NSURL URLWithString: userImageUrl];
    if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:userIconUrl]) {
        DLOG(@"has icon")
        [self shareAfterUserIconLoadCompleteWithUserIconUrl:userIconUrl];
    }else{
        
        DLOG(@"no icon")
        [[GlobalBusyFlag sharedInstance] showBusyFlagOnView:self.view];
        @MXRWeakObj(self);
        [[SDWebImageManager sharedManager] downloadImageWithURL:userIconUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [[GlobalBusyFlag sharedInstance] hideBusyFlag];
            [selfWeak shareAfterUserIconLoadCompleteWithUserIconUrl:userIconUrl];
        }];
    }
}

-(void)shareAfterUserIconLoadCompleteWithUserIconUrl:(NSURL*)userIconUrl{
   
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:userIconUrl];
    UIImage *userIconImage = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:key];
    
    MXRPKHomeShareViewParam *param = [MXRPKHomeShareViewParam new];
    param.userIcon = userIconImage;
    param.userName = self.headerViewModel.nickName;
    param.medalCount = self.headerViewModel.medalsCount;
    
    MXRPKHomeShareView *shareview = [MXRPKHomeShareView pkHomeShareView];
    shareview.model = param;
    
    UIImage *imageWithQR = [shareview createShareImageWithQR];
    if (imageWithQR != nil) {
    } else {
        [MXRConstant showAlert:MXRLocalizedString(@"MXRMissionCompleteShare_Error", @"分享失败") andShowTime:1.0];
    }
    
}

#pragma mark - MXRNewShareViewDelegate
-(void)PresentToVc:(UIViewController*)vc animation:(BOOL)animation
{
    [self presentViewController:vc animated:animation completion:nil];
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

@end
