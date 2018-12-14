//
//  MXRBookSNSDetailModel.h
//  huashida_home
//
//  Created by shuai.wang on 16/9/23.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRBookSNSDetailDynamicModel.h"
#import "MXRBookSNSDetailCommentsModel.h"
@class MXRBookSNSDetailDynamicModel;
@class MXRBookSNSDetailCommentsModel;
@class MXRSNSShareModel;
@interface MXRBookSNSDetailModel : NSObject<NSCoding>

@property (strong,nonatomic,readonly) MXRSNSShareModel *dynamicModel;
@property (strong,nonatomic,readonly) MXRBookSNSDetailCommentsModel *commentsModel;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
