//
//  NSBundle+MXRRefresh.h
//  MXRSNS
//
//  Created by MountainX on 2018/12/12.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (MXRRefresh)
    
+ (instancetype)mxr_refreshBundle;
    
+ (NSArray <UIImage *> *)mxr_loadingImages;

@end
