//
//  MXRDataStatisticsNetworkManager.h
//  huashida_home
//
//  Created by 周建顺 on 15/7/30.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRNetworkResponse.h"

@interface MXRDataStatisticsNetworkManager : NSObject

+(instancetype)defaultInstance;

/**
 binner 点击统计
 */
-(void)binnerClickDataWithBinnerId:(NSString*)binnerId callback:(defaultCallback)callback;

/**
 分享次数统计
 */
-(void)shareCountDataWithBookGUID:(NSString*)bookGUID callback:(defaultCallback)callback;
/**
 分钟
 */
-(void)readingDurationDataWithBookGUID:(NSString*)bookGUID duration:(NSNumber*)duration callback:(defaultCallback)callback;

/*
 * 报错
 */
//-(void)addErrorBookWithBookGuid:(NSString*)bookGUID pageNo:(NSString*)pageNo;
/**
 *  记录设备下载图书前的信息        // 增加bookSource字段，用于扭蛋下载阅读的踩点  是扭蛋 传1 不是传0
 */
-(void)downloadBookLogsWithBookGUID:(NSString *)bookGUID unlockType:(NSInteger)unlockType codeID:(NSNumber *)codeID bookSource:(NSInteger)bookSource callback:(defaultCallback)callback;

/*
 * 举报（Diy 类型图书）
 */
-(void)reportDiyBookWithBookGuid:(NSString *)bookGUID reportContent:(NSString *)reportContent callback:(defaultCallback )callback;
/*
 * 获取举报图书的具体内容
 */
-(void)getReportBookDetailInfoWithCallBack:(defaultCallback)callback;
/*
 *  用户对图书点赞
 */
//-(void)userLikeBookWithUserId:(NSString *)userId andBookGuid:(NSString *)bookGuid andCallBack:(defaultCallback )callback;

/*
 *  用户对图书取消赞
 */
//-(void)userCancleLikeBookWithUserId:(NSString *)userId andBookGuid:(NSString *)bookGuid andCallBack:(defaultCallback )callback;

-(void)shareCountDataWithBookGUID:(NSString *)bookGuid andShareContent:(NSString *)shareContent  andShareWay:(NSInteger )shareWay andCallBack:(defaultCallback )callback;
@end
