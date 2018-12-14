//
//  MXRNetworkManager.h
//  huashida_home
//
//  Created by Martin.liu on 2016/12/1.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

//#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MXRNetworkResponse.h"

typedef NS_ENUM(NSUInteger, MXRNetworkRequestType)
{
    
    MXRNetworkRequestTypeGet = 0,
    MXRNetworkRequestTypePost = 1,
    MXRNetworkRequestTypeDelete
};

typedef NS_ENUM(NSUInteger, MXRNetworkLoadingType) {
    MXRNetworkLoadingTypeNone = 0,
    MXRNetworkLoadingTypeNormal
};

typedef void (^MXRNetworkSuccess)(NSURLSessionTask *task, MXRNetworkResponse *response);
typedef void (^MXRNetworkFailure)(NSURLSessionTask *task, NSError *error);
typedef void (^MXRNetworkProgress)(CGFloat progress);

/**
 封装网络请求
 parameters 1.如果是NSString则不进行任何处理。
            2.对post请求的paramter不是NSString的都会进行梦想人加密
 @author Martin.liu
 */
@interface MXRNetworkManager : AFHTTPSessionManager




/**
 *  单例方法
 *
 *  @return 实例对象
 */
+ (instancetype)shareManager;



/**
 *  网络请求的类方法
 *
 *  @param type         get / post
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param success      请求成功的回调 responseObj未经过处理
 *  @param failure      请求失败的回调
 *  @param progress 进度
 */
+ (NSURLSessionDataTask *)mxr_requestType:(MXRNetworkRequestType)type
              urlString:(NSString *)urlString
             parameters:(id)parameters
               progress:(MXRNetworkProgress)progress
                success:(MXRNetworkSuccess)success
                failure:(MXRNetworkFailure)failure;


/**
 *  网络请求的类方法 get请求
 *
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param success      请求成功的回调 responseObj未经过处理
 *  @param failure      请求失败的回调
 *  @param progress     进度
 */
+ (NSURLSessionDataTask *)mxr_get:(NSString *)urlString
     parameters:(id)parameters
       progress:(MXRNetworkProgress)progress
        success:(MXRNetworkSuccess)success
        failure:(MXRNetworkFailure)failure;

/**
 *  网络请求的类方法 get请求
 *
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param success      请求成功的回调 responseObj未经过处理
 *  @param failure      请求失败的回调
 */
+ (NSURLSessionDataTask *)mxr_get:(NSString *)urlString
     parameters:(id)parameters
        success:(MXRNetworkSuccess)success
        failure:(MXRNetworkFailure)failure;

/**
 *  网络请求的类方法 post请求
 *
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param success      请求成功的回调 responseObj未经过处理
 *  @param failure      请求失败的回调
 *  @param progress     进度
 */
+ (NSURLSessionDataTask *)mxr_post:(NSString *)urlString
      parameters:(id)parameters
        progress:(MXRNetworkProgress)progress
         success:(MXRNetworkSuccess)success
         failure:(MXRNetworkFailure)failure;

/**
 *  网络请求的类方法 post请求
 *
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param success      请求成功的回调 responseObj未经过处理
 *  @param failure      请求失败的回调

 */
+ (NSURLSessionDataTask *)mxr_post:(NSString *)urlString
      parameters:(id)parameters
         success:(MXRNetworkSuccess)success
         failure:(MXRNetworkFailure)failure;

/**
 *  网络请求的类方法 delete请求
 *
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param success      请求成功的回调 responseObj未经过处理
 *  @param failure      请求失败的回调
 
 */
+ (NSURLSessionDataTask *)mxr_delete:(NSString *)urlString
        parameters:(id)parameters
           success:(MXRNetworkSuccess)success
           failure:(MXRNetworkFailure)failure;

/**
 *  网络请求的类方法
 *
 *  @param request      request参数
 *  @param success      请求成功的回调 responseObj未经过处理
 *  @param failure      请求失败的回调
 */
+ (NSURLSessionDataTask *)mxr_request:(NSURLRequest*)request
            success:(void (^)(NSURLResponse *URLresponse, id responseObject))success
            failure:(void (^)(NSURLResponse *URLresponse, id error))failure;

/**
 *  网络请求的类方法
 *
 *  @param request      request参数
 *  @param fromData     上传的二进制对象
 *  @param progress     上传文件的完成情况回调
 *  @param success      请求成功的回调
 *  @param failure      请求失败的回调
 */
+ (NSURLSessionUploadTask *)mxr_uploadRequest:(NSURLRequest *)request
                 fromData:(NSData *)bodyData
                 progress:(MXRNetworkProgress)progress
                  success:(void (^)(NSURLResponse *URLResponse, id response))success
                  failure:(void (^)(NSURLResponse *URLResponse, NSError *error))failure;


/**
 网络请求是否可到达
 
 @return YES可达到，NO不可到达
 */
+(BOOL)mxr_reachable;

/**
 Whether or not the network is currently reachable via WWAN.
 */
+(BOOL)mxr_isReachableViaWWAN;

@end
