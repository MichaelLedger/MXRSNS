//
//  MXRPKHomeHeaderViewModel.m
//  huashida_home
//
//  Created by 周建顺 on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKHomeHeaderViewModel.h"

@implementation MXRPKHomeHeaderViewModel

-(void)updateDataWithModel:(MXRPKHomeRankingInfoResponseModel*)model{
    _model = model;
    self.medalsCount = model.medalCount;
    self.records = [NSString stringWithFormat:MXRLocalizedString(@"MXRPKHomeViewController_PK_Records", @"0胜 0负 0平"), @(model.win),@(model.lose),@(model.draw)];
}

@end
