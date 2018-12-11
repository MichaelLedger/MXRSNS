//
//  YYPhotoBrowserTranslation.m
//  YYPhotoBrowserLikeWX
//
//  Created by yuyou on 2017/12/5.
//  Copyright © 2017年 yy. All rights reserved.
//

#import "YYPhotoBrowserTranslation.h"
#import "POP.h"
#import "UIView+YYExtension.h"
#import "UIImageView+WebCache.h"

//弹簧系数
#define popSpringBounciness 4.0
//速度
#define popSpringSpeed 10.0

/** 设备屏幕宽 */
#define kMainScreenWidth  [UIScreen mainScreen].bounds.size.width
/** 设备屏幕高度 */
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height

@interface YYPhotoBrowserTranslation ()

@property (nonatomic,strong) UIImageView *showImageView;

@end

@implementation YYPhotoBrowserTranslation

- (void)dealloc
{
//    DLOG(@"图片浏览器转场管理死亡");
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.photoBrowserShow)//显示出来
    {
        //transitionContext:转场上下文
        //转场过程中显示的view，所有动画控件都应该加在这上面
        __block UIView *containerView = [transitionContext containerView];
        //转场的来源控制器
//        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        //转场去往的控制器
        UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        //隐藏photoBrowser里面的图片
        self.photoBrowserMainScrollView.hidden = YES;
        
        //添加目标控制器view
        toVc.view.alpha = 0;
        [containerView addSubview:toVc.view];
        [UIView animateWithDuration:0.2 animations:^{
            toVc.view.alpha = 1;
        }];
        
        //添加imageView
        if (!self.showImageView.superview) [containerView addSubview:self.showImageView];
        
        POPSpringAnimation *imageMove = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
//        imageMove.fromValue = [NSValue valueWithCGRect:CGRectMake(self.showImageView.yy_x, self.showImageView.yy_y, self.showImageView.yy_width, self.showImageView.yy_height)];
        //计算图片浏览器中image的frame
//        CGFloat imageOriginalWidth = self.showImageView.image.size.width;
//        CGFloat imageOriginalHeight = self.showImageView.image.size.height;
//        CGFloat imageWidth = kMainScreenWidth;
//        CGFloat imageHeight = imageOriginalHeight / imageOriginalWidth * imageWidth;
//        CGFloat imageY = (kMainScreenHeight - imageHeight) * 0.5;
//        imageY = imageY < 0 ? 0 : imageY;
//        imageMove.toValue = [NSValue valueWithCGRect:CGRectMake(0, imageY, imageWidth, imageHeight)];
        
        imageMove.fromValue = [NSValue valueWithCGRect:self.showImageView.frame];

        MXRBookSNSUploadImageInfo *imageInfo = [self.imageInfoArray objectAtIndex:self.currentIndex];
        UIImage *cachedImage;
        if (imageInfo.image) {
            cachedImage = imageInfo.image;
        } else {
            NSString *imageUrlStr = [imageInfo.imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//            if ([[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:imageUrlStr]]) {
//                cachedImage = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:imageUrlStr];
//            }
        }
        
        CGFloat imageOriginalWidth;
        CGFloat imageOriginalHeight;
        if (cachedImage) {
            imageOriginalWidth = cachedImage.size.width;
            imageOriginalHeight = cachedImage.size.height;
        } else {
            CGRect imgRect = [self.imageViewFrameArray[self.currentIndex] CGRectValue];
            imageOriginalWidth = imgRect.size.width;
            imageOriginalHeight = imgRect.size.height;
        }
        CGFloat imageWidth = kMainScreenWidth;
        CGFloat imageHeight = imageOriginalHeight / imageOriginalWidth * imageWidth;
        CGFloat imageY = (kMainScreenHeight - imageHeight) * 0.5;
        imageY = imageY < 0 ? 0 : imageY;
        imageMove.toValue = [NSValue valueWithCGRect:CGRectMake(0, imageY, imageWidth, imageHeight)];
        imageMove.beginTime = CACurrentMediaTime();
        imageMove.springBounciness = popSpringBounciness;
        imageMove.springSpeed = popSpringSpeed;
        imageMove.completionBlock = ^(POPAnimation *anim ,BOOL isEnd){
            self.showImageView.hidden = YES;
            self.photoBrowserMainScrollView.hidden = NO;
            [transitionContext completeTransition:YES];
        };
        [self.showImageView pop_addAnimation:imageMove forKey:nil];
        
        //隐藏外部的图片
        ((UIView *)self.imageViewArray[self.currentIndex]).hidden = YES;
    }
    else//隐藏
    {
        //transitionContext:转场上下文
        //转场过程中显示的view，所有动画控件都应该加在这上面
        __block UIView *containerView = [transitionContext containerView];
        //添加imageView
        if (!self.showImageView.superview) [containerView addSubview:self.showImageView];
        //转场的来源控制器
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        //转场去往的控制器
//        UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        //隐藏photoBrowser里的mainScrollView
        self.photoBrowserMainScrollView.hidden = YES;
        
        //要消失的vc
        fromVC.view.alpha = 1;
        [containerView addSubview:fromVC.view];
        [UIView animateWithDuration:0.5 animations:^{
            fromVC.view.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
        
        //显示和移动图片
        [containerView bringSubviewToFront:self.showImageView];
        self.showImageView.hidden = NO;
        POPSpringAnimation *imageMove = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        //计算图片浏览器中image的frame
//        CGFloat imageOriginalWidth = self.showImageView.image.size.width;
//        CGFloat imageOriginalHeight = self.showImageView.image.size.height;
//        CGFloat imageWidth = kMainScreenWidth;
//        CGFloat imageHeight = imageOriginalHeight / imageOriginalWidth * imageWidth;
//        CGFloat imageY = (kMainScreenHeight - imageHeight) * 0.5;
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        if (!window) window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        UIView * selectItem = [self.imageViewArray objectAtIndex:self.currentIndex];
        CGRect originalRect = [window convertRect:selectItem.frame fromView:selectItem.superview];
        
        imageMove.fromValue = [NSValue valueWithCGRect:self.backImageFrame];
//        imageMove.toValue = self.imageViewFrameArray[self.currentIndex];
        imageMove.toValue = [NSValue valueWithCGRect:originalRect];
        imageMove.beginTime = CACurrentMediaTime();
        imageMove.springBounciness = popSpringBounciness;
        imageMove.springSpeed = popSpringSpeed;
        imageMove.completionBlock = ^(POPAnimation *anim ,BOOL isEnd){
            ((UIImageView *)self.imageViewArray[self.currentIndex]).hidden = NO;
            [transitionContext completeTransition:YES];
        };
        [self.showImageView pop_addAnimation:imageMove forKey:nil];
    }
}

#pragma mark - setter
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;

    //index改变时，image也要改变
//    self.showImageView.image = ((UIImageView *)self.imageViewArray[currentIndex]).image;//[UIImage imageNamed:self.imageNameArray[currentIndex]];
    MXRBookSNSUploadImageInfo *imageInfo = [self.imageInfoArray objectAtIndex:currentIndex];
    CGRect imageRect = [[self.imageViewFrameArray objectAtIndex:currentIndex] CGRectValue];
    if (imageInfo.image) {
        self.showImageView.image = imageInfo.image;
    } else {
        NSInteger width = [[NSString stringWithFormat:@"%.0f", imageRect.size.width] integerValue];
        NSInteger height = [[NSString stringWithFormat:@"%.0f", imageRect.size.height] integerValue];
        NSString *compressedImageUrl = [[imageInfo.imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] stringByAppendingString:[NSString stringWithFormat:@"?imageView2/1/w/%ld/h/%ld/interlace/1", (long)width, (long)height]];
        UIImage *cachedImage;
//        if ([[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:compressedImageUrl]]) {
//            cachedImage = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:compressedImageUrl];
//        }
//        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:[imageInfo.imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:cachedImage options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//        }];
    }
//    self.showImageView.yy_width = [self.imageViewFrameArray[currentIndex] CGRectValue].size.width;
//    self.showImageView.yy_height = [self.imageViewFrameArray[currentIndex] CGRectValue].size.height;
//    self.showImageView.yy_x = [self.imageViewFrameArray[currentIndex] CGRectValue].origin.x;
//    self.showImageView.yy_y = [self.imageViewFrameArray[currentIndex] CGRectValue].origin.y;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window) window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIView * selectItem = [self.imageViewArray objectAtIndex:self.currentIndex];
    CGRect originalRect = [window convertRect:selectItem.frame fromView:selectItem.superview];
    _showImageView.frame = originalRect;
    
    //不在这里隐藏或显示外部image，因为在这里做，外部图片会闪一下
}

#pragma mark - 懒加载
- (UIImageView *)showImageView
{
    if (!_showImageView)
    {
        _showImageView = [[UIImageView alloc] init];
        _showImageView.backgroundColor = [UIColor blackColor];
//        _showImageView.image = [UIImage imageNamed:self.imageNameArray[self.currentIndex]];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.layer.masksToBounds = YES;
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        if (!window) window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        UIView * selectItem = [self.imageViewArray objectAtIndex:self.currentIndex];
        CGRect originalRect = [window convertRect:selectItem.frame fromView:selectItem.superview];
        _showImageView.frame = originalRect;
    }
    return _showImageView;
}

@end
