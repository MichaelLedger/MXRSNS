//
//  MXRPKMedalDetailView.h
//  huashida_home
//
//  Created by shuai.wang on 2018/1/20.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRPKMedalInfoModel.h"
@interface MXRPKMedalDetailView : UIView
@property (nonatomic, strong) MXRPKMedalDetailModel *pkMedalDetailModel;
@property (nonatomic, copy) void(^closeCallback)(MXRPKMedalDetailView * );
@property (nonatomic, copy) void(^medalPromptButtonCallback)(MXRPKMedalDetailModel *,MXRPKMedalDetailView * );
@end
