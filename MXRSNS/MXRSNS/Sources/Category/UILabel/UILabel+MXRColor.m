//
//  UILabel+MXRColor.m
//  huashida_home
//
//  Created by MinJing_Lin on 2018/8/28.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "UILabel+MXRColor.h"

@implementation UILabel (MXRColor)

#pragma mark - 改变字的颜色
- (void)changeStrokeColorWithTextStrikethroughColor:(UIColor *)textStrokeColor
{
    [self changeStrokeColorWithTextStrikethroughColor:textStrokeColor changeText:self.text];
}
- (void)changeStrokeColorWithTextStrikethroughColor:(UIColor *)textStrokeColor changeText:(NSString *)text
{
    if (!text) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:textStrokeColor range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字段字体
- (void)changeFontWithTextFont:(UIFont *)textFont
{
    [self changeFontWithTextFont:textFont changeText:self.text];
}
- (void)changeFontWithTextFont:(UIFont *)textFont changeText:(NSString *)text
{
    if (!text) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSCaseInsensitiveSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSFontAttributeName value:textFont range:textRange];
    }
    self.attributedText = attributedString;
}

- (void)changeLineSpaceWithTextLineSpace:(CGFloat)textLineSpace
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:textLineSpace];
    [self changeParagraphStyleWithTextParagraphStyle:paragraphStyle];
}
#pragma mark - 段落样式
- (void)changeParagraphStyleWithTextParagraphStyle:(NSParagraphStyle *)paragraphStyle
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    [self setAttributedText:attributedString];
}

@end
