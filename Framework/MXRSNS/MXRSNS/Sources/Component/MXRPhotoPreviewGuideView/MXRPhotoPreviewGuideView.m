//
//  MXRPhotoPreviewGuideView.m
//  huashida_home
//
//  Created by 周建顺 on 2016/12/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPhotoPreviewGuideView.h"
#import "MXRUserSettingsManager.h"

#define MXRPhotoPreviewGuide_Key @"MXRPhotoPreviewGuide_Key"

@implementation MXRPhotoPreviewGuideView

+(instancetype)photoPreviewGuideView{
    MXRPhotoPreviewGuideView *instance = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MXRPhotoPreviewGuideView" owner:nil options:nil] firstObject];
    return instance;
}

-(void)dealloc{
    DLOG_METHOD
}

-(void)tryShowBookStoreGuide{
    NSInteger *index = [[NSUserDefaults standardUserDefaults] integerForKey:MXRPhotoPreviewGuide_Key];
    
    if (!(index>0)) {
        [self show];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:MXRPhotoPreviewGuide_Key];
    }
}

-(void)show{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.frame = window.bounds;
    
}

-(void)hide{
    [self removeFromSuperview];
}

- (IBAction)buttonTapped:(UIButton *)sender {
    [self hide];
}


+(BOOL)checkIsNeedShow{
    if (APPCURRENTTYPE == MXRAppTypeSnapLearn) {
        return NO;
    }
    
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    // 判断是否选择服务器 并且程序引导页是否已显示
    if (type != MXRARServerTypeInnerUnknow&&[[NSUserDefaults standardUserDefaults] boolForKey:@"HELPOVER"]) {
        
        NSInteger *index = [[NSUserDefaults standardUserDefaults] integerForKey:MXRPhotoPreviewGuide_Key];
        if (index>0) {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}


@end
