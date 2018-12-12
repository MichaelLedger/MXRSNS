//
//  MXRTopicMainViewController.h
//  huashida_home
//
//  Created by dingyang on 16/9/19.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//  话题详情页面

#import "MXRDefaultViewController.h"
#import "MXRTopicModel.h"
typedef enum fromVCType {
    defaultVCType = 0,
    bookSNSDetailViewController,
    bookSNSSendDetailViewController,
}fromVCType;
@interface MXRTopicMainViewController : MXRDefaultViewController
@property (nonatomic, copy)NSString * p_topicID;
@property (nonatomic, copy)NSString * p_topicName;
@property (nonatomic, assign)BOOL closePopGestureRecognizer;  //是否关闭左滑返回  默认支持
-(instancetype)initWithMXRTopicModelID:(NSString *)topicID;
-(instancetype)initWithMXRTopicModelName:(NSString *)topicName fromVC:(fromVCType)viewController;
@end
