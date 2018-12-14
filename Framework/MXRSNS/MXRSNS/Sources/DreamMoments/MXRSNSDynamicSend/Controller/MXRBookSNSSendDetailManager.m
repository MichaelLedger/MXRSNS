//
//  MXRBookSNSSendDetailManager.m
//  huashida_home
//
//  Created by yuchen.li on 16/9/26.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSSendDetailManager.h"
#import <UIKit/UIKit.h>
#import "UserInformation.h"
#import "MXRBookSNSSendDetailProxy.h"
#import "MXRQiNiuUploadTokenModel.h"
#import "GlobalFunction.h"
#import "UIImage+Extend.h"
//#import <QiniuSDK.h>
//#import "MXRQiNiuHelper.h"
#import "MXRBookSNSUploadImageInfo.h"
#import "BookInfoForShelf.h"
#import "MXRBookSNSSendDetailController.h"
#import "MXRBookSNSMomentStatusNoUploadManager.h"
#import "MXRBookSNSModelProxy.h"
#import "MXRConstant.h"
#import "MXRSubjectInfoModel.h"
@interface MXRBookSNSSendDetailManager()
@property(nonatomic,assign) NSInteger currentIndex;
@property (nonatomic, strong)NSMutableArray *sendIamgeArray;

@end
@implementation MXRBookSNSSendDetailManager
+(instancetype)getInstance{
    static MXRBookSNSSendDetailManager *instance;
    static dispatch_once_t pre;
    dispatch_once(&pre, ^{
        instance = [[MXRBookSNSSendDetailManager alloc] init];
        
    });
    return instance;
}

-(instancetype)init {
    if (self = [super init]) {
        _recordTopicArray = [NSMutableArray array];
    }
    return self;
}

-(void)clearRecordTopicArray {
    [self.recordTopicArray removeAllObjects];
}

//发动态和分享动态
-(MXRSNSShareModel*)getOneSendModelFromLocalText:(NSString *)string imageArray:(NSMutableArray *)totalImageArray bookInfoShelf:(BookInfoForShelf *)bookInfo userInformation:(UserInformation *)userInfo clientUUid:(NSString *)uuid senderType:(SenderType)type bookContentType:(MXRBookSNSDynamicBookContentType ) contentType subjectModel:(MXRSubjectInfoModel *)subjectInfoModel QAID:(NSString *)QAID {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSDictionary* dict;
    NSInteger senderNum;
    if (type == SenderTypeOfDefault) {
        senderNum = 1;
    }else if(type == SenderTypeOfShare) {
        senderNum = 3;
    }else{
        
    }
    NSInteger contentTypeNum;
    if (contentType == MXRBookSNSDynamicBookContentTypeSingleBook) {
        contentTypeNum = 1;
    }else if(contentType == MXRBookSNSDynamicBookContentTypeMutableBook){
        contentTypeNum = 2;
    }else{
    
    }
    
    userInfo = [UserInformation modelInformation];
    if (userInfo.userImage) {
        dict=@{ momentDescription:autoString(string),
                bookGuid:autoString(bookInfo.bookGUID),
                bookIconUrl:autoString(bookInfo.bookIconURL),
                bookName:autoString(bookInfo.bookName),
                bookStars:autoNumber(bookInfo.star),
                userId:autoString(userInfo.userID),
                senderName:autoString(userInfo.userNickName),
                senderHeadUrl:autoString(userInfo.userImage),
                senderIconImage:autoString(userInfo.userImage),
                senderTime:[NSString stringWithFormat:@"%f",interval],
                senderType:@(senderNum),
                likeCount:@(0),
                commentCount:@(0),
                trammitCount:@(0),
                imageArray:totalImageArray,
                clientUuid:uuid,
                bookContentType:@(contentTypeNum),
                contentZoneId :[NSString stringWithFormat:@"%ld",subjectInfoModel.subjectID],
                contentZoneName : autoString(subjectInfoModel.subjectName),
                contentZoneCover : autoString(subjectInfoModel.subjectCover),
                topicnames : autoString([self.recordTopicArray componentsJoinedByString:@","]),
                qaId: autoString(QAID)
                };
    }else{
        
        dict=@{  momentDescription:autoString(string),
                 bookGuid:autoString(bookInfo.bookGUID),
                 bookIconUrl:autoString(bookInfo.bookIconURL),
                 bookName:autoString(bookInfo.bookName),
                 bookStars:autoNumber(bookInfo.star),
                 userId:autoString(userInfo.userID),
                 senderName:autoString(userInfo.userNickName),
                 senderIconImage:autoString(userInfo.userImage),
                 senderTime:[NSString stringWithFormat:@"%f",interval],
                 senderType:@(senderNum),
                 likeCount:@(0),
                 commentCount:@(0),
                 trammitCount:@(0),
                 imageArray:totalImageArray,
                 clientUuid:uuid,
                 bookContentType:@(contentTypeNum),
                 contentZoneId :[NSString stringWithFormat:@"%ld",subjectInfoModel.subjectID],
                 contentZoneName : autoString(subjectInfoModel.subjectName),
                 contentZoneCover : autoString(subjectInfoModel.subjectCover),
                 topicnames : autoString([self.recordTopicArray componentsJoinedByString:@","]),
                 qaId: autoString(QAID)
                };
    }
    MXRSNSShareModel *model = [[MXRSNSShareModel  alloc]createWithDictionary:dict];
    model.momentStatusType  = MXRBookSNSMomentStatusTypeOnLocal;
    model.senderType = type;
    [model MXRSetMomentId: uuid];
    model.hasPraised = NO;
    return model;
}
//转发动态
-(MXRSNSShareModel *)getOneShareModelFromLocal:(MXRSNSShareModel *)model  senderType:(SenderType)senderType userName:(NSString *)userNickName userId:(NSInteger)userId retransmissionWord:(NSString *)retransmissionWord clientUUId:(NSString *)clientUuid QAID:(NSString *)QAID
{
    NSDictionary *params;
    NSString *picType = @"None";  // 图片的形状   “H”: 横向,"V":纵向,"S": 正方形
    NSString *userLogoUrl = @"None";
    if ([UserInformation modelInformation].userImage) {
        userLogoUrl = [UserInformation modelInformation].userImage;
    }
    if (senderType == SenderTypeOfTransmit) {
        MXRSNSSendModel *modelSend = (MXRSNSSendModel*)model;
        if (modelSend.imageArray.count == 1) {
            MXRBookSNSUploadImageInfo *imageInfo = modelSend.imageArray[0];
            if (imageInfo.shapeType == MXRBooKSNSSendDetailImageTypeHorizontal) {
                picType = @"H";
            }else if(imageInfo.shapeType == MXRBooKSNSSendDetailImageTypeVertical){
                picType = @"V";
            }else if (imageInfo.shapeType == MXRBooKSNSSendDetailImageTypeSquare){
                picType = @"S";
            }
        }
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
        if (modelSend.totalPicUrl) {
            params = @{@"momentId":clientUuid,
                     @"contentWord":autoString(modelSend.momentDescription),
                     @"contentBookId":autoString(modelSend.bookGuid),
                     @"contentBookLogo":autoString(modelSend.bookIconUrl),
                     @"contentBookName":autoString(modelSend.bookName),
                     @"contentBookStarlevel":autoString(modelSend.bookStars),
                     @"contentPic": autoString(modelSend.totalPicUrl),
                     @"createTime":[NSString stringWithFormat:@"%f",interval],
                     @"userId":@(userId),
                     @"userName":autoString(userNickName),
                     @"userLogo":autoString(userLogoUrl),
                     @"praiseNum":@(0),
                     @"action":@(2),
                     @"srcId":autoString(modelSend.momentId),
                     @"srcUserId":autoString(modelSend.senderId),
                     @"srcUserName":autoString(modelSend.senderName),
                     @"retransmissionWord":autoString(retransmissionWord),
                     @"commentNum":@(0),
                     @"retransmissionNum":@(0),
                     @"publisher":@(2),
                     @"contentPicType":picType,
                     @"hasPraised":@(0),
                     @"clientUuid":clientUuid,
                     @"bookContentType":@(modelSend.bookContentType),
                     @"contentZoneId":autoString(modelSend.contentZoneId),
                     @"contentZoneName" : autoString(modelSend.contentZoneName),
                     @"contentZoneCover": autoString(modelSend.contentZoneCover),
                     @"topicNames": autoString([self.recordTopicArray componentsJoinedByString:@","]),
                     qaId: autoString(QAID)
                     };
        }else{
            params = @{@"momentId":clientUuid,
                     @"contentWord":autoString(modelSend.momentDescription),
                     @"contentBookId":autoString(modelSend.bookGuid),
                     @"contentBookLogo":autoString(modelSend.bookIconUrl),
                     @"contentBookName":autoString(modelSend.bookName),
                     @"contentBookStarlevel":autoString(modelSend.bookStars),
                     @"createTime":[NSString stringWithFormat:@"%f",interval],
                     @"userId":@(userId),
                     @"userName":autoString(userNickName),
                     @"userLogo":autoString(userLogoUrl),
                     @"praiseNum":@(0),
                     @"action":@(2),
                     @"srcId":autoString(modelSend.momentId),
                     @"srcUserId":autoString(modelSend.senderId),
                     @"srcUserName":autoString(modelSend.senderName),
                     @"retransmissionWord":autoString(retransmissionWord),
                     @"commentNum":@(0),
                     @"retransmissionNum":@(0),
                     @"publisher":@(2),
                     @"contentPicType":picType,
                     @"hasPraised":@(0),
                     @"clientUuid":clientUuid,
                     @"bookContentType":@(modelSend.bookContentType),
                     @"contentZoneId":autoString(modelSend.contentZoneId),
                     @"contentZoneName" : autoString(modelSend.contentZoneName),
                     @"contentZoneCover": autoString(modelSend.contentZoneCover),
                     @"topicNames": autoString([self.recordTopicArray componentsJoinedByString:@","]),
                     qaId: autoString(QAID)
                     };
        }    }
    MXRSNSShareModel *sharemodel = [[MXRSNSShareModel alloc] createWithDictionary:params];
    sharemodel.momentStatusType = MXRBookSNSMomentStatusTypeOnLocal;
    sharemodel.senderType = SenderTypeOfTransmit;
    [sharemodel MXRSetMomentId: clientUuid];
    sharemodel.hasPraised = NO;
    return sharemodel;
}
-(NSArray *)textStringToRegularExpressionWithTextView:(UITextView *)view{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:view.attributedText ];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, view.attributedText.string.length)];
    NSString *topicPattern = @"#([^\\#]+)#";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:topicPattern options:0 error:nil];
    NSArray *results = [regex matchesInString:view.text options:0 range:NSMakeRange(0, view.text.length)];
    if (results.count>0) {
        for (NSTextCheckingResult *result in results) {
             NSString *recognizeTopic = [view.text substringWithRange:result.range];
            for (NSString *topicString in self.recordTopicArray) {
                if ([topicString isEqualToString:recognizeTopic]) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(6, 119, 154) range:result.range];
                }
            }
        }
        NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSBackgroundColorAttributeName:[UIColor clearColor],NSFontAttributeName:view.font};
        view.typingAttributes = attributes;
        view.attributedText = attributedString;
    }else{
        view.textColor=[UIColor blackColor];
    }
    return results;
}

-(void)userClickSendToPublicBookSNSDetail:(UITextView*)textView bookInfoShelf:(BookInfoForShelf *)book associateView:(UIView *)view isRelevantZone:(BOOL)isRelevantZone operateType:(MXRBookSNSSendDetailOperateType)sendDetailOperateType callBack:(void (^)(BOOL))callBack{
    // 判断字符数是否超过140个字
    //发送态
    if (sendDetailOperateType == MXRBookSNSSendDetailOperateTypedDefault || sendDetailOperateType == MXRBookSNSSendDetailOperateTypeJoinTopic || sendDetailOperateType == MXRBookSNSSendDetailOperateTypeShareToBookSNS) {
        if (textView.text.length == 0 || [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""].length == 0) {
            [MXRConstant showAlertOnWindow:MXRLocalizedString(@"SNSSendDetail_None_Empty",@"输入不能为空") andShowTime:1.0f];
            if (callBack) {
                callBack(NO);
            }
            return;
        }else if(textView.text.length > 140){
            [MXRConstant showAlertOnWindow: MXRLocalizedString(@"SNSSendDetail_Overflow", @"字数不能超过140") andShowTime:1.0f];
            if (callBack) {
                callBack(NO);
            }
            return;
        }else{
            NSString *textString = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (textString.length == 0) {
                [MXRConstant showAlertOnWindow:MXRLocalizedString(@"SNSSendDetail_None_All_Space",@"输入不能全为空格") andShowTime:1.0f];
                if (callBack) {
                    callBack(NO);
                }
                return;
            }
        }
    //转发
    }else{
        if(textView.text.length>140){
            [MXRConstant showAlertOnWindow:MXRLocalizedString(@"SNSSendDetail_Overflow", @"字数不能超过140") andShowTime:1.0f];
            if (callBack) {
                callBack(NO);
            }
            return;
        }else{
            if (textView.text.length!=0) {
                NSString*textString= [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                if (textString.length==0) {
                    [MXRConstant showAlertOnWindow:MXRLocalizedString(@"SNSSendDetail_None_All_Space",@"输入不能全为空格") andShowTime:1.0f];
                    if (callBack) {
                        callBack(NO);
                    }
                    return;
                }
            }
        }
    }
    
    
    if ([textView.text containsString:@"\n"]) {
        NSString*replaceString=[textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        textView.text=replaceString;
    }
    // 转发不需要图书
    if (sendDetailOperateType == MXRBookSNSSendDetailOperateTypeTransmit) {
        callBack(YES);
    }else{
        if (!book && !isRelevantZone) {
            
            view.layer.borderColor=[UIColor redColor].CGColor;
            [view layoutSubviews];
            [MXRConstant showAlert: MXRLocalizedString(@"SNSSendDetail_Select_Book",@"请选择一本图书") andShowTime:1.0f];
            if (callBack) {
                callBack(NO);
            }
        }else{
            if ([textView.text containsString:@"\n"]) {
                NSString*replaceString=[textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                textView.text=replaceString;
            }
            if (callBack) {
                callBack(YES);
            }
        }
    }
    
    
}
//-(void)bookSNSBeginUploadImageImageArray:(NSMutableArray *)imageInfoArray index:(NSInteger)index callBack:(void (^)(NSDictionary *dict))callBack{
////    NSMutableArray *qiNiuArray = [MXRBookSNSSendDetailProxy getInstance].qiNiuUploadTokenArray;
////    MXRQiNiuUploadTokenModel *model;
////    if (qiNiuArray.count > 0) {
////        model = [MXRBookSNSSendDetailProxy getInstance].qiNiuUploadTokenArray[0];
////    }
//    MXRBookSNSUploadImageInfo *imageInfo = imageInfoArray[index];
//    UIImage *image = imageInfo.image;
//    NSData *imageData = UIImagePNGRepresentation(image);
//
//    if (!imageData) {
//        imageData = UIImageJPEGRepresentation(image, 1.0f);
//    }
//    if (!imageData) { //如果图片为空值  那么不做上传操作
//        return;
//    }
//    NSString *keyString = imageInfo.keyString;
//    QNUploadOption *op = [[QNUploadOption alloc]initWithMime:nil progressHandler:nil params:nil checkCrc:NO cancellationSignal:nil];
//    NSString *token = [MXRQiNiuHelper makeBookSNSDynamicsImageUploadTokenWithFileName:keyString];
//    QNUploadManager *upManager = [[QNUploadManager alloc] init];
//    [upManager putData:imageData key:keyString token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        if(info.isOK){
//            NSDictionary *dict = @{@"index":@(index),@"isSuccess":@YES};
//            if (callBack) {
//                callBack(dict);
//            }
//        }else{
//            NSDictionary *dict = @{@"index":@(index),@"isSuccess":@NO};
//            if (callBack) {
//                callBack(dict);
//            }
//        }
//    } option:op];
//}
-(void)sendModelToSevice:(MXRSNSShareModel *)model callBack:(void (^)(BOOL))callback{
    if (!model) {
        if (callback) {
            callback(NO);
        }
        
    }
    @MXRWeakObj(self);
    [self findAndChangeModelUploadStatus:model momentStatusType:MXRBookSNSMomentStatusTypeOnUpload];
    if (model.senderType == SenderTypeOfDefault || model.senderType == SenderTypeOfShare) {
        [[MXRBookSNSSendDetailController getInstance]sendDynamicDetail:model callBack:^(BOOL isOkay) {
            if (isOkay) {
                
                [self resetDataAfterSend];
                [selfWeak findAndChangeModelUploadStatus:model momentStatusType:MXRBookSNSMomentStatusTypeOnInternet];
                [[NSNotificationCenter defaultCenter]postNotificationName:Notification_MXRBookSNS_ReloadData object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    switch (model.senderType) {
                        case SenderTypeOfShare:
                            [MXRConstant showSuccessAlertWithMsg:MXRLocalizedString(@"ShareSuccess",@"已分享成功") andShowTime:1.0f];
                            break;
                        case SenderTypeOfDefault:
                             [MXRConstant showSuccessAlertWithMsg:MXRLocalizedString(@"SNSSendDetail_Send_Success",@"动态发送成功") andShowTime:1.0f];
                            break;
                        default:
                            break;
                    }
                });
                
                if (callback) {
                    callback(YES);
                }
                
            }else{
                
                [self resetDataAfterSend];
                [selfWeak findAndChangeModelUploadStatus:model momentStatusType:MXRBookSNSMomentStatusTypeOnLocal];
                [[NSNotificationCenter defaultCenter]postNotificationName:Notification_MXRBookSNS_ReloadData object:nil];
                [[MXRBookSNSMomentStatusNoUploadManager getInstance]addLikeAndUnlikeAndDeleteAndUploadMomentDetailNoUploadModelWithUserHandleNoUploadStatusType:MXRBookSNSUserHandleNoUploadStatusTypeSendStatusDetail andBookSNSMomentId:model.momentId andHandleUserId:[UserInformation modelInformation].userID];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    switch (model.senderType) {
                        case SenderTypeOfShare:
                            [MXRConstant showAlertOnWindow:MXRLocalizedString(@"SNSSendDetail_Bad_Net_Share_Upload_Fail", @"网络不佳，分享内容上传失败") andShowTime:1.0f];
                            break;
                        case SenderTypeOfDefault:
                            [MXRConstant showAlertOnWindow:MXRLocalizedString(@"SNSSendDetail_Bad_Net_Upload_Fail",@"网络不佳,动态上传失败") andShowTime:1.0f];
                            break;
                        default:
                            break;
                    }
                });
                if (callback) {
                    callback(NO);
                }
            }
        }];
    }else if(model.senderType == SenderTypeOfTransmit){
        [[MXRBookSNSSendDetailController getInstance]transmitDetailInformationToServiceWith:model isShowFailPrompt:YES withCallBack:^(BOOL isOkay) {
            if (isOkay) {
                
                [self resetDataAfterSend];
                [selfWeak findAndChangeModelUploadStatus:model momentStatusType:MXRBookSNSMomentStatusTypeOnInternet];
                [[NSNotificationCenter defaultCenter]postNotificationName:Notification_MXRBookSNS_ReloadData object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MXRConstant showSuccessAlertWithMsg:MXRLocalizedString(@"SNSSendDetail_Transmit_Success",@"动态转发成功") andShowTime:1.5f];
                });
                if (callback) {
                    callback(YES);
                }
            }else{
                
                [self resetDataAfterSend];
                [selfWeak findAndChangeModelUploadStatus:model momentStatusType:MXRBookSNSMomentStatusTypeOnLocal];
                  [[MXRBookSNSMomentStatusNoUploadManager getInstance]addLikeAndUnlikeAndDeleteAndUploadMomentDetailNoUploadModelWithUserHandleNoUploadStatusType:MXRBookSNSUserHandleNoUploadStatusTypeSendStatusDetail andBookSNSMomentId:model.momentId andHandleUserId:[UserInformation modelInformation].userID];
                [[NSNotificationCenter defaultCenter]postNotificationName:Notification_MXRBookSNS_ReloadData object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      [MXRConstant showAlertOnWindow:MXRLocalizedString(@"SNSSendDetail_Bad_Net_Upload_Fail",@"网络不佳,动态上传失败") andShowTime:1.5f];
                });
                if (callback) {
                    callback(NO); 
                }
            }
        }];
    }
}


-(void)sendModelToSeviceAgain:(MXRSNSShareModel *)model callBack:(void (^)(BOOL))callback
{
    if (!model) {
        callback(NO);
    }
     @MXRWeakObj(self);
    [self findAndChangeModelUploadStatus:model momentStatusType:MXRBookSNSMomentStatusTypeOnUpload];
       if (model.senderType == SenderTypeOfDefault || model.senderType == SenderTypeOfShare) {
       
        [[MXRBookSNSSendDetailController getInstance]sendDynamicDetail:model callBack:^(BOOL isOkay) {
            if (isOkay) {
                [selfWeak findAndChangeModelUploadStatus:model momentStatusType:MXRBookSNSMomentStatusTypeOnInternet];
                [[NSNotificationCenter defaultCenter]postNotificationName:Notification_MXRBookSNS_ReloadData object:nil];
                
                if (callback) {
                    callback(YES);
                }
                
            }else{
                
                [selfWeak findAndChangeModelUploadStatus:model momentStatusType:MXRBookSNSMomentStatusTypeOnLocal];
                 [[NSNotificationCenter defaultCenter]postNotificationName:Notification_MXRBookSNS_ReloadData object:nil];
                if (callback) {
                    callback(NO);
                }
            }
        }];
    }else if(model.senderType == SenderTypeOfTransmit){
        [[MXRBookSNSSendDetailController getInstance]transmitDetailInformationToServiceWith:model isShowFailPrompt:NO withCallBack:^(BOOL isOkay) {
            if (isOkay) {
                
                [selfWeak findAndChangeModelUploadStatus:model momentStatusType:MXRBookSNSMomentStatusTypeOnInternet];
                [[NSNotificationCenter defaultCenter]postNotificationName:Notification_MXRBookSNS_ReloadData object:nil];
                if (callback) {
                    callback(YES);
                }
            }else{
                
                [selfWeak findAndChangeModelUploadStatus:model momentStatusType:MXRBookSNSMomentStatusTypeOnLocal];
                 [[NSNotificationCenter defaultCenter]postNotificationName:Notification_MXRBookSNS_ReloadData object:nil];
                if (callback) {
                    callback(NO);
                }
            }
        }];
    }
}

/**
 改变数据的上传状态

 @param model       动态模型
 @param momentStatusType   本地 上传中 上传成功
 */
-(void)findAndChangeModelUploadStatus:(MXRSNSShareModel*)model momentStatusType:(MXRBookSNSMomentStatusType)senderType
{
    [[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.momentId isEqualToString:model.momentId]) {
            if (senderType == MXRBookSNSMomentStatusTypeOnUpload) {
                [obj momentUploading];
            }else if(senderType == MXRBookSNSMomentStatusTypeOnLocal){
                [obj momentSendFail];
            }else if (senderType == MXRBookSNSMomentStatusTypeOnInternet){
                [obj momentSendSuss];
            }
            *stop = YES;
        }
    }];

}
-(void)resetDataAfterSend{
        [[MXRBookSNSSendDetailProxy getInstance]removeAllBookInfo];
        [[MXRBookSNSSendDetailProxy getInstance]removeAllSelectImage];
        [[MXRBookSNSSendDetailProxy getInstance]removeAllImageInfo];
        [[MXRBookSNSSendDetailProxy getInstance]removeQiNiuUploadImageToken];
}
@end
