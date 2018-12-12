//
//  MXRPKUserInfoModel.m
//  huashida_home
//
//  Created by shuai.wang on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKUserInfoModel.h"

@implementation MXRPKUserInfoModel
-(instancetype)initWithMXRPKQuestionLibModel:(MXRPKQuestionLibModel *)pkQuestionLibModel randomOpponentResult:(MXRRandomOpponentResult *)randomOpponentResult {
    if (self = [super init]) {
        self.pkQuestionLibModel = pkQuestionLibModel;
        self.randomOpponentResult = randomOpponentResult;
    }
    return self;
}
@end
