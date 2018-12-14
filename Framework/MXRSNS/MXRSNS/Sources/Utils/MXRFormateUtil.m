//
//  MXRFormateUtil.m
//  huashida_home
//
//  Created by 周建顺 on 15/11/9.
//  Copyright © 2015年 mxrcorp. All rights reserved.
//

#import "MXRFormateUtil.h"
#import <UIKit/UIKit.h>

@implementation MXRFormateUtil

+(NSString*)mxrFormateNumberWithString:(NSString*)inputStr{
    
    if (inputStr.length>7) {
        CGFloat tempF= ([inputStr floatValue])/10000000;
        NSString *temp =[NSString stringWithFormat:@"%.1f",tempF] ;
        if (![temp hasSuffix:@"0"]) {
            inputStr = [NSString stringWithFormat:@"%.1f千万",tempF];
        }else{
            inputStr = [NSString stringWithFormat:@"%.0f千万",tempF];
        }
    }else if (inputStr.length>6){
        CGFloat tempF= ([inputStr floatValue])/1000000;
        NSString *temp =[NSString stringWithFormat:@"%.1f",tempF] ;
        if (![temp hasSuffix:@"0"]) {
            inputStr = [NSString stringWithFormat:@"%.1f百万",tempF];
        }else{
            inputStr = [NSString stringWithFormat:@"%.0f百万",tempF];
        }
        
    }else if (inputStr.length>4) {
        
        CGFloat tempF = ([inputStr floatValue])/10000;
        NSString *temp =[NSString stringWithFormat:@"%.1f",tempF] ;
        if (![temp hasSuffix:@"0"]) {
            inputStr = [NSString stringWithFormat:@"%.1f万",tempF];
        }else{
            inputStr = [NSString stringWithFormat:@"%.0f万",tempF];
        }
        
    }
    return inputStr;
}

@end
