//
//  BasicNetwork.m
//  huashida_home
//
//  Created by yanbin on 15/4/24.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "BasicNetwork.h"
#import "GlobalFunction.h"
#import "ALLNetworkURL.h"
#import "MXRConstant.h"
#import <AFNetworking/AFNetworking.h>
#import "MXRMD5.h"
#import "NSMutableURLRequest+Ex.h"
#import "MXRNetworkResponse.h"
#import "MXRNetworkManager.h"

@implementation BasicNetwork {

}


/*
 *      从服务端获取游客的唯一标识符
 */
- (void)getUniqueIdForTouristWithCallBack:(void(^)(BOOL isServerOk,NSString * uniqueId))callBack
{
    // 分库中不需要请求设备id
    if (callBack) {
        callBack(YES,createVisitorUniqueId());
    }
    
//    [MXRNetworkManager mxr_get:ServiceURL_Base_device_info_id parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
//        if (response.isSuccess) {
//            NSDictionary * result = response.body;
//            callBack(YES, [result objectForKey:@"deviceId"]);
//        }else{
//            DLOG(@"服务返回的json格式错误:%@",response.errMsg);
//            callBack(NO, @"服务错误");
//        }
//        
//    } failure:^(NSURLSessionTask *task, NSError *error) {
//        
//        if ( [MXRDeviceUtil isReachable] ) {
//            callBack(NO, @"网络开小差啦,请尝试重新连接吧!");
//        } else {
//            callBack(NO, nil);
//            //            [MXRConstant showAlertNoNetwork];
//        }
//        
//    }];

}



/*
 *      将本地的唯一标识符和userid进行绑定
 */
- (void)associationUserId:(NSString *)userId withUniqueId:(NSString *)uniqueId withCallBack:(void(^)(BOOL isServerOK))callBack
{

    NSDictionary *param = @{@"userId":userId,
                            @"deviceId":uniqueId};
    
    NSString *urlString = ServiceURL_Base_device_info_bind;
    [MXRNetworkManager mxr_post:urlString parameters:param success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            if (callBack) callBack(YES);
        }else{
            if (callBack) callBack(NO);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (callBack) {
            callBack(NO);
        }
    }];
}

@end
