//
//  MXRBookSNSMomentStatusNoUploadManager.m
//  huashida_home
//
//  Created by gxd on 16/9/21.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSMomentStatusNoUploadManager.h"
#import "MXRBookSNSModelProxy.h"
#import "MXRBookSNSMomentStatusNoUploadModel.h"
#import "MXRBookSNSController.h"
#import "MXRBookSNSDetailController.h"
#import "MXRBookSNSSendDetailManager.h"
@interface MXRBookSNSMomentStatusNoUploadManager()
@property (nonatomic, strong) MXRBookSNSMomentStatusNoUploadModel * tempUploadModel;
@end

@implementation MXRBookSNSMomentStatusNoUploadManager
+(instancetype)getInstance{
    
    static dispatch_once_t onceToken;
    static MXRBookSNSMomentStatusNoUploadManager * manager;
    dispatch_once(&onceToken, ^{
        manager = [[MXRBookSNSMomentStatusNoUploadManager alloc] init];
    });
    return manager;
}

- (void)saveTempNeedUploadModel:(MXRBookSNSMomentStatusNoUploadModel *)model{

    self.tempUploadModel = model;
}

- (MXRBookSNSMomentStatusNoUploadModel *)getTempNeedUploadModel{

    return self.tempUploadModel;
}

- (void)clearTempNeedUploadModel{

    self.tempUploadModel = nil;
}

-(void)addLikeAndUnlikeAndDeleteAndUploadMomentDetailNoUploadModelWithUserHandleNoUploadStatusType:(MXRBookSNSUserHandleNoUploadStatusType)handleType andBookSNSMomentId:(NSString *)momentId andHandleUserId:(NSString *)handleUserID{
    
    MXRBookSNSMomentStatusNoUploadModel * model = [[MXRBookSNSMomentStatusNoUploadModel alloc] initWithUserHandleNoUploadStatusType:handleType andBookSNSMomentId:momentId andUnFocusUserId:nil andReportDetail:nil andCommentListModel:nil andHandleUserId:handleUserID];
    if (model.needUploadType == MXRBookSNSUserHandleNoUploadStatusTypeLikeBookSNSStatus || model.needUploadType == MXRBookSNSUserHandleNoUploadStatusTypeCancleLikeBookSNSStatus) {
        [[MXRBookSNSModelProxy getInstance].bookSNSdataNeedUploadArray enumerateObjectsUsingBlock:^(MXRBookSNSMomentStatusNoUploadModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.bookSNSMomentId isEqualToString:model.bookSNSMomentId]) {
                if (model.needUploadType == MXRBookSNSUserHandleNoUploadStatusTypeLikeBookSNSStatus || model.needUploadType == MXRBookSNSUserHandleNoUploadStatusTypeCancleLikeBookSNSStatus) {
                [[MXRBookSNSModelProxy getInstance].bookSNSdataNeedUploadArray removeObject:obj];
                }
            }
        }];
    }else if(model.needUploadType == MXRBookSNSUserHandleNoUploadStatusTypeDelete){
        MXRSNSShareModel * shareModel = [[MXRBookSNSModelProxy getInstance] getSNSShareModelWithId:model.bookSNSMomentId];
        if (shareModel.momentStatusType == MXRBookSNSMomentStatusTypeOnLocal) {
            return;
        }
    }
      [[MXRBookSNSModelProxy getInstance].bookSNSdataNeedUploadArray addObject:model];
}
-(void)addNoInterestNoUploadModelWithUserHandleNoUploadStatusType:(MXRBookSNSUserHandleNoUploadStatusType)handleType andBookSNSMomentId:(NSString *)momentId andUnFocusUserId:(NSString *)userId andHandleUserId:(NSString *)handleUserID{
    
    MXRBookSNSMomentStatusNoUploadModel * model = [[MXRBookSNSMomentStatusNoUploadModel alloc] initWithUserHandleNoUploadStatusType:handleType andBookSNSMomentId:momentId andUnFocusUserId:userId andReportDetail:nil andCommentListModel:nil andHandleUserId:handleUserID];
    [[MXRBookSNSModelProxy getInstance].bookSNSdataNeedUploadArray addObject:model];
}
-(void)addReportNoUploadModelWithUserHandleNoUploadStatusType:(MXRBookSNSUserHandleNoUploadStatusType)handleType andBookSNSMomentId:(NSString *)momentId andReportDetail:(NSString *)reportDetail andHandleUserId:(NSString *)handleUserID{
    
    MXRBookSNSMomentStatusNoUploadModel * model = [[MXRBookSNSMomentStatusNoUploadModel alloc] initWithUserHandleNoUploadStatusType:handleType andBookSNSMomentId:momentId andUnFocusUserId:nil andReportDetail:reportDetail andCommentListModel:nil andHandleUserId:handleUserID];
    [[MXRBookSNSModelProxy getInstance].bookSNSdataNeedUploadArray addObject:model];
}
-(void)addCommentNoUploadModelWithUserHandleNoUploadStatusType:(MXRBookSNSUserHandleNoUploadStatusType)handleType andBookSNSComment:(MXRBookSNSDetailCommentListModel *)listModel andHandleUserId:(NSString *)handleUserID{
    
    MXRBookSNSMomentStatusNoUploadModel * model = [[MXRBookSNSMomentStatusNoUploadModel alloc] initWithUserHandleNoUploadStatusType:handleType andBookSNSMomentId:nil andUnFocusUserId:nil andReportDetail:nil andCommentListModel:listModel andHandleUserId:handleUserID];
    [[MXRBookSNSModelProxy getInstance].bookSNSdataNeedUploadArray addObject:model];
    
    
    [[MXRBookSNSModelProxy getInstance].bookSNSdataNeedUploadArray enumerateObjectsUsingBlock:^(MXRBookSNSMomentStatusNoUploadModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.needUploadType == MXRBookSNSUserHandleNoUploadStatusTypeComment && model.commentListModel.modelFuncType == ListModelFuncOfDeleteComment) {
            if (obj.commentListModel.modelFuncType == ListModelFuncOfCreateComment || obj.commentListModel.modelFuncType == ListModelFuncOfReplyComment) {
                if (obj.commentListModel.iD == model.commentListModel.iD) {
                    [[MXRBookSNSModelProxy getInstance].bookSNSdataNeedUploadArray removeObject:obj];
                }
            }
        }
    }];

    
}
#pragma mark - Public Methods
-(void)checkNeedUploadUserHandle{
    
    if ([MXRBookSNSModelProxy getInstance].bookSNSdataNeedUploadArray.count > 0) {
        NSArray * tempArr = [NSArray arrayWithArray:[MXRBookSNSModelProxy getInstance].bookSNSdataNeedUploadArray];
        [tempArr enumerateObjectsUsingBlock:^(MXRBookSNSMomentStatusNoUploadModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self uploadSNSModel:obj];
        }];
        tempArr = nil;
    }
}
#pragma mark - Private Methods
-(void)uploadSNSModel:(MXRBookSNSMomentStatusNoUploadModel *)model{
    
    if (model.uploadStatusType == MXRBookSNSUploadStatusTypeUploading) {
        return;
    }
    [model beginUpload];
    
    switch (model.needUploadType) {
        case MXRBookSNSUserHandleNoUploadStatusTypeSendStatusDetail:
            [self uploadSNSMomentDetail:model];
            break;
        case MXRBookSNSUserHandleNoUploadStatusTypeLikeBookSNSStatus:
            [self uploadSNSMomentLikeInfo:model];
            break;
        case MXRBookSNSUserHandleNoUploadStatusTypeCancleLikeBookSNSStatus:
            [self uploadSNSMomentCancleLikeInfo:model];
            break;
        case MXRBookSNSUserHandleNoUploadStatusTypeReport:
            [self uploadSNSMomentReport:model];
            break;
        case MXRBookSNSUserHandleNoUploadStatusTypeNOInterest:
            [self uploadSNSMomentNoInterestInfo:model];
            break;
        case MXRBookSNSUserHandleNoUploadStatusTypeDelete:
            [self uploadSNSMomentDeleteInfo:model];
            break;
        case MXRBookSNSUserHandleNoUploadStatusTypeComment:
            [self uploadSNSDetailCreateCommentInfo:model];
            break;
        default:
            break;
    }
}
-(void)uploadSussCallBack:(MXRBookSNSMomentStatusNoUploadModel *)model{
    
    [model sussUpload];
    [[MXRBookSNSModelProxy getInstance].bookSNSdataNeedUploadArray removeObject:model];
}
-(void)uploadSNSMomentDetail:(MXRBookSNSMomentStatusNoUploadModel *)model{

    @MXRWeakObj(self);
    MXRSNSShareModel * t_model = [[MXRBookSNSModelProxy getInstance] getSNSShareModelWithId:model.bookSNSMomentId];
    [[MXRBookSNSSendDetailManager getInstance] sendModelToSeviceAgain:t_model callBack:^(BOOL isOkay) {
        if (isOkay) {
            [selfWeak uploadSussCallBack:model];
        }else{
            [model failUpload];
        }
    }];
    
}
-(void)uploadSNSMomentLikeInfo:(MXRBookSNSMomentStatusNoUploadModel *)model{
    
    // 赞
    @MXRWeakObj(self);
    [[MXRBookSNSController getInstance] userLikeMomentWithMomentId:model.bookSNSMomentId andHandleUserId:model.handleUserID success:^(id result) {
        if ([(NSNumber *)result boolValue]) {
            [selfWeak uploadSussCallBack:model];
        }
    } failure:^(MXRServerStatus status, id result) {
        if (status == MXRServerStatusNetworkError || status == MXRServerStatusFail) {
            [model failUpload];
        }
    }];
}
-(void)uploadSNSMomentCancleLikeInfo:(MXRBookSNSMomentStatusNoUploadModel *)model{
    
    // 取消赞
    @MXRWeakObj(self);
    [[MXRBookSNSController getInstance] userCancleLikeMomentWithMomentId:model.bookSNSMomentId andHandleUserId:model.handleUserID success:^(id result) {
        if ([(NSNumber *)result boolValue]) {
            [selfWeak uploadSussCallBack:model];
        }
    } failure:^(MXRServerStatus status, id result) {
        if (status == MXRServerStatusNetworkError || status == MXRServerStatusFail) {
            [model failUpload];
        }
    }];
}
-(void)uploadSNSMomentReport:(MXRBookSNSMomentStatusNoUploadModel *)model{
    
    // 举报
    @MXRWeakObj(self);
    [[MXRBookSNSController getInstance] userReportMomentWithReportDetail:model.reportdetail andHandleUserId:model.handleUserID andMomentId:model.bookSNSMomentId success:^(id result) {
        if ([(NSNumber *)result boolValue]) {
            [selfWeak uploadSussCallBack:model];
        }
    } failure:^(MXRServerStatus status, id result) {
        if (status == MXRServerStatusNetworkError || status == MXRServerStatusFail) {
            [model failUpload];
        }
    }];
}
-(void)uploadSNSMomentNoInterestInfo:(MXRBookSNSMomentStatusNoUploadModel *)model{
    
    @MXRWeakObj(self);
    [[MXRBookSNSController getInstance] cancleFocusWithUserId:model.unFocusUserId andHandleUserId:model.handleUserID success:^(id result) {
        if ([(NSNumber *)result boolValue]) {
            [selfWeak uploadSussCallBack:model];
        }
    } failure:^(MXRServerStatus status, id result) {
        if (status == MXRServerStatusNetworkError || status == MXRServerStatusFail) {
            [model failUpload];
        }
    }];
}
-(void)uploadSNSMomentDeleteInfo:(MXRBookSNSMomentStatusNoUploadModel *)model{
    
    @MXRWeakObj(self);
    [[MXRBookSNSController getInstance] deleteMomentWithMomentId:model.bookSNSMomentId andHandleUserId:model.handleUserID success:^(id result) {
        if ([(NSNumber *)result boolValue]) {
            [selfWeak uploadSussCallBack:model];
        }
    } failure:^(MXRServerStatus status, id result) {
        if (status == MXRServerStatusNetworkError || status == MXRServerStatusFail) {
            [model failUpload];
        }
    }];
}

-(void)uploadSNSDetailCreateCommentInfo:(MXRBookSNSMomentStatusNoUploadModel *)model {
    if (model.commentListModel.modelType == ListModelOfCache) {
        switch (model.commentListModel.modelFuncType) {
            case ListModelFuncOfCreateComment:
                [self uploadBookSNSDetailInfoCreateCommentWithModel:model];
                break;
            case ListModelFuncOfReplyComment:
                [self uploadBookSNSDetailInfoReplyCommentWithModel:model];
                break;
            case ListModelFuncOfDeleteComment:
                [self uploadBookSNSDetailInfoDeleteCommentWithModel:model];
                break;
            case ListModelFuncOfAddPreaseComment:
                [self uploadBookSNSDetailInfoAddPraiseWithModel:model];
                break;
            case ListModelFuncOfCanclePreaseComment:
                [self uploadBookSNSDetailInfoCanclePraiseWithModel:model];
                break;
            case ListModelFuncOfSendReportComment:
                [self uploadBookSNSDetailInfoReportMomentWithModel:model];
                break;
            default:
                break;
        }
    }
}
/*
 *   有网络下自动上传动态详情页有关操作
 */
-(void)uploadBookSNSDetailInfoCreateCommentWithModel:(MXRBookSNSMomentStatusNoUploadModel *)model {
    
    @MXRWeakObj(self);
    [[MXRBookSNSDetailController getInstance] createNewCommentForDynamicWithDyId:[NSString stringWithFormat:@"%ld",(long)model.commentListModel.dynamicId] userId:model.handleUserID userName:[NSString stringWithFormat:@"%@",[UserInformation modelInformation].userNickName] userLogo:[NSString stringWithFormat:@"%@",[UserInformation modelInformation].userImage] content:model.commentListModel.content withCallBack:^(BOOL isOk, MXRBookSNSDetailCommentListModel *commentModel) {
        if (isOk) {
            [selfWeak uploadSussCallBack:model];
        }
        else{
            [model failUpload];
        }
    }];
}
-(void)uploadBookSNSDetailInfoReplyCommentWithModel:(MXRBookSNSMomentStatusNoUploadModel *)model {
    
    @MXRWeakObj(self);
    [[MXRBookSNSDetailController getInstance] replyCommentForDynamicWithDyId:[NSString stringWithFormat:@"%ld",(long)model.commentListModel.dynamicId] userId:model.handleUserID userName:[NSString stringWithFormat:@"%@",[UserInformation modelInformation].userNickName] userLogo:[NSString stringWithFormat:@"%@",[UserInformation modelInformation].userImage] content:model.commentListModel.content srcUserId:model.commentListModel.srcUserId srcUserName:model.commentListModel.srcUserName srcContent:@"" srcId:model.commentListModel.srcId withCallBack:^(BOOL isOk, MXRBookSNSDetailCommentListModel *commentModel) {
        if (isOk) {
            [selfWeak uploadSussCallBack:model];
        }
        else{
            [model failUpload];
        }
    }];
}

-(void)uploadBookSNSDetailInfoAddPraiseWithModel:(MXRBookSNSMomentStatusNoUploadModel *)model {
    
    @MXRWeakObj(self);
    [[MXRBookSNSDetailController getInstance] addPraiseForDynamicWithID:model.commentListModel.iD uid:[model.handleUserID integerValue] dyId:model.commentListModel.dynamicId userName:[UserInformation modelInformation].userNickName userLogo:[UserInformation modelInformation].userImage withCallBack:^(BOOL isOk) {
        if (isOk) {
            [selfWeak uploadSussCallBack:model];
        }else{
            [model failUpload];
        }
    }];
}

-(void)uploadBookSNSDetailInfoCanclePraiseWithModel:(MXRBookSNSMomentStatusNoUploadModel *)model {
    
    @MXRWeakObj(self);
    [[MXRBookSNSDetailController getInstance] canclePraiseForDynamicWithID:model.commentListModel.iD uid:[model.handleUserID integerValue] withCallBack:^(BOOL isOk) {
        if (isOk) {
            [selfWeak uploadSussCallBack:model];
        }
        else{
            [model failUpload];
        }
    }];
}

-(void)uploadBookSNSDetailInfoDeleteCommentWithModel:(MXRBookSNSMomentStatusNoUploadModel *)model {
    
    @MXRWeakObj(self);
    [[MXRBookSNSDetailController getInstance] deleteCommentWithCid:model.commentListModel.iD dynamicId:model.commentListModel.dynamicId withCallBack:^(BOOL isOk) {
        if (isOk) {
            [selfWeak uploadSussCallBack:model];
        }
        else{
            [model failUpload];
        }
    }];
}

-(void)uploadBookSNSDetailInfoReportMomentWithModel:(MXRBookSNSMomentStatusNoUploadModel *)model {
    @MXRWeakObj(self);
    [[MXRBookSNSDetailController getInstance] reportCommentWithReportId:model.commentListModel.iD reportReason:model.commentListModel.reportReason withCallBack:^(BOOL isOk) {
        if (isOk) {
            [selfWeak uploadSussCallBack:model];
        }else{
            [model failUpload];
        }
    }];
}
@end
