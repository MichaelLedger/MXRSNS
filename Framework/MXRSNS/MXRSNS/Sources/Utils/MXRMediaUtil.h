//
//  MXRMediaUtil.h
//  huashida_home
//
//  Created by 周建顺 on 15/9/11.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRMediaUtil : NSObject

+(BOOL)checkCameraAuthorizationWithPrompt;
//检测相册权限
+(void)checkPhotoAlbumAuthorizationCallBack:(void(^)(BOOL isAuthority))callBack;
//检测摄像头权限
+(void)checkCameraVideoAuthorityCallBack:(void(^)(BOOL isAuthority))callBack;
//检测音频权限
+(void)checkCameraAndAudioAuthorizationWithPromptAndCallBack:(void(^)(BOOL isAuthor))callBack;
//截屏
+(UIImage*)doSceenShot;
+(UIImage*)doSceenShot:(UIImage*)screenShot;

@end
