//
//  MXRBaseDBModel.m
//  huashida_home
//
//  Created by Martin.liu on 2016/12/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBaseDBModel.h"

#define MXRBaseDBName @"MessageRecord.sqlite"

@implementation MXRBaseDBModel

+ (LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:MXRBaseDBName];
        db = [[LKDBHelper alloc] initWithDBPath:dbPath];
    });
    return db;
}

- (NSArray<MXRBaseDBModel *> *)getAllModel
{
    NSMutableArray *allModel = [[self.class getUsingLKDBHelper] search:[self class] where:nil orderBy:nil offset:0 count:0];
    return allModel;
}

@end


