//
//  MXRPKPropShopTableViewCell.h
//  huashida_home
//
//  Created by MountainX on 2018/10/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRPKPropShopResponseModel.h"

typedef void(^MXRPKPropPurshaseBlock)(MXRPKPropShopModel *);

@interface MXRPKPropShopTableViewCell : UITableViewCell

@property (nonatomic, strong) MXRPKPropShopModel *model;

@property (nonatomic, copy) MXRPKPropPurshaseBlock purchaseBlock;

@end
