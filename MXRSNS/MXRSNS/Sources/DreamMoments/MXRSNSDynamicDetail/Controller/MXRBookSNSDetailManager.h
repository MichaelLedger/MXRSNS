//
//  MXRBookSNSDetailManager.h
//  huashida_home
//
//  Created by shuai.wang on 16/10/11.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRBookSNSDetailCommentListModel.h"
#import "MXRSNSShareModel.h"

@class MXRSNSShareModel;
@class MXRBookSNSPraiseListModel;
@interface MXRBookSNSDetailManager : NSObject
@property(strong,nonatomic) NSMutableArray *noNetCommentList;
+(instancetype)getInstance;
-(void)deleteAllObject;


-(MXRBookSNSDetailCommentListModel *)cacheCommentModelWithContent:(NSString *)content withCommentListModel:(MXRBookSNSDetailCommentListModel *)model withListModelFuncType:(ListModelFuncType)funcType;

-(MXRBookSNSPraiseListModel *)cacheDynamicPraiseInfoRefrashWithModel:(MXRSNSShareModel *)model;

/*
 * 本地创建新评论
 */
-(MXRBookSNSDetailCommentListModel *)cacheCreateCommentModelWithContent:(NSString *)content withCommentListModel:(MXRSNSShareModel *)model withListModelFuncType:(ListModelFuncType)funcType;


/*
 * 本地创建回复评论
 */
-(MXRBookSNSDetailCommentListModel *)cacheReplyCommentModelWithContent:(NSString *)content withCommentListModel:(MXRBookSNSDetailCommentListModel *)model withListModelFuncType:(ListModelFuncType)funcType;


/*
 * 本地缓存举报信息
 */
-(MXRBookSNSDetailCommentListModel *)cacheReportCommentModelWithContent:(NSString *)content withCommentListModel:(MXRBookSNSDetailCommentListModel *)model withListModelFuncType:(ListModelFuncType)funcType;
/*
 * 缓存数据到本地等待有网络下上传
 */
-(void)cacheDetailCommentDataForBookSNSManagerWithModel:(MXRBookSNSDetailCommentListModel *)cacheListModel;

/**
 动态详情页的评论model 转换为 梦想圈评论列表model
 @param commentList 动态详情页的评论model数组
 @return 梦想圈评论列表model数组
 */
-(NSMutableArray<MXRSNSCommentModel *> *)conversionMXRBookSNSDetailCommentList:(NSArray<MXRBookSNSDetailCommentListModel *> *)commentList;
@end
