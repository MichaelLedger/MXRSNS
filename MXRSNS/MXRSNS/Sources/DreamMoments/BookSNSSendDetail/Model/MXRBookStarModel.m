//
//  MXRBookStarModel.m
//  huashida_home
//
//  Created by yuchen.li on 16/10/8.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookStarModel.h"

@implementation MXRBookStarModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _star     = autoInteger(dict[@"star"]);
        _bookGuid = autoString(dict[@"bookGuid"]);
    }
    return self;
}

@end
