//
//  MXRBookSNSPraiseListModel.m
//  huashida_home
//
//  Created by shuai.wang on 16/9/29.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSPraiseListModel.h"
static NSString *createTime = @"createTime";
static NSString *dynamicId = @"dynamicId";
static NSString *iD = @"iD";
static NSString *userId = @"userId";
static NSString *userLogo = @"userLogo";
static NSString *userName = @"userName";
static NSString *vipFlag = @"vipFlag";

@implementation MXRBookSNSPraiseListModel

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    
    if (self= [super init]) {
        _createTime = autoString(dict[createTime]);
        _dynamicId = autoInteger(dict[dynamicId]);
        _iD = autoInteger(dict[iD]);
        _userId = autoInteger(dict[userId]);
        _userLogo = autoString(dict[userLogo]);
        _userName = autoString(dict[userName]);
        _vipFlag = [dict[vipFlag] integerValue] > 0 ? YES : NO;
    }
    return self;
}

-(NSString *)userLogo {
    return REPLACE_HTTP_TO_HTTPS(_userLogo);
}
@end
