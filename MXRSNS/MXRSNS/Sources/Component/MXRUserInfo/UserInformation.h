//
//  UserInformation.h
//  huashida_home
//
//  Created by 周建顺 on 16/2/29.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MXRModel.h"
#import "LKDBHelper.h"
//#import "MXRUserInfoResponseModel.h"
#define PhoneString @"phone"
#define QQString @"QQ"
#define WXString @"WX"
#define WBString @"WB"
#define EmailString @"email"
#define GooglePlusString @"GooglePlus"
#define FacebookString @"Facebook"
#define InstagramString @"Instagram"
typedef NS_ENUM(NSUInteger , MXRloginWithKind) {
    MXRloginWithPhone        = 1,
    MXRloginWithThirdQQ      = 2,
    MXRloginWithThirdSINA    = 3,
    MXRloginWithThirdWeChat  = 4,
    MXRloginWithMail         = 5, //暂时无用,去除此功能
    MXRloginWithFacebook     = 6,
    MXRloginWithGooglePlus   = 7,
    MXRloginWithInstagram    = 8,
};

/**
  用户出版社授权信息
 */
typedef NS_ENUM(NSUInteger , MXRPublishUserType) {

    MXRPublishUserTypeNormalMan      =0, // 没有任何出版社的授权
    MXRPublishUserTypePublishMan     =1, // 包含一个或一个以上的出版社的授权
    MXRPublishUserTypeSuperMan       =2  // 包含所有出版社的授权
};
@interface UserBandelModel : NSObject
@property (assign, nonatomic) MXRloginWithKind bandelType;
@property (assign, nonatomic) NSInteger bandelID;
@property (copy,  nonatomic) NSString *bandelUserID;
@property (copy,  nonatomic) NSString *bandelLoginName;
@property (copy,  nonatomic) NSString *bandelNickName;
@property (assign,nonatomic) BOOL isMainCount;
-(void)bandelUserCountsListWithDictionary:(NSDictionary *)dict;
@end
@interface UserInformation : NSObject

- (void)logout;

@property (copy, nonatomic) NSString *userImage; //存储头像的地址
@property (copy,nonatomic) NSString *userID;//用户ID、游客ID
@property (nonatomic, assign) BOOL isGuestLogin;//是否为游客登录
@property (copy, nonatomic) NSString *userNickName;
@property (copy, nonatomic) NSString *userSex;
@property (copy, nonatomic) NSString *userAge;
@property (nonatomic, assign) NSInteger userExactAge;//用户准确年龄
@property (copy, nonatomic) NSString *userSchoolGrade;
@property (copy, nonatomic) NSString *userClass;
@property (copy, nonatomic) NSString *userReadingLV;
@property (assign, nonatomic) NSInteger userReadingCount;//阅读获得金币的数量
@property (assign, nonatomic) NSInteger userTotalCount;//梦想币
@property (copy, nonatomic) NSString *userPassWord;
@property (copy, nonatomic) NSString *userPhone;
@property (copy, nonatomic) NSString *userEmail;
@property (copy, nonatomic) NSString *userBirthday;
@property (copy, nonatomic) NSString *userClassID;
@property (assign, nonatomic) BOOL isBindPhone;
@property (assign, nonatomic) NSInteger userDiamonad; //梦想钻
@property (assign, nonatomic) NSInteger couponCount; //优惠券个数 V5.11.0
@property (assign, nonatomic) BOOL  userHasBandlePhoneOrEmail;
@property (assign, nonatomic) BOOL  userThirdLogin;
@property (assign, nonatomic) BOOL  userQuickLogin; //是否手机号快捷登录
@property (assign, nonatomic) BOOL  userQuickRegister; //手机号是否第一次快捷登录
@property (assign, nonatomic) MXRloginWithKind userThirdLoginDetail;
@property (copy, nonatomic) NSString *reviewedFlags;// "" 隐藏 hide 隐藏 show显示
@property (strong, nonatomic) NSMutableArray *bandelCountsList;
/*userType = @"0":mxr用户
 userType = @"1":hsd用户*/
@property (strong, nonatomic) NSString *userType;
@property (nonatomic, assign) MXRPublishUserType userPublishType;
@property (nonatomic, copy) NSString * userPublishInfoStr; // 用来接收服务端返回的用户信息（暂定为字符串）
@property (nonatomic, strong) NSArray * userPublishInfoArray; //  外部需要获取用户出版社信息时，get 此参数
@property (nonatomic, assign) BOOL hasShowedBandlePrompt;
//是否为VIP用户  5.13.0 version  by shuai.wang
@property (nonatomic, assign) BOOL vipFlag;
@property (nonatomic, assign) BOOL      hasPresent;//是否赠送会员
@property (nonatomic, assign) NSInteger signInCoinNum;   //签到加梦想币的数量
@property (nonatomic, assign) NSInteger presentDays;//赠送会员天数
@property (nonatomic, assign) NSInteger theRestOfVipTime;   //会员剩余时间
@property (nonatomic, copy)   NSString *startDate;    //会员开始时间
@property (nonatomic, copy)   NSString *endDate;      //会员结束时间
@property (nonatomic, copy)   NSString *couponNewDate;      //最新优惠券时间
//是否为VIP用户  5.13.0 version  by shuai.wang
@property (nonatomic, assign) BOOL  isDidBubble; //优惠券即将过期气泡 是否已经展示 5.14.0


+(instancetype)modelInformation;
/*用户所处的年龄段*/
-(NSString *)getUserAgeClass;
/**
 *   根据老版本的年龄段形式获取年龄段
 *
 *  @param ageString 0｜3
 *
 *  @return 0-3
 */
-(NSString *)getUserAgeClassWithOldAgeString:(NSString *)ageString;
/*用户性别男女*/
-(NSString *)getUserSexWithNanOrNv;
/*用户是否登陆*/
-(BOOL)getIsLogin;
/*用户是否是华师大用户*/
-(BOOL)getIsHuaShiDaUser;
-(void)initWithDictionary:(NSDictionary *)dict;
-(BOOL)isInReviewed;//是否在审核中
-(void)setUserID:(NSString *)userID;
/*初始化绑定用户账号*/
-(void)fullBandelCountsListWithArray:(NSArray *)array;
/*添加新绑定的用户账号*/
-(void)addNewCountWithDictionary:(NSDictionary *)dict;
/*解绑老用户账号*/
-(void)deleCountWithCounterID:(NSString *)ID;

- (BOOL)checkUserIsPublishUserWithPublishId:(NSString *)publishId;

/**
 判定是否显示过绑定弹窗
 */
-(BOOL)judgeWhetherShowedBandlePrompt;
/**
 判定是否登录
 */
-(BOOL)checkIsLogin;

/**
 判定是否显示优惠券红点提示
 @return return value description
 */
//-(void)saveShowCouponRedTipStateWithModel:(MXRGetUserInfoResponseModel *)getuserInfoModel;
@end
