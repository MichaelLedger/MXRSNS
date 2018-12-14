
//  MXRCopySysytemActionSheet.m
//  huashida_home
//
//  Created by lj on 16/5/26.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRCopySysytemActionSheet.h"
#define titleHeight 45
#define btnHeight 55
#define vertialSpace 8
@interface MXRCopySysytemActionSheet()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *btnBgView;
@property (nonatomic, strong) UIView *topBtnBgView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MXRCopySysytemActionSheet
{
    BOOL isShow;
}
-(instancetype)initWithFrame:(CGRect)frame withBtns:(NSArray*)btns withCancelBtn:(NSString*)cancelBtn withDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configViewWithBtns:btns WithCancelBtn:cancelBtn ];
        self.delegate = delegate;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString*)title withBtns:(NSArray*)btns withCancelBtn:(NSString*)cancelBtn withDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configViewWithBtns:btns WithCancelBtn:cancelBtn Withtitle:title];
        self.delegate = delegate;
    }
    return self;
}
-(void)dealloc{

    
}
-(void)touchBgHideActionSheet{

    [self hideActionSheet];
    if ([self.delegate respondsToSelector:@selector(sheetHidden)]) {
        [self.delegate sheetHidden];
    }
}
//有title
-(void)configViewWithBtns:(NSArray*)btns WithCancelBtn:(NSString*)cancelBtn Withtitle:(NSString*)title
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBgHideActionSheet)];
    [self.bgImageView addGestureRecognizer:tap];
    [self addSubview:self.bgImageView];
    
    BOOL hasTitle = NO;
    if (!(title == nil || [[title stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])) {
        hasTitle = YES;
        
    }
    BOOL hasCancel = NO;
    NSInteger btnTotalCount = 0;
    if (!(cancelBtn == nil || [[cancelBtn stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])) {
        hasCancel = YES;
        btnTotalCount++;
    }
    btnTotalCount+=btns.count;
    self.btnBgView.frame = CGRectMake((SCREEN_WIDTH_DEVICE-(SCREEN_WIDTH_DEVICE_ABSOLUTE-20))/2.0, SCREEN_HEIGHT_DEVICE-btnTotalCount*btnHeight-(hasCancel?2:1)*vertialSpace-(hasTitle?titleHeight:0), SCREEN_WIDTH_DEVICE_ABSOLUTE-20, btnHeight*btnTotalCount+vertialSpace+(hasTitle?titleHeight:0));
    [self addSubview:self.btnBgView];
    
    _topBtnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _btnBgView.frame.size.width, btnHeight*(btnTotalCount-(hasCancel?1:0))+(hasTitle?titleHeight:0))];
    [self.btnBgView addSubview:_topBtnBgView];
    _topBtnBgView.clipsToBounds = YES;
    _topBtnBgView.layer.cornerRadius = 12;
    
    if (hasTitle) {
        self.titleLabel.frame = CGRectMake(0, 0, _topBtnBgView.frame.size.width, titleHeight);
        [self.titleLabel setText:title];
        [_topBtnBgView addSubview:self.titleLabel];
    }
    NSInteger index = 0;
    for (NSString *btnName in btns) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnName forState:UIControlStateNormal];
        [btn setTitleColor:RGB(16, 115, 250) forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, index*btnHeight+(hasTitle?titleHeight:0), SCREEN_WIDTH_DEVICE_ABSOLUTE-20, btnHeight);
        btn.tag = ++index;
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[self imageWithColor:RGB(232, 232, 232)] forState:UIControlStateHighlighted];
        [_topBtnBgView addSubview:btn];
        if (hasCancel) {
            if (index<=btnTotalCount-1) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.frame.origin.y-0.5, _btnBgView.frame.size.width, 0.5)];
                [label setBackgroundColor:RGBA(0, 0, 0, 0.2)];
                [_topBtnBgView addSubview:label];
            }
        }
        else
        {
            if (index<=btnTotalCount)
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.frame.origin.y-0.5, _btnBgView.frame.size.width, 0.5)];
                [label setBackgroundColor:RGBA(0, 0, 0, 0.2)];
                [_topBtnBgView addSubview:label];
            }
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:19.0f];
    }
    if (hasCancel)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:cancelBtn forState:UIControlStateNormal];
        [btn setTitleColor:RGB(16, 115, 250) forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, _btnBgView.frame.size.height-btnHeight, SCREEN_WIDTH_DEVICE_ABSOLUTE-20, btnHeight);
        btn.tag = btnTotalCount;
        btn.layer.cornerRadius = 12;
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[self imageWithColor:RGB(232, 232, 232)] forState:UIControlStateHighlighted];
        [_btnBgView addSubview:btn];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    }
}
//没有title
-(void)configViewWithBtns:(NSArray*)btns WithCancelBtn:(NSString*)cancelBtn
{
    [self configViewWithBtns:btns WithCancelBtn:cancelBtn Withtitle:nil];
}

-(void)btnAction:(UIButton *)sender
{
    UIButton *btn = (UIButton*)sender;
    if ([_delegate respondsToSelector:@selector(actionSheetNew:clickedButtonAtIndex:)]) {
        [_delegate actionSheetNew:self clickedButtonAtIndex:btn.tag-1];
    }
    if ([_delegate respondsToSelector:@selector(actionSheetNew:clickedButtonAtIndex:andClickedButtonTitle:)]) {
        [_delegate actionSheetNew:self clickedButtonAtIndex:btn.tag-1 andClickedButtonTitle:sender.currentTitle];
    }
    [self hideActionSheet];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)hideActionSheet
{
    isShow = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _bgImageView.alpha = 0;
        CGRect frame = _btnBgView.frame;
        frame.origin.y = SCREEN_HEIGHT_DEVICE;
        _btnBgView.frame = frame;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
-(void)hiddenSelfNoAnimation{

    isShow = NO;
    [self removeFromSuperview];
}
-(void)show
{
    CGRect frame = _btnBgView.frame;
    frame.origin.y = SCREEN_HEIGHT_DEVICE;
    _btnBgView.frame = frame;
    _bgImageView.alpha = 0;
    isShow = YES;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
//    UIWindow * window = [UIApplication sharedApplication].keyWindow;
//    if (!window)
//        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//    [window addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        _bgImageView.alpha = 1;
        CGRect frame = _btnBgView.frame;
        frame.origin.y = SCREEN_HEIGHT_DEVICE-frame.size.height-vertialSpace;
        _btnBgView.frame = frame;
    }];
    
}
-(void)showOnView:(UIView *)showOnView{
    
    CGRect frame = self.btnBgView.frame;
    frame.origin.y = SCREEN_HEIGHT_DEVICE;
    self.btnBgView.frame = frame;
    self.bgImageView.alpha = 0;
    isShow = YES;
    [showOnView addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        self.bgImageView.alpha = 1;
        CGRect frame = _btnBgView.frame;
        frame.origin.y = SCREEN_HEIGHT_DEVICE-frame.size.height-vertialSpace;
        self.btnBgView.frame = frame;
    }];
    
}
-(BOOL)getIsShow
{
    return isShow;
}
#pragma mark - getter
-(UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setBackgroundColor:[UIColor whiteColor]];
        [_titleLabel setTextColor:[UIColor grayColor]];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    }
    return _titleLabel;
}

-(UIImageView*)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_bgImageView setBackgroundColor:RGBA(0, 0, 0, 0.6)];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

-(UIView*)btnBgView
{
    if (!_btnBgView) {
        _btnBgView = [[UIView alloc] init];
        _btnBgView.backgroundColor = [UIColor clearColor];
        _btnBgView.layer.cornerRadius = 10;
        _btnBgView.clipsToBounds = YES;
    }
    return _btnBgView;
}

@end
