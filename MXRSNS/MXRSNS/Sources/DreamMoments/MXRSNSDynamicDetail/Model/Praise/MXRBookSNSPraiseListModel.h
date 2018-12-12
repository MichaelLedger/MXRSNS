//
//  MXRBookSNSPraiseListModel.h
//  huashida_home
//
//  Created by shuai.wang on 16/9/29.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRBookSNSPraiseListModel : NSObject

@property (nonatomic,copy,readonly)   NSString  *createTime;
@property (nonatomic,assign,readonly) NSInteger dynamicId;
@property (nonatomic,assign,readonly) NSInteger iD;
@property (nonatomic,assign,readonly) NSInteger userId;
@property (nonatomic,copy)   NSString  *userLogo;
@property (nonatomic,copy,readonly)   NSString  *userName;
@property (nonatomic, assign) BOOL vipFlag;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
