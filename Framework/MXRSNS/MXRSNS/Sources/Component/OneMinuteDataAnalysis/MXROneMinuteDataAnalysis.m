//
//  MXROneMinuteDataAnalysis.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/7/16.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXROneMinuteDataAnalysis.h"
#import "NSObject+MAREX.h"
//#import <NSString+MAREX.h>
#import "MXROneMinuteNetworkManager.h"
#import "Notifications.h"
#import "NSString+Ex.h"

static const NSInteger MXROneMinuteDataDuration = 60;

@interface MXROneMinuteDataAnalysis()

@property (nonatomic, assign, readonly) NSTimeInterval startTime;
@property (nonatomic, strong) MXROneMinuteDataModel *dataModel;

- (BOOL)isInAnalysisTime;  

@end

@implementation MXROneMinuteDataAnalysis
{
    BOOL notNeedSaveDate;       // 不统计时间外不对数据库进行操作
}
+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self.class alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _startTime = [[NSDate new] timeIntervalSince1970];
        [self addObservers];
    }
    return self;
}

- (NSDictionary *)vcClazzDict
{
    if (!_vcClazzDict || _vcClazzDict.allKeys.count == 0) {
        NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"vcclasslist" ofType:@"plist"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:NULL];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            _vcClazzDict = dictionary;
//            NSLog(@">>>>>>> dict : %@", _vcClazzDict);
        }
    }
    return _vcClazzDict;
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didEnterBackgroundNoti:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didBecomeActiveNoti:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didFinishLaunchNoti:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_willTerminateNoti:) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateUserIdNoti:) name:Notification_GuestLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateUserIdNoti:) name:notificationForUserLoginSuss object:nil];
}

// 进入后台
- (void)_didEnterBackgroundNoti:(NSNotification *)noti
{
    if ([self isInAnalysisTime]) {
//        DLOG(@">>>> one minute : background");
        MXROneMinuteItemModel *model = [MXROneMinuteItemModel new];
        model.type = @"background";
        [self addItemData:model];
        [self __recordExitData];
    }
    [self __saveRecordData];
    [self performSelector:@selector(uploadAnalysisData) withObject:nil afterDelay:1];
}

// 激活进入前台
- (void)_didBecomeActiveNoti:(NSNotification *)noti
{
    if ([self isInAnalysisTime]) {
        if ([self.dataModel.exitPageName isKindOfClass:[NSString class]] && [self.dataModel.exitPageName mar_isNotBlank]) {
            self.dataModel.exitPageName = nil;
            self.dataModel.endTimeInterval = 0;
        }
    }
}

// 启动
- (void)_didFinishLaunchNoti:(NSNotification *)noti
{
    [self uploadAnalysisData];
}

// 退出
- (void)_willTerminateNoti:(NSNotification *)noti
{
    if ([self isInAnalysisTime]) {
//        DLOG(@">>>> one minute : crash");
        MXROneMinuteItemModel *model = [MXROneMinuteItemModel new];
        model.type = @"exit";
        [self addItemData:model];
        [self __recordExitData];
    }
    [self __saveRecordData];
    [self uploadAnalysisData];
}

// 在登录成功或者游客登录成功时，更新用户ID
- (void)_updateUserIdNoti:(NSNotification *)noti
{
    if ([self isInAnalysisTime]) {
        self.dataModel.userId = [UserInformation modelInformation].userID;
    }
}

- (void)__recordExitData
{
    self.dataModel.endTimeInterval = [[NSDate new] timeIntervalSince1970];
    NSArray *array = [self.dataModel.dataList copy];
    NSInteger itemCount = array.count;
    for (int i = itemCount -1; i >= 0; i--) {
        MXROneMinuteItemModel *model = array[i];
        if ([model.type isEqual:@"page"]) {
            self.dataModel.exitPageName = model.name;
            self.dataModel.endTimeInterval = [[NSDate new] timeIntervalSince1970];
            break;
        }
    }
}

- (void)__saveRecordData
{
    if ([self isInAnalysisTime]) {
        [self.dataModel updateToDB];
    }
    else
    {
        // 只记录一分钟之内的数据。
        [self.dataModel deleteToDB];
        _dataModel = nil;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (BOOL)isInAnalysisTime
{
    return [[self sharedInstance] isInAnalysisTime];
}

- (BOOL)isInAnalysisTime
{
    NSTimeInterval now = [[NSDate new] timeIntervalSince1970];
    if ((now - self.startTime) < MXROneMinuteDataDuration) {
        return YES;
    }
    return NO;
}

- (MXROneMinuteDataModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[MXROneMinuteDataModel alloc] init];
    }
    return _dataModel;
}

+ (void)addItemData:(MXROneMinuteItemModel *)itemModel
{
//    DLOG(@">>>> one minute : add item");
    [[self sharedInstance] addItemData:itemModel];
}

- (void)addItemData:(MXROneMinuteItemModel *)itemModel
{
    if (self.dataModel.dataList.count > 0) {
        MXROneMinuteItemModel *lastPageModel = self.dataModel.dataList.lastObject;
        
        if ([itemModel.type isEqualToString:@"event"]) {
            if (self.dataModel.dataList.count > 0) {
                MXROneMinuteItemModel *lastPageModel = self.dataModel.dataList.lastObject;
                itemModel.uuid = lastPageModel.uuid;
                [lastPageModel.eventList addObject:itemModel];
            }
        }
        else
        {
            lastPageModel.nextPageName = itemModel.name;
            [self.dataModel.dataList addObject:itemModel];
        }
    }
    else
    {
        if ([itemModel.type isEqualToString:@"page"]) {
            [self.dataModel.dataList addObject:itemModel];
        }
    }
}

// 上传数据
- (void)uploadAnalysisData
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(uploadAnalysisData) object:nil];
    NSArray<MXROneMinuteDataModel *> *array = [[MXROneMinuteDataModel getUsingLKDBHelper] search:[MXROneMinuteDataModel class] where:nil orderBy:nil offset:0 count:0];
    __block int i = 0;
    for (MXROneMinuteDataModel *model in array) {
        i++;
        // 去重
        NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithArray:model.dataList];
        model.dataList = [[set array] mutableCopy];
        [self mar_gcdPerformAfterDelay:i*0.1 usingBlock:^(id  _Nonnull objSelf) {
            [MXROneMinuteNetworkManager postOneMinute:model success:^(MXRNetworkResponse *response) {
                if (response.isSuccess) {
                    DLOG(@"上传成功");
                    [model deleteToDB];
                };
            } failure:^(id error) {
                ;
            }];
        }];
    }
}

@end
