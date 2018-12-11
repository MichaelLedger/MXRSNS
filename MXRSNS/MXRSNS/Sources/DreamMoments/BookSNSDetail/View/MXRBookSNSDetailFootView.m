//
//  MXRBookSNSDetailFootView.m
//  huashida_home
//
//  Created by shuai.wang on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSDetailFootView.h"
@implementation MXRBookSNSDetailFootView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.bottomView.backgroundColor = RGBA(230, 230, 230, 1);
    
    [self.commentButton setBackgroundImage:MXRIMAGE(@"btn_bookSNS_comment") forState:UIControlStateNormal];
    [self.retweetButton setBackgroundImage:MXRIMAGE(@"btn_bookSNS_forward") forState:UIControlStateNormal];
}
@end
