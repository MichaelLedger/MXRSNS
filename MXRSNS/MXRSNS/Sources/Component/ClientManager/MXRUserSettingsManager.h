//
//  MXRUserSettingsManager.h
//  huashida_home
//
//  Created by 周建顺 on 16/1/21.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"
@class mxrButton;
@interface MXRUserSettingsManager : NSObject

+(instancetype)defaultManager;
@property (nonatomic,strong) NSDictionary *needUpdateVersion;
@property (nonatomic,strong) NSString *tempID;
@property (nonatomic) CGFloat audioRate;
@property (nonatomic,assign, getter=isDownBookRichStyle) BOOL downBookRichStyle;        // 土豪模式
@property (nonatomic,assign, getter=isSmoothStyle) BOOL smoothStyle;        // 流畅模式
@property (nonatomic, assign) BOOL isARCameraOn;        // 摄像头
@property (nonatomic) NSUInteger bookShelfSelectedIndex;

@property (nonatomic) BOOL offlineButtonTapped;
@property (nonatomic) mxrButton *shackingBtn;

-(BOOL)hasTempID;
/// 获取动态
-(void)setDynamicUserDefault:(NSString *)name withValue:(BOOL )value;
-(BOOL )getDynamicUserDefault:(NSString *)name;

//设置服务器列表 1内网 2外网测试 3外网正式
-(MXRARServerType)getServerType;
-(void)setServerType:(MXRARServerType)type;

//设置jpush key，1为正式的key，2为测试的key
-(KJPushType)getJPushType;
-(void)setJPushType:(KJPushType)type;

//NSUserDefault
-(void)setBoolToNSUserDefaults:(BOOL)value key:(NSString*)key;
-(void)setObjectToNSUserDefaults:(id)value key:(NSString*)key;
-(BOOL)getBoolValueFromNSUserDefaults:(NSString*)key;
-(id)getObjectFromNSUserDefaults:(NSString*)key;

//首次安装赠送图书 NSUserDefault
-(BOOL)whetherSavePresentingBooksInfo;
@end
