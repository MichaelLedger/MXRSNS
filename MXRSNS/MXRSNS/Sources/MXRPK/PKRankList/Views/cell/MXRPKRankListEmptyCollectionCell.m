//
//  MXRPKRankListEmptyCollectionCell.m
//  huashida_home
//
//  Created by mengxiangren on 2018/11/13.
//  Copyright © 2018 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKRankListEmptyCollectionCell.h"
@interface MXRPKRankListEmptyCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *emptyTitleLabel;

@end
@implementation MXRPKRankListEmptyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     _emptyTitleLabel.text = MXRLocalizedString(@"MXR_PK_RANK_NODATA", @"暂无数据");
}

@end
