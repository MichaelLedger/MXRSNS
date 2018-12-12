//
//  MXRPKPropHeader.m
//  huashida_home
//
//  Created by MountainX on 2018/10/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKPropHeader.h"
#import "UIButton+ImageTitleSpacing.h"

#define kMargin 10.f

@interface MXRPKPropHeader ()

@property (weak, nonatomic) IBOutlet UIView *titleGradientBgView;
@property (weak, nonatomic) IBOutlet UIView *shareGradientBgView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rulerLabel;

@end

@implementation MXRPKPropHeader

+ (instancetype)header {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MXRPKPropShopViewController" owner:nil options:nil];
    __block MXRPKPropHeader *header;
    [nibs enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MXRPKPropHeader class]]) {
            header = obj;
            *stop = YES;
        }
    }];
    [header layoutSubviews];
    return header;
}
- (IBAction)shareBtnClicked:(UIButton *)sender {
    if (_shareBlock) {
        _shareBlock(sender);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_shareBtn setTitle:MXRLocalizedString(@"MXRPerViewCont_Share", @"分享") forState:UIControlStateNormal];
    _subTitleLabel.text = MXRLocalizedString(@"MXR_Prop_Task", @"任务获得");
    _titleLabel.text = MXRLocalizedString(@"MXR_Prop_Share_Task", @"分享可获道具");
    _rulerLabel.text = MXRLocalizedString(@"MXR_Prop_Share_Ruler", @"规则：每日首次分享，将获得1张复活卡和1张除错卡（会员2倍奖励）");
    
    [_shareBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5.f];

    [self setupGradientBg];
}

- (void)setupGradientBg {
    CAGradientLayer *gradient = self.shareGradientBgView.gradientLayer;
    gradient.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE_ABSOLUTE, self.shareGradientBgView.bounds.size.height);
    
    gradient.colors = @[(id)RGBHEX(0x53DFF8).CGColor, (id)RGBHEX(0x1955B9).CGColor];
    gradient.startPoint = CGPointMake(0.5f, 0.0f);
    gradient.endPoint = CGPointMake(0.5f, 1.0f);
    [self.shareGradientBgView.layer insertSublayer:gradient atIndex:0];
    
    CAGradientLayer *gradient2 = self.titleGradientBgView.gradientLayer;
    gradient2.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE_ABSOLUTE, self.titleGradientBgView.bounds.size.height);
    
    gradient2.colors = @[(id)RGBHEX(0x15D4EC).CGColor, (id)RGBHEX(0x09A9D4).CGColor];
    gradient2.startPoint = CGPointMake(0.5f, 0.0f);
    gradient2.endPoint = CGPointMake(0.5f, 1.0f);
    [self.titleGradientBgView.layer insertSublayer:gradient2 atIndex:0];
}

@end
