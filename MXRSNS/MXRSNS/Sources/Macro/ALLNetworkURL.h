//
//  ALLNetworkURL.h
//  huashida_home
//
//  Created by yanbin on 15/4/24.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#ifndef huashida_home_ALLNetworkURL_h
#define huashida_home_ALLNetworkURL_h

#import "MXRUserSettingsManager.h"

#pragma mark - 基础服务模块的相关url
/**
 *  登陆/获取下载记录
 */
static inline NSString* MXRUSER_API_URL(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10108";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-user-api.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-user.api.mxrcorp.cn";
        default:                            return @"https://bs-user-api.mxrcorp.cn";
    }
}
/**
 *  登陆/获取下载记录 (Java 环境)
 */
static inline NSString* MXRUSER_API_URL_ForJAVA(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10108";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-user.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://172.16.10.153:10108";
        default:                            return @"https://bs-user.mxrcorp.cn";
    }
}
// 获取设备ID
static inline NSString *URL_FOR_BASE_SERVER(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10103/default.asmx";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-base-service.mxrcorp.cn/default.asmx";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1.base.service.mxrcorp.cn/default.asmx";
        default:                            return @"https://bs-base-service.mxrcorp.cn/default.asmx";
    }
}


//GXD 6.4 ++ 2015 记录下载数据
static inline NSString *URL_FOR_BannerClick_SERVER(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10107";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-datacollection-api.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-datacollection.api.mxrcorp.cn";
        default:                            return @"https://bs-datacollection-api.mxrcorp.cn";
    }
}

//Martin.liu 5.0 记录下载图书记录   /download/book/logs/add 接口找张来涛
static inline NSString *URL_FOR_DownloadBook_FeedBack(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10107";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-datacollection.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-datacollection.api.mxrcorp.cn";
        default:                            return @"https://bs-datacollection.mxrcorp.cn";
    }
}

// 我的界面
static inline NSString *URL_FOR_MY_INFO_SERVER(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10110/default.asmx";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-my-service.mxrcorp.cn/default.asmx";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1.my.service.mxrcorp.cn/default.asmx";
        default:                            return @"https://bs-my-service.mxrcorp.cn/default.asmx";
    }
}

//通知页面查看评论回复
static inline NSString *URL_FOR_MessageReply(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10112";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-message-web.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-message.web.mxrcorp.cn";
        default:                            return @"https://bs-message-web.mxrcorp.cn";
    }
}
// 激活
static inline NSString *URL_FOR_ACTIVE(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10109";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-web.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-web.mxrcorp.cn";
        default:                            return @"https://bs-web.mxrcorp.cn";
    }
}


//新的书城服务
static inline NSString *URL_FOR_BOOKSTORE_NEW_SERVER(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10113";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-bookstore-api.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-bookstore.api.mxrcorp.cn";
        default:                            return @"https://bs-bookstore-api.mxrcorp.cn";

    }
}


//老的书城
static inline NSString *URL_FOR_BOOKSTORE_SERVER(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10101/default.asmx";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-bookstore-service.mxrcorp.cn/default.asmx";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1.bookstore.service.mxrcorp.cn/default.asmx";// 外网测试在前面加一个test-
        default:                            return @"https://bs-bookstore-service.mxrcorp.cn/default.asmx";
    }
}

//基本服务
static inline NSString *URL_FOR_BASE(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10111";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-base-api.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-base.api.mxrcorp.cn";// 外网测试在前面加一个test-
        default:                            return @"https://bs-base-api.mxrcorp.cn";
    }
}

static inline NSString *URL_FOR_BASE_ACTIVE(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10111";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-base.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-base.api.mxrcorp.cn";// 外网测试在前面加一个test-
        default:                            return @"https://bs-base.mxrcorp.cn";
    }
}

// 购买梦想币相关接口
static inline NSString *URL_FOR_BUY_COIN(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10106";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-coin-api.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-coin.api.mxrcorp.cn";// 外网测试在前面加一个test-
        default:                            return @"https://bs-coin-api.mxrcorp.cn";
    }
}

static inline NSString *PAYMENT_SERVICE_URL(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10105/default.asmx";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-payment-service-mxrcorp.cn/default.asmx";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-payment.service.mxrcorp.cn/default.asmx";// 外网测试在前面加一个test-
        default:                            return @"https://bs-payment-service.mxrcorp.cn/default.asmx";
    }
}

static inline NSString *MXRFileServiceUrl(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:1010/service.asmx";
        case MXRARServerTypeOuterNetFormal: return @"https://fileservice-book.mxrcorp.cn/service.asmx";
        case MXRARServerTypeOuterNetTest:   return @"http://test-fileservice.book.mxrcorp.cn/service.asmx";// 外网测试在前面加一个test-
        default:                            return @"https://fileservice-book.mxrcorp.cn/service.asmx";
    }
}
//动态，话题相关
static inline NSString *MXRSNSServiceUrl(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10121";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-community.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-bs.community.mxrcorp.cn";// 外网测试在前面加一个test-
        default:                            return @"https://bs-community.mxrcorp.cn";
    }
}
//动态分享 5.2.2新的激活码静态页面也用到
static inline NSString *MXRSNSShareServiceUrl(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10122";
        case MXRARServerTypeOuterNetFormal: return @"https://bsweb.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-bsweb.mxrcorp.cn";// 外网测试在前面加一个test-
        default:                            return @"https://bsweb.mxrcorp.cn";
    }
}
//搜索热词服务
static inline NSString *MXRServiceUrl_NEW(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10114/service.asmx";
        case MXRARServerTypeOuterNetFormal: return @"https://service-book.mxrcorp.cn/service.asmx";
        case MXRARServerTypeOuterNetTest:   return @"http://test-service.book.mxrcorp.cn/service.asmx";// 外网测试在前面加一个test-
        default:                            return @"https://service-book.mxrcorp.cn/service.asmx";
    }
}
//搜索提示词服务
static inline NSString *MXRSearchSuggestWord(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10183";
        case MXRARServerTypeOuterNetFormal: return @"http://bs-solr.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://123.58.128.100:10183";// 外网测试在前面加一个test-
        default:                            return @"http://bs-solr.mxrcorp.cn";
    }
}

//没有内网测试的地址
static inline NSString *MXRServiceUrl(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://www.mxrcorp.cn:2632/Services/MultimediaBookService.asmx";
        case MXRARServerTypeOuterNetFormal: return @"https://www.mxrcorp.cn:2632/Services/MultimediaBookService.asmx";
        case MXRARServerTypeOuterNetTest:   return @"http://www.test-mxrcorp.cn:2632/Services/MultimediaBookService.asmx";// 外网测试在前面加一个test-
        default:                            return @"https://www.mxrcorp.cn:2632/Services/MultimediaBookService.asmx"; //默认为正式
    }
}

// 二维码搜索模块
static inline NSString *URL_FOR_SEARCH_QRCODE(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10119";
        case MXRARServerTypeOuterNetFormal: return @"http://p1-search.api.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-search.api.mxrcorp.cn";// 外网测试在前面加一个test-
        default:                            return @"http://p1-search.api.mxrcorp.cn"; //默认为正式
    }
}

static inline NSString *URL_FOR_MESSAGE_SERVER_OLDMK(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10104/default.asmx";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-message-service.mxrcorp.cn/default.asmx";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1.message.service.mxrcorp.cn/default.asmx";// 外网测试在前面加一个test-
        default:                            return @"https://bs-message-service.mxrcorp.cn/default.asmx"; //默认为正式
    }
}

static inline NSString *URL_FOR_MESSAGE_SERVER(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10115";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-msg.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"https://bs-msg.mxrcorp.cn";// 外网测试在前面加一个test-
        default:                            return @"https://bs-msg.mxrcorp.cn"; //默认为正式
    }
}


static inline NSString *URL_FOR_MESSAGE_SERVERNEW(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:20000";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-msg.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"https://bs-msg.mxrcorp.cn";// 外网测试在前面加一个test-
        default:                            return @"https://bs-msg.mxrcorp.cn"; //默认为正式
    }

}

/**
 用户消息模块(Java 环境)

 @return
 */
static inline NSString * URL_FOR_MESSAGE_SERVER_JAVA(){

    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:20000";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-api.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"https://bs-api.mxrcorp.cn";// 外网测试在前面加一个test-
        default:                            return @"https://bs-api.mxrcorp.cn"; //默认为正式
    }
}

//搜索 这里添加了内审版本的搜索
static inline NSString *URL_FOR_SEARCH_SERVER(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:               return @"http://192.168.0.251:10100/default.asmx";
        case MXRARServerTypeOuterNetFormal:         return @"https://bs-search-service.mxrcorp.cn/default.asmx";
        case MXRARServerTypeOuterNetTest:           return @"http://test-p1.search.service.mxrcorp.cn/default.asmx";// 外网测试在前面加一个test-
        case MXRARServerTypeOuterNetFormalReview:   return @"http://p1-search.service-bit.mxrcorp.cn/default.asmx";//审核版本
        default:                                    return @"https://p1-search-service.mxrcorp.cn/default.asmx"; //默认为正式
    }
}


//赚取梦想币
static inline NSString *MasterUrl(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10106/addCoin";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-coin-api.mxrcorp.cn/addCoin";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-coin.api.mxrcorp.cn/addCoin";// 外网测试在前面加一个test-
        default:                            return @"https://bs-coin-api.mxrcorp.cn/addCoin"; //默认为正式
    }
}

//检查书籍是否要更新 没有内网测试服务器
static inline NSString* CHECK_BOOK_UPDATE_URL(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://test-book.service.mxrcorp.cn/service.asmx/CheckBookIsNeedUpdate";
        case MXRARServerTypeOuterNetFormal: return @"https://test-book-service.mxrcorp.cn/service.asmx/CheckBookIsNeedUpdate";
        case MXRARServerTypeOuterNetTest:   return @"http://test-test-book.service.mxrcorp.cn/service.asmx/CheckBookIsNeedUpdate";// 外网测试在前面加一个test-
        default:                            return @"https://test-book-service.mxrcorp.cn/service.asmx/CheckBookIsNeedUpdate"; //默认为正式
    }
}



//获取制造商信息
static inline NSString *BOOK_PRODUCE_URL(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10113/publisher/info";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-bookstore-api.mxrcorp.cn/publisher/info";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-bookstore.api.mxrcorp.cn/publisher/info";// 外网测试在前面加一个test-
        default:                            return @"https://bs-bookstore-api.mxrcorp.cn/publisher/info"; //默认为正式
    }
}


// 上传
static inline NSString *MXR_UPLOAD_BASE_URL(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10116";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-handlefiles-api.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-handlefiles.api.mxrcorp.cn";// 外网测试在前面加一个test-
        default:                            return @"https://bs-handlefiles-api.mxrcorp.cn"; //默认为正式
    }
}



static inline NSString *MXB_PAYRULE_URL(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10109/html/charging_standard.html";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-web.mxrcorp.cn/html/charging_standard.html";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-web.mxrcorp.cn/html/charging_standard.html";// 外网测试在前面加一个test-
        default:                            return @"https://bs-web.mxrcorp.cn/html/charging_standard.html"; //默认为正式
    }
}

////我的消息中 点赞方面的服务（点赞 取消 查看点赞）
static inline NSString *URL_FOR_NOTI_SERVER(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10107";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-datacollection-api.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-datacollection.api.mxrcorp.cn";// 外网测试在前面加一个test-
        default:                            return @"https://bs-datacollection-api.mxrcorp.cn"; //默认为正式
    }
}

static inline NSString *PUBLISHER_ONLY_URL(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:12000";
        case MXRARServerTypeOuterNetFormal: return @"https://miscellaneous.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-miscellaneous.mxrcorp.cn";// 外网测试在前面加一个test-
        default:                            return @"https://miscellaneous.mxrcorp.cn"; //默认为正式
    }
}


//二维码标识 没有内网测试地址
static inline NSString *kPubisheURL(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://www.mxrcorp.cn/download/dreammultimediabook.html";
        case MXRARServerTypeOuterNetFormal: return @"https://www.mxrcorp.cn/download/dreammultimediabook.html";
        case MXRARServerTypeOuterNetTest:   return @"http://www.test-mxrcorp.cn/download/dreammultimediabook.html";// 外网测试在前面加一个test-
        default:                            return @"https://www.mxrcorp.cn/download/dreammultimediabook.html"; //默认为正式
    }
}

//没有内网测试地址
static inline NSString *shareMulitimediaBookLink_huiben(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"https://www.mxrcorp.cn/huiBen/index.html";
        case MXRARServerTypeOuterNetFormal: return @"https://www.mxrcorp.cn/huiBen/index.html";
        case MXRARServerTypeOuterNetTest:   return @"http://www.test-mxrcorp.cn/huiBen/index.html";// 外网测试在前面加一个test-
        default:                            return @"https://www.mxrcorp.cn/huiBen/index.html"; //默认为正式
    }
}

//没有内网测试地址
static inline NSString *shareMulitimediaBookLink(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://multimediabook.mxrcorp.cn/JumpPage.html?guid=";
        case MXRARServerTypeOuterNetFormal: return @"https://multimediabook-mxrcorp.cn/JumpPage.html?guid=";
        case MXRARServerTypeOuterNetTest:   return @"http://test-multimediabook.mxrcorp.cn/JumpPage.html?guid=";// 外网测试在前面加一个test-
        default:                            return @"https://multimediabook-mxrcorp.cn/JumpPage.html?guid="; //默认为正式
    }
}


//处理diy上传文件
static inline NSString *URL_FOR_HANDLE_FILES(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10116/";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-handlefiles-api.mxrcorp.cn/";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-handlefiles.api.mxrcorp.cn/";// 外网测试在前面加一个test-
        default:                            return @"https://bs-handlefiles-api.mxrcorp.cn/"; //默认为正式
    }
}

//处理diy上传后，网页回调
static inline NSString *URL_FOR_HANDLE_UPLOAD_START_CALLBACK(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.251:10109/Html/GoldenKey/UploadSuccess.html";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-web.mxrcorp.cn/Html/GoldenKey/UploadSuccess.html";
        case MXRARServerTypeOuterNetTest:   return @"http://test-p1-web.mxrcorp.cn/Html/GoldenKey/UploadSuccess.html";// 外网测试在前面加一个test-
        default:                           return  @"https://bs-web.mxrcorp.cn/Html/GoldenKey/UploadSuccess.html"; //默认为正式
    }
}

// 通过扫码下载图书完成后记录下载次数
static inline NSString *URL_FOR_Record_BookInfo(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10107";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-datacollection.mxrcorp.cn";
        default:                           return  @"https://bs-datacollection.mxrcorp.cn"; //默认为正式
    }
}
//4D书城消息模块相关API
static inline NSString *URL_FOR_Message_New()
{
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10115";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-msg.mxrcorp.cn";
        default:                            return @"https://bs-msg.mxrcorp.cn"; //默认为正式
    }
}

//4D书城用户模块相关API
static inline NSString *URL_FOR_User_New()
{
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10108";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-user.mxrcorp.cn";
        default:                           return  @"https://bs-user.mxrcorp.cn"; //默认为正式
    }
}

// 通过扫码下载图书完成后记录下载次数
static inline NSString *URL_FOR_BOOK_STORE(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10113";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-core.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:       return @"http://192.168.0.125:10113";// 外网测试在前面加一个test-
        default:                           return  @"https://bs-core.mxrcorp.cn"; //默认为正式
    }
}
//知识树
static inline NSString *URL_FOR_ACKNOELEDGE_TREE(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10113";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-core.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"https://test-p1-bookstore.api.mxrcorp.cn";// 外网测试在前面加一个test-
        default:                           return  @"https://bs-core.mxrcorp.cn"; //默认为正式
    }




}
// 通过扫码下载图书完成后记录下载次数
static inline NSString *URL_FOR_BOOK_CLASSIFICATION(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10113";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-core.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"https://test-bs-core.mxrcorp.cn";// 外网测试在前面加一个test-
        default:                           return  @"https://bs-core.mxrcorp.cn"; //默认为正式
    }
}

// 分层中搜索
static inline NSString *URL_FOR_SEARCHBOOK_IN_CLASSIFICATION(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10119";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-search.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://172.16.10.153:10119";// 外网测试在前面加一个test-
        default:                           return  @"https://bs-search.mxrcorp.cn"; //默认为正式
    }
}

// 5.2.2 付费体系CR 正式环境 https://bs-coin.mxrcorp.cn  测试环境(不用管) http://172.16.10.153:10106  开发环境 http://192.168.0.125:10106
static inline NSString *URL_FOR_BOOKSTORE_COIN_SERVICE(){
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeInnerNet:       return @"http://192.168.0.125:10106";
        case MXRARServerTypeOuterNetFormal: return @"https://bs-coin.mxrcorp.cn";
        case MXRARServerTypeOuterNetTest:   return @"http://test-192.168.0.125:10106";// 外网测试在前面加一个test-
        default:                           return  @"https://bs-coin.mxrcorp.cn"; //默认为正式
    }
}

#define XUAN_CHUAN_HTML_URL @"https://web.mxrcorp.cn/video/xuanchuan.html"


// FAQ
#define URL_PAY_FAQ [NSString stringWithFormat:@"%@/FAQ/Rechargeother",URL_FOR_ACTIVE()] // 支付
#define URL_HUIBEN_FAQ [NSString stringWithFormat:@"%@/faq/activationcode/hb",URL_FOR_ACTIVE()] // 绘本
#define URL_PINTU_FAQ [NSString stringWithFormat:@"%@/faq/activationcode/pt",URL_FOR_ACTIVE()] // 拼图
#define URL_RENZHIKA_FAQ  [NSString stringWithFormat:@"%@/faq/activationcode/rzk",URL_FOR_ACTIVE()] // 认知卡

// 梦想钻相关
#define BUY_COIN_PRICE_LIST @"mxz/price/list" // 获取梦想钻充值列表
#define BUY_GET_ORDER_NO  @"mxz/order/no" // 获取订单信息
#define BUY_VERIFY_PURCHASE  @"/callback/applepay"//提交购买凭证
#define BUY_UPLOAD_DIY_EXPEND_COIN @"/diy/coin/use" // diy支付梦想币
#define BUY_CANCEL_UPLOAD_RETUREN_COIN @"/diy/coin/return" // 取消diy上传，返还梦想币

// 数据统计相关
#define DATA_BINNER_CLICK @"/banner/clickdata" // 记录banner的点击次数API
#define DATA_SHARE_COUNT @"/book/sharecount" // 记录每本书的分享次数API
#define DATA_READING_DURATION @"/book/readingduration" // 阅读时长
#define DATA_ADD_ERROR_BOOK_PAGE @"/error_book_page/add" // 报错
#define DATA_REPORT_BOOK @"/report/book" // 举报（Diy图书）
#define DATA_GET_REPORT_LIST @"/report/text/list" // 获取举报具体类型
#define DATA_DOWNLOAD_BOOK_LOGS @"/download/book/logs/add" // 下载前的图书信息收集
#define DATA_USERLIKEBOOK @"/book/praise" // 用户对图书点赞
#define DATA_USERCANCELLIKEBOOK @"/book/praise/cancel" // 用户对图书取消点赞
// 基本服务
#define BASE_GIFT_COIN_NUM @"/config/giftcoinnum" // 获取金币相关基本数据
#define BASE_TOPICS_DETAIL @"/community/topics"//获取某个话题的动态列表
#define BASE_DIANZHAN_DETAIL @"/api/praise"//获取点赞详情
#define BASE_GIFT_READ_TIME @"/config/reading/duration" // 获取阅读时长
#define BASE_SHOWTHING @"/config/system" // 获取是否显示view

#define BASE_CHECK_BOOK_STATUS @"check/book/status" // 检测图书状态
#define BASE_UPDATE_DEVICEUUID @"device/info/update" // 更新deviceUUID

#define BASE_GET_TEMPLATE_WITH_QRCODE @"/scan/qrcode"
#define BASE_GET_TEMPLATE_WITH_BARCODE @"/scan/barcode"
#define BASE_GET_TEMPLATE_WITH_QRCODE_CONTENT @"/scan/qrcode/content"
#define APPSTORE_UPDATE @"https://itunes.apple.com/cn/app/4d-shu-cheng-er-tong-mo-fa/id842495919?mt=8"

#define PUBLISHERBOOK_ACTIVE  [NSString stringWithFormat:@"%@/scan/qrcode/activate/book",URL_FOR_BASE_ACTIVE()] //出版社定制二维码样本书激活服务
#define PUBLISHERCIDINFORMATION  [NSString stringWithFormat:@"%@/scan/customization",URL_FOR_BASE()] //获取出版社定制二维码信息
#define YULAN_BOOKSEARCH [NSString stringWithFormat:@"%@/GetBookPreview",MXRServiceUrl_NEW()]//预览二维码请求书本信息
#define NOTFIMAL_BOOKSEARCH [NSString stringWithFormat:@"%@/DownLoadBookBefore",MXRServiceUrl_NEW()] // 非正式二维码请求书本信息
#define BAR_BOOKSEARCH [NSString stringWithFormat:@"%@/BookScanning",URL_FOR_BOOKSTORE_SERVER()] // 一维码和正式二维码请求书本信息
#define BANNINGCHANNELCODE [NSString stringWithFormat:@"%@/scan/channel/binding",URL_FOR_BASE()]//扫描绑定出版社和渠道码
#define Presspraise @"presspraise"//点赞
#define CheckreadyPraise @"checkreadyPraise"//获取有没有点赞
//私信
#define Message_ChatContent @"message/private/contentNew"          //获取私信具体的数据
#define Message_DeletChatData @"message/private/content/delete"   
#define Message_SendChatContent @"message/private/reply"        //发送私信
#define MXRLetterNetworkManagerSendLetter @"message/private/send" //通过senderid 和 receiverid 来发送私信消息
#define Letter_GetLetterList_Method @"message/private/list"     //获取私信列表
#define Letter_DeleteLetter_Method @"message/private/delete"    //删除私信列表的某个私信数据
#define Message_GetCommentContent @"message/msglist"            //获取评论列表
#define Letter_Get_Firend_Method @"/user/attention/users"   //获取私信的好友列表

#define Message_GetCommentContent_NEW @"message/msglist2"  

#define Message_CommentList_SendComment @"comment/addcommentreply" //回复评论
#define Message_Noti_zan @"notice/message/praise"                  //用户评论点赞
#define Message_Noti_CancelZan @"notice/message/praise/cancel"     //用户评论取消点赞
#define Message_Noti_ZanState @"notice/message/praise/check"       //获取点赞状态
#define Message_Comment_Report @"message/report"                   //举报
#define Message_GetMessage_Zan_Comment_Count @"message/notice/info"//获取通知中，点赞和评论的数目
#define CommentWeb_DeleteComment @"message/delcomment"             //删除评论
#define CommentWeb_DeleteCommentReply @"message/delreply"          //删除评论回复
#define Message_Noti_Delete_Comment @"message/notice/reply/delete" //通知消息详情删除评论
#define Message_Noti_Delete_CommentReply @"message/notice/delreply" //删除通知评论的回复
#define Message_Noti_Add_CommentReply @"message/notice/reply" //新增通知评论的回复




#define MyComment_GetMyCommentList @"message/mymsglist"                             //我的评论 获取评论列表
#define MyComment_DeleteMyComment @"message/delcomment"                           //我的评论 删除评论
#define MyComment_DeleteMyCommentReply @"message/delreply"                   //我的评论 删除评论回复
#define MyComment_DeleteMyCommentNotiReply @"message/notice/reply/delete"                   //我的评论 删除通知回复

//图书评论详情
#define Cuscomment_Getcomment  @"cuscomment/getcomment"              //获得所有图书评论
#define Add_Comment_Praise     @"cuscomment/addcommentpraise"        //图书详情评论点赞
#define Cancel_Comment_Praise  @"cuscomment/cancelcommentpraise"     //取消赞
#define Message_Delcomment     @"message/delcomment"                 //删除评论
#define CusComment_Add_Comment @"cuscomment/addcomment"              //增加评论
#define CusComment_Add_Comment_Reply      @"cuscomment/addcommentreply"

//将用户充值的梦想币转成梦想钻
#define Message_Coin_to_MXZ [URL_FOR_BASE() stringByAppendingString:@"/handle/data/coin_to_mxz"]

//我界面我的梦想币网页
#define WEBVIEW_MY_MXB(arg)   [URL_FOR_ACTIVE() stringByAppendingFormat:@"/HTML/user_Diamonds.html?diamonds=%ld",arg]

//我充值界面账单网页
#define WEBVIEW_BILL(arg)   [URL_FOR_ACTIVE() stringByAppendingFormat:@"/HTML/user_Bill.html?uid=%@",arg]

//获取彩蛋
#define Message_ColorEgg_Gft  [URL_FOR_BASE() stringByAppendingString:@"/config/GiftEggs"]


//获取banner
#define Message_Get_Banner [URL_FOR_BOOKSTORE_SERVER() stringByAppendingString:@"/GetBannerInformationByTagID"]

//赚取梦想币说明
#define EarnMXBExplainWebviewURL [URL_FOR_ACTIVE() stringByAppendingString:@"/Html/coin_explain.html"]



//================================================================
#define Detail_Comment @"cuscomment/getcommentreply"           //评论详情
#define AddDetail_Comment @"cuscomment/addcommentreply"        //增加评论回复
#define Delete_Main_Comment @"message/delcomment"             //删除主评论
#define Delete_Reply_Comment @"message/delreply"             //删除评论回复
#define Comment_Praise @"cuscomment/addcommentpraise"         //点赞
#define Cancel_Praise @"cuscomment/cancelcommentpraise"          //取消点赞
//评论数据请求
#define Get_Detail_Comment [NSString stringWithFormat:@"%@/%@",URL_FOR_MESSAGE_SERVER(),Detail_Comment]
//添加评论回复
#define Get_AddDetail_Comment [NSString stringWithFormat:@"%@/%@",URL_FOR_MESSAGE_SERVER(),AddDetail_Comment]
//删除主评论
#define Get_Delete_Main_Comment [NSString stringWithFormat:@"%@/%@",URL_FOR_MESSAGE_SERVER(),Delete_Main_Comment]
//删除评论回复
#define Get_Delete_Reply_Comment [NSString stringWithFormat:@"%@/%@",URL_FOR_MESSAGE_SERVER(),Delete_Reply_Comment]
//登录绑定用户信息
#define Get_Bandel_Detail @"useraccount/show"  
// 梦想圈首页
#define BookSNS_ALLMoment @"/community/dynamics"
#define BookSNS_NewMoment @"/community/dynamics/previous"
#define BookSNS_NewMomentCount @"/community/dynamics/previous/count"
#define BookSNS_OldMoment @"/community/dynamics/next"
#define BookSNS_CancleFocus @"/community/dynamics/user/cancel"
#define BookSNS_LikeMoment @"/community/dynamics/user/like"
#define BookSNS_HotTopicRecommend @"/community/topics/recommend"
#define BookSNS_Report @"/community/dynamics/user/report"
#define BookSNS_RecommentDynamic @"/community/dynamics/priority/sort"

#define My_BookSNS_ALLMoment @"/community/dynamics/my"
#define My_BookSNS_NewMoment @"/community/dynamics/my/previous"
#define My_BookSNS_NewMomentCount @"/community/dynamics/my/previous/count"
#define My_BookSNS_OldMoment @"/community/dynamics/my/next"

//梦想圈 搜索话题
#define SNS_SearchTopic  @"community/topics/fuzzy/query"
#define SNS_SearchHotTopic  @"community/topics/hot"
#define SNS_DynamicPraise @"user/like"
#define SNS_TopicShareCollect @"/community/topics/collect/share" // 收集话题分享信息
//梦想圈动态详情
#define BookSNSDetail_CreateComment @"/community/comments/create"
#define BookSNSDetail_ReplyComment @"community/comments/relpy"
#define BookSNSDetail_AddPraise @"community/comments/like"
#define BookSNSDetail_CanclePraise @"community/comments/cancel"
#define BookSNSDetail_ReportComment @"community/comments/report"

#define Get_Bandel_Detail @"useraccount/show"

//通过扫码下载完成后 将下载数据给服务器做记录
#define Record_BookInfo @"/download/book/logs/add/downloaded"
#define Upload_BookInfo_For_Record [NSString stringWithFormat:@"%@/%@",URL_FOR_Record_BookInfo(),Record_BookInfo]

// 新书城
#define BookStore_New_Home @"/home/%@" // 书城首页
// 分类中搜索
#define SEARCH_CLASSIFICATION @"/search/classification"
#define SEARCH_HomePage @"/search/solr/books"     /*新的搜索服务*/
//#define SEARCH_HomePage @"/search/home"    /*老的搜索服务*/
#define SEARCH_HomePage_Review @"/search/home/bit"
//获取赠送图书数据
#define PresentBook @"/present/book"
//获取神灯推送信息
#define MagicLampPresent @"/core/magicLamp/present"

///  url standard by Martin.liu
#define URLStringCat(_host_, _serviceurl_) [_host_ stringByAppendingPathComponent:_serviceurl_]

/// URL统一管理规范    模块注释 ： 说明服务的模块范围和做相关服务的前端作者名称
/// URL统一管理规范    后缀注释 ： 说明接口作者以及接口的功能描述
/// URL统一管理规范    全URL注释： 说明接口功能描述
/// 定义名称之间尽量保持垂直对齐

#pragma mark -
#pragma mark 图书详情、图书评论相关服务
/// ==========================================================================================
/// author : liulongDev
/// 图书详情、图书评论相关服务的后缀路径
#define SuffixURL_BookDetail_GetDetail              @"/book/detail"                          // 获取图书的详情
#define SuffixURL_BookDetail_GetComments            @"/cuscomment/getcomment"                // 获得所有图书评论
#define SuffixURL_BookDetail_GetCommentDetail       @"/cuscomment/getcommentreply"           // 评论详情
#define SuffixURL_BookDetail_PraiseComment          @"/cuscomment/addcommentpraise"          // 图书详情评论点赞
#define SuffixURL_BookDetail_CancelPraiseComment    @"/cuscomment/cancelcommentpraise"       // 取消赞
#define SuffixURL_BookDetail_AddBookComment         @"/cuscomment/addcomment"                // 增加图书评论
#define SuffixURL_BookDetail_ReplyBookComment       @"/cuscomment/addcommentreply"           // 对书的评论进行回复
#define SuffixURL_BookDetail_DeleteComment          @"/message/delcomment"                   // 删除评论
#define SuffixURL_BookDetail_DeleteReplyComment     @"/message/delreply"                     // 删除评论回复
#define SuffixURL_BookDetail_PraiseBook             @"/book/praise"                          // 用户对图书点赞
#define SuffixURL_BookDetail_CancelPraiseBook       @"/book/praise/cancel"                   // 用户对图书取消点赞
#define SuffixURL_BookDetail_AddCollectionBook      @"/user/book/collection/add"             // 收藏
#define SuffixURL_BookDetail_CacncelCollectionBook  @"/user/book/collection/cancel"          // 批量删除
#define SuffixURL_BookDetail_AppraiseBook           @"/api/praise/presspraise"               // 对图书进行评价 星星评价
#define SuffixURL_BookDetail_CheckIsAppraiseBook    @"/api/praise/checkreadyPraise"          // 获取图书是否已经评价过
#define SuffixURL_BookDetail_DeleteBookPage         @"/book/delete/page"                    // 特殊用户删除指定图书指定页

/// 图书详情、图书评论相关服务的全路径
#define ServiceURL_BookDetail_GetDetail             URLStringCat(URL_FOR_BOOK_CLASSIFICATION(), SuffixURL_BookDetail_GetDetail)     // 获取图书的详情
#define ServiceURL_BookDetail_GetComments           URLStringCat(URL_FOR_Message_New(), SuffixURL_BookDetail_GetComments) // 更换地址 URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_GetComments)       // 获得所有图书评论
#define ServiceURL_BookDetail_GetCommentDetail      URLStringCat(URL_FOR_Message_New(), SuffixURL_BookDetail_GetCommentDetail) // 更换地址 URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_GetCommentDetail)  // 评论详情
#define ServiceURL_BookDetail_PraiseComment         URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_PraiseComment)     // 图书详情评论点赞
#define ServiceURL_BookDetail_CancelPraiseComment   URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_CancelPraiseComment)   // 取消赞
#define ServiceURL_BookDetail_AddBookComment        URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_AddBookComment)        // 增加图书评论
#define ServiceURL_BookDetail_ReplyBookComment      URLStringCat(URL_FOR_Message_New(), SuffixURL_BookDetail_ReplyBookComment) //更换地址 URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_ReplyBookComment)  // 对书的评论进行回复
#define ServiceURL_BookDetail_DeleteComment         URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_DeleteComment)     // 删除评论
#define ServiceURL_BookDetail_DeleteReplyComment    URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_DeleteReplyComment)    // 删除评论回复
#define ServiceURL_BookDetail_PraiseBook            URLStringCat(URL_FOR_BannerClick_SERVER(), SuffixURL_BookDetail_PraiseBook)        // 用户对图书点赞
#define ServiceURL_BookDetail_CancelPraiseBook      URLStringCat(URL_FOR_BannerClick_SERVER(), SuffixURL_BookDetail_CancelPraiseBook)  // 用户对图书取消点赞
#define ServiceURL_BookDetail_AddCollectionBook     URLStringCat(URL_FOR_BOOK_STORE(), SuffixURL_BookDetail_AddCollectionBook)     // 收藏
#define ServiceURL_BookDetail_CacncelCollectionBook URLStringCat(URL_FOR_BOOK_STORE(), SuffixURL_BookDetail_CacncelCollectionBook) // 批量删除
#define ServiceURL_BookDetail_AppraiseBook          URLStringCat(URL_FOR_BannerClick_SERVER(), SuffixURL_BookDetail_AppraiseBook)      // 对图书进行评价 星星评价
#define ServiceURL_BookDetail_CheckIsAppraiseBook   URLStringCat(URL_FOR_BannerClick_SERVER(), SuffixURL_BookDetail_CheckIsAppraiseBook)   // 获取图书是否已经评价过
#define ServiceURL_BookDetail_DeleteBookPage        URLStringCat(URL_FOR_ACKNOELEDGE_TREE(), SuffixURL_BookDetail_DeleteBookPage)      // 特殊用户删除指定图书指定页
#pragma mark 图书详情、图书评论相关服务 end >>
/// author : liulongDev
/// ==========================================================================================

#pragma mark -
#pragma mark 知识树相关服务
/// ==========================================================================================
/// author : liulongDev
/// 知识树相关服务的后缀路径
#define SuffixURL_KnowledgeTree_PostAnswer                  @"/knowledge/user/question/record/insert"           // 用户答题记录   by 张来涛
#define SuffixURL_KnowledgeTree_GetBookLockTreeInfo         @"/knowledge/subject/info"                          // 知识柱树状信息  by 张来涛
#define SuffixURL_KnowledgeTree_ClearBookKnowledgeTreeInfo  @"/knowledge/user/question/record/delete"    // 知识树清除用户记录 by 张来涛 蚕宝宝死亡的时候用到

/// 知识树相关服务的全路径
#define ServiceURL_KnowledgeTree_PostAnswer                     URLStringCat(URL_FOR_ACKNOELEDGE_TREE(), SuffixURL_KnowledgeTree_PostAnswer)                // 获取图书的详情
#define ServiceURL_KnowledgeTree_GetBookLockTreeInfo            URLStringCat(URL_FOR_ACKNOELEDGE_TREE(), SuffixURL_KnowledgeTree_GetBookLockTreeInfo)       // 知识柱树状信息  by 张来涛
#define ServiceURL_KnowledgeTree_ClearBookKnowledgeTreeInfo     URLStringCat(URL_FOR_ACKNOELEDGE_TREE(), SuffixURL_KnowledgeTree_ClearBookKnowledgeTreeInfo)// 知识树清除用户记录 by 张来涛 蚕宝宝死亡的时候用到
/// author : liulongDev
/// ==========================================================================================

#pragma mark -
#pragma mark 七牛相关服务
/// ==========================================================================================
/// author : GXD
/// 七牛相关服务的子路径
#define SuffixURL_GETQiNiuToken                             @"/qiniu/uploadtoken"

/// 七牛相关服务的全路径
#define ServiceURL_QINIU_GETQiNiuToken URLStringCat(URL_FOR_BASE_ACTIVE(), SuffixURL_GETQiNiuToken)                // 获取七牛的token
/// author : GXD
/// ==========================================================================================

#pragma mark -
#pragma mark 用户相关服务
/// ==========================================================================================
/// 用户相关服务的子路径
/// author : GXD
#define SuffixURL_UpdateUserImage                               @"/update/user/logo"
#define SuffixURL_User_GetUserInfo                               @"/user/info"           // add by liulongdev 获取用户信息

/// 用户相关服务的全路径
#define ServiceURL_USER_UpdateUserIcon      URLStringCat(URL_FOR_User_New(), SuffixURL_UpdateUserImage)                 // 更新用户头像
#define ServiceURL_User_GetUserInfo         URLStringCat(MXRUSER_API_URL_ForJAVA(), SuffixURL_User_GetUserInfo)                  // 获取用户信息
/// author : GXD
/// ==========================================================================================

#pragma mark -
#pragma mark 5.2.2增加现实优惠CR
/// ==========================================================================================
/// 知识树相关服务的后缀路径
/// author : liulongDev
#define SuffixURL_BookStoreCoin_GetPayMode                  @"/coin/book/paymode"           // 获取图书购买方式   by youfeng.ma
#define SuffixURL_BookStoreCoin_PurchaseBook                @"/coin/book/purchase"          // 购买图书 （新的购买图书接口）  by youfeng.ma

/// 知识树相关服务的全路径
#define ServiceURL_BookStoreCoin_GetPayMode                     URLStringCat(URL_FOR_BOOKSTORE_COIN_SERVICE(), SuffixURL_BookStoreCoin_GetPayMode)          // 获取图书购买方式
#define ServiceURL_BookStoreCoin_PurchaseBook                   URLStringCat(URL_FOR_BOOKSTORE_COIN_SERVICE(), SuffixURL_BookStoreCoin_PurchaseBook)        // 购买图书 （新的购买图书接口）
/// author : liulongDev
/// ==========================================================================================

#pragma mark -
#pragma mark 登录模块重新整理
/// ==========================================================================================
/// 登录模块相关服务的后缀路径
/// author : liulongDev
#define SuffixURL_Login_LoginByMobile                       @"/login/mobile"            // 手机登录
#define SuffixURL_Login_LoginByEmail                        @"/login/email"             // 邮箱登录
#define SuffixURL_Login_LoginByThird                        @"/login/tpos"              // 第三方登录
#define SuffixURL_Login_GetBindAccountInfo                  @"/useraccount/show"        // 获取账号绑定的信息
#define SuffixURL_Login_BindUserAccount                     @"/useraccount/bind"        // 绑定账号动作
#define SuffixURL_Login_UnBindUserAccount                   @"/useraccount/unbind"      // 解绑账号动作
#define SuffixURL_Login_CheckPassword                       @"/user/check/password"     // 验证密码是否正确
#define SuffixURL_Login_ChangePassword                      @"/update/pwd"              // 修改密码

/// 登录模块相关服务的全路径
#define ServiceURL_Login_LoginByMobile                      URLStringCat(MXRUSER_API_URL_ForJAVA(), SuffixURL_Login_LoginByMobile)  // 手机登录接口
#define ServiceURL_Login_LoginByEmail                       URLStringCat(MXRUSER_API_URL_ForJAVA(), SuffixURL_Login_LoginByEmail)   // 邮箱登录接口
#define ServiceURL_Login_LoginByThird                       URLStringCat(MXRUSER_API_URL_ForJAVA(), SuffixURL_Login_LoginByThird)   // 第三方登录接口
#define ServiceURL_Login_GetBindAccountInfo                 URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_GetBindAccountInfo)    // 账号绑定的信息
#define ServiceURL_Login_BindUserAccount                    URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_BindUserAccount)    // 账号绑定的信息
#define ServiceURL_Login_UnBindUserAccount                  URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_UnBindUserAccount)    // 账号绑定的信息
#define ServiceURL_Login_CheckPassword                      URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_CheckPassword)    // 验证密码是否正确
#define ServiceURL_Login_ChangePassword                     URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_ChangePassword)    // 修改密码

/// author : liulongDev
/// ==========================================================================================

/// author : GXD
/// ==========================================================================================

#pragma mark -
#pragma mark 用户消息相关服务
/// ==========================================================================================
/// 用户消息相关服务的子路径
/// author : GXD
#define SuffixURL_GetUserMsgZanList                             @"/message/praise/list"//获取赞列表
#define SuffixURL_GetUserMsgCommentList                             @"/message/msglistNew"//获取评论列表

/// 用户消息相关服务的全路径
#define ServiceURL_USER_GetUserMsgZanList      URLStringCat(URL_FOR_MESSAGE_SERVERNEW(), SuffixURL_GetUserMsgZanList)
#define ServiceURL_USER_GetUserMsgCommentList      URLStringCat(URL_FOR_MESSAGE_SERVERNEW(), SuffixURL_GetUserMsgCommentList)


/// author : GXD
/// ==========================================================================================
#endif
