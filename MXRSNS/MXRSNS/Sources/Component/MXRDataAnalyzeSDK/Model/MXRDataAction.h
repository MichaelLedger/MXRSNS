//
//  MXRDataAction.h
//  huashida_home
//
//  Created by weiqing.tang on 2017/2/6.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRBaseDBModel.h"
typedef NS_ENUM(NSInteger,MXRModuleType) {
    MXRNotifyThePromotionType  =0,      //通知推广
    MXRTheFirstScreenBouncedType =1,    //首屏弹窗广告
    MXRBannerRecommendType = 2,         //首页banner
    MXRQeustionExerciseType = 3,        //问答
    MXRHomePageZoneFloorType = 4        //首页楼层专区
};

typedef NS_ENUM(NSInteger,MXRActionType) {
    MXRClickActionType = 0,
    MXRReadActionType =1,
    MXRLinkClickActionType = 2
};

typedef NS_ENUM(NSInteger , MXRDataActionType){
    MXRDataReadActionType        = 1,
    MXRDataHotPointActionType    = 2,
    MXRDataDownloadActionType    = 3,
    MXRDataShareActionType       = 6,
    MXRDataOtherType             = 7       // 其他行为
};

typedef NS_ENUM(NSInteger , MXRDataActionUploadStatus){
    MXRDataActionUploadFailStatus     = 0,
    MXRDataActionUploadSuccessStatus  = 1
};

typedef NS_ENUM(NSInteger , MXRDataUserActionStatus){
    MXRDataUserActionFailStatus     = 0,    // 用户非主动退出行为
    MXRDataUserActionSuccessStatus  = 1     // 用户主动退出行为
};

typedef NS_ENUM(NSInteger , MXRDataAccountType){
    MXRDataAccountGeneralType   = 0,              // 普通
    MXRDataAccountQQType        = 1,              // QQ
    MXRDataAccountWeChatType    = 2,              // 微信
    MXRDataAccountSinaWeiBoType = 3,              // 新浪微博
    MXRDataAccountOtherType     = 4               // 其它
};

/******   分享类型   ******/
typedef NS_ENUM(NSInteger, MXRCollectShareType) {
    MXRCollectShareBook        = 1,
    MXRCollectSharePicture     = 2,
    MXRCollectShare4DCity      = 3,
    MXRCollectShareTopic       = 4,
    MXRCollectShareBookDetail  = 5
};

/******   分享渠道   ******/
typedef NS_ENUM(NSInteger, MXRCollectShareChannel) {
    MXRCollectShareChannelWeiXinFriends     = 1,
    MXRCollectShareChannelCircleOfFriends   = 2,
    MXRCollectShareChannelSinaWeibo         = 3,
    MXRCollectShareChannelQQ                = 4,
    MXRCollectShareChannelMengXiangQuan     = 5,
    MXRCollectShareChannelQQFriends         = 6,
};


typedef NS_ENUM(NSInteger, MXRNotificationLinkType){
    MXRNotificationLinkBookDetail  = 0,
    MXRNotificationLinkOuterLink   = 1

};
/*******    热点类型   *******/
//1-小梦辅导；2-UGC音频；3-UGC视频；4-UGC图片；5-UGC网址；6-UGC头像
typedef NS_ENUM(NSInteger, MXRHotType){
    MXRHotDefaultType    = 0,
    MXRHotTutoringType   = 1,
    MXRHotAudioType      = 2,
    MXRHotVidoeType      = 3,
    MXRHotImageType      = 4,
    MXRHotWebType        = 5,
    MXRHotFaceVideoType  = 6
};

typedef NS_ENUM(NSInteger,MXRBookStateType) {
    MXRBookOfflineType = 0,
    MXRBookOnlineType  = 1
};

@interface MXRDataAction : NSObject
@property (nonatomic,copy) NSString *actionSessionId;

/*
 在上传的时候赋值
 */
@property (nonatomic,copy)   NSString *sessionId;
@property (nonatomic,assign) MXRDataUserActionStatus  status;     //状态上报：1-完成（用户主动退出阅读）0-其他（不是用户主动退出的状态） 需要外界传入
@property (nonatomic,assign) MXRDataActionUploadStatus uploadStatus; // 1-已上传至服务器 0-未上传至服务器
@property (nonatomic,assign) MXRDataActionType type;                 // 行为标识
@property (nonatomic,copy)   NSString *account;
/*
 
 初始化所有的变量
 */
-(instancetype)initWithAccount:(NSString*)accountId;

/*
 设置上传时候的sessionid 并更新数据库
 */
-(void)changeSessionIdToDB:(NSString *)sessionId;

/**
 改变每个行为的状态
 */
-(void)changeActionStatus:(MXRDataUserActionStatus)status;

/**
 把对象转换成dictionary
 @return 转换好的对象
 */
-(NSDictionary*)toDictionary;

/**
  修改上传状态为成功状态并更新数据库
 */
-(void)modifyUploadStatusBecomeSuccess;


@end



//===================================================================================
@interface MXRDataDetailAction : MXRDataAction
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;
/*
 
 初始化所有的变量
 */
-(instancetype)initWithAccount:(NSString*)accountId;
/*
 设置结束时间，为endTime赋值 ,设置操作状态为status赋值
 */
-(void)configureEndActionTime;

/**
 设置 readSessionId

 @param readSessionId 一本书 在一次阅读中readSession 一致 
 */
-(void)setMXRReadSessionId:(NSString *)readSessionId;
@end



//===================================================================================

/**
 系统的信息
 */
@interface MXRDataSystemAction :NSObject
@property (nonatomic,copy) NSString *sessionId;
@property (nonatomic,copy) NSString *deviceId;
@property (nonatomic,copy) NSString *regAccount;
@property (nonatomic,copy) NSString *phoneNo;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *clientVersion;
@property (nonatomic,copy) NSString *clientOs;
@property (nonatomic,copy) NSString *terminalModel;
@property (nonatomic,copy) NSString *terminalOs;
@property (nonatomic,copy) NSString *terminalBrand;
@property (nonatomic,copy) NSString *channelNo;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *sdkVersion;
@property (nonatomic,copy) NSString *operators;
@property (nonatomic,copy) NSString *networkType;
@property (nonatomic,copy) NSString *ip;
@property (nonatomic,copy) NSString *reportTime;
@property (nonatomic,assign) MXRDataAccountType accountType;

/**
 初始化所有相关的参数

 @param userId 用户id
 @param phoneNo 用户的电话号码
 @param regAccount 用户的注册的账号
 @return 初始化好的对象
 */
-(instancetype)initWithAccountType:(MXRDataAccountType)accountType
                          province:(NSString*)province
                          accoutId:(NSString*)accoutId
                           phoneNo:(NSString*)phoneNo
                            userId:(NSString*)userId
                              city:(NSString*)city
                                ip:(NSString*)ip;

@end

//===================================================================================
/**
 阅读行为
 */
@interface MXRDataReadAction : MXRDataDetailAction
@property (nonatomic,copy) NSString *guid;
@property (nonatomic,copy) NSString *pageNo;
/**
 初始化阅读行为的动作初始化，其中唯一标示和状态继承于基类，开始时间默认初始化好，结束时间初始成开始时间

 @param bookId 图书ID
 @param accountId 账号
 @param pageNumber 页码
 @param hotPointid 热点ID,应该是按钮的actionid
 @return 返回初始化的对象
 */
-(instancetype)initWithAccount:(NSString*)accountId
                    pageNumber:(NSString*)pageNumber
                        bookId:(NSString*)bookId;
@end

//===================================================================================
/**
 热点行为
 */
@interface MXRDataHotPointAction : MXRDataDetailAction
@property (nonatomic,copy) NSString *hotId;
@property (nonatomic,copy) NSString *guid;
@property (nonatomic,assign)MXRHotType hotType;
@property (nonatomic,assign)MXRBookStateType isOnline;
-(instancetype)initWithAccount:(NSString *)account
                         hotId:(NSString *)hotId
                      bookGuid:(NSString *)guid
                       hotType:(MXRHotType)hotType
                 bookStateType:(MXRBookStateType)bookStateType;
@end



//===================================================================================
/**
 下载行为
 */
@interface MXRDataDownloadAction : MXRDataAction
@property (nonatomic,copy) NSString *guid;
//@property (nonatomic,assign) MXRDownloadSourceType sourceType;
-(instancetype)initWithAccount:(NSString *)accountId  bookGuid:(NSString*)bookGuid statu:(MXRDataUserActionStatus)status;

@end



//===================================================================================
/**
 分享行为
 */
@interface MXRDataShareAction : MXRDataAction
@property (nonatomic,copy) NSString *shareTime;
@property (nonatomic,assign) MXRCollectShareType shareType;
@property (nonatomic,assign) MXRCollectShareChannel shareChannel;
-(instancetype)initWithAccount:(NSString *)accountId
                     shareType:(MXRCollectShareType)shareType
                  shareChannel:(MXRCollectShareChannel)shareChannel
                         statu:(MXRDataUserActionStatus)status;
@end
//====================================================================================
/**
 私信消息的点击行为
 */
@interface MXRDataNotificationAction : MXRDataAction

@property (nonatomic, assign) NSInteger moduleEntityId;         // 私信消息Id
@property (nonatomic, assign) NSInteger moduleType;             // 模块类型：0-通知推广 全部为0
@property (nonatomic, assign) NSInteger actionType;             // 操作类型：0-点击，1-阅读，2-链接点击
@property (nonatomic, assign) NSInteger userId;                 // 用户Id
@property (nonatomic, copy)   NSString *startTime;             // 用户操作时间

- (instancetype)initWithAccount:(NSString *)account
                       moduleId:(NSInteger)moduleId
                     moduleType:(MXRModuleType)moduleType
                     actionType:(MXRActionType)actionType
                         userId:(NSInteger )userId;

@end


@interface MXRDataNotificationLinkAction : MXRDataNotificationAction
@property (nonatomic, assign) MXRNotificationLinkType linkType; // 链接的类型 0-图书 1-超链接
@property (nonatomic, copy)   NSString *linkName;               // 点击链接的名字

- (instancetype)initWithAccount:(NSString *)accountId
                       moduleId:(NSInteger)moduleId
                     moduleType:(NSInteger)moduleType
                     actionType:(NSInteger)actionType
                         userId:(NSInteger)userId
                       linkName:(NSString *)linkName
                       linkType:(MXRNotificationLinkType)linkType;

@end

/**
 问答行为
 */
@interface MXRQuestionExerciseAction : MXRDataNotificationAction
@property (nonatomic, copy)   NSString *endTime;             // 用户操作时间

/*
 设置结束时间，为endTime赋值 ,设置操作状态为status赋值
 */
-(void)configureEndActionTime;
@end
