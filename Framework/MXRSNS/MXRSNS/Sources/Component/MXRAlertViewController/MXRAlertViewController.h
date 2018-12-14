//
//  MXRAlertViewController.h
//  huashida_home
//
//  Created by MountainX on 2018/11/1.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 弹窗类型

 - MXRAlertTypeOK: 只有一个OK按钮
 - MXRAlertTypeConfirm: 取消&确认按钮
 */
typedef NS_ENUM(NSUInteger, MXRAlertType){
    MXRAlertTypeOK,
    MXRAlertTypeConfirm,
};

typedef void(^okBtnClickBlock)();
typedef void(^cancelBtnClickBlock)();
typedef void(^confirmBtnClickBlock)();

@interface MXRAlertViewController : UIViewController

/**
 弹窗类型
 */
@property (assign, nonatomic) MXRAlertType alertType;

/**
 点击OK按钮（居中）的回调
 */
@property (copy, nonatomic) okBtnClickBlock okBlock;

/**
 点击取消按钮（左侧）的回调
 */
@property (copy, nonatomic) cancelBtnClickBlock cancelBlock;

/**
 点击确认按钮（右侧）的回调
 */
@property (copy, nonatomic) confirmBtnClickBlock confirmBlock;

/**
 是否隐藏右上角关闭按钮（默认为NO）
 */
@property (nonatomic, assign) BOOL hideCloseBtn;

/**
 初始化方法

 @param type 弹窗类型
 @param title 弹窗标题,默认为nil
 @param alertContent 弹窗提示文本
 @param okBtnTitle ok按钮的标题(居中),传nil默认为‘OK’
 @param cancelBtnTitle 取消按钮的标题(左侧)，传nil默认为‘取消’
 @param confirmBtnTitle 确认按钮的标题(右侧)，传nil默认为‘确认’
 */
- (instancetype)initWithAlertType:(MXRAlertType)type title:(NSString *)title alertContent:(NSString *)alertContent okBtnTitle:(NSString *)okBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle confirmBtnTitle:(NSString *)confirmBtnTitle;

/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)hide;

@end
