//
//  MXROneMinuteDataModel.h
//  huashida_home
//
//  Created by Martin.Liu on 2018/7/16.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MXRModel.h"
#import "MXRBaseDBModel.h"
@class MXROneMinuteItemModel;

@interface MXROneMinuteDataModel : MXRBaseDBModel <MXRModelDelegate>

@property (nonatomic, strong) NSString *userId;             // 用户ID/游客ID
@property (nonatomic, strong) NSString *deviceId;           // 设备ID
@property (nonatomic, strong) NSString *startTime;          // 开始时间
@property (nonatomic, strong) NSString *endTime;            // 结束时间
@property (nonatomic, assign) NSInteger duration;           // 用时
@property (nonatomic, strong) NSString *exitPageName;       // 退出页面名称
@property (nonatomic, strong) NSString *mobileType;         // 手机型号
@property (nonatomic, strong) NSString *mobileOSVersion;    // 手机OS版本好
@property (nonatomic, strong) NSMutableArray<MXROneMinuteItemModel *> *dataList;
//@property (nonatomic, strong) NSMutableArray<MXROneMinuteItemModel *> *dataList;

@property (nonatomic, assign) NSTimeInterval startTimeInterval;
@property (nonatomic, assign) NSTimeInterval endTimeInterval;

@end

@interface MXROneMinuteItemModel : MXRBaseDBModel <MXRModelDelegate, NSCoding, NSCopying>
@property (nonatomic, strong) NSString *uuid;       // uuid
@property (nonatomic, strong) NSString *type;       // event 事件  page  页面  background  后台  exit 杀掉进程
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nextPageName;   // 下一个页面名称 只有在page类型下用
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSMutableArray<MXROneMinuteItemModel *> *eventList;   // 事件放入这里

@property (nonatomic, assign) NSTimeInterval startTimeInterval;
@property (nonatomic, assign) NSTimeInterval endTimeInterval;

@end
