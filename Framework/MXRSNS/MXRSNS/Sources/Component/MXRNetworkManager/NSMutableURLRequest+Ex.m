//
//  NSMutableURLRequest+Ex.m
//  huashida_home
//
//  Created by 周建顺 on 15/12/17.
//  Copyright © 2015年 mxrcorp. All rights reserved.
//

#import "NSMutableURLRequest+Ex.h"
#import "MXRHeader.h"


NSString  * const MXR_HEADERKEY           = @"mxr-key";


@implementation NSMutableURLRequest(Ex)

//包头里面包含基本的参数
-(void)addMXRHeader{
    [self setValue:[MXRHeader createHeader] forHTTPHeaderField:MXR_HEADERKEY];
}

//包头里面包含基本的参数,userid强制修改为0
- (void)addMXRHeaderAndForceUserIdToZero {
    [self setValue:[MXRHeader createHeaderAndForceUserIdToZero] forHTTPHeaderField:MXR_HEADERKEY];
}

@end
//@implementation AFHTTPRequestOperationManager(Ex)
//
//-(void)addMXRHeader{
//    [self.requestSerializer setValue:[MXRHeader createHeader] forHTTPHeaderField:MXR_HEADERKEY];
//}
//
////包头里面包含基本的参数,userid强制修改为0
//- (void)addMXRHeaderAndForceUserIdToZero {
//    [self.requestSerializer setValue:[MXRHeader createHeaderAndForceUserIdToZero] forHTTPHeaderField:MXR_HEADERKEY];
//}
//
//@end

@implementation AFHTTPSessionManager(Ex)

-(void)addMXRHeader{
    [self.requestSerializer setValue:[MXRHeader createHeader] forHTTPHeaderField:MXR_HEADERKEY];
}

//包头里面包含基本的参数,userid强制修改为0
- (void)addMXRHeaderAndForceUserIdToZero {
    [self.requestSerializer setValue:[MXRHeader createHeaderAndForceUserIdToZero] forHTTPHeaderField:MXR_HEADERKEY];
}

@end
