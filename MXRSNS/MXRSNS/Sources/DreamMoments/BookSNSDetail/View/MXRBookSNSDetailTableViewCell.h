//
//  MXRBookSNSDetailTableViewCell.h
//  huashida_home
//
//  Created by shuai.wang on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRBookSNSDetailCommentListModel.h"
#import "MXRUserHeaderView.h"

@interface MXRBookSNSDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lableName;

@property (weak, nonatomic) IBOutlet UILabel *lableTime;

@property (weak, nonatomic) IBOutlet UILabel *lableComment;

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

@property (weak, nonatomic) IBOutlet MXRUserHeaderView *userHeaderView;


@property (weak, nonatomic) IBOutlet UILabel *lableZan;

@property (weak, nonatomic) IBOutlet UIButton *buttonPraise;

@property (weak, nonatomic) IBOutlet UILabel *praiseAnimotion;

@property (weak, nonatomic) IBOutlet UIView *separateLine;


-(void)addDataForCellWithModel:(MXRBookSNSDetailCommentListModel *)model;
-(void)showAddCountAnimationWithView:(UIView *)view;

@end
