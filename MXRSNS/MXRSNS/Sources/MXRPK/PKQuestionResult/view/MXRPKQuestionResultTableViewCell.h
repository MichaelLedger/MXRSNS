//
//  MXRPKQuestionResultTableViewCell.h
//  huashida_home
//
//  Created by MountainX on 2018/8/8.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRPKResponseModel.h"

@interface MXRPKQuestionResultTableViewCell : UITableViewCell

@property (nonatomic, strong) MXRPKQuestionLibModel     *pkQuestionLibModel;

@property (nonatomic, strong) MXRPKSubmitResultModel    *submitResultModel;

@property (nonatomic, strong) MXRRandomOpponentResult    *mineResult;

@property (nonatomic, assign) NSInteger                 qaId;

@property (nonatomic, copy) NSString                    *qaName;

@property (nonatomic, copy) NSString                    *bookGuid;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
