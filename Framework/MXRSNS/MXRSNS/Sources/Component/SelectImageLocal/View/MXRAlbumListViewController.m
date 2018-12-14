//
//  MXRSecondSelectImageViewController.m
//  xuanquTupian
//
//  Created by yuchen.li on 16/8/24.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import "MXRAlbumListViewController.h"
#import "MXRGetLocalImageController.h"
#import "MXRSelectLocalImageProxy.h"
#import "MXRLocalAlbumModel.h"
#import "MXRImageInformationModel.h"
#import "MXRSelectImageLocalViewController.h"
#import "MXRALbumInformationCell.h"
#import "Masonry.h"
@interface MXRAlbumListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *bgTabview;

@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger mediaType;
@property (nonatomic, copy  ) void (^completionHandler)(NSMutableArray *imageInfoArray) ;;

@end

@implementation MXRAlbumListViewController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (instancetype)initWithMediaType:(PHAssetMediaType)mediaType operationType:(MXRSelctImageOperationType)operationType completionHandler:(void (^)(NSMutableArray *))completionHandler
{
    if (self = [super init]) {
        _mediaType = mediaType;
        _operationType = operationType;
        _completionHandler = completionHandler;
    }
    return self;
}

- (instancetype)initForDIYMaxCount:(NSInteger)maxCount  mediaType:(PHAssetMediaType)mediaType completionhandler:(void (^)(NSMutableArray *))completionHandler
{
    if (self = [super init]) {
        _operationType = MXRSelctImageOperationTypeDIY;
        _maxCount = maxCount;
        _mediaType = mediaType;
        self.completionHandler = completionHandler;
    }
    return self;
}

-(BOOL)shouldAutorotate{
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];

    // add by martin 5.8.0
    [self.bgTabview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hideBackButton = YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if ([MXRSelectLocalImageProxy getInstance].totalAlbumDataArray.count == 0) {
        [[MXRGetLocalImageController getInstance]getAlbumInformationMediaType:PHAssetMediaTypeImage];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)dealloc{
    DLOG_METHOD;
    [[MXRSelectLocalImageProxy getInstance]resetAllAlbumArrayData];
    [[MXRSelectLocalImageProxy getInstance] removeAllImageInfoModelArrayData];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark--UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [MXRSelectLocalImageProxy getInstance].totalAlbumDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellId=@"cellID";
    MXRALbumInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"MXRALbumInformationCell" owner:self options:nil]lastObject];
    }
    MXRLocalAlbumModel *model = [MXRSelectLocalImageProxy getInstance].totalAlbumDataArray[indexPath.row];
    cell.thumbImage.image = model.imageObject;
    cell.thumbImage.contentMode = UIViewContentModeScaleToFill;
    cell.detailLabel.attributedText = [self getAlbumDescription:model];
    cell.seperateLabelHeightContrain.constant = 0.6;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MXRLocalAlbumModel *model = [MXRSelectLocalImageProxy getInstance].totalAlbumDataArray[indexPath.row];
    @MXRWeakObj(self);
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        [[MXRGetLocalImageController getInstance] getIamgeByGroup:model.group WithCallBack:^(BOOL isOkay) {
            if (isOkay) {
                MXRSelectImageLocalViewController* VC = [[MXRSelectImageLocalViewController alloc]init];
                [selfWeak.navigationController pushViewController:VC animated:YES];
                selfWeak.navigationController.title = model.albumName;
            }
        }];
    }else{
        MXRLocalAlbumModel *albumModel = [MXRSelectLocalImageProxy getInstance].totalAlbumDataArray[indexPath.row];
        [[MXRSelectLocalImageProxy getInstance]removeAllImageInfoModelArrayData];
        MXRImageInformationModel *imageModel;
        for (PHAsset *asset in albumModel.fetchResult) {
               // 筛选PHAsset
            if (asset.mediaType ==  self.mediaType) {
                imageModel = [[MXRImageInformationModel alloc]initWithImage:nil WithAsset:asset WithIsLastSelectImage:YES withIsAddCamera:YES];
                [[MXRSelectLocalImageProxy getInstance].imageInfoModelArray addObject:imageModel];
            }
        }
        MXRImageInformationModel *thunModel=[MXRSelectLocalImageProxy getInstance].imageInfoModelArray.firstObject;
        //跳转
        if (thunModel.isAddCamera ) {
            MXRSelectImageLocalViewController*VC;
            //梦想圈
            if (self.operationType == MXRSelctImageOperationTypeBookSNS) {
                VC = [[MXRSelectImageLocalViewController alloc]initWithMaxCount:9 mediaType:self.mediaType operationType:MXRSelctImageOperationTypeBookSNS albumModel:model bookGuid:nil completion:self.completionHandler];
                 if ([MXRSelectLocalImageProxy getInstance].isAddCamera) [[MXRSelectLocalImageProxy getInstance]addCameraPhotoItem];
            //图片分享
            }else if (self.operationType == MXRSelctImageOperationTypeShare){
                //根本不会进来
                VC = [[MXRSelectImageLocalViewController alloc]initWithMaxCount:9 mediaType:self.mediaType operationType:MXRSelctImageOperationTypeShare albumModel:model bookGuid:nil completion:self.completionHandler];
                VC.hideBackButton = YES;
            //DIY 私信
            }else if (self.operationType == MXRSelctImageOperationTypeDIY){
                VC = [[MXRSelectImageLocalViewController alloc]initWith:self.maxCount mediaType:self.mediaType albumModel:model operationType:self.operationType  completionhandler:self.completionHandler];
              
                if ([MXRSelectLocalImageProxy getInstance].isAddCamera) [[MXRSelectLocalImageProxy getInstance]addCameraPhotoItem];
            }else{
                DLOG(@"未知相册功能");
            }
            [selfWeak.navigationController pushViewController:VC animated:YES];
            selfWeak.navigationController.title = model.albumName;
        }
    }
}

-(void)cancelClickToreturn{
    [self dismissViewControllerAnimated:YES completion:^{
        [[MXRSelectLocalImageProxy getInstance]resetAllAlbumArrayData];
        [[MXRSelectLocalImageProxy getInstance]removeAllImageInfoModelArrayData];
    }];
}
-(void)setUp{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.bgTabview.delegate   = self;
    self.bgTabview.dataSource = self;
    self.bgTabview.rowHeight  = 60;
    self.bgTabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *cancelBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [cancelBtn addTarget:self action:@selector(cancelClickToreturn) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:MXRLocalizedString(@"COLOREGG_BUY_ALERT_CANCEL",  @"取消") forState:UIControlStateNormal];
    [cancelBtn setTitleColor:MXRNAVIBARTINTCOLOR forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = MXRNAVIBARITEMFONT;
    
    UIBarButtonItem *barItem =[[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    [self setNavTitleLabelText:MXRLocalizedString(@"MXRQRScanViewController_Album", @"相册")];
    // 剔除 相册中 照片为 0 的相册
    [[MXRSelectLocalImageProxy getInstance] selectAlbumCountNoneZero];
}

- (NSMutableAttributedString *)getAlbumDescription:(MXRLocalAlbumModel *)albumModel
{
    NSString *countStr;
    if (self.mediaType == PHAssetMediaTypeImage || self.mediaType == PHAssetSourceTypeNone) {
        countStr = [NSString stringWithFormat:@"  (%ld)",(long)albumModel.imageTotalCount];
    }else{
        countStr = [NSString stringWithFormat:@"  (%ld)",(long)albumModel.videoTotalCount];
    }
    NSDictionary *colordict = @{NSForegroundColorAttributeName:RGB(179, 179, 179)};
    NSAttributedString *countMutaStr = [[NSAttributedString alloc]initWithString:countStr attributes:colordict];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@", albumModel.albumName]];
    [attributeString appendAttributedString:countMutaStr];
    return  attributeString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
