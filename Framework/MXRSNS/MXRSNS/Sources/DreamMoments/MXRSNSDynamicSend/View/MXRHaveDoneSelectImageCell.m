//
//  MXRHaveDoneSelectImageCell.m
//  huashida_home
//
//  Created by yuchen.li on 16/9/20.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRHaveDoneSelectImageCell.h"
@interface MXRHaveDoneSelectImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *isDeleteImageView;

@end
@implementation MXRHaveDoneSelectImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)configureWithImage:(UIImage *)image {
    
    _mainImageView.image = image;
    _isDeleteImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteActionClick)];
    [_isDeleteImageView addGestureRecognizer:tap];
    UIImage *addImage = MXRIMAGE(@"btn_bookSNS_addPicture_nor");
    if ([image isEqual:addImage]) {
        _isDeleteImageView.hidden = YES;
    }else{
        _isDeleteImageView.hidden = NO;
        _isDeleteImageView.image  = MXRIMAGE(@"btn_bookSNS_deletepicture_nor");
    }
    
}
//黑pad [image isEqual:addImage]的返回值一直为nil 
-(void)setIsShowDelete:(BOOL)isShowDelete{
    if (isShowDelete) {
        _isDeleteImageView.hidden = NO;
        _isDeleteImageView.image  = MXRIMAGE(@"btn_bookSNS_deletepicture_nor");
    }else{
        _isDeleteImageView.hidden = YES;
    }

}
-(void)deleteActionClick{
    [self.delegate userClickDeleteSelectImageWithCell:self];
}
@end
