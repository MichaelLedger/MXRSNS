//
//  UserDefaultKey.h
//  huashida_home
//
//  Created by Martin.Liu on 2018/3/16.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef UserDefaultKey_h
#define UserDefaultKey_h

#define USERKEY_Setting_WWANNetworkEnable   @"USERKEY_Setting_WWANNetworkEnable"     // 设置中的 允许手机网络进行下载
#define USERKEY_Setting_SmoothStyle         @"USERKEY_Setting_SmoothStyle"     // 设置中的 流畅模式
#define USERKEY_Setting_ARCameraOn          @"USERKEY_Setting_ARCameraOn"     // 设置中的 流畅模式
#define USERKEY_Manual_Set_ARCamera          @"USERKEY_Manual_Set_ARCamera"     // 用户手动设置流畅模式

#define USERKEY_VersionReviewRequesetSuccessKey @"USERKEY_VersionReviewRequesetSuccessKey"  // 上一次成功获取到是否开启安全机制的版本号key
#define USERKEY_ReviewSecurityOnKey                   @"USERKEY_ReviewSecurityOnKey"            // 安全机制开启key

#define SHOWBOOKGUIDEVIDEO_BOOK_TYPE_NORMAL   @"USERKEY_SHOWBOOKGUIDEVIDEO_BOOK_TYPE_NORMAL"   //点读书.mp4
#define SHOWBOOKGUIDEVIDEO_BOOK_TYPE_4D_TIMETABLE   @"USERKEY_SHOWBOOKGUIDEVIDEO_BOOK_TYPE_4D_TIMETABLE"  //课程表.mp4
#define SHOWBOOKGUIDEVIDEO_BOOK_TYPE_CAIDAN   @"USERKEY_SHOWBOOKGUIDEVIDEO_BOOK_TYPE_CAIDAN"   //4D彩蛋.mp4
#define SHOWBOOKGUIDEVIDEO_BOOK_TYPE_SHIZIDABAIKE   @"USERKEY_SHOWBOOKGUIDEVIDEO_BOOK_TYPE_SHIZIDABAIKE"  //4D认知卡.mp4
#define SHOWBOOKGUIDEVIDEO_BOOK_TYPE_COGNIVECARD   @"USERKEY_SHOWBOOKGUIDEVIDEO_BOOK_TYPE_COGNIVECARD"  //4D认知卡B.mp4
#define SHOWBOOKGUIDEVIDEO_BOOK_TYPE_HUIBEN   @"USERKEY_SHOWBOOKGUIDEVIDEO_BOOK_TYPE_HUIBEN"  //绘本.mp4
#define SHOWBOOKGUIDEVIDEO_BOOK_TYPE_4D_GLASSES_OR_SECURITY   @"USERKEY_SHOWBOOKGUIDEVIDEO_BOOK_TYPE_4D_GLASSES_OR_SECURITY"  //4D魔镜.mp4



// 只使用一次的标识用的key
#define UserDefaultOnceKey_SettingCameraOn @"UserDefaultOnceKey_SettingCameraOn"    // 默认设置摄像头开启调用一次标识
#define UserDefaultOnceKey_SettingSmoothStyleOn @"UserDefaultOnceKey_SettingSmoothStyleOn"    // 默认设置流畅模式开启调用一次标识
#define UserDefaultOnceKey_AlertSmoothStyleManualOff @"UserDefaultOnceKey_AlertSmoothStyleManualOff"    // 提示关闭流畅模式调用一次标识

#define CACHE_USERICON_KEY [NSString stringWithFormat:@"%@%@",[UserInformation modelInformation].userID,@"userIcon"]

#define USERKEY_GUIDE_EGGS @"USERKEY_GUIDE_EGGS"   //彩蛋分组引导只显示一次 V5.10.0

#define USERKEY_COUPON_NEWDATE @"USERKEY_COUPON_NEWDATE"  // 记录用户最新获取优惠券的时间

#define USERKEY_WHETHER_SHOW_COUPON_TIP @"USERKEY_WHETHER_SHOW_COUPON_TIP"  // 是否显示优惠券提示的小红点 V5.13.0

#define USERKEY_LastVersionKey @"USERKEY_LastVersionKey"  // 记录上一次版本
#define USERKEY_UserIsAgreePravacyKey @"USERKEY_UserIsAgreePravacyKey" // 用户是否同意隐私协议

#define USERKEY_PK_VIP_PRIVILEGE @"USERKEY_PK_VIP_PRIVILEGE" //问答VIP特权弹窗 V5.18.0

#endif /* UserDefaultKey_h */
