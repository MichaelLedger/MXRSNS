//
//  MXRPKHomeCellViewModel.m
//  huashida_home
//
//  Created by 周建顺 on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKHomeCellViewModel.h"
#import "NSString+Ex.h"

static NSString *descStr = @"desc";
static NSString *nameStr = @"name";
static NSString *picStr = @"pic";
static NSString *classifyIdStr = @"classifyId";

@implementation MXRPKHomeCellViewModel


-(instancetype)initWithModel:(MXRPKHomeResponeModel*)model{
    self = [super init];
    if(self){
        _desc = model.desc;
        _name = model.name;
        _pic = model.pic;
        _classifyId = model.classifyId;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_desc forKey:descStr];
    [aCoder encodeObject:_name forKey:nameStr];
    [aCoder encodeObject:_pic forKey:picStr];
    [aCoder encodeObject:_classifyId forKey:classifyIdStr];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.desc = [aDecoder decodeObjectForKey:descStr];
        self.name = [aDecoder decodeObjectForKey:nameStr];
        self.pic = [aDecoder decodeObjectForKey:picStr];
        self.classifyId = [aDecoder decodeObjectForKey:classifyIdStr];
    }
    return self;
}

@end
