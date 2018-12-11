//
//  MXRSearchTopicViewController.m
//  huashida_home
//
//  Created by lj on 16/9/22.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSearchTopicViewController.h"
#import "Enums.h"
#import "GlobalFunction.h"
#import "AFNetworkReachabilityManager.h"
#import "MXRBookSNSSendDetailProxy.h"
#import "MXRBookSNSSendDetailController.h"
#import "MXRSearchTopicModel.h"
#import "MXRSearchTopicTableViewCell.h"
//#import "MJDIYAutoFooter.h"
#import <MJRefreshFooter.h>
#import "MXRTopicMainViewController.h"

#define cellIdentifier @"cellIdentifier"
#define pageSize 20
#define wordLimit 138   //搜索话题的时候的字数限制
@interface MXRSearchTopicViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *nullDataLabel;   //无数据 提示页面
@property (strong, nonatomic) UITextField *searchTextField;                           //搜索框
@property (strong, nonatomic) UIView *searchTextFieldPlaceHolderView;            //搜索框默认view
@property (strong, nonatomic) UIImageView *searchTextFieldHeaderImageView;   //搜索框左边视图
@property (strong, nonatomic) UITableView *tableView;                                 //搜索结果
@property (strong, nonatomic) UIView *footerView;                                       //tableview的尾视图
@property (strong, nonatomic) UIView *headerView;                                       //tableview的头视图
@property (strong, nonatomic) UIButton *cancelBtn;                                      //取消按钮
@property (strong, nonatomic) UILabel *lineLabel;                                         //搜索框下面的一条横线
@property (assign, nonatomic) BOOL netStatus;                                           //网络状态
@property (assign, nonatomic) BOOL isNewTopic;                                           //是否是新话题
@property (strong, nonatomic) UIView *noNetContainerView;                           //当无网络的时候 数据为0的时候  需要去显示 点击刷新的界面
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic)   NSString *currentKeyWord;                              //当前页面的搜索词
//数据数组
@end
@implementation MXRSearchTopicViewController
{
    BOOL _isNeedJing;
    BOOL _wordHighlight;
    BOOL _shouldBecomeFirstRegister;
    BOOL _isFromAllTopic;
    MJRefreshFooter *_footer;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
-(instancetype)initWithIsNeedJing:(BOOL)isNeedJing withSearchTextFieldBecomeFirstRegister:(BOOL)shouldBecomeFirstRegister withIsFromAllTopic:(BOOL)isFromAllTopic{
    if (self=[super init]) {
        _isNeedJing=isNeedJing;
        _shouldBecomeFirstRegister = shouldBecomeFirstRegister;
        _isFromAllTopic = isFromAllTopic;
        _pageIndex = 1;
    }
    return self;
}

//index 表明 上拉加载列表的时候 从第几页 开始加载
-(instancetype)initWithIsNeedJing:(BOOL)isNeedJing withSearchTextFieldBecomeFirstRegister:(BOOL)shouldBecomeFirstRegister withIsFromAllTopic:(BOOL)isFromAllTopic withPageIndex:(NSInteger)index
{
    if (self=[super init]) {
        _isNeedJing=isNeedJing;
        _shouldBecomeFirstRegister = shouldBecomeFirstRegister;
        _isFromAllTopic = isFromAllTopic;
        if(index<1)
        {
            index = 1;
        }
        _pageIndex = index;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNewTopic = NO;
    _dataArray = [NSMutableArray new];
    self.currentKeyWord = @"";
    
    [self addObserver];
    [self getNetStatus];
    [self configView]; //配置界面
    if([[MXRBookSNSSendDetailProxy getInstance] getOneSearchTopicArrayByKey:HotTopicArrayKey].count==0)  //无数据  去请求
    {
        if([MXRDeviceUtil isReachable])
        {
            @MXRWeakObj(self);
            [[MXRBookSNSSendDetailController getInstance] getHotTopicWithPage:selfWeak.pageIndex WithPageSize:pageSize WithCallBack:^(BOOL isSuccess) {
                [selfWeak refreshSearchView];
            }];
        }
        else
        {
            [self showNetErrorView];
        }
    }
    else  //有数据 那么去 显示界面
    {
        [self refreshSearchView];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MXRClickUtil beginEvent:@"MengXiangQuanPage"];
    if ([self.delegate respondsToSelector:@selector(hiddenNavgationBar)]) {
        [self.delegate hiddenNavgationBar];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MXRClickUtil endEvent:@"MengXiangQuanPage"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_shouldBecomeFirstRegister) {
        [self.searchTextField becomeFirstResponder];
    }
}

#pragma mark - 界面
//显示网络差
-(void)showNetErrorView
{
    @MXRWeakObj(self);
    [self.view addSubview:self.noNetContainerView];
    [self.view bringSubviewToFront:self.noNetContainerView];
    [selfWeak showNetworkErrorOnView:selfWeak.noNetContainerView refreshCallback:^{
        [[MXRBookSNSSendDetailController getInstance] getHotTopicWithPage:selfWeak.pageIndex WithPageSize:pageSize WithCallBack:^(BOOL isSuccess) {
        }];
    }];
}
//隐藏网络差
-(void)hidenNetErrorView
{
    [self.noNetContainerView removeFromSuperview];
    [self hideNetworkErrorView];
}
//配置界面
-(void)configView
{
    _wordHighlight = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchTextField];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.lineLabel];
    [self createFooter];
}
//创建上拉加载控件
-(void)createFooter{
    
    _footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = _footer;
//    _footer.timeLabel.hidden = YES;
    // 隐藏状态
//    _footer.label.hidden = YES;
}
//显示无数据的view
-(void)showNullDataView
{
    [self setIsNewTopic:YES]; //隐藏tableview的头视图
    [self.view addSubview:self.nullDataLabel];
    [self.view bringSubviewToFront:self.nullDataLabel];
}
//隐藏无数据的view
-(void)hidenNullDataView
{
    [self setIsNewTopic:NO]; //显示tableview的头视图
    [self.nullDataLabel removeFromSuperview];
}

#pragma mark  - 加载更多数据
-(void)loadMoreData{
    _pageIndex++;
    @MXRWeakObj(self);
    [[MXRBookSNSSendDetailController getInstance] getHotTopicWithPage:selfWeak.pageIndex WithPageSize:pageSize WithCallBack:^(BOOL isSuccess) {
        if (!isSuccess) {
            [selfWeak haveNoMoreData];
        }
        else{
            [selfWeak.tableView.mj_footer endRefreshing];
        }
    }];
}
-(void)haveNoMoreData{
   
    [self.tableView.mj_footer endRefreshing];
    self.tableView.tableFooterView = [self createNoMorePingLun];
    self.tableView.mj_footer = nil;
}

-(UILabel*)createNoMorePingLun
{
    UILabel *noMoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 50)];
    noMoreLabel.text = MXRLocalizedString(@"Letter_Nomore_Data", @"—— 没有更多了 ——");
    noMoreLabel.textAlignment = NSTextAlignmentCenter;
    noMoreLabel.textColor = RGB(197, 197, 197);
    noMoreLabel.font = [UIFont systemFontOfSize:12];
    return  noMoreLabel;
}

#pragma mark - 搜索
-(void)searchTopicWithKeyWord:(NSString*)keyWord
{
    [self hidenNetErrorView];
    self.netStatus = [MXRDeviceUtil isReachable];
    @MXRWeakObj(self);
    if ([keyWord isEqualToString:@""]) {
        keyWord = HotTopicArrayKey;
        if ([MXRDeviceUtil isReachable]) {
            [selfWeak.tableView.mj_footer setHidden:NO];
        }
    }
    else{
        [selfWeak.tableView.mj_footer setHidden:YES];
    }
    if (_isFromAllTopic) { //来之全部话题
        NSMutableArray *resultArray = [[MXRBookSNSSendDetailProxy getInstance] getOneSearchTopicArrayByKey:keyWord];
        if (resultArray == nil) {   //为nil表明 该关键字未进行过请求 所以需要去请求
            //根据关键字来搜索 话题
            [[MXRBookSNSSendDetailController getInstance] searchTopicByKeyword:keyWord WithCallBack:^(BOOL isSuccess) {
                if (!isSuccess) { //服务失败
                    if ([keyWord isEqualToString:selfWeak.currentKeyWord]) {
                        [selfWeak.dataArray removeAllObjects];
                        [selfWeak.tableView reloadData];
                        [selfWeak showNullDataView]; //显示无消息界面
                    }
                }
            }];
        }
        else
        {
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:resultArray];
            [selfWeak.tableView reloadData];
            if(_dataArray.count == 0){
                [self showNullDataView]; //显示无消息界面
            }
            else
            {
                [self hidenNullDataView]; //隐藏无消息界面
            }
            
        }
        return;
    }
    //来自发布动态
    if([MXRDeviceUtil isReachable]){ //来自发布动态 有网络情况
        NSMutableArray *resultArray = [[MXRBookSNSSendDetailProxy getInstance] getOneSearchTopicArrayByKey:keyWord];
        if (resultArray == nil) {           //表明需要去请求新数据
            //根据关键字来搜索 话题
            [[MXRBookSNSSendDetailController getInstance] searchTopicByKeyword:keyWord WithCallBack:^(BOOL isSuccess) {
                if (!isSuccess) {
                    if ([keyWord isEqualToString:selfWeak.currentKeyWord]) {
                        [selfWeak.dataArray removeAllObjects];
//                        [selfWeak createNewTopicWithKeyWord:keyWord];
                        selfWeak.isNewTopic = YES;
                        [selfWeak.tableView reloadData];
                    }
                }
            }];
        }
        else if(resultArray.count == 0){  //那么表明 该话题为新话题
            [_dataArray removeAllObjects];
//            [self createNewTopicWithKeyWord:keyWord];
            self.isNewTopic = YES;
            [selfWeak.tableView reloadData];
        }
        else{                                //表明在缓存数组中搜索到了结果
            _dataArray = resultArray;
            self.isNewTopic = NO;
            BOOL isExist = [[MXRBookSNSSendDetailController getInstance] checkIsCurrentTopicExistinArray:resultArray WithTopicName:keyWord];
            if (!isExist) { // 如果当前关键字 在数组中不存在 相同的那么 需要将 该关键字也做为 一个新的话题 放在数组的首位
//                [self createNewTopicWithKeyWord:keyWord];
            }
            [selfWeak.tableView reloadData];
        }
    }
    else{// 来自发布动态 无网络状态
        NSMutableArray *resultArray = [[MXRBookSNSSendDetailProxy getInstance] getOneSearchTopicArrayByKey:keyWord];
        if (resultArray == nil || resultArray.count == 0) {
            [_dataArray removeAllObjects];
//            [self createNewTopicWithKeyWord:keyWord];
            self.isNewTopic = YES;
            [selfWeak.tableView reloadData];
        }
        else{                                //表明在缓存数组中搜索到了结果
            _dataArray = resultArray;
            self.isNewTopic = NO;
            BOOL isExist = [[MXRBookSNSSendDetailController getInstance] checkIsCurrentTopicExistinArray:resultArray WithTopicName:keyWord];
            if (!isExist) { // 如果当前关键字 在数组中不存在 相同的那么 需要将 该关键字也做为 一个新的话题 放在数组的首位
//                [self createNewTopicWithKeyWord:keyWord];
            }
            [selfWeak.tableView reloadData];
        }
    }
    [self hidenNullDataView];
    if (_dataArray.count == 0 && [keyWord isEqualToString:HotTopicArrayKey] && ![MXRDeviceUtil isReachable]) {
        [self showNetErrorView];
    }
    else if (_dataArray.count == 0 && [keyWord isEqualToString:HotTopicArrayKey] && [MXRDeviceUtil isReachable]) //进入搜索页面的时候 当 没有请求热门数据  那么 需要显示 无话题界面
    {
        [self showNullDataView];
    }
}
//接受到请求完成的通知后 执行的方法
-(void)refreshSearchView
{
    [self searchTopicWithKeyWord:self.currentKeyWord];
}
-(void)createNewTopicWithKeyWord:(NSString*)keyWord{
    if([keyWord isEqualToString:HotTopicArrayKey]){
        return;
    }
    MXRSearchTopicModel *model = [[MXRSearchTopicModel alloc] initNewWithTopicName:keyWord];
    [_dataArray insertObject:model atIndex:0];
}

#pragma mark - 添加通知监听
-(void)addObserver
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(netDidChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil]; //监听网络变化
//当去网络获取数据后，来通知该界面刷新请求结果
    [notificationCenter addObserver:self selector:@selector(refreshSearchView) name:SearchTopic_RefreshView object:nil];
    //当通知改页删除话题时的操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeModel:) name:Notification_MXRBookSNS_TopicNoData object:nil];
    //监听文字输入是否发生变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveNoMoreData) name:Notification_Have_NoMore_Topic object:nil];
    
}
-(void)textFieldDidChanged
{
    [self changeText:nil];
}
-(void)getNetStatus
{
    self.netStatus = [MXRDeviceUtil isReachable];
}

#pragma mark - 删除模型
-(void)removeModel:(NSNotification*)noti
{
    @MXRWeakObj(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *str = autoString([noti.object objectForKey:@"TOPICID"]);
        NSInteger modelIndex = [[MXRBookSNSSendDetailProxy getInstance] removeModelWithKey:selfWeak.currentKeyWord topicId:str];
        if (modelIndex>=selfWeak.dataArray.count) {
            return;
        }
        [selfWeak.dataArray removeObjectAtIndex:modelIndex];
        NSArray *array = @[[NSIndexPath indexPathForRow:modelIndex inSection:0]];
        [selfWeak.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationTop];
    });
}

#pragma mark - 网络变化
-(void)netDidChanged:(NSNotification*)noti
{
    NSInteger netStatus = [(NSNumber*)noti.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    switch (netStatus) {
        case AFNetworkReachabilityStatusUnknown:
            self.netStatus = NO;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            self.netStatus = NO;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            self.netStatus = YES;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            self.netStatus = YES;
            break;
        default:
            self.netStatus = YES;
            break;
    }
}

#pragma mark - 按钮操作
-(void)cancelBtnAction:(id)sender //取消按钮点击操作
{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    if (_isFromAllTopic) {  //全部话题 过来的 点击取消按钮
        if([self.delegate respondsToSelector:@selector(cancelBtnClicked)])
        {
            [_tableView removeFromSuperview];
            _tableView = nil;
            [self.delegate cancelBtnClicked];
        }
    }
    else{               //发布动态过来的 点击 cancel
        if ([self.delegate respondsToSelector:@selector(makeTextViewBecomeFirstResponder)]) {
            [self.delegate makeTextViewBecomeFirstResponder];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.tableView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        _tableView.mj_footer = nil;
        [_tableView removeFromSuperview];
        _tableView = nil;
        [[MXRBookSNSSendDetailProxy getInstance] removecacheSearchTopicArray];
        [_dataArray removeAllObjects];
        _dataArray = nil;
        _headerView = nil;
        _searchTextField = nil;
        [_searchTextField removeFromSuperview];
        [_nullDataLabel removeFromSuperview];
        _nullDataLabel = nil;
        [_cancelBtn removeFromSuperview];
        _cancelBtn = nil;
        [_lineLabel removeFromSuperview];
        _lineLabel = nil;
        [_noNetContainerView removeFromSuperview];
        _noNetContainerView = nil;
        _footer = nil;
    }
}


#pragma mark - textField代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    @MXRWeakObj(self);
    // 处理表情
    __block BOOL hasEmoji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if (substring.length >= 2) {
            *stop = YES;
            hasEmoji = YES;
        }
    }];
    
    if (hasEmoji) {
        return NO;
    }
    if([string isEqualToString:@" "])   //不允许空格输入
    {
        return NO;
    }
    BOOL reslut = YES;
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if(toBeString.length<wordLimit){
    }
    else if (([toBeString length] > wordLimit && !_wordHighlight) || (textField.text.length==wordLimit && !_wordHighlight)){
            reslut = NO;
    }
    if (reslut) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [selfWeak changeText:nil];
        });
    }
    return reslut;
}
//监听textfield 变化
-(void)changeText:(id)sender
{
    UITextField* tf=self.searchTextField;
    NSString* toBeString=tf.text;
    int maxNum = wordLimit;
    NSString *langugeType = [[tf textInputMode] primaryLanguage];
    if ([langugeType isEqualToString:@"zh-Hans"])//中文输入
    {
        UITextRange *selectedRange = [tf markedTextRange];//选中部分
        //获取高亮部分
        UITextPosition *position = [tf positionFromPosition:selectedRange.start offset:0];
        if (!position)//无高亮
        {
            if (toBeString.length>=maxNum) {
                toBeString=[toBeString substringToIndex:maxNum];
                tf.text=toBeString;
            }
            _wordHighlight = NO;
            //去请求数据
            [self searchTopicWithKeyWord:tf.text];
            if (_dataArray.count>0) {
                [self.tableView setContentOffset:CGPointMake(0, 0)];
            }
            [self.tableView reloadData];
            self.currentKeyWord = tf.text;
        }
        else//有高亮
        {
            _wordHighlight = YES;
        }
    }
    else//非中文输入
    {
        _wordHighlight = NO;
        if (toBeString.length>maxNum)
        {
            toBeString=[toBeString substringToIndex:maxNum];
            tf.text=toBeString;
        }
        //去请求数据
        [self searchTopicWithKeyWord:tf.text];
        if (_dataArray.count>0) {
            [self.tableView setContentOffset:CGPointMake(0, 0)];
        }
        [self.tableView reloadData];
        self.currentKeyWord = tf.text;
    }
}
#pragma mark - scrollView的代理方法
//当手指滑动tableview的时候 需要将键盘 消失
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     [self.searchTextField resignFirstResponder];
}
#pragma mark - tableview代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    MXRSearchTopicModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell setValue:model forKey:@"model"];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
//点击话题
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    if (_dataArray.count <= indexPath.row) {
        return;
    }
    MXRSearchTopicModel *model = _dataArray[indexPath.row];
    if (_isFromAllTopic) { //需要跳转到 话题页
        if ( model.isNewTopic) {
            return;
        }
        MXRTopicMainViewController *vc = [[MXRTopicMainViewController alloc] initWithMXRTopicModelID:[NSString stringWithFormat:@"%ld",(long)model.topicId]];
        if ([self.delegate respondsToSelector:@selector(pushToTopicViewController:)]) {
            
            [self.searchTextField resignFirstResponder];
            [self cancelBtnAction:nil];
            [self.delegate pushToTopicViewController:vc];
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selected = NO;
    }
    else{ //跳转到 发布动态页
        if ([self.delegate respondsToSelector:@selector(userHaveSelectTopicDelegate:)]) {
            if (model.name.length>1) {
                
                NSString *callBackString = _isNeedJing?model.name:([[model.name substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"#"]?[model.name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""]:model.name);
                [self.searchTextField resignFirstResponder];
                [self.delegate userHaveSelectTopicDelegate:callBackString];
            }
        }
        [tableView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self cancelBtnAction:nil];
    }
}
#pragma mark - setter
//判断是否是新话题 如何不是新话题 需要headerview 反之不需要
-(void)setIsNewTopic:(BOOL)isNewTopic
{
    _isNewTopic = isNewTopic;
    if (!isNewTopic) {
        self.tableView.tableHeaderView = nil;
        self.tableView.tableHeaderView = self.headerView;
    }
    else
    {
        self.tableView.tableHeaderView = nil;
    }
}

-(void)setNetStatus:(BOOL)netStatus
{
    _netStatus = netStatus;
    if (netStatus) {
        self.tableView.tableFooterView = nil;
//        [self refreshSearchView];     //来网络后 需要需要刷新下界面
    }
    else
    {
        if (!_isFromAllTopic) {
            self.tableView.tableFooterView = self.footerView;
        }
        [self.tableView.mj_footer setHidden:YES];

    }
    
}
#pragma mark - getter
-(UIView*)noNetContainerView
{
    if (!_noNetContainerView)
    {
        _noNetContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT, SCREEN_WIDTH_DEVICE_ABSOLUTE, SCREEN_HEIGHT_DEVICE_ABSOLUTE-TOP_BAR_HEIGHT)];
        _noNetContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _noNetContainerView;
}
-(UILabel*)nullDataLabel
{
    if (!_nullDataLabel) {
        _nullDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 124, SCREEN_WIDTH_DEVICE_ABSOLUTE, 20)];
        _nullDataLabel.text  = MXRLocalizedString(@"SearchTopic_NoTopic", @"话题不存在");
        _nullDataLabel.font = [UIFont systemFontOfSize:17.0f];
        _nullDataLabel.textColor = RGB(108, 108, 108);
        _nullDataLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nullDataLabel;
}
-(UILabel*)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT-2, SCREEN_WIDTH_DEVICE_ABSOLUTE, 1)];
        [_lineLabel setBackgroundColor:RGB(0xe6, 0xe6, 0xe6)];
    }
    return _lineLabel;
}

-(UIView*)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE_ABSOLUTE, 33)];
        _headerView.backgroundColor = RGB(250, 250, 250);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, SCREEN_WIDTH_DEVICE_ABSOLUTE, 12)];
        label.text = MXRLocalizedString(@"MXRSearchTopicViewController_HotTopic", @"热门话题");
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = RGB(102, 102, 102);
        label.font = [UIFont systemFontOfSize:12.0f];
        [_headerView addSubview:label];
    }
    return _headerView;
}

-(UIView*)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE_ABSOLUTE, 33)];
        _footerView.backgroundColor = [UIColor whiteColor];
        UILabel *noNetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, SCREEN_WIDTH_DEVICE_ABSOLUTE, 15)];
        noNetLabel.text = MXRLocalizedString(@"MXRSearchTopicViewController_NoNet", @"无可用网络");
        noNetLabel.textAlignment = NSTextAlignmentCenter;
        noNetLabel.textColor = RGB(153, 153, 153);
        [_footerView addSubview:noNetLabel];
    }
    return _footerView;
}

-(UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT, SCREEN_WIDTH_DEVICE_ABSOLUTE, SCREEN_HEIGHT_DEVICE_ABSOLUTE-TOP_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"MXRSearchTopicTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}

-(UITextField*)searchTextField  //搜索框
{
    if (!_searchTextField)
    {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0f, STATUS_BAR_HEIGHT + 8, SCREEN_WIDTH_DEVICE_ABSOLUTE-76.0f, 28)];
        _searchTextField.delegate = self;
        _searchTextField.backgroundColor = RGB(0xed, 0xed, 0xed);
        _searchTextField.font = [UIFont systemFontOfSize:14.0f];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:MXRIMAGE(@"btn_bookSNS_selectTopic")];
        imageView.frame = CGRectMake(0, 0, 25, 18);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _searchTextField.leftView = imageView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:MXRLocalizedString(@"MXRSearchTopicViewController_Topic", @"话题") attributes:@{NSForegroundColorAttributeName:RGB(153, 153, 153)}];
        _searchTextField.attributedPlaceholder = attrStr;
        _searchTextField.layer.cornerRadius = 5.0f;
    }
    return _searchTextField;
}
-(UIButton*)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(SCREEN_WIDTH_DEVICE_ABSOLUTE-60, STATUS_BAR_HEIGHT + 8, 66-15, 28);
        [_cancelBtn setTitle:MXRLocalizedString(@"CANCEL", @"取消") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIView*)searchTextFieldPlaceHolderView   //搜索框默认view
{
    if (!_searchTextFieldPlaceHolderView) {
        _searchTextFieldPlaceHolderView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH_DEVICE_ABSOLUTE/2.0-25.0f, 0, 50, 27)];
        UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 25, 27)];
        placeHolderLabel.textColor = RGB(102, 102, 102);
        placeHolderLabel.text = MXRLocalizedString(@"MXRSearchTopicViewController_Topic", @"话题");
        [_searchTextFieldPlaceHolderView addSubview:placeHolderLabel];
        
        
    }
    return _searchTextFieldPlaceHolderView;
}

-(UIImageView*)searchTextFieldHeaderImageView
{
    if (!_searchTextFieldHeaderImageView) {
        _searchTextFieldHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
        _searchTextFieldHeaderImageView.image = MXRIMAGE(@"btn_searchTopicVC_search");
    }
    return _searchTextFieldHeaderImageView;
}
#pragma mark - dealloc
-(void)dealloc
{
    DLOG_METHOD
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
