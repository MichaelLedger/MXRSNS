//
//  MXRTopicsController.h
//  huashida_home
//
//  Created by dingyang on 16/9/26.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRTopicsController : NSObject
+(instancetype)getInstance;
/*根据topicId,timestamp获取之前话题动态,uid即userId,可以不传*/
-(void)getPreviousDynamicForTopicByUid:(NSString *)auid topicId:(NSString *)atopicId timeStamp:(NSString *)atimeStamp orderNum:(NSString *)aorderNum andCallBack:(void(^)(BOOL isSuccess, id sender))callback;
/*根据topicId,timestamp获取之后话题动态,uid即userId,可以不传*/
-(void)getNextDynamicForTopicByUid:(NSString *)auid topicId:(NSString *)atopicId timeStamp:(NSString *)atimeStamp orderNum:(NSString *)aorderNum andCallBack:(void(^)(BOOL isSuccess, id sender))callback;
/*根据topicId获取话题动态*/
-(void)getDynamicForTopicByUid:(NSString *)auid topicId:(NSString *)atopicId pageIndex:(NSInteger)apage rows:(NSInteger)arows andCallBack:(void(^)(BOOL isSuccess, id sender))callback;
/*根据name获取话题动态*/
-(void)getDynamicForTopicByUid:(NSString *)auid name:(NSString *)aname pageIndex:(NSInteger)apage rows:(NSInteger)arows andCallBack:(void(^)(BOOL isSuccess, id sender))callback;
/*获取话题icon*/
-(void)collectTopicShareWithTopicId:(NSString *)topicId andShareWay:(NSInteger )shareWay andShareUserId:(NSString *)shareUserId andCallBack:(void(^)(BOOL isSuccess))callback;
@end
