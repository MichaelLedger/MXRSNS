//
//  MXRCountDownView.h
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/21.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXRCountDownView : UIView

@property (nonatomic, copy) void (^finishCallback)(void);
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger maxValue;

@end
