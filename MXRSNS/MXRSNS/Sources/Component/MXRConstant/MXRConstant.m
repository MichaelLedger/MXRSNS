//
//  MXRConstant.m
//  HuaShiDa
//
//  Created by zhenyu.wang on 14-7-18.
//  Copyright (c) 2014年 mxrcorp. All rights reserved.
//

#import "MXRConstant.h"
#import "MXRBase64.h"
//#import "MXRControl.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "GlobalFunction.h"
//#import "BookInfoForShelf.h"
#import "AFNetworking.h"
//#import "mxrCommonService.h"
//#import "MXRPromptView.h"
#import "MXRJsonUtil.h"
#import "GlobalBusyFlag.h"
//#import "AppDelegate.h"
#import "NSString+Ex.h"
#import "NSString+NSDate.h"
//#include "JDStatusBarNotification.h"
#import "NSObject+MXRModel.h"
//#import "MXRMemoryToastController.h"

@implementation MXRConstant

+ (void)showAlertNoNetwork{
    if ( [MXRDeviceUtil isReachable] )
    {
        [MXRConstant showAlertBadNetwork];
        return;
    }
    mxr_dispatch_main_async_safe(^{
        UIView *window = [[UIApplication sharedApplication] keyWindow];
        [[GlobalBusyFlag sharedInstance] showMBHUD:window text:MXRLocalizedString(@"None_Net", @"好像没有连接网络哦") delay:1.5f];
    });
}
+ (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}
+ (void)showAlertBadNetwork{
    // 提示无网络
    mxr_dispatch_main_async_safe(^{
        UIView *window = [[UIApplication sharedApplication] keyWindow];
        [[GlobalBusyFlag sharedInstance] showMBHUD:window text:MXRLocalizedString(@"BADNET_ALERT",@"当前网络不佳") delay:1.5f];
    });
}

+ (void)showAlert:(NSString *)infStr andShowTime:(float)tStr{
    mxr_dispatch_main_async_safe(^{
        [self showAlertOnWindow:infStr andShowTime:tStr];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(tStr * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissAlert];
    });
}

+ (void)showAlert:(NSString *)infStr andShowTime:(float)tStr radius:(CGFloat)radius{
    mxr_dispatch_main_async_safe(^{
        [self showAlertOnWindow:infStr andShowTime:tStr radius:radius];
    });
}

+ (void)showAlertOnWindow:(NSString *)infStr andShowTime:(float)tStr{
    mxr_dispatch_main_async_safe(^{
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [[GlobalBusyFlag sharedInstance] showMBHUD:window text:infStr delay:tStr];
    });
}

+ (void)showAlertOnWindow:(NSString *)infStr andShowTime:(float)tStr radius:(CGFloat)radius{
    mxr_dispatch_main_async_safe(^{
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [[GlobalBusyFlag sharedInstance] showMBHUD:window text:infStr delay:tStr radius:radius];
    });
}


+ (void)showAlertOnForwordWindow:(NSString *)infStr andShowTime:(float)tStr{
    mxr_dispatch_main_async_safe(^{
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [[GlobalBusyFlag sharedInstance] showMBHUD:window text:infStr delay:tStr];
    });
}
+ (void)showAlert:(NSString *)infStr andShowTime:(float)tStr andShowWindow:(BOOL)isShow{
    mxr_dispatch_main_async_safe(^{
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [[GlobalBusyFlag sharedInstance] showMBHUD:window text:infStr delay:tStr];
    });
}

+ (void)showAlertOnVC:(UIViewController*)vc info:(NSString *)infStr andShowTime:(float)tStr{
    mxr_dispatch_main_async_safe(^{
        UIView *currentView = [vc view];
        [[GlobalBusyFlag sharedInstance] showMBHUD:currentView text:infStr delay:tStr];
    });
}

+(void)showSuccessAlertWithMsg:(NSString*)msg andShowTime:(CGFloat)showTime
{
    mxr_dispatch_main_async_safe(^{
        // 有的页面pop之后，看不到该对话框
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [[GlobalBusyFlag sharedInstance] showMBHUD:window text:msg dealy:showTime WithImageName:@"icon_toast_successinfo"];
    });
}

+ (void)dismissAlert{
    
}

+(NSDictionary *)parseXML:(NSString *) str
{
    NSString *responseStr = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    if (responseStr.length >=74) {
        responseStr = [responseStr substringFromIndex:74];
    }else{
        DERROR(@"parseXML error,length less than 74,len=%ld",(unsigned long)responseStr.length);
        return nil;
    }
    
    NSString *strXML = [[responseStr stringByReplacingOccurrencesOfString:@"</string>" withString:@""] stringByReplacingOccurrencesOfString:@"/>" withString:@""];
    if (strXML.length > 0) {
        NSString *strRes = [MXRBase64 decodeBase64WithString:strXML];
        if (strRes) {
            strRes = [[[strRes stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[strRes dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            return dic;
        }else{
            DERROR(@"parseXML strRes is nil");
            return nil;
        }
    }else{
        return nil;
    }
}


#pragma mark 检测魔镜是否可用
+ (BOOL) checkPlatformForMoJing{
   return [self checkPlatformForMoJingShowPrompt:YES];
}

+ (BOOL) checkPlatformForMoJingShowPrompt:(BOOL)show
{
    
    NSString *device = [MXRDeviceUtil getDeviceModel];
    // 对于iPhone4s一下的设备，弹出对话框询问用户是否需要继续
    if ([device hasSuffix:@"old"]) {
        if (show) {
//            MXRPromptView *promptView = [[MXRPromptView alloc] initWithTitle:nil message:MXRLocalizedString(@"MXR_ALERT_DEVICE_BAD", @"您的设备配置较低，无法体验")  delegate:nil cancelButtonTitle:MXRLocalizedString(@"KNOWALEADY",@"我知道了") otherButtonTitle:nil];
//
//            [promptView showInLastViewController];
        }

        return NO;
    }
    
    return YES;
}


#pragma mark ---统计分析
+ (NSString *)getNowTime{
    return [NSString createCurrentTimeWithLocalZone:@"Asia/Shanghai" dateFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

+ (void)downloadBookGUID:(NSString *)bookGUID{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSString *strDef = [[NSUserDefaults standardUserDefaults] stringForKey:@"DOWNLOADBOOK"];
    if (strDef.length != 0)
    {
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:@"DOWNLOADBOOK"];
        if (jsonString) {
            arr = [[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil] objectForKey:@"Para1"];
        }else{
            DERROR(@"downloadBookGUID jsonString is nil");
        }
 
    }
    NSString *timeStr = [self getNowTime];
    [arr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                    timeStr, @"TIME",
                    bookGUID, @"BOOKGUID",
                    [UserInformation modelInformation].userID, @"USEID",
                    [MXRDeviceUtil getDeviceUUID], @"DEVICE",
                    nil]];
    NSMutableDictionary *dicRead = [NSMutableDictionary dictionaryWithObjectsAndKeys:arr, @"Para1", nil];
    NSString *downloadStr = [MXRJsonUtil dictionaryToJson:dicRead];
    [[NSUserDefaults standardUserDefaults] setObject:downloadStr forKey:@"DOWNLOADBOOK"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)addUGCCountBookGUID:(NSString *)bookGUID andBookPage:(NSString *)page andUGCType:(NSString *)name{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSString *strDef = [[NSUserDefaults standardUserDefaults] stringForKey:@"ADDUGC"];
    if (strDef.length != 0)
    {
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:@"ADDUGC"];
        if (jsonString) {
                    arr = [[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil] objectForKey:@"Para2"];
        }else{
            DERROR(@"addUGCCountBookGUID jsonString is nil");
        }

    }
    NSString *timeStr = [self getNowTime];
    [arr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                    timeStr, @"TIME",
                    bookGUID, @"BOOKGUID",
                    page, @"PAGE",
                    name, @"UGCTYPE",
                    [UserInformation modelInformation].userID, @"USEID",
                    [MXRDeviceUtil getDeviceUUID], @"DEVICE",
                    nil]];
    NSMutableDictionary *dicRead = [NSMutableDictionary dictionaryWithObjectsAndKeys:arr, @"Para2", nil];
    NSString *downloadStr = [MXRJsonUtil dictionaryToJson:dicRead];
    [[NSUserDefaults standardUserDefaults] setObject:downloadStr forKey:@"ADDUGC"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)typeOfButton:(CustomBtnType)btnType
{
    NSString * type;
    switch ( btnType ) {
        case DE_ACTION_2D_VIDEO:
            type = @"video";
            break;
        case DE_ACTION_AUDIO:
            type = @"audio";
            break;
        case DE_ACTION_3D_MODEL:
            type = @"model";
            break;
        case DE_ACTION_WEBSITE:
            type = @"web";
            break;
        case DE_ACTION_2D_IMAGE:
            type = @"image";
            break;
        case DE_ACTION_COMMENT:
            type = @"comment";
            break;

        default:
            type = @"unknow";
            break;
    }
    return type;
}
+ (NSString *)typeOfXiaomengButton:(CustomBtnType)btnType
{
    NSString * type;
    switch ( btnType ) {
        case DE_ACTION_2D_VIDEO:
            type = @"xmkh30f-video";
            break;
        case DE_ACTION_AUDIO:
            type = @"xmkh30f-audio";
            break;
        case DE_ACTION_3D_MODEL:
            type = @"xmkh30f-model";
            break;
        case DE_ACTION_WEBSITE:
            type = @"xmkh30f-web";
            break;
        case DE_ACTION_2D_IMAGE:
            type = @"xmkh30f-image";
            break;
        case DE_ACTION_COMMENT:
            type = @"xmkh30f-comment";
            break;

        default:
            type = @"unknow";
            break;
    }
    return type;
}

+ (void)clickHotCountBookGUID:(NSString *)bookGUID andBookPage:(NSString *)page andIsOnline:(NSString *)name andBtnType:(CustomBtnType)btnType andIsXiaomengBtn:(BOOL)isXiaomengBtn{
    DLOG_METHOD
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSString *strDef = [[NSUserDefaults standardUserDefaults] stringForKey:@"CLICKHOT"];
    if (strDef.length != 0)
    {
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:@"CLICKHOT"];
        if (jsonString) {
            arr = [[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil] objectForKey:@"Para3"];
        }else{
            DERROR(@"clickHotCountBookGUID jsonString is nil");
        }

    }
    NSString *timeStr = [self getNowTime];
    NSString * t_btnTypeStr;
    if (isXiaomengBtn) {
        t_btnTypeStr = [self typeOfXiaomengButton:btnType];
    }else{
        t_btnTypeStr = [self typeOfButton:btnType];
    }
    
    [arr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                    timeStr, @"TIME",
                    bookGUID, @"BOOKGUID",
                    page, @"PAGE",
                    name, @"ISONLINE",
                    [UserInformation modelInformation].userID, @"USEID",
                    [MXRDeviceUtil getDeviceUUID], @"DEVICE",
                    t_btnTypeStr,@"BUTTONTYPE",
                    nil]];
    NSMutableDictionary *dicRead = [NSMutableDictionary dictionaryWithObjectsAndKeys:arr, @"Para3", nil];
    NSString *downloadStr = [MXRJsonUtil dictionaryToJson:dicRead];
    [[NSUserDefaults standardUserDefaults] setObject:downloadStr forKey:@"CLICKHOT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



+ (BookInfoForShelf *) getPreViewBookinfo:(NSString *)bookGUID
{
    BookInfoForShelf * bookinfo = nil;
    NSData *data1 = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"preinfo_%@",bookGUID]];
    if (data1 != nil) {
        bookinfo = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    }
    return bookinfo;
}

//+ (void) savePreViewBookinfo:(BookInfoForShelf *)bookinfotemp
//{
//    //保存预览信息
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bookinfotemp];
//    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"preinfo_%@",bookinfotemp.bookGUID]];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

+ (void) removePreViewBookinfo:(NSString *)bookGuid
{
    //删除预览信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"preinfo_%@",bookGuid]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//遍历
+ (NSMutableArray *)allFilesAtPath:(NSString *)direString
{
    NSMutableArray *pathArray = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:direString error:nil];
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        NSString *fullPath = [direString stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                // ignore .DS_Store
                if (![[fileName substringToIndex:1] isEqualToString:@"."]) {
                    [pathArray addObject:fullPath];
                }
            }
            else {
                //[pathArray addObject:[self allFilesAtPath:fullPath]];
                [pathArray addObject:[NSString stringWithFormat:@"%@/",fullPath]];
                [pathArray addObjectsFromArray:[self allFilesAtPath:fullPath]];
            }
        }
    }
    
    return pathArray;
}

//去除特殊字符
+ (NSString *)mxrReplaceStr:(NSString *)str{

    
    NSString *temp  =  [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp =  [temp stringByReplacingOccurrencesOfString:@"-" withString:@""];
    temp =  [temp stringByReplacingOccurrencesOfString:@":" withString:@""];
    temp =  [temp stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([NSString isBlankString:temp]) {
        temp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]*1000];
    }
    return [NSString stringWithFormat:@"t=%@",temp];
}
+(NSString *)changeObjectTypeToString:(id)value{
    if (value == nil || value == [NSNull null]) {
        return @"";
    }else if  ([value isKindOfClass:[NSString class]]){
        return value;
    }else  if ([value isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%@",value];
    }
    DERROR(@"返回数据报错");
    return @"";
}

+(NSString *)changeObjectTypeToString:(id)value defaultValue:(NSString*)defaultValue{
    if (value == nil || value == [NSNull null]) {
        return defaultValue;
    }else if  ([value isKindOfClass:[NSString class]]){
        return value;
    }else  if ([value isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%@",value];
    }
    DERROR(@"返回数据报错");
    return defaultValue;
}
+(NSInteger)changeObjectTypeToInteger:(id)value{
    if (value == nil || value == [NSNull null]) {
        return -1;
    }else if ([value isKindOfClass:[NSString class]]){
        return [value integerValue];
    }else if ([value isKindOfClass:[NSNumber class]]){
        return [value intValue];
    }
    DERROR(@"返回数据报错");
    return -1;
}

+(NSInteger)changeObjectTypeToInteger:(id)value defaultValue:(NSInteger)defaultValue{
    if (value == nil || value == [NSNull null]) {
        return defaultValue;
    }else if ([value isKindOfClass:[NSString class]]){
        return [value integerValue];
    }else if ([value isKindOfClass:[NSNumber class]]){
        return [value intValue];
    }
    DERROR(@"返回数据报错");
    return defaultValue;
}

+(long long)changeObjectTypeTolonglong:(id)value defaultValue:(long long)defaultValue{
    if (value == nil || value == [NSNull null]) {
        return defaultValue;
    }else if ([value isKindOfClass:[NSString class]]){
        return [value longLongValue];
    }else if ([value isKindOfClass:[NSNumber class]]){
        return [value longLongValue];
    }
    DERROR(@"返回数据报错");
    return defaultValue;
}

+(NSNumber *)changeObjectTypeToNumber:(id)value{
    if (value == nil || value == [NSNull null]) {
        return [NSNumber numberWithInt:0];
    }else if ([value isKindOfClass:[NSNumber class]]){
        return value;
    }else if([value isKindOfClass:[NSString class]]){
         NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        id result;
        result=[f numberFromString:value];
        if(!(result))
        {
            result=value;
        }
        
        return result;
    }else if ([NSNumber numberWithInt:[value integerValue]]){
        return [NSNumber numberWithInt:[value integerValue]];
    }
    DERROR(@"返回数据报错");
    return [NSNumber numberWithInt:-1];
}

+(NSNumber *)changeObjectTypeToNumber:(id)value defaultValue:(NSNumber*)defaultValue{
    if (value == nil || value == [NSNull null]) {
        return defaultValue;
    }else if ([value isKindOfClass:[NSNumber class]]){
        return value;
    }else if([value isKindOfClass:[NSString class]]){
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        id result;
        result=[f numberFromString:value];
        if(!(result))
        {
            result=value;
        }
        
        return result;
    }
    DERROR(@"返回数据报错");
    return defaultValue;
}

+(NSString*)formatFloat:(float)value{
    int pt = (int)value;
    NSString *ret = nil;
    if (value > pt) {
        CGFloat newValue = [[NSString stringWithFormat:@"%.2f",value] floatValue];
        if (newValue > pt) {
            ret = [NSString stringWithFormat:@"%.2f",value];
        }else{
            ret = [NSString stringWithFormat:@"%d",pt];
        }
        
    }else{
        ret = [NSString stringWithFormat:@"%d",pt];
    }
    return ret;
    
}

+(NSString*)changeHttpToHttps:(NSString*)arg{
//    if ([[MXRUserSettingsManager defaultManager] getServerType] == MXRARServerTypeOuterNetFormalHTTP) {
//           return arg;
//    }
//
//    if(arg && arg.length >0){
//
//        ///==================================================================
//        /// 加上内网过滤条件
//        /// add by martin 本地的不需要转https， 7牛.   测试需要，要roll back
//        if([[MXRUserSettingsManager defaultManager] getServerType] == MXRARServerTypeInnerNet||[[MXRUserSettingsManager defaultManager] getServerType] == MXRARServerTypeOuterNetTest)
//        {
//            if([arg rangeOfString:@"http"].location == NSNotFound ){
//                arg = [NSString stringWithFormat:@"http://%@", arg];
//            }
//
//            NSArray *dontNeedChangeStrings = @[@"clouddn.com/examination_questions", @"clouddn.com", @"res-cn.mxrcorp.cn", @"cloudfront.net" ];
//
//            for (NSString *dontNeedChangeString in dontNeedChangeStrings) {
//                if ([arg rangeOfString:dontNeedChangeString].location != NSNotFound) {
//                    return arg;
//                }
//            }
//
//            NSArray *needChangeStrings = @[@"clouddn.com/examination_questions",@"192.168.0.145",@"192.168.0.125",@"192.168.0.251"];
//            for (NSString *needChangeString in needChangeStrings) {
//                if ([arg rangeOfString:needChangeString].location != NSNotFound) {
//                    arg = [arg stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
//                    return arg;
//                }
//            }
//
//        }
//        /// add by martin
//        ///==================================================================
//
//        //不必转换大小写，如转换微信的logo获取有问题
//        if([arg rangeOfString:@"https"].location == NSNotFound ){
//            arg = [arg stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
//        }
//    }
    return arg;

}
+(NSDictionary *)getUmengClickDictWithValue:(NSString *)clickValue{

    return [[NSDictionary alloc] initWithObjectsAndKeys:clickValue,@"ClickEvent",nil];
}
@end


@implementation MXRConstant(MXRStatusBarToast)
#pragma mark - statusBar toast 提示

+(void)showStatusBarMsg:(NSString*)msg{
//    JDStatusBarView *statusBarView = [JDStatusBarNotification showWithStatus:msg];
//    statusBarView.backgroundColor = MXRCOLOR_2FB8E2;
//    statusBarView.textLabel.textColor = MXRCOLOR_FFFFFF;
//    [JDStatusBarNotification dismissAfter:3.f];
   // [JDStatusBarNotification dismisWithStatusBarView:statusBarView];
    
   
}

+(void)showStatusBarErrorMsg:(NSString*)msg{
//    JDStatusBarView *statusBarView = [JDStatusBarNotification showWithStatus:msg];
//    statusBarView.backgroundColor = MXRCOLOR_2FB8E2;
//    statusBarView.textLabel.textColor =  MXRCOLOR_FFFFFF;
//     [JDStatusBarNotification dismissAfter:3.f];
   // [JDStatusBarNotification dismisWithStatusBarView:statusBarView];
}
@end



@implementation MXRConstant(PromotView)
+(void)showMemoryWarning{
//    MXRPromptView *promptView = [[MXRPromptView alloc] initWithTitle:nil message:MXRLocalizedString(@"NOT_ENOUGH_SPACE", @"当前设备存储空间不足，会造成文件丢失，请释放内存后再进行操作。") delegate:nil cancelButtonTitle:MXRLocalizedString(@"MXRControl_Know",@"我知道了") otherButtonTitle:nil];
//    [promptView showInLastViewController];
    
//    [MXRMemoryToastController showMemoryWarning];
}
@end
