//
//  UserInformation.m
//  huashida_home
//
//  Created by 周建顺 on 16/2/29.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//
#import "UserInformation.h"
//#import "MXRPromptView.h"
//#import "MXRPhoneBandelDetailViewController.h"
//#import "AppDelegate.h"
//#import "MXRNavigationViewController.h"
//#import "MXRAdpterManager.h"
//#import "MXRLoginVC.h"
//#import "CacheData.h"
//#import "UIViewController+Ex.h"
#import "UtilMacro.h"
#import "MXRMacro.h"
#import "MXRConstant.h"
#import "Notifications.h"

@implementation UserBandelModel
/*用户帐号绑定信息*/
-(void)bandelUserCountsListWithDictionary:(NSDictionary *)dict{
    self.bandelID = autoInteger(dict[@"Id"]);
    self.bandelUserID = autoString(dict[@"UserId"]);
    NSString *bandelType = autoString(dict[@"BindType"]);
    if ([bandelType caseInsensitiveCompare:PhoneString] == NSOrderedSame) {
        self.bandelType = MXRloginWithPhone;
    }else if ([bandelType caseInsensitiveCompare:QQString] == NSOrderedSame){
        self.bandelType = MXRloginWithThirdQQ;
    }else if ([bandelType caseInsensitiveCompare:WXString] == NSOrderedSame){
        self.bandelType = MXRloginWithThirdWeChat;
    }else if ([bandelType caseInsensitiveCompare:WBString] == NSOrderedSame){
        self.bandelType = MXRloginWithThirdSINA;
    }else if ([bandelType caseInsensitiveCompare:EmailString] == NSOrderedSame){
        self.bandelType = MXRloginWithMail;
    }else if ([bandelType caseInsensitiveCompare:GooglePlusString] == NSOrderedSame){
        self.bandelType = MXRloginWithGooglePlus;
    }else if ([bandelType caseInsensitiveCompare:FacebookString] == NSOrderedSame){
        self.bandelType = MXRloginWithFacebook;
    }else if ([bandelType caseInsensitiveCompare:InstagramString] == NSOrderedSame){
        self.bandelType = MXRloginWithInstagram;
    }
    self.bandelNickName = autoString(dict[@"NickName"]);
    self.bandelLoginName = autoString(dict[@"LgName"]);
    if (autoInteger(dict[@"IsMain"]) == 1)  {
        self.isMainCount = YES;
    }else{
        self.isMainCount = NO;
    }
}
@end
@implementation UserInformation

@synthesize userID;
@synthesize isGuestLogin;
@synthesize userNickName;
@synthesize userSex;
@synthesize userAge;
@synthesize userExactAge;
@synthesize userSchoolGrade;
@synthesize userImage;
@synthesize userReadingLV;
@synthesize userReadingCount;
@synthesize userTotalCount;
@synthesize userPassWord;
@synthesize userPhone;
@synthesize userEmail;
@synthesize userType;
@synthesize userBirthday;
@synthesize userClass;
@synthesize userClassID;
@synthesize userHasBandlePhoneOrEmail;
@synthesize userQuickLogin;
@synthesize userQuickRegister;
@synthesize userDiamonad;
@synthesize couponCount;
@synthesize userThirdLogin;
@synthesize userThirdLoginDetail;
@synthesize reviewedFlags;
@synthesize userPublishInfoStr;
@synthesize userPublishInfoArray;
@synthesize userPublishType;
@synthesize isBindPhone;
@synthesize vipFlag;
@synthesize isDidBubble;

-(void)initWithDictionary:(NSDictionary *)dict{
    self.userBirthday = dict[@"userBirthday"];
  
    self.userClassID = [NSString stringWithFormat:@"%@",dict[@"userGrade"]];
    self.userID = [NSString stringWithFormat:@"%@",dict[@"userID"]];
    self.userReadingLV = [NSString stringWithFormat:@"%@",dict[@"userLevel"]];
    self.userNickName = dict[@"userNickName"];
    NSString * t_phone = dict[@"userPhone"];
    if (t_phone.length > 0) {
        self.userPhone = dict[@"userPhone"];
    }
    
    self.userSex =[NSString stringWithFormat:@"%@",dict[@"userSex"]] ;
    self.userImage = dict[@"userIcon"];
    self.userAge = [NSString stringWithFormat:@"%@-%@岁",dict[@"userMinAge"],dict[@"userMaxAge"]];
    self.userExactAge = [dict[@"age"] integerValue];
    
    // v5.14.0 v2.4 modify userinfo by liulong
//    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dict];
//    NSString *phone = mutableDic[@"userPhone"];
//    if (![phone isKindOfClass:[NSString class]] || phone.length <= 0) {
//        [mutableDic removeObjectForKey:@"userPhone"];
//    }
//    [[MXRUserInfo sharedInstance] mxr_modelSetWithJSON:mutableDic];
}
+(instancetype)modelInformation{
    static UserInformation *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[UserInformation alloc] init];
    });
    return _sharedInstance;
}
- (BOOL)checkUserIsPublishUserWithPublishId:(NSString *)publishId{

    BOOL isPublisherManager = NO;
    if ([UserInformation modelInformation].userPublishType == MXRPublishUserTypeSuperMan) {
        isPublisherManager = YES;
    }
    else if ([UserInformation modelInformation].userPublishType == MXRPublishUserTypePublishMan)
    {
        isPublisherManager = [[UserInformation modelInformation].userPublishInfoArray containsObject:publishId];
    }
    return isPublisherManager;
}
#pragma mark Setter Method
/******************** user_vipFlag *********************/
-(void)setVipFlag:(BOOL)avipFlag {
    vipFlag = avipFlag;
    [[NSUserDefaults standardUserDefaults] setBool:vipFlag  forKey:@"user_vipFlag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)vipFlag {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"user_vipFlag"];
}
/******************** user_vipFlag *********************/

/********************userID*********************/
-(void)setUserID:(NSString *)auserID{
    userID = auserID;
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"USERID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)userID{
    NSString * result = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERID"];
    return result ? result : @"0";
}

/********************isGuestLogin*********************/
-(void)setIsGuestLogin:(BOOL)aIsGuestLogin {
    isGuestLogin = aIsGuestLogin;
    [[NSUserDefaults standardUserDefaults] setBool:isGuestLogin forKey:@"USER_IS_GUEST"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)isGuestLogin {
    BOOL isGuestLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"USER_IS_GUEST"];
    return isGuestLogin;
}
/********************isGuestLogin*********************/

-(BOOL)getIsLogin{
    return (![self.userID isEqualToString:@"0"] && self.userID.length != 0 && !self.isGuestLogin);
}
/********************userImage*********************/
-(void)setUserImage:(NSString*)auserImage{

    userImage = auserImage;
    [[NSUserDefaults standardUserDefaults] setObject:userImage  forKey:@"USERHEADIMAGE"];
    
}
-(NSString*)userImage{
    
    //优先取本地缓存的用户头像  Version 5.9.0   shuai.wang
//    NSString *cacheUserIcon = [CacheData readApplicationStr:CACHE_USERICON_KEY];
//    if (cacheUserIcon && ![cacheUserIcon isEqualToString:@""]) {
//        return cacheUserIcon;
//    }
    
    userImage = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERHEADIMAGE"];
    return REPLACE_HTTP_TO_HTTPS(userImage);
}

- (NSString *)userPublishInfoStr{

     NSString * result = [[NSUserDefaults standardUserDefaults] stringForKey:@"userPublishInfoStr"];
    return result;
}
- (NSArray *)userPublishInfoArray{

    userPublishInfoArray = [NSArray array];
    if(self.userPublishInfoStr){
        userPublishInfoArray = [self.userPublishInfoStr componentsSeparatedByString:@","];
    }
    return userPublishInfoArray;
}
/********************userNickName*********************/
-(void)setUserNickName:(NSString *)auserNickName{
    userNickName = auserNickName;
    [[NSUserDefaults standardUserDefaults] setObject:userNickName forKey:@"user_nick_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)userNickName{
    NSString * result = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_nick_name"];
    if ( result && result.length > 0 ) {
        return result;
    }
    result = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_userID"];
    NSArray* objName = [result componentsSeparatedByString:@"@"];
    return objName[0];
}
/********************userReadingCount*********************/
-(void)setUserReadingCount:(NSInteger)auserReadingCount{
    userReadingCount = auserReadingCount;
}
/********************userReadingLV*********************/
-(void)setUserReadingLV:(NSString *)auserReadingLV{
    userReadingLV = auserReadingLV;
}
/********************userPassWord*********************/
-(void)setUserPassWord:(NSString *)auserPassWord{
    userPassWord = auserPassWord;
    [[NSUserDefaults standardUserDefaults] setObject:userPassWord  forKey:@"login_passWord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)userPassWord{
    NSString * result = [[NSUserDefaults standardUserDefaults] stringForKey:@"login_passWord"];
    return result;
}
/********************userEmail*********************/
-(void)setUserEmail:(NSString *)auserEmail{
    userEmail = auserEmail;
    [[NSUserDefaults standardUserDefaults] setObject:userEmail  forKey:@"email_address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setUserPublishInfoStr:(NSString *)auserPublishInfoStr{

    userPublishInfoStr = auserPublishInfoStr;
    [[NSUserDefaults standardUserDefaults] setObject:userPublishInfoStr  forKey:@"userPublishInfoStr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)userEmail{
    NSString * result = [[NSUserDefaults standardUserDefaults] stringForKey:@"email_address"];
    return result;
}
/********************userAge*********************/
-(void)setUserAge:(NSString *)auserAge{
    userAge = auserAge;
    [[NSUserDefaults standardUserDefaults] setObject:userAge  forKey:@"user_gender_range"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)userAge{
    NSString * result = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_gender_range"];
    return result;
}
-(NSString *)getUserAgeClass{
    NSString * result = [UserInformation modelInformation].userAge;
    if ([[result substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"18"]) {
        return MXRLocalizedString(@"UserInformation_Than_Eighteen", @"18岁+");
    }
    NSArray * t_newArr = [result componentsSeparatedByString:@"-"];
    if(t_newArr.count == 2){
        if ([[t_newArr lastObject] isEqualToString:@"1"]) {
        }else{
            if ([[t_newArr lastObject] isEqualToString:@"0"] || [[t_newArr lastObject] isEqualToString:@"0岁"]) {
                return MXRLocalizedString(@"UserInformation_Zero_Three", @"0－3岁");
            }else{
                return result;
            }
        }
    }
    if (result.length == 0) {
        return MXRLocalizedString(@"UserInformation_Zero_Three", @"0－3岁");
    }
    NSArray * t_arr = [result componentsSeparatedByString:@"|"];
    if (result == nil) {
        return MXRLocalizedString(@"UserInformation_Zero_Three", @"0－3岁");
    }
    if (t_arr.count == 1) {
        NSString * t_str = [t_arr lastObject];
        result = [NSString stringWithFormat: MXRLocalizedString(@"UserInformation_ldAge", @"%ld-%ld岁"),[t_str integerValue] - 3,(long)[t_str integerValue]];
        return result;
    }
    if ([t_arr[0] isEqualToString:@"18"]) {
        result = [NSString stringWithFormat: MXRLocalizedString(@"UserInformation_Age+", @"%@岁+"),t_arr[0]];
    }else{
        result = [NSString stringWithFormat: MXRLocalizedString(@"UserInformation_Age",@"%@-%@岁"),t_arr[0],t_arr[1]];
    }
    return result;
}
-(NSString *)getUserAgeClassWithOldAgeString:(NSString *)ageString{

    NSString * result = ageString;
    NSArray * t_newArr = [result componentsSeparatedByString:@"-"];
    if(t_newArr.count == 2){
        if ([[t_newArr lastObject] isEqualToString:@"1"]) {
        }else{
            if ([[t_newArr lastObject] isEqualToString:@"0"]) {
                return @"0岁";
            }else{
                return result;
            }
        }
    }
    if (result.length == 0) {
        return @"0-3岁";
    }
    NSArray * t_arr = [result componentsSeparatedByString:@"|"];
    if (result == nil) {
        return @"0-3岁";
    }
    if (t_arr.count == 1) {
        NSString * t_str = [t_arr lastObject];
        result = [NSString stringWithFormat:@"%ld-%ld岁",(long)[t_str integerValue] - 3,(long)[t_str integerValue]];
        return result;
    }
    if ([t_arr[0] isEqualToString:@"18"]) {
        result = [NSString stringWithFormat:MXRLocalizedString(@"UserInformation_Age+", @"%@岁+"),t_arr[0]];
    }else{
        result = [NSString stringWithFormat:MXRLocalizedString(@"UserInformation_Age",@"%@-%@岁"),t_arr[0],t_arr[1]];
    }
    return result;
}
/********************userAge*********************/
- (void)setUserExactAge:(NSInteger)auserExactAge {
    userExactAge = auserExactAge;
    [[NSUserDefaults standardUserDefaults] setInteger:userExactAge forKey:CurrentUserNetworkAge];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)userExactAge {
    userExactAge = [[NSUserDefaults standardUserDefaults] integerForKey:CurrentUserNetworkAge];
    return userExactAge;
}
/********************userTotalCount*********************/
-(void)setUserTotalCount:(NSInteger)auserTotalCount{
    if (userTotalCount == auserTotalCount) {
        return;
    }
    userTotalCount = auserTotalCount;
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_For_RefreshMXBInPersonVC object:nil];
}

-(void)setUserDiamonad:(NSInteger)value{
    userDiamonad = value;
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_For_RefreshUserDiamond object:nil];
}

- (void)setCouponCount:(NSInteger)aCouponCount {
    couponCount = aCouponCount;
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_For_RefreshUserCouponCount object:nil];
}

/********************userSex*********************/
-(void)setUserSex:(NSString *)auserSex{
    if (![userSex isEqualToString:auserSex]) {
        userSex = auserSex;
        [[NSUserDefaults standardUserDefaults] setObject:userSex  forKey:@"user_sex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        DLOG(@"UserInformation has the same userSex!");
    }
}
-(NSString *)userSex{
    NSString * result = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_sex"];
    return result;
}
-(NSString *)getUserSexWithNanOrNv{
    NSString * sex = [UserInformation modelInformation].userSex;
    if ([sex isEqualToString:@"0"]) {
        return MXRLocalizedString(@"UserInformation_female",@"女");
    }else{
        return MXRLocalizedString(@"UserInformation_male", @"男");
    }
}
/********************userPhone*********************/
-(void)setUserPhone:(NSString *)auserPhone{
        userPhone = auserPhone;
        [[NSUserDefaults standardUserDefaults] setObject:userPhone  forKey:@"login_userPhone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)userPhone{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"login_userPhone"];
}

-(void)setIsBindPhone:(BOOL)bindPhone {
    isBindPhone = bindPhone;
    [[NSUserDefaults standardUserDefaults] setBool:isBindPhone  forKey:@"login_isBindPhone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isBindPhone {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"login_isBindPhone"];
}

/********************userSchoolGrade*********************/
-(void)setUserSchoolGrade:(NSString *)auserSchoolGrade{
        userSchoolGrade = auserSchoolGrade;
}
/********************userType*********************/
-(void)setUserType:(NSString *)auserType{
        userType = auserType;
        [[NSUserDefaults standardUserDefaults] setObject:auserType  forKey:@"USERTYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)userType{
    NSString * result = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERTYPE"];
    return result;
}
-(BOOL)getIsHuaShiDaUser{
    if ([self.userType isEqualToString:@"1"]){
        return YES;
    } else{
        return NO;
    }
}
/********************userBirthday*********************/
-(void)setUserBirthday:(NSString *)auserBirthday{
        userBirthday = auserBirthday;
        [[NSUserDefaults standardUserDefaults] setObject:auserBirthday  forKey:@"user_birthday"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)userBirthday{
    NSString * result = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_birthday"];
    return result;
}
/********************userHasBandlePhoneOrEmail*********************/
-(void)setUserHasBandlePhoneOrEmail:(BOOL )auserHasBandlePhoneOrEmail{
        userHasBandlePhoneOrEmail = auserHasBandlePhoneOrEmail;
        [[NSUserDefaults standardUserDefaults] setBool:auserHasBandlePhoneOrEmail  forKey:@"mxrEmailLoginAndPhone"];
}
-(BOOL)userHasBandlePhoneOrEmail{
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:@"mxrEmailLoginAndPhone"];
    return result;
}

/********************userQuickLogin V5.9.4 by minjing.lin*********************/
-(void)setUserQuickLogin:(BOOL)auserQuickLogin{
    userQuickLogin = auserQuickLogin;
    if (!auserQuickLogin) {
        self.userQuickRegister = NO;
    }
    [[NSUserDefaults standardUserDefaults]setBool:userQuickLogin forKey:@"mxruserQuickLogin"];
}
-(BOOL)userQuickLogin{
    BOOL result = [[NSUserDefaults standardUserDefaults]boolForKey:@"mxruserQuickLogin"];
    return result;
}

/********************userQuickRegister V5.9.4 by minjing.lin*********************/
-(void)setUserQuickRegister:(BOOL)auserQuickRegister{
    userQuickRegister = auserQuickRegister;
    [[NSUserDefaults standardUserDefaults]setBool:userQuickRegister forKey:@"mxruserQuickRegister"];
}
-(BOOL)userQuickRegister{
    BOOL result = [[NSUserDefaults standardUserDefaults]boolForKey:@"mxruserQuickRegister"];
    return result;
}

/********************userClass*********************/
-(void)setUserClass:(NSString *)auserClass{
        userClass = auserClass;
        [[NSUserDefaults standardUserDefaults] setObject:auserClass  forKey:@"user_children_class_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];

}
-(NSString *)userClass{
    NSString * result = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_children_class_name"];
    return result;
}
/********************userClassID*********************/
-(void)setUserClassID:(NSString *)auserClassID{
        userClassID = auserClassID;
        [[NSUserDefaults standardUserDefaults] setObject:auserClassID  forKey:@"user_children_class_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)userClassID{
    NSString * result = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_children_class_id"];
    return result;
}
/********************userThirdLogin*********************/
-(void)setUserThirdLogin:(BOOL)auserThirdLogin{
    NSInteger loginInt = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mxrloginKind"] integerValue];
    if (loginInt == 0 || loginInt == 1) {
        userThirdLogin = NO;
    }else{
        userThirdLogin = YES;
    }
    [[NSUserDefaults standardUserDefaults] setBool:userThirdLogin forKey:@"IsLoginByThirdKind"];
}
-(BOOL)userThirdLogin{
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsLoginByThirdKind"];
    return result;
}
/********************userThirdLoginDetail*********************/
-(void)setUserThirdLoginDetail:(MXRloginWithKind )auserThirdLoginDetail{
    userThirdLoginDetail = auserThirdLoginDetail;
    [[NSUserDefaults standardUserDefaults] setInteger:auserThirdLoginDetail forKey:@"mxrloginKind"];
    self.userThirdLogin = nil;
}
-(MXRloginWithKind)userThirdLoginDetail{
    MXRloginWithKind result = [[NSUserDefaults standardUserDefaults] integerForKey:@"mxrloginKind"];
    return result;
}

- (void)setUserPublishType:(MXRPublishUserType)auserPublishType{

    userPublishType = auserPublishType;
    [[NSUserDefaults standardUserDefaults] setInteger:auserPublishType forKey:@"userPublishType"];
     [[NSUserDefaults standardUserDefaults] synchronize];
}
- (MXRPublishUserType)userPublishType{

    return [[NSUserDefaults standardUserDefaults] integerForKey:@"userPublishType"];
}
-(BOOL)isInReviewed{//是否在审核中
    return [MXRGlobalUtil isInReviewed];
}
/********************userBandel*********************/
-(void)fullBandelCountsListWithArray:(NSArray *)array{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"HasBingBandelPhone"];
    if (!_bandelCountsList) {
        _bandelCountsList = [NSMutableArray array];
    }else{
        [_bandelCountsList removeAllObjects];
    }
    for (NSDictionary *dict in array) {
        UserBandelModel *model = [[UserBandelModel alloc] init];
        [model bandelUserCountsListWithDictionary:dict];
        if (model) {
            [self.bandelCountsList addObject:model];
        }
        if (model.bandelType == MXRloginWithPhone) {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"HasBingBandelPhone"];
        }
    }
}
-(void)addNewCountWithDictionary:(NSDictionary *)dict{
    if (!_bandelCountsList) {
        _bandelCountsList = [NSMutableArray array];
    }
    UserBandelModel *model = [[UserBandelModel alloc] init];
    [model bandelUserCountsListWithDictionary:dict];
    [_bandelCountsList addObject:model];
}
-(void)deleCountWithCounterID:(NSString *)ID{
    for (UserBandelModel *model in _bandelCountsList) {
        if ([[NSString stringWithFormat:@"%ld",(long)model.bandelID] isEqualToString:ID]) {
            [_bandelCountsList removeObject:model];
            break;
        }
    }
}

#pragma mark - 判定是否显示绑定
-(BOOL)judgeWhetherShowedBandlePrompt {
    if ([UserInformation modelInformation].hasShowedBandlePrompt) {
        return YES;
    }else {
        return [self checkIsBandle];;
    }
}

#pragma mark - 判定是否绑定
-(BOOL)checkIsBandle {
    // snapLearn不显示绑定提示
    if ([MXRAdpterManager currentAppType] == MXRAppTypeSnapLearn) {
        return YES;
    }
    
    BOOL isThirdLogin = [UserInformation modelInformation].userThirdLogin;
    if (isThirdLogin && [UserInformation modelInformation].isBindPhone ) {
        
//        MXRPromptView *bandlePrompt = [[MXRPromptView alloc] initWithTitle:nil message:MXRLocalizedString(@"MXRGoToBandleBeforePrompt", @"根据《互联网跟帖评论服务管理规定》，发表言论需实名制，请先绑定手机号码后再进行操作，谢谢。") delegate:nil otherButtonTitles:@[MXRLocalizedString(@"CANCEL", @"取消"),MXRLocalizedString(@"MXRGoToBandle", @"我要绑定")] buttonTapBlock:^(MXRPromptView * _Nonnullsender, NSInteger index) {
//            if (index == 0) {
//                [MXRClickUtil event:@"mySettingPhoneNoCancel"];
//            }else {
//                [MXRClickUtil event:@"mySettingPhoneNoRelation"];
//                MXRPhoneBandelDetailViewController *bandelDetailVC = [[MXRPhoneBandelDetailViewController alloc] init];
//                AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                [delegate.navigationController pushViewController:bandelDetailVC animated:YES];
//            }
//        }];
//        [bandlePrompt showInCustomWindow];
        
        [UserInformation modelInformation].hasShowedBandlePrompt = YES;   //记录已经显示过绑定  5.8.9version功能，显示过绑定就不再提示
        return NO;
        
    }else {
        return YES;
    }
}

#pragma mark - 是否登录
-(BOOL)checkIsLogin{
    if (![[UserInformation modelInformation] getIsLogin]) {
//        MXRPromptView * alert = [[MXRPromptView alloc] initWithTitle:nil message:MXRLocalizedString(@"MXRBookSNSViewControllerTipsUserHandleLogin", @"登录后即可操作") delegate:nil cancelButtonTitle:MXRLocalizedString(@"GOLOGIN", nil) otherButtonTitle:MXRLocalizedString(@"CANCEL", nil)
//                                                      buttonTapBlock:^(MXRPromptView * sender, NSInteger index) {
//                                                          if (index == 0) {
//                                                              //do nothing
//                                                          }else{
//                                                              MXRLoginVC *vc = [[MXRLoginVC alloc] init];
//                                                              UINavigationController *loginNavigationC = [[MXRNavigationViewController alloc] initWithRootViewController:vc];
//                                                              [loginNavigationC showAtTop];
//                                                          }
//                                                      }];
//        [alert showInLastViewController];
        return NO;
    }else{
        return YES;
    }
}

/**
 判定是否显示优惠券红点提示
 @return <#return value description#>
 */
//-(void)saveShowCouponRedTipStateWithModel:(MXRGetUserInfoResponseModel *)getuserInfoModel {
//    NSString *couponNewDate = [[NSUserDefaults standardUserDefaults] objectForKey:USERKEY_COUPON_NEWDATE];
//    if (couponNewDate) {
//        if (![autoString(getuserInfoModel.couponNewDate) isEqualToString:autoString(couponNewDate)]) {
//            [[NSUserDefaults standardUserDefaults] setObject:autoString(getuserInfoModel.couponNewDate) forKey:USERKEY_COUPON_NEWDATE];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USERKEY_WHETHER_SHOW_COUPON_TIP];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//    }else {
//        [[NSUserDefaults standardUserDefaults] setObject:autoString(getuserInfoModel.couponNewDate) forKey:USERKEY_COUPON_NEWDATE];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USERKEY_WHETHER_SHOW_COUPON_TIP];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//}

#pragma mark - 优惠券即将过期气泡 是否已经展示 5.14.0
- (void)setIsDidBubble:(BOOL)aisDidBubble{
    isDidBubble = aisDidBubble;
    [[NSUserDefaults standardUserDefaults]setBool:isDidBubble forKey:@"isDidBubble"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)isDidBubble{
    BOOL result = [[NSUserDefaults standardUserDefaults]boolForKey:@"isDidBubble"];
    return result;
}

- (void)logout
{
    UserInformation *userInfo = [UserInformation modelInformation];
    
    userInfo.userImage = nil;
    userInfo.userID = 0;//用户ID、游客ID
    userInfo.isGuestLogin = NO;//是否为游客登录
    userInfo.userNickName = nil;
    userInfo.userSex = nil;
    //    @property (copy, nonatomic) NSString *userAge;
    //    @property (nonatomic, assign) NSInteger userExactAge;//用户准确年龄
    //    @property (copy, nonatomic) NSString *userSchoolGrade;
    //    @property (copy, nonatomic) NSString *userClass;
    //    @property (copy, nonatomic) NSString *userReadingLV;
    userInfo.userReadingCount = 0;//阅读获得金币的数量
    userInfo.userTotalCount = 0;//梦想币
    userInfo.userPassWord = nil;
    userInfo.userPhone = nil;
    userInfo.userEmail = nil;
    userInfo.userBirthday = nil;
    userInfo.userClassID = nil;
    userInfo.isBindPhone = nil;
    userInfo.userDiamonad = 0; //梦想钻
    userInfo.couponCount = 0; //优惠券个数 V5.11.0
    userInfo.userHasBandlePhoneOrEmail = NO;
    userInfo.userThirdLogin = NO;
    userInfo.userQuickLogin = NO; //是否手机号快捷登录
    userInfo.userQuickRegister = NO; //手机号是否第一次快捷登录
    userInfo.userThirdLoginDetail = 0;
    userInfo.bandelCountsList = nil;
    /*userType = @"0":mxr用户
     userType = @"1":hsd用户*/
    userInfo.userType = nil;
    userInfo.userPublishType = 0;
    userInfo.userPublishInfoStr = nil; // 用来接收服务端返回的用户信息（暂定为字符串）
    userInfo.userPublishInfoArray = nil; //  外部需要获取用户出版社信息时，get 此参数
    //是否为VIP用户  5.13.0 version  by shuai.wang
    userInfo.vipFlag = NO;
    userInfo.hasPresent = NO;//是否赠送会员
    userInfo.signInCoinNum = 0;   //签到加梦想币的数量
    userInfo.presentDays = 0;//赠送会员天数
    userInfo.theRestOfVipTime = 0;   //会员剩余时间
    userInfo.startDate = nil;    //会员开始时间
    userInfo.endDate = nil;      //会员结束时间
    userInfo.couponNewDate = nil;      //最新优惠券时间
    //是否为VIP用户  5.13.0 version  by shuai.wang
    userInfo.isDidBubble = NO;; //优惠券即将过期气泡 是否已经展示 5.14.0
}

@end
