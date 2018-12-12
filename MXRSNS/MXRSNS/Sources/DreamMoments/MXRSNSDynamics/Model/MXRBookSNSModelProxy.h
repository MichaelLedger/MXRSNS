//
//  MXRBookSNSModelProxy.h
//  huashida_home
//
//  Created by gxd on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MXRBookSNSBannerModel;
@class MXRSNSShareModel;
@class MXRBookSNSMomentStatusNoUploadModel;
@class MXRTopicModel;
@interface MXRBookSNSModelProxy : NSObject
@property (strong, nonatomic) NSMutableArray <MXRTopicModel *> * bookSNSHeadtopicModelDataArray;
/**
 从服务端获取的数据 （排序过后的）
 */
@property (strong, nonatomic) NSMutableArray <MXRSNSShareModel *> * bookSNSMomentsArray;

/**
 梦想圈顶部banner图片数组
 */
@property (strong, nonatomic) NSMutableArray <MXRBookSNSBannerModel *> * bookSNSBannerArray;

/**
 从服务端获取的原始数据 （未排序的）
 */
@property (strong, nonatomic) NSMutableArray <MXRSNSShareModel *> * bookSNSNetMomentsArray;
@property (strong, nonatomic) NSMutableArray <MXRBookSNSMomentStatusNoUploadModel *> * bookSNSdataNeedUploadArray;
@property (strong, nonatomic) NSMutableArray <MXRSNSShareModel *> * bookSNSRecommentMomentsArray; //服务推荐的动态(精选)
+(instancetype)getInstance;
/*
 ** 保存缓存数据到沙盒
 */
-(void)creatCacheData;
-(void)creatNeedUploadCacheData;

/**
 清除缓存文件

 @return 是否清除成功
 */
- (BOOL)deleteCacheData;

/*
 ** 根据id获取sns模型
 */
-(MXRSNSShareModel *)getSNSShareModelWithId:(NSString *)modelID;
-(void)deleteMomentWithId:(NSString *)momentId;
-(void)uninterestredWithunFocusUserId:(NSString *)unFocusUserId;
-(NSArray *)getMomentIDBelongUserWithUserId:(NSString *)userid;
-(NSInteger )getMomentOnArrayIndex:(NSString *)momentID;

-(NSArray *)getMomentsOnArrayIndex:(NSArray *)momentIDArray;
-(void)updateLocalMoment:(NSArray *)dictArray andIsNewMoment:(BOOL )isNew callback:(void(^)(BOOL isSuccess))callback;

//-(BOOL )checkSrcModelIsDeleteWithId:(NSString *)momentId;
-(void)srcMomentDeleteMomentWithId:(NSString *)momentId;


/**
 给精选的动态数组赋值
 */
//-(void)addDataForBookSNSRecommentMomentsArray:(MXRSNSShareModel *)model;

/**
  排序两个数组

 @param oldArray 被插入数组
 @param newArray 插入数组
 @return 新数组
 */
- (NSMutableArray *)sortMomentArray:(NSMutableArray *)oldArray newArray:(NSMutableArray *)newArray;
@end
