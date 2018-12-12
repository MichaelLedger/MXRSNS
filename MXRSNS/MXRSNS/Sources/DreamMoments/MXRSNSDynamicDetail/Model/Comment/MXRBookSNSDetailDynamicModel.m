//
//  MXRBookSNSDetailDynamicModel.m
//  huashida_home
//
//  Created by shuai.wang on 16/9/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSDetailDynamicModel.h"
static NSString *iD = @"id";
static NSString *contentWord = @"contentWord";
static NSString *contentBookId = @"contentBookId";
static NSString *contentBookName = @"contentBookName";
static NSString *createTime = @"createTime";
static NSString *userId = @"userId";
static NSString *userName = @"userName";
static NSString *praiseNum = @"praiseNum";
static NSString *action = @"action";
static NSString *commentNum = @"commentNum";
static NSString *retransmissionNum = @"retransmissionNum";
static NSString *topicIds = @"topicIds";
static NSString *publisher = @"publisher";
static NSString *orderNum = @"orderNum";
static NSString *srcStatus = @"srcStatus";

@implementation MXRBookSNSDetailDynamicModel

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self= [super init])
    {
        _iD = autoInteger(dict[iD]);
        _contentWord = autoString(dict[contentWord]);
        _contentBookId = autoInteger(dict[contentBookId]);
        _contentBookName = autoString(dict[contentBookName]);
        _createTime = autoString(dict[createTime]);
        _userId = autoInteger(dict[userId]);
        _userName = autoString(dict[userName]);
        _praiseNum = autoInteger(dict[praiseNum]);
        _action = autoInteger(dict[action]);
        _commentNum = autoInteger(dict[commentNum]);
        _retransmissionNum = autoInteger(dict[retransmissionNum]);
        _topicIds = autoString(dict[topicIds]);
        _publisher = autoInteger(dict[publisher]);
        _orderNum = autoInteger(dict[orderNum]);
        if (autoInteger(dict[srcStatus]) == 0) {
            _srcStatus = OriginalCommentStateNomal;
        }else if (autoInteger(dict[srcStatus]) == 1){
            _srcStatus = OriginalCommentStateDelete;
        }else if (autoInteger(dict[srcStatus]) == 2){
            _srcStatus = OriginalCommentStateAudit;
        }else{
            _srcStatus = OriginalCommentStateNomal;
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.iD forKey:iD];
    [aCoder encodeObject:self.contentWord forKey:contentWord];
    [aCoder encodeInteger:self.contentBookId forKey:contentBookId];
    [aCoder encodeObject:self.contentBookName forKey:contentBookName];
    [aCoder encodeObject:self.createTime forKey:createTime];
    [aCoder encodeInteger:self.userId forKey:userId];
    [aCoder encodeObject:self.userName forKey:userName];
    [aCoder encodeInteger:self.praiseNum forKey:praiseNum];
    [aCoder encodeInteger:self.action forKey:action];
    [aCoder encodeInteger:self.commentNum forKey:commentNum];
    [aCoder encodeInteger:self.retransmissionNum forKey:retransmissionNum];
    [aCoder encodeObject:self.topicIds forKey:topicIds];
    [aCoder encodeInteger:self.publisher forKey:publisher];
    [aCoder encodeInteger:self.orderNum forKey:orderNum];
    [aCoder encodeInteger:self.srcStatus forKey:srcStatus];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {        
        _iD = [aDecoder decodeIntegerForKey:iD];
        _contentWord= [aDecoder decodeObjectForKey:contentWord];
        _contentBookId= [aDecoder decodeIntegerForKey:contentBookId];
        _contentBookName= [aDecoder decodeObjectForKey:contentBookName];
        _createTime= [aDecoder decodeObjectForKey:createTime];
        _userId= [aDecoder decodeIntegerForKey:userId];
        _userName= [aDecoder decodeObjectForKey:userName];
        _praiseNum= [aDecoder decodeIntegerForKey:praiseNum];
        _action= [aDecoder decodeIntegerForKey:action];
        _commentNum= [aDecoder decodeIntegerForKey:commentNum];
        _retransmissionNum= [aDecoder decodeIntegerForKey:retransmissionNum];
        _topicIds= [aDecoder decodeObjectForKey:topicIds];
        _publisher= [aDecoder decodeIntegerForKey:publisher];
        _orderNum= [aDecoder decodeIntegerForKey:orderNum];
        _srcStatus= [aDecoder decodeIntegerForKey:srcStatus];
    }
    return self;
}
@end
