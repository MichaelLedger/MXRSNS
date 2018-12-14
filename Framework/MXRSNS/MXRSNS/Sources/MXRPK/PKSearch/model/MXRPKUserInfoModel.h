//
//  MXRPKUserInfoModel.h
//  huashida_home
//
//  Created by shuai.wang on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRPKResponseModel.h"
@interface MXRPKUserInfoModel : NSObject

@property (nonatomic, strong) MXRPKQuestionLibModel *pkQuestionLibModel;
@property (nonatomic, strong) MXRRandomOpponentResult *randomOpponentResult;
@property (nonatomic, strong) MXRRandomOpponentResult *mineResult;//我的答题结果

-(instancetype)initWithMXRPKQuestionLibModel:(MXRPKQuestionLibModel *)pkQuestionLibModel randomOpponentResult:(MXRRandomOpponentResult *)randomOpponentResult;
@end
