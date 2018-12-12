//
//  MXRPKRequestModel.h
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRPKResponseModel.h"
@interface MXRPKRequestModel : NSObject

@end

@interface MXRGetQAListWithIdR : NSObject
@property (nonatomic, strong) NSString *qaId;
@end

@interface MXRSubmitAnswerDetailR : NSObject
@property (nonatomic, strong) NSArray *answerIds;   // 用户选择的答案 id 数组
@property (nonatomic, assign) NSInteger isRight;    // 是否正确 0错误，1正确
@property (nonatomic, strong) NSString *questionId; // 问答题目ID
@end

@interface MXRSubmitPKAnswersR : NSObject <MXRModelDelegate>
@property (nonatomic, strong) NSString *qaInfoId;       // 问答id
@property (nonatomic, assign) NSInteger accuracy;       // 正确率
@property (nonatomic, assign) NSInteger startTime;      // 开始时间
@property (nonatomic, assign) NSInteger endTime;        // 结束时间
@property (nonatomic, strong) NSString *ip;             // IP 地址
@property (nonatomic, assign) NSInteger isPk;       // 是否是 PK 模式，0：PK 模式，1：普通模式
@property (nonatomic, assign) NSInteger matchAccuracy;  // 被匹配者用户正确率 ,
@property (nonatomic, assign) NSInteger matchUserId;    // 被匹配者用户id
@property (nonatomic, strong) NSString *matchUserLogo;  // 被匹配者用户logo
@property (nonatomic, strong) NSString *matchUserName;  // 被匹配者用户名称
@property (nonatomic, strong) NSArray<MXRRandomOpponentQuestionModel *> *questionDetail;  // 答题详细数据
@property (nonatomic, assign) NSInteger result;         // PK 结果，-1 输，0平， 1胜 ,
@end
