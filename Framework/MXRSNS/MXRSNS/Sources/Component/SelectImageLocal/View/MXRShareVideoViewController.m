//
//  MXRPreViewViewController.m
//  huashida_home
//
//  Created by yuchen.li on 16/8/29.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRShareVideoViewController.h"
#import "MXRSelectLocalImageProxy.h"
#import "MXRPreviewCell.h"
#import "MXRImageInformationModel.h"
#import "MXRGetLocalImageController.h"
//#import "MXRPromptView.h"
#import <Photos/Photos.h>
#import "GlobalBusyFlag.h"
#import "MXRLocalAlbumModel.h"
#import "UIImage+Extend.h"
#import "MXRPreviewVideoCell.h"
//#import "MXRNewShareView.h"
#import "MXRPhotoPreviewGuideView.h"
#import "MXRShowAlertView.h"


@interface MXRShareVideoViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,MXRPreViewCellDelegate,MXRPreviewVideoCellDelegate,MXRShowAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *myLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *preViewCollectionView;                           // 展示图片的UICollectionView
@property (nonatomic, strong) CABasicAnimation * rotationAnimation;                                     // loading
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) NSString * shareBookGuid;                                                 // 分享图书的bookGuid
@property (nonatomic, strong,readonly) NSIndexPath * index;                                                      // 点击进入的 在数据源中的位置
@property (nonatomic, strong) PHCachingImageManager *imageManager;

//@property (nonatomic, strong) MXRPromptView *selectTooMuchPrompt;

@property (nonatomic, assign) PHAssetMediaType mediaType;
@property (nonatomic, copy) void (^completionHandler)(NSMutableArray *imageInfoArray) ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBtnBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end
#define MXRPreViewCellId @"MXRPreViewCellId"
#define MXRPreViewVideoCellId @"MXRPreViewVideoCellId"
static CGSize AssetGridThumbnailSize;
@implementation MXRShareVideoViewController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath mediaType:(PHAssetMediaType)mediaType shareBookGuid:(NSString *)bookGuid operationType:(MXRSelctImageOperationType)operationType completionHandler:(void (^)(NSMutableArray *))completionHandler
{
    if (self = [super init]) {
        _index = indexPath;
        _mediaType = mediaType;
        _shareBookGuid = bookGuid;
        _operationType = operationType;
        _completionHandler = completionHandler;
    }
    return self;

}
/**
 隐藏状态栏
 */
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}


#pragma mark--返回
- (IBAction)backBtnClick:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Video_To_Pause object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    
    self.shareBtnBottomConstraint.constant = MXRiPhoneX_BottomMargin + 21;
    self.backBtnTopConstraint.constant = MXRiPhoneX_TopMargin + 20;
    [self.shareBtn setTitle:MXRLocalizedString(@"MXRPerViewCont_Share", @"分享") forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareSuccess) name:Notification_MXRShareVideoUrlSuccess object:nil];
    
}

- (void)shareSuccess{
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)dealloc{
    DLOG_METHOD;
    [self hidenLoading];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)setPreIndex:(NSIndexPath *)index
{
    _index = index;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ( self.imageModelDataArray.count > 0) {
        [[MXRSelectLocalImageProxy getInstance] setThunMailDataArrayWith: [self.imageModelDataArray mutableCopy]];
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    // 使 UICollectionView 滑动至 在数据中对应的Index的位置
    if (self.operationType == MXRSelctImageOperationTypeShare) {
        if (self.index.item < self.imageModelDataArray.count) {
            [self.preViewCollectionView scrollToItemAtIndexPath:self.index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }else  if(self.index.item >= self.imageModelDataArray.count && self.imageModelDataArray.count > 0) {
            [self setPreIndex: [NSIndexPath indexPathForItem:0 inSection:0]];
            [self.preViewCollectionView scrollToItemAtIndexPath:self.index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }else{
        }
    }else {
        // 有 拍照功能的 数据源 比 无 拍照功能的 数据源 多一个 数据
        if ([MXRSelectLocalImageProxy getInstance].isAddCamera) {
            NSInteger indexPrews = self.index.item - 1;
            NSIndexPath *indexPrew = [NSIndexPath indexPathForItem:indexPrews inSection:0];
            [self.preViewCollectionView scrollToItemAtIndexPath:indexPrew atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }else{
            [self.preViewCollectionView scrollToItemAtIndexPath:self.index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
    [self showCurrentScrollIndex];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark-- UICollectionViewDelegate 代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        if ([MXRSelectLocalImageProxy getInstance].isAddCamera) {
            return self.imageModelDataArray.count - 1;
        }else{
            return self.imageModelDataArray.count;
        }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE);
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MXRImageInformationModel*model;
    UICollectionViewCell*cell;
    if (IOS8_OR_LATER) {
        // 分享
        if ([MXRSelectLocalImageProxy getInstance].isAddCamera){
            if (self.imageModelDataArray.count > indexPath.row + 1) {
                model = [self.imageModelDataArray objectAtIndex:indexPath.row + 1];
            }
        }else{
            if (self.imageModelDataArray.count > indexPath.row) {
                model = [self.imageModelDataArray objectAtIndex:indexPath.row];
            }
        }
        
        if (model.asset.mediaType == PHAssetMediaTypeVideo) {
            cell = [self createMXRPreviewVideoCellWithModel:model collectionView:collectionView indexPath:indexPath]; // 视频
        }else{
            cell = [self createMXRPreviewCellWithModel:model collectionView:collectionView indexPath:indexPath]; //图片
        }
        return cell;
    }else{
        MXRPreviewCell *previewCell = [self createMXRPreviewCellWithModel:model collectionView:collectionView indexPath:indexPath];
        previewCell.iconImage = model.dic[@"img"];
        return previewCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[MXRPreviewCell class]]) {
        [(MXRPreviewCell *)cell recoverSubviews];
    }else if([cell isKindOfClass:[MXRPreviewVideoCell class]]){
        [(MXRPreviewVideoCell*)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[MXRPreviewCell class]]) {
        [(MXRPreviewCell *)cell recoverSubviews];
    }else if([cell isKindOfClass:[MXRPreviewVideoCell class]]){
        [(MXRPreviewVideoCell*)cell recoverSubviews];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.operationType == MXRSelctImageOperationTypeShare) {
      
        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_PreviewScroll_End_Decceleting object:nil];
        [self userPauseORPlayVideo:NO];
    }
    [self showCurrentScrollIndex];
}
#pragma mark-- 初始化设置
-(void)setUp {
    [self setUpCollectionView];
    self.view.backgroundColor = [UIColor blackColor];
   
    self.imageManager = [[PHCachingImageManager alloc] init];
   
    [self showCurrentScrollIndex];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.myLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);

}

#pragma mark - 私有方法

/**
 设置collectionView相关参数
 */
- (void)setUpCollectionView
{
    self.preViewCollectionView.dataSource = self;
    self.preViewCollectionView.delegate = self;
    self.preViewCollectionView.pagingEnabled = YES;
    [self.preViewCollectionView setShowsHorizontalScrollIndicator:NO];
    [self.preViewCollectionView registerClass:[MXRPreviewCell class] forCellWithReuseIdentifier:MXRPreViewCellId];
    [self.preViewCollectionView registerClass:[MXRPreviewVideoCell class] forCellWithReuseIdentifier:MXRPreViewVideoCellId];
}

/**
 获取一个特定的 PHImageRequestOptions

 @return PHImageRequestOptions 实例
 */
- (PHImageRequestOptions *)getImageRequsetOptions
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.resizeMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.networkAccessAllowed = YES;
    return options;
}

/**
 显示 当前 scroll 滑动的位置 (7/12)
 */
-(void)showCurrentScrollIndex{

    NSInteger countNum = self.imageModelDataArray.count;
    if (countNum > 0) {
        NSInteger currentIndex = self.preViewCollectionView.contentOffset.x/SCREEN_WIDTH_DEVICE_ABSOLUTE+1;
        if (currentIndex <= 0) {
            currentIndex = 1;
        }
    }else{
    }
}

#pragma mark--播放视频和预览图片的cell

/**
 获得播放视频的cell
 */
-(MXRPreviewVideoCell*)createMXRPreviewVideoCellWithModel:(MXRImageInformationModel*)model collectionView:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath{
    MXRPreviewVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MXRPreViewVideoCellId forIndexPath:indexPath];
    if (IOS8_OR_LATER) {
        CGSize size = CGSizeMake(model.asset.pixelWidth, model.asset.pixelHeight);
        [self showLoading];
        [self.imageManager requestImageForAsset:model.asset
                                     targetSize:size
                                    contentMode:PHImageContentModeAspectFill
                                        options:[self getImageRequsetOptions]
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      if (result) {
                                          [self hidenLoading];
                                          cell.iconImage = result;
                                          cell.model = model;
                                          cell.isSharePlay = YES;
                                      }
                                  }];
        [cell.videoPauseButton setImage:MXRIMAGE(@"btn_common_bigVideoPlay") forState:UIControlStateNormal];
        cell.delegate = self;
    }
    return cell;
}

/**
 获得图片预览的cell

 */
-(MXRPreviewCell*)createMXRPreviewCellWithModel:(MXRImageInformationModel*)model collectionView:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath{
    MXRPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MXRPreViewCellId forIndexPath:indexPath];
    if (IOS8_OR_LATER) {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize size = CGSizeMake(model.asset.pixelWidth/scale, model.asset.pixelHeight/scale);
        [self showLoading];
        [self.imageManager requestImageForAsset:model.asset
                                     targetSize:size
                                    contentMode:PHImageContentModeAspectFill
                                        options:[self getImageRequsetOptions]
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      if (result) {
                                          [self hidenLoading];
                                          cell.iconImage = result;
                                      }
                                  }];
        cell.delegate = self;
    }
    return cell;
}

#pragma mark - MXRPreviewVideoCellDelegate 代理

/**
 单击 （隐藏 或者 显示）
 // */
-(void)userSingleClick{
    
}

/**
 结束 播放视频
 */
-(void)userEndPlayVideo{

}

/**
 暂停播放视频

 @param isPause 是否暂停
 */
-(void)userPauseORPlayVideo:(BOOL)isPause{
    
}

-(void)userDeleteVideo{
    
}

/**
 选中或者没有选中图片
 */
/**
-(void)slectOrUnSelectImage{
    NSInteger selectIndex = self.preViewCollectionView.contentOffset.x / SCREEN_WIDTH_DEVICE;
    MXRImageInformationModel *model;
    if([MXRSelectLocalImageProxy getInstance].isAddCamera){
        model = self.imageModelDataArray[selectIndex + 1];
    }else{
        model = self.imageModelDataArray[selectIndex];
    }
    // 当最大选择数为 1 时 不弹提示框
    if ([MXRSelectLocalImageProxy getInstance].maxCount == 1) {
        [[MXRSelectLocalImageProxy getInstance]removeAllPreselectImageInfoModelData];
        [[MXRSelectLocalImageProxy getInstance]becomeImagestateToUncheck];
    }
    
    BOOL flag = [[model.dic objectForKey:@"flga"] boolValue];
    NSInteger selectCount = [[MXRGetLocalImageController getInstance]getSelectImageCount];
   
    if (selectCount >= [MXRSelectLocalImageProxy getInstance].maxCount && !flag) {
        [self.selectTooMuchPrompt showInLastViewController];
        return;
    }
    
    // 没有选中 变为选中状态
    if (!flag) {
        BOOL isAddImageSuccess = [[MXRSelectLocalImageProxy getInstance]selectImageChangeStatusWithModel:model];
        if (isAddImageSuccess) {
//            self.topNumberLabel.text = [NSString stringWithFormat:@"%ld",[MXRSelectLocalImageProxy getInstance].preSelectImageModelArray.count];
//            self.topNumberLabel.hidden = NO;
            self.isSelectImageView.image = MXRIMAGE(@"icon_selectImage_selected");
        }
    // 已选中
    }else{
        BOOL isReduceImageSuccess = [[MXRSelectLocalImageProxy getInstance]unselectImageChangeStatusWithModel:model];
        if (isReduceImageSuccess) {
            [model setSelectOrderWith:0];
//            self.topNumberLabel.text = @"";
//            self.topNumberLabel.hidden = YES;
            self.isSelectImageView.image=MXRIMAGE(@"icon_selectImage_unselected");
        }
    }
}
 */

/**
 加 loading
 */
-(void)showLoading
{
    [self.loadingImageView.layer addAnimation:self.rotationAnimation forKey:nil];
    [[[UIApplication sharedApplication].windows lastObject] addSubview:self.loadingImageView];
}
/**
 移除loading
 */
-(void)hidenLoading
{
    [self.loadingImageView.layer removeAllAnimations];
    [self.loadingImageView removeFromSuperview];
}
#pragma mark - MXRNewShareViewDelegate 代理
-(void)PresentToVc:(UIViewController*)vc animation:(BOOL)animation
{
    [self presentViewController:vc animated:animation completion:nil];
}
-(void)pushToVc:(UIViewController*)vc animation:(BOOL)animation
{
    CATransition *anim = [CATransition animation];
    [anim setDuration:0.3f];
    [anim setType:kCATransitionMoveIn];
    [anim setSubtype:kCATransitionFromRight];
    [[[[UIApplication sharedApplication] keyWindow] layer] addAnimation:anim forKey:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:nil];
}
/**
  promptView 代理
 */
//-(void)promptView:(MXRPromptView *)promptView didSelectAtIndex:(NSUInteger)index
//{
//    self.selectTooMuchPrompt = nil;
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-- 发送 或者 确定

/**
 点击 发送 （梦想圈  私信 DIY）

 @param sender 发送按钮
 */
//- (IBAction)sendClick:(id)sender {
//
//    if (self.mediaType == PHAssetMediaTypeImage) {
//        NSInteger originalImageArrayCount = [MXRSelectLocalImageProxy getInstance].preSelectImageModelArray.count;
//        NSInteger selectCount = [[MXRGetLocalImageController getInstance]getSelectImageCount];
//        NSMutableArray *finalImageArray = [[NSMutableArray alloc]init];
//        [[MXRSelectLocalImageProxy getInstance].preSelectImageModelArray enumerateObjectsUsingBlock:^(MXRImageInformationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [finalImageArray addObject:obj.assetImage];
//        }];
//
//        if (selectCount == 0)     return;
//        if (originalImageArrayCount == selectCount && selectCount == finalImageArray.count) {
//            self.completionHandler ? self.completionHandler(finalImageArray) : nil;
//            [self dismissViewControllerAnimated:NO completion:^{
//                [[MXRSelectLocalImageProxy getInstance]becomeImagestateToUncheck];
//                [[MXRSelectLocalImageProxy getInstance]removeAllPreselectImageInfoModelData];
//            }];
//        }
//    }else if(self.mediaType == PHAssetMediaTypeVideo){
//        @MXRWeakObj(self);
//        if ([MXRSelectLocalImageProxy getInstance].preSelectImageModelArray.count > 0) {
//            MXRImageInformationModel *imageInfoModel = [MXRSelectLocalImageProxy getInstance].preSelectImageModelArray[0];
//            [[MXRGetLocalImageController getInstance]getVideoFromAlbumWithPHAsset:imageInfoModel completionHandler:^(BOOL isOkay){
//                NSMutableArray *finalVideoDataArray = [[NSMutableArray alloc]init];
//                [finalVideoDataArray addObject:imageInfoModel.videoData];
//
//                self.completionHandler ? self.completionHandler(finalVideoDataArray) : nil ;
//
//                [selfWeak dismissViewControllerAnimated:NO completion:^{
//                    [[MXRSelectLocalImageProxy getInstance]becomeImagestateToUncheck];
//                    [[MXRSelectLocalImageProxy getInstance]removeAllPreselectImageInfoModelData];
//                }];
//            }];
//
//        }
//    }else if(self.mediaType == PHAssetMediaTypeUnknown){
//        DLOG(@"MediaTypeUnknown");
//
//    }else{
//        DLOG(@"MediaTypeAudio");
//    }
//}

/**
 暂停 视频播放
 
 @param sender 暂停按钮
 */
- (IBAction)shareRelatedPauseBtnClick:(id)sender {
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        //        [self.shareRelatedPauseBtn setImage:MXRIMAGE(@"btn_preViewVC_videoPause") forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Video_To_Play object:nil];
    }else{
        //        [self.shareRelatedPauseBtn setImage:MXRIMAGE(@"btn_preViewVC_playVideo") forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Video_To_Pause object:nil];
    }
}
#pragma mark-- 分享 和 删除
/**
 点击删除
 
 @param sender 删除按钮
 */
- (IBAction)shareRelatedDeleteClick:(id)sender {
    
    if (self.operationType == MXRSelctImageOperationTypeShare) {
        
        MXRShowAlertView *alertView = [[MXRShowAlertView alloc]initWithNibName:@"MXRShowAlertView" bundle:[NSBundle bundleForClass:[self class]]];
        alertView.delegate = self;
        
        alertView.view.frame = self.view.bounds;
        [self addChildViewController:alertView];
        [self.view addSubview:alertView.view];
        [alertView didMoveToParentViewController:self];
        
    }
}
/**
 点击 分享
 
 @param sender 分享按钮
 */
- (IBAction)shareRelatedShareClick:(id)sender {
    if (self.operationType == MXRSelctImageOperationTypeShare) {
//        NSInteger selectCount = [MXRSelectLocalImageProxy getInstance].preSelectImageModelArray.count;
//        if(selectCount == 1){
        
        
        MXRImageInformationModel *imageInfoModel = self.imageModelDataArray[0];
        __weak __typeof(self) weakSelf = self;
        [self doSelectVideoWithModel:imageInfoModel callBack:^(BOOL isOkay) {
            if (imageInfoModel.asset.mediaType == PHAssetMediaTypeVideo) {
                [weakSelf shareVideo:imageInfoModel];
            }else{
                DLOG(@"分享错误");
            }
        }];
    }
}

- (void)doSelectVideoWithModel:(MXRImageInformationModel *)imageInfoModel callBack:(void(^)(BOOL isOkay))callBack{
    
    [[MXRGetLocalImageController getInstance]getImageByModel:imageInfoModel withCallBack:^(BOOL isOk) {
        //获取不到高清图，取一个缩略图
        if (!isOk) {
            [[MXRGetLocalImageController getInstance]getThumnailImageByModel:imageInfoModel callBack:^(BOOL isOkay) {
                if (callBack) {
                    callBack(isOkay);
                }
            }];
            
        }else{
            if (callBack) callBack(isOk);
        }
    }];
}

/**
 分享视频

 @param imageInfoModel 视频信息model
 */
- (void)shareVideo:(MXRImageInformationModel *)imageInfoModel
{
    @MXRWeakObj(self);
//    [[MXRGetLocalImageController getInstance]getVideoFromAlbumWithPHAsset:imageInfoModel completionHandler:^(BOOL isOkay) {
//        if (isOkay) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (imageInfoModel.videoData) {
//                    if (imageInfoModel.assetImage) {
//                        MXRNewShareView *shareView = [[MXRNewShareView alloc]initWithTitle:@"" andShareVideo:imageInfoModel.videoData  andVideoThumbnailImage:imageInfoModel.assetImage andShareSource:MXRShareSourceTypeFromUnity];
//                        shareView.delegate = selfWeak;
//                        [shareView showOnWindown];
//                    }else{
//                        MXRNewShareView *shareView = [[MXRNewShareView alloc]initWithTitle:@"" andShareVideo:imageInfoModel.videoData  andVideoThumbnailImage:MXRIMAGE(@"icon_common_bookIconPlaceholder") andShareSource:MXRShareSourceTypeFromUnity];
//                        shareView.delegate = selfWeak;
//                        [shareView showOnWindown];
//                    }
//                }else{
//                    DLOG(@"分享视频出错");
//                }
//
//            });
//        }else{
//            DLOG(@"分享视频出错");
//        }
//    }];
}

/**
 分享 图片
 */
- (void)shareImage:(MXRImageInformationModel *)imageInfoModel
{
//
//    MXRNewShareView * shareView = [[MXRNewShareView alloc] initWithTitle:@"" andShareImage:imageInfoModel andShareSource:MXRShareSourceTypeFromUnity anShareBookGuid:self.shareBookGuid ];
//    shareView.delegate = self;
//    [shareView showInView:self.view];
}

#pragma mark MXRShowAlertViewDelegate
- (void)alertViewShow:(MXRShowAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        @MXRWeakObj(self);
        if (IOS8_OR_LATER && self.operationType == MXRSelctImageOperationTypeShare) {
            //asset的集合
            PHFetchResult *assetResult = [[MXRGetLocalImageController getInstance]getAllPHAssetFromPHAssetCollection:self.lastAlbumInfoModel.assetCollection];
            [assetResult enumerateObjectsUsingBlock:^(PHAsset * obj, NSUInteger idx, BOOL *stop) {
                __block MXRImageInformationModel *deleteModel;
                
                MXRImageInformationModel *imageInfoModel = self.imageModelDataArray[0];
                
                if ([imageInfoModel.asset.localIdentifier isEqual:obj.localIdentifier]) {
                    deleteModel = imageInfoModel;
                    [[MXRGetLocalImageController getInstance] deleteImageFromAlbumWithAsset:obj CompletionHandler:^(BOOL isOkay) {
                        if (isOkay) {
                            // 这里的代码会在主线程执行
                            dispatch_sync(dispatch_get_main_queue(), ^(){
//                                [[MXRSelectLocalImageProxy getInstance].preSelectImageModelArray removeObject:deleteModel];
                                [selfWeak.imageModelDataArray removeObject:deleteModel];
                                [selfWeak.preViewCollectionView reloadData];
                                if (selfWeak.imageModelDataArray.count > 0) {
                                }else{
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Go_To_Reload_Data_After_Delete object:nil];
                               
                            });
                        }else{
                            
                        }
                    }];
                }
            }];
        }
    }
    
}

#pragma mark  - getter
- (UIImageView*)loadingImageView
{
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH_DEVICE_ABSOLUTE/2.0-25, SCREEN_HEIGHT_DEVICE_ABSOLUTE/2.0-25, 50, 50)];
        _loadingImageView.image = MXRIMAGE(@"anim_chatloading");
    }
    return _loadingImageView;
}

- (CABasicAnimation*)rotationAnimation
{
    if (!_rotationAnimation) {
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        _rotationAnimation.duration = 3;
        _rotationAnimation.cumulative = YES;
        _rotationAnimation.repeatCount = 100000;
    }
    return _rotationAnimation;
}

//- (MXRCopySysytemActionSheet *)shareRelatedDeletSheet
//{
//    if (!_shareRelatedDeletSheet) {
//        _shareRelatedDeletSheet = [[MXRCopySysytemActionSheet alloc]initWithFrame:[UIScreen mainScreen].bounds withTitle:   MXRLocalizedString(@"MXRPreViewController_Delete_Image_From_Image", @"是否从相册中删除选中图片") withBtns:@[MXRLocalizedString(@"DELETE",@"删除")] withCancelBtn:MXRLocalizedString(@"CANCEL" ,@"取消") withDelegate:self];
//    }
//    return _shareRelatedDeletSheet;
//
//}

//- (MXRPromptView *)selectTooMuchPrompt
//{
//    if (!_selectTooMuchPrompt) {
//        _selectTooMuchPrompt = [[MXRPromptView alloc]initWithTitle:MXRLocalizedString(@"SettingViewCon_TIP",@"提示") message: [NSString stringWithFormat:MXRLocalizedString(@"GET_IMAGE_LOCAL_MAX_NINE",@"最多只能选择%ld张照片"), [MXRSelectLocalImageProxy getInstance].maxCount] delegate:self cancelButtonTitle:MXRLocalizedString(@"KNOWALEADY",@"我知道了") otherButtonTitle:nil];
//    }
//    return _selectTooMuchPrompt;
//}

- (NSMutableArray<MXRImageInformationModel *> *)imageModelDataArray
{
    if (!_imageModelDataArray) {
        _imageModelDataArray = [[NSMutableArray alloc]init];
    }
    return _imageModelDataArray;
}

@end
