//
//  MXRPKRankFirstCollectionViewCell.m
//  huashida_home
//
//  Created by mengxiangren on 2018/11/13.
//  Copyright © 2018 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKRankFirstCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface MXRPKRankFirstCollectionViewCell ()
//第一名
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIImageView *firstPhoto;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNumLabel;
//第二名
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIImageView *secondPhoto;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondNumLabel;
//第三名
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdPhoto;
@property (weak, nonatomic) IBOutlet UILabel *thirdNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdNumLabel;


@property (strong, nonatomic) MXRPKRankListModel *listModel;

@end

@implementation MXRPKRankFirstCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}


- (void)parseCellDataWithModel:(MXRPKRankListModel *)model{
    self.listModel = model;
    MXRPKUserRankModel *firstModel = nil;
    MXRPKUserRankModel *secondModel = nil;
    MXRPKUserRankModel *thirdModel = nil;
        
    if (self.listModel.qaChallengeRankingInfoList.count == 1){
        firstModel = [self.listModel.qaChallengeRankingInfoList objectAtIndex:0];
    }else if (self.listModel.qaChallengeRankingInfoList.count == 2){
        firstModel = [self.listModel.qaChallengeRankingInfoList objectAtIndex:0];
        secondModel = [self.listModel.qaChallengeRankingInfoList objectAtIndex:1];
    }else if(self.listModel.qaChallengeRankingInfoList.count > 2){
        firstModel = [self.listModel.qaChallengeRankingInfoList objectAtIndex:0];
        secondModel = [self.listModel.qaChallengeRankingInfoList objectAtIndex:1];
        thirdModel = [self.listModel.qaChallengeRankingInfoList objectAtIndex:2];
    }
    
    [self parseFirstRankData:firstModel];
    [self parseSecondRankData:secondModel];
    [self parseThirdRankData:thirdModel];
}

- (void)parseFirstRankData:(MXRPKUserRankModel *)rankModel{
    if (rankModel) {
        self.firstView.hidden = NO;
        
        if ([rankModel.userId isEqualToString:[UserInformation modelInformation].userID]) {
            if ([[UserInformation modelInformation].userImage isKindOfClass:[NSString class]]) {
                 [self.firstPhoto sd_setImageWithURL:[NSURL URLWithString:[UserInformation modelInformation].userImage] placeholderImage:MXRIMAGE(@"icon_xiaomeng_logo")];
            }else if([[UserInformation modelInformation].userImage isKindOfClass:[UIImage class]]){
                self.firstPhoto.image = (UIImage *)[UserInformation modelInformation].userImage;
            } else {
                self.firstPhoto.image = MXRIMAGE(@"icon_common_default_head");
            }
        }else{
            [self.firstPhoto sd_setImageWithURL:[NSURL URLWithString:rankModel.userLogo] placeholderImage:MXRIMAGE(@"icon_xiaomeng_logo")];
        }

        
        
        self.firstNameLabel.text = rankModel.userName;
        self.firstNumLabel.text = [NSString stringWithFormat:@"%ld题",rankModel.continuousCorrectNum];
    }else{
        self.firstView.hidden = YES;
    }
    
}
- (void)parseSecondRankData:(MXRPKUserRankModel *)rankModel{
    if (rankModel) {
        self.secondView.hidden = NO;
        if ([rankModel.userId isEqualToString:[UserInformation modelInformation].userID]) {
            if ([[UserInformation modelInformation].userImage isKindOfClass:[NSString class]]) {
                [self.secondPhoto sd_setImageWithURL:[NSURL URLWithString:[UserInformation modelInformation].userImage] placeholderImage:MXRIMAGE(@"icon_xiaomeng_logo")];
            }else if([[UserInformation modelInformation].userImage isKindOfClass:[UIImage class]]){
                self.secondPhoto.image = (UIImage *)[UserInformation modelInformation].userImage;
            } else {
                self.secondPhoto.image = MXRIMAGE(@"icon_common_default_head");
            }
        }else{
            [self.secondPhoto sd_setImageWithURL:[NSURL URLWithString:rankModel.userLogo] placeholderImage:MXRIMAGE(@"icon_xiaomeng_logo")];
        }
        self.secondNameLabel.text = rankModel.userName;
        self.secondNumLabel.text = [NSString stringWithFormat:@"%ld题",rankModel.continuousCorrectNum];
    }else{
        self.secondView.hidden = YES;
    }
}
- (void)parseThirdRankData:(MXRPKUserRankModel *)rankModel{
    if (rankModel) {
        self.thirdView.hidden = NO;
        if ([rankModel.userId isEqualToString:[UserInformation modelInformation].userID]) {
            if ([[UserInformation modelInformation].userImage isKindOfClass:[NSString class]]) {
                [self.thirdPhoto sd_setImageWithURL:[NSURL URLWithString:[UserInformation modelInformation].userImage] placeholderImage:MXRIMAGE(@"icon_xiaomeng_logo")];
            }else if([[UserInformation modelInformation].userImage isKindOfClass:[UIImage class]]){
                self.thirdPhoto.image = (UIImage *)[UserInformation modelInformation].userImage;
            } else {
                self.thirdPhoto.image = MXRIMAGE(@"icon_common_default_head");
            }
        }else{
            [self.thirdPhoto sd_setImageWithURL:[NSURL URLWithString:rankModel.userLogo] placeholderImage:MXRIMAGE(@"icon_xiaomeng_logo")];
        }
        self.thirdNameLabel.text = rankModel.userName;
        self.thirdNumLabel.text = [NSString stringWithFormat:@"%ld题",rankModel.continuousCorrectNum];
    }else{
        self.thirdView.hidden = YES;
    }
}
@end
