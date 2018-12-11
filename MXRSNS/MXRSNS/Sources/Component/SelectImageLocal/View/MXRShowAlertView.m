//
//  MXRShowAlertView.m
//  huashida_home
//
//  Created by MinJing_Lin on 2018/8/13.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRShowAlertView.h"

@interface MXRShowAlertView ()
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel  *titleLabel;


@end

@implementation MXRShowAlertView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = MXRLocalizedString(@"MXR_Delete_Video_Text",@"是否删除视频");
    [self.deleteBtn setTitle:MXRLocalizedString(@"DELETE",@"删除") forState:UIControlStateNormal];
    [self.cancelBtn setTitle:MXRLocalizedString(@"CANCEL" ,@"取消") forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)deteteBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(alertViewShow:clickedButtonAtIndex:)]) {
        [self.delegate alertViewShow:self clickedButtonAtIndex:0];
    }
    [self closeBtnClciked:nil];
}

- (IBAction)cancelBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(alertViewShow:clickedButtonAtIndex:)]) {
        [self.delegate alertViewShow:self clickedButtonAtIndex:1];
    }
    [self closeBtnClciked:nil];
}

- (IBAction)closeBtnClciked:(id)sender {
    
    [self willMoveToParentViewController:nil]; //1
    [self.view removeFromSuperview]; //2
    [self removeFromParentViewController]; //3
}
@end
