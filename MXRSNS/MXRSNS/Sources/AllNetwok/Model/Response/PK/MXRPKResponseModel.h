//
//  MXRPKResponseModel.h
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MXRModel.h"
#import "MXRBaseDBModel.h"

@interface MXRPKResponseModel : NSObject

@end

@class MXRPKQuestionContent;
@class MXRPKQuestionModel;
@class MXRPKAnswerOption;
@class MXRPKRecommendBook;
@interface MXRPKQuestionLibModel : NSObject <MXRModelDelegate, NSCopying, NSCoding>
@property (nonatomic, copy) NSString                              *qaId;              // 试题id
@property (nonatomic, copy) NSString                              *name;              // 问答名称
@property (nonatomic, strong) NSArray<MXRPKQuestionModel*>          *questionList;       // 问题列表属性
@property (nonatomic, strong) MXRPKRecommendBook                    *recommendBook;      // 问答推荐图书列表
@property (nonatomic, assign) NSInteger                             accuracy;           // 正确率
@property (nonatomic, copy) NSString                              *coverUrl;          // 问答封面图
@property (nonatomic, copy) NSString                              *isPartIn;          // 用户是否参与
@property (nonatomic, assign) NSInteger                             position;           // 问答位置
@property (nonatomic, assign) NSInteger                             userNum;            // 参与人数

@end

@interface MXRPKQuestionModel : NSObject <MXRModelDelegate, NSCopying, NSCoding>
@property (nonatomic, copy) NSString                              *questionId;            // 问题id
@property (nonatomic, strong) MXRPKQuestionContent                  *questionContent;       // 问题题目
@property (nonatomic, strong) NSArray<MXRPKAnswerOption *>          *answers;               // 试题选项集合
@property (nonatomic, copy) NSString                              *analysis;              // 题目答案解析

@property (nonatomic, strong) MXRPKRecommendBook                    *questionBook;          // 问题关联的图书
@property (nonatomic, assign) NSInteger                             answerType;             // 问题答案类型（5.8.5新增）：1-文字，2-图片，3-图文

@property (nonatomic, assign) NSInteger isRight;    // 是否正确 0错误，1正确 ,
@property (nonatomic, strong) NSArray                               *selectedIndexArray;    // 选择的答案集合 ， 索引数组

// 随机打乱选项顺序
- (void)randomSortOptions;

@end

@interface MXRPKAnswerOption : NSObject<MXRModelDelegate, NSCopying, NSCoding>
@property (nonatomic, assign) NSInteger answerId;
@property (nonatomic, copy) NSString *word;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, assign) BOOL correct;
@end

@interface MXRPKQuestionContent : NSObject<NSCopying, NSCoding>
@property (nonatomic, copy) NSString *word;
@property (nonatomic, copy) NSString *pic;
@end

@interface MXRPKRecommendBook : NSObject
@property (nonatomic, copy) NSString *bookDesc;
@property (nonatomic, copy) NSString *bookGuid;
@property (nonatomic, copy) NSString *bookIconUrl;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *bookStar;
@end


/**
 pk对手的信息详情
 */
@interface MXRRandomOpponentQuestionModel : NSObject <MXRModelDelegate, NSCopying, NSCoding>
@property (nonatomic, strong) NSArray *answerIds;       // 用户选择的答案 id 数组
@property (nonatomic, assign) NSInteger  isRight;            // 是否正确 0错误，1正确
@property (nonatomic, copy) NSString *questionId;    // pk问答题目ID
@end

@interface MXRRandomOpponentResult : NSObject <MXRModelDelegate, NSCopying, NSCoding>
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, strong) NSArray<MXRRandomOpponentQuestionModel*> *questionModelList;

@property (nonatomic, assign) NSInteger  userId;              // pk对手的id
@property (nonatomic, assign) NSInteger  accuracy;            // pk对手的正确率
@property (nonatomic, assign) NSInteger  qaId;                // pk的题目qaid
// V5.13.0 M by liulong 是否是vip图书
@property (nonatomic, assign) BOOL vipFlag;

@end

@interface MXRPKQARankModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger ip;
@property (nonatomic, assign) NSInteger qaId;
@property (nonatomic, assign) NSInteger accuracy;           // 正确率
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *userLogo;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) NSInteger isDelete;
@property (nonatomic, assign) NSInteger isFist;
@property (nonatomic, assign) NSInteger isNew;
@property (nonatomic, strong) NSString *osType;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) BOOL vipFlag;// V5.13.0 是否为VIP

@end

@interface MXRPKSubmitResultModel : NSObject <MXRModelDelegate>
@property (nonatomic, assign) NSInteger awardMxbNum;    // 获取了多少梦想币数量
@property (nonatomic, assign) NSInteger isGetMxb;       // 是否还能获取梦想币， 0能，1不能
@property (nonatomic, assign) NSInteger isNeedMxbAnalysis;  // 错题解析是否还需要梦想币, 0 需要， 1不需要
@property (nonatomic, assign) NSInteger isNeedMxbAnalysisNum;   // 此次错题解析需要多少梦想币
@property (nonatomic, strong) NSArray<MXRPKQARankModel *> *rankingList;    // 排行榜信息数组
@property (nonatomic, assign) NSInteger currentRankingSort; // 当前用户排行
@property (nonatomic, assign) NSInteger surpassPersons;     //  超越人数
@end


