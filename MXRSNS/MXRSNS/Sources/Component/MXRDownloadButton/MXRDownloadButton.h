//
//  MXRDownloadButton.h
//  huashida_home
//
//  Created by weiqing.tang on 2016/12/7.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXTProgressLabel.h"


@interface MXRDownloadButton : UIButton
@property (nonatomic, strong) UIView  *progressView;
@property (nonatomic, strong) JXTProgressLabel *progresslable;
@property (nonatomic, assign, readonly) CGFloat buttonWidth;                        // 下载按钮的宽度
@property (nonatomic, assign, readonly) CGFloat buttonHeight;                       // 下载按钮的高度
@property (nonatomic, strong, readonly) UIColor *backgroundTextColor;               // 下载文字的background颜色

@property (nonatomic, strong) BookInfoForShelf *downloadBookInfo;         // 图书信息

// set方法
- (void)setMXRDownloadBtnWidth:(CGFloat)buttonWidth;
- (void)setMXRDownloadBtnHeight:(CGFloat)buttonHeight;
- (void)setMXRDownloadBtnBackgroundTextColor:(UIColor *)backgroundTextColor;

- (void)setBookInfo:(BookInfoForShelf *)bookInfo;

@end
