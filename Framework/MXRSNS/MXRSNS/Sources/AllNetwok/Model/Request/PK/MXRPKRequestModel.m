//
//  MXRPKRequestModel.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKRequestModel.h"

@implementation MXRPKRequestModel

@end

@implementation MXRGetQAListWithIdR

@end

@implementation MXRSubmitAnswerDetailR

@end

@implementation MXRSubmitPKAnswersR

+ (NSDictionary<NSString *,id> *)mxr_modelContainerPropertyGenericClass
{
    return @{@"questionDetail": [MXRRandomOpponentQuestionModel class]};
}

@end
