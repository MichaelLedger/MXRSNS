//
//  MXRBookSNSDetailController.h
//  huashida_home
//
//  Created by shuai.wang on 16/9/26.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRNetworkResponse.h"
#import "MXRBookSNSDetailModel.h"
#import "MXRBookSNSDetailCommentListModel.h"
#import "MXRBookSNSPraiseModel.h"
@interface MXRBookSNSDetailController : NSObject
+(instancetype)getInstance;

/*
 *    梦想圈动态详情评论列表数据
 */
-(void)requestBookSNSDetailDataWithPage:(NSInteger)page dynamicId:(NSString *)dynamicId uid:(NSString *)uid withCallBack:(void(^)(BOOL isOk ,MXRBookSNSDetailModel *bookSNSDetailModel))callBack;

/*
 *    获取动态点赞用户列表
 */
-(void)requestBookSNSPraiseListWithDynamicId:(NSString *)dynamicId uid:(NSString *)uid page:(NSInteger)page WithCallBack:(void(^)(BOOL isOk,MXRServerStatus status,MXRBookSNSPraiseModel *model))callBack;

/*
 *    发布评论
 */
-(void)createNewCommentForDynamicWithDyId:(NSString *)dyId userId:(NSString *)userId userName:(NSString *)userName userLogo:(NSString *)userLogo content:(NSString *)content withCallBack:(void(^)(BOOL isOk, MXRBookSNSDetailCommentListModel *model))callBack;

/*
 *    回复评论
 */
-(void)replyCommentForDynamicWithDyId:(NSString *)dyId userId:(NSString *)userId userName:(NSString *)userName userLogo:(NSString *)userLogo content:(NSString *)content srcUserId:(NSInteger)srcUserId srcUserName:(NSString *)srcUserName srcContent:(NSString *)srcContent srcId:(NSInteger)srcId withCallBack:(void(^)(BOOL isOk, MXRBookSNSDetailCommentListModel *model))callBack;

/*
 *    动态详情页对评论  点赞
 */
-(void)addPraiseForDynamicWithID:(NSInteger)iD uid:(NSInteger)uid dyId:(NSInteger)dyId userName:(NSString *)userName userLogo:(NSString *)userLogo withCallBack:(void(^)(BOOL isOk))callBack;

/*
 *    动态详情页对评论   取消赞
 */
-(void)canclePraiseForDynamicWithID:(NSInteger)iD uid:(NSInteger)uid withCallBack:(void(^)(BOOL isOk))callBack;

/*
 *    动态详情页对评论   删除
 */
-(void)deleteCommentWithCid:(NSInteger)cid dynamicId:(NSInteger)dynamicId withCallBack:(void(^)(BOOL isOk))callBack;

/*
 *    动态详情页对评论   举报
 */
-(void)reportCommentWithReportId:(NSInteger)reportId reportReason:(NSString *)reportReason withCallBack:(void(^)(BOOL isOk))callBack;
@end
