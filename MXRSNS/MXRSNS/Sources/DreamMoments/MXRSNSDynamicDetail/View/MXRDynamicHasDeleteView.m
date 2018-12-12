//
//  MXRDynamicHasDeleteView.m
//  huashida_home
//
//  Created by shuai.wang on 16/10/19.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRDynamicHasDeleteView.h"

@interface MXRDynamicHasDeleteView()
@property (weak, nonatomic) IBOutlet UIImageView *promptImage;

@end

@implementation MXRDynamicHasDeleteView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
  
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.promptLable.textColor = RGB(153, 153, 153);
    self.promptLable.font = [UIFont systemFontOfSize:18];
    self.promptLable.text = MXRLocalizedString(@"MomentHasBeenDeleted", @"该动态已删除");
    
    self.promptImage.image = MXRIMAGE(@"img_dynamicHasDeleteView_prompt");
}

@end
