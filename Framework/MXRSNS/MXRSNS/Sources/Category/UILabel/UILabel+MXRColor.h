//
//  UILabel+MXRColor.h
//  huashida_home
//
//  Created by MinJing_Lin on 2018/8/28.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MXRColor)

#pragma mark - 改变字的颜色
/**
 *  改变所有字段的颜色
 */
- (void)changeStrokeColorWithTextStrikethroughColor:(UIColor *)textStrokeColor;

/**
 改变句中某些字段的颜色
 
 @param textStrokeColor 改变的颜色
 @param text 改变的字段
 */
- (void)changeStrokeColorWithTextStrikethroughColor:(UIColor *)textStrokeColor changeText:(NSString *)text;

#pragma mark - 改变字段字体
/**
 *  改变句中所有的字体
 *
 *  @param textFont 改变的字体
 */
- (void)changeFontWithTextFont:(UIFont *)textFont;
/**
 *  改变句中某些字段的字体
 *
 *  @param textFont 改变的字体
 *  @param text     改变的字段
 */
- (void)changeFontWithTextFont:(UIFont *)textFont changeText:(NSString *)text;

#pragma mark - 改变行间距
/**
 *  改变句中所有的行间距
 *
 *  @param lineSpace 改变的行间距
 */
- (void)changeLineSpaceWithTextLineSpace:(CGFloat)textLineSpace;

/**
 *  改变句中段落样式
 *
 *  @param paragraphStyle 段落样式
 */
- (void)changeParagraphStyleWithTextParagraphStyle:(NSParagraphStyle *)paragraphStyle;

@end
