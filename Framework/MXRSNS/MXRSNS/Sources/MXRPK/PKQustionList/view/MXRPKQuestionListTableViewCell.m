//
//  MXRPKQuestionListTableViewCell.m
//  huashida_home
//
//  Created by MountainX on 2018/8/8.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKQuestionListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface MXRPKQuestionListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *bookCover;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *mineStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;

@end

@implementation MXRPKQuestionListTableViewCell

static NSString *cellIdentifier = @"MXRPKQuestionListTableViewCell";
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    MXRPKQuestionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MXRPKQuestionListTableViewCell"owner:nil options:nil] firstObject];
//        cell = [[MXRPKQuestionListTableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)setModel:(MXRPKQuestionListModel *)model {
    _model = model;
    
    [_bookCover sd_setImageWithURL:[NSURL URLWithString:autoString(_model.coverUrl)] placeholderImage:MXR_BOOK_ICON_PLACEHOLDER_IMAGE];
    
    _bookNameLabel.text = autoString(model.name);
    
    NSString *subject = MXRLocalizedString(@"MXR_PK_QUESTIONS_SUBJECTS", @"题");
    NSString *questionNumStr = [NSString stringWithFormat:@"%ld%@", _model.questionNum, subject];
    NSMutableAttributedString *questionNumAttr = [[NSMutableAttributedString alloc] initWithString:questionNumStr];
    [questionNumAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_2FB8E2 range:NSMakeRange(0, questionNumStr.length - subject.length)];
    [questionNumAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_999999 range:NSMakeRange(questionNumStr.length - subject.length, subject.length)];
    _questionNumLabel.attributedText = questionNumAttr;
    
    NSString *averageAccuracy = MXRLocalizedString(@"MXR_PK_AVERAGE_CORRECT_RATE", @"平均正确率:");
    NSString *averageAccuracyStr = [NSString stringWithFormat:@"%@%ld%%", averageAccuracy, _model.avgAccuracy];
    NSMutableAttributedString *averageAccuracyAttr = [[NSMutableAttributedString alloc] initWithString:averageAccuracyStr];
    [averageAccuracyAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_999999 range:NSMakeRange(0, averageAccuracy.length)];
    [averageAccuracyAttr addAttribute:NSForegroundColorAttributeName value:_model.avgAccuracy > 60 ? MXRCOLOR_4A90E2 : MXRCOLOR_FF001F range:NSMakeRange(averageAccuracy.length, averageAccuracyStr.length - averageAccuracy.length)];
    _accuracyLabel.attributedText = averageAccuracyAttr;
    
    if (_model.isPartIn) {
        NSString *mineAccuracy = MXRLocalizedString(@"MXR_PK_MINE_ACCURACY", @"我的正确率:");
        NSString *mineAccuracyStr = [NSString stringWithFormat:@"%@%ld%%", mineAccuracy, _model.accuracy];
        NSMutableAttributedString *mineAccuracyAttr = [[NSMutableAttributedString alloc] initWithString:mineAccuracyStr];
        [mineAccuracyAttr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_999999 range:NSMakeRange(0, mineAccuracy.length)];
        [mineAccuracyAttr addAttribute:NSForegroundColorAttributeName value:_model.avgAccuracy > 60 ? MXRCOLOR_6AC500 : MXRCOLOR_FF001F range:NSMakeRange(mineAccuracy.length, mineAccuracyAttr.length - mineAccuracy.length)];
        _mineStatusLabel.attributedText = mineAccuracyAttr;
    } else {
        _mineStatusLabel.text = MXRLocalizedString(@"MXR_PK_PARTICIPATE_PROMPT", @"还未参与哦，赶紧来吧");
    }
}

@end
