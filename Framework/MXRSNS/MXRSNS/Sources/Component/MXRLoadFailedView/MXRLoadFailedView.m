//
//  MXRLoadFailedView.m
//  huashida_home
//
//  Created by 周建顺 on 15/10/10.
//  Copyright © 2015年 mxrcorp. All rights reserved.
//

#import "MXRLoadFailedView.h"
#import "DimensMacro.h"

@interface MXRLoadFailedView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTop;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIButton *tryAgainButton;

@end

@implementation MXRLoadFailedView 

+(instancetype)loadFailedView{
    MXRLoadFailedView *view = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MXRLoadFailedView" owner:nil options:nil] firstObject];
    return view;
}

-(void)awakeFromNib{
    [super awakeFromNib];

    self.contentViewTop.constant = MXR_NO_DATE_VIEW_TOP_TO_64NAVIBAR + TOP_BAR_HEIGHT;
    self.infoLabel.text = MXRLocalizedString(@"MXRLoadFailedView_No_Network", @"好像网络连接有问题");
    [self.tryAgainButton setTitle:MXRLocalizedString(@"MXRLoadFailedView_Try_Again", @"点击重试") forState:UIControlStateNormal];

}

- (IBAction)buttonTapped:(UIButton *)sender {
    if (self.refreshTapped) {
        self.refreshTapped(self);
    }
}

@end
