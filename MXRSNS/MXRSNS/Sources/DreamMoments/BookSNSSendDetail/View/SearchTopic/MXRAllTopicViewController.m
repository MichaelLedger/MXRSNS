//
//  MXRAllTopicViewController.m
//  huashida_home
//
//  Created by lj on 16/10/10.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRAllTopicViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "MXRSearchTopicTableViewCell.h"
#import "MXRBookSNSSendDetailController.h"
//#import "MJDIYAutoFooter.h"
#import <MJRefreshFooter.h>
#import "MXRBookSNSSendDetailProxy.h"
#import "MXRSearchTopicViewController.h"
#import "MXRTopicMainViewController.h"
#import "MXRSearchTopicModel.h"
#import "GlobalFunction.h"
#import "MXRSearchTopicViewController.h"
#import "GlobalBusyFlag.h"
#import "Notifications.h"
#import "Masonry.h"
#define pageSize 20
#define MXRSearchTopicTableViewCell @"MXRSearchTopicTableViewCell"
#define CellIdentifier @"CellIdentifier"

@interface MXRAllTopicViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,MXRBookSNSTopicSelectDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UIView *searchTFDefaultView;
@property (assign, nonatomic) BOOL isEdit;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic)MXRSearchTopicViewController *searchTopicViewController;
@end

@implementation MXRAllTopicViewController
{
    MJRefreshFooter *_footer;
    NSInteger pageIndex;
    BOOL didLoadFooter;//判断是否 加载 footer 的标志位
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray new];
    MXRAdjustsScrollViewInsets_NO(self.tableView, self);
    didLoadFooter = NO;
    pageIndex = 1;
    [self configView];
    [self addobserver]; //添加通知
    [self loadData];//加载数据
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - 添加通知
-(void)addobserver
{    //当点击进入一个话题后，发现是空话题，那么这个时候 需要将这个列表中的该话题删除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeModel:) name:Notification_MXRBookSNS_TopicNoData object:nil];
}
#pragma mark 通知方法
#pragma mark - 删除模型
-(void)removeModel:(NSNotification*)noti
{
    @MXRWeakObj(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *str = autoString([noti.object objectForKey:@"TOPICID"]);
        NSInteger modelIndex = [[MXRBookSNSSendDetailProxy getInstance] removeModelWithKey:HotTopicArrayKey topicId:str];
        if (modelIndex>=selfWeak.dataArray.count) {
            return;
        }
        [selfWeak.dataArray removeObjectAtIndex:modelIndex];
        NSArray *array = @[[NSIndexPath indexPathForRow:modelIndex inSection:0]];
        [selfWeak.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationTop];
    });
}
#pragma mark - 界面相关
//显示网络错误
-(void)showNetErrorView
{
    @MXRWeakObj(self);
    [self showNetworkErrorWithRefreshCallback:^{
        [selfWeak loadData];
    }];
}
//隐藏网络错误
-(void)hidenNetErrorView
{
    [self hideNetworkErrorView];
}
//配置界面
-(void)configView
{
    self.title = MXRLocalizedString(@"MXRSearchTopicViewController_AllTopic", @"全部话题");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.leading.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
        make.trailing.mas_equalTo(self.view);
        
    }];
    if (![MXRDeviceUtil isReachable]) {
        [self showNetErrorView];
    }
}
//创建 上拉加载控件
-(void)createFooter{
    if (!_footer) {
        _footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//        _footer.timeLabel.hidden = YES;
        // 隐藏状态
//        _footer.label.hidden = YES;
    }
    self.tableView.mj_footer = _footer;
}
#pragma mark - 按钮操作
-(void)backAction:(id)sender
{
    [[MXRBookSNSSendDetailProxy getInstance] removecacheSearchTopicArray];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 工具方法
//加载数据
-(void)loadData
{
    if (![MXRDeviceUtil isReachable]) {
        return;
    }
    @MXRWeakObj(self);
    [[GlobalBusyFlag sharedInstance] showBusyFlagOnWindow];
    [[MXRBookSNSSendDetailController getInstance] getHotTopicWithPage:pageIndex WithPageSize:pageSize WithCallBack:^(BOOL isSuccess) {
        [[GlobalBusyFlag sharedInstance] hideBusyFlag];
        NSMutableArray *resultArray = [[MXRBookSNSSendDetailProxy getInstance] getOneSearchTopicArrayByKey:HotTopicArrayKey];
        if(resultArray)
        {
            selfWeak.dataArray = resultArray;
            [selfWeak.tableView reloadData];
//            if (selfWeak.tableView.contentSize.height<SCREEN_HEIGHT_DEVICE_ABSOLUTE) {
//                selfWeak.tableView.frame = CGRectMake(0, selfWeak.tableView.frame.origin.y, selfWeak.tableView.frame.size.width, [selfWeak tableViewContentHeight]);
//            }
//            selfWeak.tableView.contentOffset = CGPointMake(0, 41);
            [selfWeak hidenNetErrorView];
        }
        else if (resultArray == nil && _dataArray.count == 0)
        {
            [selfWeak showNetErrorView];
        }
    }];
}
//加载更多数据
-(void)loadMoreData{
    if (![MXRDeviceUtil isReachable]) {
        return;
    }
    pageIndex++;
    @MXRWeakObj(self);
    [[MXRBookSNSSendDetailController getInstance] getHotTopicWithPage:pageIndex WithPageSize:pageSize WithCallBack:^(BOOL isSuccess) {
        if (!isSuccess) {
            [selfWeak.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [selfWeak.tableView.mj_footer endRefreshing];
        }
        NSMutableArray *resultArray = [[MXRBookSNSSendDetailProxy getInstance] getOneSearchTopicArrayByKey:HotTopicArrayKey];
        if(resultArray)
        {
            selfWeak.dataArray = resultArray;
            [selfWeak.tableView reloadData];
        }
    }];
}

#pragma mark -  searchTopic代理
-(void)pushToTopicViewController:(UIViewController*)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)cancelBtnClicked   //searchtopic 取消按钮点击操作
{
    [self.searchTopicViewController willMoveToParentViewController:nil];
    [self.searchTopicViewController.view removeFromSuperview];
    [self.searchTopicViewController removeFromParentViewController];
    [self.searchTopicViewController didMoveToParentViewController:self];
    self.searchTopicViewController = nil;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self addInteractivePopGestureRecognizer];
}
-(void)hiddenNavgationBar
{
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark - textField代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.isEdit = YES;
}
#pragma mark - scrollview的代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (!didLoadFooter) {
         [self createFooter];
        didLoadFooter = YES;
    }
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    if (scrollView.contentOffset.y<20.0f && scrollView.frame.size.height != SCREEN_HEIGHT_DEVICE_ABSOLUTE-64) {
//        self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, SCREEN_HEIGHT_DEVICE_ABSOLUTE-64);
//        self.tableView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
//    }
//}
#pragma mark - tableview代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59.0f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MXRSearchTopicModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell setValue:model forKey:@"model"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=_dataArray.count) {
        return;
    }
    MXRSearchTopicModel *model = _dataArray[indexPath.row];
    MXRTopicMainViewController *vc = [[MXRTopicMainViewController alloc] initWithMXRTopicModelID:[NSString stringWithFormat:@"%ld",(long)model.topicId]];
    [self.navigationController pushViewController:vc animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return IPHONEX_SAFEAREA_INSETS_PORTRAIT.bottom;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE_ABSOLUTE, IPHONEX_SAFEAREA_INSETS_PORTRAIT.bottom)];
}

#pragma mark - setter
-(void)setIsEdit:(BOOL)isEdit
{

    _isEdit = isEdit;
    if (isEdit) {
        [self.searchTFDefaultView removeFromSuperview];
        self.searchTopicViewController.mxr_preferredNavigationBarHidden = YES;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.searchTopicViewController.disablePopGestureRecognizer = YES;
        [self addChildViewController:self.searchTopicViewController];
        [self.view  addSubview:self.searchTopicViewController.view];
        [self.searchTopicViewController didMoveToParentViewController:self];
        [self.searchTopicViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        self.isEdit = NO;
    }
    else
    {
        [self.searchTextField addSubview:self.searchTFDefaultView];
    }
}
#pragma mark - getter
-(MXRSearchTopicViewController*)searchTopicViewController
{
    if (!_searchTopicViewController)
    {
        _searchTopicViewController = [[MXRSearchTopicViewController alloc] initWithIsNeedJing:NO withSearchTextFieldBecomeFirstRegister:YES withIsFromAllTopic:YES withPageIndex:pageIndex];
        _searchTopicViewController.delegate = self;
    }
    return _searchTopicViewController;
}

-(CGFloat)tableViewContentHeight
{
    CGFloat height = 0;
    height += (self.dataArray.count)*59.0f +33;
    return height;
}

-(UIView*)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE_ABSOLUTE, 74)];
        _headerView.backgroundColor = RGB(255, 255, 255);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH_DEVICE_ABSOLUTE, 33)];
        view.backgroundColor = RGB(250, 250, 250);
        [_headerView addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH_DEVICE_ABSOLUTE, 33)];
        label.text = MXRLocalizedString(@"MXRSearchTopicViewController_HotTopic", @"热门话题");
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = RGB(102, 102, 102);
        label.backgroundColor = RGB(250, 250, 250);
        label.font = [UIFont systemFontOfSize:12.0f];
        [view addSubview:label];
        
        [_headerView addSubview:self.searchTextField];
        
        
    }
    return _headerView;
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE_ABSOLUTE, SCREEN_HEIGHT_DEVICE_ABSOLUTE - TOP_BAR_HEIGHT) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:MXRSearchTopicTableViewCell bundle:nil] forCellReuseIdentifier:CellIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

-(UIView*)searchTFDefaultView
{
    if (!_searchTFDefaultView) {
        CGFloat width = 75;
        _searchTFDefaultView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH_DEVICE_ABSOLUTE-24-width)/2.0, 0, width, 30)];
        _searchTFDefaultView.backgroundColor = RGB(0xed, 0xed, 0xed);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 4.5, 21, 21)];
        UIImage * imageSearch = MXRIMAGE(@"btn_bookStore_search");
        imageSearch = [imageSearch imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        imageView.image = imageSearch;
        imageView.tintColor = RGB(153, 153, 153);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, width-imageView.frame.size.width, 27)];
        label.text = MXRLocalizedString(@"MXRSearchTopicViewController_Topic", @"话题");
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0f];
        [label setTextColor:RGB(102, 102, 102)];
        
        [_searchTFDefaultView addSubview:imageView];
        [_searchTFDefaultView addSubview:label];
    }
    return _searchTFDefaultView;
}

-(UITextField*)searchTextField
{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 8.5, SCREEN_WIDTH_DEVICE_ABSOLUTE-24, 30)];
        _searchTextField.delegate = self;
        _searchTextField.layer.cornerRadius = 5.0f;
        _searchTextField.backgroundColor = RGB(0xed, 0xed, 0xed);
        [_searchTextField addSubview:self.searchTFDefaultView];
    }
    return _searchTextField;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
