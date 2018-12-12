//
//  UIViewController+ScreenZoonOut.h
//  huashida_home
//
//  Created by 周建顺 on 15/6/16.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ScreenZoonOutButtonTappedBlock)(void);

@interface UIViewController(ScreenZoonOut)

-(void)addScreenZoonOutButtonToViewWithTappedBlock:(ScreenZoonOutButtonTappedBlock)tappedBlock isHidden:(BOOL)isHidden;

@property (nonatomic,strong) UIButton *screenZoonOutButton;

@property (nonatomic,copy) ScreenZoonOutButtonTappedBlock screenZoonOutButtonTapped;

@end
