//
//  MXRTopSearchView.m
//  huashida_home
//
//  Created by 周建顺 on 15/9/22.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "MXRTopSearchView.h"
#import "GlobalFunction.h"
#import "NSString+Ex.h"
#define Border_Color RGB(212, 214, 216)
#define SpaceWidth 10
@interface MXRTopSearchView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textfieldHeight;
@end

@implementation MXRTopSearchView

+(instancetype)topSearchView{
    MXRTopSearchView *topSearchView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MXRTopSearchView" owner:nil options:nil] lastObject];
    
    return topSearchView;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];

    UIView *leftView = [[UIView alloc] init];
    CGFloat height = 25;
    
    UIImage *imageSearch = MXRIMAGE(@"btn_bookStore_search");
    imageSearch = [imageSearch imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 2, height-5, height-5)];
    imageView.image = imageSearch;

    imageView.tintColor = MXRCOLOR_999999;
    CGFloat splitHeight = height - 12;
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+8, (height - splitHeight)/2, 1, splitHeight)];
    splitView.backgroundColor = [UIColor magentaColor];
    splitView.alpha = 0.5;
    
    [leftView addSubview:imageView];
    leftView.frame = CGRectMake(0, 0, CGRectGetMaxX(splitView.frame), height);
    
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = leftView;
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.cornerRadius = 3;
    self.textField.textColor = [UIColor blackColor];
    [[UITextField appearance] setTintColor:MXRCOLOR_999999];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:MXRLocalizedString(@"Please_Import_BookName", @"请输入关键词搜索") attributes:
                                      @{NSForegroundColorAttributeName:MXRCOLOR_999999,
                                        NSFontAttributeName:self.textField.font
                                        }];
    self.textField.attributedPlaceholder = attrString;
    [self configureCancleButton];
    
    UIImage *image = MXRIMAGE(@"bg_topSearchView_searchBg");
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2) resizingMode:UIImageResizingModeStretch];
    self.textField.background = image;
}


-(void)configureCancleButton{
    [self.rightButton setImage:MXRIMAGE(@"btn_searchBook_searchClose") forState:UIControlStateNormal];
}

@end
