//
//  MXRNetworkManager.m
//  huashida_home
//
//  Created by Martin.liu on 2016/12/1.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRNetworkManager.h"
#import "NSMutableURLRequest+Ex.h"
#import "MXRBase64.h"
#import "AFNetworkReachabilityManager.h"
//#import "MXRUserSettingsManager.h"
#import <AlicloudMobileAnalitics/ALBBMAN.h>
//#import "MXRVersionUpdateManager.h"

@implementation MXRNetworkManager

#pragma mark - shareManager
+(instancetype)shareManager
{
    static MXRNetworkManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:nil];
    });
    
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) return nil;
  //  self.requestSerializer = [AFHTTPRequestSerializer serializer];
  //  self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    /**设置请求超时时间*/
    self.requestSerializer.timeoutInterval = 15;
    
    /**复杂的参数类型 需要使用json传值-设置请求内容的类型*/
    [self.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //解决304的问题
    [self.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    // 将DELETE请求的参数放在httpBody中
    self.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
    // post 对paramter进行加密，加工放入request的httpbody前的string格式
    [self.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        if ([parameters isKindOfClass:[NSString class]]) {
            return parameters;
        }
       
        if ([[request.HTTPMethod uppercaseString] isEqualToString:@"POST"]||[[request.HTTPMethod uppercaseString] isEqualToString:@"DELETE"])
        {
            NSString *paramString = [parameters mxr_modelToJSONString];
            NSString *decodeParamString = [MXRBase64 encodeBase64WithString:paramString];
            return decodeParamString;
        }else if([[request.HTTPMethod uppercaseString] isEqualToString:@"GET"] ){
            if ([parameters isKindOfClass:[NSDictionary class]]) {
                return AFQueryStringFromParameters(parameters);
            }
            return AFQueryStringFromParameters([parameters mxr_modelToJSONObject]);
        }else {
            if ([parameters isKindOfClass:[NSDictionary class]]) {
                return AFQueryStringFromParameters(parameters);
            }
            return AFQueryStringFromParameters([parameters mxr_modelToJSONObject]);
        }
        
        return parameters;
    }];
    /**MXR定制*/
    [self addMXRHeader];
    
    /**设置接受的类型*/
    [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
    
    return self;
}


+(void)_mxr_alert_failure:(NSString*)urlString{
    [[self shareManager] _mxr_alert_failure:urlString];
}

- (void)_mxr_alert_failure:(NSString *)urlString{
//    /*未知域名和正式域名下不弹窗提醒;可设置是否提醒，可免去多次弹窗 by MT.X*/
//    if([[MXRUserSettingsManager defaultManager] getServerType] != MXRARServerTypeOuterNetFormal && [[MXRUserSettingsManager defaultManager] getServerType] != MXRARServerTypeInnerUnknow && WhetherShowNetworkFailAlert){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"服务请求失败"message:urlString delegate:nil cancelButtonTitle: nil otherButtonTitles:MXRLocalizedString(@"CANCEL", @"取消"), nil];
//        [alertView show];
//    }
}

- (NSURLSessionDataTask *)_mxr_requestType:(MXRNetworkRequestType)type
                                 urlString:(NSString *)urlString
                                parameters:(id)parameters
                                  progress:(MXRNetworkProgress)progress
                                   success:(MXRNetworkSuccess)success
                                   failure:(MXRNetworkFailure)failure
                               loadingType:(MXRNetworkLoadingType)loadingType     // 备用
                                    inView:(UIView *)inView
{
    [self addMXRHeader];
    
    NSURLSessionDataTask *task;
    ALBBMANNetworkHitBuilder *builder = [[ALBBMANNetworkHitBuilder alloc] initWithHost:task.originalRequest.URL.host method:task.originalRequest.HTTPMethod];
    __weak __typeof(self) weakSelf = self;
    switch (type) {
        case MXRNetworkRequestTypeGet:
        {
            task = [self GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progress) progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                [strongSelf _alynasisRequestEndWithTask:task builder:builder];
                if (success) {
                    MXRNetworkResponse *responce = [MXRNetworkResponse mxr_modelWithDictionary:responseObject];
//                    [[MXRVersionUpdateManager sharedManager] checkUpdateWithResponse:responce];
                    success(task, responce);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if(error)
                {
                    [strongSelf _alynasisRequestEndWithError:error builder:builder];
                }
                if (failure) {
                    [self _mxr_alert_failure:urlString];
                    failure(task, error);
                }
            }];
        }
            break;
        case MXRNetworkRequestTypePost:
        {
            task = [self POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progress) progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                [strongSelf _alynasisRequestEndWithTask:task builder:builder];
                if (success) {
                    MXRNetworkResponse *responce = [MXRNetworkResponse mxr_modelWithDictionary:responseObject];
//                    [[MXRVersionUpdateManager sharedManager] checkUpdateWithResponse:responce];
                    success(task, responce);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if(error)
                {
                    [strongSelf _alynasisRequestEndWithError:error builder:builder];
                }
                if (failure) {
                    [self _mxr_alert_failure:urlString];
                    failure(task, error);
                }
            }];
        }
            break;
        case MXRNetworkRequestTypeDelete:
        {
            task = [self DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                [strongSelf _alynasisRequestEndWithTask:task builder:builder];
                if (success) {
                    MXRNetworkResponse *responce = [MXRNetworkResponse mxr_modelWithDictionary:responseObject];
//                    [[MXRVersionUpdateManager sharedManager] checkUpdateWithResponse:responce];
                    success(task, responce);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if(error)
                {
                    [strongSelf _alynasisRequestEndWithError:error builder:builder];
                }
                if (failure) {
                    [self _mxr_alert_failure:urlString];
                    failure(task, error);
                }
            }];
        }
            break;
    }
    if (task) {
        [builder requestStart];
    }
    return task;
}

+ (NSURLSessionDataTask *)_mxr_requestType:(MXRNetworkRequestType)type
               urlString:(NSString *)urlString
              parameters:(id)parameters
                progress:(MXRNetworkProgress)progress
                 success:(MXRNetworkSuccess)success
                 failure:(MXRNetworkFailure)failure
             loadingType:(MXRNetworkLoadingType)loadingType     // 备用
                  inView:(UIView *)inView                       // 备用
{
    return [[self shareManager] _mxr_requestType:type urlString:urlString parameters:parameters progress:progress success:success failure:failure loadingType:loadingType inView:inView];
}

+ (NSURLSessionDataTask *)_mxr_requestType:(MXRNetworkRequestType)type
               urlString:(NSString *)urlString
              parameters:(id)parameters
                progress:(MXRNetworkProgress)progress
                 success:(MXRNetworkSuccess)success
                 failure:(MXRNetworkFailure)failure
{
   return [self _mxr_requestType:type
                 urlString:urlString
                parameters:parameters
                  progress:progress
                   success:success
                   failure:failure
               loadingType:MXRNetworkLoadingTypeNone
                    inView:nil];
}

+ (NSURLSessionDataTask *)mxr_requestType:(MXRNetworkRequestType)type
              urlString:(NSString *)urlString
             parameters:(id)parameters
               progress:(MXRNetworkProgress)progress
                success:(MXRNetworkSuccess)success
                failure:(MXRNetworkFailure)failure
{
  return [self _mxr_requestType:type
                 urlString:urlString
                parameters:parameters
                  progress:progress
                   success:success
                   failure:failure];
}

+ (NSURLSessionDataTask *)mxr_get:(NSString *)urlString
     parameters:(id)parameters
       progress:(MXRNetworkProgress)progress
        success:(MXRNetworkSuccess)success
        failure:(MXRNetworkFailure)failure
{
  return [self _mxr_requestType:MXRNetworkRequestTypeGet
                 urlString:urlString parameters:parameters
                  progress:progress
                   success:success
                   failure:failure];
}

+ (NSURLSessionDataTask *)mxr_get:(NSString *)urlString
     parameters:(id)parameters
        success:(MXRNetworkSuccess)success
        failure:(MXRNetworkFailure)failure
{
    return [self _mxr_requestType:MXRNetworkRequestTypeGet
                 urlString:urlString
                parameters:parameters
                  progress:nil
                   success:success
                   failure:failure];
}

+ (NSURLSessionDataTask *)mxr_post:(NSString *)urlString
      parameters:(id)parameters
        progress:(MXRNetworkProgress)progress
         success:(MXRNetworkSuccess)success
         failure:(MXRNetworkFailure)failure
{
    return [self _mxr_requestType:MXRNetworkRequestTypePost
                 urlString:urlString
                parameters:parameters
                  progress:progress
                   success:success
                   failure:failure];
}

+ (NSURLSessionDataTask *)mxr_post:(NSString *)urlString
      parameters:(id)parameters
         success:(MXRNetworkSuccess)success
         failure:(MXRNetworkFailure)failure
{
   return [self _mxr_requestType:MXRNetworkRequestTypePost
                 urlString:urlString
                parameters:parameters
                  progress:nil
                   success:success
                   failure:failure];
}


/**
 delete 请求

 @param urlString 请求url
 @param parameters 参数，拼装在body中
 @param success 成功
 @param failure 失败
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)mxr_delete:(NSString *)urlString
        parameters:(id)parameters
           success:(MXRNetworkSuccess)success
           failure:(MXRNetworkFailure)failure
{
    return [self _mxr_requestType:MXRNetworkRequestTypeDelete
                 urlString:urlString
                parameters:parameters
                  progress:nil
                   success:success
                   failure:failure];
}

- (NSURLSessionDataTask*)mxr_request:(NSURLRequest *)request
                             success:(void (^)(NSURLResponse *, id))success
                             failure:(void (^)(NSURLResponse *, id))failure
{
    ALBBMANNetworkHitBuilder *builder = nil;
    if (request) {
        builder = [[ALBBMANNetworkHitBuilder alloc] initWithHost:request.URL.host method:request.HTTPMethod];
        [builder requestStart];
    }
    __weak __typeof(self) weakSelf = self;
    [self addMXRHeader];
    NSURLSessionDataTask* datatask = nil;
    datatask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            [strongSelf _alynasisRequestEndWithError:error builder:builder];
            if (failure) {
                [self _mxr_alert_failure:[[request URL] absoluteString]];
                failure(response, error);
            }
        }
        else
        {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            [strongSelf _alynasisRequestEndWithTask:datatask builder:builder];
            if (success) {
                MXRNetworkResponse *mxrResponce = [MXRNetworkResponse mxr_modelWithDictionary:responseObject];
//                [[MXRVersionUpdateManager sharedManager] checkUpdateWithResponse:mxrResponce];
                success(response, responseObject);
            }
        }
    }];
    [datatask resume];
    
    return datatask;
}

+ (NSURLSessionDataTask*)mxr_request:(NSURLRequest *)request
            success:(void (^)(NSURLResponse *, id))success
            failure:(void (^)(NSURLResponse *, id))failure
{
    return [[self shareManager] mxr_request:request success:success failure:failure];
}

+ (NSURLSessionUploadTask *)mxr_uploadRequest:(NSURLRequest *)request
                 fromData:(NSData *)bodyData
                 progress:(MXRNetworkProgress)progress
                  success:(void (^)(NSURLResponse *, id))success
                  failure:(void (^)(NSURLResponse *, NSError *))failure
{
    NSURLSessionUploadTask *uploadTask = [[self shareManager] uploadTaskWithRequest:request fromData:bodyData progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) progress(uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                [self _mxr_alert_failure:[[request URL] absoluteString]];
                failure(response, error);
            }
        }
        else
        {
            if (success) {
                MXRNetworkResponse *responseModel = [MXRNetworkResponse mxr_modelWithDictionary:responseObject];
//                [[MXRVersionUpdateManager sharedManager] checkUpdateWithResponse:responseModel];
                success(response,responseModel);
            }
        }
        
    }];
    [uploadTask resume];
    
    return uploadTask;
}


/**
 网络请求是否可到达

 @return YES可达到，NO不可到达
 */
+(BOOL)mxr_reachable{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)mxr_isReachableViaWWAN
{
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWWAN];
}

- (void)_alynasisRequestEndWithError:(NSError *)error builder:(ALBBMANNetworkHitBuilder *)builder
{
    if (!builder) return;
    ALBBMANNetworkError *networkError = [[ALBBMANNetworkError alloc] initWithErrorCode:[NSString stringWithFormat:@"%ld", (long)error.code]];
    [networkError setProperty:@"errMsg" value:error.localizedDescription ?: @"errMsg"];
//    [networkError setProperty:@"wifiip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: @"wifiip"];
//    [networkError setProperty:@"cellip" value:[UIDevice currentDevice].mar_ipAddressCell ?: @"cellip"];
//    [networkError setProperty:@"ip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: ([UIDevice currentDevice].mar_ipAddressCell ?: @"ip")];
    [builder requestEndWithError:networkError];
    // 组装日志并发送
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    [tracker send:[builder build]];
}

- (void)_alynasisRequestEndWithTask:(NSURLSessionDataTask *)task builder:(ALBBMANNetworkHitBuilder *)builder
{
    if (!builder) return;
    [builder requestEndWithBytes:task.countOfBytesReceived];
//    [builder setProperty:@"wifiip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: @"wifiip"];
//    [builder setProperty:@"cellip" value:[UIDevice currentDevice].mar_ipAddressCell ?: @"cellip"];
//    [builder setProperty:@"ip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: ([UIDevice currentDevice].mar_ipAddressCell ?: @"ip")];
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    [tracker send:[builder build]];
}

+ (void)_alynasisRequestEndWithError:(NSError *)error builder:(ALBBMANNetworkHitBuilder *)builder
{
    if (!builder) return;
    ALBBMANNetworkError *networkError = [[ALBBMANNetworkError alloc] initWithErrorCode:[NSString stringWithFormat:@"%ld", (long)error.code]];
    [networkError setProperty:@"errMsg" value:error.localizedDescription ?: @"errMsg"];
    //    [networkError setProperty:@"wifiip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: @"wifiip"];
    //    [networkError setProperty:@"cellip" value:[UIDevice currentDevice].mar_ipAddressCell ?: @"cellip"];
    //    [networkError setProperty:@"ip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: ([UIDevice currentDevice].mar_ipAddressCell ?: @"ip")];
    [builder requestEndWithError:networkError];
    // 组装日志并发送
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    [tracker send:[builder build]];
}

+ (void)_alynasisRequestEndWithTask:(NSURLSessionDataTask *)task builder:(ALBBMANNetworkHitBuilder *)builder
{
    if (!builder) return;
    [builder requestEndWithBytes:task.countOfBytesReceived];
    //    [builder setProperty:@"wifiip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: @"wifiip"];
    //    [builder setProperty:@"cellip" value:[UIDevice currentDevice].mar_ipAddressCell ?: @"cellip"];
    //    [builder setProperty:@"ip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: ([UIDevice currentDevice].mar_ipAddressCell ?: @"ip")];
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    [tracker send:[builder build]];
}

@end
