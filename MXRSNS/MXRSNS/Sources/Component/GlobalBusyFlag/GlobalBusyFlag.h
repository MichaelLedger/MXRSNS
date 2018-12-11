//
//  GlobalBusyFlag.h
//  AiYiKe
//
//  Created by bin.yan on 14-10-8.
//  Copyright (c) 2014年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalBusyFlag : NSObject
+ (id)sharedInstance;
- (void)showBusyFlagOnView:(UIView *)containView withMessage:(NSString *)msg;

- (void)showBusyFlagOnWindowWithMessage:(NSString *)msg;
- (void)showBusyFlagOnView:(UIView *)containView;
- (void)showBusyFlagOnView:(UIView *)containView enableTouch:(BOOL)enable;
- (void)hideBusyFlag;
- (void)showBusyFlagFullScreenOnView:(UIView *)containView;
/**
 *  @param containView flag 父视图
 *  @param point       flag 位置
 */
- (void)showBusyFlagOnView:(UIView *)containView andFlagCenter:(CGPoint )point;

//直接在window中加一个loading
- (void)showBusyFlagOnWindow;
- (void)hideBusyFlagOnWindow;

//双目模式需要加两个loading,两边个一个
-(void)showTwoBusyFlagOnWindow;
-(void)hideTwoBusyFlagOnWindow;

//黑框加文字
-(void)showMBHUD:(UIView*)view text:(NSString*)content delay:(float)delay;
//钩加文字
-(void)showMBHUD:(UIView*)view text:(NSString*)content dealy:(CGFloat)delay WithImageName:(NSString*)imageName;

-(void)showDownloadIamgeLoading;
-(void)hideDownloadIamgeLoading;
-(void)showMBHUD:(UIView*)view text:(NSString*)content delay:(float)delay radius:(CGFloat)radius;

@end
