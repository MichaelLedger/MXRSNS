//
//  MXRDataAction.m
//  huashida_home
//
//  Created by weiqing.tang on 2017/2/6.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRDataAction.h"
#import "MXRDeviceUtil.h"
#import "NSString+NSDate.h"
#import "NSObject+MXRModel.h"
#import "MXRCollectionDataController.h"
//#import "MXRBookManager.h"
#define MXRCacheDBName @"Cache.db"
/**
 数据统计行为的基类
 */
@implementation MXRDataAction

-(instancetype)initWithAccount:(NSString*)accountId{
    self = [super init];
    if(self){
        _account         = accountId;
        _uploadStatus    = MXRDataActionUploadFailStatus;
        _actionSessionId = [MXRDeviceUtil getUUID];
    }
    return self;
}



+ (BOOL)isContainParent
{
    return YES;
}

+ (LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:MXRCacheDBName];
        
        db = [[LKDBHelper alloc] initWithDBPath:dbPath];
    });
    return db;
}

/**
 改变每个行为的状态
 */
-(void)changeActionStatus:(MXRDataUserActionStatus)status {
    self.status = status;
}

-(NSDictionary*)toDictionary{
    DERROR(@"You should replace this function in child class");
    assert(0);
    return nil;
}

/*
 设置上传时候的sessionid 并更新数据库
 */
-(void)changeSessionIdToDB:(NSString *)sessionId{
    self.sessionId = sessionId;
    [self updateToDB];
}

/**
  上传成功后 修改上传状态为成功
 */
-(void)modifyUploadStatusBecomeSuccess{
    self.uploadStatus =MXRDataActionUploadSuccessStatus;
    [self updateToDB];
}
@end

@implementation MXRDataDetailAction

-(instancetype)initWithAccount:(NSString *)accountId{
    self = [super initWithAccount:accountId];
    if(self){
        _startTime = [NSString creatCurrentTimeWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
        [self setAccount:accountId];
    }
    return self;
}
/*
 设置结束时间，为endTime赋值
 */
-(void)configureEndActionTime{
    self.endTime = [NSString creatCurrentTimeWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

-(void)setMXRReadSessionId:(NSString *)readSessionId{
    [self setActionSessionId:readSessionId];
}
@end

/**
 系统的信息
 */

@implementation MXRDataSystemAction

-(instancetype)initWithAccountType:(MXRDataAccountType)accountType
                          province:(NSString *)province
                          accoutId:(NSString *)accoutId
                           phoneNo:(NSString *)phoneNo
                            userId:(NSString *)userId
                              city:(NSString *)city
                                ip:(NSString *)ip{
    if (self = [super init]) {
        _accountType          = accountType;
        _deviceId             = [MXRDeviceUtil getCurrentUserIdAsscationDevice]?:@"";
        _sessionId            = [MXRDeviceUtil getUUID];
        _regAccount           = accoutId;
        _phoneNo              = phoneNo;
        _userId               = userId;
        _clientVersion        = [MXRDeviceUtil getClientVersion];
        _terminalModel        = [MXRDeviceUtil getDeviceModel];
        _terminalOs           = [MXRDeviceUtil getSystermVersion];
        _operators            = [MXRDeviceUtil getOperationType];
        _networkType          = [MXRDeviceUtil getNetworkType];
        _terminalBrand        = @"Apple";
        _channelNo            = @"1";
        _clientOs             = @"iOS";
        _sdkVersion           = @"1.0";
        _ip                   = ip;
        _reportTime           = [NSString creatCurrentTimeWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
        _province             = province;
        _city                 = city;
        
    }
    return self;

}
@end


//===================================================================================
/**
 阅读行为
 */

@implementation MXRDataReadAction

-(instancetype)initWithAccount:(NSString*)accountId
                    pageNumber:(NSString*)pageNumber
                        bookId:(NSString*)bookId{
    if (self = [super initWithAccount:accountId]) {
        _guid          = bookId;
        _pageNo        = pageNumber;
        [self setType:MXRDataReadActionType];
       
    }
    
    return self;
}

-(NSDictionary*)toDictionary{
    NSDictionary *dict               =  [self mxr_modelToJSONObject];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mutableDict setObject:self.actionSessionId forKey:@"readSessionId"];
    return mutableDict;
}

@end


//===================================================================================
/**
 热点行为
 */
@implementation MXRDataHotPointAction
-(instancetype)initWithAccount:(NSString *)account
                         hotId:(NSString *)hotId
                      bookGuid:(NSString *)guid
                       hotType:(MXRHotType)hotType
                 bookStateType:(MXRBookStateType)bookStateType{
    if (self = [super initWithAccount:account]) {
        _hotId         = hotId;
        _guid          = guid;
        _hotType       = hotType;
        _isOnline = bookStateType;
        [self setType:MXRDataHotPointActionType];
       
    }
    return self;
}

/**
 把对象转换成dictionary  保证与 阅读行为的readSessionId保持一致
 
 @return 转换好的对象
 */
-(NSDictionary*)toDictionary{
    NSDictionary *dict               =  [self mxr_modelToJSONObject];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mutableDict setObject:self.actionSessionId forKey:@"readSessionId"];
    return mutableDict;
}

@end


//===================================================================================
/**
 下载行为
 */
@implementation MXRDataDownloadAction

-(instancetype)initWithAccount:(NSString *)accountId  bookGuid:(NSString*)bookGuid statu:(MXRDataUserActionStatus)status{
    if (self = [super initWithAccount:accountId]) {
        _guid              = bookGuid;
        self.status     = status;
//        self.sourceType = [MXRBookManager defaultManager].downloadSourceType;
        [self setType:MXRDataDownloadActionType];
    }
    return self;
}

/**
 把对象转换成dictionary
 
 @return 转换好的对象
 */
-(NSDictionary*)toDictionary{
    NSDictionary *dict               =  [self mxr_modelToJSONObject];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mutableDict setObject:self.actionSessionId forKey:@"downloadSessionId"];
    return mutableDict;
}

@end


//===================================================================================
/**
 分享行为
 */

@implementation MXRDataShareAction
-(instancetype)initWithAccount:(NSString *)accountId
                     shareType:(MXRCollectShareType)shareType
                  shareChannel:(MXRCollectShareChannel)shareChannel
                         statu:(MXRDataUserActionStatus)status
{
 
    if (self = [super initWithAccount:accountId]) {
        _shareTime      = [NSString creatCurrentTimeWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
        _shareType      = shareType;
        _shareChannel   = shareChannel;
        self.status     = status;
        [self setType:MXRDataShareActionType];
    }
    return self;
}

/**
 把对象转换成dictionary
 
 @return 转换好的对象
 */
-(NSDictionary*)toDictionary{
    NSDictionary *dict               =  [self mxr_modelToJSONObject];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mutableDict setObject:self.actionSessionId forKey:@"shareSessionId"];
    return mutableDict;
}

@end

@implementation MXRDataNotificationAction

/**
 初始化操作
 @param account 账户
 @param moduleId moduleType=0时，表示通知推广id；  moduleType=1时，表示首屏弹框广告id
 @param moduleType 采集模块类型：0-通知推广，1-首屏弹框
 @param actionType 操作类型：0-点击，1-阅读，2-链接点击
 @param userId 用户id
 */
- (instancetype)initWithAccount:(NSString *)account
                       moduleId:(NSInteger)moduleId
                     moduleType:(MXRModuleType)moduleType
                     actionType:(MXRActionType)actionType
                         userId:(NSInteger )userId
{
    if (self = [super initWithAccount:account]) {
        _moduleEntityId = moduleId;
        _moduleType     = moduleType;
        _actionType     = actionType;
        _userId         = userId;
        _startTime     = [NSString creatCurrentTimeWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
        [self setType:MXRDataOtherType];
    }
    return self;
}
/**
 把对象转换成dictionary
 
 @return 转换好的对象
 */
- (NSDictionary *)toDictionary
{
    NSDictionary *dict   = [self mxr_modelToJSONObject];
    return dict;
}
@end

@implementation MXRDataNotificationLinkAction


- (instancetype)initWithAccount:(NSString *)accountId moduleId:(NSInteger)moduleId moduleType:(NSInteger)moduleType actionType:(NSInteger)actionType userId:(NSInteger)userId linkName:(NSString *)linkName linkType:(MXRNotificationLinkType)linkType
{
    if (self = [super initWithAccount:accountId moduleId:moduleId moduleType:moduleType actionType:actionType userId:userId]) {
        _linkType = linkType;
        _linkName = linkName;
    }
    return  self;
}
/**
 把对象转换成dictionary
 
 @return 转换好的对象
 */
- (NSDictionary *)toDictionary{

    NSDictionary *dict = [self mxr_modelToJSONObject];
    return dict;
}
@end

@implementation MXRQuestionExerciseAction
/*
 设置结束时间，为endTime赋值 ,设置操作状态为status赋值
 */
-(void)configureEndActionTime {
    self.endTime = [NSString creatCurrentTimeWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
}
@end
