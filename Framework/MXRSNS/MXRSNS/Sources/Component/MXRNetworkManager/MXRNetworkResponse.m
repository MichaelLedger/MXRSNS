//
//  MXRNetworkResponse.m
//  huashida_home
//
//  Created by Martin.liu on 2016/12/5.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRNetworkResponse.h"
#import "MXRBase64.h"
#import <objc/runtime.h>

@implementation MXRNetworkResponse

+ (NSDictionary<NSString *,id> *)mxr_modelCustomPropertyMapper
{
    return @{@"errCode"     :   @"Header.ErrCode",
             @"errMsg"      :   @"Header.ErrMsg",
             @"body"        :   @"Body"};
}

- (BOOL)isSuccess
{
    return [self.errCode isEqualToNumber:@0];
}

- (id)body
{
    NSString * decodeStr = [MXRBase64 decodeBase64WithString:_body];
    if (!decodeStr) {
        DERROR(@"bodyResult is nil");
        return nil;
    }
    if (![decodeStr isKindOfClass:[NSString class]]) {
        DERROR(@"bodyResult is not NSString class");
        return nil;
    }
    
    id dict = [NSJSONSerialization JSONObjectWithData:[decodeStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    return dict;
}

-(id)rawBody{
    return _body;
}

- (NSString *)responseBodyString
{
    NSString * decodeStr = [MXRBase64 decodeBase64WithString:_body];
    if (!decodeStr) {
        DERROR(@"bodyResult is nil");
        return nil;
    }
    if (![decodeStr isKindOfClass:[NSString class]]) {
        DERROR(@"bodyResult is not NSString class");
        return nil;
    }
    return decodeStr;
}

- (NSInteger)responseBodyInteger {
    NSString * decodeStr = [MXRBase64 decodeBase64WithString:_body];
    return [decodeStr integerValue];
}

@end
