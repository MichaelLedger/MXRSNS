//
//  MXRBlackListModel.m
//  huashida_home
//
//  Created by MountainX on 2018/3/13.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSNSBlackListModel.h"
#import "NSObject+LKDBHelper.h"

@implementation MXRSNSBlackListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

//+ (NSString *)getPrimaryKey {
//    return @"momentID";
//}

+ (NSArray *)getPrimaryKeyUnionArray {
    return @[@"userID", @"momentID"];
}

@end
