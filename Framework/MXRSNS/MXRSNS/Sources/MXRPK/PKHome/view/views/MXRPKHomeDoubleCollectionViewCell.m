//
//  MXRPKHomeDoubleCollectionViewCell.m
//  huashida_home
//
//  Created by 周建顺 on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKHomeDoubleCollectionViewCell.h"

@interface MXRPKHomeDoubleCollectionViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *myContentView;

@end


@implementation MXRPKHomeDoubleCollectionViewCell

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

-(void)setViewModel:(MXRPKHomeCellDoubleViewModel *)viewModel{
    _viewModel = viewModel;
    UIImage *image = [UIImage imageNamed:_viewModel.localImageName];
    self.imageView.image = image;
}


@end
