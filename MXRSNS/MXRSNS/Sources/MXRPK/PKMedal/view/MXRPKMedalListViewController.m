//
//  MXRPKMedalListViewController.m
//  huashida_home
//
//  Created by shuai.wang on 2018/1/19.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKMedalListViewController.h"
#import "MXRPKNetworkManager.h"
#import "MXRPKMedalInfoModel.h"
#import "MXRPKMedalCollectionViewCell.h"
#import "MXRPKMedalDetailView.h"
//#import "AppDelegate.h"
#import "MXRLoadFailedView.h"
#import "MXRPKQuestionListViewController.h"

#define Identifier @"Identifier"

@interface MXRPKMedalListViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *medalNumLable;
@property (nonatomic, strong) MXRLoadFailedView *loadFailedView;
@property (nonatomic, strong) MXRPKMedalInfoModel *pkMedalInfoModel;
@end

@implementation MXRPKMedalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = MXRLocalizedString(@"MXRPKMedalViewController_Medal", @"勋章");
    [self.collectionView registerNib:[UINib nibWithNibName:@"MXRPKMedalCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:Identifier];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestPKMedalListInfo];
}

-(void)requestPKMedalListInfo {
    @MXRWeakObj(self);
    [MXRPKNetworkManager requestUserPKMedalListSuccess:^(MXRPKMedalInfoModel *pkMedalListInfo) {
        if (selfWeak.loadFailedView) {
            [selfWeak.loadFailedView removeFromSuperview];
        }
        selfWeak.pkMedalInfoModel = pkMedalListInfo;
        [selfWeak reloadData];
    } failure:^(MXRServerStatus status, id result) {
        [selfWeak showLoadError];
    }];
}

-(void)showLoadError{
    @MXRWeakObj(self)
    self.loadFailedView = [MXRLoadFailedView loadFailedView];
    self.loadFailedView.refreshTapped = ^(MXRLoadFailedView *sender){
        [selfWeak requestPKMedalListInfo];
    };
    self.loadFailedView.frame = self.view.bounds;
    [self.view addSubview:self.loadFailedView];
    
}

-(void)reloadData {
    [self.collectionView reloadData];
    if (self.pkMedalInfoModel.medalCount > 0) {
        if (self.pkMedalInfoModel.medalCount == self.pkMedalInfoModel.medalVos.count) {
            self.medalNumLable.text = MXRLocalizedString(@"MXRPKMedaiVC_Prompt_Obtain_All_Medal", @"真棒，你已经集齐了全部勋章！");
        }else {
            self.medalNumLable.text = [NSString stringWithFormat:MXRLocalizedString(@"MXRPKMedaiVC_Prompt_Has_Some_Medal", @"已获得%ld个勋章，继续努力哦！"),self.pkMedalInfoModel.medalCount];
        }
    }else{
        self.medalNumLable.text = MXRLocalizedString(@"MXRPKMedaiVC_Prompt_None_Medal", @"还没有获得勋章，要努力哦！");
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pkMedalInfoModel.medalVos.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MXRPKMedalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    cell.pkMedalInfoModel = self.pkMedalInfoModel.medalVos[indexPath.row];
    @MXRWeakObj(self)
    cell.callback = ^(MXRPKMedalDetailModel *pkMedalDetailModel) {
        
        MXRPKMedalDetailView *pkMedalDetailView = [[NSBundle mainBundle] loadNibNamed:@"MXRPKMedalDetailView" owner:nil options:nil].lastObject;
//        pkMedalDetailView.center = APP_DELEGATE.window.center;
        pkMedalDetailView.bounds = [UIScreen mainScreen].bounds;
        pkMedalDetailView.pkMedalDetailModel = pkMedalDetailModel;
        pkMedalDetailView.closeCallback = ^(MXRPKMedalDetailView *medalDetailView) {
            [medalDetailView removeFromSuperview];
        };
        pkMedalDetailView.medalPromptButtonCallback = ^(MXRPKMedalDetailModel *medalDetailMode, MXRPKMedalDetailView *medalDetailView) {
            if (medalDetailMode.isHold) {
                [medalDetailView removeFromSuperview];
            }else {
                [medalDetailView removeFromSuperview];
                if (medalDetailMode.skipToQaClassifyId == 0) {
                    [selfWeak.navigationController popViewControllerAnimated:YES];
                }else {
                    MXRPKQuestionListViewController *vc = [[MXRPKQuestionListViewController alloc] init];
                    vc.categoryId = medalDetailMode.skipToQaClassifyId;
//                    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
                }
            }
        };
        
//        [APP_DELEGATE.window addSubview:pkMedalDetailView];
    };
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionVi5ew layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH_DEVICE/4, SCREEN_WIDTH_DEVICE/4);
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
