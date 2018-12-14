//
//  BUUtil.m
//  huashida_home
//
//  Created by 周建顺 on 15/6/3.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "BUUtil.h"
#import "MXRConstant.h"

@implementation BUUtil

+ (CGFloat)statusBarHeight
{
    if (IOS7_OR_LATER)
    {
        return STATUS_BAR_HEIGHT;
    }
    else
    {
        return 0;
    }
}

+ (CGFloat)navBarHeight
{
    if (IOS7_OR_LATER)
    {
        return 64;
    }
    else
    {
        return 44;
    }
}


+(CGFloat)mxrNaviBarHeight{
    return TOP_BAR_CONTENT_HEIGHT + [BUUtil statusBarHeight];
}


@end
