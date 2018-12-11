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
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=12; i++) {
        NSString *imageName = [NSString stringWithFormat:@"anim_chatloading%lu.png", (unsigned long)i];
        UIImage *image = MXRIMAGE(imageName);
        if (image) {
            [idleImages addObject:image];
        }
    }
    if (idleImages.count>0) {
        [self setImages:idleImages forState:MJRefreshStatePulling];
        [self setImages:idleImages forState:MJRefreshStateRefreshing];
    }
}
@end
