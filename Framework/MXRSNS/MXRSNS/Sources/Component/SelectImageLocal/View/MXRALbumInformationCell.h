//
//  MXRALbumInformationCell.h
//  huashida_home
//
//  Created by yuchen.li on 16/8/26.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXRALbumInformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperateLabelHeightContrain;

@property (nonatomic, copy) NSString *representedAssetIdentifier;

@end
