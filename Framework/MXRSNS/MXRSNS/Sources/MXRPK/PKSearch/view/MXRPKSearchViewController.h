//
//  MXRPKSearchViewController.h
//  huashida_home
//
//  Created by shuai.wang on 2018/1/16.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//  随机PK搜索页

#import "MXRDefaultViewController.h"
#import "MXRPKUserInfoModel.h"
@protocol MXRPKSearchViewControllerDelegate <NSObject>
@optional
-(void)dismissMXRPKSearchViewControllerWithMXRPKUserInfoModel:(MXRPKUserInfoModel *)pkUserInfoModel;
@end
@interface MXRPKSearchViewController : MXRDefaultViewController
@property (nonatomic, weak) id <MXRPKSearchViewControllerDelegate>delegate;
+(instancetype)pkSearchViewController;
@end
