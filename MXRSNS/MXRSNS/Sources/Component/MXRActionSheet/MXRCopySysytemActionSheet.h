//
//  MXRCopySysytemActionSheet.h
//  huashida_home
//
//  Created by lj on 16/5/26.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MXRCopySysytemActionSheet;
@protocol MXRCopySysytemActionSheetDelegate <NSObject>
@optional
- (void)actionSheetNew:(MXRCopySysytemActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)actionSheetNew:(MXRCopySysytemActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex andClickedButtonTitle:(NSString *)buttonTitle;
- (void)sheetHidden;
@end


@interface MXRCopySysytemActionSheet : UIView
@property (weak, nonatomic) id<MXRCopySysytemActionSheetDelegate> delegate;


//初始化方法
-(instancetype)initWithFrame:(CGRect)frame withBtns:(NSArray*)btns withCancelBtn:(NSString*)cancelBtn withDelegate:(id)delegate;
-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString*)title withBtns:(NSArray*)btns withCancelBtn:(NSString*)cancelBtn withDelegate:(id)delegate;

-(void)show;
-(void)showOnView:(UIView *)showOnView;
-(void)hideActionSheet;
-(void)hiddenSelfNoAnimation;
-(BOOL)getIsShow;

@end
