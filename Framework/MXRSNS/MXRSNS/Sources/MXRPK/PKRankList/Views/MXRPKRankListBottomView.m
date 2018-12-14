//
//  MXRPKRankListBottomView.m
//  huashida_home
//
//  Created by MinJing_Lin on 2018/10/24.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKRankListBottomView.h"
#import "MXRPKRankListModel.h"
#import "UILabel+MXRColor.h"
#import "UIImageView+WebCache.h"


@interface MXRPKRankListBottomView (){
    CGRect myframe;
}

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subhectNumConstraintRight;

@end

@implementation MXRPKRankListBottomView

+ (instancetype)instancePKRankListView {

    return [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MXRPKRankListBottomView" owner:self options:nil]lastObject];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MXRPKRankListBottomView" owner:self options:nil]lastObject];
        myframe = frame;
    }
    return self ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //适配320屏
    if (SCREEN_WIDTH_320) {
        self.subhectNumConstraintRight.constant = 50;
    }
    
    self.rankLabel.font = MXRFONT_15;
    self.desLabel.font = MXRFONT_15;
    self.subjectNumLabel.font = MXRFONT_12;
}

- (void)drawRect:(CGRect)rect{
    self.frame = myframe; //解决设置frame无效问题
    //记录：设置Xib尺寸不等于70，要不然iphoneX不走这个方法，真奇怪
}

- (void)setRankModel:(MXRPKRankListModel *)rankModel {
    _rankModel = rankModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[UserInformation modelInformation].userImage] placeholderImage:MXRIMAGE(@"icon_xiaomeng_logo")];
    
    NSString *userRankStr = [NSString stringWithFormat:@"%ld",rankModel.userRanking];
    if (userRankStr.integerValue >999) {
        self.rankLabel.text = @"未上榜";
        self.desLabel.text = @"我排在1000名之外";
    }else{
        self.rankLabel.text = userRankStr;
        self.desLabel.text = [NSString stringWithFormat:@"我排在第%@位",userRankStr];
        [self.desLabel changeStrokeColorWithTextStrikethroughColor:MXRCOLOR_2FB8E2 changeText:userRankStr];
    }

    NSInteger continuousCorrectNum = rankModel.continuousCorrectNum;
    if (continuousCorrectNum == 0) {
        self.rankLabel.text = @"未上榜";
        self.desLabel.text = @"赶紧去答题吧~";
    }
    self.subjectNumLabel.text = [NSString stringWithFormat:@"%ld题",continuousCorrectNum];
    
}



@end
