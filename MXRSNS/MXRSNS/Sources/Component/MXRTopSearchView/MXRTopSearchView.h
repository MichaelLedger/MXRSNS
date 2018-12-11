//
//  MXRTopSearchView.h
//  huashida_home
//
//  Created by 周建顺 on 15/9/22.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MXRTextField;

@interface MXRTopSearchView : UIView

+(instancetype)topSearchView;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftFiledWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtnHeight;
@property(nonatomic, assign) CGSize intrinsicContentSize;
@end
