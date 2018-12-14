//
//  MXRBookSNSSearchBookBeforeView.m
//  huashida_home
//
//  Created by yuchen.li on 16/9/22.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSSearchBookBeforeView.h"
#import "UIImage+Extend.h"
@interface MXRBookSNSSearchBookBeforeView()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftBookIconImage;


@end
@implementation MXRBookSNSSearchBookBeforeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MXRBookSNSSearchBookBeforeView" owner:nil options:nil] lastObject];
        self.frame = frame;
        self.tipLabel.text = MXRLocalizedString(@"MXRBookSNSSearchBookBeforeView_Add_A_Book", @"为你的动态添加一本图书吧");
        self.autoresizingMask = NO;
    }
   return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.searchImageView.tintColor = RGB(0xcc, 0xcc, 0xcc);
    self.searchImageView.image = [UIImage imageNamedUseTintColor:@"icon_common_arrows"];
    self.leftBookIconImage.image = MXRIMAGE(@"icon_bookSNSSearchBookBeforeView_bookIcon");
}

@end
