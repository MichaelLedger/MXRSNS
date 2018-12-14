//
//  MXRNetworkUrl.h
//  huashida_home
//
//  Created by 周建顺 on 2017/5/25.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRNetworkUrl_h
#define MXRNetworkUrl_h

#import "MXRUserSettingsManager.h"

static inline NSString* MXRHttps(NSString* url){
    
    return [NSString stringWithFormat:@"https://%@", url];
}

static inline NSString* MXRHttp(NSString* url){
    
    return [NSString stringWithFormat:@"http://%@", url];
}


static inline NSString* MXRBASE_API_URL(){
    NSString *productionServer = @"bs-api.mxrcorp.cn";
    MXRAppType appType = APPCURRENTTYPE;
    switch (appType) {
        case MXRAppTypeBookCity:
            productionServer = @"bs-api.mxrcorp.cn";
            break;
        case MXRAppTypeSnapLearn:
            //productionServer = @"47.52.230.81";
            productionServer = @"sl-api.mxrcorp.cn";//#warning HTTPS In WiFi Timed Out(Need VPN Connect),But In 4G OK
//            productionServer = @"47.91.217.31";
            break;
        default:
            break;
    }
    
   MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    
    switch (type) {
        case MXRARServerTypeInnerNet:               return MXRHttp(@"192.168.0.125:20000");
        case MXRARServerTypeOuterNetFormal:         return MXRHttps(productionServer);
        case MXRARServerTypeOuterNetTest:
        {
            switch (appType) {
                case MXRAppTypeBookCity:
                    productionServer = MXRHttp(@"192.168.0.145:20000");
                    break;
                case MXRAppTypeSnapLearn:
                    productionServer = MXRHttp(@"47.75.67.198");
                    break;
                default:
                    break;
            }
            return productionServer;
        };
        case MXRARServerTypeOuterNetTestHTTP:          return MXRHttp(@"bs-api-test.mxrcorp.cn");
        case MXRARServerTypeOuterNetTestHTTPS:          return MXRHttps(@"bs-api-test.mxrcorp.cn");
        case MXRARServerTypeOuterNetFormalHTTP:     return MXRHttp(productionServer);
        default:                                    return MXRHttps(productionServer);
    }
}


/**
 网页的URL

 @return <#return value description#>
 */
static inline NSString* MXRBASE_HTML_WEB_URL(){
    
    
    NSString *productionServer = @"bsweb.mxrcorp.cn";
    MXRAppType appType = APPCURRENTTYPE;
    switch (appType) {
        case MXRAppTypeBookCity:
            productionServer = @"bsweb.mxrcorp.cn";
            break;
        case MXRAppTypeSnapLearn:
            productionServer = @"sl-web.mxrcorp.cn";
            break;
        default:
            break;
    }
    
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    
    switch (type) {
        case MXRARServerTypeInnerNet:               return MXRHttp(@"192.168.0.125:10122");
        case MXRARServerTypeOuterNetFormal:
        {
            return MXRHttps(productionServer);
        }
        case MXRARServerTypeOuterNetTest:
        {

            if (appType == MXRAppTypeSnapLearn) {
                return MXRHttp(@"sl-web-test.mxrcorp.cn");
            }else{
                return MXRHttp(@"192.168.0.145:10122");
            }
            
        }
        case MXRARServerTypeOuterNetFormalHTTP: return MXRHttp (productionServer);
        default:                                return MXRHttps(productionServer);
    }

}

/**
 特殊网页的URL, 解决带#的分享到qq的问题
 */
static inline NSString* MXRBASE_HTMLSPECAIL_WEB_URL(){
    
    
    NSString *productionServer = @"bs-web-vue.mxrcorp.cn";
    MXRAppType appType = APPCURRENTTYPE;
    switch (appType) {
        case MXRAppTypeBookCity:
            productionServer = @"bs-web-vue.mxrcorp.cn";
            break;
        case MXRAppTypeSnapLearn:
            productionServer = @"sl-web.mxrcorp.cn";
            break;
        default:
            break;
    }
    
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    
    switch (type) {
        case MXRARServerTypeInnerNet:               return MXRHttp(@"192.168.0.125:10122");
        case MXRARServerTypeOuterNetFormal:
        {
            return MXRHttps(productionServer);
        }
        case MXRARServerTypeOuterNetTest:
        {
            
            if (appType == MXRAppTypeSnapLearn) {
                return MXRHttp(@"sl-web-test.mxrcorp.cn");
            }else{
                return MXRHttp(@"192.168.0.145:10123");
            }
            
        }
        case MXRARServerTypeOuterNetFormalHTTP: return MXRHttp (productionServer);
        default:                                return MXRHttps(productionServer);
    }
    
}

///  url standard by Martin.liu
#define URLStringCat(_host_, _serviceurl_)     [[NSURL URLWithString:_serviceurl_ relativeToURL:[NSURL URLWithString:_host_]] absoluteString]


/** 错误码*/

#define SERVER_ERROR_ACTIVE_EXCEEDED_LIMIT      201002 /* 激活码使用次数已经超过上限 */
#define SERVER_ERROR_ACTIVE_USED_BY_OTHER       201003 /* 激活码已经被别人使用过,但是没有绑定账号 */
#define SERVER_ERROR_ACTIVE_BOUND_TO_A_USERA    201004 /* 激活码已经被别人使用过,并绑定账号 */
#define SERVER_ERROR_ACTIVE_INVALID             201001 /* 激活码无效 */
#define SERVER_ERROR_ACTIVE_EMPTY               201000 /* 激活码为空 */
#define SERVER_ERROR_NO_MORE_MSG                201005 /* 没有更多的消息 */
#define SERVER_ERROR_NO_DATA                    200001 /* 没有找到相关的数据 */

#define SERVER_ERROR_LOGIN_FAIL                 201900 /* 登陆失败 */
#define SERVER_ERROR_ACCOUNT_ERROR              201901 /* 账号错误 */
#define SERVER_ERROR_EMAIL_REGISTERED           201902 /* 邮箱已被注册 */
#define SERVER_ERROR_PHONE_REGISTERED           201903 /* 手机已经被注册 */

#define SERVER_ERROR_ALREADY_CHECKED_IN         201007 /* 用户当前已经签到过了 */
#define SERVER_ERROR_EXCEED_LIMITE              201008 /* 用户当前分享次数超过上限 */
#define SERVER_NONETSEVICER                     404    /* 断网情况 */
#define SERVER_OK                               0


#endif /* MXRNetworkUrl_h */
