//
//  MXRBookSNSLoadDataGifRefreshFooter.m
//  huashida_home
//
//  Created by gxd on 16/10/9.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSLoadDataGifRefreshFooter.h"
#import "NSBundle+MJRefresh.h"

@implementation MXRBookSNSLoadDataGifRefreshFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
    
    // 初始化文字
    [self setTitle:@"" forState:MJRefreshStateIdle];
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshAutoFooterRefreshingText] forState:MJRefreshStateRefreshing];
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshAutoFooterNoMoreDataText] forState:MJRefreshStateNoMoreData];
}
@end
