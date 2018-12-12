//
//  MXRSNSPraiseListTableViewCell.m
//  huashida_home
//
//  Created by shuai.wang on 2017/7/6.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSNSPraiseListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+NSDate.h"
@implementation MXRSNSPraiseListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configCellData:(MXRBookSNSPraiseListModel *)praiseModel {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userIcon.layer.cornerRadius = self.userIcon.frame.size.width/2.0;
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.borderWidth = 1;
    self.userIcon.layer.borderColor = RGB(224, 224, 224).CGColor;
    
    self.userName.text = autoString(praiseModel.userName);
    self.userName.textColor = MXRCOLOR_333333;
    self.userName.font = MXRFONT_15;
//    self.praiseTime.text = [NSString convertTimeWithDateStr:praiseModel.createTime];
    self.praiseTime.hidden = YES;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:autoString(praiseModel.userLogo)] placeholderImage:MXR_USER_ICON_PLACEHOLDER_IMAGE];
    
    // V5.13.0 点赞新增VIP专属头像边框
    self.userHeaderView.headerUrl = autoString(praiseModel.userLogo);
    BOOL isThatUserVIP = praiseModel.vipFlag;
    if (praiseModel.userId == [MAIN_USERID integerValue]) {
        isThatUserVIP = [UserInformation modelInformation].vipFlag;
    }
    self.userHeaderView.vip = isThatUserVIP;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
