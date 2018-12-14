//
//  MXRPKMedalDetailView.m
//  huashida_home
//
//  Created by shuai.wang on 2018/1/20.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKMedalDetailView.h"
#import "MXRAdpterManager.h"
@interface MXRPKMedalDetailView()
@property (weak, nonatomic) IBOutlet UIImageView *medalIcon;
@property (weak, nonatomic) IBOutlet UILabel *medalConditionDescription;
@property (weak, nonatomic) IBOutlet UIButton *medalPromptBtn;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation MXRPKMedalDetailView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self.backgroundView.layer setMasksToBounds:YES];
    [self.backgroundView.layer setCornerRadius:12];
    
    [self.medalPromptBtn.layer setMasksToBounds:YES];
    [self.medalPromptBtn.layer setCornerRadius:8];
}

-(void)setPkMedalDetailModel:(MXRPKMedalDetailModel *)pkMedalDetailModel {
    _pkMedalDetailModel = pkMedalDetailModel;
    if (pkMedalDetailModel.isHold) {
        self.medalIcon.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:autoString([pkMedalDetailModel.iconActive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding])]]];
        [self.medalPromptBtn setTitleColor:MXRCOLOR_333333 forState:UIControlStateNormal];
        [self.medalPromptBtn setImage:MXRIMAGE(@"icon_pk_correctMark") forState:UIControlStateNormal];
        [self.medalPromptBtn setTitle:MXRLocalizedString(@"MXRPKMedalVC_Has_Obtain", @"已获得") forState:UIControlStateNormal];
    }else {
        [self.medalPromptBtn mxr_setGradientBackGoundStyle:MXRUIViewGradientStyle_80F0EA_29AAFE direction:MXRUIViewLinearGradientDirectionVertical];
        self.medalIcon.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:autoString([pkMedalDetailModel.iconInactive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding])]]];
        [self.medalPromptBtn setTitleColor:MXRCOLOR_FFFFFF  forState:UIControlStateNormal];
        [self.medalPromptBtn setTitle:MXRLocalizedString(@"MXRPKMedalVC_Leave_For", @"前往") forState:UIControlStateNormal];
    }

    self.medalConditionDescription.text = pkMedalDetailModel.qaMedalConditionDesc;

}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
}

- (IBAction)onMedalPromptButtonClick:(id)sender {
    if (self.medalPromptButtonCallback) {
        self.medalPromptButtonCallback(_pkMedalDetailModel,self);
    }
}

- (IBAction)onCloseButtonClick:(id)sender {
    if (self.closeCallback) {
        self.closeCallback(self);
    }
}
@end
