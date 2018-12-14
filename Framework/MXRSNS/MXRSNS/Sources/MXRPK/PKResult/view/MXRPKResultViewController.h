//
//  MXRPKResultViewController.h
//  huashida_home
//
//  Created by MountainX on 2018/8/21.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//  PK结果页

#import <UIKit/UIKit.h>
#import "MXRPKResponseModel.h"
#import "MXRPKUserInfoModel.h"

@interface MXRPKResultViewController : MXRDefaultViewController

@property (nonatomic, strong)MXRPKUserInfoModel *infoModel;

@property (nonatomic, strong)MXRPKSubmitResultModel *submitResultModel;

@end
