//
//  MXRPKQuestionListViewController.m
//  huashida_home
//
//  Created by MountainX on 2018/8/8.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKQuestionListViewController.h"
#import "MXRPKQuestionListController.h"
#import "MXRPKQuestionListTableViewCell.h"
#import "MXRPKQuestionListModel.h"
#import "Masonry.h"
#import "MXRPromptView.h"
//#import "MXRLoginVC.h"
#import "MXRNavigationViewController.h"
#import "MXRPKNormalAnswerVC.h"
#import "MXRBookSNSLoadDataGifRefreshHeader.h"
#import "MXRBookSNSLoadDataGifRefreshFooter.h"

#define kPageNum 10
#define kCellHeight 120.f
#define kHeaderHeight 8.f

@interface MXRPKQuestionListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, strong) NSMutableArray <MXRPKQuestionListModel *> * dataArr;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MXRPKQuestionListModel *currentQLModel;

@end

@implementation MXRPKQuestionListViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = MXRLocalizedString(@"MXR_PK_QUESTIONS", @"问答");
    
    [self initData];
    
    [self createUI];
    [self createHeader];
    [self createFooter];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)dealloc {
    DLOG_METHOD
}

#pragma mark - InitData
- (void)initData {
    _page = 1;
}

- (void)createUI {
    self.view.backgroundColor = MXRCOLOR_F3F4F6;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(self.view).mas_equalTo(UIEdgeInsetsZero);
    }];
}

-(void)createHeader
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MXRBookSNSLoadDataGifRefreshHeader *header = [MXRBookSNSLoadDataGifRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    
    // 设置header
    self.tableView.mj_header = header;
}

-(void)createFooter
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MXRBookSNSLoadDataGifRefreshFooter * t_footer = [MXRBookSNSLoadDataGifRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    // 隐藏状态
    t_footer.refreshingTitleHidden = YES;
    [t_footer setTitle:MXRLocalizedString(@"Letter_Nomore_Data", @"—— 没有更多了 ——") forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = t_footer;
}

- (void)headerRefresh {
    @MXRWeakObj(self);
    _page = 1;
    [MXRPKQuestionListController requestQuestionListWithCategoryId:_categoryId page:_page pageNum:kPageNum success:^(MXRNetworkResponse *response) {
        selfWeak.page ++;
        NSDictionary *dict = response.body;
        NSArray *qaList = [dict objectForKey:@"qaList"];
        if (qaList && [qaList isKindOfClass:[NSArray class]]) {
            [selfWeak.dataArr removeAllObjects];
            [qaList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MXRPKQuestionListModel *model = [MXRPKQuestionListModel mxr_modelWithJSON:obj];
                [selfWeak.dataArr addObject:model];
            }];
            [selfWeak.tableView reloadData];
        }
        
        if (selfWeak.dataArr.count == 0) {
            [selfWeak showNetworkErrorWithRefreshCallback:^{
                [selfWeak headerRefresh];
            }];
        }
        [selfWeak.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [selfWeak showNetworkErrorWithRefreshCallback:^{
            [selfWeak headerRefresh];
        }];
        [selfWeak.tableView.mj_header endRefreshing];
    }];
}

- (void)footerRefresh {
    @MXRWeakObj(self);
    [MXRPKQuestionListController requestQuestionListWithCategoryId:_categoryId page:_page pageNum:kPageNum success:^(MXRNetworkResponse *response) {
        selfWeak.page ++;
        NSDictionary *dict = response.body;
        NSArray *qaList = [dict objectForKey:@"qaList"];
        if (qaList && [qaList isKindOfClass:[NSArray class]]) {
            [qaList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MXRPKQuestionListModel *model = [MXRPKQuestionListModel mxr_modelWithJSON:obj];
                [selfWeak.dataArr addObject:model];
            }];
            [selfWeak.tableView reloadData];
        }

        if (qaList && [qaList isKindOfClass:[NSArray class]] && qaList.count == kPageNum) {
            [selfWeak.tableView.mj_footer endRefreshing];
        } else {
            [selfWeak.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [selfWeak showNetworkErrorWithRefreshCallback:^{
            [selfWeak headerRefresh];
        }];
        [selfWeak.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Lazy Loader
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = MXRCOLOR_F3F4F6;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MXRPKQuestionListTableViewCell *cell = [MXRPKQuestionListTableViewCell cellWithTableView:tableView];
    cell.model = [self.dataArr objectAtIndex:indexPath.row];
    cell.backgroundColor = MXRCOLOR_F3F4F6;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, kHeaderHeight)];
    header.backgroundColor = MXRCOLOR_F3F4F6;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, CGFLOAT_MIN)];
    footer.backgroundColor = MXRCOLOR_F3F4F6;
    return footer;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _currentQLModel = [self.dataArr objectAtIndex:indexPath.row];
    
    if ([[UserInformation modelInformation] getIsLogin] == NO) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:MXRLocalizedString(@"KnowLedgeTree_MXRPromptView_LoginToExame", @"您需要登录才能答题，请登录") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:MXRLocalizedString(@"KnowLedgeTree_MXRPromptViewLogin", @"登录") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 跳转到登录页面
//            MXRLoginVC *vc = [[MXRLoginVC alloc] init];
//            @weakify(self)
//            vc.loginResultBlock = ^(MXRLoginVCResult result) {
//                @strongify(self)
//                if (!strong_self) return;
//                if (result & MXRLoginVCResultSuccess) {
//                    if ([strong_self respondsToSelector:@selector(jumpToQuestions)]) {
//                        [strong_self jumpToQuestions];
//                    }
//                }
//            };
//            MXRNavigationViewController *loginNavigationC = [[MXRNavigationViewController alloc] initWithRootViewController:vc];
//            [self.navigationController presentViewController:loginNavigationC animated:YES completion:nil];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:MXRLocalizedString(@"CANCEL", @"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:confirmAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self jumpToQuestions];
    }
}

#pragma mark - Events
- (void)jumpToQuestions {
    if (_currentQLModel) {
        MXRPKNormalAnswerVC *pkNormalAnswerVC = [[MXRPKNormalAnswerVC alloc] init];
        pkNormalAnswerVC.qaId = [NSString stringWithFormat:@"%ld",_currentQLModel.qaId];
        MXRNavigationViewController *navi = [[MXRNavigationViewController alloc] initWithRootViewController:pkNormalAnswerVC];
        [navi.navigationBar setTitleTextAttributes:@{NSFontAttributeName:MXRNAVITITLEFONT,NSForegroundColorAttributeName:MXRNAVITITLCOLOR}];
        navi.navigationBar.barTintColor = MXRNAVIBARTINTCOLOR;
        [self.navigationController presentViewController:navi animated:YES completion:nil];
    }
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
