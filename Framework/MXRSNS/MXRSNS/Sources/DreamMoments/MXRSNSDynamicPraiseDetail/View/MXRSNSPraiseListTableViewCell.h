//
//  MXRSNSPraiseListTableViewCell.h
//  huashida_home
//
//  Created by shuai.wang on 2017/7/6.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRBookSNSPraiseListModel.h"
#import "MXRUserHeaderView.h"

@interface MXRSNSPraiseListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *praiseTime;

@property (weak, nonatomic) IBOutlet MXRUserHeaderView *userHeaderView;

-(void)configCellData:(MXRBookSNSPraiseListModel *)praiseModel;
@end
