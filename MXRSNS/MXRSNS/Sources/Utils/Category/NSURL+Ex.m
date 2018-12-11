//
//  NSURL+Ex.m
//  huashida_home
//
//  Created by 周建顺 on 15/8/31.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "NSURL+Ex.h"
#import "NSString+Ex.h"

@implementation NSURL(Ex)

+(instancetype)urlWithUrlSting:(NSString *)URLString{
    NSString *tempStr;
    NSURL *url;
    
    if ([URLString hasPrefix:@"http://"] || [URLString hasPrefix:@"https://"]) {
        //url = [NSURL URLWithString:[self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //url = [NSURL URLWithString:self.urlStr];
        tempStr = URLString;
    }else{
        
        tempStr = [NSString stringWithFormat:@"http://%@", URLString];
        //url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", self.urlStr]];
    }
    
    if ([NSString isContainsChinese:tempStr]) {
        url =[NSURL URLWithString:[tempStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else{
        url = [NSURL URLWithString:tempStr];
    }
    return url;
}

- (instancetype)standardURLEncode {
    return self;
}

@end
