//
//  MXRCollectionDataController.h
//  huashida_home
//
//  Created by shuai.wang on 17/2/8.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CollectWay) {
    CollectWayExitOrStart = 0,
    CollectWayEvery10Minutes = 10,
    CollectWayEvery30nMinutes = 30,
    CollectWayEvery60Minutes = 60
};
@interface MXRCollectionDataController : NSObject
@property (nonatomic , assign) BOOL requestSuccess;


+(instancetype)getInstance;

/**
 从服务端请求书城采集数据的方式
 (1.APP退出或启动时，上传数据（默认） collectWay = 0
 2.每隔10分钟 collectWay = 10
 3.每隔30分钟 collectWay = 30
 4.每隔1小时) collectWay = 60
 */
-(void)requestTheWayOfCollectionDataWithCallBack:(void(^)(CollectWay collectWay,BOOL isSuccess))callBack;

/**
 上传采集数据服务
 dictionary 需要上传的数据
 */
+(void)uploadcollectDataToServerWithDictionary:(NSDictionary *)dictionary callBack:(void(^)(NSArray *unuploadArray,BOOL isSuccess))call;



@end
