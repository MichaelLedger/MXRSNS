//
//  MXRQuestionBannerCell.m
//  huashida_home
//
//  Created by MountainX on 2017/9/30.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRQuestionBannerCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "MXRBookSNSModelProxy.h"
#import "MXRBookSNSBannerModel.h"
#define MAS_SHORTHAND

@interface MXRQuestionBannerCell()

@property (nonatomic, strong)UIImageView *iv;

@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation MXRQuestionBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _iv = [[UIImageView alloc] init];
    _iv.backgroundColor = [UIColor lightGrayColor];
//    _iv.image = [UIImage imageNamed:@"question_banner.png"];
    MXRBookSNSBannerModel *bookSNSBannerModel = [MXRBookSNSModelProxy getInstance].bookSNSBannerArray.firstObject;
    [_iv sd_setImageWithURL:[NSURL URLWithString:[bookSNSBannerModel.bannerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:MXRIMAGE(@"btn_bookSNS_bannerPlaceholder")];
//    _iv.contentMode = UIViewContentModeScaleAspectFit;
    _iv.clipsToBounds = YES;
    _iv.layer.cornerRadius = 3.f;
    [self.contentView addSubview:_iv];
    
//    _titleLabel = [[UILabel alloc] init];
//    _titleLabel.backgroundColor = [UIColor purpleColor];
//    _titleLabel.text = @"小朋友，快来答题";
//    [self.contentView addSubview:_titleLabel];
    
    [_iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.equalTo(self.contentView);
        make.width.and.height.equalTo(self.contentView);
    }];
    
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(_iv);
//        make.width.equalTo(_iv);
//        make.height.equalTo(_iv).multipliedBy(1/3.0);
//    }];
}

@end
