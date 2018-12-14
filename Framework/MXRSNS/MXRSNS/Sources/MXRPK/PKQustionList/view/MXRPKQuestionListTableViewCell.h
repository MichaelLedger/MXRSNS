//
//  MXRPKQuestionListTableViewCell.h
//  huashida_home
//
//  Created by MountainX on 2018/8/8.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRPKQuestionListModel.h"

@interface MXRPKQuestionListTableViewCell : UITableViewCell

@property (nonatomic, strong)MXRPKQuestionListModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
