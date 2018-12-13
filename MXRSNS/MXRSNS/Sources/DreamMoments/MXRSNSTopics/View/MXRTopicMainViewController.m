  //
//  MXRTopicMainViewController.m
//  huashida_home
//
//  Created by dingyang on 16/9/19.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRTopicMainViewController.h"
#import "MXRTopicsController.h"
#import "MXRTopicProxy.h"
#import "MXRTopicModel.h"
#import "MXRSNSShareModel.h"
#import "MXRBookSNSDetailViewController.h"
#import "MXRBookSNSTableViewCell.h"
#import "MXRBookSNSForwardTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "NSString+Ex.h"
#import "MXRSNSSendStateViewController.h"
#import "MXRNavigationViewController.h"
#import "MXRBookSNSDeleteForwardTableViewCell.h"
//#import "MXRLoginVC.h"
//#import "AppDelegate.h"
#import "ALLNetworkURL.h"
//#import "MXRNewShareView.h"
#import "MXRBookSNSModelProxy.h"
#import "MXRBookSNSLoadDataGifRefreshHeader.h"
#import "MXRBookSNSLoadDataGifRefreshFooter.h"
#import "GlobalBusyFlag.h"
#import "UIImage+Extend.h"
#import "GlobalFunction.h"
//#import "MXRHomePageBookRecommendDetailModel.h"
#import "MXRBookSNSController.h"
//#import "MXRSuspendedBall.h"
//#import "MXRHomeActivityNetworkManager.h"
//#import "MXRHomeEggActivityModel.h"
//#import <NSFileManager+MAREX.h>
//#import "MXRCapsuleToysWebView.h"
//#import <NSString+MAREX.h>

//#import "UITableView+FDTemplateLayoutCell.h"
#define mxrBookSNSTableViewCell @"MXRBookSNSTableViewCell"
#define mxrBookSNSForwardTableViewCell @"MXRBookSNSForwardTableViewCell"
#define mxrBookSNSDeleteForwardTableViewCell @"MXRBookSNSDeleteForwardTableViewCell"
static float headViewHigh = 185;
static float upLabelHigh = 55.0f;
static float downLabelHigh = 12.0f;
//static float defaultCellHigh = 95.0f;
@interface MXRTopicMainViewController ()<UITableViewDelegate, UITableViewDataSource,MXRBookSNSTableViewCellDelegate,MXRBookSNSForwardTableViewCellDelegate>
{
    NSMutableArray *p_dynamicList;
    MXRTopicModel *p_topicModel;
    BOOL _addedGradientLayer;
}

@property (weak, nonatomic) IBOutlet UITableView *e_tableView;
@property (weak, nonatomic) IBOutlet UIButton *joinNowButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;

@property (strong, nonatomic) UILabel * e_tipsUpdateMomentCountLabel;
@property (nonatomic, assign) BOOL isNotFirstRequestTopicData;
@property (nonatomic, assign) NSInteger noSNSDataReloadCount; // 默认没有数据时，默认条的count
@property (strong, nonatomic) UIBarButtonItem * shareBtn;
@property (strong, nonatomic) NSMutableArray * tableViewDataSourceArray; // 用于显示给用户看的特定排序的动态数组
@property (strong, nonatomic) NSMutableArray * recommendArray; // 运营推荐的动态数组
@property (assign, nonatomic) fromVCType vcType;


@end

@implementation MXRTopicMainViewController
@synthesize p_topicName;
@synthesize p_topicID;
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

-(BOOL)shouldAutorotate{
    return NO;
}
-(instancetype)initWithMXRTopicModelID:(NSString *)topicID{
    self = [super initWithNibName:@"MXRTopicMainViewController" bundle:nil];
    if (self) {
       p_topicID = topicID;
    }
    return self;
}
-(instancetype)initWithMXRTopicModelName:(NSString *)topicName fromVC:(fromVCType)viewController{
    self = [super initWithNibName:@"MXRTopicMainViewController" bundle:nil];
    if (self) {
        p_topicName = topicName;
        self.vcType = viewController;
    }
    return self;
}
/*******************************************************************************/
#pragma mark View-Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setDefaultView];
    [self p_setDefaultData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MXRClickUtil beginEvent:@"MengXiangQuanPage"];
    if (self.closePopGestureRecognizer) {
        [self removeInteractivePopGestureRecognizer];
    }
    if (p_dynamicList.count == 0) {
        [self.e_tableView reloadData];
    }else{
        [self reloadTableView];
    }
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MXRClickUtil endEvent:@"MengXiangQuanPage"];
    [[MXRTopicProxy getInstence] clearCurrentModel];
    [self hideNetworkErrorView];
  
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self addInteractivePopGestureRecognizer];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)p_setDefaultView{
    self.title = MXRLocalizedString(@"TopicTitle", @"话题页");
    self.noSNSDataReloadCount = 20;
    
    self.tableBottomConstraint.constant = (IS_iPhoneX_Device()?60:49);
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSpacer.width = -6;
//    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.shareBtn];
    self.navigationItem.rightBarButtonItem = self.shareBtn;
    self.e_tableView.backgroundColor = BACKGROUND_COLOR_249;
    self.e_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.e_tableView registerNib:[UINib nibWithNibName:mxrBookSNSTableViewCell bundle:nil] forCellReuseIdentifier:mxrBookSNSTableViewCell];
    [self.e_tableView registerNib:[UINib nibWithNibName:mxrBookSNSForwardTableViewCell  bundle:nil] forCellReuseIdentifier:mxrBookSNSForwardTableViewCell];
    [self.e_tableView registerNib:[UINib nibWithNibName:mxrBookSNSDeleteForwardTableViewCell  bundle:nil] forCellReuseIdentifier:mxrBookSNSDeleteForwardTableViewCell];
    self.e_tableView.estimatedRowHeight = 95.f;
    [self createLoadMoreHeader];
    [self createLoadMoreFooter];
    
    [self.joinNowButton setTitle:MXRLocalizedString(@"MXRTopicMainViewController_Join_Now", "立即参与") forState: UIControlStateNormal];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!_addedGradientLayer) {
        [self.joinNowButton mxr_setGradientBackGoundStyle:MXRUIViewGradientStyleLightGreen2];
        _addedGradientLayer = YES;
    }
}

-(void)p_setDefaultData{
    /*从网络请求数据*/
    [self p_getDataFromService];
    /*添加通知*/
    [self p_addobserver];
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
    self.e_tableView.mj_header = header;
}
-(void)loadMoreNewSNSDataHaveTips{
//    if(p_dynamicList != nil && p_dynamicList.count > 0) {
//        MXRSNSShareModel * tempModel = (MXRSNSShareModel *)[p_dynamicList lastObject];
//        NSString *time = [tempModel.senderTime stringValue];
//        NSString *orderNum = tempModel.orderNum;
//        [self p_getDataFromServicePreviousByTimesStamp:time andOrderNum:orderNum];
//    } else {
        [self p_getDataFromServicePreviousByTimesStamp:nil andOrderNum:nil];
//    }
}
-(void)createLoadMoreFooter
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MXRBookSNSLoadDataGifRefreshFooter * t_footer = [MXRBookSNSLoadDataGifRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOldSNSData)];
    // 隐藏状态
    t_footer.refreshingTitleHidden = YES;
    [t_footer setTitle:MXRLocalizedString(@"Letter_Nomore_Data", @"—— 没有更多了 ——") forState:MJRefreshStateNoMoreData];
    self.e_tableView.mj_footer = t_footer;
}
-(void)loadMoreOldSNSData{

    [self p_getDataFromServiceNextByTimesStamp:nil andOrderNum:nil];
}
-(void)p_getDataFromService{
    if ([MXRTopicProxy getInstence].currentModel.dynamicList.count > 0) {
       [self reloadTableView];
    }
    @MXRWeakObj(self);
    [self hideNetworkErrorView];
    if (self.isNotFirstRequestTopicData) {
        [[GlobalBusyFlag sharedInstance] showBusyFlagOnView:self.view];
    }
    void (^aCallBack)(BOOL , id) = ^(BOOL isSuccess, id sender){
       
        if (isSuccess) {
            p_dynamicList = [MXRTopicProxy getInstence].currentModel.dynamicList;
            p_topicModel = [MXRTopicProxy getInstence].currentModel;
            [self showCapsuleToysTopicName:p_topicModel.name];
            if (!p_dynamicList || !p_dynamicList.count) {
                
            }else{
                selfWeak.e_tableView.scrollEnabled = YES;
            }
            [selfWeak requestRecommendMoment];
            if ( selfWeak.tableViewDataSourceArray.count < 3) {
                [selfWeak.e_tableView.mj_footer endRefreshing];
//                selfWeak.e_tableView.mj_footer.hidden = YES;
            }
        }else{
            if (self.isNotFirstRequestTopicData) {
                [[GlobalBusyFlag sharedInstance] hideBusyFlag];
            }
            if (![MXRDeviceUtil isReachable]) {
                [selfWeak showNetworkErrorWithRefreshCallback:^{
                    selfWeak.isNotFirstRequestTopicData = YES;
                    selfWeak.noSNSDataReloadCount = 0;
                    [selfWeak reloadTableView];
                    
                    if ([MXRDeviceUtil isReachable]){
                        [selfWeak p_getDataFromService];
                    }
                }];
            }else{
                selfWeak.e_tableView.scrollEnabled = NO;
                [MXRConstant showAlert:MXRLocalizedString(@"MXRTopicMainViewControllerTopicNoData", @"此话题好像不见了呢") andShowTime:1.5f];
                NSString * topicId = selfWeak.p_topicID ? selfWeak.p_topicID : selfWeak.p_topicName;
                NSDictionary * dict = [NSDictionary dictionaryWithObject:topicId forKey:@"TOPICID"];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_TopicNoData object:dict];
                [selfWeak backAction:nil];
            }
        }
    };
    if (p_topicID && ![p_topicID isEqualToString:@""]) {
        [[MXRTopicsController getInstance] getDynamicForTopicByUid:nil topicId:p_topicID pageIndex:1 rows:10 andCallBack:aCallBack];
    }else if (p_topicName && ![p_topicName isEqualToString:@""]){
        [[MXRTopicsController getInstance] getDynamicForTopicByUid:nil name:p_topicName pageIndex:1 rows:10 andCallBack:aCallBack];
    }else{
        DERROR("no valid information for request topic dynamic!")
    }
}
-(void)p_getDataFromServicePreviousByTimesStamp:(NSString *)atime andOrderNum:(NSString *)aorderNum{
    
    if (p_dynamicList.count == 0 || !p_dynamicList) {
        [self.e_tableView.mj_header endRefreshing];
        return;
    }
    @MXRWeakObj(self);
    __block NSString *time = @"";
    NSString *orderNum = @"";
    if (atime) {
        time = atime;
        orderNum = aorderNum;
    }else if (p_dynamicList.count > 0) {
       __block MXRSNSShareModel * tempModel;
        [p_dynamicList enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.momentId) {
                if (![obj.momentId isEqualToString:obj.clientUuid]) {
                    if (![obj getIsRecommendMoment]) {
                        tempModel = obj;
                        *stop = YES;
                    }
                }
            }
        }];
        time = [tempModel.senderTime stringValue];
        if (time == nil) {
            return;
        }
        orderNum = tempModel.orderNum;
        
//        MXRSNSShareModel *model = [p_dynamicList firstObject];
//        time = [model.senderTime stringValue];
//        if (time == nil) {
//            return;
//        }
//        orderNum = model.orderNum;
    }
    [[MXRTopicsController getInstance] getPreviousDynamicForTopicByUid:nil topicId:autoString(@(p_topicModel.topicId)) timeStamp:time orderNum:orderNum andCallBack:^(BOOL isSuccess, id sender) {
        [selfWeak.e_tableView.mj_header endRefreshing];
        if (isSuccess) {
            NSArray *newArray = [MXRTopicProxy getInstence].currentModel.dynamicList;
            if (newArray.count > 0) {
                    if (atime) {
                        p_dynamicList = nil;
                        p_dynamicList = [NSMutableArray arrayWithArray:newArray];
                    }else{
                       __block NSMutableArray * tempArray = [NSMutableArray arrayWithArray:newArray];
                        [newArray enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([selfWeak isCantainsSNSModel:obj]) {
                                [tempArray removeObject:obj];
                            }
                        }];
                        [p_dynamicList insertObjects:tempArray atIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, tempArray.count)]];
                        if (tempArray.count > 0) {
                            [selfWeak showTipsUpdateNewMomentCount:tempArray.count];
                            //刷新动态数量
                            p_topicModel.publishDynamicNum = [NSString stringWithFormat:@"%lu", [p_topicModel.publishDynamicNum integerValue] + tempArray.count];
                        }
                    }
                
                [selfWeak requestRecommendMoment];
            }else{
                [selfWeak reloadTableView];
            }
        }else{
            DERROR(@"Refresh error");
        }
    }];
}

- (void)checkNoMommentData{

    if (!p_dynamicList || !p_dynamicList.count) {
        self.e_tableView.scrollEnabled = NO;
        [MXRConstant showAlert:MXRLocalizedString(@"MXRTopicMainViewControllerTopicNoData", @"此话题好像不见了呢") andShowTime:1.5f];
        
        NSString * topicId = self.p_topicID ? self.p_topicID : self.p_topicName;
        NSDictionary * dict = [NSDictionary dictionaryWithObject:topicId forKey:@"TOPICID"];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_TopicNoData object:dict];
        [self backAction:nil];
    }
}

- (void)requestRecommendMoment{

    @MXRWeakObj(self);
    if (p_topicID || p_topicName) {
        [[MXRBookSNSController getInstance] getServerRecommendDynamicWithTopicID:p_topicID topicName:p_topicName success:^(id result) {
            [selfWeak.recommendArray removeAllObjects];
            if ([result isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)result;
                if (array.count > 0) {
                    [selfWeak.recommendArray removeAllObjects];
                    for (NSDictionary *dictionary in array) {
                        MXRSNSShareModel *model = [[MXRSNSShareModel alloc] createRecommentDataWithDictionary:dictionary];
                        [selfWeak.recommendArray addObject:model];
                    }
                }else{
                    [selfWeak checkNoMommentData];
                }
            }
            [selfWeak reloadTableView];
        } failure:^(MXRServerStatus status, id result) {
            [selfWeak.recommendArray removeAllObjects];
            [selfWeak reloadTableView];
        }];
        
    }else{
        [MXRConstant showAlert:MXRLocalizedString(@"MXRTopicMainViewControllerTopicNoData", @"此话题好像不见了呢") andShowTime:1.5f];
        
        NSString * topicId = self.p_topicID ? self.p_topicID : self.p_topicName;
        NSDictionary * dict = [NSDictionary dictionaryWithObject:topicId forKey:@"TOPICID"];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_TopicNoData object:dict];
        [self backAction:nil];
    }
    
    
}

-(void)p_getDataFromServiceNextByTimesStamp:(NSString *)atime andOrderNum:(NSString *)aorderNum{
    if (p_dynamicList.count == 0 || !p_dynamicList) {
        [self.e_tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    @MXRWeakObj(self);
    NSString *time = @"";
    NSString *orderNum = @"";
    if (atime) {
        time = atime;
        orderNum = aorderNum;
    }else if (p_dynamicList.count) {
       __block MXRSNSShareModel * tempModel;
        for (int i = p_dynamicList.count - 1; i >= 0 ; i--) {
            MXRSNSShareModel * model = p_dynamicList[i];
            if (model.momentId) {
                if (![model.momentId isEqualToString:model.clientUuid]) {
                    if (![model getIsRecommendMoment]) {
                        tempModel = model;
                        break;
                    }
                }
            }
        }
        time = [tempModel.senderTime stringValue];
        orderNum = tempModel.orderNum;
    }
    [[MXRTopicsController getInstance] getNextDynamicForTopicByUid:nil topicId:autoString(@(p_topicModel.topicId)) timeStamp:time orderNum:orderNum  andCallBack:^(BOOL isSuccess, id sender) {
//        [selfWeak.e_tableView.mj_footer endRefreshing];
//        selfWeak.e_tableView.mj_footer.hidden = YES;
        if (isSuccess) {
            NSArray *newArray = [MXRTopicProxy getInstence].currentModel.dynamicList;
            if (newArray.count) {
                if (atime) {
                    p_dynamicList = nil;
                    p_dynamicList = [NSMutableArray arrayWithArray:newArray];
                }else{
                    [newArray enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (![selfWeak isCantainsSNSModel:obj]) {
                            [p_dynamicList addObject:obj];
                        }
                    }];
                }
                [selfWeak reloadTableView];
                
                if (newArray.count < 20) {
                    [selfWeak.e_tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [selfWeak.e_tableView.mj_footer endRefreshing];
                }
            }else{
                [selfWeak.e_tableView.mj_footer endRefreshingWithNoMoreData];
                
            }
        }else{
            [selfWeak.e_tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)p_addobserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFreshTable) name:Notification_MXRBookSNS_UpdateALLMoment object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFreshTable) name:Notification_MXRBookSNS_ReloadData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTabbar) name:Notification_MXRBookSNS_ShowTabbar object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userHandleMoment:) name:Notification_MXRBookSNS_UserHandleMoment object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(topicShare:) name:Notification_MXRBookSNS_TopicShare object:nil];
}
-(void)reloadTableView{
    
    if (self.isNotFirstRequestTopicData) {
        [[GlobalBusyFlag sharedInstance] hideBusyFlag];
    }
    NSMutableArray * tempDynamicListArray = [NSMutableArray arrayWithCapacity:p_dynamicList.count];
    [tempDynamicListArray addObjectsFromArray:p_dynamicList];
   
    
    
    [self.tableViewDataSourceArray removeAllObjects];
    
    self.tableViewDataSourceArray = [[MXRBookSNSModelProxy getInstance] sortMomentArray:tempDynamicListArray newArray:self.recommendArray];
    [self.e_tableView reloadData];
}

/**
 判断当前话题列表里有没有该动态
 */
-(BOOL )isCantainsSNSModel:(MXRSNSShareModel *)model{
    
    __block BOOL isCantains = NO;
    [p_dynamicList enumerateObjectsUsingBlock:^(MXRSNSShareModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.momentStatusType == MXRBookSNSMomentStatusTypeOnInternet) {
            if ([model.momentId isEqualToString:obj.momentId] || [model.momentId isEqualToString:obj.clientUuid]) {
                isCantains = YES;
            }
        }else{
            if ([model.momentId isEqualToString:obj.momentId] || [model.clientUuid isEqualToString:obj.momentId]) {
                isCantains = YES;
            }
        }
    }];
    return isCantains;
}

/**
 返回按钮

 @param sender
 */
- (void)backAction:(id)sender{
    if (self.vcType == bookSNSSendDetailViewController) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}


#pragma mark - Noti Methods
-(void)topicShare:(NSNotification *)sender{

     NSNumber * shareWay = [sender.object objectForKey:@"TopicShareWay"];
    NSString * topicId = self.p_topicID ? self.p_topicID : self.p_topicName;
    [[MXRTopicsController getInstance] collectTopicShareWithTopicId:topicId andShareWay:[shareWay integerValue] andShareUserId:[UserInformation modelInformation].userID andCallBack:^(BOOL isSuccess) {
        
    }];
}
-(void)hiddenTabbar{
    
    [self.tabBarController.tabBar setHidden:YES];
}
//-(void)gotoBookDetailBefore:(NSNotification *)sender{
//}
//-(void)gotoBookDetailAfter:(NSNotification *)sender{
//}
-(void)reFreshTable{
    MXRSNSShareModel * tempModel = (MXRSNSShareModel *)[p_dynamicList lastObject];
    NSString *time = [tempModel.senderTime stringValue];
    NSString *orderNum = tempModel.orderNum;
    [self p_getDataFromServicePreviousByTimesStamp:time andOrderNum:orderNum];
}
-(void)userHandleMoment:(NSNotification *)noti{
    
    NSNumber * handleTypeNUm = [noti.object objectForKey:@"UserHandleMomentType"];
    NSString * handleId = [noti.object objectForKey:@"UserHandleMomentID"];
//    NSNumber * momentBelongViewTypeNum = [noti.object objectForKey:@"UserHandleMomentBelongViweType"];
//    if ([momentBelongViewTypeNum integerValue] == MXRUserHandleMomentBelongViewtypeTopicView) {
        if ([handleTypeNUm integerValue] == MXRUserHandleMomentViewTypeDelete) {
            [self deleteMomentWithMomentIdOrUserId:handleId andHandleType:MXRUserHandleMomentViewTypeDelete];
        }else if([handleTypeNUm integerValue] == MXRUserHandleMomentViewTypeNoInterest){
            [self deleteMomentWithMomentIdOrUserId:handleId andHandleType:MXRUserHandleMomentViewTypeNoInterest];
        }else if([handleTypeNUm integerValue] == MXRUserHandleMomentViewTypeReport){
            // 举报 在页面展示效果和删除效果一样
           [self deleteMomentWithMomentIdOrUserId:handleId andHandleType:MXRUserHandleMomentViewTypeDelete];
        }
//    }
}

-(void)deleteMomentWithMomentIdOrUserId:(NSString *)momentIdOrUserId andHandleType:(MXRUserHandleMomentViewType) handleType{
    
    if (p_dynamicList.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_UpdateALLMoment object:nil];
        return;
    }
    NSMutableArray * momentIndexArray = [NSMutableArray array];
    if (handleType == MXRUserHandleMomentViewTypeDelete) {
        __block NSInteger index;
        NSArray * t_arr = [NSArray arrayWithArray:self.tableViewDataSourceArray];
        [t_arr enumerateObjectsUsingBlock:^(MXRSNSShareModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.momentId isEqualToString:momentIdOrUserId]) {
                index = idx;
                [p_dynamicList removeObject:obj];
                [self.tableViewDataSourceArray removeObject:obj];
                [self.recommendArray removeObject:obj];
                *stop = YES;
            }
        }];
        [momentIndexArray addObject:[NSString stringWithFormat:@"%lu",(long)index]];
    }else if (handleType == MXRUserHandleMomentViewTypeNoInterest){
    }
    __block NSMutableArray <NSIndexPath *> * deleteMomentIndexPathArray = [NSMutableArray array];
    [momentIndexArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[obj integerValue] inSection:0];
        [deleteMomentIndexPathArray addObject:indexPath];
    }];
    if (p_dynamicList.count == 0) {
        
        [MXRConstant showAlert:MXRLocalizedString(@"MXRTopicMainViewControllerTopicNoData", @"此话题好像不见了呢") andShowTime:1.5f];
    
        NSString * topicId = self.p_topicID ? self.p_topicID : self.p_topicName;
        NSDictionary * dict = [NSDictionary dictionaryWithObject:topicId forKey:@"TOPICID"];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_TopicNoData object:dict];
        [self backAction:nil];
        return;
    }
    [self.e_tableView beginUpdates];
    [self.e_tableView deleteRowsAtIndexPaths:deleteMomentIndexPathArray withRowAnimation:UITableViewRowAnimationFade];
    [self.e_tableView endUpdates];
}

/*******************************************************************************/
#pragma mark get-set method
-(NSMutableArray *)tableViewDataSourceArray{

    if (!_tableViewDataSourceArray) {
        _tableViewDataSourceArray = [NSMutableArray array];
    }
    return _tableViewDataSourceArray;
}

- (NSMutableArray *)recommendArray{

    if (!_recommendArray) {
        _recommendArray = [NSMutableArray array];
    }
    return _recommendArray;
}

-(UIBarButtonItem *)shareBtn{
    
    if (!_shareBtn) {
//        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        rightBtn.frame = CGRectMake(0 , 0, 44, 44);
//        [rightBtn setTitleColor:MXRCOLOR_2FB8E2 forState:UIControlStateNormal];
//        [rightBtn setImage:[UIImage imageNamed:@"btn_bookdetail_navi_share"] forState:UIControlStateNormal];
//        rightBtn.imageView.contentMode = UIViewContentModeCenter;
//        [rightBtn addTarget:self action:@selector(e_shareTopic) forControlEvents:UIControlEventTouchUpInside];
//        _shareBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        
        _shareBtn = [[UIBarButtonItem alloc] initWithImage:MXRIMAGE(@"btn_bookdetail_navi_share") style:UIBarButtonItemStylePlain target:self action:@selector(e_shareTopic)];
    }
    return _shareBtn;
}
-(UILabel *)e_tipsUpdateMomentCountLabel{
    if (!_e_tipsUpdateMomentCountLabel) {
        _e_tipsUpdateMomentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 0)];
        _e_tipsUpdateMomentCountLabel.alpha = 0.9;
        _e_tipsUpdateMomentCountLabel.backgroundColor = MXRCOLOR_2FB8E2;
        _e_tipsUpdateMomentCountLabel.textColor = [UIColor whiteColor];
        _e_tipsUpdateMomentCountLabel.textAlignment = NSTextAlignmentCenter;
        _e_tipsUpdateMomentCountLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _e_tipsUpdateMomentCountLabel;
}
-(void)showTipsUpdateNewMomentCount:(NSInteger )count{
    if ([self.view.subviews containsObject:self.e_tipsUpdateMomentCountLabel]) {
        [self.e_tipsUpdateMomentCountLabel removeFromSuperview];
        self.e_tipsUpdateMomentCountLabel = nil;
    }
    [self.view addSubview:self.e_tipsUpdateMomentCountLabel];
    [self.view bringSubviewToFront:self.e_tipsUpdateMomentCountLabel];
    @MXRWeakObj(self);
    _e_tipsUpdateMomentCountLabel.text = [NSString stringWithFormat:@"%@%ld%@",MXRLocalizedString(@"MXRBookSNSViewControllerTipsUpdate", @"更新了"),(long)count,MXRLocalizedString(@"MXRBookSNSViewControllerTipsUpdatedetail", @"条动态")];
    [UIView animateWithDuration:0.7f animations:^{
        self.e_tipsUpdateMomentCountLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 30);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5f animations:^{
                    self.e_tipsUpdateMomentCountLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 0);
                } completion:^(BOOL finished) {
                    [selfWeak.e_tipsUpdateMomentCountLabel removeFromSuperview];
                    selfWeak.e_tipsUpdateMomentCountLabel = nil;
                }];
        });
    }];
}

/*******************************************************************************/
#pragma mark Button-Click Action
/*分享话题页*/
-(void)e_shareTopic{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    [MXRClickUtil event:@"DreamCircle_TopicShare_Click"];
    if (![[UserInformation modelInformation] checkIsLogin]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"SharePageTypeIsTopicSNS" forKey:@"SharePageTypeIs"];
    NSString *shareUrlString = [NSString stringWithFormat:@"%@/topic/share.html?tpid=%ld",MXRSNSShareServiceUrl(),(long)p_topicModel.topicId];
    [[NSUserDefaults standardUserDefaults] setObject:shareUrlString forKey:@"ShareURL"];
    NSString *title = [NSString stringWithFormat:@"%@:%@",MXRLocalizedString(@"SNSTopic", @"分享话题"),p_topicModel.name];
    
//    MXRNewShareView * shareView = [[MXRNewShareView alloc] initWithTitle:title andShareContent:p_topicModel.topicDescription andShareImageUrl:p_topicModel.picUrl andShareUrlStr:shareUrlString];
//    [shareView showInView:self.view];
}
/*立即参与*/
- (IBAction)e_JoinAndGo:(id)sender {
    [MXRClickUtil event:@"MengXiangQuanClick"];
    [MXRClickUtil event:@"DreamCircle_JoinTopic_Click"];
    if (![[UserInformation modelInformation] checkIsLogin]) {
        return;
    }
    
   MXRSNSSendStateViewController *sendStateVC = [[MXRSNSSendStateViewController alloc] initWithTopicModel:p_topicModel];
    MXRNavigationViewController *nav = [[MXRNavigationViewController alloc]initWithRootViewController:sendStateVC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark UITableView Delegate and DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    if (self.tableViewDataSourceArray.count == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadingCell"];
        }
        cell.imageView.image = MXRIMAGE(@"icon_cell_BookSNS_placeholder_disable");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell * cell;
    MXRSNSShareModel * model;
    MXRSNSShareModel * tempModel = (MXRSNSShareModel *)[self.tableViewDataSourceArray objectAtIndex:indexPath.row];
    if (tempModel.senderType == SenderTypeOfDefault || tempModel.senderType == SenderTypeOfShare) {
        cell = [tableView dequeueReusableCellWithIdentifier:mxrBookSNSTableViewCell forIndexPath:indexPath];
        MXRBookSNSTableViewCell *aCell = (MXRBookSNSTableViewCell *)cell;
        aCell.belongViewtype = MXRBookSNSBelongViewtypeTopicView;
        model = (MXRSNSSendModel *)tempModel;
        aCell.delegate = self;
    }else{
        model = (MXRSNSTransmitModel *)tempModel;
        if ([(MXRSNSTransmitModel *)model orginalModel].srcMomentStatus == MXRSrcMomentStatusDelete) {
            cell = [tableView dequeueReusableCellWithIdentifier:mxrBookSNSDeleteForwardTableViewCell forIndexPath:indexPath];
            MXRBookSNSDeleteForwardTableViewCell *aCell = (MXRBookSNSDeleteForwardTableViewCell *)cell;
            aCell.belongViewtype = MXRBookSNSBelongViewtypeTopicView;
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:mxrBookSNSForwardTableViewCell forIndexPath:indexPath];
            MXRBookSNSForwardTableViewCell *aCell = (MXRBookSNSForwardTableViewCell *)cell;
            aCell.belongViewtype = MXRBookSNSBelongViewtypeTopicView;
            aCell.delegate = self;
        }
    }
    if([cell respondsToSelector:@selector(setModel:)]){
        [cell performSelector:@selector(setModel:) withObject:model];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configCell:(id)cell indexPath:(NSIndexPath *)indexPath{
    
    MXRSNSShareModel * model;
    model = [self.tableViewDataSourceArray objectAtIndex:indexPath.row];
    if ([(UITableViewCell *)cell respondsToSelector:@selector(setModel:)]) {
        [(UITableViewCell *)cell performSelector:@selector(setModel:) withObject:model];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.tableViewDataSourceArray.count == 0) {
        return 95.f;
    }
    return UITableViewAutomaticDimension;
    
//    NSString * strId;
//    MXRSNSShareModel * model;
//    CGFloat height;
//    model = [self.tableViewDataSourceArray objectAtIndex:indexPath.row];
//    if (model.senderType == SenderTypeOfDefault || model.senderType == SenderTypeOfShare) {
//        strId = mxrBookSNSTableViewCell;
//        height = [tableView fd_heightForCellWithIdentifier:strId configuration:^(id cell) {
//            [self configCell:cell indexPath:indexPath];
//        }];
//    }else if(model.senderType == SenderTypeOfTransmit){
//        if ([(MXRSNSTransmitModel *)model orginalModel].srcMomentStatus == MXRSrcMomentStatusDelete) {
//            strId = mxrBookSNSDeleteForwardTableViewCell;
//        }else{
//            strId = mxrBookSNSForwardTableViewCell;
//        }
//        height = [tableView fd_heightForCellWithIdentifier:strId cacheByIndexPath:indexPath configuration:^(id cell) {
//            [self configCell:cell indexPath:indexPath];
//        }];
//    }else{
//        height = 95;
//    }
//
//    model.cellheight = height + 1;
//    return height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableViewDataSourceArray.count == 0) {
        return 95.f;
    }
    return SCREEN_HEIGHT_DEVICE;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableViewDataSourceArray && self.tableViewDataSourceArray.count != 0) {
        MXRBookSNSDetailViewController * vc = [[MXRBookSNSDetailViewController alloc] initWithModel:(MXRSNSShareModel *)[self.tableViewDataSourceArray objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tableViewDataSourceArray.count == 0) {
        return self.noSNSDataReloadCount;
    }
    return self.tableViewDataSourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return headViewHigh;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    __block UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, headViewHigh * IPHONE6_SCREEN_WIDTH_SCALE)];
    view.contentMode = UIViewContentModeScaleAspectFit;
    [view sd_setImageWithURL:[NSURL URLWithString:p_topicModel.picUrl] placeholderImage:MXRIMAGE(@"img_bookSNS_topicPlaceholder") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            UIImage * t_img = [UIImage imageCompressForSize:image targetSize:CGSizeMake(SCREEN_WIDTH_DEVICE, headViewHigh)];
            if (t_img){
                view.image = t_img;
            }
        }
    }];
    UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, headViewHigh)];
    centerImageView.image = MXRIMAGE(@"img_bookSNS_bannerShadow");
    [view addSubview:centerImageView];
    CGFloat headTitleWidth = SCREEN_WIDTH_DEVICE - 30;
    if (p_topicModel) {
        NSString *aName = p_topicModel.name;
        self.p_topicName = aName;
        UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headTitleWidth, upLabelHigh)];
        upLabel.textColor = [UIColor whiteColor];
        upLabel.textAlignment = NSTextAlignmentCenter;
        upLabel.text = aName;
        upLabel.numberOfLines = 2;
        upLabel.center = centerImageView.center;
        [centerImageView addSubview:upLabel];
        CGFloat aNameWidth = [NSString caculateText:aName andTextLabelSize:CGSizeMake(CGFLOAT_MAX,upLabelHigh) andFont:MXRFONT_20 andParagraphStyle:[NSMutableParagraphStyle new]].width;
        if (aNameWidth >=  headTitleWidth) {
            upLabel.font = [UIFont systemFontOfSize:14];
        }else{
            upLabel.font = [UIFont systemFontOfSize:20];
        }
        UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(upLabel.frame), CGRectGetMaxY(upLabel.frame) + 20, headTitleWidth, downLabelHigh)];
        downLabel.textColor = [UIColor whiteColor];
        downLabel.textAlignment = NSTextAlignmentCenter;
        downLabel.font = [UIFont systemFontOfSize:12];
        if (p_topicModel.publishDynamicNum.length == 0) {
            p_topicModel.publishDynamicNum = @"0";
        }
        
        downLabel.text = [NSString stringWithFormat:@"%@%@",p_topicModel.publishDynamicNum,MXRLocalizedString(@"PerpsonsJoin", @"条动态")];
        CGRect downLabelF = downLabel.frame;
        downLabelF.origin.y = downLabelF.origin.y - downLabelHigh/2;
        downLabel.frame = downLabelF;
        [centerImageView addSubview:downLabel];
    }
    return view;
}

#pragma mark - 悬浮球
/**
 扭蛋功能 5.11.0 by minjin.lin
 */
- (void)showCapsuleToysTopicName:(NSString *)name{
    if ([name isEqualToString:@"#我的扭蛋#"]) {
        __weak __typeof(self) weakSelf = self;
        [MXRGlobalUtil checkIsInReview:^(BOOL isReview) {
            __strong __typeof(self) strongSelf = weakSelf;
            if (!strongSelf) return;
            if (!isReview) {
                [self setupCapsuleToys];
            }
        }];
    }else{
        DLOG(@"%@",name);
    }
}
- (void)setupCapsuleToys{
    
//    [MXRHomeActivityNetworkManager checkEggActivityStatusSuccess:^(MXRHomeEggActivityModel *model) {
//        
//        if (model.status != 0 || model.icon == nil) {
//            return ;
//        }
//        //        NSLog(@">>>>>>> %@", model.icon);
//        NSString * diskCachePath = [NSFileManager mar_getCacheDirectoryForFile:@"mxrimageCache"];
//        //如果目录imageCache不存在，创建目录
//        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]) {
//            NSError *error=nil;
//            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:&error];
//        }
//        DLOG(@"--paths:%@",diskCachePath);
//        NSString *url = autoString(model.icon);
//        NSString *key = [url mar_md5String];
//        NSString *imagePath = [diskCachePath stringByAppendingPathComponent:key];
//        
//        BOOL isDirectory = NO;
//        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:&isDirectory];
//        if (isExist && !isDirectory) {
//            UIImage *resultImage = [UIImage imageWithContentsOfFile:imagePath];
//            
//            [self setupCapsuleToysWithImage:resultImage];
//        }
//        else{
//            [self downloadCapsuleToysImageWithIcon:autoString(model.icon) ImagePath:imagePath];
//        }
//    } Failure:^(id errMsg) {
//        
//    }];
}

/**
 第一次加载图片并保存key值到沙盒中
 */
- (void)downloadCapsuleToysImageWithIcon:(NSString*)urlStr ImagePath:(NSString*)imagePath
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *iconUrl = [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        NSData *data = [NSData dataWithContentsOfURL:iconUrl];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            NSData * imageData = UIImagePNGRepresentation(image);
            [imageData writeToFile:imagePath atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupCapsuleToysWithImage:image];
            });
        }
    });
}

- (void)setupCapsuleToysWithImage:(UIImage*)image{
    
    CGSize size = image.size;
    CGSize ballSize = CGSizeMake(80, 80/size.width*size.height);
    CGFloat margin = 16.f;
    CGFloat bottomMargin = 190;
    if (IS_iPhoneX_Device()) {
        bottomMargin = IPHONEX_SAFEAREA_INSETS_PORTRAIT.bottom + bottomMargin;
    }
//    MXRSuspendedBall *ball = [[MXRSuspendedBall alloc]initWithFrame:CGRectMake(SCREEN_WIDTH_DEVICE - margin - ballSize.width, SCREEN_HEIGHT_DEVICE - bottomMargin - ballSize.height, ballSize.width, ballSize.height)];
//    ball.berthImage = image;
//    
//    ball.block = ^(MXRSuspendedBall * _Nonnull ball) {
//        
//        MXRCapsuleToysWebView *web = [[MXRCapsuleToysWebView alloc] init];
//        NSString *jumpUrl = ServiceURL_CapsuleToys_WEB_URL;
//        web.e_urlString = jumpUrl;
//        web.forceLogin = NO;
//        web.mxr_preferredNavigationBarHidden = YES;
//        web.showBackBtn = NO;
//        web.enablePopGestureRecognizer = YES;
//        [self.navigationController pushViewController:web animated:YES];
//    };
//    
//    [ball showInView:self.view];
}

@end
