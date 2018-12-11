//
//  MXRBookSNSDetailCommentListModel.h
//  huashida_home
//
//  Created by shuai.wang on 16/9/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum ListModelType{
    ListModelOfUpload = 0,
    ListModelOfCache
}ListModelType;


typedef enum ListModelFuncType{
    ListModelFuncOfDefault = 0,
    ListModelFuncOfCreateComment,
    ListModelFuncOfReplyComment,
    ListModelFuncOfDeleteComment,
    ListModelFuncOfAddPreaseComment,
    ListModelFuncOfCanclePreaseComment,
    ListModelFuncOfSendComment,
    ListModelFuncOfSendReplyComment,
    ListModelFuncOfSendReportComment
}ListModelFuncType;

typedef enum DataType{
    defaultDataType = 0,
    cacheDataType
}DataType;

typedef enum CommentType{
    defaultCommentType = 0,
    noNetWorkCreateComment
}CommentType;

@interface MXRBookSNSDetailCommentListModel : NSObject<NSCoding>
@property (copy,nonatomic,readonly) NSString  *reportReason;
@property (assign,nonatomic,readonly) NSInteger iD;
@property (assign,nonatomic,readonly) NSInteger dynamicId;
@property (assign,nonatomic,readonly) NSInteger userId;
@property (copy,nonatomic,readonly) NSString  *userName;
@property (copy,nonatomic,readonly) NSString  *createTime;
@property (copy,nonatomic,readonly) NSString  *content;
@property (assign,nonatomic,readonly) NSInteger praiseNum;
@property (copy,nonatomic) NSString  *userLogo;
@property (assign,nonatomic,readonly) NSInteger hasPraised;
@property (copy,nonatomic,readonly) NSString  *srcContent;
@property (assign,nonatomic,readonly) NSInteger srcId;
@property (assign,nonatomic,readonly) NSInteger srcUserId;
@property (copy,nonatomic,readonly) NSString  *srcUserName;
@property (assign,nonatomic,readonly) NSInteger deleteFlag;
@property (assign,nonatomic,readonly) NSInteger srcStatus;
@property (assign,nonatomic,readonly) ListModelType modelType;
@property (assign,nonatomic,readonly) ListModelFuncType modelFuncType;
@property (assign,nonatomic,readonly) CommentType commentType;
@property (assign,nonatomic,readonly) DataType dataType;
//V5.9.1
@property (nonatomic, assign) NSInteger sort;//排序（为0则不为置顶）
//V5.13.0 M by liulong
@property (nonatomic, assign) BOOL vipFlag;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary withModelType:(ListModelType)type  withModelFuncType:(ListModelFuncType)functype withDataType:(DataType)dataType  withCommentType:(CommentType)commentType;
@end
