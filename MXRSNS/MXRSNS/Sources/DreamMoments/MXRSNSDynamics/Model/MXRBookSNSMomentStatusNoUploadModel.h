//
//  MXRBookSNSMomentStatusNoUploadModel.h
//  huashida_home
//
//  Created by gxd on 16/9/21.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MXRBookSNSDetailCommentListModel;
typedef NS_ENUM(NSInteger , MXRBookSNSUserHandleNoUploadStatusType){
    MXRBookSNSUserHandleNoUploadStatusTypeSendStatusDetail,
    MXRBookSNSUserHandleNoUploadStatusTypeLikeBookSNSStatus,
    MXRBookSNSUserHandleNoUploadStatusTypeCancleLikeBookSNSStatus,
    MXRBookSNSUserHandleNoUploadStatusTypeReport,
    MXRBookSNSUserHandleNoUploadStatusTypeNOInterest,
    MXRBookSNSUserHandleNoUploadStatusTypeDelete,
    MXRBookSNSUserHandleNoUploadStatusTypeComment
};
typedef NS_ENUM(NSInteger , MXRBookSNSUploadStatusType){
    MXRBookSNSUploadStatusTypeUploading,
    MXRBookSNSUploadStatusTypeUploadFail,
    MXRBookSNSUploadStatusTypeUploadSuss,
};
@interface MXRBookSNSMomentStatusNoUploadModel : NSObject<NSCoding>
@property (copy, nonatomic,readonly) NSString * bookSNSMomentId; // 动态ID
@property (copy, nonatomic,readonly) NSString * unFocusUserId; //  取消关注的userid
@property (copy, nonatomic,readonly) NSString * reportdetail; //  举报详情
@property (strong, nonatomic) MXRBookSNSDetailCommentListModel * commentListModel;// 评论模型
@property (assign, nonatomic) MXRBookSNSUserHandleNoUploadStatusType needUploadType; // 需要上传的用户操作类型
@property (readonly, assign, nonatomic) MXRBookSNSUploadStatusType uploadStatusType; // 上传之后动态的状态
@property (readonly, copy, nonatomic) NSString * handleUserID;
-(instancetype)initWithUserHandleNoUploadStatusType:(MXRBookSNSUserHandleNoUploadStatusType )handleType andBookSNSMomentId:(NSString *)momentId andUnFocusUserId:(NSString *)userId andReportDetail:(NSString *)reportDetail andCommentListModel:(MXRBookSNSDetailCommentListModel *)listModel andHandleUserId:(NSString *)handleUserID;
-(void)beginUpload;
-(void)sussUpload;
-(void)failUpload;
@end
