//
//  MXRTopicModel.m
//  huashida_home
//
//  Created by dingyang on 16/9/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRTopicModel.h"
#import "ALLNetworkURL.h"
#import <objc/message.h>
#import "MXRSNSShareModel.h"
#import "MXRSubjectInfoModel.h"
static NSString *createTime = @"createTime";
static NSString *topicId = @"id";
static NSString *participateUserNum = @"participateUserNum";
static NSString *picUrl = @"pic";
static NSString *publishDynamicNum = @"publishDynamicNum";
static NSString *dynamicList = @"dynamics";
static NSString *list = @"list";
static NSString *topic = @"topic";
static NSString *topicDescription = @"description";
@implementation MXRTopicModel

+ (NSDictionary<NSString *,id> *)mxr_modelCustomPropertyMapper
{
    return @{@"topicId":@"id"};
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        unsigned int count=0;
        Ivar *ivar=class_copyIvarList([self class], &count);
        for (int i=0; i<count; i++) {
            Ivar iva=ivar[i];
            const char*name=ivar_getName(iva);
            NSString *strName=[NSString stringWithUTF8String:name];
            id value=[aDecoder decodeObjectForKey:strName];
            if (value) {
                [self setValue:value forKey:strName];
            }else{
//                DLOG(@"key value not exist,key=%@",strName);
            }
        }
        free(ivar);
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count=0;
    Ivar *ivar=class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        Ivar iva=ivar[i];
        const char *name=ivar_getName(iva);
        NSString*strName=[NSString stringWithUTF8String:name];
        id value=[self valueForKey:strName];
        [aCoder encodeObject:value forKey:strName];
    }
    free(ivar);
}
#pragma mark initWithDictionary
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _topicType = TopicHandleTypeNormal;
        NSDictionary *topicDict = dict[topic];
        if (!topicDict) {
            topicDict = dict;
        }
        if (topicDict) {
            _createTime = autoString(topicDict[createTime]);
            _topicId = autoInteger(topicDict[topicId]);
            _name = autoString(topicDict[name]);
            _participateUserNum = autoString(topicDict[participateUserNum]);
            _picUrl = autoString(topicDict[picUrl]);
            _publishDynamicNum = autoString(topicDict[publishDynamicNum]);
            _topicDescription = autoString(topicDict[topicDescription]);
        }
        NSDictionary *dynamicsDict = dict[dynamicList];
        if (!_dynamicList) {
            _dynamicList = [NSMutableArray array];
        }
        [_dynamicList removeAllObjects];
        if (dynamicsDict) {
            NSArray *listArray = dynamicsDict[list];
            for (int i = 0; i < listArray.count; i ++) {
                MXRSNSShareModel *model = [[MXRSNSShareModel alloc] createWithDictionary:listArray[i]];
                [_dynamicList addObject:model];
            }
        }
        if ( autoInteger(topicDict[@"type"]) == 1) {
            _relevantType = TopicRelevantBook;
            _bookInfo = [[BookInfoForShelf alloc]initWithNewDict:topicDict[@"bookSmall"]];
        }else if (autoInteger(topicDict[@"type"]) == 2){
            _relevantType = TopicRelevantZone;
            _zoneModel = [[MXRSubjectInfoModel alloc]initWithDict:topicDict[@"recommendZoneSmall"]];
        }else{
            _relevantType = TopicRelevantNone;
        }
        
    }
    return self;
}
-(instancetype)initMoreSystemItem{

    self = [super init];
    if (self) {
        _name = MXRLocalizedString(@"MXRSearchTopicViewController_MoreTopic", @"更多话题");
        _participateUserNum = @"";
        _topicType = TopicHandleTypeMoreTopic;
    }
    return self;
}

+ (NSDictionary<NSString *,id> *)mxr_modelContainerPropertyGenericClass
{
    return @{@"bookSmall":[BookInfoForShelf class],
             @"recommendZoneSmall":[MXRSubjectInfoModel class]};
}

@end
