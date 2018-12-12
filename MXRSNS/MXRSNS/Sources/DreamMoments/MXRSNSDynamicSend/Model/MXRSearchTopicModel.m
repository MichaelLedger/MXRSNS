//
//  MXRSearchTopicModel.m
//  huashida_home
//
//  Created by lj on 16/9/22.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSearchTopicModel.h"
#define name @"name"
#define pic @"pic"
#define participateUserNum @"participateUserNum"
#define publishDynamicNum @"publishDynamicNum"
#define createTime @"createTime"
#define searchPic @"searchPic"
@implementation MXRSearchTopicModel



//初始化 模型
-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        _topicId = [autoNumber(dict[@"id"]) integerValue];
        _name = autoString(dict[name]);
        _pic = autoString(dict[pic]);
        _participateUserNum = autoInteger(dict[participateUserNum]);
        _publishDynamicNum = autoInteger(dict[publishDynamicNum]);
        _createTime = autoString(dict[createTime]);
        _searchPic = autoString(dict[searchPic]);
        _isNewTopic = NO;
    }
    return self;
}

//当判断出 一个新话题的 时候 需要创建这个话题
-(instancetype)initNewWithTopicName:(NSString*)topicName
{
    self = [super init];
    if (self) {
        _topicId = -1;
        _name = [NSString stringWithFormat:@"#%@#",topicName];
        _isNewTopic = YES;
    }
    return self;
}


//调用setValue forkey 防止key值不存在 会发生崩溃
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
@end
