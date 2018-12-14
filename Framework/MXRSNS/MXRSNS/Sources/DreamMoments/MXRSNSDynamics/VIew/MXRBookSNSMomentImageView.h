//
//  MXRBookSNSMomentImageView.h
//
//
//  Created by gxd on 16/10/19.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//Custom Image Info Model
#import "MXRBookSNSUploadImageInfo.h"

@class MXRBookSNSMomentImageView;

@protocol MXRBookSNSMomentImageViewDelegate <NSObject>
@optional
-(void)btnImageViewClick:(NSInteger )index andSelf:(UIView *)sender;
-(void)registerForImagePreviewingWithDelegate:(id<UIViewControllerPreviewingDelegate>)delegate sourceView:(UIView *)sourceView;
- (void)praiseSNS;
- (void)commentSNS;
- (void)promoteSNS;
- (BOOL)checkPraiseStatus;
@end
@interface MXRBookSNSMomentImageView : UIView
@property (weak, nonatomic) id <MXRBookSNSMomentImageViewDelegate>  delegate;
-(instancetype)initWithimagesArray:(NSArray <MXRBookSNSUploadImageInfo *>*)imagesArray andFrame:(CGRect )frame andItemSize:(CGSize )itemSize;
-(void)reloadData;
@end
