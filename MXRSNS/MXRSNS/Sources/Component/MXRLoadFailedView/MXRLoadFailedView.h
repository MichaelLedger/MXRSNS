//
//  MXRLoadFailedView.h
//  huashida_home
//
//  Created by 周建顺 on 15/10/10.
//  Copyright © 2015年 mxrcorp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MXRLoadFailedView;

@interface MXRLoadFailedView : UIView

+(instancetype)loadFailedView;

@property (nonatomic,copy) void(^refreshTapped)(MXRLoadFailedView*);

@end
