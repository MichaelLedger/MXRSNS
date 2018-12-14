//
//  MXRSNSSearchNoBookView.m
//  huashida_home
//
//  Created by yuchen.li on 16/9/19.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSNSSearchNoBookView.h"
@interface MXRSNSSearchNoBookView ()

@property (weak, nonatomic) IBOutlet UILabel *noFindBookLabel;

@end
@implementation MXRSNSSearchNoBookView

-(instancetype)initWithFrame:(CGRect)frame withText:(NSString *)text withPromptText:(NSString *)promptText andImageName:(NSString *)imgName{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MXRSNSSearchNoBookView" owner:nil options:nil] lastObject];
        self.frame = frame;
        self.autoresizingMask = NO;
        self.userInteractionEnabled = YES;
        self.noFindBookLabel.text = text;
        self.imageSearch.image = MXRIMAGE(imgName);
        [self.promptBtn setTitle:promptText forState:UIControlStateNormal];
        [self.promptBtn setTitleColor:RGB(6, 119, 184) forState:UIControlStateNormal];
    }
    return self;
}

@end
