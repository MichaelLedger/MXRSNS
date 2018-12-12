//
//  MXRPKRankListCollectionViewCell.m
//  huashida_home
//
//  Created by mengxiangren on 2018/11/13.
//  Copyright © 2018 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKRankListCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface MXRPKRankListCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectNumLabel;
@end

@implementation MXRPKRankListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)parseCellDataWithModel:(MXRPKUserRankModel *)rankModel  rowInteger:(NSInteger) row{
    if ([rankModel.userId isEqualToString:[UserInformation modelInformation].userID]) {
        if ([[UserInformation modelInformation].userImage isKindOfClass:[NSString class]]) {
            [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:[UserInformation modelInformation].userImage] placeholderImage:MXRIMAGE(@"icon_xiaomeng_logo")];
        }else if([[UserInformation modelInformation].userImage isKindOfClass:[UIImage class]]){
            self.photoImageView.image = (UIImage *)[UserInformation modelInformation].userImage;
        } else {
            self.photoImageView.image = MXRIMAGE(@"icon_common_default_head");
        }
    }else{
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:rankModel.userLogo] placeholderImage:MXRIMAGE(@"icon_xiaomeng_logo")];
    }
    self.nameLabel.text = rankModel.userName;
    self.subjectNumLabel.text = [NSString stringWithFormat:@"%ld题",rankModel.continuousCorrectNum];
    self.rankLabel.text = [NSString stringWithFormat:@"%ld",(long)row];
}
@end
