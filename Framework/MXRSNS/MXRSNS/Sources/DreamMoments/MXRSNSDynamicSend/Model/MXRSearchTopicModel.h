//
//  MXRSearchTopicModel.h
//  huashida_home
//
//  Created by lj on 16/9/22.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRSearchTopicModel : NSObject
@property (copy, nonatomic, readonly) NSString *searchPic;            //搜索话题的图片地址
@property (assign, nonatomic, readonly) NSInteger topicId;    //话题Id
@property (copy, nonatomic, readonly) NSString *name;         //话题名称
@property (copy, nonatomic, readonly) NSString *pic;            //图片地址
@property (assign, nonatomic, readonly) NSInteger participateUserNum; //参与人数
@property (assign, nonatomic, readonly) NSInteger publishDynamicNum; //发表动态数
@property (copy, nonatomic, readonly) NSString *createTime;   //创建时间
@property (assign, nonatomic, readonly) BOOL isNewTopic;       //是否是新话题
//初始化 模型  将网络获取的信息转换成 模型
-(instancetype)initWithDict:(NSDictionary*)dict;
//当判断出 一个新话题的 时候 需要创建这个话题
-(instancetype)initNewWithTopicName:(NSString*)topicName;
@end
