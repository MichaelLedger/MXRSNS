//
//  NSMutableURLRequest+Ex.h
//  huashida_home
//
//  Created by 周建顺 on 15/12/17.
//  Copyright © 2015年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface NSMutableURLRequest(Ex)

-(void)addMXRHeader;

- (void)addMXRHeaderAndForceUserIdToZero;


@end
//@interface AFHTTPRequestOperationManager(Ex)
//
//-(void)addMXRHeader;
//
//- (void)addMXRHeaderAndForceUserIdToZero;
//
//@end

@interface AFHTTPSessionManager(Ex)

-(void)addMXRHeader;

- (void)addMXRHeaderAndForceUserIdToZero;

@end
