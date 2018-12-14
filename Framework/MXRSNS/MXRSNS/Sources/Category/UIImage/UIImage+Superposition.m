//
//  UIImage+Superposition.m
//  huashida_home
//
//  Created by zhenyu.wang on 15-4-2.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "UIImage+Superposition.h"

@implementation UIImage (Superposition)
-(UIImage *)superpositionImage:(UIImage *)exImage andScale:(CGRect)exRect
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    CGSize finalSize = CGSizeMake(self.size.width*scale, self.size.height*scale);
    UIGraphicsBeginImageContext(finalSize);
    [self drawInRect:CGRectMake(0, 0,finalSize.width,finalSize.height)];
    [exImage drawInRect:CGRectMake(exRect.origin.x*scale, exRect.origin.y*scale, exRect.size.width*scale, exRect.size.height*scale)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;

}
@end
