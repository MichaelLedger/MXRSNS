//
//  MXRPKHomeNormalCollectionViewCell.m
//  huashida_home
//
//  Created by 周建顺 on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKHomeNormalCollectionViewCell.h"

#import "UIImageView+WebCache.h"

@interface MXRPKHomeNormalCollectionViewCell()
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *myContentView;

@end

@implementation MXRPKHomeNormalCollectionViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
   self = [super initWithCoder:aDecoder];
    if (self) {
      
    }
    return self;
}

-(void)setup{
    self.myContentView.layer.cornerRadius = 10.f;
    self.myContentView.layer.masksToBounds = YES;
}

-(void)setViewModel:(MXRPKHomeCellViewModel *)viewModel{
    _viewModel = viewModel;
    
    self.label.text = _viewModel.name;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_viewModel.pic] placeholderImage:nil];
}

-(void)dealloc{
    DLOG_METHOD
}

@end
