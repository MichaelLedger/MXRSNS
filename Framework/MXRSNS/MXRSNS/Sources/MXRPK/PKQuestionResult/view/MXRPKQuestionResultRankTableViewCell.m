//
//  MXRPKQuestionResultRankTableViewCell.m
//  huashida_home
//
//  Created by MountainX on 2018/8/8.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKQuestionResultRankTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MXRUserHeaderView.h"

@interface MXRPKQuestionResultRankTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIv;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet MXRUserHeaderView *userHeaderView;

@end

@implementation MXRPKQuestionResultRankTableViewCell

static NSString *const cellIdentifier = @"MXRPKQuestionResultRankTableViewCell";
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    MXRPKQuestionResultRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MXRPKQuestionResultRankTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setRankModel:(MXRPKQARankModel *)rankModel {
    _rankModel = rankModel;
    
    [_userIv sd_setImageWithURL:[NSURL URLWithString:autoString(_rankModel.userLogo)] placeholderImage:MXRIMAGE(@"icon_xiaomeng_logo")];
    _userNameLabel.text = autoString(_rankModel.userName);
    _timestampLabel.text = autoString(_rankModel.createTime);
    
    _timestampLabel.font = MXRFONT(12);
    
    NSString *accuracyRateStr = MXRLocalizedString(@"MXR_PK_RESULT_ACCURACY", @"正确率");
    NSString *accuracyNumStr = [NSString stringWithFormat:@"%ld%%", _rankModel.accuracy];
    NSString *accuracyStr = [NSString stringWithFormat:@"%@：%@", accuracyRateStr, accuracyNumStr];
    NSMutableAttributedString *accuracyAttr = [[NSMutableAttributedString alloc] initWithString:accuracyStr];
    [accuracyAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_333333 range:NSMakeRange(0, accuracyRateStr.length + 1)];
    [accuracyAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_2FB8E2 range:NSMakeRange(accuracyRateStr.length + 1, accuracyNumStr.length)];
    _accuracyLabel.attributedText = accuracyAttr;
    
    if (_rankModel.userId == [[UserInformation modelInformation].userID integerValue]) {
        if ([[UserInformation modelInformation].userImage isKindOfClass:[NSString class]]) {
            self.userHeaderView.headerUrl = [UserInformation modelInformation].userImage;
        }else if([[UserInformation modelInformation].userImage isKindOfClass:[UIImage class]]){
            self.userHeaderView.placeHolderheaderImage = (UIImage *)[UserInformation modelInformation].userImage;
        }else {
            self.userHeaderView.placeHolderheaderImage = MXRIMAGE(@"icon_common_default_head");
        }
        self.userHeaderView.vip = [UserInformation modelInformation].vipFlag;
    }else{
        self.userHeaderView.headerUrl = autoString(_rankModel.userLogo);
        self.userHeaderView.vip = _rankModel.vipFlag;
    }
}

- (void)autoRank:(NSIndexPath *)indexPath {
    _rankLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
}

@end
