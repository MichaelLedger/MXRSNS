//
//  MXRSendStateViewController.h
//  huashida_home
//
//  Created by yuchen.li on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//  动态发布页面

#import <UIKit/UIKit.h>
@class MXRSNSShareModel,BookInfoForShelf,MXRImageInformationModel,MXRTopicModel;
@interface MXRSNSSendStateViewController : MXRDefaultViewController

typedef NS_ENUM(NSInteger,MXRBookSNSSendDetailOperateType){
    MXRBookSNSSendDetailOperateTypedDefault       = 0,                    // 默认 发送态
    MXRBookSNSSendDetailOperateTypeTransmit       = 1,                    // 转发动态
    MXRBookSNSSendDetailOperateTypeJoinTopic      = 2,                    // 立即参与
    MXRBookSNSSendDetailOperateTypeShareToBookSNS = 3,                    // 分享到梦想圈
    MXRBookSNSSendDetailOperateTypeChatJoinTopic  = 4                     // 私信立即参与
};


/**
 转发动态

 @param model 原动态model
 @return
 */
-(instancetype)initWithModel:(MXRSNSShareModel *)model;

/**
 点击立即参与  参与话题

 @param topicModel 话题模型
 @return
 */
- (instancetype)initWithTopicModel:(MXRTopicModel *)topicModel;

/**
 私信 关联话题 点击立即参与

 @param topicString
 @param operationType 话题的名字
 @return 
 */
-(instancetype)initWithTopic:(NSString *)topicString
               operationType:(MXRBookSNSSendDetailOperateType)operationType;

/**
 分享图片至梦想圈 无默认文字

 @param bookInfo 图书信息
 @param model 图片信息
 @return 
 */
//-(instancetype)initWithBookInfo:(BookInfoForShelf *)bookInfo
//   WithMXRImageInformationModel:(MXRImageInformationModel *)model;

/**
 分享至梦想圈，有默认文字
 @param bookInfo  图书信息
 @param model   图片信息
 @param shareTextString  分享文字
 @return
 */
- (instancetype)initWithBookInfo:(BookInfoForShelf *)bookInfo
                  imageInfoModel:(MXRImageInformationModel *)model
                 shareTextString:(NSString *)shareTextString;
@end
