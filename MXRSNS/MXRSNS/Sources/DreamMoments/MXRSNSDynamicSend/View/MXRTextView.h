//
//  MXRTextView.h
//  huashida_home
//
//  Created by yuchen.li on 2017/7/4.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXRTextView : UITextView
/* 不可编辑的文字 [0, disableEditNum] */
@property (nonatomic, assign) NSInteger disableEditNum;
/* 不可粘贴#号 */
@property (nonatomic, assign) BOOL disablePasteTopic;

@end
