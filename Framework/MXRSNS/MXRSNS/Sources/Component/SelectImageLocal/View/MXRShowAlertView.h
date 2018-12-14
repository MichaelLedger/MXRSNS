//
//  MXRShowAlertView.h
//  huashida_home
//
//  Created by MinJing_Lin on 2018/8/13.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXRShowAlertView;
@protocol MXRShowAlertViewDelegate <NSObject>

- (void)alertViewShow:(MXRShowAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface MXRShowAlertView : UIViewController

@property (weak, nonatomic) id <MXRShowAlertViewDelegate> delegate;

@end



