//
//  MXRBookSNSDetailModel.m
//  huashida_home
//
//  Created by shuai.wang on 16/9/23.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSDetailModel.h"
#import "MXRSNSShareModel.h"
static NSString *dynamic = @"dynamic";
static NSString *comments = @"comments";

@implementation MXRBookSNSDetailModel

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    
    if (self = [super init])
    {
        _dynamicModel = [[MXRSNSShareModel alloc] createWithDictionary:dict[dynamic]];
        _commentsModel = [[MXRBookSNSDetailCommentsModel alloc] initWithDictionary:dict[comments]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.dynamicModel forKey:dynamic];
    [aCoder encodeObject:self.commentsModel forKey:comments];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init])
    {
        _dynamicModel = [aDecoder decodeObjectForKey:dynamic];
        _commentsModel = [aDecoder decodeObjectForKey:comments];
    }
    return self;
}

@end
