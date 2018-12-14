//
//  MXRQuestionBanner.h
//  huashida_home
//
//  Created by MountainX on 2017/9/30.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MXRQuestionBannerDelegate <NSObject>

- (void)MXRQuestionBannerDidSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MXRQuestionBanner : UIView

@property (nonatomic, weak) id<MXRQuestionBannerDelegate> delegate;

/**
 刷新数据
 */
- (void)reloadData;

/**
 item尺寸
 */
+ (CGSize)itemSize;

+ (CGFloat)topEdgeInset;

@end
