//
//  MXRBookSNSMomentImageView.m
//  huashida_home
//
//  Created by gxd on 16/10/19.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSMomentImageView.h"
#import "UIButton+WebCache.h"
#import "MXRBookSNSUploadImageInfo.h"
#import "UIImageView+WebCache.h"
#import "MXRSNSShareModel.h"
#import "UIImage+Extend.h"
#import "UIImage+GIF.h"
#import "NSData+ImageContentType.h"
#import "AppDelegate.h"
#import "MXRBookSNSMomentImageDetailCollection.h"
#import "MXRPreviewImageViewController.h"
#import "YYPhotoBrowserViewController.h"
#import "UIViewController+Ex.h"

@interface MXRBookSNSMomentImageView() <UIViewControllerPreviewingDelegate, MXRPreviewImageViewControllerDelegate>

@property (strong, nonatomic) NSArray <MXRBookSNSUploadImageInfo *>* imagesArray;
@property (assign, nonatomic) NSInteger imagesCount;
@property (assign, nonatomic) CGSize itemSize;
@property (nonatomic,strong) NSMutableArray *imageViewArray;//图片控件数组
@property (nonatomic,strong) NSMutableArray *imageViewFrameArray;//图片控件在window中的位置


@end
@implementation MXRBookSNSMomentImageView
-(instancetype)initWithimagesArray:(NSArray <MXRBookSNSUploadImageInfo *>*)imagesArray andFrame:(CGRect)frame andItemSize:(CGSize)itemSize{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.imagesArray = imagesArray;
        self.imagesCount = imagesArray.count;
        self.itemSize = itemSize;
        [self setup];
    }
    return self;
}
-(void)setup{
    
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
}
-(void)imageViewClick:(UIButton *)sender{
    
//    if ([self.delegate respondsToSelector:@selector(btnImageViewClick:andSelf:)]) {
//        [self.delegate btnImageViewClick:sender.tag andSelf:self];
//    }
    
    YYPhotoBrowserViewController *photo = [[YYPhotoBrowserViewController alloc] initWithImageInfoArray:self.imagesArray currentImageIndex:sender.tag imageViewArray:self.imageViewArray imageViewFrameArray:self.imageViewFrameArray];
    [photo showAtTop];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
}
-(void)reloadData{
    if (self.subviews.count > 0) {
        [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.imageViewArray removeAllObjects];
    [self.imageViewFrameArray removeAllObjects];
    for (int i = 0;i < self.imagesCount; i++) {
        if (i >= 9) {
            break;
        }
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        float x = col * (self.itemSize.width + itemMargin);
        float y = row * (self.itemSize.width + itemMargin);
        UIButton * btnimageView = [[UIButton alloc] init];
        btnimageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        [btnimageView setBackgroundImage:[UIImage imageNamed:@"img_default_pic"] forState:UIControlStateNormal];//占位图
        btnimageView.backgroundColor = RGB(237, 237, 237);//as placeholderImage
        btnimageView.imageView.clipsToBounds = YES;
        btnimageView.frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
        NSValue *frameValue = [NSValue valueWithCGRect:btnimageView.frame];
        [self.imageViewFrameArray addObject:frameValue];
        [self.imageViewArray addObject:btnimageView];
        [btnimageView addTarget:self action:@selector(imageViewClick:) forControlEvents:UIControlEventTouchUpInside];
        btnimageView.tag = i;
        [btnimageView setAdjustsImageWhenHighlighted:NO];
        MXRBookSNSUploadImageInfo * imageInfo = self.imagesArray[i];
        if (imageInfo.image) {
            [btnimageView setImage:imageInfo.image forState:UIControlStateNormal];
        }else{
            __weak __typeof(btnimageView) weakBtn = btnimageView;
            NSInteger width = [[NSString stringWithFormat:@"%.0f", self.itemSize.width] integerValue];
            NSInteger height = [[NSString stringWithFormat:@"%.0f", self.itemSize.height] integerValue];
            NSString *compressedImageUrl = [[imageInfo.imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] stringByAppendingString:[NSString stringWithFormat:@"?imageView2/1/w/%ld/h/%ld/interlace/1", (long)width, (long)height]];
            /*https://img.mxrcorp.cn/mxroms/20171026200514272_lftt5t90c5.gif?imageView2/1/w/108/h/108/interlace/1*/
            [btnimageView sd_setImageWithURL:[NSURL URLWithString:compressedImageUrl] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    __strong UIButton *strongBtn = weakBtn;
                    if (!strongBtn) {
                        return;
                    }
                    [strongBtn sd_setImageWithURL:[NSURL URLWithString:imageInfo.shrinkImageUrl] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageLowPriority];
                }
            }];
        }
        
        [btnimageView setExclusiveTouch:YES];
        [self addSubview:btnimageView];
        
        //3D-Touch
        if (IOS9_OR_LATER && ForceTouchCapabilityAvailable) {
            if ([self.delegate respondsToSelector:@selector(registerForImagePreviewingWithDelegate:sourceView:)]) {
                [self.delegate registerForImagePreviewingWithDelegate:self sourceView:btnimageView];
            }
        }
    }
}

#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    UIView *sourceView = previewingContext.sourceView;
    if ([sourceView isKindOfClass:[UIButton class]]) {
        MXRPreviewImageViewController *vc = [[MXRPreviewImageViewController alloc] init];
        if (_imagesArray && _imagesArray.count > sourceView.tag) {
            vc.imageInfo = [_imagesArray objectAtIndex:sourceView.tag];
            vc.selectIndex = sourceView.tag;
        }
        vc.imageViewFrameArray = self.imageViewFrameArray;
        vc.delegate = self;
        return vc;
    } else {
        return nil;
    }
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    if ([viewControllerToCommit isKindOfClass:[MXRPreviewImageViewController class]]) {
        MXRPreviewImageViewController *vc = (MXRPreviewImageViewController *)viewControllerToCommit;
        
//        UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//        UIViewController *topVC;
//        if (appRootVC.presentedViewController) {
//            topVC = appRootVC.presentedViewController;
//        }else{
//            AppDelegate* app =  (AppDelegate*)[UIApplication sharedApplication].delegate;
//            topVC = app.navigationController;
//        }
//        MXRBookSNSMomentImageDetailCollection *collection = [[MXRBookSNSMomentImageDetailCollection alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE) anditem:self andSelectIndex:vc.selectIndex andImageInfos:_imagesArray];
//        [topVC.view addSubview:collection];
//        [APP_DELEGATE.tabBarVC.tabBar setHidden:YES];
//        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_ScrollTopNoEnable object:nil];
        
        YYPhotoBrowserViewController *photo = [[YYPhotoBrowserViewController alloc] initWithImageInfoArray:self.imagesArray currentImageIndex:vc.selectIndex imageViewArray:self.imageViewArray imageViewFrameArray:self.imageViewFrameArray];
        [photo showAtTop];
    }
}

#pragma mark - MXRPreviewImageViewControllerDelegate
- (BOOL)previewCheckPraiseStatus {
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkPraiseStatus)]) {
        return [self.delegate checkPraiseStatus];
    } else {
        return NO;
    }
}

- (void)previewPraise {
    if (self.delegate && [self.delegate respondsToSelector:@selector(praiseSNS)]) {
        [self.delegate praiseSNS];
    }
}

- (void)previewComment {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentSNS)]) {
        [self.delegate commentSNS];
    }
}

- (void)previewPromote {
    if (self.delegate && [self.delegate respondsToSelector:@selector(promoteSNS)]) {
        [self.delegate promoteSNS];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)imageViewArray
{
    if (!_imageViewArray)
    {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

- (NSMutableArray *)imageViewFrameArray {
    if (!_imageViewFrameArray) {
        _imageViewFrameArray = [NSMutableArray array];
    }
    return _imageViewFrameArray;
}

@end

