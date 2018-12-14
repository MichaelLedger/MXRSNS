//
//  MXRBookSNSSendDetailProxy.h
//  huashida_home
//
//  Created by yuchen.li on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MXRQiNiuUploadTokenModel,MXRBookSNSUploadImageInfo,MXRSNSSendModel,MXRSNSTransmitModel,MXRBookStarModel;
#define HotTopicArrayKey @" "
@class MXRQiNiuUploadTokenModel,MXRBookSNSUploadImageInfo,MXRSNSShareModel,MXRSNSTransmitModel;
@interface MXRBookSNSSendDetailProxy : NSObject
@property (nonatomic, strong, readonly)NSMutableArray <BookInfoForShelf *>*bookDataArray;            // 书架上所有图书
@property (nonatomic, strong, readonly)NSMutableArray <UIImage*> *selectImageArray;           // 选中的图片
@property (nonatomic, strong, readonly)NSMutableArray <MXRQiNiuUploadTokenModel*> *qiNiuUploadTokenArray; // 七牛上传token 里面只有一个
@property (nonatomic, strong, readonly)NSMutableArray <MXRBookSNSUploadImageInfo*> *imageInfoArray;   // 图片信息
@property (nonatomic, strong, readonly)NSMutableArray <MXRBookStarModel*> *bookStarModelArray;  // 获取搜索到的全部图书的星级信息
@property (nonatomic, strong)NSMutableArray *cacheSearchTopicArray;      //搜索话题结果缓存数组  结构[ {key:array} , {} , {} ]  里面可能存了几个关键词的搜索结果

+(instancetype)getInstance;
#pragma mark--发送动态

/**
  将图片转化为 imageInfo  在上传之前 获取每个图片的url

 @param imageArray 图片数组
 */
-(void)getImageUrlAndStateWithImageArray:(NSMutableArray*)imageArray;
-(void)changeImageInfoUrlWithImageInfoArray:(NSMutableArray*)imageInfoArray;

#pragma mark--搜索图书
-(void)saveShelfBooksInformationWithArray:(NSArray*)bookArray;

#pragma mark - 搜索话题 对数组的操作方法
//根据key值 获取 当前key值所对应的 搜索数组
-(NSMutableArray*)getOneSearchTopicArrayByKey:(NSString*)key;
//将 某个关键字的搜索结果 放到cacheSearchTopicArray 数组中
-(void)setOneSearchTopicArrayToSearchTopicArray:(NSArray*)array WithKey:(NSString*)key postNotification:(BOOL)isPostNotification;
//删除 cacheSearchTopicArray数组
-(void)removecacheSearchTopicArray;
//删除某个key值所对应数组的某个模型
-(NSInteger)removeModelWithKey:(NSString*)key topicId:(NSString*)topicId;



-(void)removeAllImageInfo;
-(void)removeAllSelectImage;
-(void)removeAllBookInfo;
-(void)removeQiNiuUploadImageToken;


@end
