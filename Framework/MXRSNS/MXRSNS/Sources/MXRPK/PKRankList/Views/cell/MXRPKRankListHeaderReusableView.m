//
//  MXRPKRankListHeaderReusableView.m
//  huashida_home
//
//  Created by mengxiangren on 2018/11/13.
//  Copyright © 2018 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKRankListHeaderReusableView.h"
#import "UIImageView+WebCache.h"

static const CGFloat PkRankListRecordMargin = 12.0;
static const CGFloat PkRankListRecordWidth = 25.2;

@interface MXRPKRankListHeaderReusableView ()
@property (weak, nonatomic) IBOutlet UIImageView *highestPhoto;
@property (weak, nonatomic) IBOutlet UIScrollView *recoedScrollView;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
@property (weak, nonatomic) IBOutlet UIView *recordView;

@property (strong, nonatomic) MXRPKRankListModel *rankModel;

@end
@implementation MXRPKRankListHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor =  RGBHEX(0xFFF2C7);
    // Initialization code

}
- (void)parseCellDataWithModel:(MXRPKRankListModel *)listModel{
    self.rankModel = listModel;
    self.answerLabel.attributedText = [self attributedAnswerStr:[NSString stringWithFormat:@"连续答对%ld题", (long)listModel.bestContinuousCorrectNum]];
    if ([listModel.bestUserId isEqualToString:[UserInformation modelInformation].userID]) {
        if ([[UserInformation modelInformation].userImage isKindOfClass:[NSString class]]) {
            [self.highestPhoto sd_setImageWithURL:[NSURL URLWithString:[UserInformation modelInformation].userImage] placeholderImage:MXRIMAGE(@"icon_xiaomeng_logo")];
        }else if([[UserInformation modelInformation].userImage isKindOfClass:[UIImage class]]){
            self.highestPhoto.image = (UIImage *)[UserInformation modelInformation].userImage;
        } else {
            self.highestPhoto.image = MXRIMAGE(@"icon_common_default_head");
        }
    }else{
        [self.highestPhoto sd_setImageWithURL:[NSURL URLWithString:listModel.bestUserLogo] placeholderImage:MXRIMAGE(@"icon_xiaomeng_logo")];
    }
    self.recordLabel.attributedText = [self attributedRecordStr:[NSString stringWithFormat:@"记录已保持 %ld 天",(long)listModel.keepDays]];
    
    //同记录保持着
    if (listModel.qaChallengeBestRankingVos.count > 0) {
        self.recordView.hidden = NO;
        for (int i = 0; i < listModel.qaChallengeBestRankingVos.count; i++) {
            MXRPKBestUserRankModel *userModel = listModel.qaChallengeBestRankingVos[i];
            CGRect frame = CGRectMake(PkRankListRecordMargin + (PkRankListRecordWidth + PkRankListRecordMargin) * i, 0, PkRankListRecordWidth, PkRankListRecordWidth);
            [self creatRecordPhotoImgFrame:frame imgUrl:userModel.userLogo];
        }
        self.recoedScrollView.contentSize = CGSizeMake(PkRankListRecordMargin + (PkRankListRecordWidth + PkRankListRecordMargin) * listModel.qaChallengeBestRankingVos.count, self.recoedScrollView.frame.size.height);
    }else{
        self.recordView.hidden = YES;
    }
    
}

//初始化同记录者头像
- (UIImageView *)creatRecordPhotoImgFrame:(CGRect)frame imgUrl:(NSString *)imgUrl{
    UIImageView *photoImg = [[UIImageView alloc] initWithFrame:frame];
    [photoImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:MXRIMAGE(@"icon_xiaomeng_logo")];
    photoImg.layer.cornerRadius = PkRankListRecordWidth / 2;
    photoImg.layer.masksToBounds = YES;
    [self.recoedScrollView addSubview:photoImg];
    return photoImg;
}
//连续答题字体
- (NSMutableAttributedString *)attributedAnswerStr:(NSString *)answerStr{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:answerStr];
    NSDictionary *attributedDict = @{NSForegroundColorAttributeName:[UIColor blackColor]};
   [attStr setAttributes:attributedDict range:NSMakeRange(4, answerStr.length - 5)];
    return attStr;
}
//记录保持字体变化
- (NSMutableAttributedString *)attributedRecordStr:(NSString *)recordStr{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:recordStr];
    NSDictionary *attributedDict = @{NSForegroundColorAttributeName:RGBHEX(0xFA9C18)};
    [attStr setAttributes:attributedDict range:NSMakeRange(5, recordStr.length - 6)];
    return attStr;
}
@end
