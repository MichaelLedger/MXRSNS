//
//  MXRBookSNSMomentImageDetailCollection.m
//  huashida_home
//
//  Created by gxd on 16/9/30.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSMomentImageDetailCollection.h"
#import "MXRBookSNSUploadImageInfo.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "GlobalBusyFlag.h"
#import "MXRMediaUtil.h"
#import "AppDelegate.h"
#import "MXRPreviewCell.h"
//#import "MXRPromptView.h"
static NSString * const cellID = @"cellID";
@interface MXRBookSNSMomentImageDetailCollection()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property (strong, nonatomic) UIView * itemView;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIButton *savePicBtn;
@property (assign, nonatomic) CGSize itemSize;
@property (assign, nonatomic) CGSize selectImageSize;
@property (strong, nonatomic) NSArray <MXRBookSNSUploadImageInfo *> * imageInfoArray;
@end
@implementation MXRBookSNSMomentImageDetailCollection


-(instancetype)initWithFrame:(CGRect)frame anditem:(UIView *)itemView andSelectIndex:(NSInteger)index andImageInfos:(NSArray *)imageInfoArray{

    self = [super initWithFrame:frame];
    if (self) {
        self.itemView = itemView;
        self.selectIndex = index;
        self.imageInfoArray = imageInfoArray;
        [self setup];
    }
    return self;
}
-(void)dealloc{

    DLOG_METHOD;
}
#pragma mark - Private
-(void)setup{
    self.backgroundColor = [UIColor blackColor];
    self.itemSize = CGSizeMake(SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE);
    [self addSubview:self.collectionView];
    [self.collectionView reloadData];
    [self addSubview:self.savePicBtn];
    [self addSubview:self.pageLabel];
    [self.pageLabel setText:[NSString stringWithFormat:@"%ld/%ld",(long)(self.selectIndex + 1),(long)self.imageInfoArray.count]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    });
}
-(void)beganAnimation{

    [self beganAnimationWithIsShow:YES andCallBack:^(BOOL isSuss) {
        if (isSuss) {
            
        }
    }];
}
-(void)beganAnimationWithIsShow:(BOOL)isShow andCallBack:(void(^)(BOOL))callBack{

   
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    __block UIView * selectItem;
    [self.itemView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.selectIndex == obj.tag) {
            selectItem = obj;
        }
    }];
    CGRect cellOldRect = [window convertRect:selectItem.frame fromView:selectItem.superview];
    __block UIImageView * imageView = [[UIImageView alloc] initWithFrame:cellOldRect];
    if (isShow) {
        [self addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.collectionView.hidden = YES;
        [[GlobalBusyFlag sharedInstance] showDownloadIamgeLoading];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageInfoArray[self.selectIndex] imageUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [[GlobalBusyFlag sharedInstance] hideDownloadIamgeLoading];
        }];
        imageView.alpha = 0;
        [UIView animateWithDuration:0.3f animations:^{
            imageView.frame = CGRectMake(0, 0,SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE);
            imageView.alpha = 1;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            imageView = nil;
            if (callBack) {
                callBack(YES);
            }
            self.collectionView.hidden = NO;
        }];
    }else{
        MXRPreviewCell * cell = [[self.collectionView visibleCells] firstObject];
        if (cell.imageView.image == nil) {
            
        }else{
            imageView.image = cell.imageView.image;
        }
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self getDetailImageViewSize:cell.imageView.image];
        imageView.frame = CGRectMake(0, 0,SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE);
        imageView.center = self.center;
        self.pageLabel.hidden = YES;
        self.savePicBtn.hidden = YES;
        self.hidden = YES;
        UIView * t_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE)];
        [t_view addSubview:imageView];
        [window addSubview:t_view];
        [UIView animateWithDuration:0.4f animations:^{
            t_view.alpha = 0;
        } completion:^(BOOL finished) {
            [t_view removeFromSuperview];
            if (callBack) {
                callBack(YES);
            }
        }];
        [UIView animateWithDuration:0.3f animations:^{
            imageView.frame = cellOldRect;
            imageView.alpha = 0;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            imageView = nil;
        }];
    }
}
-(void)getDetailImageViewSize:(UIImage *)image{

    
    CGFloat imageWidth;
    CGFloat imageheight;
    if (image == nil) {
        imageWidth = SCREEN_WIDTH_DEVICE;
        imageheight = SCREEN_WIDTH_DEVICE;
        self.selectImageSize = CGSizeMake(imageWidth, imageheight);
        return;
    }
    if (image.size.width > image.size.height) {
        if (image.size.width > SCREEN_WIDTH_DEVICE) {
            imageWidth = SCREEN_WIDTH_DEVICE;
            imageheight = image.size.height/(image.size.width/SCREEN_WIDTH_DEVICE);
        }else{
            imageWidth = image.size.width;
            imageheight = image.size.height;
        }
    }else if (image.size.width < image.size.height){
        if (image.size.height > SCREEN_HEIGHT_DEVICE*4/5) {
//            imageWidth =  image.size.width/(image.size.height/(SCREEN_HEIGHT_DEVICE*4/5));
            imageWidth = SCREEN_WIDTH_DEVICE;
            imageheight = SCREEN_HEIGHT_DEVICE*4/5;
        }else{
            if (image.size.width > SCREEN_WIDTH_DEVICE) {
                imageWidth = SCREEN_WIDTH_DEVICE;
            }else{
                imageWidth = image.size.width;
            }
            imageheight = SCREEN_HEIGHT_DEVICE*4/5;
        }
    }else{
            imageWidth = SCREEN_WIDTH_DEVICE;
            imageheight = SCREEN_WIDTH_DEVICE;
    }
    self.selectImageSize = CGSizeMake(imageWidth, imageheight);
}
#pragma mark - delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSInteger page=(int)(self.collectionView.contentOffset.x/self.collectionView.frame.size.width+0.5)%self.imageInfoArray.count;
    self.selectIndex = page;
    [self.pageLabel setText:[NSString stringWithFormat:@"%ld/%ld",(long)self.selectIndex + 1,(long)self.imageInfoArray.count]];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageInfoArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    @MXRWeakObj(self);
    MXRPreviewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.imageInfo = self.imageInfoArray[indexPath.row];
    cell.imageViewClick = ^(UIView * previewCell){
        [selfWeak clickImage:previewCell];
    };
    return cell;
}

-(void)clickImage:(UIView *)previewCell{

    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_ShowTabbar object:nil];
    @MXRWeakObj(self);
    MXRPreviewCell * cell = (MXRPreviewCell *)previewCell;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:cell.imageInfo.imageUrl] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [selfWeak getDetailImageViewSize:image];
    }];
    previewCell.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_ScrollTopEnable object:nil];
    [[GlobalBusyFlag sharedInstance] hideDownloadIamgeLoading];
    
    [self beganAnimationWithIsShow:NO andCallBack:^(BOOL isSuss) {
        if (isSuss) {
            [self removeFromSuperview];
        }
    }];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return self.itemSize;
}
-(UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return 0;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    
}
#pragma mark - getter
-(UICollectionView *)collectionView{

    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[MXRPreviewCell class] forCellWithReuseIdentifier:cellID];
        _collectionView.pagingEnabled = YES;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
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
-(void)savePicAction:(id)sender
{
   
    [MXRMediaUtil checkPhotoAlbumAuthorizationCallBack:^(BOOL isAuthority) {
        MXRPreviewCell * cell = [[self.collectionView visibleCells] firstObject];
        if (cell.imageView.image == nil) {
            
        }else{
            UIImageWriteToSavedPhotosAlbum(cell.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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
        [MXRConstant showSuccessAlertWithMsg:MXRLocalizedString(@"SavePicSuccess", @"保存成功") andShowTime:1.5f];
    }
}


@end
