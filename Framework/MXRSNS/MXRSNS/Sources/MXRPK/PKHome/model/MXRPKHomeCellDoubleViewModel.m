//
//  MXRPKHomeCellDoubleViewModel.m
//  huashida_home
//
//  Created by 周建顺 on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKHomeCellDoubleViewModel.h"

static NSString *localImageNameStr = @"localImageName";

@implementation MXRPKHomeCellDoubleViewModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_localImageName forKey:localImageNameStr];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.localImageName = [aDecoder decodeObjectForKey:localImageNameStr];
    }
    return self;
}

@end
