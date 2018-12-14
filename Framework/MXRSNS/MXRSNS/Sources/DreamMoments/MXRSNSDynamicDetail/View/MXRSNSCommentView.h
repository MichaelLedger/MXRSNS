//
//  MXRSNSCommentView.h
//  huashida_home
//
//  Created by shuai.wang on 2017/8/1.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXRSNSCommentView : UIView

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *senderBtnWidth;

@property (weak, nonatomic) IBOutlet UIButton *senderButton;
@end
