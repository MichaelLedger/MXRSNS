//
//  MXRPKImageOptionCell.h
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/19.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXRPKImageOptionCell : UICollectionViewCell

@property (nonatomic, assign) BOOL mxr_selected;
- (void)setCellData:(id)data;
- (void)showResult;
@end
