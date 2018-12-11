//
//  MXRBookSNSMomentStatusNoUploadManager.h
//  huashida_home
//
//  Created by gxd on 16/9/21.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRBookSNSMomentStatusNoUploadModel.h"
#import "MXRBookSNSDetailCommentListModel.h"
@interface MXRBookSNSMomentStatusNoUploadManager : NSObject
+(instancetype)getInstance;
-(void)checkNeedUploadUserHandle;
// 点赞，取消赞，删除，上传动态
-(void)addLikeAndUnlikeAndDeleteAndUploadMomentDetailNoUploadModelWithUserHandleNoUploadStatusType:(MXRBookSNSUserHandleNoUploadStatusType )handleType andBookSNSMomentId:(NSString *)momentId andHandleUserId:(NSString *)handleUserID;
// 取消关注
-(void)addNoInterestNoUploadModelWithUserHandleNoUploadStatusType:(MXRBookSNSUserHandleNoUploadStatusType )handleType andBookSNSMomentId:(NSString *)momentId andUnFocusUserId:(NSString *)userId andHandleUserId:(NSString *)handleUserID;
// 举报
-(void)addReportNoUploadModelWithUserHandleNoUploadStatusType:(MXRBookSNSUserHandleNoUploadStatusType )handleType andBookSNSMomentId:(NSString *)momentId andReportDetail:(NSString *)reportDetail andHandleUserId:(NSString *)handleUserID;
// 动态详情评论
-(void)addCommentNoUploadModelWithUserHandleNoUploadStatusType:(MXRBookSNSUserHandleNoUploadStatusType)handleType andBookSNSComment:(MXRBookSNSDetailCommentListModel *)listModel andHandleUserId:(NSString *)handleUserID;

- (void)saveTempNeedUploadModel:(MXRBookSNSMomentStatusNoUploadModel *)model;

- (MXRBookSNSMomentStatusNoUploadModel *)getTempNeedUploadModel;

- (void)clearTempNeedUploadModel;
@end
