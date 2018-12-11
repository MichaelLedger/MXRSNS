//
//  MXROneMinuteDataAnalysis.h
//  huashida_home
//
//  Created by Martin.Liu on 2018/7/16.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXROneMinuteDataModel.h"


/**
 一分钟行为数据统计
 上传机制：启动时候上传
 */
@interface MXROneMinuteDataAnalysis : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSDictionary *vcClazzDict;

// 判断时候在可分析的时间内
- (BOOL)isInAnalysisTime;
+ (BOOL)isInAnalysisTime;

// 增加分析数据
- (void)addItemData:(MXROneMinuteItemModel *)itemModel;
+ (void)addItemData:(MXROneMinuteItemModel *)itemModel;

@end
