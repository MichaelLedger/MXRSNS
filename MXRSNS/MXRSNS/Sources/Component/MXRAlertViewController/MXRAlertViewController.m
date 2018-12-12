//
//  MXRAlertViewController.m
//  huashida_home
//
//  Created by MountainX on 2018/11/1.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRAlertViewController.h"

@interface MXRAlertViewController ()
{
    NSString *_alertTitle;
    NSString *_alertContent;
    NSString *_okBtnTitle;
    NSString *_cancelBtnTitle;
    NSString *_confirmBtnTitle;
}

@property (weak, nonatomic) IBOutlet UIView *alertContentView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *alertTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MXRAlertViewController

#pragma mark - Public Method
- (instancetype)initWithAlertType:(MXRAlertType)type title:(NSString *)title alertContent:(NSString *)alertContent okBtnTitle:(NSString *)okBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle confirmBtnTitle:(NSString *)confirmBtnTitle {
    if (self = [super init]) {
        _alertType = type;
        _alertTitle = title;
        _alertContent = [self changeObjectTypeToString:alertContent];
        _okBtnTitle = okBtnTitle ?: MXRLocalizedString(@"OKay", @"好的");
        _cancelBtnTitle = cancelBtnTitle ?: MXRLocalizedString(@"CANCEL", @"取消");
        _confirmBtnTitle = confirmBtnTitle ?: MXRLocalizedString(@"SURE", @"确定");
    }
    return self;
}

- (void)show {
    [self showAtTop];
}

- (void)hide {
    __weak __typeof(self) weakSelf = self;
    //产品要求去除动画效果
    [self dismissViewControllerAnimated:NO completion:^{
        if (weakSelf.okButton.selected) {
            if (weakSelf.okBlock) {
                weakSelf.okBlock();
            }
        } else if (weakSelf.cancelButton.selected) {
            if (weakSelf.cancelBlock) {
                weakSelf.cancelBlock();
            }
        } else if (weakSelf.confirmButton.selected) {
            if (weakSelf.confirmBlock) {
                weakSelf.confirmBlock();
            }
        }
    }];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (_alertType) {
        case MXRAlertTypeOK:
        {
            _okButton.hidden = NO;
            _cancelButton.hidden = YES;
            _confirmButton.hidden = YES;
        }
            break;
        case MXRAlertTypeConfirm:
        {
            _okButton.hidden = YES;
            _cancelButton.hidden = NO;
            _confirmButton.hidden = NO;
        }
            break;
        default:
        {
            _okButton.hidden = NO;
            _cancelButton.hidden = YES;
            _confirmButton.hidden = YES;
        }
            break;
    }
    _titleLabel.text = _alertTitle;
    _alertTitleLabel.text = _alertContent;
    [_okButton setTitle:_okBtnTitle forState:UIControlStateNormal];
    [_cancelButton setTitle:_cancelBtnTitle forState:UIControlStateNormal];
    [_confirmButton setTitle:_confirmBtnTitle forState:UIControlStateNormal];
    
    if (autoString(_alertTitle).length > 0) {
        _alertTitleLabel.font = [UIFont systemFontOfSize:14];
    } else {
        _alertTitleLabel.font = [UIFont systemFontOfSize:18];
    }
    
    _closeButton.hidden = _hideCloseBtn;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark - IBAction
- (IBAction)closeBtnClicked:(UIButton *)sender {
    sender.selected = YES;
    [self hide];
}

- (IBAction)cancelBtnClicked:(UIButton *)sender {
    sender.selected = YES;
    [self hide];
}

- (IBAction)confirmBtnClicked:(UIButton *)sender {
    sender.selected = YES;
    [self hide];
}

- (IBAction)okBtnClicked:(UIButton *)sender {
    sender.selected = YES;
    [self hide];
}

#pragma mark - Helper
-(NSString *)changeObjectTypeToString:(id)value{
    if (value == nil || value == [NSNull null]) {
        return @"";
    }else if  ([value isKindOfClass:[NSString class]]){
        return value;
    }else  if ([value isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%@",value];
    }
    return @"";
}

- (void)showAtTop {
    UIViewController *topVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while ([[topVc.childViewControllers  lastObject] presentedViewController]) {
        topVc = [[topVc.childViewControllers lastObject] presentedViewController];
    }
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [topVc presentViewController:self animated:NO completion:nil];//产品要求去除动画效果
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
