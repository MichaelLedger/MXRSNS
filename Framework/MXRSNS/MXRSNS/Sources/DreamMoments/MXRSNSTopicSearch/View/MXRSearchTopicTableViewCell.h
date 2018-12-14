//
//  MXRSearchTopicTableViewCell.h
//  huashida_home
//
//  Created by lj on 16/9/22.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MXRSearchTopicModel;
@interface MXRSearchTopicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topicHeaderImageView;                 //话题图片
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;                                       //话题名称
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;                                   //参与人数
@property (strong, nonatomic) MXRSearchTopicModel *model;                                    //模型
@end
