//
//  MXRPKQuestionListModel.h
//  huashida_home
//
//  Created by MountainX on 2018/8/8.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MXRModel.h"

@interface MXRPKQuestionListModel : NSObject

@property (nonatomic, assign) NSInteger accuracy;

@property (nonatomic, assign) NSInteger avgAccuracy;

@property (nonatomic, assign) NSInteger classifyId;

@property (nonatomic, copy) NSString *coverUrl;

@property (nonatomic, assign) NSInteger isPartIn;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *publishTime;

@property (nonatomic, assign) NSInteger qaId;

@property (nonatomic, assign) NSInteger questionNum;

@end
