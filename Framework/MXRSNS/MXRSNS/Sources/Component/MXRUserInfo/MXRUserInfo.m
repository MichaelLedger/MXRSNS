//
//  MXRUserInfo.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/8/27.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRUserInfo.h"
#import "NSObject+MXRModel.h"
//#import "MXRGlobalUtil.h"

@interface MXRUserInfo ()

@end

@implementation MXRUserInfo

+ (NSString *)getPrimaryKey
{
    return @"userID";
}

+ (instancetype)sharedInstance
{
    static MXRUserInfo *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
        if ([userID isKindOfClass:[NSString class]] || userID.length == 0) {
            userID = @"0";
        }
        MXRUserInfo *userInfo = [[MXRUserInfo getUsingLKDBHelper] searchSingle:[MXRUserInfo class] where:@{@"userID":userID} orderBy:nil];
        if ([userInfo isKindOfClass:[MXRUserInfo class]]) {
            instance = userInfo;
        }
        else
        {
            instance = [[self.class alloc] init];
            instance.userID = userID;
        }
        
    });
    return instance;
}

- (void)compatibleOldVersion
{
    [self mxr_modelSetWithJSON:nil];
}


@end
