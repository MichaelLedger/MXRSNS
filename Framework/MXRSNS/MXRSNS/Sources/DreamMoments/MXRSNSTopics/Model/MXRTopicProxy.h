//
//  MXRTopicProxy.h
//  huashida_home
//
//  Created by dingyang on 16/9/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRTopicModel.h"
@interface MXRTopicProxy : NSObject
@property (strong, nonatomic) MXRTopicModel *lastModel;
@property (strong, nonatomic) MXRTopicModel *currentModel;
/*备用数组，为以后扩展功能服务*/
@property (strong, nonatomic) NSMutableArray <MXRTopicModel *> *modelList;
+(instancetype)getInstence;
-(void)clearCurrentModel;
@end
