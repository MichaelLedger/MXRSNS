//
//  MXRPKHomeRankingInfoResponseModel.m
//  huashida_home
//
//  Created by 周建顺 on 2018/1/20.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKHomeRankingInfoResponseModel.h"

static NSString *medalCountStr = @"medalCount";
static NSString *winStr = @"win";
static NSString *drawStr = @"draw";
static NSString *loseStr = @"lose";

@implementation MXRPKHomeRankingInfoResponseModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(_medalCount) forKey:medalCountStr];
    [aCoder encodeObject:@(_win) forKey:winStr];
    [aCoder encodeObject:@(_draw) forKey:drawStr];
    [aCoder encodeObject:@(_lose) forKey:loseStr];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.medalCount = [[aDecoder decodeObjectForKey:medalCountStr] integerValue];
        self.win = [[aDecoder decodeObjectForKey:winStr] integerValue];
        self.draw = [[aDecoder decodeObjectForKey:drawStr] integerValue];
        self.lose = [[aDecoder decodeObjectForKey:loseStr] integerValue];
    }
    return self;
}

@end
