//
//  MXRPKHomeHeaderView.m
//  huashida_home
//
//  Created by 周建顺 on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKHomeHeaderView.h"

#import "UIImageView+WebCache.h"
#import "NSString+Ex.h"
#import "MXRUserHeaderView.h"

#define OBSERVER_NICKNAME_KEY @"nickName"
#define OBSERVER_USERICON_KEY @"userIcon"
#define OBSERVER_MEDALSCOUNT_KEY @"medalsCount"
#define OBSERVER_RECORDS_KEY @"records"


@interface MXRPKHomeHeaderView()

@property (strong, nonatomic) IBOutlet UIView *myContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *myContainerBgImageView;

@property (strong, nonatomic) IBOutlet UIView *userIconContainerView;
@property (strong, nonatomic) IBOutlet MXRUserHeaderView *userHeaderView;

@property (strong, nonatomic) IBOutlet UIView *headerContainerView;
@property (strong, nonatomic) IBOutlet UILabel *userNameView;
@property (strong, nonatomic) IBOutlet UILabel *recordLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *medalButtons;

@end

@implementation MXRPKHomeHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    

    [_medalButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj;
        button.userInteractionEnabled = NO;
        [button setImage:MXRIMAGE(@"icon_pk_home_medals_normal") forState:UIControlStateNormal];
        [button setImage:MXRIMAGE(@"icon_pk_home_medals_selected") forState:UIControlStateSelected];
        [button setTitle:nil forState:UIControlStateNormal];
       // button.translatesAutoresizingMaskIntoConstraints
        [NSLayoutConstraint  constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeHeight multiplier:(40.f/48.f) constant:0.f];
    }];
    [self setup ];
}

-(void)dealloc{
    DLOG_METHOD
    [self removeObserversWithVM:_headerViewModel];
}

#pragma mark - UI
-(void)setup{
    self.myContainerView.layer.cornerRadius = 10.f;
    self.myContainerView.layer.masksToBounds = YES;
    self.myContainerView.layer.borderColor =  RGBHEX(0x29AAFE).CGColor;
    self.myContainerView.layer.borderWidth = 1;
    
    self.myContainerBgImageView.image = MXRGRADIENTIMAGEWITHSTYLEMAIN(MXRUIViewGradientStyle_009FD8_022D71);
    
    // 头像
    BOOL isUserVip = [UserInformation modelInformation].vipFlag;       
    self.userHeaderView.vip = isUserVip;
    if (!isUserVip) {
        self.userIconContainerView.layer.cornerRadius = 30.f;
        self.userIconContainerView.layer.masksToBounds = YES;
        self.userIconContainerView.layer.borderColor =  [UIColor whiteColor].CGColor;
        self.userIconContainerView.layer.borderWidth = 3;
    }
}

// update UI
-(void)updateNickName{
    self.userNameView.text = _headerViewModel.nickName;
}

-(void)updateUserIcon{
    self.userHeaderView.headerUrl = [NSString encodeUrlString:_headerViewModel.userIcon];
}

-(void)updateMedals{
    [self.medalButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj;
        if (idx < _headerViewModel.medalsCount) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }];
}

-(void)updateRecords{
    DLOG_METHOD
    self.recordLabel.text = _headerViewModel.records;
    [self.recordLabel layoutIfNeeded];
    // [self.recordLabel sizeToFit];
    self.recordLabel.attributedText =  [self maxFontSizeWithFontSize:31 str:_headerViewModel.records inWidth:CGRectGetWidth(self.recordLabel.frame)];
}

-(NSAttributedString*)maxFontSizeWithFontSize:(NSInteger)fontSize str:(NSString*)str inWidth:(CGFloat)width{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold]};
    CGSize size = [str sizeWithAttributes:attrs];
    
    if (fontSize<15) {
        
        return [[NSAttributedString alloc ] initWithString:str attributes:attrs];
    }
    
    if (size.width>width) {
        return [self maxFontSizeWithFontSize:(fontSize - 1) str:str inWidth:width];
    }else{
        return [[NSAttributedString alloc ] initWithString:str attributes:attrs];
    }
}

#pragma mark - setters

-(void)setHeaderViewModel:(MXRPKHomeHeaderViewModel *)headerViewModel{
    [self removeObserversWithVM:_headerViewModel];
    _headerViewModel = headerViewModel;
    [self addObserversWithVM:headerViewModel];
    
    [self updateNickName];
    [self updateUserIcon];
    [self updateMedals];
    [self updateRecords];
}

#pragma mark -actions

- (IBAction)goMedalsAction:(id)sender {
    if (self.goMedalsBlock) {
        self.goMedalsBlock(self);
    }
}


#pragma mark - obervsers
-(void)addObserversWithVM:(MXRPKHomeHeaderViewModel *)headerViewModel{
    
    [headerViewModel addObserver:self forKeyPath:OBSERVER_NICKNAME_KEY options:NSKeyValueObservingOptionNew context:nil];
     [headerViewModel addObserver:self forKeyPath:OBSERVER_USERICON_KEY options:NSKeyValueObservingOptionNew context:nil];
     [headerViewModel addObserver:self forKeyPath:OBSERVER_MEDALSCOUNT_KEY options:NSKeyValueObservingOptionNew context:nil];
     [headerViewModel addObserver:self forKeyPath:OBSERVER_RECORDS_KEY options:NSKeyValueObservingOptionNew context:nil];

}

-(void)removeObserversWithVM:(MXRPKHomeHeaderViewModel *)headerViewModel{
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_NICKNAME_KEY];
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_USERICON_KEY];
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_MEDALSCOUNT_KEY];
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_RECORDS_KEY];

}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:OBSERVER_NICKNAME_KEY]) {
        [self updateNickName];
    }else if([keyPath isEqualToString:OBSERVER_USERICON_KEY]){
        [self updateUserIcon];
    }else if([keyPath isEqualToString:OBSERVER_MEDALSCOUNT_KEY]){
        [self updateMedals];
    }else if([keyPath isEqualToString:OBSERVER_RECORDS_KEY]){
        [self updateRecords];
    }
    
}


@end
