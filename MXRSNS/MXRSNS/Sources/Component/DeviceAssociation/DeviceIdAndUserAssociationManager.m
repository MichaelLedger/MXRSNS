//
//  DeviceIdAndUserAssociationManager.m
//  huashida_home
//
//  Created by yanbin on 15/4/24.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "DeviceIdAndUserAssociationManager.h"
#import "MXRBase64.h"
#import "GlobalFunction.h"
#define Association_File_Name @"DeviceIdAndUserAssociation.plist"

@implementation DeviceIdAndUserAssociationManager{
    NSMutableDictionary * associationTable; // key : deviceiD obj : userId (全是加密的数据)
}
+(id)sharedInstance
{
    static DeviceIdAndUserAssociationManager * dauam = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dauam = [[DeviceIdAndUserAssociationManager alloc] init];
    });
    return dauam;
}

- (NSString *)filePathOfDB
{
    NSString * document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString * filePath = [document stringByAppendingFormat:@"/%@",Association_File_Name];
    return filePath;
}
- (id)init{
    self = [super init];
    if ( self ) {
        NSString * filePath = [self filePathOfDB];
        
        if ( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
            associationTable = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
            if ( !associationTable ) {
                associationTable = [[NSMutableDictionary alloc] init];
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            }
        } else {
            associationTable = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}
- (void)addAssociationOfUser:(NSString *)userId withDeviceId:(NSString *)deviceId
{
    NSString * encodeUserId     = [MXRBase64 encodeBase64WithString:userId];
    [associationTable setObject:encodeUserId forKey:deviceId];
    
    NSString * filePath = [self filePathOfDB];
    
    [associationTable writeToFile:filePath atomically:YES];
}
- (NSString *)userIdAssociatedWithDeviceId:(NSString *)deviceId andUserId:(NSString *)uId
{
  
    __block NSString * encodeUserid;
    /**
      先判断当前uId是否已经绑定设备id
     */
    [[associationTable allValues] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[MXRBase64 decodeBase64WithString:obj] isEqualToString:uId]) {
            encodeUserid = obj;
            *stop = YES;
        }
    }];
    
    if (encodeUserid) {
        NSString * userId   = [MXRBase64 decodeBase64WithString:encodeUserid];
        if ( userId.length == 0 ) {
            return nil;
        }else{
            return userId;
        }
    }
    if ( deviceId.length == 0 ) {
        return  MXRLocalizedString(@"DeviceIdAndUserAssociationManager_Not_nil",@"deviceid不能为空");
    }
        encodeUserid = [associationTable objectForKey:deviceId];
    if ( encodeUserid.length == 0 ) {
        return nil;
    }
    NSString * userId   = [MXRBase64 decodeBase64WithString:encodeUserid];
    if ( userId.length == 0 ) {
        return nil;
    }
   
    return userId;
}
//- (BOOL)userIdIsAssociatedWithDeviceId:(NSString *)uId{
//
//    __block BOOL isAssociation = NO;
//    [[associationTable allValues] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([[MXRBase64 decodeBase64WithString:obj] isEqualToString:uId]) {
//            isAssociation = YES;
//            *stop = YES;
//        }
//    }];
//    return isAssociation;
//}
- (NSString *)getCurrentUserIdAssicationDeviceId{

    NSString * currentUserId = [UserInformation modelInformation].userID;
    /**
     先判断当前uId是否已经绑定设备id
     */
    __block NSString * deviceId;
    [associationTable enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([[MXRBase64 decodeBase64WithString:obj] isEqualToString:currentUserId]) {
            deviceId = key;
            *stop = YES;
        }
    }];

    if (deviceId) {
        
    }else{
        deviceId = getVisitorUniqueId();
    }
    return deviceId;
}
@end
