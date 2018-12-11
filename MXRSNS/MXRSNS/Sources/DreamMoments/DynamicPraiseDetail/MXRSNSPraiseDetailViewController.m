//
//  MXRSNSPraiseDetailViewController.m
//  huashida_home
//
//  Created by shuai.wang on 2017/7/6.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSNSPraiseDetailViewController.h"
#import "MXRSNSPraiseListTableViewCell.h"
#import "MXRBookSNSDetailController.h"
#import "MXRBookSNSPraiseModel.h"
#import "MXRBookSNSPraiseListModel.h"
#import "MJRefresh.h"
#import "MXRBookSNSLoadDataGifRefreshFooter.h"
#define CellIndentifier @"CellIndentifier"
#define CellHeight 65
@interface MXRSNSPraiseDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) MXRSNSShareModel *momentModel;
@property (nonatomic, strong) MXRBookSNSPraiseModel *detailPraiseModel;   //点赞数据模型
@end

@implementation MXRSNSPraiseDetailViewController
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

-(instancetype)initWithMXRSNSShareModel:(MXRSNSShareModel *)momentModel {
    if (self = [super init]) {
        self.momentModel = momentModel;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = MXRLocalizedString(@"Praise", @"赞");
    self.page = 1;
    
    [self requestDynamicPraiseListData];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setExtraCellLineHidden:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MXRSNSPraiseListTableViewCell" bundle:nil] forCellReuseIdentifier:CellIndentifier];
}


-(void)requestDynamicPraiseListData {
    
    @MXRWeakObj(self);
    [[MXRBookSNSDetailController getInstance] requestBookSNSPraiseListWithDynamicId:autoString(self.momentModel.momentId) uid:autoString(self.momentModel.senderId) page:self.page WithCallBack:^(BOOL isOk,MXRServerStatus status,MXRBookSNSPraiseModel *model) {
        if (isOk) {
            self.detailPraiseModel = model;
            selfWeak.page++;
            [selfWeak addMJRefreshFootView];
            [selfWeak.tableView reloadData];
            [selfWeak.tableView.mj_footer endRefreshing];
        }else{
            if (status == MXRServerStatusNetworkError) {
                if (selfWeak.page == 1) {
                    [selfWeak showNetworkErrorWithRefreshCallback:^{
                        [selfWeak requestDynamicPraiseListData];
                    }];
                }else{
                    [selfWeak.tableView.mj_footer endRefreshing];
                }
            }else{
                [selfWeak.tableView.mj_footer endRefreshing];
                selfWeak.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
        }
    }];
}

-(void)addMJRefreshFootView {
    
    
    
        if (self.detailPraiseModel.list.count < self.detailPraiseModel.total) {
            
            MXRBookSNSLoadDataGifRefreshFooter * t_footer = [MXRBookSNSLoadDataGifRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestDynamicPraiseListData)];
            t_footer.refreshingTitleHidden = YES;
            [t_footer setTitle:MXRLocalizedString(@"Letter_Nomore_Data", @"—— 没有更多了 ——") forState:MJRefreshStateNoMoreData];
            self.tableView.mj_footer = t_footer;
        }
    
}

-(MXRSNSPraiseListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MXRSNSPraiseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier forIndexPath:indexPath];
    
    if (self.detailPraiseModel.list.count > indexPath.row) {
        MXRBookSNSPraiseListModel *praiseModel = self.detailPraiseModel.list[indexPath.row];
        [cell configCellData:praiseModel];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailPraiseModel.list.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellHeight;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

-(void)dealloc {
    DLOG_METHOD;
}
@end
