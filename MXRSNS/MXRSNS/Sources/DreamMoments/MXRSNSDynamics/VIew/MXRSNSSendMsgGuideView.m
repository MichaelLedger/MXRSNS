//
//  MXRSNSSendMsgGuideView.m
//  huashida_home
//
//  Created by 周建顺 on 2016/12/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSNSSendMsgGuideView.h"
#import "MXRUserSettingsManager.h"

#define MXRSNSSendMsgGuide_Key @"MXRSNSSendMsgGuide_Key"

@interface MXRSNSSendMsgGuideView ()

@end

@implementation MXRSNSSendMsgGuideView

+(instancetype)sendMsgGuideView{
    MXRSNSSendMsgGuideView *instance = [[[NSBundle mainBundle] loadNibNamed:@"MXRSNSSendMsgGuideView" owner:nil options:nil] firstObject];
    return instance;
}


-(void)dealloc{
    DLOG_METHOD
}

-(void)tryShowBookStoreGuide{
    NSInteger *index = [[NSUserDefaults standardUserDefaults] integerForKey:MXRSNSSendMsgGuide_Key];
    
    if (!(index>0)) {
        [self show];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:MXRSNSSendMsgGuide_Key];
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
    
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    // 判断是否选择服务器 并且程序引导页是否已显示
    if (type != MXRARServerTypeInnerUnknow&&[[NSUserDefaults standardUserDefaults] boolForKey:@"HELPOVER"]) {
        
        NSInteger *index = [[NSUserDefaults standardUserDefaults] integerForKey:MXRSNSSendMsgGuide_Key];
        if (index>0) {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

@end
