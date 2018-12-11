//
//  MXRBookSNSSendDetailController.h
//  huashida_home
//
//  Created by yuchen.li on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRBookSNSUploadImageInfo.h"
@class MXRSNSSendModel,MXRSNSTransmitModel,MXRSNSShareModel;
@interface MXRBookSNSSendDetailController : NSObject
@property (strong, nonatomic) NSMutableArray *searchTopicKeyWordArray;


+(instancetype)getInstance;

/**
  从书架上面获取图书
 */
-(void)saveBookFromBookShelf;



#pragma mark - 搜索话题接口
//根据关键字来搜索 话题
-(void)searchTopicByKeyword:(NSString*)keyWord
               WithCallBack:(void(^)(BOOL))callBack;
//根据页码 和 pageSize获取热门话题
-(void)getHotTopicWithPage:(NSInteger)page
              WithPageSize:(NSInteger)pageSize
              WithCallBack:(void(^)(BOOL))callBack;
#pragma mark - 管理搜索话题的操作方法
-(void)addStringToSearchTopicKeyWordArray:(NSString*)keyWord;
-(void)removesStringFromeTopicKeyWordArray:(NSString*)keyWord;
-(void)removeSearchTopicKeyWordArray;
#pragma mark - 判断数组中是否存在 某个话题
-(BOOL)checkIsCurrentTopicExistinArray:(NSArray*)topicArray
                         WithTopicName:(NSString*)topicName;


/**
 获取七牛上传Token

 @param userId 用户Id
 @param moduleName @"dynamic"
 @param callBack 
 */
-(void)dynamicAcquisitionQiNiuUploadTokenUserId:(NSString*)userId
                                     moduleName:(NSString*)moduleName
                                       callBack:(void(^)(BOOL isOkay))callBack;

/**
 发送动态

 @param shareModel 动态信息model
 @param callBack 
 */
-(void)sendDynamicDetail:(MXRSNSShareModel*)shareModel
                callBack:(void(^)(BOOL isOkay))callBack;
//转发动态
-(void)transmitDetailInformationToServiceWith:(MXRSNSShareModel*)model
                             isShowFailPrompt:(BOOL)isShowPrompt
                                 withCallBack:(void (^)(BOOL))callback;

/**
 获取书架上的书的图书星级

 @param bookGuids 多个图书ID，以逗号（,）隔开
 @param callBack 
 */
-(void)getBookStarWithBookGuids:(NSString*)bookGuids
                   callBack:(void(^)(BOOL isOkay))callBack;


/**
 获取当前网络状态

 @return YES or NO
 */
-(BOOL)getNetStatus;
@end
