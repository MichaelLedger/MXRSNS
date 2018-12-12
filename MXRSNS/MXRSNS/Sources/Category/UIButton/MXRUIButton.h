//
//  MXRUIButton.h
//  huashida_home
//
//  Created by Martin.liu on 2017/11/14.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MXRUIButtonImagePosition) {
    MXRUIButtonImagePositionLeft,
    MXRUIButtonImagePositionRight
};

@interface MXRUIButton : UIButton

@property (nonatomic, assign) MXRUIButtonImagePosition imagePosition;

@end
