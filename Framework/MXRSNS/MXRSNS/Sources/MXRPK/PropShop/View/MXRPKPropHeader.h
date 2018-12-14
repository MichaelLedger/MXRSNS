//
//  MXRPKPropHeader.h
//  huashida_home
//
//  Created by MountainX on 2018/10/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShareBlock)(UIButton *);

@interface MXRPKPropHeader : UIView

@property (copy, nonatomic) ShareBlock shareBlock;

+ (instancetype)header;

@end
