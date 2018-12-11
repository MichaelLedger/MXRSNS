//
//  MXRBookSNSBannerModel.m
//  huashida_home
//
//  Created by weiqing.tang on 2018/2/28.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSBannerModel.h"

@implementation MXRBookSNSBannerModel

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _bannerUrl = dict[@"bannerUrl"];
        NSInteger bannerType = [dict[@"bannerType"] integerValue];
        if (bannerType == 1) {
            _bookSNSBannerType = MXRBookSNSBannerQuestionType;
        }
    }
    return self;
}

@end
