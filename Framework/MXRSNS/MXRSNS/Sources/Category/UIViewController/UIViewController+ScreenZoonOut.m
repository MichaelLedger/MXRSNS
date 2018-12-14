//
//  UIViewController+ScreenZoonOut.m
//  huashida_home
//
//  Created by 周建顺 on 15/6/16.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "UIViewController+ScreenZoonOut.h"
#import <objc/runtime.h>
#import "DimensMacro.h"

static const void *ScreenZoonOutButtonKey = &ScreenZoonOutButtonKey;
static const void *ScreenZoonOutButtonTappedKey = &ScreenZoonOutButtonTappedKey;

#define BUTTON_WIDTH 44
#define BUTTON_HEIGHT 44

@implementation UIViewController(ScreenZoonOut)

-(void)addScreenZoonOutButtonToViewWithTappedBlock:(ScreenZoonOutButtonTappedBlock)tappedBlock isHidden:(BOOL)isHidden{
    if (!self.screenZoonOutButton) {
        self.screenZoonOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
       // self.screenZoonOutButton.frame = CGRectMake(SCREEN_WIDTH_DEVICE - BUTTON_WIDTH - 8 , 8, BUTTON_WIDTH, BUTTON_HEIGHT);
        

        
        [self.screenZoonOutButton setImage:MXRIMAGE(@"btn_screen_zoon_out") forState:UIControlStateNormal];
        [self.screenZoonOutButton setImage:MXRIMAGE(@"btn_screen_zoon_out_press") forState:UIControlStateHighlighted];
        [self.screenZoonOutButton addTarget:self action:@selector(screenZoonOutButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        self.screenZoonOutButtonTapped = tappedBlock;
        self.screenZoonOutButton.hidden = isHidden;
        
        [self.view addSubview:self.screenZoonOutButton];
        [self.view bringSubviewToFront:self.screenZoonOutButton];
        
        
         self.screenZoonOutButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *metrics = @{@"width":[NSNumber numberWithFloat:BUTTON_WIDTH ],
                                  @"height":[NSNumber numberWithFloat:BUTTON_HEIGHT ],
                                  @"marginLeft":[NSNumber numberWithFloat:8],
                                  @"marginTop":[NSNumber numberWithFloat:8]};
        NSDictionary *views = @{@"_screenZoonOutButton":self.screenZoonOutButton};
        NSArray *constraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"[_screenZoonOutButton(width)]-(marginLeft)-|" options:0 metrics:metrics views:views];
        NSArray *constraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(marginTop)-[_screenZoonOutButton(height)]" options:0 metrics:metrics views:views];
       
        [self.view addConstraints:constraintH];
        [self.view addConstraints:constraintV];
    }
   
}


-(void)screenZoonOutButtonTapped:(UIButton*)sender{
    if (self.screenZoonOutButtonTapped) {
        self.screenZoonOutButtonTapped();
    }

}

#pragma mark ------

-(void)setScreenZoonOutButton:(UIButton *)screenZoonOutButton{

     objc_setAssociatedObject(self, ScreenZoonOutButtonKey, screenZoonOutButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton *)screenZoonOutButton{

   return objc_getAssociatedObject(self, ScreenZoonOutButtonKey);
}



-(void)setScreenZoonOutButtonTapped:(ScreenZoonOutButtonTappedBlock)screenZoonOutButtonTapped{
    objc_setAssociatedObject(self, ScreenZoonOutButtonTappedKey, screenZoonOutButtonTapped, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(ScreenZoonOutButtonTappedBlock)screenZoonOutButtonTapped{
    return objc_getAssociatedObject(self, ScreenZoonOutButtonTappedKey);
}



@end
