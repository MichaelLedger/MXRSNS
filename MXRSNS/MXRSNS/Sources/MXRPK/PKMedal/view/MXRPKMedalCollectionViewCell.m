//
//  MXRPKMedalCollectionViewCell.m
//  huashida_home
//
//  Created by shuai.wang on 2018/1/20.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKMedalCollectionViewCell.h"
#import "GlobalFunction.h"
#import "UIButton+WebCache.h"

@interface MXRPKMedalCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIButton *medalButton;

@end

@implementation MXRPKMedalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    setButtonExclusiveTouch(self.contentView);   //禁止多点触控
}


-(void)setPkMedalInfoModel:(MXRPKMedalDetailModel *)pkMedalDetailModel {
    _pkMedalInfoModel = pkMedalDetailModel;
    if (pkMedalDetailModel.isHold) {
        [self.medalButton sd_setImageWithURL:[NSURL URLWithString:[autoString(pkMedalDetailModel.iconActive) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] forState:UIControlStateNormal placeholderImage:MXRIMAGE(@"icon_pk_home_medals_normal")];
    }else {
        [self.medalButton sd_setImageWithURL:[NSURL URLWithString:[autoString(pkMedalDetailModel.iconInactive) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] forState:UIControlStateNormal  placeholderImage:MXRIMAGE(@"icon_pk_home_medals_normal")];
    }
}

- (IBAction)onMedalButtonClick:(id)sender {

    if (self.callback) {
        self.callback(_pkMedalInfoModel);
    }
}

@end
