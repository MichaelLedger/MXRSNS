//
//  MXRCollectionDataController.m
//  huashida_home
//
//  Created by shuai.wang on 17/2/8.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRCollectionDataController.h"
#import "MXRNetworkManager.h"
#import "MXRUserSettingsManager.h"
#import "MXRBase64.h"
#import "NSMutableURLRequest+Ex.h"
#import "ALLNetworkURL.h"
#import "MXRAppConfigModel.h"
#import "MXRAppConfigProxy.h"
#import "MXRAppConfigController.h"

@implementation MXRCollectionDataController

+(instancetype)getInstance {
    static MXRCollectionDataController *controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[MXRCollectionDataController alloc] init];
    });
    return controller;
}


/**
 从服务端请求书城采集数据的方式
 */
-(void)requestTheWayOfCollectionDataWithCallBack:(void(^)(CollectWay collectWay,BOOL isSuccess))callBack{
    
    [[MXRAppConfigController getInstance] requestTheWayOfCollectionDataWithCallBack:^(BOOL isSuccess) {
        
        if (isSuccess) {
            for (MXRAppConfigModel *configModel in [MXRAppConfigProxy getInstance].configArray) {
                if ([configModel.configName isEqualToString:@"data_collection_rule"]) {
                    if (callBack) {
                        if ([autoString(configModel.configValue) isEqualToString:@"0"]) {
                            callBack(CollectWayExitOrStart,YES);
                        }else if ([autoString(autoString(configModel.configValue)) isEqualToString:@"10"]){
                            callBack(CollectWayEvery10Minutes,YES);
                        }else if ([autoString(autoString(configModel.configValue)) isEqualToString:@"30"]){
                            callBack(CollectWayEvery30nMinutes,YES);
                        }else if ([autoString(autoString(configModel.configValue)) isEqualToString:@"60"]){
                            callBack(CollectWayEvery60Minutes,YES);
                        }
                    }
                }
            }
        }else {
            if (callBack) {
                callBack(CollectWayExitOrStart, NO);
            }
        }
    }];
    
}

/**
 上传采集数据服务
 */
+(void)uploadcollectDataToServerWithDictionary:(NSDictionary *)dictionary callBack:(void(^)(NSArray *unuploadArray,BOOL isSuccess))call {
    NSString *urlString = ServiceURL_CollectDataURL;
    
    // 代码质量优化 M by liulong for wangshuai
    [MXRNetworkManager mxr_post:urlString parameters:dictionary success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess){
            if (response.body) {
                /******  上传采集数据部分成功  array *******/
                NSArray *uploadFailData = response.body;
                if (call) {
                    call(uploadFailData,YES);
                }
            }else{
                DLOG(@"采集数据全部上传成功");
                if (call) {
                    call(nil,YES);
                }
            }
        }else{
            
            if (call) {
                call(nil,NO);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        DLOG(@"采集数据服务错误:%@",error);
        if (call) {
            call(nil,NO);
        }
    }];
}



@end
