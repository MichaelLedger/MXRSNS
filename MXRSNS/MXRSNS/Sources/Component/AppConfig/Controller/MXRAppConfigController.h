//
//  MXRAppConfigController.h
//  huashida_home
//
//  Created by weiqing.tang on 2018/5/30.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRAppConfigController : NSObject

@property (nonatomic , assign) BOOL requestSuccess;

+(instancetype)getInstance;

/**
 从服务端请求书城配置信息
 
 isSuccess
 */
-(void)requestTheWayOfCollectionDataWithCallBack:(void(^)(BOOL isSuccess))callBack;

@end
