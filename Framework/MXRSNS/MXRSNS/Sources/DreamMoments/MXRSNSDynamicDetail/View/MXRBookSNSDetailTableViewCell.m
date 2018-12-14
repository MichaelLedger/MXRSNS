//
//  MXRBookSNSDetailTableViewCell.m
//  huashida_home
//
//  Created by shuai.wang on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSDetailTableViewCell.h"
#import "GlobalFunction.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "NSString+Ex.h"
#import "NSString+NSDate.h"

#define BookSNS_like MXRIMAGE(@"btn_bookSNS_like")
#define BookSNS_like_select MXRIMAGE(@"btn_bookSNS_like_select")
#define BookSNS_unlike MXRIMAGE(@"btn_bookSNS_unlike")

@interface MXRBookSNSDetailTableViewCell()

@end

@implementation MXRBookSNSDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.separateLine.backgroundColor = MXRCOLOR_CCCCCC;
    
    self.userHeaderView.userHeaderImageView.layer.borderWidth = 1;
    self.userHeaderView.userHeaderImageView.layer.borderColor = MXRCOLOR_CCCCCC.CGColor;
    self.lableZan.textColor = MXRCOLOR_999999;
    self.lableTime.textColor = MXRCOLOR_999999;
    
    self.lableComment.numberOfLines = 0;
    self.lableComment.translatesAutoresizingMaskIntoConstraints = NO;
    self.lableComment.textAlignment=NSTextAlignmentLeft;
    self.lableComment.font = MXRFONT_15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)addDataForCellWithModel:(MXRBookSNSDetailCommentListModel *)model{
    if (model.hasPraised == 0) {
        [self.buttonPraise setImage:BookSNS_like forState:UIControlStateNormal];
        [self.buttonPraise setImage:BookSNS_like_select forState:UIControlStateHighlighted];
    }else{
        [self.buttonPraise setImage:BookSNS_unlike forState:UIControlStateNormal];
    }


    self.lableName.text = model.userName;
    self.lableTime.text = [NSString convertTimeWithDateStr:model.createTime];
    if (model.praiseNum <= 0) {
        self.lableZan.text = @"";
    }else{
        self.lableZan.text = [NSString stringWithFormat:@"%ld",(long)model.praiseNum];
    }
    
    if ([MAIN_USERID isEqualToString:[NSString stringWithFormat:@"%ld",model.userId]]) {
        self.userHeaderView.headerUrl = CURRENT_USERICON_URL;
        self.userHeaderView.vip = [UserInformation modelInformation].vipFlag;
    }else {
        self.userHeaderView.headerUrl = model.userLogo;
        self.userHeaderView.vip = model.vipFlag;
    }
    
    self.lableComment.textColor = MXRCOLOR_333333;
    NSString *commentStr = nil;
    
    //model.sort 0 或者 1 表示正常评论  其它则为置顶评论
    if (model.sort != 0 && model.sort != -1) {
        self.lableName.textColor = MXRCOLOR_FF3B30;
        
        if (![model.srcUserName isEqualToString:@""])
        {
            commentStr = [NSString stringWithFormat:@"%@%@: %@",MXRLocalizedString(@"Comment_Reply", @"回复"),model.srcUserName,model.content];
            [self.lableComment setAttributedText:[self handleStringParagraphStyleWithString:commentStr whetherIsRetweetString:YES commentListModel:model whetherRecommended:YES]];
        }else{
            commentStr = model.content;
            [self.lableComment setAttributedText:[self handleStringParagraphStyleWithString:commentStr whetherIsRetweetString:NO commentListModel:model whetherRecommended:NO]];
            self.lableComment.textColor = MXRCOLOR_FF3B30;
        }
    }else{
        self.lableName.textColor = MXRCOLOR_333333;
        
        if (![model.srcUserName isEqualToString:@""])
        {
            commentStr = [NSString stringWithFormat:@"%@%@: %@",MXRLocalizedString(@"Comment_Reply", @"回复"),model.srcUserName,model.content];
            [self.lableComment setAttributedText:[self handleStringParagraphStyleWithString:commentStr whetherIsRetweetString:YES commentListModel:model whetherRecommended:NO]];
        }else{
            commentStr = model.content;
            [self.lableComment setAttributedText:[self handleStringParagraphStyleWithString:commentStr whetherIsRetweetString:NO commentListModel:model whetherRecommended:NO]];
        }
    }
}

#pragma mark - 文字行间距  \ 评论人名字变色处理
-(NSAttributedString *)handleStringParagraphStyleWithString:(NSString *)str whetherIsRetweetString:(BOOL)isRetweet commentListModel:(MXRBookSNSDetailCommentListModel *)model whetherRecommended:(BOOL)recommended{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    if (isRetweet == YES)
    {
        NSDictionary *dics=@{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2};
        [attributedString addAttributes:dics range:NSMakeRange(MXRLocalizedString(@"Comment_Reply", @"回复").length,model.srcUserName.length)];
    }
    
    if (recommended) {
        NSDictionary *dics=@{NSForegroundColorAttributeName:MXRCOLOR_FF3B30};
        [attributedString addAttributes:dics range:NSMakeRange([NSString stringWithFormat:@"%@%@: ",MXRLocalizedString(@"Comment_Reply", @"回复"),model.srcUserName].length,model.content.length)];
    }
    return attributedString;
}
#pragma mark - 点赞+1动画处理
-(void)showAddCountAnimationWithView:(UIView *)view{
    
    UILabel * animationLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, view.frame.size.width , view.frame.size.height)];
    animationLabel.text = @"+1";
    animationLabel.font = [UIFont systemFontOfSize:10];
    [view addSubview:animationLabel];
    animationLabel.textColor = RGB(28,180,138);
    [self.praiseAnimotion addSubview:animationLabel];
    [UIView animateWithDuration:1.0f animations:^{
        animationLabel.alpha = 0;
        animationLabel.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:^(BOOL finished)
     {
         [animationLabel removeFromSuperview];
     }];
}
@end
