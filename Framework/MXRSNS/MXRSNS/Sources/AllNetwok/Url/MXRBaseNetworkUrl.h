//
//  MXRBaseNetworkUrl.h
//  huashida_home
//
//  Created by 周建顺 on 2017/5/25.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRBaseNetworkUrl_h
#define MXRBaseNetworkUrl_h

#import "MXRNetworkUrl.h"


static inline NSString *MXR_BASE_SERVICE_API_URL(){
    return MXRBASE_API_URL();
}

#define SuffixURL_Base_device_info_id               @"base/device/info/bind" //  从服务端获取游客的唯一标识符
//#define ServiceURL_Base_device_info_id              URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_Base_device_info_id)

//#define SuffixURL_Base_device_info_bind             @"base/device/info/bind" // 将本地的唯一标识符和userid进行绑定
#define ServiceURL_Base_device_info_bind            URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_Base_device_info_id)


#define SuffixURL_PUBLISHERBOOK_ACTIVE              @"base/scan/qrcode/activate/book"
#define SuffixURL_PUBLISHERCIDINFORMATION           @"base/scan/customization"
#define SuffixURL_BANNINGCHANNELCODE                @"base/scan/channel/binding"

#define ServiceURL_PUBLISHERBOOK_ACTIVE                 URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_PUBLISHERBOOK_ACTIVE) //出版社定制二维码样本书激活服务
#define ServiceURL_PUBLISHERCIDINFORMATION              URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_PUBLISHERCIDINFORMATION) //获取出版社定制二维码信息
#define ServiceURL_BANNINGCHANNELCODE                   URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_BANNINGCHANNELCODE)//扫描绑定出版社和渠道码

#define SuffixURL_SCAN_RESOURCE_PREVIEW(__pid)          [NSString stringWithFormat:@"/areditor/resource/prev/%@", __pid] // 资源商店资源预览
#define ServiceURL_SCAN_RESOURCE_PREVIEW(__pid)         URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_SCAN_RESOURCE_PREVIEW(__pid))


/// 七牛相关服务的子路径
#define SuffixURL_GETQiNiuToken                             @"base/qiniu/uploadtoken"
/// 七牛相关服务的全路径
#define ServiceURL_QINIU_GETQiNiuToken URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_GETQiNiuToken)            // 获取七牛的token


// 基本服务
#define SuffixURL_BASE_GIFT_COIN_NUM @"base/config/giftcoinnum" // 获取金币相关基本数据
#define ServiceURL_BASE_GIFT_COIN_NUM  URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_BASE_GIFT_COIN_NUM)

#define SuffixURL_BASE_SHOWTHING @"base/config/system" // 获取是否显示view
#define ServiceURL_BASE_SHOWTHING  URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_BASE_SHOWTHING)

#define SuffixURL_BASE_GIFT_READ_TIME @"base/config/reading/duration" // 获取阅读时长
#define ServiceURL_BASE_GIFT_READ_TIME  URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_BASE_GIFT_READ_TIME)

#define SuffixURL_BASE_CHECK_BOOK_STATUS @"base/check/book/status" // 检测图书状态
#define ServiceURL_BASE_CHECK_BOOK_STATUS  URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_BASE_CHECK_BOOK_STATUS)

#define SuffixURL_BASE_UPDATE_DEVICEUUID @"base/device/info/update" // 更新deviceUUID
#define ServiceURL_BASE_UPDATE_DEVICEUUID  URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_BASE_UPDATE_DEVICEUUID)


//从服务端请求书城采集数据的方式
#define SuffixURL_BASE_SERVICE_config_client            @"base/config/client"
#define ServiceURL_BASE_SERVICE_config_client           URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_BASE_SERVICE_config_client)

#endif /* MXRBaseNetworkUrl_h */
