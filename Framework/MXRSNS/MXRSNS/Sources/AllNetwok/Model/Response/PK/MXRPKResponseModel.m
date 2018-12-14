//
//  MXRPKResponseModel.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKResponseModel.h"
#import <MAREXT/NSArray+MAREX.h>

@implementation MXRPKResponseModel

@end

@implementation MXRPKQuestionLibModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mxr_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mxr_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mxr_modelCopy];
}

+ (NSDictionary<NSString *,id> *)mxr_modelContainerPropertyGenericClass
{
    return @{@"questionList":[MXRPKQuestionModel class],
             @"recommendBook":[MXRPKRecommendBook class]};
}

@end

@implementation MXRPKQuestionModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mxr_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mxr_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mxr_modelCopy];
}

+ (NSDictionary<NSString *,id> *)mxr_modelCustomPropertyMapper
{
    return @{@"answers":@"answer"};
}

+ (NSDictionary<NSString *,id> *)mxr_modelContainerPropertyGenericClass
{
    return @{@"questionContent":[MXRPKQuestionContent class],
             @"answers":[MXRPKAnswerOption class],
             @"questionBook":[MXRPKRecommendBook class],
             };
}

// 随机打乱选项顺序
- (void)randomSortOptions
{
    if (self.answers.count > 1) {
        self.answers = [self.answers mar_shuffledArray];
    }
    self.selectedIndexArray = nil;
}

@end

@implementation MXRPKAnswerOption

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mxr_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mxr_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mxr_modelCopy];
}

+ (NSDictionary<NSString *,id> *)mxr_modelCustomPropertyMapper
{
    return @{@"word":@"answerContent.word",
             @"pic":@"answerContent.pic"};
}

@end

@implementation MXRPKQuestionContent

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mxr_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mxr_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mxr_modelCopy];
}

@end

@implementation MXRPKRecommendBook

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mxr_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mxr_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mxr_modelCopy];
}

@end



/**
 pk对手的信息详情
 */
@implementation MXRRandomOpponentQuestionModel
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mxr_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mxr_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mxr_modelCopy];
}

//+ (NSDictionary<NSString *,id> *)mxr_modelCustomPropertyMapper
//{
//    return @{@"answers":@"answer"};
//}
//
//+ (NSDictionary<NSString *,id> *)mxr_modelContainerPropertyGenericClass
//{
//    return @{@"questionContent":[MXRPKQuestionContent class],
//             @"answers":[MXRPKAnswerOption class],
//             @"questionBook":[MXRPKRecommendBook class],
//             };
//}
@end

@implementation MXRRandomOpponentResult
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mxr_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mxr_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mxr_modelCopy];
}


+ (NSDictionary<NSString *,id> *)mxr_modelContainerPropertyGenericClass
{
    return @{@"questionModelList":[MXRRandomOpponentQuestionModel class]};
}

@end

@implementation MXRPKQARankModel

- (NSString *)description
{
    return [self mxr_modelDescription];
}

@end

@implementation MXRPKSubmitResultModel

- (NSString *)description
{
    return [self mxr_modelDescription];
}

+ (NSDictionary<NSString *,id> *)mxr_modelCustomPropertyMapper
{
    return @{@"rankingList":@"qaRankingVo.rankingList",
             @"currentRankingSort":@"qaRankingVo.currentRankingSort",
             @"surpassPersons":@"qaRankingVo.surpassPersons"
             };
}

+ (NSDictionary<NSString *,id> *)mxr_modelContainerPropertyGenericClass
{
    return @{@"rankingList": [MXRPKQARankModel class]};
}

@end
