//
//  MXRPKQuestionResultViewController.h
//  huashida_home
//
//  Created by MountainX on 2018/8/8.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//  问答结果页

#import "MXRDefaultViewController.h"
#import "MXRPKUserInfoModel.h"

@interface MXRPKQuestionResultViewController : MXRDefaultViewController

@property (nonatomic, strong)MXRPKUserInfoModel *infoModel;

@property (nonatomic, strong)MXRPKSubmitResultModel *submitResultModel;

- (instancetype)initWithPKUserInfoModel:(MXRPKUserInfoModel *)infoModel submitResultModel:(MXRPKSubmitResultModel *)submitResultModel;

@end
