//
//  MXRWrongAnalysisViewController.h
//  huashida_home
//
//  Created by MountainX on 2018/8/16.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//  PK错题解析页

#import <UIKit/UIKit.h>
#import "MXRPKResponseModel.h"

@interface MXRWrongAnalysisViewController : MXRDefaultViewController

@property (nonatomic, strong) MXRPKQuestionLibModel      *pkQuestionLibModel;

@property (nonatomic, strong) MXRRandomOpponentResult    *mineResult;

@end
