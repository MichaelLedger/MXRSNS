//
//  MXRPKNormalFooterView.h
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXRPKNormalFooterView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *askHelpBtn;
- (void)setShareStyle:(BOOL)isShareStyle;
@end
