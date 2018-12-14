//
//  MXRSelectImageLocalViewController.m
//  xuanquTupian
//
//  Created by yuchen.li on 16/8/24.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import "MXRSelectImageLocalViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "MXRSelecImageLocalCell.h"
#import "MXRSelectLocalImageProxy.h"
#import "MXRLocalAlbumModel.h"
#import "MXRImageInformationModel.h"
#import "MXRGetLocalImageController.h"
#import "MXRPreViewViewController.h"
//#import "MXRPromptView.h"
#import "GlobalBusyFlag.h"
#import "UICollectionView+Convenience.h"
#import "NSIndexSet+Convenience.h"
#import "MXRCopySysytemActionSheet.h"
#import "UIImage+Extend.h"
//#import "MXRNewShareView.h"
#import "MXRMediaUtil.h"
#import "MXRPhotoPreviewGuideView.h"
//#import "MXRUnityMessageHelper.h"
#import "Masonry.h"

#define LINE_SPACE 0 //(4.5 / 375.0 * SCREEN_WIDTH_DEVICE_ABSOLUTE -1)
#define CELL_ID  @"MXRSelecImageLocalCellID"
@interface MXRSelectImageLocalViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MXRSelectImageLocalCellPrepareToSendDelegate,MXRPreViewViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *myLayout;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarRightItem;                  // 右边按钮
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarLeftItem;                   // 左边按钮
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarSelectNumberItem;
@property (nonatomic, strong) NSMutableArray <MXRImageInformationModel*>*imageModelDataArray; // 分享时的数据源
@property (nonatomic, strong) NSString * shareBookGuid;                                 // 图书分享的bookGuid
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) UIButton *deleteBtn;                                      // 删除按钮
@property (nonatomic, strong) UIButton *shareBtn;                                       // 分享按钮
@property (nonatomic, strong) UIButton *cancelBtn;                                      // 取消按钮
@property (nonatomic, strong) UILabel  *finishLabel;                                    // "完成"
@property (nonatomic, strong) UILabel  *selectNumberLabel;                              // 选中数量

@property (nonatomic, strong) CABasicAnimation *zoomInOutAnimation;                     // 选中数量缩放动画

@property (nonatomic, strong) MXRCopySysytemActionSheet *shareRelatedSheet;
@property (nonatomic, strong) MXRLocalAlbumModel *model;                                // 上次选择的相册信息 梦想圈使用
//@property (nonatomic, strong) MXRPromptView *selectTooMuchPrompt;
@property (nonatomic, assign) PHAssetMediaType mediaType;
@property (nonatomic, strong) PHFetchResult     *result ;
@property (nonatomic, copy) void (^completionHandler)(NSMutableArray *imageInfoArray) ;

@property CGRect previousPreheatRect;
@end

@implementation MXRSelectImageLocalViewController
static CGSize AssetGridThumbnailSize;
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
-(BOOL)shouldAutorotate{
    return NO;
}


- (instancetype)initWithMaxCount:(NSInteger)maxCount mediaType:(PHAssetMediaType)mediaType operationType:(MXRSelctImageOperationType)operationType albumModel:(MXRLocalAlbumModel *)albumModel bookGuid:(NSString *)bookGuid completion:(void (^)(NSMutableArray *))completion
{
    if (self = [super init]) {
        _model = albumModel;
        _result = albumModel.fetchResult;
        _shareBookGuid = bookGuid;
        _assetCollection = albumModel.assetCollection;
        _operationType = operationType;
        _mediaType = mediaType;
        _completionHandler = completion;
        [[MXRSelectLocalImageProxy getInstance] setMXRMaxCount:maxCount];
        [[MXRSelectLocalImageProxy getInstance] setBookSNSAlbumModelWith:albumModel];
    }
    return self;
}

- (instancetype)initWith:(NSInteger)maxCount mediaType:(PHAssetMediaType)mediaType albumModel:(MXRLocalAlbumModel *)albumModel operationType:(MXRSelctImageOperationType)operationType completionhandler:(void (^)(NSMutableArray *))completionHandler
{
    if (self = [super init]) {
        _operationType = operationType;
        _model = albumModel;
        _result = albumModel.fetchResult;
        _mediaType = mediaType;
        [[MXRSelectLocalImageProxy getInstance] setMXRMaxCount:maxCount];
        self.completionHandler = completionHandler;
    }
    return self;
}

-(void)dealloc{
    DLOG_METHOD;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewInformation];
    [self addNotificationObservers];
    [self setMyNavigation];
    [self setupImageCacheManage];
    self.imageModelDataArray = [[MXRSelectLocalImageProxy getInstance].imageInfoModelArray mutableCopy];
    // add by martin 5.8.0
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBottomToolBarItemTitle];      // 时时检查状态
    // 分享时 需要时时保证 数据源数据和单例里面的数据一致
    if (self.imageModelDataArray.count > 0)   [[MXRSelectLocalImageProxy getInstance] setThunMailDataArrayWith:[self.imageModelDataArray mutableCopy]];
    if (self.operationType == MXRSelctImageOperationTypeShare)     [self showGuideView];
    
    [self.imageCollectionView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (IOS8_OR_LATER) {
        [self updateCachedAssets];
    }
}

#pragma mark -- UICollectionView 代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return self.imageModelDataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.imageModelDataArray.count >= indexPath.row ){
        MXRSelecImageLocalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
        MXRImageInformationModel *model = [self.imageModelDataArray objectAtIndex:indexPath.row];
        if (!model.isAddCamera) {
            cell.delegate = self;
            cell.backgroundColor = RGB(126, 126, 126);
            cell.timeContainerView.hidden = YES;
            cell.imageInfoModel = model;
            return cell;
        }else {
            if (IOS8_OR_LATER) {
                PHAsset *asset = self.imageModelDataArray[indexPath.row].asset;
                if (asset.mediaType == PHAssetMediaTypeImage) {
                    cell.timeContainerView.hidden = YES;
                }else{
                    cell.timeContainerView.hidden = NO;
                }     
                [self setUpCellWithManager:self.imageManager Asset:asset Cell:cell];
                cell.imageInfoModel = model;
                return cell;
            }else{
                //ios7
                cell.delegate = self;
                [cell configureCellWithModelSystermSeven:model];
                return cell;
            }
        }
    }
    UICollectionViewCell*cell=[[UICollectionViewCell alloc]init];
    return cell;
}
-(void)setUpCellWithManager:(PHCachingImageManager*)manager Asset:(PHAsset*)asset Cell:(MXRSelecImageLocalCell*)cell{
    [manager requestImageForAsset:asset targetSize: CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result)  cell.bgImageView.image = result;
    }];
    cell.delegate = self;
    cell.backgroundColor = RGB(126, 126, 126);
}
// 设置每个View的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemWH = ([UIScreen mainScreen].bounds.size.width - LINE_SPACE * 2) / 3.0 ;
    return CGSizeMake(itemWH, itemWH);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return LINE_SPACE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return LINE_SPACE;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item >= 1) {
        if (self.operationType == MXRSelctImageOperationTypeDIY && self.mediaType == PHAssetMediaTypeVideo) {
            DLOG(@"DIY视频 不跳 视频 预览页");
        }else{
            
            [self pushViewToPreviewController:indexPath mediaType:self.mediaType];
        }
    }else{
        //分享 照片,视频   不跳相机
        if (self.operationType == MXRSelctImageOperationTypeShare) {
            [self pushViewToPreviewController:indexPath mediaType:self.mediaType];
        }else{
            if ([[MXRGetLocalImageController getInstance]getSelectImageCount] >= [MXRSelectLocalImageProxy getInstance].maxCount) {
//                [self.selectTooMuchPrompt showInLastViewController];
                return;
            }
            
            MXRImageInformationModel *imageModel = self.imageModelDataArray[indexPath.row];
            if (! imageModel.isAddCamera) {
                //有可能和unity用了同一个摄像头，所以需要关闭
//                [MXRUnityMessageHelper unityStopCamNoRestartSence];
                [self useSystermCameraFunctionType:self.mediaType];
            }else{
                if (self.operationType == MXRSelctImageOperationTypeDIY && self.mediaType == PHAssetMediaTypeVideo) {
                    DLOG(@"DIY视频 不跳视频预览页");
                }else{
                    [self pushViewToPreviewController:indexPath mediaType:self.mediaType];
                }
            }
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateCachedAssets];
}

/**
 缓存管理者 PHOTOKIT
 */
- (void)setupImageCacheManage
{
    if (IOS8_OR_LATER) {
        [self resetCachedAssets];
        self.imageManager = [[PHCachingImageManager alloc] init];
        if (!self.result) {
            self.result = self.model.fetchResult;
        }
    }
}

#pragma mark - MXRNewShareViewDelegate 的代理方法
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
#pragma mark--MXRPreViewViewController代理
-(void)goToDismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark---MXRSelectImageLocalCellPrepareToSendDelegate代理
-(void)userPrepareToSendWithCount:(NSInteger)count
{
    if (self.operationType == MXRSelctImageOperationTypeShare) {
        [self changeShareAndDeleteBtnStateIfNeeded];
    }else{
        [self changeConfirmOrSendItemStateIfNeeded];
    }
    if ([MXRSelectLocalImageProxy getInstance].maxCount == 1) {
        
        
    }else{
        // 查找 需要更新的item
        NSMutableArray *indexPathArray = [[NSMutableArray alloc]init];
        @MXRWeakObj(self);
        [[MXRSelectLocalImageProxy getInstance].preSelectImageModelArray enumerateObjectsUsingBlock:^(MXRImageInformationModel * _Nonnull preObj, NSUInteger idx, BOOL * _Nonnull stop) {
            [selfWeak.imageModelDataArray enumerateObjectsUsingBlock:^(MXRImageInformationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([preObj.asset.localIdentifier isEqualToString:obj.asset.localIdentifier]) {
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                    [indexPathArray addObject:indexPath];
                    *stop = YES;
                }
            }];
        }];
        if (indexPathArray.count>0) {
            [UIView performWithoutAnimation:^{
                [self.imageCollectionView reloadItemsAtIndexPaths:indexPathArray];
            }];
        }

    }
}

- (void)haveSelectImageWithIndexPathArray:(NSArray *)indexPathArray
{
    // 解决全部刷新闪烁的 问题
    if ([MXRSelectLocalImageProxy getInstance].maxCount == 1) {
        if (indexPathArray.count > 0) {
            [self.imageCollectionView reloadItemsAtIndexPaths:indexPathArray];
        }
    }
}

/**
 选择的图片多于选择数    代理方法
 */
//-(void)userHaveSelectTooMuchImage{
//    [self.selectTooMuchPrompt showInLastViewController];
//}

#pragma mark--UIImagePickerController代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (picker.cameraCaptureMode == UIImagePickerControllerCameraCaptureModePhoto) {
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        @MXRWeakObj(self);
        [[MXRGetLocalImageController getInstance]saveImageToAllImageAlbumWithImage:image CompletionHandler:^(BOOL isOkay) {
            if (isOkay) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [selfWeak setupLastSelectAlbumInformationAndSaveImageInformationModel:image];
                });
            }else{
                DLOG(@"保存图片出错");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:NO completion:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                });
            }
        }];
    }else{
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *urlPath = [url path];
        @MXRWeakObj(self);
        // 保存到 4D 相册
        [[MXRGetLocalImageController getInstance]saveVideoToAlbumWithAlbumName:MXRLocalizedString(@"WZYShare_4DStore", @"4D书城") videoPath:urlPath completion:^(BOOL success) {
            if (success) {
                DLOG(@"保存视频成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlPath)) {
                        [selfWeak setupLastSelectAlbumInformationAndSaveVideoInfomation:url];
                    }
                });
            }else{
                DLOG(@"保存视频失败");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:NO completion:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                });
            }
        }];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 私有方法
/**
 使用系统相机 拍照 录视频
 */
- (void)useSystermCameraFunctionType:(PHAssetMediaType)mediaType
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.delegate = self;
    if (mediaType == PHAssetMediaTypeVideo) {
        NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        pickerController.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
    }else{
       // pickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }
    @MXRWeakObj(self);
    [MXRMediaUtil checkCameraVideoAuthorityCallBack:^(BOOL isAuthority) {
        if(isAuthority){
            [selfWeak presentViewController:pickerController animated:YES completion:nil];
        }else{
            return ;
        }
    }];
}

/**
 进入到预览界面
 */
- (void)pushViewToPreviewController:(NSIndexPath *)indexPath  mediaType:(PHAssetMediaType)mediaType
{
    MXRPreViewViewController *previewVC;
    //分享
    if (self.operationType == MXRSelctImageOperationTypeShare || self.operationType == MXRSelctImageOperationTypeBookSNS) {
        
        previewVC = [[MXRPreViewViewController alloc]initWithIndexPath:indexPath mediaType:self.mediaType shareBookGuid:self.shareBookGuid operationType:self.operationType completionHandler:self.completionHandler];
        previewVC.imageModelDataArray = self.imageModelDataArray;
        
    // DIY 私信
    }else if(self.operationType == MXRSelctImageOperationTypeDIY){
        if (self.imageModelDataArray.count > indexPath.row) {
            MXRImageInformationModel *imageModel = self.imageModelDataArray[indexPath.row];
            if (imageModel.asset.mediaType == mediaType ) {
                previewVC = [[MXRPreViewViewController alloc]initForDIYIndexPath:indexPath mediaType:self.mediaType completionHandler:self.completionHandler];
                previewVC.imageModelDataArray = self.imageModelDataArray;
            }else{
                DLOG(@"视频不需要预览功能");
            }
        }else{
            DERROR(@"无效点击");
        }
    }
    previewVC.delegate = self;
    previewVC.lastAlbumInfoModel = self.model;
    [self.navigationController pushViewController:previewVC animated:YES];
}


/**
 查找相册中第一个视频

 @param url
 */
- (void)setupLastSelectAlbumInformationAndSaveVideoInfomation:(NSURL *)url
{
    [[MXRSelectLocalImageProxy getInstance]setupLastSelectAlbumInfoAndAddVideoToPreselectImageModelArray:url];
    MXRImageInformationModel *model = [MXRSelectLocalImageProxy getInstance].preSelectImageModelArray[0]; //获取第一个
    [[MXRGetLocalImageController getInstance]getVideoFromAlbumWithPHAsset:model completionHandler:^(BOOL isOkay) {
        NSMutableArray *finalVideoDataArray = [[NSMutableArray alloc]init];
        if (isOkay) {
            [finalVideoDataArray addObject:model.videoData];
        }else{
            DLOG(@"获取视频数据失败");
        }
        if (self.completionHandler) self.completionHandler(finalVideoDataArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:NO completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        });
    }];
}


/**
 查找 所有照片 相册中的第一个图片

 @param image 拍照 获取的图片
 */
- (void)setupLastSelectAlbumInformationAndSaveImageInformationModel:(UIImage *)image {
    // 获得胶卷相机的相册
    [[MXRSelectLocalImageProxy getInstance]setupLastSelectAlbumInfoAndAddImageToPreselectImageModelArray:image];
    NSMutableArray *finalImageArray = [[NSMutableArray alloc]init];
    [[MXRSelectLocalImageProxy getInstance].preSelectImageModelArray enumerateObjectsUsingBlock:^(MXRImageInformationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [finalImageArray addObject:obj.assetImage];
    }];
    
    if(self.completionHandler) self.completionHandler(finalImageArray);
    // 用照相机拍照后，清空已选择照片数组
    [[MXRSelectLocalImageProxy getInstance]becomeImagestateToUncheck];
    [[MXRSelectLocalImageProxy getInstance]removeAllPreselectImageInfoModelData];
    @MXRWeakObj(self);
    [self dismissViewControllerAnimated:NO completion:^{
        [selfWeak dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark--初始化设置
- (void)setupViewInformation
{
     self.imageModelDataArray = [[MXRSelectLocalImageProxy getInstance].imageInfoModelArray mutableCopy];
     self.automaticallyAdjustsScrollViewInsets = NO;
     self.view.backgroundColor = [UIColor whiteColor];
    
     self.imageCollectionView.delegate   = self;
     self.imageCollectionView.dataSource = self;
     self.imageCollectionView.backgroundColor = [UIColor whiteColor];
    [self.imageCollectionView registerNib:[UINib nibWithNibName:@"MXRSelecImageLocalCell" bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:CELL_ID];
    //私信,梦想圈
    if (self.operationType != MXRSelctImageOperationTypeShare) {
        [self.toolBarRightItem setCustomView:self.finishLabel];
        [self.toolBarSelectNumberItem setCustomView:self.selectNumberLabel];
         self.toolBarLeftItem.enabled = NO;                                 // 左边按钮失效
    }else{
        [self.toolBarLeftItem  setCustomView:self.shareBtn];
        [self.toolBarRightItem setCustomView:self.deleteBtn];
        [self changeShareAndDeleteBtnStateIfNeeded];
    }
    //获取每个缩略图的大小
    CGFloat scale   = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.myLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
}

- (void)addNotificationObservers
{
    if (self.operationType == MXRSelctImageOperationTypeShare) {
        //分享中 删除图片完成通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goToReloadData) name:Notification_Go_To_Reload_Data_After_Delete object:nil];
        //分享中 分享图片到梦想圈通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goToReloadData) name: Notification_MXRSelectImageLocal_ReloadData object:nil];
    }
}

/**
 更换 确定 或者 发送 按钮的状态
 */
- (void)changeConfirmOrSendItemStateIfNeeded
{
    NSInteger count = [MXRSelectLocalImageProxy getInstance].preSelectImageModelArray.count;
    if (count == 0) {
        self.selectNumberLabel.hidden = YES;
        self.toolBarRightItem.enabled = NO;
    }else{
        self.selectNumberLabel.hidden = NO;
        self.selectNumberLabel.text = [NSString stringWithFormat:@"%ld",count];
        [self.selectNumberLabel.layer addAnimation:self.zoomInOutAnimation forKey:@"zoomInOut"];
        self.toolBarRightItem.enabled = YES;
    }
}

/**
 更换 分享 删除 按钮的状态
 */
-(void)changeShareAndDeleteBtnStateIfNeeded
{
    if (self.operationType == MXRSelctImageOperationTypeShare) {
        if ([MXRSelectLocalImageProxy getInstance].preSelectImageModelArray.count == 1) {
            self.shareBtn.enabled  = YES;
            self.deleteBtn.enabled = YES;
        }else if([MXRSelectLocalImageProxy getInstance].preSelectImageModelArray.count == 0){
            self.shareBtn.enabled  = NO;
            self.deleteBtn.enabled = NO;
        }else{
            self.shareBtn.enabled  = NO;
            self.deleteBtn.enabled = YES;
        }
    }
}

/**
 设置导航
 */
-(void)setMyNavigation
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancelBtn];
      if(!self.model.albumName ){
        [self setNavTitleLabelText:MXRLocalizedString(@"Recently_Add",@"最近添加")];
    }else{
        [self setNavTitleLabelText:self.model.albumName];
    }

    NSDictionary *textAttributes = @{NSFontAttributeName : NAVI_TITLE_FONT,
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    self.navigationController.navigationBar.barTintColor = MXRCOLOR_2FB8E2;
}
/**
 设置底部按钮的标题
 */
-(void)setBottomToolBarItemTitle
{
    //私信和梦想圈
    if (self.operationType != MXRSelctImageOperationTypeShare) {
        [self changeConfirmOrSendItemStateIfNeeded];
        //分享
    }else{
        [self changeShareAndDeleteBtnStateIfNeeded];
    }
}

/**
 重置缓存的asset
 */
- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

/**
 * 删除图片之后,刷新UI
 */
-(void)goToReloadData{
    [self becomeImageStateToUncheck];
    [self.imageCollectionView reloadData];
}
/**
 * 使图片变为未选中状态
 */
-(void)becomeImageStateToUncheck{
    if (self.imageModelDataArray.count > 0) {
        for (MXRImageInformationModel *model in self.imageModelDataArray) {
            [model.dic setObject:@"0" forKey:@"flga"];
            [model setSelectOrderWith:0];
        }
    }

}
/**
 * 分享的时候，第一次打开显示分享到梦想圈引导图
 */
-(void)showGuideView{
    if ([MXRPhotoPreviewGuideView checkIsNeedShow]) {
        MXRPhotoPreviewGuideView *guide = [MXRPhotoPreviewGuideView photoPreviewGuideView];
        [guide tryShowBookStoreGuide];
    }
}
#pragma mark --发送
-(void)sendClick{
    if (self.mediaType == PHAssetMediaTypeImage) {
        BOOL isValid = [[MXRGetLocalImageController getInstance]checkSelectedPHAssetInfoIsValid];
        if (isValid) {
            self.finishLabel.userInteractionEnabled = NO;
            NSMutableArray *finalImageArray = [[NSMutableArray alloc]init];
            [[MXRSelectLocalImageProxy getInstance].preSelectImageModelArray enumerateObjectsUsingBlock:^(MXRImageInformationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [finalImageArray addObject:obj.assetImage];
            }];
            if (self.completionHandler) self.completionHandler(finalImageArray);
            [self dismissViewControllerAnimated:NO completion:^{
                [[MXRSelectLocalImageProxy getInstance]becomeImagestateToUncheck];
                [[MXRSelectLocalImageProxy getInstance]removeAllPreselectImageInfoModelData];
            }];
        }
    }else if(self.mediaType == PHAssetMediaTypeVideo){
        BOOL isValid = [[MXRGetLocalImageController getInstance]checkSelectedPHAssetInfoIsValid];
        if (isValid) {
            self.finishLabel.userInteractionEnabled = NO;
            @MXRWeakObj(self);
            if ([MXRSelectLocalImageProxy getInstance].preSelectImageModelArray.count > 0) {
                MXRImageInformationModel *imageInfoModel = [MXRSelectLocalImageProxy getInstance].preSelectImageModelArray[0];
                [[MXRGetLocalImageController getInstance]getVideoFromAlbumWithPHAsset:imageInfoModel completionHandler:^(BOOL isOkay){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableArray *finalVideoDataArray = [[NSMutableArray alloc]init];
                        [finalVideoDataArray addObject:imageInfoModel.videoData];
                        self.completionHandler ? self.completionHandler(finalVideoDataArray) : nil ;
                        [selfWeak dismissViewControllerAnimated:NO completion:^{
                            [[MXRSelectLocalImageProxy getInstance]becomeImagestateToUncheck];
                            [[MXRSelectLocalImageProxy getInstance]removeAllPreselectImageInfoModelData];
                        }];
                    });
                }];
                
            }
        }
    }else if(self.mediaType == PHAssetMediaTypeUnknown){
        DLOG(@"MediaTypeUnknown");
    
    }else{
        DLOG(@"MediaTypeAudio");
    }
}
#pragma mark -- 点击 返回
/**
 * MXRNavigationController的返回事件
 */
-(void)backAction:(id)sender{
    [self.imageCollectionView removeFromSuperview];
    self.imageCollectionView = nil;
    [[MXRSelectLocalImageProxy getInstance]removeAllImageInfoModelArrayData];
    [[MXRSelectLocalImageProxy getInstance]removeAllPreselectImageInfoModelData];

    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark--取消
-(void)cancelClickToreturn{
    @MXRWeakObj(self);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[MXRSelectLocalImageProxy getInstance]removeAllImageInfoModelArrayData];
        if (self.operationType == MXRSelctImageOperationTypeShare)  [selfWeak.imageModelDataArray removeAllObjects];
        [[MXRSelectLocalImageProxy getInstance] removeAllPreselectImageInfoModelData];
    }];
}
#pragma mark--ShareRelated相关
/**
 删除 4D书城相册中选中的图片
 */
-(void)deleteImageFromAlbum{
    if (self.operationType == MXRSelctImageOperationTypeShare) {
        NSInteger selectCount = [MXRSelectLocalImageProxy getInstance].preSelectImageModelArray.count;
        if (selectCount >= 1)  [self.shareRelatedSheet show];
    }
}
/**
 分享 4D书城相册中的图片或者视频
 */
-(void)shareButtonClick:(id)sender{
    [MXRClickUtil event:@"pressTakePhotoShare"];
    if (self.operationType == MXRSelctImageOperationTypeShare) {
        NSInteger selectCount = [MXRSelectLocalImageProxy getInstance].preSelectImageModelArray.count;
        if(selectCount == 1){
            MXRImageInformationModel *imageInfoModel = [MXRSelectLocalImageProxy getInstance].preSelectImageModelArray[0];
            if (imageInfoModel.asset.mediaType == PHAssetMediaTypeVideo) {
                [self goToShareVideo:imageInfoModel];
            }else if(imageInfoModel.asset.mediaType == PHAssetMediaTypeImage){
                [self goToShareImage:imageInfoModel];
            }else{
                DLOG(@"未识别 PHAsset类型");
            }
        }
    }
}
#pragma mark--分享视频
-(void)goToShareVideo:(MXRImageInformationModel *)imageInfoModel
{
//    if (!imageInfoModel) return;
//    @MXRWeakObj(self);
//    [[MXRGetLocalImageController getInstance]getVideoFromAlbumWithPHAsset:imageInfoModel completionHandler:^(BOOL isOkay) {
//        if (isOkay) {
//            if (!imageInfoModel.assetImage) [imageInfoModel setAssetImageWith:MXRIMAGE(@"icon_common_bookIconPlaceholder")];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (!imageInfoModel.videoData) {
//                    DLOG(@"分享视频出错");
//                    return ;
//                }
//                MXRNewShareView *shareView = [[MXRNewShareView alloc]initWithTitle:@"" andShareVideo:imageInfoModel.videoData  andVideoThumbnailImage:imageInfoModel.assetImage andShareSource:MXRShareSourceTypeFromUnity];
//                shareView.delegate = selfWeak;
//                [shareView showInView:self.view];
//            });
//        }else{
//            DLOG(@"分享视频出错");
//        }
//    }];

}
#pragma mark--分享图片
-(void)goToShareImage:(MXRImageInformationModel *)imageInfoModel
{
    if (!imageInfoModel) return;
//    if (!imageInfoModel.assetImage) [imageInfoModel setAssetImageWith:MXRIMAGE(@"icon_common_bookIconPlaceholder")];
//    MXRNewShareView * shareView = [[MXRNewShareView alloc] initWithTitle:@"" andShareImage:imageInfoModel andShareSource:MXRShareSourceTypeFromUnity anShareBookGuid:self.shareBookGuid];
//     shareView.delegate = self;
//    [shareView showInView:self.view];
}

#pragma mark -- MXRCopySysytemActionSheet 代理  --删除图片
- (void)actionSheetNew:(MXRCopySysytemActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        @MXRWeakObj(self);
        if (IOS8_OR_LATER && self.operationType == MXRSelctImageOperationTypeShare) {
            selfWeak.cancelBtn.enabled=NO;
            //记录有多少图片删除
            __block NSInteger deleteImageCount = [MXRSelectLocalImageProxy getInstance].preSelectImageModelArray.count;
            PHFetchResult <PHAsset *> * assetResult = [[MXRGetLocalImageController getInstance]getAllPHAssetFromPHAssetCollection:selfWeak.model.assetCollection];
            [assetResult enumerateObjectsUsingBlock:^(PHAsset * objAsset, NSUInteger idx, BOOL *stop) {
                __block MXRImageInformationModel *deleteModel;
                for (MXRImageInformationModel *model in [MXRSelectLocalImageProxy getInstance].preSelectImageModelArray) {
                    if ([model.asset.localIdentifier isEqual:objAsset.localIdentifier]) {
                        deleteModel = model;
                        [[MXRGetLocalImageController getInstance]deleteImageFromAlbumWithAsset:objAsset CompletionHandler:^(BOOL isOkay) {
                            deleteImageCount--;
                            if (deleteImageCount == 0) selfWeak.cancelBtn.enabled = YES;
                            if (isOkay) {
                                //删除完照片 刷新UI
                                dispatch_sync(dispatch_get_main_queue(), ^(){
                                    [selfWeak.imageModelDataArray removeObject:deleteModel];
                                    [[MXRSelectLocalImageProxy getInstance].preSelectImageModelArray removeObject:deleteModel];
                                    [[MXRSelectLocalImageProxy getInstance]rearrangeSelectOrder];
                                    [selfWeak.imageCollectionView reloadData];
                                    [selfWeak changeShareAndDeleteBtnStateIfNeeded];
                                });
                            }else{
                                
                            }
                        }];
                    }else{
                        
                    }
                }
            }];
        }
    }else{
        DLOG(@"取消删除图片");
    }
}

#pragma mark--MXRPromptViewDelegate 代理
//-(void)promptView:(MXRPromptView *)promptView didSelectAtIndex:(NSUInteger)index
//{
//    if([promptView isEqual:self.selectTooMuchPrompt]){
//        self.selectTooMuchPrompt = nil;//不设置为nil 再次弹的时候会 crash
//    }else{
//
//    }
//}
#pragma mark - photoKit 缓存方法
/**
 参照苹果Photokit 的 缓存方法
 */
- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    CGRect preheatRect = self.imageCollectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.imageCollectionView.bounds) / 3.0f) {
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.imageCollectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.imageCollectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching  = [self assetsAtIndexPaths:removedIndexPaths];
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        self.previousPreheatRect = preheatRect;
    }
}
- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            if (addedHandler) {
                addedHandler(rectToAdd);
            }
            
        }
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            if (addedHandler) {
                addedHandler(rectToAdd);
            }
        }
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            if (removedHandler) {
                removedHandler(rectToRemove);
            }
            
        }
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            if (removedHandler) {
                removedHandler(rectToRemove);
            }
            
        }
    } else {
        if (addedHandler) {
            addedHandler(newRect);
        }
        if (removedHandler) {
            removedHandler(oldRect);
        }
        
    }
}
- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (!IOS8_OR_LATER)         return nil;
    if (indexPaths.count == 0)  return nil;
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    [assets enumerateObjectsUsingBlock:^(PHAsset * asset, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [assets addObject:self.result[0]];
        }else{
            [assets addObject:self.result[idx-1]];
        }
    }];
    return assets;
}
#pragma mark ---Getter
-(UIButton *)deleteBtn
{
    if (!_deleteBtn) {
         _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_deleteBtn setImage:MXRIMAGE(@"btn_selectImage_delete_sel") forState:UIControlStateNormal];
        [_deleteBtn setImage:MXRIMAGE(@"btn_selectImage_delete_sel") forState:UIControlStateHighlighted];
        [_deleteBtn addTarget:self action:@selector(deleteImageFromAlbum) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

-(UIButton *)shareBtn
{
    if (!_shareBtn) {
         _shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_shareBtn  setBackgroundImage:MXRIMAGE(@"btn_selectImage_sharePic_sel") forState:UIControlStateNormal];
        [_shareBtn  setBackgroundImage:MXRIMAGE(@"btn_selectImage_sharePic_sel") forState:UIControlStateHighlighted];
        [_shareBtn addTarget:self  action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
         _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
         _cancelBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_cancelBtn setTitleColor:MXRNAVIBARTINTCOLOR forState:UIControlStateNormal];
        [_cancelBtn setTitle:MXRLocalizedString(@"COLOREGG_BUY_ALERT_CANCEL",  @"取消") forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = MXRNAVIBARITEMFONT;
        [_cancelBtn addTarget:self action:@selector(cancelClickToreturn) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn sizeToFit];
    }
    return _cancelBtn;
}

-(UILabel *)finishLabel
{
    if (!_finishLabel) {
        _finishLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 40)];
        _finishLabel.textColor = MXRCOLOR_2FB8E2;
        _finishLabel.userInteractionEnabled = YES;
        _finishLabel.textAlignment = NSTextAlignmentLeft;
        _finishLabel.text = MXRLocalizedString(@"personchildrenFoucsViewControllerFinishBtnTitle",@"完成");
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendClick)];
        [_finishLabel addGestureRecognizer:tapGest];
        [_finishLabel sizeToFit];
    }
    return _finishLabel;
}

- (UILabel *)selectNumberLabel
{
    if (!_selectNumberLabel) {
        _selectNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 20, 20)];
        _selectNumberLabel.backgroundColor = MXRCOLOR_2FB8E2;
        _selectNumberLabel.layer.cornerRadius = 10;
        _selectNumberLabel.layer.masksToBounds = YES;
        _selectNumberLabel.textAlignment = NSTextAlignmentCenter;
        _selectNumberLabel.textColor = [UIColor whiteColor];
    }
    return _selectNumberLabel;
}

-(MXRCopySysytemActionSheet *)shareRelatedSheet
{
    if (!_shareRelatedSheet) {
        _shareRelatedSheet = [[MXRCopySysytemActionSheet alloc]initWithFrame:[UIScreen mainScreen].bounds withTitle: MXRLocalizedString(@"MXRPreViewController_Delete_Image_From_Image", @"是否从相册中删除选中图片") withBtns:@[MXRLocalizedString(@"DELETE",@"删除")] withCancelBtn:MXRLocalizedString(@"CANCEL" ,@"取消") withDelegate:self];
    }
    return _shareRelatedSheet;
}

//- (MXRPromptView *)selectTooMuchPrompt
//{
//    if (!_selectTooMuchPrompt) {
//        {
//            NSString *tipString;
//            if (self.mediaType == PHAssetMediaTypeImage || self.mediaType == PHAssetSourceTypeNone) {
//                tipString = [NSString stringWithFormat:MXRLocalizedString(@"GET_IMAGE_LOCAL_NINE",@"您当前已经选择了%ld张照片了"),[MXRSelectLocalImageProxy getInstance].maxCount];
//            }else{
//                tipString = [NSString stringWithFormat:MXRLocalizedString(@"GET_VIDEO_LOCAL_NINE",@"您当前已经选择了%ld个视频了"),[MXRSelectLocalImageProxy getInstance].maxCount];
//            }
//            _selectTooMuchPrompt = [[MXRPromptView alloc]initWithTitle:MXRLocalizedString(@"MXBManager_Prompt", @"提示") message:tipString delegate:self cancelButtonTitle:MXRLocalizedString(@"KNOWALEADY",@"我知道了") otherButtonTitle:nil];
//        }
//    }
//    return _selectTooMuchPrompt;
//}

- (CABasicAnimation *)zoomInOutAnimation
{
    if (!_zoomInOutAnimation) {
        _zoomInOutAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        _zoomInOutAnimation.duration = 0.2;
        _zoomInOutAnimation.repeatCount = 1;
        _zoomInOutAnimation.autoreverses = YES;
        _zoomInOutAnimation.fromValue = [NSNumber numberWithFloat:1];
        _zoomInOutAnimation.toValue = [NSNumber numberWithFloat:1.2];
    }
    return _zoomInOutAnimation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    DLOG_METHOD
}

- (NSMutableArray<MXRImageInformationModel *> *)imageModelDataArray
{
    if (!_imageModelDataArray) {
        _imageModelDataArray = [[NSMutableArray alloc]init];
    }
    return _imageModelDataArray;
}
@end
