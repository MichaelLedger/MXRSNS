//
//  NSURL+Ex.h
//  huashida_home
//
//  Created by 周建顺 on 15/8/31.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL(Ex)

+(instancetype)urlWithUrlSting:(NSString*)string;

- (instancetype)standardURLEncode;

@end
