//
//  MXRCoinNetworkUrl.h
//  huashida_home
//
//  Created by 周建顺 on 2017/5/25.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRCoinNetworkUrl_h
#define MXRCoinNetworkUrl_h

#import "MXRNetworkUrl.h"

// 5.2.2 付费体系CR
// 购买梦想币相关接口
//赚取梦想币
static inline NSString *MXR_BOOKSTORE_COIN_SERVICE_API_URL(){
    return MXRBASE_API_URL();
}




// 兑换梦想币列表
#define SuffixURL_ExchangeCoinList @"coin/change/mxz/mxb/list" // 获取列表
#define ServiceURL_ExchangeCoinList   URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_ExchangeCoinList)

// 兑换梦想币
#define SuffixURL_ExchangeCoin @"coin/change/mxz/mxb" // 获取列表
#define ServiceURL_ExchangeCoin   URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_ExchangeCoin)


// 用户休息获得梦想币
#define SuffixURL_UserResetGetCoin @"coin/present"
#define ServiceURL_UserResetGetCoin   URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_UserResetGetCoin)
//

#define SuffixURL_kMXZExchangeForMXB @"coin/change/mxz/mxb"

#pragma mark 5.2.2增加现实优惠CR
/// ==========================================================================================
/// 知识树相关服务的后缀路径
/// author : liulongDev
#define SuffixURL_BookStoreCoin_GetPayMode                  @"coin/book/paymode"           // 获取图书购买方式   by youfeng.ma
#define SuffixURL_BookStoreCoin_PurchaseBook                @"coin/book/purchase"          // 购买图书 （新的购买图书接口）  by youfeng.ma

/// 知识树相关服务的全路径
#define ServiceURL_BookStoreCoin_GetPayMode                     URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_BookStoreCoin_GetPayMode)          // 获取图书购买方式
#define ServiceURL_BookStoreCoin_PurchaseBook                   URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_BookStoreCoin_PurchaseBook)        // 购买图书 （新的购买图书接口）



#define SuffixURL_BookStoreCoin_AddCoin_GetCoinWay          @"coin/addCoin/GetCoinWay"
#define ServiceURL_BookStoreCoin_AddCoin_GetCoinWay         URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_BookStoreCoin_AddCoin_GetCoinWay)

// 梦想钻相关
#define SuffixURL_BUY_COIN_PRICE_LIST                   @"coin/mxz/price/list"   // 获取梦想钻充值列表
#define ServiceURL_BUY_COIN_PRICE_LIST                  URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_BUY_COIN_PRICE_LIST)

#define SuffixURL_BUY_GET_ORDER_NO                      @"trading/bookstore/order/applepay"     // 获取订单信息
#define ServiceURL_BUY_GET_ORDER_NO                     URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_BUY_GET_ORDER_NO)


#define SuffixURL_BUY_VERIFY_PURCHASE                   @"trading/check/status/bookstore/applepay"    //提交购买凭证
#define ServiceURL_BUY_VERIFY_PURCHASE                  URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_BUY_VERIFY_PURCHASE)

#define SuffixURL_BUY_UPLOAD_DIY_EXPEND_COIN            @"coin/diy/coin/use"    // diy支付梦想币
#define ServiceURL_BUY_UPLOAD_DIY_EXPEND_COIN           URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_BUY_UPLOAD_DIY_EXPEND_COIN)

#define SuffixURL_BUY_CANCEL_UPLOAD_RETUREN_COIN        @"coin/diy/coin/return"     // 取消diy上传，返还梦想币
#define ServiceURL_BUY_CANCEL_UPLOAD_RETUREN_COIN       URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_BUY_CANCEL_UPLOAD_RETUREN_COIN)

#define SuffixURL_addCoin_firstlogin                    @"coin/addCoin/firstlogin"
#define SuffixURL_addCoin_update_app                    @"coin/addCoin/update/app"

#define ServiceURL_AddCoinFirstlogin                    URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_addCoin_firstlogin)
#define ServiceURL_AddCoinUpdate                        URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_addCoin_update_app)


// 意见反馈
#define SuffixURL_Coin_AddCoin_Feedback @"coin/addCoin/FeedBack"
#define ServiceURL_Coin_AddCoin_Feedback   URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_Coin_AddCoin_Feedback)

//app评分添加梦想币接口
#define SuffixURL_Coin_AddCoin_AppScore @"coin/addcoin/evaluate/app"
#define ServiceURL_Coin_AddCoin_AppScore   URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_Coin_AddCoin_AppScore)

// 获取用户优惠券列表接口 V5.11.0
#define SuffixURL_Coupon_UserCouponList          @"coin/coupon/userCouponList"
#define ServiceURL_Coupon_UserCouponList         URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_Coupon_UserCouponList)

// 获取用户优惠券数量 V5.11.0
#define SuffixURL_Coupon_UserCouponCount          @"coin/coupon/getUserCouponCount"
#define ServiceURL_Coupon_UserCouponCount         URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_Coupon_UserCouponCount)

// 充值赠送优惠券 V5.11.0
#define SuffixURL_Coupon_RechargePresent         @"coin/coupon/present"
#define ServiceURL_Coupon_RechargePresent         URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_Coupon_RechargePresent)

// 图书章节答题赠送梦想币 V5.11.0
#define SuffixURL_MXB_ExercisePresent         @"coin/present/bookQuestion"
#define ServiceURL_MXB_ExercisePresent         URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_MXB_ExercisePresent)

// 用户vip充值记录V5.13.0
#define SuffixURL_VIP_RechargeList        @"/coin/vip/recharge/list"
#define ServiceURL_VIP_RechargeList         URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_VIP_RechargeList)

// 领取优惠券 V5.14.0
#define SuffixURL_Coupon_DrawCoupon          @"coin/coupon/userCouponAdd"
#define ServiceURL_Coupon_DrawCoupon         URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_Coupon_DrawCoupon)

// 专区优惠券列表 V5.14.0
#define SuffixURL_Zone_CouponList        @"/coin/coupon/getZoneCouponList"
#define ServiceURL_Zone_CouponList         URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_Zone_CouponList)

// 获取用户即将到期（小于2天）优惠券数量 V5.14.0
#define SuffixURL_Coupon_ExpiringNum        @"/coin/coupon/getExpiringCouponNum"
#define ServiceURL_Coupon_ExpiringNum        URLStringCat(MXR_BOOKSTORE_COIN_SERVICE_API_URL(), SuffixURL_Coupon_ExpiringNum)

#endif /* MXRCoinNetworkUrl_h */
