//
//  MXRUserInfo.h
//  huashida_home
//
//  Created by Martin.Liu on 2018/8/27.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRBaseDBModel.h"

@interface MXRUserInfo : MXRBaseDBModel

+ (instancetype)sharedInstance;

/// 个人信息接口获取
/// start
@property (copy,nonatomic) NSString *userID;//用户ID、游客ID
@property (nonatomic, strong) NSString  *userIcon; //存储头像的地址
@property (nonatomic, strong) NSString  *userNickName;
@property (nonatomic, assign) NSInteger userSex; // 性别 0:女 ， 1: 男
@property (nonatomic, assign) NSInteger age;//用户年龄
@property (nonatomic, assign) NSInteger userGrade;  // 用户等级  与userClassID
@property (nonatomic, assign) BOOL      vipFlag;    // 是否是会员
@property (nonatomic, assign) BOOL      hasPresent; //是否赠送会员
@property (nonatomic, assign) NSInteger presentDays;//赠送会员天数
@property (nonatomic, assign) NSInteger theRestOfVipTime;   //会员剩余时间
@property (nonatomic, assign) NSInteger userLevel;
@property (nonatomic, strong) NSString  *userPhone;
@property (nonatomic, strong) NSString  *userBirthday;
@property (nonatomic, assign) NSInteger userMXZ;
@property (nonatomic, assign) NSInteger couponNum;//优惠券个数

@property (nonatomic, strong) NSString  *userFullName;
@property (nonatomic, strong) NSString  *userIdentity;
@property (nonatomic, assign) NSInteger userMaxAge;
@property (nonatomic, assign) NSInteger userMinAge;
@property (nonatomic, assign) NSInteger userAuthority;
@property (nonatomic, strong) NSString  *userPressIds;
/// end
/// 个人信息接口获取

// @"user/mxb/read" // 获取用户阅读获得的梦想币  key : coinNum
@property (assign, nonatomic) NSInteger userReadingCount;//阅读获得金币的数量
// 绑定设备号 、 email登录 设置
@property (copy, nonatomic) NSString *userEmail;
// 绑定设备号 、 绑定手机号时设置
@property (assign, nonatomic) BOOL isBindPhone;
@property (nonatomic, assign) BOOL isGuestLogin;//是否为游客登录
@property (nonatomic, assign) NSInteger userAgeRange; // 用户年龄段
@property (copy, nonatomic) NSString *userClass;    // 无用？
@property (assign, nonatomic) NSInteger userTotalCount;//梦想币
@property (assign, nonatomic) NSInteger loginType;  // 登录类型
@property (assign, nonatomic) BOOL  userQuickRegister; //手机号是否第一次快捷登录，快捷登录接口获取，当isExists的值为0时为YES

- (void)compatibleOldVersion;

@end
