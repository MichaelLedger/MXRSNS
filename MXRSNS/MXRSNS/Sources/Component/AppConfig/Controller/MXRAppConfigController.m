//
//  MXRAppConfigController.m
//  huashida_home
//
//  Created by weiqing.tang on 2018/5/30.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRAppConfigController.h"
#import "MXRNetworkManager.h"
#import "MXRUserSettingsManager.h"
#import "MXRBase64.h"
#import "NSMutableURLRequest+Ex.h"
#import "ALLNetworkURL.h"
#import "MXRAppConfigModel.h"
#import "MXRAppConfigProxy.h"
//#import "MXRSettingTimerManager.h"

@implementation MXRAppConfigController

+(instancetype)getInstance {
    static MXRAppConfigController *controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[MXRAppConfigController alloc] init];
    });
    return controller;
}


/**
 从服务端请求书城配置信息
 */
-(void)requestTheWayOfCollectionDataWithCallBack:(void(^)(BOOL isSuccess))callBack{
    //V5.9.3 默认关闭梦想钻兑换梦想币
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HideMXZExchangeEntrance];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.requestSuccess) {
        return;
    }
    
    self.requestSuccess = YES;
    NSString *urlString = ServiceURL_BASE_SERVICE_config_client;
    [MXRNetworkManager mxr_get:urlString parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.body) {
            
            if([response.body isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in response.body) {
                    MXRAppConfigModel *model = [MXRAppConfigModel mxr_modelWithJSON:dict];
                    [[MXRAppConfigProxy getInstance] addMXRAppConfigModelToConfigArray:model];
                    
                    //V5.9.3 梦想钻转梦想币开关，1=可以，0=不可以
                    if ([model.configName isEqualToString:@"can_mxz_to_mxb"]) {
                        BOOL hideMXZExchangeEntrance = [model.configValue integerValue] == 1 ? NO : YES;
                        [[NSUserDefaults standardUserDefaults] setBool:hideMXZExchangeEntrance forKey:HideMXZExchangeEntrance];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    //一键添加QQ群配置 V5.11.0 by minjing.lin
                    if ([model.configName isEqualToString:@"ios_qq_group"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:model.configValue forKey:UserBindingQQGroupInfo];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                }
                
                //开启休息提醒
//                [[MXRSettingTimerManager sharedInstance] defaultShowTips];
                
                if (callBack) {
                    callBack(YES);
                }
            }else{
                if (callBack) {
                    callBack(NO);
                }
            }
            
        }else{
            if (callBack) {
                callBack(NO);
            }
            DLOG(@"获取书城采集数据方式错误errorcode:%@, errorMsg:%@",response.errCode,response.errMsg);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (callBack) {
            callBack(NO);
        }
        DLOG(@"获取书城采集数据方式错误:%@",error);
    }];
}

@end
