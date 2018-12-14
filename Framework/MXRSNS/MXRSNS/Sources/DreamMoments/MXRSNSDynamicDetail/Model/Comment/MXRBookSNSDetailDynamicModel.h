//
//  MXRBookSNSDetailDynamicModel.h
//  huashida_home
//
//  Created by shuai.wang on 16/9/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, OriginalCommentState) {
    OriginalCommentStateNomal = 0,
    OriginalCommentStateDelete,
    OriginalCommentStateAudit
    
};
@interface MXRBookSNSDetailDynamicModel : NSObject<NSCoding>

@property (assign,nonatomic,readonly) NSInteger iD;
@property (copy,nonatomic,readonly) NSString *contentWord;
@property (assign,nonatomic,readonly) NSInteger contentBookId;
@property (copy,nonatomic,readonly) NSString *contentBookName;
@property (copy,nonatomic,readonly) NSString *createTime;
@property (assign,nonatomic,readonly) NSInteger userId;
@property (copy,nonatomic,readonly) NSString *userName;
@property (assign,nonatomic,readonly) NSInteger praiseNum;
@property (assign,nonatomic,readonly) NSInteger action;
@property (assign,nonatomic,readonly) NSInteger commentNum;
@property (assign,nonatomic,readonly) NSInteger retransmissionNum;
@property (copy,nonatomic,readonly) NSString *topicIds;
@property (assign,nonatomic,readonly) NSInteger publisher;
@property (assign,nonatomic,readonly) NSInteger orderNum;
@property (assign,nonatomic,readonly) OriginalCommentState srcStatus;


-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
