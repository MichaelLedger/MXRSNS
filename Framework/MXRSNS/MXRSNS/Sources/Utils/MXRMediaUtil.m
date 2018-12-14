//
//  MXRMediaUtil.m
//  huashida_home
//
//  Created by 周建顺 on 15/9/11.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "MXRMediaUtil.h"
#import <AVFoundation/AVFoundation.h>
//#import "MXRPromptView.h"
//#import "UnityAppController.h"
#import "MXRConstant.h"
#import "UIImage+Superposition.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#define TIPSUSERTHORS @"请到“设置-隐私”中，选择4D书城，开启相机和麦克风访问权限。"
@implementation MXRMediaUtil

+(BOOL)checkCameraAuthorizationWithPrompt{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
//        MXRPromptView *promp = [[MXRPromptView alloc] initWithTitle:MXRLocalizedString(@"PROMPT",@"提示") message:MXRLocalizedString(@"MXRMedia_Util_Video_Authority",@"您的相机没有开启，无法使用摄像头。请到{设置}-{隐私}-{相机}，选择4D书城开启相机即可。") delegate:nil cancelButtonTitle:MXRLocalizedString(@"SURE",@"确定") otherButtonTitle:nil];
////        [promp.cancelButton setTitleColor:MXRCOLOR_2FB8E2 forState:UIControlStateNormal];
//        [promp showInLastViewController];
        return NO;
    }
    
    return YES;
}

+(void)checkCameraVideoAuthorityCallBack:(void (^)(BOOL))callBack{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
        // authorized
        if (callBack) {
            callBack(YES);
        }
    } else if(status == AVAuthorizationStatusDenied || status ==AVAuthorizationStatusRestricted){
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString* tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:MXRLocalizedString(@"GET_IMAGE_LOCAL_Authority",  @"请在设备的\"设置-隐私-相机\"选项中，允许%@访问你的手机相机"), appName];
        // 展示提示语
//        MXRPromptView* alertView= [[MXRPromptView alloc]initWithTitle:MXRLocalizedString(@"MXBManager_Prompt", @"提示") message:tipTextWhenNoPhotosAuthorization delegate:nil cancelButtonTitle:MXRLocalizedString(@"PopMenuforEdit_Sure",@"好的") otherButtonTitle:nil];
//        [alertView showInLastViewController];
        if (callBack) {
            callBack(NO);
        }
    } else if(status == AVAuthorizationStatusNotDetermined){
        // not determined
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (callBack) {
                    callBack(granted);
                }
            });

        }];
    }
}

+(void)checkPhotoAlbumAuthorizationCallBack:(void (^)(BOOL isAuthority))callBack{
    if (IOS8_OR_LATER) {
        PHAuthorizationStatus status=[PHPhotoLibrary authorizationStatus];
        if (status ==PHAuthorizationStatusRestricted||status ==PHAuthorizationStatusDenied) {
            //无权限
//            MXRPromptView* promptView = [[MXRPromptView alloc] initWithTitle:nil message:MXRLocalizedString(@"MXRMedia_Util_PhotoAlbum",@"您的照片权限没有开启，无法读取本地相册，请到（设置）-（隐私）-（照片）中选择4D书城开启即可。") delegate:nil cancelButtonTitle:MXRLocalizedString(@"CaiDan_Know",@"我知道了") otherButtonTitle:nil];
//            [promptView showInLastViewController];
            if (callBack) {
                callBack(NO);
            }
        }else if(status==PHAuthorizationStatusNotDetermined){
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status==PHAuthorizationStatusAuthorized) {
                        if (callBack) {
                            callBack(YES);
                        }
                        
                    }else{
                        if (callBack) {
                            callBack(NO);
                        }
                    }
                });
               
                
            }];
        }else if (status==PHAuthorizationStatusAuthorized){
            if (callBack) {
                callBack(YES);
            }
        }
        
    }else{
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            //无权限
//            MXRPromptView* promptView = [[MXRPromptView alloc] initWithTitle:nil message:MXRLocalizedString(@"MXRMedia_Util_PhotoAlbum",@"您的照片权限没有开启，无法读取本地相册，请到（设置）-（隐私）-（照片）中选择4D书城开启即可。") delegate:nil cancelButtonTitle:MXRLocalizedString(@"CaiDan_Know",@"我知道了") otherButtonTitle:nil];
//            [promptView showInLastViewController];
            if (callBack) {
                callBack(NO);
            }
        }else if (author==ALAuthorizationStatusNotDetermined){
            if (callBack) {
                callBack(NO);
            }
        }else if (author==ALAuthorizationStatusAuthorized){
            if (callBack) {
                callBack(NO);
            }
        }
    }


}
+(void)checkCameraAndAudioAuthorizationWithPromptAndCallBack:(void (^)(BOOL))callBack{
    
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (!granted || authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
                    //无权限
//                    MXRPromptView *promp = [[MXRPromptView alloc] initWithTitle:MXRLocalizedString(@"PROMPT",@"提示") message:TIPSUSERTHORS delegate:nil cancelButtonTitle:MXRLocalizedString(@"SURE",@"确定") otherButtonTitle:nil];
//                    //        [promp.cancelButton setTitleColor:MXRCOLOR_2FB8E2 forState:UIControlStateNormal];
//                    [promp showInLastViewController];
                    if(callBack){
                        callBack(NO);
                    }
                    
                }else {
                    if (callBack) {
                        callBack(YES);
                    }
                    
                }
            });
        }];
    }else{
        //无权限
//        MXRPromptView *promp = [[MXRPromptView alloc] initWithTitle:MXRLocalizedString(@"PROMPT",@"提示") message:TIPSUSERTHORS delegate:nil cancelButtonTitle:MXRLocalizedString(@"SURE",@"确定") otherButtonTitle:nil];
//        //        [promp.cancelButton setTitleColor:MXRCOLOR_2FB8E2 forState:UIControlStateNormal];
//        [promp showInLastViewController];
        if (callBack) {
            callBack(NO);
        }
        
    }
    
}
//+(UIImage*)doSceenShot{
//    UIImage *screenShot = [UnityAppController snapshot];
//    UIImage *image = MXRIMAGE(@"icon_watermark");
//    UIImage *finalImg = [screenShot superpositionImage:image andScale:CGRectMake(screenShot.size.width*1.2 - image.size.width-10, screenShot.size.height-image.size.height*1.2-10, image.size.width*1.2, image.size.height*1.2)];
//    UIImageWriteToSavedPhotosAlbum(finalImg, self, NULL, NULL);
//    [MXRConstant showAlert:MXRLocalizedString(@"MXRBottomMultifuctionalView_Have_Save",@"已成功保存到本地相册") andShowTime:0.15];
//    return finalImg;
//}

+(UIImage*)doSceenShot:(UIImage*)screenShot{
    UIImage *image = MXRIMAGE(@"icon_watermark");
    UIImage *finalImg = [screenShot superpositionImage:image andScale:CGRectMake(screenShot.size.width - image.size.width*1.2-10, screenShot.size.height-image.size.height*1.2-10, image.size.width*1.2, image.size.height*1.2)];
    UIImageWriteToSavedPhotosAlbum(finalImg, self, NULL, NULL);
    return finalImg;
}

@end
