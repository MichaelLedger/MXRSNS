//
//  MXRBookSNSViewController.m
//  huashida_home
//
//  Created by gxd on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSViewController.h"
#import "MXRBookSNSModelProxy.h"
#import "MXRSNSShareModel.h"
#import "MXRBookSNSHeadVIew.h"
#import "MXRBookSNSDeleteForwardTableViewCell.h"
#import "MXRBookSNSTableViewCell.h"
#import "MXRBookSNSForwardTableViewCell.h"
#import "MXRBookSNSDetailViewController.h"
#import "MXRSNSSendStateViewController.h"
#import "MXRNavigationViewController.h"
#import "MXRBookSNSMomentStatusNoUploadManager.h"
#import "MXRBookSNSController.h"
#import "MXRBookSNSLoadDataGifRefreshHeader.h"
#import "MXRBookSNSLoadDataGifRefreshFooter.h"
#import "GlobalBusyFlag.h"
//#import "MXRBookStoreNetworkManager.h"
//#import "MXRBookManager.h"
//#import "MXRLoginVC.h"
//#import "MXRPromptView.h"
#import "AppDelegate.h"
#import "MXRSNSSendMsgGuideView.h"
#import "GlobalFunction.h"
//#import "DDYBookDetailViewController.h"
#import <AFNetworking.h>
//#import "UITableView+FDTemplateLayoutCell.h"
#import "MXRQuestionBanner.h"
#import "MXRDeviceUtil.h"
#import <objc/runtime.h>

#import "MXRPKSearchViewController.h"
#import "MXRPKHomeViewController.h"
//#import "MXRPhoneBandelDetailViewController.h"
static const float itemWidth = 132;
static const float itemHeight = 65;

#define mxrBookSNSTableViewCell @"MXRBookSNSTableViewCell"
#define mxrBookSNSForwardTableViewCell @"MXRBookSNSForwardTableViewCell"
#define mxrBookSNSDeleteForwardTableViewCell @"MXRBookSNSDeleteForwardTableViewCell"
@interface MXRBookSNSViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UITabBarControllerDelegate,
MXRQuestionBannerDelegate,
UIViewControllerPreviewingDelegate,
MXRBookSNSTableViewCellDelegate,
MXRBookSNSForwardTableViewCellDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *bookSNSTableView;
@property (weak, nonatomic) IBOutlet UILabel *tipsUserLoginLabel;
@property (weak, nonatomic) IBOutlet UIButton *userLoginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tableViewWidth;
@property (strong, nonatomic) UIBarButtonItem * creatMomentBtn;
@property (strong, nonatomic) UILabel * tipsUpdateMomentCountLabel;
@property (strong, nonatomic) MXRBookSNSHeadVIew * headView;// 话题视图
@property (nonatomic, assign) BOOL isNotFirstRequestBookSNSData;
@property (nonatomic, assign) NSInteger noSNSDataReloadCount; // 默认没有数据时，默认条的count
@property (nonatomic, assign) BOOL isViewDidAppear;
@property (nonatomic, weak) MXRSNSSendMsgGuideView *guideView;
@property (nonatomic, strong) NSIndexPath * selectIndexPath;
@property (nonatomic, strong)MXRQuestionBanner *questionBanner;//问答Banner
@property (nonatomic, strong)UIView *tableHeaderView;//头部视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tableViewBottom;

@end

@implementation MXRBookSNSViewController
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

-(BOOL)shouldAutorotate{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleLabelText: MXRLocalizedString(@"MXRBookSNSViewControllerTabBarItemTitle", @"梦想圈")];
    self.constraint_tableViewWidth.constant = SCREEN_WIDTH_DEVICE;
    [self setup];
    [self firstUpdateSNSData];

    [self addObserver];
    
    [self getBookSNSBannerInfo];
    
    if (_hideTabbar) _constraint_tableViewBottom.constant = 0;
}

-(void)viewWillAppear:(BOOL)animated{
 
    [super viewWillAppear:animated];
    [MXRClickUtil beginEvent:@"MengXiangQuanPage"];
    //全部话题 到搜索话题 需要将bar hidden  然后 如果那个时候 手指 滑动到 首页的话 那么这个时候 导航栏 就不会show出来 所以在该出加上了 下面这行代码
    [self.navigationController.navigationBar setHidden:NO];
    [self showTabbar];
    [self resetTabbar];
    
    [self reloadDataWithSelectIndex];
//    [self.bookSNSTableView reloadData];
    
    self.creatMomentBtn.enabled = YES;
    self.isViewDidAppear = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    });
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[MXRBookSNSMomentStatusNoUploadManager getInstance] checkNeedUploadUserHandle];
    });
    [self reloadHotTopic:nil];
    
    //禁用侧滑，会导致cell点击卡死
//    [self removeInteractivePopGestureRecognizer];
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [MXRClickUtil endEvent:@"MengXiangQuanPage"];
    self.isViewDidAppear = NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)resetTabbar{
#ifdef MXRSNAPLEARN
    [self.tabBarController.tabBar layoutSubviews];
#endif
}
#pragma mark - Actions
-(void)creatStatusBtnClick:(UIButton *)sender{
    [MXRClickUtil event:@"DreamCircle_Add_Click"];
    [MXRClickUtil event:@"MengXiangQuanClick"];
    if (![[UserInformation modelInformation] checkIsLogin]) {
        return;
    }
    
    if (![[UserInformation modelInformation] judgeWhetherShowedBandlePrompt]) {
        return;
    }
    
    MXRSNSSendStateViewController *sdVC=[[MXRSNSSendStateViewController alloc]init];
    MXRNavigationViewController*nav=[[MXRNavigationViewController alloc]initWithRootViewController:sdVC];
    [self presentViewController:nav animated:YES completion:^{
    
    }];
    
}

#pragma mark - Noti Actions
-(void)saveBookSNSData:(NSNotification *)sender{
    
    [[MXRBookSNSModelProxy getInstance] creatCacheData];
}
-(void)enableTableScrollTop:(NSNotification *)sender{

//    self.bookSNSTableView.scrollsToTop = YES;
}
-(void)noEnableTableScrollTop:(NSNotification *)sender{
    
//    self.bookSNSTableView.scrollsToTop = NO;
}
-(void)reloadALLBookSNSData:(NSNotification *)sender{
    [self hideNetworkErrorView];
    if (self.isNotFirstRequestBookSNSData) {
        [[GlobalBusyFlag sharedInstance] showBusyFlagOnView:self.view];
    }
    @MXRWeakObj(self);
    [[MXRBookSNSController getInstance] getBookSNSAllMomentWithHandleUserId:[UserInformation modelInformation].userID Success:^(id result) {
        if (selfWeak.isNotFirstRequestBookSNSData) {
            [[GlobalBusyFlag sharedInstance] hideBusyFlag];
        }
        [selfWeak.bookSNSTableView reloadData];
    } failure:^(MXRServerStatus status, id result) {
        if (status == MXRServerStatusNetworkError || status == MXRServerStatusFail) {
           
            if (selfWeak.isNotFirstRequestBookSNSData) {
                [[GlobalBusyFlag sharedInstance] hideBusyFlag];
            }
            if ([MXRBookSNSModelProxy getInstance].bookSNSMomentsArray.count > 0) {
                return ;
            }
#ifdef MXRSNAPLEARN
#else
            [selfWeak showNetworkErrorWithRefreshCallback:^{
                selfWeak.isNotFirstRequestBookSNSData = YES;
                selfWeak.noSNSDataReloadCount = 0;
                [selfWeak.bookSNSTableView reloadData];

                if ([MXRDeviceUtil isReachable])
                {

                    [selfWeak reloadALLBookSNSData:nil];
                    [selfWeak reloadHotTopic:nil];
                }
            }];
#endif
        }
    }];
}
-(void)reloadHotTopic:(NSNotification *)sender{
    @MXRWeakObj(self);
    [[MXRBookSNSController getInstance] getHotTopicListWithSuccess:^(id result) {
        [selfWeak reloadTableHeaderView];
    } failure:^(MXRServerStatus status, id result) {
        [selfWeak reloadTableHeaderView];
    }];
}

#pragma mark - 配置&刷新头部视图
-(void)getBookSNSBannerInfo {
    @MXRWeakObj(self);
    [[MXRBookSNSController getInstance] getBookSNSBannerIconUrlStringSuccess:^(id result) {
        [selfWeak reloadTableHeaderView];
    } failure:^(MXRServerStatus status, id result) {
        [selfWeak reloadTableHeaderView];
    }];
}

- (void)reloadTableHeaderView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_tableHeaderView) {
            _tableHeaderView = [[UIView alloc] init];
            [_tableHeaderView addSubview:self.questionBanner];
        }
        
        [self.headView reloaData];
        [self.questionBanner reloadData];
        
        if ([MXRBookSNSModelProxy getInstance].bookSNSHeadtopicModelDataArray.count > 0) {
            if (!self.headView.superview) {
                [_tableHeaderView addSubview:self.headView];
            }
            _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, self.questionBanner.bounds.size.height + self.headView.bounds.size.height);
        } else {
            [self.headView removeFromSuperview];
            _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, self.questionBanner.bounds.size.height);
        }
        
        self.bookSNSTableView.tableHeaderView = _tableHeaderView;
    });
}

-(void)loadMoreNewSNSDataNotips{

   [self loadMoreNewSNSDataAndIsShowTips:NO];
}
-(void)loadMoreNewSNSDataHaveTips{

    [self loadMoreNewSNSDataAndIsShowTips:YES];
}
-(void)loadMoreNewSNSDataAndIsShowTips:(BOOL )isShowTips{

    if ([MXRBookSNSModelProxy getInstance].bookSNSMomentsArray.count == 0){
        [self.bookSNSTableView.mj_header endRefreshing];
        return;
    }
    @MXRWeakObj(self);
    [self reloadHotTopic:nil];
    [[MXRBookSNSController getInstance] getBookSNSAllMomentWithHandleUserId:[UserInformation modelInformation].userID Success:^(id result) {
        [selfWeak.bookSNSTableView.mj_header endRefreshing];
        [selfWeak.bookSNSTableView reloadData];
        
        if (isShowTips) {
            [selfWeak showTipsUpdateNewMomentCount:[(NSNumber *)result integerValue]];
        }
    } failure:^(MXRServerStatus status, id result) {
        [selfWeak.bookSNSTableView.mj_header endRefreshing];
        [selfWeak.bookSNSTableView reloadData];
    }];
}
-(void)loadMoreOldSNSData{
    
    if ([MXRBookSNSModelProxy getInstance].bookSNSMomentsArray.count == 0){
        [self.bookSNSTableView.mj_footer endRefreshing];
        return;
    }
    @MXRWeakObj(self);
    [[MXRBookSNSController getInstance] getPreviousBookSNSMomentWithandHandleUserId:[UserInformation modelInformation].userID Success:^(id result) {
        if ([(NSNumber *)result isEqualToNumber:@0]) {
            [selfWeak.bookSNSTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [selfWeak.bookSNSTableView.mj_footer endRefreshing];
            [selfWeak.bookSNSTableView reloadData];
        }
    } failure:^(MXRServerStatus status, id result) {
        if (status == MXRServerStatusNetworkError ) {
            [selfWeak.bookSNSTableView.mj_footer endRefreshing];
        }else if (status == MXRServerStatusFail){
            [selfWeak.bookSNSTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
//-(void)gotoBookDetailBefore:(NSNotification *)sender{

//    self.view.userInteractionEnabled = NO;
//}
//-(void)gotoBookDetailAfter:(NSNotification *)sender{

//     self.view.userInteractionEnabled = YES;
//}
-(void)reloadBookSNSData:(NSNotification *)sender{

    if ([MXRBookSNSModelProxy getInstance].bookSNSMomentsArray.count == 0) {
        [self reloadALLBookSNSData:nil];
    }else{
        [self loadMoreNewSNSDataHaveTips];
    }
}
-(void)loginSussBack{
    [[MXRBookSNSModelProxy getInstance].bookSNSNetMomentsArray removeAllObjects];
    [[MXRBookSNSModelProxy getInstance].bookSNSRecommentMomentsArray removeAllObjects];
    [[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray removeAllObjects];
    mxr_dispatch_main_async_safe(^{
        [self.bookSNSTableView reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            self.bookSNSTableView.contentOffset = CGPointZero;
        } completion:^(BOOL finished) {
            [self reloadALLBookSNSData:nil];
        }];
    });
    
}
-(void)userHandleMoment:(NSNotification *)noti{

    NSNumber * handleTypeNUm = [noti.object objectForKey:@"UserHandleMomentType"];
    NSString * handleId = [noti.object objectForKey:@"UserHandleMomentID"];
    NSNumber * momentBelongViewTypeNum = [noti.object objectForKey:@"UserHandleMomentBelongViweType"];
    if ([momentBelongViewTypeNum integerValue] == MXRUserHandleMomentBelongViewtypeBookSNSView || [momentBelongViewTypeNum integerValue] == MXRUserHandleMomentBelongViewtypeTopicView) {
        if ([handleTypeNUm integerValue] == MXRUserHandleMomentViewTypeDelete) {
            [self deleteMomentWithMomentIdOrUserId:handleId andHandleType:MXRUserHandleMomentViewTypeDelete];
        }else if([handleTypeNUm integerValue] == MXRUserHandleMomentViewTypeNoInterest){
            [self deleteMomentWithMomentIdOrUserId:handleId andHandleType:MXRUserHandleMomentViewTypeNoInterest];
        }else if([handleTypeNUm integerValue] == MXRUserHandleMomentViewTypeReport){
            // 举报 在页面展示效果和删除效果一样 
        [self deleteMomentWithMomentIdOrUserId:handleId andHandleType:MXRUserHandleMomentViewTypeDelete];
        }
    }
    [self.bookSNSTableView reloadData];
}
#pragma mark - 网络变化
-(void)netDidChanged:(NSNotification*)noti
{
    NSInteger netStatus = [(NSNumber*)noti.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    switch (netStatus) {
        case AFNetworkReachabilityStatusUnknown:
            break;
        case AFNetworkReachabilityStatusNotReachable:
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
            [[MXRBookSNSMomentStatusNoUploadManager getInstance] checkNeedUploadUserHandle];
            break;
        default:
            break;
    }
}
-(void)showTabbar{
#ifdef MXRSNAPLEARN
    [self.tabBarController.tabBar setHidden:NO];
#endif
}
#pragma mark - Private
-(void)setup{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.delegate=self;
    [self setRightNavBtn];

    
    self.tipsUserLoginLabel.text = MXRLocalizedString(@"MXRBookSNSViewControllerTipsUserLogin", @"登录后即可查看所有动态");
    [self.userLoginButton setTitle:MXRLocalizedString(@"MXRBookSNSViewControllerUserLoginBtnTitle", @"立即登录") forState:UIControlStateNormal];
    [self.userLoginButton setTitle:MXRLocalizedString(@"MXRBookSNSViewControllerUserLoginBtnTitle", @"立即登录") forState:UIControlStateHighlighted];
    self.noSNSDataReloadCount = 20;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupbookSNSTableView];
    });
    
    [self createLoadMoreHeader];
    [self createLoadMoreFooter];
}

- (void)reloadDataWithSelectIndex{

    if (self.selectIndexPath && self.selectIndexPath.row >= 0) {
        NSArray * array = [NSArray arrayWithObject:self.selectIndexPath];
        [self.bookSNSTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
        self.selectIndexPath = nil;
    }
}

-(void)addObserver{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveBookSNSData:) name:Notification_ApplicationWillTerminate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableTableScrollTop:) name:Notification_MXRBookSNS_ScrollTopEnable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noEnableTableScrollTop:) name:Notification_MXRBookSNS_ScrollTopNoEnable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBookSNSData:) name:Notification_MXRBookSNS_ReloadData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadALLBookSNSData:) name:Notification_MXRBookSNS_UpdateALLMoment object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHotTopic:) name:Notification_MXRBookSNS_UpdateHotTopic object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netDidChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil]; //监听网络变化
    //当去网络获取数据后，来通知该界面刷新请求结果
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabbar) name:Notification_MXRBookSNS_ShowTabbar object:nil]; //监听网络变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSussBack) name:notificationForUserLoginSuss object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userHandleMoment:) name:Notification_MXRBookSNS_UserHandleMoment object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstUpdateSNSData) name:Notification_ClearMXQCacheNoti object:nil];//清空数据&刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataWhenLogout:) name:Notification_UserLogout object:nil];
}

- (void)reloadDataWhenLogout:(NSNotification *)noti
{
    [self reloadALLBookSNSData:nil];
}

-(void)firstUpdateSNSData{
    
    [self reloadALLBookSNSData:nil];
}

-(void)showFirstSendGuide{
    if ([MXRSNSSendMsgGuideView checkIsNeedShow]) {
        
//        if ([APP_DELEGATE.navigationController.childViewControllers lastObject] == self&&!self.guideView) {
//            // 当前在首页而且有数据
//            MXRSNSSendMsgGuideView *guide = [MXRSNSSendMsgGuideView sendMsgGuideView];
//
//            [guide tryShowBookStoreGuide];
//            self.guideView = guide;
//        }
        
       
    }
}

-(void)setRightNavBtn{

//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSpacer.width = -6;
//    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.creatMomentBtn];
    self.navigationItem.rightBarButtonItem = self.creatMomentBtn;
}
-(void)setupbookSNSTableView{

    self.bookSNSTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bookSNSTableView setSeparatorColor:[UIColor clearColor]];
    [self.bookSNSTableView registerNib:[UINib nibWithNibName:mxrBookSNSTableViewCell bundle:nil] forCellReuseIdentifier:mxrBookSNSTableViewCell];
    [self.bookSNSTableView registerNib:[UINib nibWithNibName:mxrBookSNSForwardTableViewCell  bundle:nil] forCellReuseIdentifier:mxrBookSNSForwardTableViewCell];
    [self.bookSNSTableView registerNib:[UINib nibWithNibName:mxrBookSNSDeleteForwardTableViewCell  bundle:nil] forCellReuseIdentifier:mxrBookSNSDeleteForwardTableViewCell];
    self.bookSNSTableView.delegate = self;
    self.bookSNSTableView.dataSource = self;
    self.bookSNSTableView.backgroundColor = BACKGROUND_COLOR_249;
   self.bookSNSTableView.estimatedRowHeight = 95.f;
//    self.bookSNSTableView.rowHeight = UITableViewAutomaticDimension;
    [self.bookSNSTableView reloadData];
}
-(void)createLoadMoreHeader
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MXRBookSNSLoadDataGifRefreshHeader *header = [MXRBookSNSLoadDataGifRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNewSNSDataHaveTips)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;

    // 设置header
    self.bookSNSTableView.mj_header = header;
}
-(void)createLoadMoreFooter
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MXRBookSNSLoadDataGifRefreshFooter * t_footer = [MXRBookSNSLoadDataGifRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOldSNSData)];
    // 隐藏状态
    t_footer.refreshingTitleHidden = YES;
    [t_footer setTitle:MXRLocalizedString(@"Letter_Nomore_Data", @"—— 没有更多了 ——") forState:MJRefreshStateNoMoreData];
    self.bookSNSTableView.mj_footer = t_footer;
}
-(void)showTipsUpdateNewMomentCount:(NSInteger )count{
    if (count <= 0) {
        return;
    }
    if (!self.tipsUpdateMomentCountLabel.superview) {
        [self.view addSubview:self.tipsUpdateMomentCountLabel];
        [self.view bringSubviewToFront:self.tipsUpdateMomentCountLabel];
    }
    self.tipsUpdateMomentCountLabel.text = [NSString stringWithFormat:@"%@%ld%@",MXRLocalizedString(@"MXRBookSNSViewControllerTipsUpdate", @"更新了"),(long)count,MXRLocalizedString(@"MXRBookSNSViewControllerTipsUpdatedetail", @"条动态")];
    [UIView animateWithDuration:0.5f animations:^{
        self.tipsUpdateMomentCountLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 30);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.tipsUpdateMomentCountLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 0);
            } completion:^(BOOL finished) {
                [self.tipsUpdateMomentCountLabel removeFromSuperview];
            }];
        });
    }];
}


-(void)deleteMomentWithMomentIdOrUserId:(NSString *)momentIdOrUserId andHandleType:(MXRUserHandleMomentViewType) handleType{
    
    if (!momentIdOrUserId || [MXRBookSNSModelProxy getInstance].bookSNSMomentsArray.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_UpdateALLMoment object:nil];
        return;
    }
    __block NSMutableArray <NSIndexPath *> * deleteMomentIndexPathArray = [NSMutableArray array];
    NSMutableArray * momentIndexArray = [NSMutableArray array];
    if (handleType == MXRUserHandleMomentViewTypeDelete) {
        NSInteger index = [[MXRBookSNSModelProxy getInstance] getMomentOnArrayIndex:momentIdOrUserId];
        if (index >= [MXRBookSNSModelProxy getInstance].bookSNSMomentsArray.count) {
            return;
        }
        [momentIndexArray addObject:[NSString stringWithFormat:@"%lu",(long)index]];
        [[MXRBookSNSModelProxy getInstance] deleteMomentWithId:momentIdOrUserId];
    }else if (handleType == MXRUserHandleMomentViewTypeNoInterest){
        NSArray * momentArr = [[MXRBookSNSModelProxy getInstance] getMomentIDBelongUserWithUserId:momentIdOrUserId];
        momentIndexArray = [NSMutableArray arrayWithArray:[[MXRBookSNSModelProxy getInstance] getMomentsOnArrayIndex:momentArr]];
        [[MXRBookSNSModelProxy getInstance] uninterestredWithunFocusUserId:momentIdOrUserId];
    }
    if ([MXRBookSNSModelProxy getInstance].bookSNSMomentsArray.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_UpdateALLMoment object:nil];
        return;
    }
    [momentIndexArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[obj integerValue] inSection:0];
        [deleteMomentIndexPathArray addObject:indexPath];
    }];
    
    mxr_dispatch_main_async_safe(^{
        [self.bookSNSTableView beginUpdates];
        [self.bookSNSTableView deleteRowsAtIndexPaths:[deleteMomentIndexPathArray copy] withRowAnimation:UITableViewRowAnimationFade];
        [self.bookSNSTableView endUpdates];
    })
}

- (void)configCell:(id)cell indexPath:(NSIndexPath *)indexPath{
   
    MXRSNSShareModel * model;
    model = [[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray objectAtIndex:indexPath.row];
    if ([(UITableViewCell *)cell respondsToSelector:@selector(setModel:)]) {
        [(UITableViewCell *)cell performSelector:@selector(setModel:) withObject:model];
    }
}

#pragma mark - delegate
#pragma mark - tableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if ([MXRBookSNSModelProxy getInstance].bookSNSMomentsArray.count == 0) {
        return self.noSNSDataReloadCount;
    }
    return [MXRBookSNSModelProxy getInstance].bookSNSMomentsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @MXRWeakObj(self);
    MXRSNSShareModel * model;
    if ([MXRBookSNSModelProxy getInstance].bookSNSMomentsArray.count == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadingCell"];
        }
        cell.imageView.image = MXRIMAGE(@"icon_cell_BookSNS_placeholder_disable");
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    model = [[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray objectAtIndex:indexPath.row];
    if (model.senderType == SenderTypeOfDefault || model.senderType == SenderTypeOfShare) {
        MXRBookSNSTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:mxrBookSNSTableViewCell forIndexPath:indexPath];
        model = (MXRSNSSendModel *)[[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray objectAtIndex:indexPath.row];
        cell.delegate = self;
        cell.model = model;
        cell.imageClick = ^(BOOL isShowTabbar){
#ifdef MXRSNAPLEARN
            [selfWeak.tabBarController.tabBar setHidden:!isShowTabbar];
#endif
        };
        cell.belongViewtype = MXRBookSNSBelongViewtypeBookSNSView;
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell.frame.size.height == 0) {
            cell.hidden = YES;
        }else{
        cell.hidden = NO;
        }
        
        //3D-Touch
//        if (IOS9_OR_LATER && ForceTouchCapabilityAvailable) {
//            [self registerForPreviewingWithDelegate:self sourceView:cell];
//        }
        return cell;
    }else if(model.senderType == SenderTypeOfTransmit){
        if ([(MXRSNSTransmitModel *)model orginalModel].srcMomentStatus == MXRSrcMomentStatusDelete) {
            MXRBookSNSDeleteForwardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:mxrBookSNSDeleteForwardTableViewCell forIndexPath:indexPath];
            model = (MXRSNSTransmitModel *)[[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray objectAtIndex:indexPath.row];
            cell.model = (MXRSNSTransmitModel *)model;
            cell.belongViewtype = MXRBookSNSBelongViewtypeBookSNSView;
            // cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            MXRBookSNSForwardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:mxrBookSNSForwardTableViewCell];
            model = (MXRSNSTransmitModel *)[[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray objectAtIndex:indexPath.row];
            cell.delegate = self;
            cell.model = (MXRSNSTransmitModel *)model;
            cell.belongViewtype = MXRBookSNSBelongViewtypeBookSNSView;
            cell.imageClick = ^(BOOL isShowTabbar){
#ifdef MXRSNAPLEARN
                [selfWeak.tabBarController.tabBar setHidden:!isShowTabbar];
#endif
            };
            // cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (cell.frame.size.height == 0) {
                cell.hidden = YES;
            }else{
                cell.hidden = NO;
            }
            //3D-Touch
//            if (IOS9_OR_LATER && ForceTouchCapabilityAvailable) {
//                [self registerForPreviewingWithDelegate:self sourceView:cell];
//            }
            return cell;
        }
    }else{
        return [[UITableViewCell alloc] init];
    }
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([MXRBookSNSModelProxy getInstance].bookSNSMomentsArray.count == 0) {
//            return 95;
//    }
//    NSString * strId;
//    MXRSNSShareModel * model;
//    CGFloat height;
//    model = [[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray objectAtIndex:indexPath.row];
//    if (model.senderType == SenderTypeOfDefault || model.senderType == SenderTypeOfShare) {
//        strId = mxrBookSNSTableViewCell;
//        height = [tableView fd_heightForCellWithIdentifier:strId cacheByIndexPath:indexPath configuration:^(id cell) {
//            [self configCell:cell indexPath:indexPath];
//        }];
//        height = height + 0.5;
//    }else if(model.senderType == SenderTypeOfTransmit){
//        if ([(MXRSNSTransmitModel *)model orginalModel].srcMomentStatus == MXRSrcMomentStatusDelete) {
//            strId = mxrBookSNSDeleteForwardTableViewCell;
//        }else{
//            strId = mxrBookSNSForwardTableViewCell;
//        }
//        height = [tableView fd_heightForCellWithIdentifier:strId cacheByIndexPath:indexPath configuration:^(id cell) {
//            [self configCell:cell indexPath:indexPath];
//        }];
//        height = height + 1;
//    }else{
//        height = 0.001;
//    }
//
//    model.cellheight = height;
//
//    return height;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([MXRBookSNSModelProxy getInstance].bookSNSMomentsArray.count == 0) {
        return 95.f;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if ([MXRBookSNSModelProxy getInstance].bookSNSMomentsArray.count == 0) {
            return 95.f;
        } else {
            return SCREEN_HEIGHT_DEVICE;
        }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MXRClickUtil event:@"DreamCircle_Detail_Click"];
    self.selectIndexPath = indexPath;
    if ([MXRBookSNSModelProxy getInstance].bookSNSMomentsArray.count == 0) {
        return;
    }
    MXRSNSShareModel * model = [[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray objectAtIndex:indexPath.row];
    if (model.momentStatusType == MXRBookSNSMomentStatusTypeOnLocal || model.momentStatusType == MXRBookSNSMomentStatusTypeOnUpload) {
            return;
    }
    [MXRClickUtil event:@"MengXiangQuanClick"];
    MXRBookSNSDetailViewController * vc = [[MXRBookSNSDetailViewController alloc] initWithModel:[[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MXRQuestionBannerDelegate
- (void)MXRQuestionBannerDidSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [MXRClickUtil event:@"Test_index_btn"];
    [MXRClickUtil event:@"MengXiangQuanClick"];
    if (![MXRDeviceUtil isReachable]) {
        [MXRConstant showAlertNoNetwork];
    }else{
        if ([[UserInformation modelInformation] checkIsLogin]) {
            MXRPKHomeViewController *pk = [MXRPKHomeViewController pkHomeViewController];
            [self.navigationController pushViewController:pk animated:YES];
        }
    }
}
#pragma mark MXRPromptViewDelegate
//-(void)promptView:(MXRPromptView*)promptView didSelectAtIndex:(NSUInteger)index{
//
//}
#pragma mark - UITabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        if ([nav.topViewController isEqual:self]) {
            if ([tabBarController.selectedViewController isEqual:viewController]) {
                if (!self.bookSNSTableView.mj_header.isRefreshing) {
                    CGFloat contentOffsetY = self.bookSNSTableView.contentOffset.y;
                    if (contentOffsetY == 0) {
                        [self.bookSNSTableView.mj_header beginRefreshing];
                    } else {
                        [self.bookSNSTableView setContentOffset:CGPointZero animated:NO];
                    }
                }
            }
        }
    }
    
    return YES;
}
#pragma mark - getter
-(UILabel *)tipsUpdateMomentCountLabel{

    if (!_tipsUpdateMomentCountLabel) {
        _tipsUpdateMomentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 0)];
        _tipsUpdateMomentCountLabel.alpha = 0.9;
        _tipsUpdateMomentCountLabel.backgroundColor = MXRCOLOR_2FB8E2;
        _tipsUpdateMomentCountLabel.textColor = [UIColor whiteColor];
        _tipsUpdateMomentCountLabel.textAlignment = NSTextAlignmentCenter;
        _tipsUpdateMomentCountLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _tipsUpdateMomentCountLabel;
}
-(MXRBookSNSHeadVIew *)headView{

    if (!_headView) {
        CGFloat width = itemWidth * IPHONE6_SCREEN_WIDTH_SCALE;
        CGFloat height = width * itemHeight / itemWidth;
        CGFloat headViewheight = height + (20 * IPHONE6_SCREEN_HEIGHT_SCALE);
        _headView = [[MXRBookSNSHeadVIew alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.questionBanner.frame), SCREEN_WIDTH_DEVICE,headViewheight) andItemSize:CGSizeMake(width, height)];
    }
    return _headView;
}
- (MXRQuestionBanner *)questionBanner {
    if (!_questionBanner) {
#ifdef MXRSNAPLEARN
        _questionBanner = [[MXRQuestionBanner alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 0)];
#else
        _questionBanner = [[MXRQuestionBanner alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, [MXRQuestionBanner topEdgeInset] + [MXRQuestionBanner itemSize].height)];
        _questionBanner.delegate = self;
#endif
    }
    return _questionBanner;
}
-(UIBarButtonItem *)creatMomentBtn{

    if (!_creatMomentBtn) {
        _creatMomentBtn = [[UIBarButtonItem alloc] initWithImage:MXRIMAGE(@"btn_bookSNSVC_creatSNSStatus") style:UIBarButtonItemStylePlain target:self action:@selector(creatStatusBtnClick:)];
    }
    return _creatMomentBtn;
}

- (void)clickAppStatusBar
{
    if (!IOS10_OR_LATER) {
        if (self.bookSNSTableView.scrollsToTop) {
            mxr_dispatch_main_async_safe(^{
                [self.bookSNSTableView setContentOffset:CGPointMake(self.bookSNSTableView.contentOffset.x, - kAppTopViewHeight) animated:YES];
            });
        }
    }
}

#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    [MXRClickUtil event:@"MengXiangQuanClick"];
    MXRSNSShareModel *model;
    UIView *sourceView = previewingContext.sourceView;
    if ([sourceView isKindOfClass:[MXRBookSNSTableViewCell class]]) {
        MXRBookSNSTableViewCell *cell = (MXRBookSNSTableViewCell *)sourceView;
        model = cell.model;
    } else if ([sourceView isKindOfClass:[MXRBookSNSDeleteForwardTableViewCell class]]) {
        MXRBookSNSDeleteForwardTableViewCell *cell = (MXRBookSNSDeleteForwardTableViewCell *)sourceView;
        model = cell.model;
    } else if ([sourceView isKindOfClass:[MXRBookSNSForwardTableViewCell class]]) {
        MXRBookSNSForwardTableViewCell *cell = (MXRBookSNSForwardTableViewCell *)sourceView;
        model = cell.model;
    }
    if (model == nil) {
        return nil;
    }
    if (model.momentStatusType == MXRBookSNSMomentStatusTypeOnLocal || model.momentStatusType == MXRBookSNSMomentStatusTypeOnUpload) {
        return nil;
    }
    MXRBookSNSDetailViewController * vc = [[MXRBookSNSDetailViewController alloc] initWithModel:model];
    return vc;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}

- (void)commentSNSFromCell:(MXRSNSShareModel *)model {
    [[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.momentId integerValue] == [model.momentId integerValue]) {
            self.selectIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];//获取当前点击的cell位置
            *stop = YES;
        }
    }];
}

@end
