//
//  MXRPKRankListViewController.m
//  huashida_home
//
//  Created by MinJing_Lin on 2018/10/16.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKRankListViewController.h"
#import "MXRPKRankListBottomView.h"
#import "MXRPKRankListController.h"
#import "MXRPKRankListModel.h"
#import "GlobalBusyFlag.h"

#import "MXRPKRankListHeaderReusableView.h"
#import "MXRPKRankListCollectionViewCell.h"
#import "MXRPKRankFirstCollectionViewCell.h"
#import "MXRPKRankListEmptyCollectionCell.h"

static const CGFloat PkRankListRowHeight = 70.0;

@interface MXRPKRankListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

//@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) UICollectionView *collectioniew;
/// 我当前位置视图
@property (nonatomic, strong) MXRPKRankListBottomView *rankView;
/// 数据model
@property (nonatomic, strong) MXRPKRankListModel *rankModel;

@end

@implementation MXRPKRankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排行榜";
    
    [self.collectioniew registerNib:[UINib nibWithNibName:@"MXRPKRankFirstCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MXRPKRankFirstCollectionViewCell"];
    [self.collectioniew registerNib:[UINib nibWithNibName:@"MXRPKRankListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MXRPKRankListCollectionViewCell"];
    [self.collectioniew registerNib:[UINib nibWithNibName:@"MXRPKRankListEmptyCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MXRPKRankListEmptyCollectionCell"];
    [self.collectioniew registerNib:[UINib nibWithNibName:@"MXRPKRankListHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MXRPKRankListHeaderReusableView"];
    [self setUpUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark - load UI data
- (void)setUpUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.rankView];
    [self hideAllViews:YES];
}

- (void)loadData{
    
    __weak __typeof(self) weakSelf = self;
    [[GlobalBusyFlag sharedInstance] showBusyFlagOnWindow];
    [MXRPKRankListController loadPKRankListsuccess:^(MXRPKRankListModel *rankModel) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return ;
        }
        [[GlobalBusyFlag sharedInstance] hideBusyFlag];
        [strongSelf hideNetworkErrorView];
        [strongSelf hideAllViews:NO];
        // 最多显示前20名
        if (rankModel.qaChallengeRankingInfoList.count > 20) {
            rankModel.qaChallengeRankingInfoList = [rankModel.qaChallengeRankingInfoList subarrayWithRange:NSMakeRange(0, 20)];
        }
        strongSelf.rankModel = rankModel;
        strongSelf.rankView.rankModel = rankModel;
        
        [strongSelf.collectioniew reloadData];
       
    } failure:^(id error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return ;
        }
        [[GlobalBusyFlag sharedInstance] hideBusyFlag];
        [strongSelf showNetworkErrorWithRefreshCallback:^{
            [strongSelf loadData];
        }];
    }];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!self.rankModel || self.rankModel.qaChallengeRankingInfoList.count == 0) {
        return 1;
    }else{
        return  self.rankModel.qaChallengeRankingInfoList.count > 3 ? self.rankModel.qaChallengeRankingInfoList.count - 2 : 1;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.rankModel || self.rankModel.qaChallengeRankingInfoList.count == 0) {
        MXRPKRankListEmptyCollectionCell *emptyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MXRPKRankListEmptyCollectionCell" forIndexPath:indexPath];
        return emptyCell;
    }

    if (indexPath.row == 0) {
        MXRPKRankFirstCollectionViewCell *firstCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MXRPKRankFirstCollectionViewCell" forIndexPath:indexPath];
        [firstCell parseCellDataWithModel:self.rankModel];
        return firstCell;
    }else{
        MXRPKRankListCollectionViewCell *listCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MXRPKRankListCollectionViewCell" forIndexPath:indexPath];
        [listCell parseCellDataWithModel:[self.rankModel.qaChallengeRankingInfoList objectAtIndex:indexPath.row+2] rowInteger:indexPath.row + 3];
        return listCell;
    }
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.rankModel || self.rankModel.qaChallengeRankingInfoList.count == 0) {
        return  CGSizeMake(SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE);;
    }
    if (indexPath.row == 0) {
        return CGSizeMake(SCREEN_WIDTH_DEVICE - 30, 194);
    }else{
        return CGSizeMake(SCREEN_WIDTH_DEVICE - 30, 70);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (!self.rankModel || self.rankModel.qaChallengeRankingInfoList.count == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREEN_WIDTH_DEVICE, 330);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        MXRPKRankListHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MXRPKRankListHeaderReusableView" forIndexPath:indexPath];
        [headerView parseCellDataWithModel:self.rankModel];
        return headerView;
    }
    return [UICollectionReusableView new];
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - Target Mehtods

#pragma mark - Notification Method

#pragma mark - Private Method
- (void)hideAllViews:(BOOL)isHide {
    
    self.collectioniew.hidden = isHide;
    self.rankView.hidden = isHide;

}

#pragma mark - Public Method

#pragma mark - Delegate Method

#pragma mark - Getters & Setters

- (UICollectionView *)collectioniew{
    if (!_collectioniew) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _collectioniew = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE-MXRStatusAndNavHeight-MXRiPhoneX_BottomMargin-PkRankListRowHeight) collectionViewLayout:layout];
        _collectioniew.backgroundColor = RGBHEX(0xFFF2C7);
        _collectioniew.dataSource = self;
        _collectioniew.delegate = self;
        [self.view addSubview:_collectioniew];
    }
    return _collectioniew;
}

- (MXRPKRankListBottomView *)rankView {
    if (!_rankView) {
        CGRect rect = CGRectMake(0, SCREEN_HEIGHT_DEVICE - PkRankListRowHeight - MXRStatusAndNavHeight - MXRiPhoneX_BottomMargin, SCREEN_WIDTH_DEVICE, PkRankListRowHeight);
        _rankView = [[MXRPKRankListBottomView alloc]initWithFrame:rect];
    }
    return _rankView;
}

#pragma mark - dealloc
- (void)dealloc {
    DLOG_METHOD;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
