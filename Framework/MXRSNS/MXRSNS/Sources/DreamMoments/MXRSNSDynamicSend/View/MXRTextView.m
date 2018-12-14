//
//  MXRTextView.m
//  huashida_home
//
//  Created by yuchen.li on 2017/7/4.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRTextView.h"

@implementation MXRTextView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    _disableEditNum = 0;
    _disablePasteTopic = NO;
}

-(instancetype)init{
    
    if (self = [super init]) {
        _disableEditNum = 0;
        _disablePasteTopic = NO;
    }
    return self;
}

// 删除键
- (void)deleteBackward{
    if (self.text.length <= self.disableEditNum) {
        return;
    }else{
        [super deleteBackward];
    }
}

// 菜单栏
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
        // 有"#“号禁止粘贴
        if (action == @selector(paste:) && self.disablePasteTopic)
        {
            return ![[UIPasteboard generalPasteboard].string containsString:@"#"];
        }
    
        return [super canPerformAction:action withSender:sender];
}
@end
