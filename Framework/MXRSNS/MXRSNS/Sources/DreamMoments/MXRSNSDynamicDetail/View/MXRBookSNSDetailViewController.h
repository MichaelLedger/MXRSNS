//
//  MXRBookSNSDetailViewController.h
//  huashida_home
//
//  Created by shuai.wang on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//  动态详情页面

#import "MXRDefaultViewController.h"
@class MXRSNSShareModel;
@interface MXRBookSNSDetailViewController : MXRDefaultViewController
-(instancetype)initWithModel:(MXRSNSShareModel *)model;
@property (strong, nonatomic) MXRSNSShareModel * momentModel;
@end
