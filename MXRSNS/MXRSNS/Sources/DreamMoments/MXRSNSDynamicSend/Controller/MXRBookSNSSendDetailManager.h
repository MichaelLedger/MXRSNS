//
//  MXRBookSNSSendDetailManager.h
//  huashida_home
//
//  Created by yuchen.li on 16/9/26.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRSNSShareModel.h"
#import "MXRSNSSendStateViewController.h"

@class BookInfoForShelf,MXRSNSSendModel,MXRSNSTransmitModel,MXRSNSShareModel,MXRSubjectInfoModel;
@interface MXRBookSNSSendDetailManager : NSObject
@property (nonatomic, strong) NSMutableArray *recordTopicArray;

+(instancetype)getInstance;
-(void)clearRecordTopicArray;
/**
 点击发送

 @param textView
 @param book 分享的图书信息
 @param view  图书信息View 若没有图书，边框变为红色
 @param sendDetailOperateType 动态操作类型
 @param callBack
 */
-(void)userClickSendToPublicBookSNSDetail:(UITextView*)textView
                            bookInfoShelf:(BookInfoForShelf*)book
                            associateView:(UIView*)view
                           isRelevantZone:(BOOL)isRelevantZone
                              operateType:(MXRBookSNSSendDetailOperateType)sendDetailOperateType
                                 callBack:(void(^)(BOOL isOkay))callBack;

/**
 正则匹配话题

 @param view
 */
-(NSArray *)textStringToRegularExpressionWithTextView:(UITextView*)view;


/**
 上传图片

 @param imageInfoArray 存放图片的数组
 @param index 第几张图片
 @param callBack
 */
-(void)bookSNSBeginUploadImageImageArray:(NSMutableArray *)imageInfoArray
                                   index:(NSInteger)index
                                callBack:(void (^)(NSDictionary*dict))callBack;

/**
 获得一个动态

 @param string 动态内容
 @param totalImageArray 动态的图片
 @param bookInfo 图书信息
 @param userInfo 用户信息
 @param uuid 该动态的唯一标识
 @param type 操作类型
 @param QAID 问答ID
 @return
 */
-(MXRSNSShareModel *)getOneSendModelFromLocalText:(NSString *)string
                                       imageArray:(NSMutableArray *)totalImageArray
                                    bookInfoShelf:(BookInfoForShelf *)bookInfo
                                  userInformation:(UserInformation *)userInfo
                                       clientUUid:(NSString *)uuid
                                       senderType:(SenderType)type
                                  bookContentType:(MXRBookSNSDynamicBookContentType ) contentType
                                    subjectModel:(MXRSubjectInfoModel *)subjectInfoModel
                                             QAID:(NSString *)QAID;

/**
 获得一个 转发 的数据模型

 @param model 被转发的数据模型
 @param senderType SenderTypeOfTransmit
 @param userNickName 转发人的昵称
 @param userId 转发人的用户Id
 @param retransmissionWord 转发的文字
 @param clientUuid 该转发数据模型的唯一标识
 @param QAID 问答ID
 @return 
 */
-(MXRSNSShareModel *)getOneShareModelFromLocal:(MXRSNSShareModel *)model
                                    senderType:(SenderType)senderType
                                      userName:(NSString *)userNickName
                                        userId:(NSInteger )userId
                            retransmissionWord:(NSString *)retransmissionWord
                                    clientUUId:(NSString *)clientUuid
                                          QAID:(NSString *)QAID;


/**
 将发送失败的动态，在次发送至服务器

 @param model 动态数据
 @param callback
 */
-(void)sendModelToSeviceAgain:(MXRSNSShareModel*)model
                     callBack:(void(^)(BOOL isOkay))callback;

/**
 第一次将动态发送至服务器

 @param model 动态数据
 @param callback
 */
-(void)sendModelToSevice:(MXRSNSShareModel *)model
                callBack:(void (^)(BOOL))callback;
@end
