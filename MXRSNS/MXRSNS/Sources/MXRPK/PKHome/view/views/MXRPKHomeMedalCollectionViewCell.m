//
//  MXRPKHomeMedalCollectionViewCell.m
//  huashida_home
//
//  Created by MountainX on 2018/10/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKHomeMedalCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface MXRPKHomeMedalCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *medalIv;

@end

@implementation MXRPKHomeMedalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMedalModel:(MXRPKMedalDetailModel *)medalModel {
    _medalModel = medalModel;
    if (medalModel.isHold) {
        [self.medalIv sd_setImageWithURL:[NSURL URLWithString:[autoString(_medalModel.iconActive) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:MXRIMAGE(@"icon_pk_home_medals_normal")];
    }else {
        [self.medalIv sd_setImageWithURL:[NSURL URLWithString:[autoString(_medalModel.iconInactive) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:MXRIMAGE(@"icon_pk_home_medals_normal")];
    }
}

@end
