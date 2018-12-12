//
//  MXRUserBehaviour.m
//  huashida_home
//
//  Created by MountainX on 2018/11/21.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRUserBehaviour.h"

@implementation MXRUserBehaviour

#pragma mark - Public Method
+ (MXRUserBehaviour *)currentUserBehaviour {
    MXRUserBehaviour *behaviour = [self fetchUserBehaviourWithUserID:[UserInformation modelInformation].userID];
    return behaviour;
}

+ (MXRUserBehaviour *)fetchUserBehaviourWithUserID:(NSString *)userID {
    MXRUserBehaviour *behaviour = (MXRUserBehaviour *)[MXRUserBehaviour searchSingleWithWhere:@{@"userID": autoString(userID)} orderBy:nil];
    if (!behaviour) {
        behaviour = [[MXRUserBehaviour alloc] init];
        behaviour.userID = autoString(userID);
        [behaviour updateToDB];
    }
    return behaviour;
}

#pragma mark - NSObject(LKModel)
+ (NSString *)getPrimaryKey {
    return @"userID";
}

+ (LKDBHelper *)getUsingLKDBHelper {
    static LKDBHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"UserBehaviour.db"];
        helper = [[LKDBHelper alloc] initWithDBPath:dbPath];
    });
    return helper;
}

#pragma mark - MXRModelDelegate
//+ (NSDictionary<NSString *,id> *)mxr_modelContainerPropertyGenericClass
//{
//    return @{@"unitBook"             : [MXRUnitPointReadingBookModel class],
//             };
//}
//
//+ (NSDictionary<NSString *,id> *)mxr_modelCustomPropertyMapper
//{
//    return @{@"extensionBookList" : @"extendBookList",
//             };
//}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    return [self mxr_modelCopy];
}

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self mxr_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self mxr_modelEncodeWithCoder:aCoder];
}

@end
