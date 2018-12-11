//
//  YYPhotoBrowserViewController.m
//  YYPhotoBrowserLikeWX
//
//  Created by yuyou on 2017/12/5.
//  Copyright © 2017年 yy. All rights reserved.
//

#import "YYPhotoBrowserViewController.h"
//#import "YYPhotoBrowserMainScrollView.h"
#import "YYPhotoBrowserTranslation.h"
#import "UIView+YYExtension.h"

#import "MXRMediaUtil.h"
#import "SDWebImageManager.h"

#import "YYPhotoCollectionViewCell.h"
#import <SDWebImageManager.h>

/** 6位十六进制颜色转换 */
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/** 6位十六进制颜色转换，带透明度 */
#define UIAlphaColorFromRGB(rgbValue,a) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

//图片间的间距
#define MARGIN_BETWEEN_IMAGE 20

@interface YYPhotoBrowserViewController () <UIViewControllerTransitioningDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YYPhotoBrowserSubScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *imageInfoArray;//图片信息数组
@property (nonatomic,assign) NSInteger currentImageIndex;//当前图片索引
@property (nonatomic,strong) NSMutableArray *imageViewArray;//外部的图片控件数组
@property (nonatomic,strong) NSMutableArray *imageViewFrameArray;//外部图片在window中的frame数组
//@property (nonatomic,strong) YYPhotoBrowserMainScrollView *mainScrollView;//主控件
@property (nonatomic,strong) YYPhotoBrowserTranslation *translation;//转场动画管理者

@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIButton *savePicBtn;
@property (nonatomic, strong) UICollectionView *collection;

@end

@implementation YYPhotoBrowserViewController

#pragma mark - 生命周期
- (instancetype)initWithImageInfoArray:(NSArray <MXRBookSNSUploadImageInfo *>*)imageInfoArray currentImageIndex:(int)currentImageIndex imageViewArray:(NSMutableArray *)imageViewArray imageViewFrameArray:(NSMutableArray *)imageViewFrameArray
{
    if (self = [self init])
    {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;//设置modal的方式，这样背后的控制器的view不会消失
        self.transitioningDelegate = self;//转场管理者
        self.imageInfoArray = [imageInfoArray copy];
        self.currentImageIndex = currentImageIndex;
        self.imageViewArray = imageViewArray;
        self.imageViewFrameArray = imageViewFrameArray;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUIComponent];
}

- (void)dealloc
{
//    DLOG(@"图片浏览器死亡");
}

#pragma mark - UI相关
- (void)setUIComponent
{
    self.view.backgroundColor = UIAlphaColorFromRGB(0x000000, 1.0);
    
//    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.collection];
    [self.collection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentImageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    [self.view addSubview:self.savePicBtn];
    [self.view addSubview:self.pageLabel];
    [self.pageLabel setText:[NSString stringWithFormat:@"%ld/%ld",(long)(self.currentImageIndex + 1),(long)self.imageInfoArray.count]];
    
    //隐藏或显示对应的外部imageView
    for (int i = 0; i < self.imageViewArray.count; i++)
    {
        ((UIView *)self.imageViewArray[i]).hidden = (i == self.currentImageIndex);
    }
}

#pragma mark - YYPhotoBrowserMainScrollViewDelegate
//- (void)YYPhotoBrowserMainScrollViewDoSingleTapWithImageFrame:(CGRect)imageFrame
//{
//    self.translation.backImageFrame = imageFrame;//赋值给转场管理对象做动画
//    //需要退回页面
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)YYPhotoBrowserMainScrollViewChangeCurrentIndex:(int)currentIndex
//{
//    self.currentImageIndex = currentIndex;
//    self.translation.currentIndex = self.currentImageIndex;//传值给转场管理对象
//
//    [self.pageLabel setText:[NSString stringWithFormat:@"%ld/%ld",(long)(self.currentImageIndex + 1),(long)self.imageInfoArray.count]];
//
//    //隐藏或显示对应的外部imageView
//    for (int i = 0; i < self.imageViewArray.count; i++)
//    {
//        ((UIView *)self.imageViewArray[i]).hidden = (i == self.currentImageIndex);
//    }
//}

//- (void)YYPhotoBrowserMainScrollViewDoingDownDrag:(CGFloat)dragProportion
//{
//    self.view.backgroundColor = UIAlphaColorFromRGB(0x000000, (1 - dragProportion));
//    self.pageLabel.alpha = (1 - dragProportion);
//    self.savePicBtn.alpha = (1 - dragProportion);
//}

//- (void)YYPhotoBrowserMainScrollViewNeedBackWithImageFrame:(CGRect)imageFrame
//{
//    self.translation.backImageFrame = imageFrame;//赋值给转场管理对象做动画
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark UIViewControllerTransitioningDelegate(转场动画代理)
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.translation.photoBrowserShow = YES;
    return self.translation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.translation.photoBrowserShow = NO;
    return self.translation;
}

#pragma mark - 懒加载
- (YYPhotoBrowserTranslation *)translation
{
    if (!_translation)
    {
        _translation = [[YYPhotoBrowserTranslation alloc] init];
//        _translation.endBlock = ^{
//            NSLog(@"end");
//        };
//        _translation.photoBrowserMainScrollView = (UIView *)self.mainScrollView;
        _translation.photoBrowserMainScrollView = (UIView *)self.collection;
        _translation.imageViewArray = self.imageViewArray;
        _translation.imageViewFrameArray = self.imageViewFrameArray;
        _translation.imageInfoArray = self.imageInfoArray;
        _translation.currentIndex = self.currentImageIndex;//这个参数要最后赋值，因为他的setter中用到了上面的参数
    }
    return _translation;
}

//- (YYPhotoBrowserMainScrollView *)mainScrollView
//{
//    if (!_mainScrollView)
//    {
//        _mainScrollView = [[YYPhotoBrowserMainScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.yy_width, self.view.yy_height) imageInfoArray:self.imageInfoArray imageViewFrameArray:self.imageViewFrameArray currentImageIndex:self.currentImageIndex];
//        _mainScrollView.delegate = self;
//    }
//    return _mainScrollView;
//}

-(UILabel*)pageLabel
{
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT_DEVICE_ABSOLUTE-46, SCREEN_WIDTH_DEVICE_ABSOLUTE, 28)];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.font = [UIFont systemFontOfSize:14.0f];
        [_pageLabel setTextColor:[UIColor whiteColor]];
    }
    return _pageLabel;
}

-(UIButton*)savePicBtn
{
    if (!_savePicBtn)
    {
        _savePicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _savePicBtn.frame = CGRectMake(SCREEN_WIDTH_DEVICE_ABSOLUTE-20-70, SCREEN_HEIGHT_DEVICE_ABSOLUTE-18-28, 70, 28);
        _savePicBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f].CGColor;
        _savePicBtn.layer.borderWidth = 1.0f;
        _savePicBtn.layer.cornerRadius = 5.0f;
        _savePicBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_savePicBtn setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3f]];
        [_savePicBtn addTarget:self action:@selector(savePicAction:) forControlEvents:UIControlEventTouchUpInside];
        [_savePicBtn setTitle:MXRLocalizedString(@"ShowMessageContentViewController_Save_Img",@"保存图片") forState:UIControlStateNormal];
    }
    return _savePicBtn;
}

- (UICollectionView *)collection {
    if (!_collection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collection registerClass:[YYPhotoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YYPhotoCollectionViewCell class])];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.pagingEnabled = YES;
        _collection.backgroundColor = [UIColor clearColor];
        _collection.showsHorizontalScrollIndicator = NO;
    }
    return _collection;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YYPhotoCollectionViewCell class]) forIndexPath:indexPath];
    cell.imageInfo = [self.imageInfoArray objectAtIndex:indexPath.item];
    cell.imageFrame = [[self.imageViewFrameArray objectAtIndex:indexPath.item] CGRectValue];
    cell.delegate = self;
    [cell reloadCell];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [self YYPhotoBrowserSubScrollViewDoSingleTapWithImageFrame:[[self.imageViewFrameArray objectAtIndex:indexPath.item] CGRectValue]];
}

#pragma mark - UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return MARGIN_BETWEEN_IMAGE;
//}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, -MARGIN_BETWEEN_IMAGE / 2, 0, MARGIN_BETWEEN_IMAGE);
//}

#pragma mark - Private Method
-(void)savePicAction:(id)sender
{
    
    [MXRMediaUtil checkPhotoAlbumAuthorizationCallBack:^(BOOL isAuthority) {
        MXRBookSNSUploadImageInfo *imageInfo = [self.imageInfoArray objectAtIndex:self.currentImageIndex];
        if (imageInfo.image) {
            UIImageWriteToSavedPhotosAlbum(imageInfo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            return;
        }
        
        if (imageInfo.imageUrl) {
            NSString *imgUrlStr = [imageInfo.imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//            if ([[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:imgUrlStr]]) {
//                UIImage *cachedImage = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:imgUrlStr];
//                UIImageWriteToSavedPhotosAlbum(cachedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//            } else {
//                CGRect imageFrame = [self.imageViewFrameArray[self.currentImageIndex] CGRectValue];
//                NSInteger width = [[NSString stringWithFormat:@"%.0f", imageFrame.size.width] integerValue];
//                NSInteger height = [[NSString stringWithFormat:@"%.0f", imageFrame.size.height] integerValue];
//                NSString *compressedImageUrl = [imageInfo.imageUrl stringByAppendingString:[NSString stringWithFormat:@"?imageView2/1/w/%ld/h/%ld/interlace/1", (long)width, (long)height]];
//                if ([[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:compressedImageUrl]]) {
//                    UIImage *cachedImage = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:compressedImageUrl];
//                    UIImageWriteToSavedPhotosAlbum(cachedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//                }
//            }
        }
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        //已经检测过了
        //        [MXRConstant showAlert:MXRLocalizedString(@"SavePicFailure", @"保存失败") andShowTime:1.5f];
        //无权限
        //        MXRPromptView* promptView = [[MXRPromptView alloc] initWithTitle:nil message:MXRLocalizedString(@"MXRMedia_Util_PhotoAlbum",@"您的照片权限没有开启，无法读取本地相册，请到（设置）-（隐私）-（照片）中选择4D书城开启即可。") delegate:nil cancelButtonTitle:MXRLocalizedString(@"CaiDan_Know",@"我知道了") otherButtonTitle:nil];
        //        [promptView showInCustomWindow];
    } else {
        [MXRConstant showSuccessAlertWithMsg:MXRLocalizedString(@"SavePicSuccess", @"保存成功") andShowTime:1.f];
    }
}

#pragma mark - YYPhotoBrowserSubScrollViewDelegate
- (void)YYPhotoBrowserSubScrollViewDoSingleTapWithImageFrame:(CGRect)imageFrame
{
    self.translation.backImageFrame = imageFrame;//赋值给转场管理对象做动画
    //需要退回页面
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)YYPhotoBrowserSubScrollViewDoDownDrag:(BOOL)isBegin view:(YYPhotoBrowserSubScrollView *)subScrollView needBack:(BOOL)needBack imageFrame:(CGRect)imageFrame
{
    if (needBack)//需要退回页面时，向下通知代理
    {
        [self YYPhotoBrowserSubScrollViewDoSingleTapWithImageFrame:imageFrame];
    } else {
        [self.collection.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.collection.scrollEnabled = !isBegin;
            if ([obj isKindOfClass:[YYPhotoCollectionViewCell class]]) {
                YYPhotoCollectionViewCell *cell = obj;
                if (cell.subScrollView == subScrollView) {
                    cell.subScrollView.mainImageView.hidden = isBegin;
                }
            }
        }];
    }
}

- (void)YYPhotoBrowserSubScrollViewDoingDownDrag:(CGFloat)dragProportion
{
    self.view.backgroundColor = UIAlphaColorFromRGB(0x000000, (1 - dragProportion));
    self.pageLabel.alpha = (1 - dragProportion);
    self.savePicBtn.alpha = (1 - dragProportion);
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collection) {
        //计算当前滚到了哪个index
        NSInteger floorIndex = (int)floorf(scrollView.contentOffset.x / scrollView.bounds.size.width);
        //安全判断
        if (self.imageInfoArray.count == 0) return;
        if (floorIndex >= self.imageInfoArray.count) floorIndex = self.imageInfoArray.count - 1;
        if (floorIndex < 0) floorIndex = 0;
        
        self.currentImageIndex = floorIndex;
        self.translation.currentIndex = self.currentImageIndex;//传值给转场管理对象
    
        [self.pageLabel setText:[NSString stringWithFormat:@"%ld/%ld",(long)(self.currentImageIndex + 1),(long)self.imageInfoArray.count]];
    
        //隐藏或显示对应的外部imageView
        for (int i = 0; i < self.imageViewArray.count; i++)
        {
            ((UIView *)self.imageViewArray[i]).hidden = (i == self.currentImageIndex);
        }
    }
}

@end
