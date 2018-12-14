//
//  MXRUtil.m
//  huashida_home
//
//  Created by 周建顺 on 15/7/1.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "MXRCGUtil.h"

@implementation MXRCGUtil
#pragma mark 两点之间的距离
+(float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end{
    
    float distance;
    
    //下面就是高中的数学，不详细解释了
    
    CGFloat xDist = (end.x - start.x);
    
    CGFloat yDist = (end.y - start.y);
    
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    
    return distance;
    
}




@end
