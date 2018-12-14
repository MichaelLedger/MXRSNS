//
//  MXRPKPropShopViewController.m
//  huashida_home
//
//  Created by MountainX on 2018/10/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKPropShopViewController.h"
#import "MXRPKNetworkManager.h"
#import "MXRPKPropShopTableViewCell.h"
#import "MXRPKPropHeader.h"
#import "MXRPKPropSectionHeader.h"
#import "MXRPKPropSectionFooter.h"
#import "MXRPKPropPurchaseViewController.h"
#import "SDWebImageManager.h"
#import "MXRPKChallengeShareView.h"
//#import "MXRNewShareView.h"
#import "GlobalBusyFlag.h"
#import "Notifications.h"

@interface MXRPKPropShopViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MXRPKPropShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = MXRLocalizedString(@"MXR_Prop_Title", @"道具商店");
    
    [self configTableView];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gainProp) name:Notification_Share_Success object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_Share_Success object:nil];
}

- (void)configTableView {
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    @MXRWeakObj(self);
    MXRPKPropHeader *tableHeader = [MXRPKPropHeader header];
    tableHeader.shareBlock = ^(UIButton *btn) {
        [selfWeak shareBtnClicked:btn];
    };
    self.mainTableView.tableHeaderView = tableHeader;
}

- (void)loadData {
    //V5.16.0 要求一页加载完毕
    @MXRWeakObj(self);
    [[GlobalBusyFlag sharedInstance] showBusyFlagOnWindow];
    [MXRPKNetworkManager fetchPropShopListWithPageNo:1 pageSize:100 Success:^(MXRPKPropShopResponseModel *pkChallengeInfo) {
        [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
        [selfWeak.dataArray removeAllObjects];
        [pkChallengeInfo.list enumerateObjectsUsingBlock:^(MXRPKPropShopModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [selfWeak.dataArray addObject:obj];
        }];
        [selfWeak.mainTableView reloadData];
    } failure:^(MXRServerStatus status, id result) {
        [[GlobalBusyFlag sharedInstance] hideBusyFlagOnWindow];
        [selfWeak showNetworkErrorWithRefreshCallback:^{
            [selfWeak loadData];
        }];
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

static NSString *cellIdentifier = @"PKPropShopCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MXRPKPropShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MXRPKPropShopTableViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        @MXRWeakObj(self);
        cell.purchaseBlock = ^(MXRPKPropShopModel *model) {
            [selfWeak purchaseProp:model];
        };
    }
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MXRPKPropSectionHeader *sectionHeader = [MXRPKPropSectionHeader sectionHeader];
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MXRPKPropSectionFooter *sectionFooter = [MXRPKPropSectionFooter sectionFooter];
    return sectionFooter;
}

#pragma mark - Lazy Loader
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - Events
- (void)purchaseProp:(MXRPKPropShopModel *)shopModel {
    MXRPKPropPurchaseViewController *vc = [[MXRPKPropPurchaseViewController alloc] init];
    vc.shopModel = shopModel;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:NO completion:^{
        
    }];
}

#pragma mark - 分享获取道具
-  (void)gainProp {
    [MXRPKNetworkManager challengeShareWithType:2 Success:^(MXRNetworkResponse *response) {
        if (response.isSuccess && response.body) {
            NSDictionary *dict = response.body;
            NSInteger reliveCardNum = [[dict objectForKey:@"reliveCardNum"] integerValue];
            NSInteger removeWrongCardNum = [[dict objectForKey:@"removeWrongCardNum"] integerValue];
            if (reliveCardNum > 0 || removeWrongCardNum > 0) {
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

- (void)shareBtnClicked:(UIButton *)btn {
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
