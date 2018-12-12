 //
//  MXRUserSettingsManager.m
//  huashida_home
//
//  Created by 周建顺 on 16/1/21.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRUserSettingsManager.h"
//#import "MXRPresentingBookConstants.h"
//#import "MXRPresentingBooksProxy.h"
//#import <MARUserDefault.h>

NSString *const MXRUserSettingsManagerisAlertNewColumToMessageCenter = @"isAlertNewColumToMessageCenter";
NSString *const MXRUserSettingsManagerHELPOVER = @"HELPOVER";
NSString *const MXRUserSettingsManagerSEVERISSHOWVIEW = @"SEVERISSHOWVIEW";

NSString *const MXRUserSettingManagerAudioRate = @"MXRUserSettingManagerAudioRate";

NSString *const MXRBookShelfSelectedIndex = @"MXRBookShelfSelectedIndex";


NSString *const MXROfflineButtonTapped = @"MXRUserSettingManagerOfflineButtonTapped";

@implementation MXRUserSettingsManager


@synthesize tempID = _tempID;
@synthesize bookShelfSelectedIndex = _bookShelfSelectedIndex;

+(instancetype)defaultManager{
    static dispatch_once_t onceToken;
    static MXRUserSettingsManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MXRUserSettingsManager alloc] init];
    });
    return instance;
}


#pragma mark 书架选中

-(NSUInteger)bookShelfSelectedIndex{
    NSObject *selectedIndexObj = [[NSUserDefaults standardUserDefaults] objectForKey:MXRBookShelfSelectedIndex];
    NSInteger selectedIndex = 2;
    if (selectedIndexObj) {
        selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:MXRBookShelfSelectedIndex];
    }
    return selectedIndex;
}

-(void)setBookShelfSelectedIndex:(NSUInteger)bookShelfSelectedIndex{
    [[NSUserDefaults standardUserDefaults] setInteger:bookShelfSelectedIndex forKey:MXRBookShelfSelectedIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark 第一次启动离线界面按钮晃动，用户是否点击过按钮。
-(void)setOfflineButtonTapped:(BOOL)offlineButtonTapped{
    [[NSUserDefaults standardUserDefaults] setBool:offlineButtonTapped forKey:MXROfflineButtonTapped];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)offlineButtonTapped{
   return [[NSUserDefaults standardUserDefaults] boolForKey:MXROfflineButtonTapped];
}

#pragma mark --
-(NSString *)tempID{
    if (!_tempID) {
        NSString * tmpId = [[NSUserDefaults standardUserDefaults] objectForKey:@"tempId"];
        if ( tmpId == nil || [tmpId isEqualToString:@""]|| [tmpId isEqualToString:@"6"]|| [tmpId isEqualToString:@"5"] ){
            tmpId = @"1";
        }
        _tempID = tmpId;
    }

    return _tempID;
}

-(void)setTempID:(NSString *)tempID{
    _tempID = tempID;
    [[NSUserDefaults standardUserDefaults] setObject:tempID forKey:@"tempId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)hasTempID{
    NSString * tmpId = [[NSUserDefaults standardUserDefaults] objectForKey:@"tempId"];
    return tmpId != nil;
}
-(void)setDynamicUserDefault:(NSString *)name withValue:(BOOL)value{
//    [[NSUserDefaults standardUserDefaults] setBool:value forKey:[NSString stringWithFormat:@"%@%@",name,@"isShowTipsToLookTiYanBook"]];
     [[NSUserDefaults standardUserDefaults] setBool:value forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL )getDynamicUserDefault:(NSString *)name{
    //新需求 ，所有书只提示一次
//    return [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%@",name,@"isShowTipsToLookTiYanBook"]];
     return [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowTipsToLookTiYanBook"];
}

-(MXRARServerType)getServerType{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"MXRServerType"];
}

-(void)setServerType:(MXRARServerType)type{
    [[NSUserDefaults standardUserDefaults] setInteger:(NSInteger)type forKey:@"MXRServerType"];
    BOOL ret =[[NSUserDefaults standardUserDefaults] synchronize];
    if(!ret){
        DALERTERROR(@"setServerType error=%ld",type);
    }
}


-(KJPushType)getJPushType{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"KJPushType"];
}
-(void)setJPushType:(KJPushType)type{
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:@"KJPushType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setAudioRate:(CGFloat)audioRate{
    [[NSUserDefaults standardUserDefaults] setFloat:audioRate forKey:MXRUserSettingManagerAudioRate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(CGFloat)audioRate{
    CGFloat rate = [[NSUserDefaults standardUserDefaults] floatForKey:MXRUserSettingManagerAudioRate];
    if (rate<=0) {
        rate = 1;
    }
    return rate;
}

//- (void)setDownBookRichStyle:(BOOL)downBookRichStyle
//{
//    [MARUserDefault setBool:downBookRichStyle key:USERKEY_Setting_WWANNetworkEnable];
//}
//
//- (BOOL)isDownBookRichStyle
//{
//    return [MARUserDefault getBoolBy:USERKEY_Setting_WWANNetworkEnable];
//}
//
//- (void)setSmoothStyle:(BOOL)smoothStyle
//{
//    [MARUserDefault setBool:smoothStyle key:USERKEY_Setting_SmoothStyle];
//}
//
//- (BOOL)isSmoothStyle
//{
//    return [MARUserDefault getBoolBy:USERKEY_Setting_SmoothStyle];
//}
//
//- (void)setIsARCameraOn:(BOOL)isARCameraOn
//{
//    [MARUserDefault setBool:isARCameraOn key:USERKEY_Setting_ARCameraOn];
//}
//
//- (BOOL)isARCameraOn
//{
//    return [MARUserDefault getBoolBy:USERKEY_Setting_ARCameraOn];
//}

#pragma mark - nsuserdefaults

-(void)setBoolToNSUserDefaults:(BOOL)value key:(NSString*)key
{
    if(key){
        [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        DLOG(@"key值为nil");
    }
}

-(void)setObjectToNSUserDefaults:(id)value key:(NSString*)key
{
    if (value&&key) { //对value和key进行安全性判断
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        if (value) {
            DLOG(@" key为 nil");
        }
        else{
            DLOG(@" 存储的对象为 nil");
        }
    }
    
}
-(BOOL)getBoolValueFromNSUserDefaults:(NSString*)key
{
    if(key)
    {
        return [[NSUserDefaults standardUserDefaults] boolForKey:key];
    }
    else
    {
        DLOG(@" key为 nil");
        return NO;
    }
}
-(id)getObjectFromNSUserDefaults:(NSString*)key
{
    if(key)
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    else
    {
        DLOG(@" key为 nil");
        return nil;
    }
}

#pragma mark - 首次安装赠送图书
//-(BOOL)whetherSavePresentingBooksInfo {
//    BOOL whetherSelectedPresentingBooks = [[NSUserDefaults standardUserDefaults] boolForKey:WhetherSelectedPresentingBooks];
//    if (whetherSelectedPresentingBooks) {
//        return NO;
//    }else {
//        BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",Caches_Directory_PresentingBooks,PresentingBooks]];
//        if (!fileExist) {
//            [[MXRPresentingBooksProxy getInstance] savePresentingBooks];
//        }
//
//        return YES;
//    }
//}
@end
