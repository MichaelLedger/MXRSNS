//
//  MXRPreviewImageViewController.m
//  huashida_home
//
//  Created by MountainX on 2018/2/22.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPreviewImageViewController.h"
#import "MXRBookSNSMomentImageDetailCollection.h"
#import "MXRMediaUtil.h"
#import "MXRPreviewCell.h"
#import "MXRBookSNSUploadImageInfo.h"
#import "GlobalBusyFlag.h"
#import "UIImageView+WebCache.h"

@interface MXRPreviewImageViewController ()

@property (nonatomic, strong)UIImageView *iv;

@end

@implementation MXRPreviewImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _iv = [[UIImageView alloc] init];
    _iv.contentMode = UIViewContentModeScaleAspectFill;
    _iv.clipsToBounds = YES;
    [self.view addSubview:_iv];
    
    if (_imageInfo && _imageInfo.image) {
        _iv.image = _imageInfo.image;
        [self adjustUIWithImageSize:_imageInfo.image.size];
    } else if (_imageInfo && _imageInfo.imageUrl) {
        @MXRWeakObj(self);
        NSString *imgUrlStr = [_imageInfo.imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if ([manager diskImageExistsForURL:[NSURL URLWithString:imgUrlStr]]) {
            _iv.image = [[manager imageCache] imageFromDiskCacheForKey:imgUrlStr];
            [selfWeak adjustUIWithImageSize:_iv.image.size];
        } else {
            UIImage *cachedImage;
            if (self.imageViewFrameArray && self.imageViewFrameArray.count > self.selectIndex) {
                CGRect imageFrame = [self.imageViewFrameArray[self.selectIndex] CGRectValue];
                NSInteger width = [[NSString stringWithFormat:@"%.0f", imageFrame.size.width] integerValue];
                NSInteger height = [[NSString stringWithFormat:@"%.0f", imageFrame.size.height] integerValue];
                NSString *compressedImageUrl = [imgUrlStr stringByAppendingString:[NSString stringWithFormat:@"?imageView2/1/w/%ld/h/%ld/interlace/1", (long)width, (long)height]];
                if ([[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:compressedImageUrl]]) {
                    cachedImage = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:compressedImageUrl];
                    [self adjustUIWithImageSize:cachedImage.size];
                } else {
                    [self adjustUIWithImageSize:CGSizeMake(width, height)];
                }
            }

            [_iv sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:cachedImage options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {

            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

            }];
        }
    }
}

#pragma mark - Private Method
- (void)adjustUIWithImageSize:(CGSize)imageSize {
    if (imageSize.width > 0 && imageSize.height > 0) {
        CGFloat scale = imageSize.height / imageSize.width;
        CGFloat adjustWidth = SCREEN_WIDTH_DEVICE;
        _iv.frame = CGRectMake(0, 0, adjustWidth, adjustWidth * scale);
        self.preferredContentSize = _iv.frame.size;
    }
}

#pragma mark - 3DTouch
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    NSMutableArray *actions = [NSMutableArray array];
    BOOL isPraised = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewCheckPraiseStatus)]) {
        isPraised = [self.delegate previewCheckPraiseStatus];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewPraise)]) {
        NSString *title = isPraised ? MXRLocalizedString(@"MXRBookSNSViewControllerUserCancelLike", @"取消点赞") : MXRLocalizedString(@"MXRBookSNSViewControllerUserLike", @"点赞");
        UIPreviewAction *praiseAction = [UIPreviewAction actionWithTitle:title style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            [self.delegate previewPraise];
        }];
        [actions addObject:praiseAction];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewComment)]) {
        UIPreviewAction *commentAction = [UIPreviewAction actionWithTitle:MXRLocalizedString(@"MXRBookSNSViewControllerUserComment", @"评论") style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            [self.delegate previewComment];
        }];
        [actions addObject:commentAction];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewPromote)]) {
        UIPreviewAction *promoteAction = [UIPreviewAction actionWithTitle:MXRLocalizedString(@"MXRBookSNSViewControllerSenderTypeTransmit", @"转发") style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            [self.delegate previewPromote];
        }];
        [actions addObject:promoteAction];
    }
    
    __weak __typeof(self) weakSelf = self;
    UIPreviewAction *saveAction = [UIPreviewAction actionWithTitle:MXRLocalizedString(@"MXRChatViewControllerMenuImageCopyTitle", @"保存图片") style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        if (weakSelf.iv.image) {
            [MXRMediaUtil checkPhotoAlbumAuthorizationCallBack:^(BOOL isAuthority) {
                if (isAuthority) {
                    UIImageWriteToSavedPhotosAlbum(weakSelf.iv.image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                }
            }];
        }
    }];
    [actions addObject:saveAction];
    return [actions copy];
}
#endif
#endif

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
