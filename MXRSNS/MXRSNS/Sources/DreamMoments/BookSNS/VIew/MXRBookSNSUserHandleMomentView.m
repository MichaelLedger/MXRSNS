//
//  MXRBookSNSUserHandleMomentView.m
//  huashida_home
//
//  Created by gxd on 16/9/23.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSUserHandleMomentView.h"
#import "MXRBookSNSController.h"
#import "MXRCopySysytemActionSheet.h"
#import "MXRBookSNSMomentStatusNoUploadManager.h"
#import "AppDelegate.h"
#import "LKDBHelper.h"
#import "MXRSNSBlackListModel.h"

#define ACancelButtonTitle MXRLocalizedString(@"MXRBookSNSUserHandleMomentView_cancle", "取消")
#define AReportButtonTitle MXRLocalizedString(@"MXRBookSNSUserHandleMomentView_report", "举报")
#define ADeletButtonTitle MXRLocalizedString(@"MXRBookSNSUserHandleMomentView_delete", "删除")
#define AUninterestredButtonTitle MXRLocalizedString(@"MXRBookSNSUserHandleMomentView_NoInterest", "不感兴趣")
@interface MXRBookSNSUserHandleMomentView()<UIActionSheetDelegate,MXRCopySysytemActionSheetDelegate>
@property (assign, nonatomic) BOOL isSystemMoment;
@property (assign, nonatomic) MXRBookSNSBelongViewtype belongViewtype;
@property (copy, nonatomic) NSString * momentId;
@property (copy, nonatomic) NSString * unFocusUserId;
@property (nonatomic, strong) MXRCopySysytemActionSheet *reportSheetNew;
@property (strong, nonatomic) NSArray * reportArray;
@property (strong, nonatomic) NSMutableArray * actionSheetTitleArray;
@property (strong, nonatomic) MXRCopySysytemActionSheet * actionSheet;
@end
@implementation MXRBookSNSUserHandleMomentView
+(instancetype) getInstance{
    MXRBookSNSUserHandleMomentView *instance;
    instance = [[MXRBookSNSUserHandleMomentView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return instance;
}
-(void)showWithIsXiaomengMoment:(BOOL)isSystemMoment momentID:(NSString *)momentId andUnFocusUserId:(NSString *)userId andMomentBelongViewtype:(MXRBookSNSBelongViewtype)belongViewtype{
    //在话题页中，针对其他用户的弹窗调整为“举报/取消”，针对自己的弹窗为““删除/取消”,社区首页中，针对自己的动态，弹窗文案为“删除/取消”，针对其他用户的弹窗文案为“删除/不感兴趣/举报/取消”
    self.isSystemMoment = isSystemMoment;
    self.momentId = momentId;
    self.unFocusUserId = userId;
    self.belongViewtype = belongViewtype;
    [self.actionSheetTitleArray removeAllObjects];
    self.frame = [UIScreen mainScreen].bounds;
    if (belongViewtype == MXRBookSNSBelongViewtypeTopicView) {
        if (isSystemMoment) {
//            [self.actionSheet addButtonWithTitle:AReportButtonTitle];
            [self.actionSheetTitleArray addObject:AReportButtonTitle];
        }else{
//            [self.actionSheet addButtonWithTitle:ADeletButtonTitle];
             [self.actionSheetTitleArray addObject:ADeletButtonTitle];
        }
    }else{
        if (isSystemMoment) {
            [self.actionSheetTitleArray addObject:ADeletButtonTitle];
//            [self.actionSheetTitleArray addObject:AUninterestredButtonTitle];//V5.8.8移除
            [self.actionSheetTitleArray addObject:AReportButtonTitle];
//            [self.actionSheet addButtonWithTitle:ADeletButtonTitle];
//            [self.actionSheet addButtonWithTitle:AUninterestredButtonTitle];
//            [self.actionSheet addButtonWithTitle:AReportButtonTitle];
        }else{
             [self.actionSheetTitleArray addObject:ADeletButtonTitle];
//            [self.actionSheet addButtonWithTitle:ADeletButtonTitle];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        if (!window)
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [window addSubview:self];
        [self.actionSheet showOnView:self];
    });
}
-(void)dealloc{

    DLOG_METHOD;
}
#pragma mark - Private 
-(void)reportMomentWithReportContent:(NSString *)report{

    NSNumber * numberMomentBelongType;
    switch (self.belongViewtype) {
        case MXRBookSNSBelongViewtypeBookSNSView:
            numberMomentBelongType = [NSNumber numberWithInteger:1];
            break;
        case MXRBookSNSBelongViewtypeTopicView:
            numberMomentBelongType = [NSNumber numberWithInteger:2];
            break;
        case MXRBookSNSBelongBelongViewtypeMyBookSNSView:
            numberMomentBelongType = [NSNumber numberWithInteger:3];
            break;
        default:
            break;
    }
    
    MXRSNSBlackListModel *blackListModel = [[MXRSNSBlackListModel alloc] init];
    blackListModel.momentID = self.momentId;
    blackListModel.userID = [[UserInformation modelInformation].userID integerValue];
    [[MXRBookSNSController getInstance] addSNSBlackListModel:blackListModel];
    
    // UserHandleMomentType @3 表示举报操作
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:self.momentId ,@"UserHandleMomentID",@3,@"UserHandleMomentType",numberMomentBelongType, @"UserHandleMomentBelongViweType",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_UserHandleMoment object:dict];
    @MXRWeakObj(self);
    [[MXRBookSNSController getInstance] userReportMomentWithReportDetail:report andHandleUserId:[UserInformation modelInformation].userID andMomentId:self.momentId success:^(id result) {
        [MXRConstant showAlert:MXRLocalizedString(@"MXRBookSNSUserHandleMomentReportSuss", @"您的举报已提交，我们会尽快处理。") andShowTime:1.5f];
    }failure:^(MXRServerStatus status, id result) {
        if (status == MXRServerStatusNetworkError || status == MXRServerStatusFail) {
//            [MXRConstant showAlert:MXRLocalizedString(@"MXRBookSNSUserHandleMomentReportFail", @"网络异常，举报失败。") andShowTime:1.5f];
            
            [[MXRBookSNSMomentStatusNoUploadManager getInstance] addReportNoUploadModelWithUserHandleNoUploadStatusType:MXRBookSNSUserHandleNoUploadStatusTypeReport andBookSNSMomentId:selfWeak.momentId andReportDetail:report andHandleUserId:[UserInformation modelInformation].userID];
        }
    }];
}
-(void)deleteMoment{
    
//    @MXRWeakObj(self);
    NSNumber * numberMomentBelongType;
    switch (self.belongViewtype) {
        case MXRBookSNSBelongViewtypeBookSNSView:
            numberMomentBelongType = [NSNumber numberWithInteger:1];
            break;
        case MXRBookSNSBelongViewtypeTopicView:
            numberMomentBelongType = [NSNumber numberWithInteger:2];
            break;
        case MXRBookSNSBelongBelongViewtypeMyBookSNSView:
            numberMomentBelongType = [NSNumber numberWithInteger:3];
            break;
        default:
            break;
    }
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:self.momentId ,@"UserHandleMomentID",@1,@"UserHandleMomentType",numberMomentBelongType, @"UserHandleMomentBelongViweType",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_UserHandleMoment object:dict];
    
    MXRSNSBlackListModel *blackListModel = [[MXRSNSBlackListModel alloc] init];
    blackListModel.momentID = self.momentId;
    blackListModel.userID = [[UserInformation modelInformation].userID integerValue];
    [[MXRBookSNSController getInstance] addSNSBlackListModel:blackListModel];
    
    if ([[UserInformation modelInformation].userID integerValue] == [self.unFocusUserId integerValue]) {//个人动态才调用删除接口
        MXRBookSNSMomentStatusNoUploadModel * model = [[MXRBookSNSMomentStatusNoUploadModel alloc] initWithUserHandleNoUploadStatusType:MXRBookSNSUserHandleNoUploadStatusTypeDelete andBookSNSMomentId:self.momentId andUnFocusUserId:nil andReportDetail:nil andCommentListModel:nil andHandleUserId:[UserInformation modelInformation].userID];
        
        [[MXRBookSNSMomentStatusNoUploadManager getInstance] saveTempNeedUploadModel:model];
        
        [[MXRBookSNSController getInstance] deleteMomentWithMomentId:self.momentId andHandleUserId:[UserInformation modelInformation].userID success:^(id result) {
            if ([(NSNumber *)result boolValue]) {
            }
        } failure:^(MXRServerStatus status, id result) {
            if (status == MXRServerStatusNetworkError || status == MXRServerStatusFail) {
                MXRBookSNSMomentStatusNoUploadModel * model = [[MXRBookSNSMomentStatusNoUploadManager getInstance] getTempNeedUploadModel];
                
                [[MXRBookSNSMomentStatusNoUploadManager getInstance] addLikeAndUnlikeAndDeleteAndUploadMomentDetailNoUploadModelWithUserHandleNoUploadStatusType:MXRBookSNSUserHandleNoUploadStatusTypeDelete andBookSNSMomentId:model.bookSNSMomentId andHandleUserId:model.handleUserID];
                [[MXRBookSNSMomentStatusNoUploadManager getInstance] clearTempNeedUploadModel];
                
            }
        }];
    }
}
-(void)uninterestred{
    
    @MXRWeakObj(self);
    NSNumber * numberMomentBelongType;
    switch (self.belongViewtype) {
        case MXRBookSNSBelongViewtypeBookSNSView:
            numberMomentBelongType = [NSNumber numberWithInteger:1];
            break;
        case MXRBookSNSBelongViewtypeTopicView:
            numberMomentBelongType = [NSNumber numberWithInteger:2];
            break;
        case MXRBookSNSBelongBelongViewtypeMyBookSNSView:
            numberMomentBelongType = [NSNumber numberWithInteger:3];
            break;
        default:
            break;
    }
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:self.unFocusUserId ,@"UserHandleMomentID",@2,@"UserHandleMomentType",numberMomentBelongType, @"UserHandleMomentBelongViweType",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_UserHandleMoment object:dict];
    [[MXRBookSNSController getInstance] cancleFocusWithUserId:self.unFocusUserId andHandleUserId:[UserInformation modelInformation].userID success:^(id result) {
        if ([(NSNumber *)result boolValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_UpdateALLMoment object:nil];
        }
    } failure:^(MXRServerStatus status, id result) {
        if (status == MXRServerStatusNetworkError || status == MXRServerStatusFail) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_UpdateALLMoment object:nil];
            [[MXRBookSNSMomentStatusNoUploadManager getInstance] addNoInterestNoUploadModelWithUserHandleNoUploadStatusType:MXRBookSNSUserHandleNoUploadStatusTypeNOInterest andBookSNSMomentId:selfWeak.momentId andUnFocusUserId:selfWeak.unFocusUserId andHandleUserId:[UserInformation modelInformation].userID];
        }
    }];
}
#pragma mark -UIActionSheetDelegate
-(void)actionSheetNew:(MXRCopySysytemActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex andClickedButtonTitle:(NSString *)buttonTitle{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (actionSheet.tag == 1) {
            if (buttonIndex<self.actionSheetTitleArray.count) {
                if ([buttonTitle isEqualToString:AReportButtonTitle]) {
                    //举报按钮
                    [self.actionSheet hiddenSelfNoAnimation];
                    self.actionSheet = nil;
                    [self.reportSheetNew showOnView:self];
                }else if ([buttonTitle isEqualToString:ADeletButtonTitle]){
                    //删除按钮
                    [self deleteMoment];
                    [self removeFromSuperview];
                }else if ([buttonTitle isEqualToString:AUninterestredButtonTitle]){
                    //不感兴趣按钮
                    [self uninterestred];
                    [self removeFromSuperview];
                }else{
                    //取消按钮
                    [self removeFromSuperview];
                }
            }else{
                [self removeFromSuperview];
            }
        }else if (actionSheet.tag == 2){
            if (buttonIndex<self.reportArray.count) {
                [self reportMomentWithReportContent:self.reportArray[buttonIndex]];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
        }
    });
}
-(void)sheetHidden{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
#pragma mark - getter
-(MXRCopySysytemActionSheet*)reportSheetNew
{
    if (!_reportSheetNew) {
        _reportSheetNew = [[MXRCopySysytemActionSheet alloc] initWithFrame:[UIScreen mainScreen].bounds withBtns:self.reportArray withCancelBtn:MXRLocalizedString(@"CANCEL", @"取消") withDelegate:self];
        _reportSheetNew.tag = 2;
    }
    return _reportSheetNew;
}
-(MXRCopySysytemActionSheet *)actionSheet{

    if (!_actionSheet) {
        _actionSheet = [[MXRCopySysytemActionSheet alloc] initWithFrame:[UIScreen mainScreen].bounds withBtns:self.actionSheetTitleArray withCancelBtn:MXRLocalizedString(@"CANCEL", @"取消") withDelegate:self];
        _actionSheet.tag = 1;
    }
    return _actionSheet;
}
-(NSArray *)reportArray{

    if (!_reportArray) {
        _reportArray = @[MXRLocalizedString(@"MXRCommentViewCon_Sex", @"色情"),MXRLocalizedString(@"MXRCommentViewCon_Adver", @"广告"),MXRLocalizedString(@"MXRCommentViewCon_Rev", @"反动"),MXRLocalizedString(@"MXRCommentViewCon_Vio", @"暴力"),MXRLocalizedString(@"MXRCommentViewCon_Other",@"其他")];
    }
    return _reportArray;
}
-(NSMutableArray *)actionSheetTitleArray{

    if (!_actionSheetTitleArray) {
        _actionSheetTitleArray = [NSMutableArray array];
    }
    return _actionSheetTitleArray;
}
@end
