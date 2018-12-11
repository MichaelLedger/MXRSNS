//
//  MXRNetworkResponse.h
//  huashida_home
//
//  Created by Martin.liu on 2016/12/5.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MXRModel.h"


typedef enum : NSUInteger {
    MXRServerStatusSuccess, // 返回成功
    MXRServerStatusFail, // 返回失败
    MXRServerStatusNetworkError, // 网络访问不通
    MXRServerStatusNetworkCanceled,//   取消的
} MXRServerStatus;

typedef void(^defaultCallback)(MXRServerStatus status, id result,id error);
typedef void(^defaultBack)(MXRServerStatus status, BOOL isOk);
typedef void(^callback)(MXRServerStatus status);
typedef void(^successCallback)(id result);
typedef void(^failureCallback)(MXRServerStatus status, id result);
typedef NSString*(^myCallback)(MXRServerStatus status, id result);

@interface MXRNetworkResponse : NSObject<MXRModelDelegate>
@property (nonatomic, strong)       NSNumber    *errCode;
@property (nonatomic, copy)         NSString    *errMsg;
@property (nonatomic, readonly)     BOOL        isSuccess;
@property (nonatomic, copy)         id          body;
@property (nonatomic, copy)         NSString    *responseBodyString;
@property (nonatomic, assign)       NSInteger   responseBodyInteger;

/**
 原始的body
 */
@property (nonatomic, readonly) id rawBody;
@end
