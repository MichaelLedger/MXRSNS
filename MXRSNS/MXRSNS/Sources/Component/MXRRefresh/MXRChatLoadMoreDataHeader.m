//
//  MXRChatLoadMoreDataHeader.m
//  huashida_home
//
//  Created by lj on 16/9/6.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRChatLoadMoreDataHeader.h"

@implementation MXRChatLoadMoreDataHeader
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    NSArray *idleImages = [NSBundle mxr_loadingImages];
    if (idleImages.count>0) {
        [self setImages:idleImages forState:MJRefreshStatePulling];
        [self setImages:idleImages forState:MJRefreshStateRefreshing];
    }
}
@end
