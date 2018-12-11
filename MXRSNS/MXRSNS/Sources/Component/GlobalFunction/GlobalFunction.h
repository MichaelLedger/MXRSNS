//
//  GlobalFunction.h
//  testMessageCenter
//
//  Created by bin.yan on 14-7-22.
//  Copyright (c) 2014年 bin.yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRConstant.h"
//#import "BookShelfManger.h"
#import "MXRBase64.h"
#import <mach/mach_time.h>
//#import "ActiveCodeDatabase.h"
//#import <ShareSDK/ShareSDK.h>
#import <sys/param.h>

#import "BUUtil.h"
//#import "MXRManger.h"
//#import "MXRTag.h"
//#import "MXRTagResult.h"
//#import "IsLockBook.h"
//#import <AssetsLibrary/AssetsLibrary.h>
//#import "MXRUserSettingsManager.h"
//#import "ShareProxy.h"
//#import "JPUSHService.h"
//#import "NSString+Ex.h"
//#import "AppDelegate.h"
#import "MXRJsonUtil.h"
//#import "KeychainItemWrapper.h"
#import "MXRDeviceUtil.h"
//#import "NSString+Ex.h"
//#import "NSString+NSDate.h"
//#import "MXRDeviceUtil.h"
#import "MXRConstant.h"


#define VISITOR_UNIQUE_ID @"mxb_visitor_unique_id"
#ifdef DEBUG
#define LIMITPHONEDISK 512
#else
#define LIMITPHONEDISK 512
#endif
#define CACHE_SAMPLE_BOOKS_KEY @"bookStoreSampleBooks.plist"

#define TIPSUSERPAYMXB MXRLocalizedString(@"GO_TO_LOGIN_TITLE", @"为了保障您的虚拟财产安全，请登录后再进行操作。")
#define TAG4DGLASSES 12
#define kMXRTipsGoLookTiYanBook @"  您还没有去体验《4D魔镜-体验教程》图书哦，是否去体验？"
/*
 !!!!!!!!!!!!!!!!!!!!!!!!!不要在这个类写代码，这个类即将废弃
 */

typedef enum {
    //出版社id
    PRESS_HUASHIDA = 0x01
} PRESSID_TYPE;

typedef enum : NSUInteger{
    SizeWithFontMethodsKind = 1,
    SizeWithFontMethodsKindWithAttributes = 2,
    SizeWithFontMethodsKindWithoptions = 3
} MXRSizeWithFontMethodsKind;


/*
 * 判断是不是横屏切换会导致右侧无法点击的问题的特殊版本
 */
static inline BOOL isCantLandVersion(){
    NSString *version = [UIDevice currentDevice].systemVersion;
    if ([version isEqualToString:@"8.1.3"]) {
        return YES;
    }
    
    return NO;
}


/// 判断字符串是否全部都是空格
static inline BOOL isStrAllSpace(NSString * str)
{
    if ( str == nil )
        return YES;
    
    const char * pstr = str.UTF8String;
    NSInteger n = strlen(pstr);
    NSInteger i = 0;
    
    for (; i < n; i++ )
    {
        if ( (*(pstr + i) != ' ') && (*(pstr + i) != '\n') )
        {
            break;
        }
    }
    
    if (i == n)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/// 获取用户积分
static inline NSString * getUserGradeCount(void) {
    NSString * result = [[NSUserDefaults standardUserDefaults] stringForKey:@"userOfflineHotPoint"];
    return result;
}
//// 初始化 背景视图
static inline void setBackImgView(UIView *t_view)
{
    t_view.layer.borderWidth = 1;
    t_view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    t_view.alpha = 0.5;
    t_view.layer.masksToBounds = YES;
    t_view.layer.cornerRadius = 4;
    t_view.backgroundColor = [UIColor whiteColor];
    
}


/// 获取没有nsnull 的字典  和 NSNumber 类型的转换
static inline NSDictionary * getNONullNSDictionary(NSDictionary *dict)
{
    
    NSMutableDictionary * t_dict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    id  t_temp = [t_dict objectForKey:@"userSex"];
    
    if ([t_temp isKindOfClass:[NSNumber class]]) {
        [t_dict setObject:[NSString stringWithFormat:@"%ld",(long)[t_temp integerValue]] forKey:@"userSex"];
    }else if([t_temp isKindOfClass:[NSNull class]]){
        [t_dict setObject:@"1" forKey:@"userSex"];//默认为男
        
    }
    
    id  t_temp_nikename = [t_dict objectForKey:@"userNickName"];
    
    
    
    if([t_temp_nikename isKindOfClass:[NSNull class]]){
        BOOL result = [[UserInformation modelInformation] userThirdLogin];
        if(result){
            
            NSString * t_thirdNickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_third_nick_name"];
            
            
            if (t_thirdNickName) {
                [t_dict setObject:t_thirdNickName forKey:@"userNickName"];//第三方昵称
                
            }else{
                [t_dict setObject:@"" forKey:@"userNickName"];//第三方默认
                
            }
        }
        
    }
    
    
    NSArray * t_arr = [t_dict allKeys];
    for (NSString * t_key in t_arr) {
        
        
        
        if ([[t_dict objectForKey:t_key] isKindOfClass:[NSNull class]]) {
            
            [t_dict setObject:@"" forKey:t_key];
        }
        NSString * t_b = nil;
        if ([[t_dict objectForKey:t_key] isKindOfClass:[NSNumber class]]) {
            
            NSNumber * t_num = [t_dict objectForKey:t_key];
            if (t_num == nil) {
                t_b = nil;
            }else{
                NSNumberFormatter * t_numFor = [[NSNumberFormatter alloc]init];
                t_b = [t_numFor stringFromNumber:t_num];
            }
            
            [t_dict setObject:t_b forKey:t_key];
            
        }
    }
    
    return t_dict;
}



/// 获取用户的昵称
static inline NSString * huaShiDaGetUserName(void)
{
    NSString * result = nil;
    
    if ( [[UserInformation modelInformation] getIsHuaShiDaUser] ) {
        result = [UserInformation modelInformation].userNickName;
//        DLOG(@"hsd-打开消息的用户名称:%@",result);
    } else {
        result = [UserInformation modelInformation].userNickName;
//        DLOG(@"mxr-打开消息的用户名称:%@",result);
        if ( result.length == 0 )
            result = [UserInformation modelInformation].userNickName;
    }
    
    if ( result.length == 0 )
        result = @"";
    
    return result;
}




///判断当前空间是否够
static inline BOOL isFreeDiskToDownload(void)
{
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"getFreeDiskSpaceInBytesToDownload"]) {
//        float t_space = [MXRDeviceUtil getFreeDiskSpaceInBytes];
//        if (t_space >= LIMITPHONEDISK) {
//            return YES;
//        }else{
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"getFreeDiskSpaceInBytesToDownload"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            return NO;
//
//        }
//
//    }else{
//        return YES;
//    }
    
    /*V5.6.1 add by MT.X*/
    float t_space = [MXRDeviceUtil getFreeDiskSpaceInBytes];
    return t_space >= LIMITPHONEDISK;
    /*V5.6.1 add by MT.X*/
    
}

///判断当前空间是否够
static inline BOOL isFreeDiskToAddUGC(void)
{
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"getFreeDiskSpaceInBytesToAddUGC"]) {
//        float t_space = [MXRDeviceUtil getFreeDiskSpaceInBytes];
//        if (t_space >= LIMITPHONEDISK) {
//            return YES;
//        }else{
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"getFreeDiskSpaceInBytesToAddUGC"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            return NO;
//
//        }
//
//    }else{
//        return YES;
//    }
    
    /*V5.6.1 add by MT.X*/
    float t_space = [MXRDeviceUtil getFreeDiskSpaceInBytes];
    return t_space >= LIMITPHONEDISK;
    /*V5.6.1 add by MT.X*/
}

#pragma mark - 通知中心，消息使用
/// 获取新人引导条数
static inline NSInteger unReadNewerGuideCount(NSString * userId)
{
    // modify by martin ref fantao SP去掉新人引导 、 小梦
    if (APPCURRENTTYPE == MXRAppTypeSnapLearn) {
        return 0;
    }
    NSString * flagStr = [NSString stringWithFormat:@"unReadNewerGuideCount"];
    
    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    return num;
}

/// 设置新人引导条数
static inline void setunReadNewerGuideCount(NSString * userId, NSInteger number)
{
    NSString * flagStr1 = @"unReadNewerGuideCount";
    
    // modify by martin ref fantao SP去掉新人引导 、 小梦
    if (APPCURRENTTYPE == MXRAppTypeSnapLearn) {
        number = 0;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:number forKey:flagStr1];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSInteger result = 0;
    NSString * flagStr ;
    flagStr = [NSString stringWithFormat:@"%@_unreadMsgNum",userId];
    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    result+=num;
    flagStr = [NSString stringWithFormat:@"%@_unReadCommentCount",userId];
    num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    result+=num;
    flagStr = [NSString stringWithFormat:@"%@_unReadLetterCount",userId];
    num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    // modify by martin ref fantao SP去掉新人引导 、 小梦
    if (APPCURRENTTYPE == MXRAppTypeSnapLearn) {
        num = 0;
    }
    result+=num;
    // 新人引导 add by martin
//    flagStr = @"unReadNewerGuideCount";
//    num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
//    result+=num;
//    [JPUSHService setBadge:result];
//    [[NSNotificationCenter defaultCenter] postNotificationName:showSelfReadPoint object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:showCommentRedPoint object:nil];

}

/// 获取未读私信条数
static inline NSInteger unReadLetterCount(NSString * userId)
{
    // modify by martin ref fantao SP去掉新人引导 、 小梦
    if (APPCURRENTTYPE == MXRAppTypeSnapLearn) {
        return 0;
    }
    NSString * flagStr = [NSString stringWithFormat:@"%@_unReadLetterCount",userId];
    
    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    return num;
}
//设置未读评论的条数
static inline void setunReadCommentCount(NSString * userId, NSInteger number)
{
    NSString * flagStr1 = [NSString stringWithFormat:@"%@_unReadCommentCount",userId];
    
    [[NSUserDefaults standardUserDefaults] setInteger:number forKey:flagStr1];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSInteger result = 0;
    NSString * flagStr ;
    flagStr = [NSString stringWithFormat:@"%@_unreadMsgNum",userId];
    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    result+=num;
    flagStr = [NSString stringWithFormat:@"%@_unReadCommentCount",userId];
    num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    result+=num;
    flagStr = [NSString stringWithFormat:@"%@_unReadLetterCount",userId];
    num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    // modify by martin ref fantao SP去掉新人引导 、 小梦
    if (APPCURRENTTYPE == MXRAppTypeSnapLearn) {
        num = 0;
    }
    result+=num;
    // 新人引导 add by martin
//    flagStr = @"unReadNewerGuideCount";
//    num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
//    result+=num;
//    [JPUSHService setBadge:result];
//    [[NSNotificationCenter defaultCenter] postNotificationName:showSelfReadPoint object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:showCommentRedPoint object:nil];
}
/// 获取未读评论条数
static inline NSInteger unReadCommentCount(NSString * userId)
{
    NSString * flagStr = [NSString stringWithFormat:@"%@_unReadCommentCount",userId];
    
    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    return num;
}
/// 设置未读消息条数
static inline void setUnreadMsgNum(NSString * userId,NSInteger number)
{
    NSString * flagStr1 = [NSString stringWithFormat:@"%@_unreadMsgNum",userId];
    
    [[NSUserDefaults standardUserDefaults] setInteger:number forKey:flagStr1];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSInteger result = 0;
    NSString * flagStr ;
    flagStr = [NSString stringWithFormat:@"%@_unreadMsgNum",userId];
    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    result+=num;
    flagStr = [NSString stringWithFormat:@"%@_unReadCommentCount",userId];
    num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    result+=num;
    flagStr = [NSString stringWithFormat:@"%@_unReadLetterCount",userId];
    num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    // modify by martin ref fantao SP去掉新人引导 、 小梦
    if (APPCURRENTTYPE == MXRAppTypeSnapLearn) {
        num = 0;
    }
    result+=num;
    // 新人引导 add by martin
//    flagStr = @"unReadNewerGuideCount";
//    num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
//    result+=num;

//    [JPUSHService setBadge:result];
//    [[NSNotificationCenter defaultCenter] postNotificationName:showSelfReadPoint object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:showNotiReadPoint object:nil];
}
/// 获取未读消息条数
static inline NSInteger unreadMsgNum(NSString * userId)
{
    NSString * flagStr = [NSString stringWithFormat:@"%@_unreadMsgNum",userId];
    
    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    return num;
}

static inline NSInteger unReadMessageTotalNum(NSString * userId)
{
    NSInteger result = 0;
    NSString * flagStr ;
    flagStr = [NSString stringWithFormat:@"%@_unreadMsgNum",userId];
    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    result+=num;
    flagStr = [NSString stringWithFormat:@"%@_unReadCommentCount",userId];
    num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    result+=num;
    flagStr = [NSString stringWithFormat:@"%@_unReadLetterCount",userId];
    num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
    // modify by martin ref fantao SP去掉新人引导 、 小梦
    if (APPCURRENTTYPE == MXRAppTypeSnapLearn) {
        num = 0;
    }
    result+=num;
    // 新人引导 add by martin
//    flagStr = @"unReadNewerGuideCount";
//    num = [[NSUserDefaults standardUserDefaults] integerForKey:flagStr];
//    result+=num;
    return result;
}


//static inline void setSystermNotificationNum(NSString *user)

static inline BOOL isNeedReceiveMessageFromWeb(void)
{
    NSUserDefaults * userDefs = [NSUserDefaults standardUserDefaults];
    return [userDefs boolForKey:@"NeedReceiveMessageFromWeb"];
}
static inline void setNeedReceiveMessageFromWeb(void)
{
    NSUserDefaults * userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setBool:YES forKey:@"NeedReceiveMessageFromWeb"];
    [userDefs synchronize];
}
static inline void clearNeedReceiveMessageFromWeb(void)
{
    NSUserDefaults * userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setBool:NO forKey:@"NeedReceiveMessageFromWeb"];
    [userDefs synchronize];
}
//设置是否需要去网络请求私信列表页
static inline void setIsNeedRequestLetter(BOOL isNeed)
{
    NSUserDefaults * userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setBool:isNeed forKey:@"isNeedRequestLetter"];
    [userDefs synchronize];
}
//判断是否需要去网络请求私信列表页
static inline BOOL isNeedRequestLetter(void)
{
    NSUserDefaults * userDefs = [NSUserDefaults standardUserDefaults];
    return [userDefs boolForKey:@"isNeedRequestLetter"];
}

//设置是否需要去网络请求评论回复列表页
static inline void setIsNeedRequestComment(BOOL isNeed)
{
    NSUserDefaults * userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setBool:isNeed forKey:@"isNeedRequestComment"];
    [userDefs synchronize];
}
//判断是否需要去网络请求评论回复列表页
static inline BOOL isNeedRequestComment(void)
{
    NSUserDefaults * userDefs = [NSUserDefaults standardUserDefaults];
    return [userDefs boolForKey:@"isNeedRequestComment"];
}


//设置是否需要去网络请求我的评论列表页
static inline void setIsNeedRequestMyComment(BOOL isNeed)
{
    NSUserDefaults * userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setBool:isNeed forKey:@"isNeedRequestMyComment"];
    [userDefs synchronize];
}
//判断是否需要去网络请求我的评论列表页
static inline BOOL isNeedRequestMyComment(void)
{
    NSUserDefaults * userDefs = [NSUserDefaults standardUserDefaults];
    return [userDefs boolForKey:@"isNeedRequestMyComment"];
}

static inline void setNewMessgeCount(NSInteger count)
{
    NSNotificationCenter * notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter postNotificationName:@"newMessageFlag" object:[NSNumber numberWithInteger:count]];
    NSInteger un = unreadMsgNum([UserInformation modelInformation].userID);
    if (count != 0 || un > 0)
    {
//        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [delegate.tabBarVC setTabBarItemImageWithIndex:3 WithIsShow:YES];
    }
}

/// 去除返回数据中的xml头尾
static inline NSString * cleanXMLHeaderAndTail(NSString * xmlStr)
{
    NSString * encodeStrTmp = [[[xmlStr stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n" withString:@""] stringByReplacingOccurrencesOfString:@"<string xmlns=\"http://tempuri.org/\">" withString:@""] stringByReplacingOccurrencesOfString:@"</string>" withString:@""];
    return encodeStrTmp;
}
/// 把字符串中的\r\n替换成#r#n
static inline NSString * replaceEnter(NSString * source)
{
    NSString * result = [[source stringByReplacingOccurrencesOfString:@"\r" withString:@"#r"] stringByReplacingOccurrencesOfString:@"\n" withString:@"#n"];
    return result;
}
/// 把#r#n还原为\r\n
static inline NSString * restoreEnter(NSString * source)
{
    NSString * result = [[source stringByReplacingOccurrencesOfString:@"#r" withString:@"\r"] stringByReplacingOccurrencesOfString:@"#n" withString:@"\n"];
    return result;
}
/// 把＃r＃n剔除
static inline NSString * deleteNandr(NSString * source){
    NSString * t_str = source;
    if ([source rangeOfString:@"#r"].location != NSNotFound|| [source rangeOfString:@"#n"].location != NSNotFound) {
         t_str = [[source stringByReplacingOccurrencesOfString:@"#r" withString:@""] stringByReplacingOccurrencesOfString:@"#n" withString:@""];
        
    }
    
    return t_str;
    

}
/// 创建发送给服务器的字典
static inline NSDictionary * createParamsByParaStr(NSString * paraStr)
{
    NSDictionary * paras = @{@"para":paraStr,
                             @"version":[NSNumber numberWithInt:1],
                             @"datatype":@"json"
                             };
    return paras;
}

/// 创建发送给服务器的字典
static inline NSDictionary * createParamsByParaStrV2(NSString * paraStr)
{
    NSString * encodeStr = [MXRBase64 encodeBase64WithString:paraStr];
    NSDictionary * paras = @{@"para":encodeStr,
                             @"version":[NSNumber numberWithInt:1],
                             @"datatype":@"json"
                             };
    return paras;
}

/// 创建发送给服务器的字典
static inline NSDictionary * createParamsByParaStrAndVersion(NSString * paraStr, NSInteger version)
{
    NSString * encodeStr = [MXRBase64 encodeBase64WithString:paraStr];
    NSDictionary * paras = @{@"para":encodeStr,
                             @"version":[NSNumber numberWithInteger:version],
                             @"datatype":@"json"
                             };
    return paras;
}
/// 创建加密给服务器的参数
static inline NSString * createParamsByString(NSString *paraStr)
{
    NSString * encodeStr = [MXRBase64 encodeBase64WithString:paraStr];
    //    NSDictionary * paras = @{@"":encodeStr};
    return encodeStr;
    
    
}
/// 获取解密之后的字符串
static inline NSString * getDecodeResponseString(NSString * responseStr)
{
    NSString * strWithOutXML = cleanXMLHeaderAndTail(responseStr);
    NSString * decodeStr     = [MXRBase64 decodeBase64WithString:strWithOutXML];
    return decodeStr;
}

//  获取字符串的大小  ios7
static inline CGSize getStringRectIos7(NSString* aString)
{
    CGSize size;
    UIFont * font = [UIFont boldSystemFontOfSize:16.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    size = [aString boundingRectWithSize:CGSizeMake(296, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return  size;
    
}

/// 获取字符串的尺寸
static inline CGSize getStringRect(NSString * aString)
{
    return getStringRectIos7(aString);
}

static inline bool isAChar(char cc)
{
    if ( cc >= 'a' && cc <= 'z' )
        return YES;
    
    if ( cc >= 'A' && cc <= 'Z' )
        return YES;
    
    return NO;
}
static inline bool isANumber(char cc)
{
    if ( cc >= '0' && cc <= '9' )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
static inline bool isValidEmailAddress(NSString * emailAddress)
{
    if ( nil == emailAddress )
        return NO;
    
    // 判断是否有@
    NSArray * arr = [emailAddress componentsSeparatedByString:@"@"];
    if ( arr.count < 2 )
        return NO;
    
    // 判断@之后是否有.
    NSString * tailStr = [arr lastObject];
    NSArray  * tailArr = [tailStr componentsSeparatedByString:@"."];
    if ( tailArr.count < 2 )
        return NO;
    
    // 判断.前面的是否合法
    const char * p = ( (NSString *)[tailArr firstObject] ).UTF8String;
    NSInteger count = strlen( p );
    if ( 0 == count )
        return NO;
    
    for ( int i = 0; i < count; i++ )
    {
        char c = * ( p + i);
        if ( !isAChar( c ) && !isANumber( c ) )
        {
            return NO;
        }
    }
    
    // 判断前面的字符类型
    p = ( (NSString *)[arr firstObject] ).UTF8String;
    count = strlen( p );
    if ( 0 == count )
        return NO;
    
    for ( int i = 0; i < count; i++ )
    {
        char c = * ( p + i);
        if ( !isAChar( c ) && !isANumber( c ) && c != '_' && c != '.' )
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 全局的用于设置导航条背景的函数
/// 设置导航条的背景色
static inline UIImageView* setBackgroundColorOfNavigateBar(UIView * nBar)
{
    nBar.backgroundColor = NAVI_BACKGROUND_COLOR;
    return nil;
}

static inline void setBookEntryCount(NSString * bookGUID)
{
    NSString * dictStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookEntryCount"];
    NSMutableDictionary * dict;
    if ( dictStr.length > 0 ) {
        NSData * t_data = [dictStr dataUsingEncoding:NSUTF8StringEncoding];
        if (t_data) {
                dict = [[NSJSONSerialization JSONObjectWithData:t_data options:NSJSONReadingMutableContainers error:nil] mutableCopy];
        }else{
            return;
        }
    
    } else {
        dict = [[NSMutableDictionary alloc] init];
    }
    
    NSUInteger count = [((NSString *)[dict objectForKey:bookGUID]) integerValue];
    count ++;
    NSString * countStr = [NSString stringWithFormat:@"%@",@(count)];
    [dict setObject:countStr forKey:bookGUID];
    if (!dict) {
        DERROR(@"setBookEntryCount dict is nil");
        return;
    }
    
    NSString * jsonStr = [MXRJsonUtil dictionaryToJson:dict];
    [[NSUserDefaults standardUserDefaults] setObject:jsonStr forKey:@"bookEntryCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
static inline NSArray * arrayOfBookEntryCount(void)
{
    NSString * dictStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookEntryCount"];
    NSMutableDictionary * dict;
    if ( dictStr.length > 0 ) {
        NSData * t_data = [dictStr dataUsingEncoding:NSUTF8StringEncoding];
        if (t_data) {
            dict = [[NSJSONSerialization JSONObjectWithData:t_data options:NSJSONReadingMutableContainers error:nil] mutableCopy];
        }else{
            return nil;
        }
    } else {
        return nil;
    }
    
    NSMutableArray * result = [[NSMutableArray alloc] init];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSUInteger count = [((NSString *)obj) integerValue];
        for (NSUInteger i = 0; i < count; i++) {
            NSDictionary * dict = @{@"BOOKGUID":key};
            [result addObject:dict];
        }
    }];
    
    return result;
}

#pragma mark - 游客相关，服务器返回的唯一id
static inline void setVisitorUniqueId(NSString * uniqueId, BOOL sync)
{
    NSString * encodeStr = [MXRBase64 encodeBase64WithString:uniqueId];
    [[NSUserDefaults standardUserDefaults] setObject:encodeStr forKey:VISITOR_UNIQUE_ID];
    if ( sync == YES ) {
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

static inline NSString * getVisitorUniqueId(void)
{
    NSString * string = [MXRBase64 decodeBase64WithString:[[NSUserDefaults standardUserDefaults] objectForKey:VISITOR_UNIQUE_ID]];
    if (string==nil || [string isEqualToString:@""]) {
        string = [MXRDeviceUtil getUUID];
        setVisitorUniqueId(string,YES);
    }
    return string;
}

static inline NSString * getCurrentUserIdAsscationDevice(void){
    return [MXRDeviceUtil getCurrentUserIdAsscationDevice]?:@"";
}


static inline NSString * createVisitorUniqueId(void)
{
    return  [MXRDeviceUtil getUUID];
}



#pragma mark - 路径辅助函数
static inline NSString * faceRecVideoPathWithFileName(NSString * fileName)
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", Caches_Directory,fileName];
    return filePath;
}




static inline UIImage * g_fixOrientationWithT_img(UIImage * aImage){
    if (!aImage) {
        return aImage;
    }

    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
    
    
}

///// 禁止视图多点触控
static inline void setButtonExclusiveTouch(UIView *t_view){
    NSArray * arr = [t_view subviews];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([(UIView *)obj isKindOfClass:[UIButton class]]) {
            [(UIView *)obj setExclusiveTouch:YES];
        }
        
    }];


}
///// 设置按钮位置  （ar 界面）
static inline void  setViewFrame(UIView * t_view){
    t_view.center = CGPointMake(t_view.center.x, 32);

}



//版本号为  xx.xx.xx
//该方法返回的版本号为 xx.xx
//V5.8.7之后返回完整的版本号
static inline NSString* getCurrentShortVerion()
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:MXRShotVersionKey];
//    NSArray *versionArray = [version componentsSeparatedByString:@"."];
//    if (versionArray.count >= 2) {
//        version = [NSString stringWithFormat:@"%@.%@",versionArray[0],versionArray[1]];
//    }
    return version;
}

static inline CGSize changeMethodsSizeWithFontWithIOSVersion(NSString * currentString, CGSize size,UIFont *font, MXRSizeWithFontMethodsKind methodsKind){
    CGSize g_size ;
    if (methodsKind == SizeWithFontMethodsKind) {
        g_size = [currentString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    }else if(methodsKind == SizeWithFontMethodsKindWithAttributes){
        CGRect currentRect = [currentString boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
        g_size = currentRect.size;
    }else{
        CGRect currentRect = [currentString boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
        g_size = currentRect.size;
    }
    return g_size;
}

/*
 * 获取图书的分类icon
 */
static inline NSString* getBookTypeIconWithType(MXRBookStoreBookIconType type){

    switch (type) {
        case MXRBookStoreBookItemTypeColorEgg:
        {
            return @"icon_bookStore_Item_colorEgg";
        }
            break;
        case MXRBookStoreBookItemTypeGlass:
        {
            return @"icon_bookStore_Item_glass";
        }
            break;
        case MXRBookStoreBookItemTypeDraw:
        {
            return @"icon_bookStore_Item_draw";
        }
            break;
        case MXRBookStoreBookItemTypeARBook:
        {
            return @"icon_bookStore_Item_arBook";
        }
            break;
        case MXRBookStoreBookItemTypeNormal:
        {
            return @"icon_bookStore_Item_normal";
        }
            break;
            
        default:
        {
            return nil;
        }
            break;
    }

}


/*
  !!!!!!!!!!!!!!!!!!!!!!!!!不要在这个类写代码，这个类即将废弃
  */
