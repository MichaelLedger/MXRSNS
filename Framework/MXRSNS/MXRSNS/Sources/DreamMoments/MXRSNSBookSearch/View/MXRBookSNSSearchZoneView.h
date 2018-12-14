//
//  MXRBookSNSSearchZoneView.h
//  huashida_home
//
//  Created by yuchen.li on 2017/7/4.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXRSubjectInfoModel;
@interface MXRBookSNSSearchZoneView : UIView
-(instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong)MXRSubjectInfoModel *zoneModel;

@end
