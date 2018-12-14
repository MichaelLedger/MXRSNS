//
//  MXRPromptView.h
//  huashida_home
//
//  Created by 周建顺 on 15/6/4.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//
                                                           
#import <UIKit/UIKit.h>
#import "BookInfoForShelf.h"
@class MXRPromptView;
@class TTTAttributedLabel;

typedef void(^PromptViewButtonTapBlock)(MXRPromptView *_Nonnull,NSInteger index);

@protocol MXRPromptViewDelegate <NSObject>
@optional
-(void)promptView:(nullable MXRPromptView*)promptView didSelectAtIndex:(NSUInteger)index;

@end

@interface MXRPromptView : NSObject

@property (nonatomic,weak,nullable) id<MXRPromptViewDelegate> mxrDelegate;
@property (nonatomic,strong,nullable) id recordData;   //为扫码记录下载的参数
@property (nonatomic,assign) BOOL isNotFromal;  //扫码用来记录是否为审核的二维码
@property (nonatomic,strong,nullable) NSDictionary *userInfo;
@property(nonatomic)                  NSInteger    tag; 
@property (nonatomic,copy,nullable) PromptViewButtonTapBlock buttonTapBlock;

-(void)showInLastViewController;
-(void)showOnViewController:(nullable UIViewController *)vc;
-(void)showInCustomWindow;
-(void)hiden;
-(BOOL)isShowning;


-(_Nonnull instancetype)initWithTitle:(nullable NSString*)title message:(nullable NSString*)message delegate:(nullable id<MXRPromptViewDelegate>)customDelegate cancelButtonTitle:(nullable NSString*)cancelTitle otherButtonTitle:(nullable NSString*)otherTitle;

-(_Nonnull instancetype)initWithTitle:(nullable NSString*)title message:(nullable NSString*)message attributedMessage:(nullable NSAttributedString*)attributedString delegate:(nullable id<MXRPromptViewDelegate>)customDelegate cancelButtonTitle:(nullable NSString*)cancelTitle otherButtonTitle:(nullable NSString*)otherTitle;


/*
 * cancelButton 右侧的按钮，otherButton左侧按钮
 */
-(_Nonnull instancetype)initWithTitle:(nullable NSString*)title message:(nullable NSString*)message delegate:(nullable id< MXRPromptViewDelegate>)customDelegate cancelButtonTitle:(nullable NSString*)cancelTitle otherButtonTitle:(nullable NSString*)otherTitle buttonTapBlock:(nullable PromptViewButtonTapBlock) buttonTapBlock;


//3个按钮
-(_Nonnull instancetype)initWithTitle:(nullable NSString*)title message:(nullable NSString*)message delegate:(nullable id<MXRPromptViewDelegate>)customDelegate otherButtonTitles:(nullable NSArray*)otherTitles;

-(_Nonnull instancetype)initWithTitle:(nullable NSString*)title message:(nullable NSString*)message delegate:(nullable id<MXRPromptViewDelegate>)customDelegate otherButtonTitles:(nullable NSArray*)otherTitles buttonTapBlock:(nullable PromptViewButtonTapBlock) buttonTapBlock;
@end
