//
//  MXRBookSNSDetailViewController.m
//  huashida_home
//
//  Created by shuai.wang on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//
#import "MXRBookSNSDetailViewController.h"
#import "MXRBookSNSDetailTableViewCell.h"
#import "MXRBookSNSDetailFootView.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "MXRSNSSendStateViewController.h"
#import "MXRBookSNSTableViewCell.h"
#import "MXRBookSNSDetailController.h"

#import "MXRBookSNSDetailCommentListModel.h"
#import "MXRNavigationViewController.h"
//#import "MXRPromptView.h"
#import "MXRCopySysytemActionSheet.h"
#import "MXRBookSNSDetailManager.h"
#import "MXRSNSShareModel.h"
#import "MXRBookSNSPraiseListModel.h"
//#import "MXRLoginVC.h"
//#import "AppDelegate.h"
#import "MXRDynamicHasDeleteView.h"
#import "MXRBookSNSModelProxy.h"
#import "NSString+Ex.h"
#import "MXRBookSNSDeleteForwardTableViewCell.h"
#import "MXRBookSNSMomentStatusNoUploadManager.h"
#import "MXRBookSNSLoadDataGifRefreshFooter.h"
#import "CacheData.h"
#import "GlobalFunction.h"
#import "MXRBookSNSController.h"
//#import "UITableView+FDTemplateLayoutCell.h"
#import "MXRSNSCommentView.h"
#import "MXRBookSNSForwardTableViewCell.h"
#import "GlobalBusyFlag.h"
//#import "MXRPhoneBandelDetailViewController.h"
#import "MXRBookSNSDetailModel.h"

#define HAS_DELETE_DYNAMIC @"hasDeleteDynamic"
#define FootViewXIB @"MXRBookSNSDetailFootView"
#define MXRBookSNSDetailXIB @"MXRBookSNSDetailTableViewCell"
#define mxrBookSNSTableViewCell @"MXRBookSNSTableViewCell"
#define mxrBookSNSForwardTableViewCell @"MXRBookSNSForwardTableViewCell"
#define mxrBookSNSDeleteForwardTableViewCell @"MXRBookSNSDeleteForwardTableViewCell"
#define HAS_DELETE_DYNAMIC_WHEN_COMMENT @"HAS_DELETE_DYNAMIC_WHEN_Comment"
#define HAS_DELETE_DYNAMIC_WHEN_REPLY_COMMENT @"HAS_DELETE_DYNAMIC_WHEN_REPLY_COMMENT"

#define Indentifier @"cell"
#define KNotificationNoMoreData @"NoMoreData"
#define ListModel @"listModel"
#define MomoemtModel @"momentModel"

#define FootView_Height 41.0*SCREEN_WIDTH_DEVICE/320
#define Section_Height 45
#define Zero_Height 0.01
#define BottomHeight 49

//图片
#define Praise_SNSDeatil_sel @"btn_bookSNS_unlike"
#define Praise_SNSDeatil @"btn_bookSNS_like_select"

static NSString *cellIndent = @"indentifier";
static NSString *forwardcellIndent = @"forwardindentifier";
static NSString *deleteForwardcellIndent = @"deleteForwardcellIndent";
@interface MXRBookSNSDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MXRCopySysytemActionSheetDelegate,UITextFieldDelegate,MXRBookSNSTableViewCellDelegate,MXRBookSNSForwardTableViewCellDelegate>

@property(nonatomic,strong)UITableView *tabView;
@property(nonatomic,strong)UILabel *totalCountLable;
@property(nonatomic,strong)MXRSNSCommentView *commentView;
@property(nonatomic,strong)MXRBookSNSDetailFootView *footView;
@property(nonatomic,strong)MXRCopySysytemActionSheet *confirmSheet;    //提示弹框
@property(nonatomic,strong)MXRCopySysytemActionSheet *reportSheetNew;   //举报弹框
//@property(nonatomic,strong)MXRPromptView *promptAlertView;

@property(nonatomic,strong)MXRBookSNSDetailModel *bookSNSDetailModel;    //动态的评论数据模型
@property(nonatomic,strong)MXRBookSNSPraiseModel *praiseModel;     //   动态的点赞数据模型

@property(nonatomic,assign)BOOL isMySelfComment;
@property(nonatomic,assign)BOOL isReplyComment;
@property(nonatomic,assign)BOOL keyboardIsShow;
@property(nonatomic,assign)BOOL reportSheet;
@property(nonatomic,copy)NSString *cacheTextFileText;
@property(nonatomic,strong)UITapGestureRecognizer * tap;  //添加手势(取消键盘第一响应)
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSIndexPath *index;
@property(nonatomic,assign)NSInteger dynamicCommentCount;  //记录当前动态的评论,点赞 数量
@property(nonatomic,assign)NSInteger commentCount;        //评论数量
@property(nonatomic,strong)NSArray *reportArray;
@end

@implementation MXRBookSNSDetailViewController
// 关闭转屏
-(BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
-(instancetype)initWithModel:(MXRSNSShareModel *)model{
    if (self = [super init]) {
        _momentModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = MXRLocalizedString(@"MXRBookSNSDetailViewController_Title", @"动态详情");
   
    [self requestSNSDetailData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MXRClickUtil beginEvent:@"MengXiangQuanPage"];
    [MXRClickUtil beginLogPageView:@"MXRBookSNSDetailViewController"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MXRClickUtil endEvent:@"MengXiangQuanPage"];
    [MXRClickUtil endLogPageView:@"MXRBookSNSDetailViewController"];
}


-(void)requestSNSDetailData {
    @MXRWeakObj(self);
    if (![MXRDeviceUtil isReachable]) {
        [selfWeak showNetworkErrorWithRefreshCallback:^{
            if ([MXRDeviceUtil isReachable])
            {
                [selfWeak addViewForWindow];
            }
        }];
        return;
    }
    [selfWeak addViewForWindow];
}

-(void)addViewForWindow{
    [self.footView removeFromSuperview];
    [self addFootView];  //重新渲染
    [self reloadBookSNSPraiseListCell];
    [self addTableView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self addNotification];
    [self.view addSubview:self.commentView];
    self.page = 1; //首次加载第一页
    [self requestSNSDetailDataWithPage:self.page];
    
}

-(void)requestSNSDetailDataWithPage:(NSInteger)page {
    @MXRWeakObj(self);
    
    [[MXRBookSNSDetailController getInstance] requestBookSNSDetailDataWithPage:page dynamicId:self.momentModel.momentId uid:MAIN_USERID withCallBack:^(BOOL isOk ,MXRBookSNSDetailModel *bookSNSDetailModel) {
        if (isOk) {
            if (selfWeak.bookSNSDetailModel) {
                [selfWeak.bookSNSDetailModel.commentsModel.list addObjectsFromArray:bookSNSDetailModel.commentsModel.list];
            }else{
                selfWeak.bookSNSDetailModel = bookSNSDetailModel;
            }
            
            if (selfWeak.tabView.mj_footer.state == MJRefreshStateRefreshing) {
                [selfWeak.tabView.mj_footer endRefreshing];
            }
                
                if (selfWeak.bookSNSDetailModel.dynamicModel.srcMomentStatus == OriginalCommentStateDelete) {
                    if (selfWeak.momentModel.senderType == SenderTypeOfTransmit) {
                        [(MXRSNSTransmitModel *)selfWeak.momentModel orginalModelIsDelete];
                    }
                    /*      动态已删除,评论按钮变灰色     */
                    selfWeak.footView.retweetButton.enabled = NO;
                    [selfWeak.footView.retweetButton setBackgroundImage:MXRIMAGE(@"btn_bookSNS_forward") forState:UIControlStateNormal];
                    selfWeak.footView.retweetButton.alpha = 0.4;
                    [selfWeak.view addSubview:selfWeak.footView];
                    
                }else{
                    [selfWeak.footView.retweetButton addTarget:selfWeak action:@selector(onRetweetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [selfWeak.view addSubview:selfWeak.footView];
                }
                [selfWeak.momentModel updataMomentCommentCount:selfWeak.bookSNSDetailModel.commentsModel.total];
                [selfWeak.momentModel updataMomentComment:[[MXRBookSNSDetailManager getInstance] conversionMXRBookSNSDetailCommentList:selfWeak.bookSNSDetailModel.commentsModel.list]];
                selfWeak.commentCount = selfWeak.bookSNSDetailModel.commentsModel.total;
            
            [selfWeak.tabView reloadData];
        }
    }];
}
-(void)refreshingFooterData {
    self.page += 1;
    [self requestSNSDetailDataWithPage:self.page];
}
-(void)endRefresh{
    self.tabView.mj_footer.state = MJRefreshStateNoMoreData;
    self.tabView.mj_footer.hidden = YES;
    self.tabView.mj_footer = nil;

}
-(void)maskViewTapClick:(UITapGestureRecognizer *)gesture{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    [self textFileResignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self textFileResignFirstResponder];
}

-(void)textFileResignFirstResponder{
    self.index = nil;
    [self.commentView.textField resignFirstResponder];
    self.commentView.textField.placeholder = MXRLocalizedString(@"Comment_Please_InputComment_Content", @"请输入评论内容");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}


#pragma mark - 通知方法处理
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRefresh) name:KNotificationNoMoreData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTabbar) name:Notification_MXRBookSNS_ShowTabbar object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dynamicCommentHasDelete) name:HAS_DELETE_DYNAMIC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasDeleteDynamicWhenCreateComment:) name:HAS_DELETE_DYNAMIC_WHEN_COMMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasDeleteDynamicWhenReplyComment:) name:HAS_DELETE_DYNAMIC_WHEN_REPLY_COMMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBookSNSData:) name:Notification_ApplicationWillTerminate object:nil];
    
}
-(void)hiddenTabbar{
    [self.tabBarController.tabBar setHidden:YES];
}
-(void)hasDeleteDynamicWhenCreateComment:(NSNotification *)notification{
    [self.bookSNSDetailModel.commentsModel.list insertObject:[[MXRBookSNSDetailManager getInstance] cacheCreateCommentModelWithContent:self.cacheTextFileText withCommentListModel:self.momentModel withListModelFuncType:ListModelFuncOfCreateComment] atIndex:0];
    [self addComment];
    [self reloadSectionToTop];
}
-(void)hasDeleteDynamicWhenReplyComment:(NSNotification *)notification{
    [self.bookSNSDetailModel.commentsModel.list insertObject:[[MXRBookSNSDetailManager getInstance] cacheReplyCommentModelWithContent:self.cacheTextFileText withCommentListModel:self.bookSNSDetailModel.commentsModel.list[self.index.row] withListModelFuncType:ListModelFuncOfReplyComment] atIndex:0];
    [self addComment];
    [self reloadSectionToTop];
}
-(void)reloadBookSNSPraiseListCellWhenHaveAddPraiseChangeCommentData {
 
    for (MXRBookSNSPraiseListModel *praise in self.praiseModel.list) {
        if ([praise.userName isEqualToString:[UserInformation modelInformation].userNickName]) {
            return;
        }
    }
    [self.praiseModel.list insertObject:[[MXRBookSNSDetailManager getInstance] cacheDynamicPraiseInfoRefrashWithModel:self.momentModel] atIndex:0];
    [self.tabView reloadData];
}

-(void)reloadBookSNSPraiseListCellWhenHaveCanclePraiseChangeCommentData {
    
    if (self.praiseModel.list.count>0) {
        NSInteger i = 0;
        for (MXRBookSNSPraiseListModel *model in self.praiseModel.list) {
            i++;
            if (model.userId == [MAIN_USERID integerValue]) {
                break;
            }
        }
        NSMutableArray *arrayPraise = [NSMutableArray arrayWithArray:self.praiseModel.list];
        for (MXRBookSNSPraiseListModel *praise in self.praiseModel.list) {
            if ([praise.userName isEqualToString:[UserInformation modelInformation].userNickName]) {
                [arrayPraise removeObjectAtIndex:i-1];
            }
        }
        self.praiseModel.list = arrayPraise;
    }
}

-(void)updateDynamicPraise {
    for (MXRBookSNSPraiseListModel *model in self.praiseModel.list) {
        if (model.userId == [MAIN_USERID integerValue]) {
            [self.momentModel LikeMoment];
            break;
        }else{
            [self.momentModel cancleLikeMoment];
        }
    }
    if (self.praiseModel.hasPraise) {
        [self.footView.praiseButton setBackgroundImage:MXRIMAGE(Praise_SNSDeatil_sel) forState:UIControlStateNormal];
    }else{
        [self.footView.praiseButton setBackgroundImage:MXRIMAGE(Praise_SNSDeatil) forState:UIControlStateNormal];
    }
}

-(void)reloadBookSNSPraiseListCell{
    @MXRWeakObj(self);
    [[MXRBookSNSDetailController getInstance] requestBookSNSPraiseListWithDynamicId:selfWeak.momentModel.momentId uid:selfWeak.momentModel.senderId page:1 WithCallBack:^(BOOL isOk,MXRServerStatus status,MXRBookSNSPraiseModel *model) {
        if (isOk) {
            selfWeak.praiseModel = model;
            if (selfWeak.praiseModel.list.count>0) {
                selfWeak.dynamicCommentCount = selfWeak.praiseModel.total;
                [selfWeak.momentModel updataMomentLikeCount:selfWeak.dynamicCommentCount];
                [selfWeak updateDynamicPraise];
            }
            else{
                selfWeak.dynamicCommentCount = 0;
                [selfWeak.momentModel updataMomentLikeCount:selfWeak.dynamicCommentCount];
                [selfWeak.momentModel cancleLikeMoment];
            }
            
        }else{
            selfWeak.praiseModel = [[MXRBookSNSPraiseModel alloc] initWithDictionary:@{}];  //当前动态没有赞时服务会报错
            selfWeak.dynamicCommentCount = 0;
            [selfWeak.momentModel updataMomentLikeCount:selfWeak.dynamicCommentCount];
            [selfWeak.momentModel cancleLikeMoment];
            [selfWeak.footView.praiseButton setBackgroundImage:MXRIMAGE(Praise_SNSDeatil) forState:UIControlStateNormal];
        }
        [selfWeak.tabView reloadData];
    }];
}

-(void)dynamicCommentHasDelete {
    MXRDynamicHasDeleteView *hasDeleteDynamicView = [[[NSBundle mainBundle] loadNibNamed:@"MXRDynamicHasDeleteView" owner:nil options:nil] lastObject];
    hasDeleteDynamicView.frame =[UIScreen mainScreen].bounds;
    hasDeleteDynamicView.backgroundColor = RGB(249, 249, 249);
    [self.view addSubview:hasDeleteDynamicView];

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:self.momentModel.momentId ,@"UserHandleMomentID",@1,@"UserHandleMomentType",@1, @"UserHandleMomentBelongViweType",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_UserHandleMoment object:dict];
}

-(UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTapClick:)];
    }
    return _tap;
}

-(void)KeyboardShow:(NSNotification *)notify{
    self.keyboardIsShow = YES;
    [self keyboardChange:notify isKeyboardHide:NO];
    [self.view addGestureRecognizer:self.tap];
}
-(void)keyboardHide:(NSNotification *)notify{
    self.keyboardIsShow = NO;
    [self keyboardChange:notify isKeyboardHide:YES];
    [self.view removeGestureRecognizer:self.tap];
}
-(void)keyboardChange:(NSNotification *)notify isKeyboardHide:(BOOL)isHide{
    NSDictionary *dicUseInfo = notify.userInfo;
    CGRect rect = [dicUseInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect temp = self.commentView.frame;
    if (isHide == YES) {
        temp.origin.y = rect.origin.y-TOP_BAR_HEIGHT;
    }
    else{
        temp.origin.y = rect.origin.y - BottomHeight-TOP_BAR_HEIGHT;
    }
    self.commentView.frame = temp;
    
    CGFloat maxY=CGRectGetMaxY(self.commentView.frame);
    CGRect tempTable = self.tabView.frame;
    if (isHide == YES) {
        tempTable.size.height = maxY-BottomHeight-FootView_Height;
    }
    else {
        tempTable.size.height = maxY-BottomHeight;
    }
    @MXRWeakObj(self);
    [UIView performWithoutAnimation:^{
        selfWeak.tabView.frame = tempTable;
        [selfWeak.tabView layoutIfNeeded];
        if (selfWeak.keyboardIsShow) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (selfWeak.index.row < selfWeak.bookSNSDetailModel.commentsModel.list.count) {
                    [selfWeak.tabView scrollToRowAtIndexPath:selfWeak.index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            });
        }
    }];
}

//-(void)gotoBookDetailBefore:(NSNotification *)sender{
//    self.view.userInteractionEnabled = NO;
//}
//-(void)gotoBookDetailAfter:(NSNotification *)sender{
//    self.view.userInteractionEnabled = YES;
//}
-(void)updateBookSNSData:(NSNotification *)sender{
    
    [[MXRBookSNSModelProxy getInstance] deleteMomentWithId:self.momentModel.momentId];
    [[MXRBookSNSModelProxy getInstance] creatCacheData];
}


#pragma mark - 视图布局
//  总评论数
-(UILabel *)totalCountLable {
    if (!_totalCountLable) {
        _totalCountLable = [[UILabel alloc] init];
        _totalCountLable.font = MXRFONT_14;
        _totalCountLable.textColor = MXRCOLOR_999999;
    }
    return _totalCountLable;
}
-(void)addTableView{
    if (self.tabView) {
        return;
    }
    self.tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE-FootView_Height-TOP_BAR_HEIGHT) style:UITableViewStylePlain];
    self.tabView.delegate =self;
    self.tabView.dataSource = self;
    self.tabView.backgroundColor = [UIColor whiteColor];
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.tabView.estimatedSectionHeaderHeight = 0;
    self.tabView.estimatedSectionFooterHeight = 0;


    MXRBookSNSLoadDataGifRefreshFooter * t_footer = [MXRBookSNSLoadDataGifRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshingFooterData)];
    t_footer.refreshingTitleHidden = YES;
    [t_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.tabView.mj_footer = t_footer;

    
    [self.tabView registerNib:[UINib nibWithNibName:mxrBookSNSTableViewCell bundle:nil] forCellReuseIdentifier:mxrBookSNSTableViewCell];
    [self.tabView registerNib:[UINib nibWithNibName:mxrBookSNSForwardTableViewCell  bundle:nil] forCellReuseIdentifier:mxrBookSNSForwardTableViewCell];
    [self.tabView registerNib:[UINib nibWithNibName:mxrBookSNSDeleteForwardTableViewCell  bundle:nil] forCellReuseIdentifier:mxrBookSNSDeleteForwardTableViewCell];
    [self.tabView registerNib:[UINib nibWithNibName:MXRBookSNSDetailXIB bundle:nil] forCellReuseIdentifier:Indentifier];
    [self.view addSubview:self.tabView];
}


-(MXRSNSCommentView *)commentView {
    if (!_commentView) {
        _commentView = [[NSBundle mainBundle] loadNibNamed:@"MXRSNSCommentView" owner:self options:nil].lastObject;
        _commentView.frame = CGRectMake(0, SCREEN_HEIGHT_DEVICE, SCREEN_WIDTH_DEVICE_ABSOLUTE, BottomHeight);
        [_commentView.senderButton addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
        _commentView.textField.delegate = self;
    }
    return _commentView;
}

-(void)addFootView{
    self.footView = [[[NSBundle mainBundle] loadNibNamed:FootViewXIB owner:nil options:nil] lastObject];
    self.footView.frame = CGRectMake(0, SCREEN_HEIGHT_DEVICE-FootView_Height-TOP_BAR_HEIGHT, SCREEN_WIDTH_DEVICE, FootView_Height);
    [self.footView.commentButton addTarget:self action:@selector(onCommentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footView.praiseButton addTarget:self action:@selector(onDynamicPraiseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.momentModel.hasPraised) {
        [self.footView.praiseButton setBackgroundImage:MXRIMAGE(Praise_SNSDeatil_sel) forState:UIControlStateNormal];
    }else{
        [self.footView.praiseButton setBackgroundImage:MXRIMAGE(Praise_SNSDeatil) forState:UIControlStateNormal];
    }
    [self.view addSubview:self.footView];
}


#pragma mark - #pragma mark - MXRPromptView  弹 框
//-(MXRPromptView *)promptAlertView{
//    if (!_promptAlertView) {
//        _promptAlertView = [[MXRPromptView alloc] initWithTitle:MXRLocalizedString(@"MXBManager_Prompt", @"提示") message:MXRLocalizedString(@"Comment_Delegate_Main_Content", @"是否删除该评论") delegate:self cancelButtonTitle:MXRLocalizedString(@"CANCEL", @"取消") otherButtonTitle:MXRLocalizedString(@"SURE", @"确定")];
//    }
//    return _promptAlertView;
//}
//
//-(void)promptView:(MXRPromptView*)promptView didSelectAtIndex:(NSUInteger)index {
//
//    if (index == 0) {
//        @MXRWeakObj(self);
//        if (selfWeak.bookSNSDetailModel.commentsModel.list.count>0) {
//            MXRBookSNSDetailCommentListModel * listModel = selfWeak.bookSNSDetailModel.commentsModel.list[self.index.row];
//            if (listModel.dataType == cacheDataType) {
//                for (MXRBookSNSDetailCommentListModel *commentModel in selfWeak.bookSNSDetailModel.commentsModel.list) {
//                    if (listModel.iD == commentModel.iD) {
//                        [[MXRBookSNSDetailManager getInstance].noNetCommentList removeObject:commentModel];
//                    }
//                }
//            }
//            [[MXRBookSNSDetailController getInstance] deleteCommentWithCid:listModel.iD dynamicId:listModel.dynamicId withCallBack:^(BOOL isOk) {
//                if (isOk == NO) {
//                    [[MXRBookSNSDetailManager getInstance] cacheDetailCommentDataForBookSNSManagerWithModel:[[MXRBookSNSDetailManager getInstance] cacheCommentModelWithContent:nil withCommentListModel:listModel withListModelFuncType:ListModelFuncOfDeleteComment]];
//                }
//                [selfWeak.momentModel updataMomentComment:[[MXRBookSNSDetailManager getInstance] conversionMXRBookSNSDetailCommentList:selfWeak.bookSNSDetailModel.commentsModel.list]];
//            }];
//            NSMutableArray *newCommentData = [NSMutableArray array];
//            [selfWeak.bookSNSDetailModel.commentsModel.list enumerateObjectsUsingBlock:^(MXRBookSNSDetailCommentListModel *comment, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (comment.srcId != listModel.iD && comment.iD != listModel.iD) {
//                    [newCommentData addObject:comment];
//                }else{
//
//                    [selfWeak deleteComment];
//                }
//            }];
//            selfWeak.bookSNSDetailModel.commentsModel.list = [NSMutableArray arrayWithArray:newCommentData];
//            [selfWeak.tabView reloadData];
//
//        }
//    }
//    self.promptAlertView = nil;
//}


#pragma mark - MXRCopySysytemActionSheet  弹 框
-(void)setTitleForConfirmSheet{
    if (self.isMySelfComment == YES)
    {
        _confirmSheet = [[MXRCopySysytemActionSheet alloc] initWithFrame:[UIScreen mainScreen].bounds  withTitle:nil withBtns:@[MXRLocalizedString(@"Comment_Reply", @"回复"),MXRLocalizedString(@"Delegate", @"删除")] withCancelBtn:MXRLocalizedString(@"MXRCommentTableView_Delete_Cancel",@"取消") withDelegate:self];
    }
    else{
        _confirmSheet = [[MXRCopySysytemActionSheet alloc] initWithFrame:[UIScreen mainScreen].bounds  withTitle:nil withBtns:@[MXRLocalizedString(@"Comment_Reply", @"回复"),MXRLocalizedString(@"Comment_Accusation", @"举报")] withCancelBtn:MXRLocalizedString(@"MXRCommentTableView_Delete_Cancel",@"取消") withDelegate:self];
    }
}

/*********   举报  **********/
-(MXRCopySysytemActionSheet*)reportSheetNew{
    if (!_reportSheetNew) {
        _reportSheetNew = [[MXRCopySysytemActionSheet alloc] initWithFrame:[UIScreen mainScreen].bounds withBtns:self.reportArray withCancelBtn:MXRLocalizedString(@"CANCEL", @"取消") withDelegate:self];
    }
    return _reportSheetNew;
}
-(NSArray *)reportArray{
    if (!_reportArray) {
        _reportArray = @[MXRLocalizedString(@"MXRCommentViewCon_Sex", @"色情"),MXRLocalizedString(@"MXRCommentViewCon_Adver", @"广告"),MXRLocalizedString(@"MXRCommentViewCon_Rev", @"反动"),MXRLocalizedString(@"MXRCommentViewCon_Vio", @"暴力"),MXRLocalizedString(@"MXRCommentViewCon_Other",@"其他")];
    }
    return _reportArray;
}
-(void)actionSheetNew:(MXRCopySysytemActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    @MXRWeakObj(self);
    if (self.reportSheet) {
        if (buttonIndex<5) {
            MXRBookSNSDetailCommentListModel *listModel = nil;
            if (selfWeak.bookSNSDetailModel.commentsModel.list.count>0) {
                listModel = selfWeak.bookSNSDetailModel.commentsModel.list[self.index.row];
            }
            [[MXRBookSNSDetailController getInstance] reportCommentWithReportId:listModel.iD reportReason:_reportArray[buttonIndex] withCallBack:^(BOOL isOk) {
                if (isOk) {
                    [MXRConstant showAlert:MXRLocalizedString(@"Comment_Report_Success", @"举报成功") andShowTime:1.0f];
                }else{
                    [MXRConstant showAlert:MXRLocalizedString(@"Comment_Report_Success", @"举报成功") andShowTime:1.0f];
                    [[MXRBookSNSDetailManager getInstance] cacheDetailCommentDataForBookSNSManagerWithModel:[[MXRBookSNSDetailManager getInstance] cacheReportCommentModelWithContent:selfWeak.reportArray[buttonIndex] withCommentListModel:listModel withListModelFuncType:ListModelFuncOfSendReportComment]];
                }
                [selfWeak.bookSNSDetailModel.commentsModel.list removeObjectAtIndex:selfWeak.index.row];
                [selfWeak.tabView reloadData];
                [selfWeak deleteComment];
                selfWeak.index = nil;
            }];
        }
        self.reportSheet = NO;
    }
    else{
        if (buttonIndex== 0){
            if (![[UserInformation modelInformation] judgeWhetherShowedBandlePrompt]) {
                return;
            }
            [self.commentView.textField becomeFirstResponder];
            MXRBookSNSDetailCommentListModel *listModel = nil;
            if (selfWeak.bookSNSDetailModel.commentsModel.list>0) {
                listModel = selfWeak.bookSNSDetailModel.commentsModel.list[self.index.row];
            }
            if (self.isReplyComment) {
                self.commentView.textField.placeholder = [NSString stringWithFormat:@"%@: %@",MXRLocalizedString(@"Comment_Reply", @"回复"),listModel.userName];
            }
        }
        if (buttonIndex== 1) {
            if (_isMySelfComment) {
//                [self.promptAlertView showInLastViewController];
            }
            else{
                [self.reportSheetNew show];
                self.reportSheet = YES;
            }
        }
    }
    self.confirmSheet = nil;
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else {
        return self.bookSNSDetailModel.commentsModel.list.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return Zero_Height;
    }
    else {
        if (self.bookSNSDetailModel.commentsModel.list.count>0) {
            return Section_Height;
        }else{
            CGFloat section_Height_No_Comment = 180;
            return section_Height_No_Comment;
        }
    }
}

- (void)configCell:(id)cell indexPath:(NSIndexPath *)indexPath{
    
    MXRSNSShareModel * model;
    model = self.momentModel;
    if ([(UITableViewCell *)cell respondsToSelector:@selector(setIsSNSDetailView:)]) {
        [(UITableViewCell *)cell performSelector:@selector(setIsSNSDetailView:) withObject:@1];
    }
    if ([(UITableViewCell *)cell respondsToSelector:@selector(setModel:)]) {
        [(UITableViewCell *)cell performSelector:@selector(setModel:) withObject:model];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    CGFloat separateLineHeight = 0.5;
    CGFloat spaceWidth = 12.f;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, Section_Height)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *topSeparate = [[UIView alloc] initWithFrame:CGRectMake(spaceWidth, 0, SCREEN_WIDTH_DEVICE-(spaceWidth*2), separateLineHeight)];
    topSeparate.backgroundColor = MXRCOLOR_CCCCCC;
    UIView *bottomSeparate = [[UIView alloc] initWithFrame:CGRectMake(spaceWidth, headerView.frame.size.height-separateLineHeight, SCREEN_WIDTH_DEVICE-(spaceWidth*2), separateLineHeight)];
    bottomSeparate.backgroundColor = MXRCOLOR_CCCCCC;
    [headerView addSubview:topSeparate];
    [headerView addSubview:bottomSeparate];
    UILabel *sectionLable = [[UILabel alloc] init];
    sectionLable.frame = CGRectMake(15, separateLineHeight, [NSString caculateText:MXRLocalizedString(@"MXRBookSNSDetailVC_Section_Lable", @"最新评论") andTextLabelSize:CGSizeMake(200,50) andFont:MXRFONT_15].width, headerView.frame.size.height-(2*separateLineHeight));
    sectionLable.text = MXRLocalizedString(@"MXRBookSNSDetailVC_Section_Lable", @"最新评论");
    sectionLable.font = [UIFont fontWithName:@"System Medium" size:15.0];
    if (self.bookSNSDetailModel.commentsModel.list.count > 0) {
        self.totalCountLable.text = [NSString stringWithFormat:@"(%ld%@)",self.commentCount,MXRLocalizedString(@"MXRSNSDetail_item", @"条")];
    }else{
        self.totalCountLable.text = @"";
    }
    
    
    sectionLable.textColor = MXRCOLOR_333333;
    sectionLable.font = MXRFONT_15;
    [headerView addSubview:sectionLable];
    [headerView addSubview:self.totalCountLable];
    [self.totalCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sectionLable.mas_right).offset(10);
        make.top.mas_equalTo(sectionLable.mas_top).offset(separateLineHeight);
        make.bottom.mas_equalTo(sectionLable.mas_bottom).offset(-separateLineHeight);
        make.right.mas_equalTo(headerView.mas_right).offset(-10);
    }];
    
    if (self.bookSNSDetailModel.commentsModel.list.count>0) {
        return headerView;
    }else{
        UILabel *noComment = [[UILabel alloc] init];
        noComment.frame = CGRectMake(0, 90, headerView.frame.size.width, 30);
        noComment.backgroundColor = [UIColor whiteColor];
        noComment.text = MXRLocalizedString(@"MXRBookSNSDetailVC_Section_NO_Comment", @"暂无评论");
        noComment.textColor = MXRCOLOR_2FB8E2;
        noComment.textAlignment = NSTextAlignmentCenter;
        noComment.font = MXRFONT_14;
        [headerView addSubview:noComment];

        return headerView;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (self.momentModel.senderType == SenderTypeOfDefault || self.momentModel.senderType == SenderTypeOfShare) {
               MXRBookSNSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mxrBookSNSTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.isSNSDetailView = @1;
            cell.belongViewtype = MXRBookSNSBelongViewtypeMomentDetail;
            cell.delegate = self;
            cell.praiseModel = self.praiseModel;
            if([cell respondsToSelector:@selector(setModel:)]){
                [cell performSelector:@selector(setModel:) withObject:self.momentModel];
            }
            return cell;
        }else if(self.momentModel.senderType == SenderTypeOfTransmit){
            if ([(MXRSNSTransmitModel *)self.momentModel orginalModel].srcMomentStatus == MXRSrcMomentStatusDelete) {
                 MXRBookSNSDeleteForwardTableViewCell * deleteCell = [tableView dequeueReusableCellWithIdentifier:mxrBookSNSDeleteForwardTableViewCell forIndexPath:indexPath];
                deleteCell.selectionStyle = UITableViewCellSelectionStyleNone;
                deleteCell.isSNSDetailView = @1;
                deleteCell.belongViewtype = MXRBookSNSBelongViewtypeMomentDetail;
                deleteCell.praiseModel = self.praiseModel;
                if([deleteCell respondsToSelector:@selector(setModel:)]){
                    [deleteCell performSelector:@selector(setModel:) withObject:self.momentModel];
                }
                
                return deleteCell;
            }else{
                MXRBookSNSForwardTableViewCell *forwardcell = [tableView dequeueReusableCellWithIdentifier:mxrBookSNSForwardTableViewCell forIndexPath:indexPath];
                forwardcell.selectionStyle = UITableViewCellSelectionStyleNone;
                forwardcell.isSNSDetailView = @1;
                forwardcell.belongViewtype = MXRBookSNSBelongViewtypeMomentDetail;
                forwardcell.delegate = self;
                forwardcell.praiseModel = self.praiseModel;
                if([forwardcell respondsToSelector:@selector(setModel:)]){
                    [forwardcell performSelector:@selector(setModel:) withObject:self.momentModel];
                }
                return forwardcell;
            }
        }
    }else {
        MXRBookSNSDetailTableViewCell *cellComment = [tableView dequeueReusableCellWithIdentifier:Indentifier forIndexPath:indexPath];
        cellComment.selectionStyle = UITableViewCellSelectionStyleNone;
        [cellComment.buttonPraise addTarget:self action:@selector(onButtonPraiseClick:) forControlEvents:UIControlEventTouchUpInside];
        cellComment.buttonPraise.tag = indexPath.row;
        
        MXRBookSNSDetailCommentListModel *listModel = nil;
        
        if (self.bookSNSDetailModel.commentsModel.list.count>indexPath.row) {
            listModel = self.bookSNSDetailModel.commentsModel.list[indexPath.row];
        }
        
        [cellComment addDataForCellWithModel:listModel];
        return cellComment;
    }
    return [[UITableViewCell alloc] init];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UserInformation modelInformation] checkIsLogin]) {
        self.isReplyComment = YES;
        MXRBookSNSDetailCommentListModel *listModel = nil;
        if (indexPath.section == 1)
        {
            self.index = indexPath;
            if (self.bookSNSDetailModel.commentsModel.list.count>0) {
                listModel = self.bookSNSDetailModel.commentsModel.list[indexPath.row];
            }
            if ([MAIN_USERID integerValue] == listModel.userId) {
                self.isMySelfComment = YES;
                [self setTitleForConfirmSheet];
                [self.confirmSheet show];
            }
            else{
                self.isMySelfComment = NO;
                [self setTitleForConfirmSheet];
                MXRBookSNSDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [UIView animateWithDuration:0.1 animations:^{
                    cell.backgroundColor = RGB(220, 220, 220);
                } completion:^(BOOL finished) {
                    cell.backgroundColor = [UIColor whiteColor];
                }];
                [self.confirmSheet show];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return SCREEN_HEIGHT_DEVICE;
    }else{
        return 100;
    }
}
#pragma mark - 底部的三个按钮
#pragma mark -评论
//评论按钮
- (void)onCommentButtonClick:(UIButton *)sender {
    [MXRClickUtil event:@"DreamCircle_Comment_Click"];
    [MXRClickUtil event:@"MengXiangQuanClick"];
    if (![[UserInformation modelInformation] checkIsLogin]) {
        return;
    }
    
    if (![[UserInformation modelInformation] judgeWhetherShowedBandlePrompt]) {
        return;
    }
    self.isReplyComment = NO;
    self.index = nil;
    [self.commentView.textField becomeFirstResponder];
}

#pragma mark 转发
-(void)onRetweetButtonClick:(UIButton *)sender {
    [MXRClickUtil event:@"MengXiangQuanClick"];
    [MXRClickUtil event:@"DreamCircle_Forwarding_Click"];
    if ([[UserInformation modelInformation] checkIsLogin]) {
        MXRSNSSendStateViewController *vc = [[MXRSNSSendStateViewController alloc] initWithModel:self.momentModel];
        MXRNavigationViewController *nav=[[MXRNavigationViewController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark 对动态点赞
-(void)onDynamicPraiseButtonClick:(UIButton *)sender {
    [MXRClickUtil event:@"MengXiangQuanClick"];
    [MXRClickUtil event:@"DreamCircle_Like_Click"];
    
    if (_momentModel.momentStatusType == MXRBookSNSMomentStatusTypeOnLocal || _momentModel.momentStatusType == MXRBookSNSMomentStatusTypeOnUpload) {
        return;
    }
    if (![[UserInformation modelInformation] checkIsLogin]) {
        return;
    }
    self.footView.praiseButton.enabled = NO;
    [self.momentModel likeBtnClick];
    @MXRWeakObj(self);
    if (_momentModel.hasPraised) {
        [self reloadBookSNSPraiseListCellWhenHaveAddPraiseChangeCommentData];
        // 点赞
        [[MXRBookSNSController getInstance] userLikeMomentWithMomentId:self.momentModel.momentId andHandleUserId:[UserInformation modelInformation].userID success:^(id result) {
            if ([(NSNumber *)result boolValue]) {

                [selfWeak.tabView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [selfWeak.footView.praiseButton setBackgroundImage:MXRIMAGE(Praise_SNSDeatil_sel) forState:UIControlStateNormal];
            }
            selfWeak.footView.praiseButton.enabled = YES;
        } failure:^(MXRServerStatus status, id result) {
            if (status == MXRServerStatusNetworkError || status == MXRServerStatusFail) {
                [[MXRBookSNSMomentStatusNoUploadManager getInstance] addLikeAndUnlikeAndDeleteAndUploadMomentDetailNoUploadModelWithUserHandleNoUploadStatusType:MXRBookSNSUserHandleNoUploadStatusTypeLikeBookSNSStatus andBookSNSMomentId:selfWeak.momentModel.momentId andHandleUserId:[UserInformation modelInformation].userID];

                [selfWeak.tabView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [selfWeak.footView.praiseButton setBackgroundImage:MXRIMAGE(Praise_SNSDeatil_sel) forState:UIControlStateNormal];
            }
            selfWeak.footView.praiseButton.enabled = YES;
        }];
    }else{
        // 取消赞
        [self reloadBookSNSPraiseListCellWhenHaveCanclePraiseChangeCommentData];
        [[MXRBookSNSController getInstance] userCancleLikeMomentWithMomentId:self.momentModel.momentId andHandleUserId:[UserInformation modelInformation].userID success:^(id result) {
            if ([(NSNumber *)result boolValue]) {


                [selfWeak.tabView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [selfWeak.footView.praiseButton setBackgroundImage:MXRIMAGE(Praise_SNSDeatil) forState:UIControlStateNormal];
                
            }
            selfWeak.footView.praiseButton.enabled = YES;
        } failure:^(MXRServerStatus status, id result) {
            if (status == MXRServerStatusNetworkError || status == MXRServerStatusFail) {
                [[MXRBookSNSMomentStatusNoUploadManager getInstance] addLikeAndUnlikeAndDeleteAndUploadMomentDetailNoUploadModelWithUserHandleNoUploadStatusType:MXRBookSNSUserHandleNoUploadStatusTypeCancleLikeBookSNSStatus andBookSNSMomentId:selfWeak.momentModel.momentId andHandleUserId:[UserInformation modelInformation].userID];


                [selfWeak.tabView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [selfWeak.footView.praiseButton setBackgroundImage:MXRIMAGE(Praise_SNSDeatil) forState:UIControlStateNormal];
            }
            selfWeak.footView.praiseButton.enabled = YES;
        }];
    }
}

#pragma mark -
#pragma mark 发布评论/回复评论
-(void)sendComment:(UIButton *)sender{
    /*********  首先判定输入内容是否为空    ********/
    self.cacheTextFileText = self.commentView.textField.text;
    if ([[self.commentView.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]){
        [MXRConstant showAlert:MXRLocalizedString(@"Comment_Please_InputComment_Content", @"请输入评论内容") andShowTime:1.0f];
        self.commentView.textField.text = @"";
        return;
    }

    if (self.isReplyComment == NO) {
        [self createNewCommentForDynamicWithMomentModel:self.momentModel];
    }else{
        if (self.bookSNSDetailModel.commentsModel.list.count>0) {
            MXRBookSNSDetailCommentListModel *listModel = self.bookSNSDetailModel.commentsModel.list[self.index.row];
            [self replyCommentForDynamicWithListModel:listModel];
        }
    }
}

/**
 添加新评论

 @param momentModel <#momentModel description#>
 */
-(void)createNewCommentForDynamicWithMomentModel:(MXRSNSShareModel * )momentModel {
    @MXRWeakObj(self);
    [[MXRBookSNSDetailController getInstance] createNewCommentForDynamicWithDyId:momentModel.momentId userId:MAIN_USERID userName:[NSString stringWithFormat:@"%@",[UserInformation modelInformation].userNickName] userLogo:[NSString stringWithFormat:@"%@",[UserInformation modelInformation].userImage] content:selfWeak.commentView.textField.text withCallBack:^(BOOL isOk, MXRBookSNSDetailCommentListModel *model) {
        if (!isOk) {
            MXRBookSNSDetailCommentListModel *cacheModel = [[MXRBookSNSDetailManager getInstance] cacheCreateCommentModelWithContent:selfWeak.cacheTextFileText withCommentListModel:momentModel withListModelFuncType:ListModelFuncOfCreateComment];
            //没网络下缓存评论
            
            [[MXRBookSNSDetailManager getInstance] cacheDetailCommentDataForBookSNSManagerWithModel:cacheModel];
            [selfWeak reorderCommentListWithModel:cacheModel];
        }else {
            [selfWeak reorderCommentListWithModel:model];
        }
       
        [selfWeak reloadSectionToTop];
        [selfWeak addComment];
        [MXRConstant showAlert:MXRLocalizedString(@"Comment_Reply_Success", @"评论成功") andShowTime:1.0f];
    }];
    [self.commentView.textField resignFirstResponder];
    self.commentView.textField.text = @"";
    self.isReplyComment = NO;
    [CacheData removeCacheData:MomoemtModel];
    [CacheData removeCacheData:ListModel];

}

/**
 回复评论

 @param listModel <#listModel description#>
 */
-(void)replyCommentForDynamicWithListModel:(MXRBookSNSDetailCommentListModel *)listModel {
    @MXRWeakObj(self);
    if (listModel.dataType == cacheDataType) {
        if (listModel.commentType == noNetWorkCreateComment) {
            [MXRConstant showAlert:MXRLocalizedString(@"Comment_Reply_Failed", @"评论失败") andShowTime:1.0f];
            [selfWeak.commentView.textField resignFirstResponder];
            selfWeak.commentView.textField.text = @"";
            selfWeak.isReplyComment = NO;
            return ;
        }
    }
    [[MXRBookSNSDetailController getInstance] replyCommentForDynamicWithDyId:selfWeak.momentModel.momentId userId:MAIN_USERID userName:[NSString stringWithFormat:@"%@",[UserInformation modelInformation].userNickName] userLogo:[NSString stringWithFormat:@"%@",[UserInformation modelInformation].userImage] content:selfWeak.commentView.textField.text srcUserId:listModel.userId srcUserName:listModel.userName srcContent:listModel.content srcId:listModel.iD withCallBack:^(BOOL isOk, MXRBookSNSDetailCommentListModel *model) {
        if (!isOk) {
            MXRBookSNSDetailCommentListModel *cacheModel =[[MXRBookSNSDetailManager getInstance] cacheReplyCommentModelWithContent:selfWeak.cacheTextFileText withCommentListModel:listModel withListModelFuncType:ListModelFuncOfReplyComment];
            //没网络下缓存回复评论
            [selfWeak reorderCommentListWithModel:cacheModel];
            [[MXRBookSNSDetailManager getInstance] cacheDetailCommentDataForBookSNSManagerWithModel:cacheModel];
        }else{
            [selfWeak reorderCommentListWithModel:model];
        }
        
        [selfWeak reloadSectionToTop];
        [selfWeak addComment];
        [MXRConstant showAlert:MXRLocalizedString(@"Comment_Reply_Success", @"评论成功") andShowTime:1.0f];
    }];
    [self.commentView.textField resignFirstResponder];
    self.commentView.textField.text = @"";
    self.isReplyComment = NO;
    [CacheData removeCacheData:MomoemtModel];
    [CacheData removeCacheData:ListModel];
 
}

/**
 评论完成后重新对评论排序
 5.9.1 version 通过后台设置置顶的评论永远在最上面
 @param model <#model description#>
 */
-(void)reorderCommentListWithModel:(MXRBookSNSDetailCommentListModel *)model {
    @MXRWeakObj(self);
    if (self.bookSNSDetailModel.commentsModel.list.count > 0) {
        [self.bookSNSDetailModel.commentsModel.list enumerateObjectsUsingBlock:^(MXRBookSNSDetailCommentListModel * commentModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (commentModel.sort == 0 || commentModel.sort == -1) {
                [selfWeak.bookSNSDetailModel.commentsModel.list insertObject:model atIndex:idx];
                *stop = YES;
            }
        }];
    }else{
        [selfWeak.bookSNSDetailModel.commentsModel.list insertObject:model atIndex:0];
    }
}

-(void)reloadSectionToTop{
    [self.tabView reloadData];
    [self.tabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
#pragma mark -对评论点赞/取消赞
-(void)onButtonPraiseClick:(UIButton *)sender {
    [MXRClickUtil event:@"MengXiangQuanClick"];
    if ([[UserInformation modelInformation] checkIsLogin]== NO) {
        return;
    }
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tabView indexPathForCell:cell];
    sender.enabled = NO;
    self.tabView.userInteractionEnabled = NO;
    @MXRWeakObj(self);
    MXRBookSNSDetailCommentListModel *listModel = nil;
    if (self.bookSNSDetailModel.commentsModel.list.count>0) {
        listModel = self.bookSNSDetailModel.commentsModel.list[sender.tag];
    }
    if (listModel.hasPraised == 0) {
        if (listModel.dataType == cacheDataType) {
            if (listModel.commentType == noNetWorkCreateComment) {
                [MXRConstant showAlert:MXRLocalizedString(@"MXRBookDetailCommCell_Praise_Fail", @"点赞失败") andShowTime:1.0f];
                sender.enabled = YES;
                selfWeak.tabView.userInteractionEnabled = YES;
                return ;
            }
        }
        [[MXRBookSNSDetailController getInstance] addPraiseForDynamicWithID:listModel.iD uid:[MAIN_USERID integerValue] dyId:listModel.dynamicId userName:[UserInformation modelInformation].userNickName userLogo:[UserInformation modelInformation].userImage withCallBack:^(BOOL isOk) {
            sender.enabled = YES;
            selfWeak.tabView.userInteractionEnabled = YES;
            if (!isOk) {
                
                [[MXRBookSNSDetailManager getInstance] cacheDetailCommentDataForBookSNSManagerWithModel:[[MXRBookSNSDetailManager getInstance] cacheCommentModelWithContent:nil withCommentListModel:listModel withListModelFuncType:ListModelFuncOfAddPreaseComment]];
            }
            [selfWeak.bookSNSDetailModel.commentsModel.list replaceObjectAtIndex:sender.tag withObject:[[MXRBookSNSDetailManager getInstance] cacheCommentModelWithContent:nil withCommentListModel:listModel withListModelFuncType:ListModelFuncOfAddPreaseComment]];

            [selfWeak.tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        MXRBookSNSDetailTableViewCell * cell = (MXRBookSNSDetailTableViewCell *)[[sender superview] superview];
        [cell showAddCountAnimationWithView:cell.praiseAnimotion];
    }
    else{
        [[MXRBookSNSDetailController getInstance] canclePraiseForDynamicWithID:listModel.iD uid:[MAIN_USERID integerValue] withCallBack:^(BOOL isOk) {
            sender.enabled = YES;
            selfWeak.tabView.userInteractionEnabled = YES;
            if (!isOk) {
                
                [[MXRBookSNSDetailManager getInstance] cacheDetailCommentDataForBookSNSManagerWithModel:[[MXRBookSNSDetailManager getInstance] cacheCommentModelWithContent:nil withCommentListModel:listModel withListModelFuncType:ListModelFuncOfCanclePreaseComment]];
            }
            [selfWeak.bookSNSDetailModel.commentsModel.list replaceObjectAtIndex:sender.tag withObject:[[MXRBookSNSDetailManager getInstance] cacheCommentModelWithContent:nil withCommentListModel:listModel withListModelFuncType:ListModelFuncOfCanclePreaseComment]];

            [selfWeak.tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
}


-(void)addComment {
    [self.momentModel addMomentComment];
    [self.momentModel updataMomentComment:[[MXRBookSNSDetailManager getInstance] conversionMXRBookSNSDetailCommentList:self.bookSNSDetailModel.commentsModel.list]];
    self.commentCount += 1;
}

-(void)deleteComment {
    [self.momentModel deleteMomentComment];
    [self.momentModel updataMomentComment:[[MXRBookSNSDetailManager getInstance] conversionMXRBookSNSDetailCommentList:self.bookSNSDetailModel.commentsModel.list]];
    self.commentCount -= 1;
}


#pragma mark - 预览状态下进行评论
- (void)commentSNSFromPreview {
    [self onCommentButtonClick:self.footView.commentButton];
}

#pragma mark - 预览下对动态进行点赞
- (void)praiseSNSFromPreview {
    [self onDynamicPraiseButtonClick:self.footView.praiseButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    DLOG_METHOD
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeAllCacheData];
}

-(void)removeAllCacheData {

    [[MXRBookSNSDetailManager getInstance] deleteAllObject];
    [CacheData removeCacheData:MomoemtModel];
    [CacheData removeCacheData:ListModel];
    if ([MXRBookSNSDetailManager getInstance].noNetCommentList.count>0) {
        for (MXRBookSNSDetailCommentListModel *listDodel in [MXRBookSNSDetailManager getInstance].noNetCommentList) {
            [[MXRBookSNSDetailManager getInstance] cacheDetailCommentDataForBookSNSManagerWithModel:listDodel];
            [[MXRBookSNSMomentStatusNoUploadManager getInstance] checkNeedUploadUserHandle];
        }
    }
}
@end
