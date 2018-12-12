//
//  MXRPKPropShopTableViewCell.m
//  huashida_home
//
//  Created by MountainX on 2018/10/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKPropShopTableViewCell.h"

#define kLRMargin 20.f

@interface MXRPKPropShopTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *purchaseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *propIv;
@property (weak, nonatomic) IBOutlet UILabel *diamondLabel;
@property (weak, nonatomic) IBOutlet UILabel *propNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgIv;

@end

@implementation MXRPKPropShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupGradientBg];
}

- (void)setupGradientBg {
    CAGradientLayer *gradient = self.bgIv.gradientLayer;
    gradient.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE - 2 * kLRMargin, self.bgIv.bounds.size.height);
    
    gradient.colors = @[(id)RGBHEX(0x53DFF8).CGColor, (id)RGBHEX(0x1955B9).CGColor];
    gradient.startPoint = CGPointMake(0.5f, 0.0f);
    gradient.endPoint = CGPointMake(0.5f, 1.0f);
    [self.bgIv.layer insertSublayer:gradient atIndex:0];
}

- (void)setModel:(MXRPKPropShopModel *)model {
    _model = model;
    
    _diamondLabel.text = [NSString stringWithFormat:@"x%ld", _model.coinNum];
    
    if (_model.type == MXRPropTypeExcludeError) {
        NSString *numStr = [NSString stringWithFormat:@"%ld%@", _model.num, MXRLocalizedString(@"MXR_Prop_Card_Unit", @"张")];
        NSString *cardStr = MXRLocalizedString(@"MXR_CHALLENGE_EXCLUDEERRORCARD", @"除错卡");
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[numStr stringByAppendingString:cardStr]];
        [attr addAttributes:@{NSForegroundColorAttributeName : RGBHEX(0xFEF946), NSFontAttributeName : MXRFONT(20)} range:NSMakeRange(0, numStr.length)];
        [attr addAttributes:@{NSForegroundColorAttributeName : RGBHEX(0xFFFFFF), NSFontAttributeName : MXRFONT(17)} range:NSMakeRange(numStr.length, cardStr.length)];
        _propNumLabel.attributedText = attr;
        _propIv.image = MXRIMAGE(@"icon_shop_debug");
    } else {
        NSString *numStr = [NSString stringWithFormat:@"%ld%@", _model.num, MXRLocalizedString(@"MXR_Prop_Card_Unit", @"张")];
        NSString *cardStr = MXRLocalizedString(@"MXR_CHALLENGE_RESURGENCECARD", @"复活卡");
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[numStr stringByAppendingString:cardStr]];
        [attr addAttributes:@{NSForegroundColorAttributeName : RGBHEX(0xFEF946), NSFontAttributeName : MXRFONT(20)} range:NSMakeRange(0, numStr.length)];
        [attr addAttributes:@{NSForegroundColorAttributeName : RGBHEX(0xFFFFFF), NSFontAttributeName : MXRFONT(17)} range:NSMakeRange(numStr.length, cardStr.length)];
        _propNumLabel.attributedText = attr;
        _propIv.image = MXRIMAGE(@"icon_shop_resurgence");
    }
    [_purchaseBtn setTitle:MXRLocalizedString(@"DDYBookDetailViewController_PurchaseReal", @"购买") forState:UIControlStateNormal];
}

- (IBAction)purchaseBtnClicked:(UIButton *)sender {
    if (_purchaseBlock) {
        _purchaseBlock(_model);
    }
}

@end
