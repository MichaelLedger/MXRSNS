//
//  MXRBookSNSDetailCommentListModel.m
//  huashida_home
//
//  Created by shuai.wang on 16/9/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSDetailCommentListModel.h"
static NSString *reportReason = @"reportReason";
static NSString *iD = @"id";
static NSString *dynamicId = @"dynamicId";
static NSString *userId = @"userId";
static NSString *userName = @"userName";
static NSString *createTime = @"createTime";
static NSString *content = @"content";
static NSString *praiseNum = @"praiseNum";
static NSString *userLogo = @"userLogo";
static NSString *hasPraised = @"hasPraised";
static NSString *deleteFlag = @"delFlag";
static NSString *srcStatus = @"srcStatus";

static NSString *modelType = @"modelType";
static NSString *modelFuncType = @"modelFuncType";
static NSString *dataType = @"dataType";
static NSString *commentType = @"commentType";
    /*  转发  */
static NSString *srcUserId = @"srcUserId";
static NSString *srcId = @"srcId";
static NSString *srcContent = @"srcContent";
static NSString *srcUserName = @"srcUserName";

static NSString *sort = @"topSort";
static NSString *vipFlag = @"vipFlag";

@implementation MXRBookSNSDetailCommentListModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.reportReason forKey:reportReason];
    [aCoder encodeInteger:self.iD forKey:iD];
    [aCoder encodeInteger:self.dynamicId forKey:dynamicId];
    [aCoder encodeInteger:self.userId forKey:userId];
    [aCoder encodeObject:self.userName forKey:userName];
    [aCoder encodeObject:self.createTime forKey:createTime];
    [aCoder encodeObject:self.content forKey:content];
    [aCoder encodeInteger:self.praiseNum forKey:praiseNum];
    [aCoder encodeObject:self.userLogo forKey:userLogo];
    [aCoder encodeInteger:self.hasPraised forKey:hasPraised];
    [aCoder encodeInteger:self.deleteFlag forKey:deleteFlag];
    [aCoder encodeInteger:self.srcStatus forKey:srcStatus];
    [aCoder encodeInteger:self.modelType forKey:modelType];
    [aCoder encodeInteger:self.modelFuncType forKey:modelFuncType];
    [aCoder encodeInteger:self.dataType forKey:dataType];
    [aCoder encodeInteger:self.commentType forKey:commentType];
    /*  转发  */
    [aCoder encodeInteger:self.srcUserId forKey:srcUserId];
    [aCoder encodeInteger:self.srcId forKey:srcId];
    [aCoder encodeObject:self.srcContent forKey:srcContent];
    [aCoder encodeObject:self.srcUserName forKey:srcUserName];
    
    [aCoder encodeInteger:self.sort forKey:sort];   //Version 5.9.1
    [aCoder encodeBool:self.vipFlag forKey:vipFlag];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self= [super init]) {
        _reportReason = [aDecoder decodeObjectForKey:reportReason];
        _iD = [aDecoder decodeIntegerForKey:iD];
        _dynamicId = [aDecoder decodeIntegerForKey:dynamicId];
        _userId = [aDecoder decodeIntegerForKey:userId];
        _userName = [aDecoder decodeObjectForKey:userName];
        _createTime = [aDecoder decodeObjectForKey:createTime];
        _content = [aDecoder decodeObjectForKey:content];
        _praiseNum = [aDecoder decodeIntegerForKey:praiseNum];
        _userLogo = [aDecoder decodeObjectForKey:userLogo];
        _hasPraised = [aDecoder decodeIntegerForKey:hasPraised];
        _deleteFlag = [aDecoder decodeIntegerForKey:deleteFlag];
        _srcStatus = [aDecoder decodeIntegerForKey:srcStatus];
        _modelType = [aDecoder decodeIntegerForKey:modelType];
        _modelFuncType = [aDecoder decodeIntegerForKey:modelFuncType];
        _dataType = [aDecoder decodeIntegerForKey:dataType];
        _commentType = [aDecoder decodeIntegerForKey:commentType];
        /*  转发  */
        _srcUserId = [aDecoder decodeIntegerForKey:srcUserId];
        _srcId = [aDecoder decodeIntegerForKey:srcId];
        _srcContent = [aDecoder decodeObjectForKey:srcContent];
        _srcUserName = [aDecoder decodeObjectForKey:srcUserName];
        
        _sort = [aDecoder decodeIntegerForKey:sort];    //Version 5.9.1
        _vipFlag = [aDecoder decodeBoolForKey:vipFlag];
    }
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionary withModelType:(ListModelType)type  withModelFuncType:(ListModelFuncType)functype withDataType:(DataType)dataType  withCommentType:(CommentType)commentType{
    if (self = [super init]) {
        _iD = autoInteger(dictionary[iD]);
        _dynamicId = autoInteger(dictionary[dynamicId]);
        _userId = autoInteger(dictionary[userId]);
        _userName = autoString(dictionary[userName]);
        _createTime = autoString(dictionary[createTime]);
        _content =autoString(dictionary[content]);
        _praiseNum = autoInteger(dictionary[praiseNum]);
        _userLogo = autoString(dictionary[userLogo]);
        _hasPraised = autoInteger(dictionary[hasPraised]);
        _deleteFlag = autoInteger(dictionary[deleteFlag]);
        _srcStatus = autoInteger(dictionary[srcStatus]);
        _modelType = type;
        _modelFuncType = functype;
        _dataType = dataType;
        _commentType = commentType;
        /*  转发  */
        _srcUserId = autoInteger(dictionary[srcUserId]);
        _srcId = autoInteger(dictionary[srcId]);
        _srcContent = autoString(dictionary[srcContent]);
        _srcUserName = autoString(dictionary[srcUserName]);
        _reportReason = autoString(dictionary[reportReason]);
        
        _sort = autoInteger(dictionary[sort]);   //Version 5.9.1
        _vipFlag = [dictionary[vipFlag] boolValue];
    }
    return self;
}

-(NSString *)userLogo {
    return REPLACE_HTTP_TO_HTTPS(_userLogo);
}
@end
