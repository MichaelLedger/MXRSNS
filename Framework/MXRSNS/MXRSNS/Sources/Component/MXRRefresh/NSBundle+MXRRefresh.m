//
//  NSBundle+MXRRefresh.m
//  MXRSNS
//
//  Created by MountainX on 2018/12/12.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "NSBundle+MXRRefresh.h"
#import "MXRChatLoadMoreDataHeader.h"

@implementation NSBundle (MXRRefresh)
    
+ (instancetype)mxr_refreshBundle {
    static NSBundle *mxrRefreshBundle = nil;
    if (!mxrRefreshBundle) {
//        mxrRefreshBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"MXRRefresh" ofType:@"bundle"]];
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        mxrRefreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[MXRChatLoadMoreDataHeader class]] pathForResource:@"MXRRefresh" ofType:@"bundle"]];
    }
    return mxrRefreshBundle;
}

+ (NSArray<UIImage *> *)mxr_loadingImages {
    static NSArray <UIImage *> *loadingImages = nil;
    if (!loadingImages) {
        NSMutableArray *mutableImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=12; i++) {
            NSString *imageName = [NSString stringWithFormat:@"anim_chatloading%lu@2x", (unsigned long)i];
            UIImage *image = [[UIImage imageWithContentsOfFile:[[self mxr_refreshBundle] pathForResource:imageName ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            if (image) [mutableImages addObject:image];
        }
        loadingImages = [mutableImages copy];
    }
    return loadingImages;
}

@end
