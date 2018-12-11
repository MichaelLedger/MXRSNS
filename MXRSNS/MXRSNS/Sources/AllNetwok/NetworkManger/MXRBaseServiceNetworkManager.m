//
//  MXRBaseServiceNetworkManager.m
//  huashida_home
//
//  Created by 周建顺 on 15/8/6.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "MXRBaseServiceNetworkManager.h"
#import "ALLNetworkURL.h"
#import "AFNetworking.h"
//#import "MXRBaseGiftCoinNum.h"
#import "GlobalFunction.h"
//#import "MXRTabTemplate.h"
#import "NSMutableURLRequest+Ex.h"
#import "MXRJsonUtil.h"
//#import "MXRCheckBookStatusModel.h"
#import "MXRNetworkManager.h"
#import "MXRNetworkResponse.h"
//#import "MXRMyDiyBookManager.h"

@interface MXRBaseServiceNetworkManager()
@end


@implementation MXRBaseServiceNetworkManager

+(instancetype)defaultInstance{
    static MXRBaseServiceNetworkManager *instance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[MXRBaseServiceNetworkManager alloc] init];
    });
    return instance;
}

#pragma mark 是否隐藏内容
- (void)requestIsShowHiddenThingsOrNotWithCallback:(defaultCallback)callback{
    
    [MXRNetworkManager mxr_get:ServiceURL_BASE_SHOWTHING parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess&&response.body) {
            NSDictionary *isShowDict = [(NSDictionary *)response.body objectForKey:@"showOrHideFunction"];
            callback(MXRServerStatusSuccess,isShowDict,nil);
            
        }else{
            callback(MXRServerStatusFail,nil,response.errMsg);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
         callback(MXRServerStatusFail,nil,nil);
    }];
    

    
}
#pragma mark 请求阅读时长
-(void)requestReadTimeWithCallback:(defaultCallback)callback{
    
    [MXRNetworkManager mxr_get:ServiceURL_BASE_GIFT_READ_TIME parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess&&response.body) {
            NSNumber *readingDuration = [(NSDictionary *)response.body objectForKey:@"ReadingDuration"];
            callback(MXRServerStatusSuccess,readingDuration,nil);
            
        }else{
            callback(MXRServerStatusFail,nil,response.errMsg);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        callback(MXRServerStatusNetworkError,nil,nil);
    }];

    
}

#pragma mark - 更新deviceUUID
//{“deviceID”:””, deviceDesc:””,” deviceUUID”:””}
-(void)updateDeviceUUID:(NSString*)deviceUUID deviceID:(NSString*)deviceID deviceDesc:(NSString*)deviceDesc Success:(successCallback)success failure:(failureCallback)failure{
    NSDictionary *parms = @{@"deviceID":autoString(deviceID),
                           @"deviceDesc":autoString(deviceDesc),
                           @"deviceUUID":autoString(deviceUUID)};
  
    NSString *urlString = ServiceURL_BASE_UPDATE_DEVICEUUID;
    [MXRNetworkManager mxr_post:urlString parameters:parms success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            if (success) success(@YES);
        }else{
            if (failure) failure(MXRServerStatusFail,response.errMsg);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(MXRServerStatusNetworkError,error);
        }
    }];
}

@end
