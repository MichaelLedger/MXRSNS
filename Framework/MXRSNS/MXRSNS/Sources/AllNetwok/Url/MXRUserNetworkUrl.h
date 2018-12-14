//
//  MXRUserNetworkUrl.h
//  huashida_home
//
//  Created by 周建顺 on 2017/5/25.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRUserNetworkUrl_h
#define MXRUserNetworkUrl_h

#import "MXRNetworkUrl.h"


/**
 *  登陆/获取下载记录
 */
static inline NSString* MXRUSER_API_URL(){
    return MXRBASE_API_URL();
    //return [MXRBASE_API_URL() stringByAppendingPathComponent:@"user"];
}

#define SuffixURL_User_info_My          @"user/info/my"
#define ServiceURL_User_info_My         URLStringCat(MXRUSER_API_URL(), SuffixURL_User_info_My)

#define SuffixURL_User_Rank_Day         @"/user/rank/day/1"
#define ServiceURL_User_Rank_Day         URLStringCat(MXRUSER_API_URL(), SuffixURL_User_Rank_Day)

#define SuffixURL_User_Grade @"user/grade"
#define ServiceURL_User_Grade  URLStringCat(MXRUSER_API_URL(), SuffixURL_User_Grade)


#define SuffixURL_User_Upate_Grade @"user/update/grade" // 刷新年级
#define ServiceURL_User_Update_Grade  URLStringCat(MXRUSER_API_URL(), SuffixURL_User_Upate_Grade)

#define SuffixURL_User_signin_status            @"user/signin/status" // 签到
#define ServiceURL_User_signin_status           URLStringCat(MXRUSER_API_URL(), SuffixURL_User_signin_status)

#define SuffixURL_User_Receive_Vip            @"coin/vip/present/get" // 领取VIP 5.13.0 version by shuai.wang
#define ServiceURL_User_Receive_Vip           URLStringCat(MXRUSER_API_URL(), SuffixURL_User_Receive_Vip)

#define SuffixURL_User_mxb_read                             @"user/mxb/read" // 获取用户阅读获得的梦想币
#define ServiceURL_User_mxb_read         URLStringCat(MXRUSER_API_URL(), SuffixURL_User_mxb_read)

#define SuffixURL_UpdateUserImage                           @"user/update/user/logo"
#define SuffixURL_User_GetUserInfo                          @"user/info"           // add by liulongdev 获取用户信息
#define SuffixURL_Login_LoginByMobile                       @"user/login/mobile"            // 手机登录
#define SuffixURL_Login_LoginByMobileCode                   @"/user/login/mobile/code"            // 手机验证码登录
#define SuffixURL_Login_LoginByEmail                        @"user/login/email"             // 邮箱登录
#define SuffixURL_Login_LoginByThird                        @"user/login/tpos"              // 第三方登录
#define SuffixURL_Login_LoginByThird_whetherIsANewUser      @"/user/login/exist"            // 判定第三方登录用户是否为新用户
#define SuffixURL_Login_LoginByGuest                        @"user/account/temp/id"         // 游客登录
#define SuffixURL_Login_GetBindAccountInfo                  @"user/account/show"        // 获取账号绑定的信息
#define SuffixURL_Login_BindUserAccount                     @"user/account/bind"        // 绑定账号动作
#define SuffixURL_Login_UnBindUserAccount                   @"user/account/unbind"      // 解绑账号动作
#define SuffixURL_Login_CheckPassword                       @"user/check/password"     // 验证密码是否正确
#define SuffixURL_Login_ChangePassword                      @"user/update/pwd"              // 修改密码
#define SuffixURL_Login_Log                                 @"user/login/log"

#define SuffixURL_Letter_Get_Firend_Method                  @"user/attention/users"   //获取私信的好友列表
#define ServiceURL_Letter_Get_Firend_Method                 URLStringCat(MXRUSER_API_URL(), SuffixURL_Letter_Get_Firend_Method)

#define SuffixURL_User_MXB_All                              @"user/mxb/all" //从服务端获取用户所拥有的梦想币

#define SuffixURL_getAllFoucsLabelUrl                       @"user/attention/all"
#define SuffixURL_getMyFoucsLabelUrl                        @"user/attention/user"
#define SuffixURL_handleMyFoucsLabelUrl                     @"user/attention/handle"

#define SuffixURL_User_SendEmailCode                        @"user/register/email/send/code"           // add by liulongdev 邮箱发送验证码
#define SuffixURL_User_CheckEmailCode                       @"user/register/email/check/code"      // 验证邮箱验证码
#define SuffixURL_User_RegisteruserWithEmail                @"user/register/email"      // 用邮箱注册
#define SuffixURL_User_LoginWithEmail                       @"user/login/email"         // 邮箱登陆
#define SuffixURL_User_CheckEmailExist                      @"user/check/email"         // 验证邮箱是否存在
#define SuffixURL_User_UpdatePwdWithEmail                   @"/user/update/pwd/email"   // 通过邮箱修改密码
#define SuffixURL_User_UpdatePwd                            @"/user/password/id"    // 修改密码
#define SuffixURL_PhoneCode_Send                            @"/base/sms/netease/send"   // 发送验证码
#define SuffixURL_PhoneCode_Check                           @"/base/sms/netease/check"  // 验证验证码
#define SuffixURL_ReceiveUserConpon                         @"/coin/coupon/addVipUserCoupon"                    // 领取vip优惠券 by wangshuai01

/// 用户相关服务的全路径
#define ServiceURL_USER_UpdateUserIcon      URLStringCat(MXRUSER_API_URL(), SuffixURL_UpdateUserImage)                 // 更新用户头像
#define ServiceURL_User_GetUserInfo         URLStringCat(MXRUSER_API_URL(), SuffixURL_User_GetUserInfo)                  // 获取用户信息

/// 登录模块相关服务的全路径
#define ServiceURL_Login_LoginByMobile                      URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_LoginByMobile)  // 手机登录接口
#define ServiceURL_Login_LoginByMobileCode                      URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_LoginByMobileCode)  // 手机验证码登录接口
#define ServiceURL_Login_LoginByEmail                       URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_LoginByEmail)   // 邮箱登录接口
#define ServiceURL_Login_LoginByThird                       URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_LoginByThird)   // 第三方登录接口
#define ServiceURL_Login_LoginByThird_whetherIsANewUser                       URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_LoginByThird_whetherIsANewUser)   // 判定第三方登录用户是否为新用户接口
#define ServiceURL_Login_LoginByGuest                       URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_LoginByGuest)   // 游客登录
#define ServiceURL_Login_GetBindAccountInfo                 URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_GetBindAccountInfo)    // 账号绑定的信息
#define ServiceURL_Login_BindUserAccount                    URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_BindUserAccount)    // 账号绑定的信息
#define ServiceURL_Login_UnBindUserAccount                  URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_UnBindUserAccount)    // 账号绑定的信息
#define ServiceURL_Login_CheckPassword                      URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_CheckPassword)    // 验证密码是否正确
#define ServiceURL_Login_ChangePassword                     URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_ChangePassword)    // 修改密码
#define ServiceURL_Login_Log                                URLStringCat(MXRUSER_API_URL(), SuffixURL_Login_Log)
// 5.10.0 验证码发送验证相关
#define ServiceURL_PhoneCode_Send                           URLStringCat(MXRUSER_API_URL(), SuffixURL_PhoneCode_Send)               // 发送验证码
#define ServiceURL_PhoneCode_Check                          URLStringCat(MXRUSER_API_URL(), SuffixURL_PhoneCode_Check)               // 验证验证码
// V5.13.0
#define ServiceURL_ReceiveUserConpon                        URLStringCat(MXRUSER_API_URL(), SuffixURL_ReceiveUserConpon)            // 领取vip优惠卷

#define ServiceURL_User_MXB_All                             [MXRUSER_API_URL() stringByAppendingPathComponent:SuffixURL_User_MXB_All] //从服务端获取用户所拥有的梦想币

// 邮箱登陆相关
#define ServiceURL_User_SendEmailCode URLStringCat(MXRUSER_API_URL(), SuffixURL_User_SendEmailCode)     //邮箱发送验证码
#define ServiceURL_User_CheckEmailCode URLStringCat(MXRUSER_API_URL(), SuffixURL_User_CheckEmailCode)       // 校验邮箱发送的验证码
#define ServiceURL_User_RegisteruserWithEmail URLStringCat(MXRUSER_API_URL(), SuffixURL_User_RegisteruserWithEmail)     // 邮箱注册
#define ServiceURL_User_LoginWithEmail URLStringCat(MXRUSER_API_URL(), SuffixURL_User_LoginWithEmail)     // 邮箱登陆
#define ServiceURL_User_CheckEmailExist URLStringCat(MXRUSER_API_URL(), SuffixURL_User_CheckEmailExist)     // 验证邮箱是否妇女在
#define ServiceURL_User_UpdatePwdWithEmail URLStringCat(MXRUSER_API_URL(), SuffixURL_User_UpdatePwdWithEmail)     // 通过邮箱修改密码
#define ServiceURL_User_UpdatePwd       URLStringCat(MXRUSER_API_URL(), SuffixURL_User_UpdatePwd)

#define ServiceURL_getAllFoucsLabelUrl                      URLStringCat(MXRUSER_API_URL(),SuffixURL_getAllFoucsLabelUrl)
#define ServiceURL_getMyFoucsLabelUrl                       URLStringCat(MXRUSER_API_URL(),SuffixURL_getMyFoucsLabelUrl)
#define ServiceURL_handleMyFoucsLabelUrl                    URLStringCat(MXRUSER_API_URL(),SuffixURL_handleMyFoucsLabelUrl)


#pragma mark ---- 


#define SuffixURL_User_update_nickname @"user/update/nickname"

#define ServiceURL_User_update_nickname URLStringCat(MXRUSER_API_URL(), SuffixURL_User_update_nickname)

#define SuffixURL_User_Check_Mobile  @"user/check/mobile"
#define ServiceURL_User_Check_Mobile URLStringCat(MXRUSER_API_URL(),SuffixURL_User_Check_Mobile)

#define SuffixURL_User_Login_Email  @"user/login/email"
#define ServiceURL_User_Login_Email URLStringCat(MXRUSER_API_URL(),SuffixURL_User_Login_Email)

#define SuffixURL_User_Login_Tpos  @"user/login/tpos"
#define ServiceURL_User_Login_Tpos URLStringCat(MXRUSER_API_URL(),SuffixURL_User_Login_Tpos)

#define SuffixURL_Login_Mobile @"user/login/mobile"
#define ServiceURL_Login_Mobile URLStringCat(MXRUSER_API_URL(),SuffixURL_Login_Mobile)

#define SuffixURL_Update_Agegroup @"user/update/agegroup"
#define ServiceURL_Update_Agegroup URLStringCat(MXRUSER_API_URL(),SuffixURL_Update_Agegroup)

#define SuffixURL_Update_Age @"user/set/age"
#define ServiceURL_Update_Age URLStringCat(MXRUSER_API_URL(),SuffixURL_Update_Age)

#define SuffixURL_Update_Sex @"user/update/sex"
#define ServiceURL_Update_Sex URLStringCat(MXRUSER_API_URL(),SuffixURL_Update_Sex)

#define SuffixURL_Register_Mobile @"user/register/mobile"
#define ServiceURL_Register_Mobile URLStringCat(MXRUSER_API_URL(),SuffixURL_Register_Mobile)

#define SuffixURL_Download_Book_Logs @"user/download/book/logs"
#define ServiceURL_Download_Book_Logs URLStringCat(MXRUSER_API_URL(),SuffixURL_Download_Book_Logs)  // 购买记录

#pragma mark ---


#endif /* MXRUserNetworkUrl_h */
