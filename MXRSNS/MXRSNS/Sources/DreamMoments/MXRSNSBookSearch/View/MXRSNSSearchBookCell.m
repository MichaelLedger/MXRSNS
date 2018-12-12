//
//  MXRSearchBookCell.m
//  huashida_home
//
//  Created by yuchen.li on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSNSSearchBookCell.h"
#import "BookInfoForShelf.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Extend.h"
#import "NSString+Ex.h"

#define EMPTY_STAR @"icon_common_bookStar_empty"
#define FILL_STAR @"icon_common_bookStar_fill"
#define HALF_STAR @"icon_common_bookStar_half"

@interface MXRSNSSearchBookCell()
@property (weak, nonatomic) IBOutlet UIImageView *oneStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoStarIamgeView;
@property (weak, nonatomic) IBOutlet UIImageView *threeStrarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fiveStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bookIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorLabelConstrain;

@end
@implementation MXRSNSSearchBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBook:(BookInfoForShelf *)book
{

    _book=book;    
    float starNum = [_book.star floatValue]/2;
    if (starNum == 0) {
        self.oneStarImageView.image = MXRIMAGE(EMPTY_STAR);
    }else if (starNum == 0.5){
        self.oneStarImageView.image = MXRIMAGE(HALF_STAR);
    }else{
        self.oneStarImageView.image = MXRIMAGE(FILL_STAR);
    }
    if (starNum <= 1) {
        self.twoStarIamgeView.image = MXRIMAGE(EMPTY_STAR);
    }else if (starNum == 1.5){
        self.twoStarIamgeView.image = MXRIMAGE(HALF_STAR);
    }else{
        self.twoStarIamgeView.image = MXRIMAGE(FILL_STAR);
    }
    if (starNum <= 2) {
        self.threeStrarImageView.image = MXRIMAGE(EMPTY_STAR);
    }else if (starNum == 2.5){
        self.threeStrarImageView.image = MXRIMAGE(HALF_STAR);
    }else{
        self.threeStrarImageView.image = MXRIMAGE(FILL_STAR);
    }
    if (starNum <= 3) {
        self.fourStarImageView.image = MXRIMAGE(EMPTY_STAR);
    }else if (starNum == 3.5){
        self.fourStarImageView.image = MXRIMAGE(HALF_STAR);
    }else{
        self.fourStarImageView.image = MXRIMAGE(FILL_STAR);
    }
    if (starNum <= 4) {
        self.fiveStarImageView.image = MXRIMAGE(EMPTY_STAR);
    }else if (starNum == 4.5){
        self.fiveStarImageView.image = MXRIMAGE(HALF_STAR);
    }else{
        self.fiveStarImageView.image = MXRIMAGE(FILL_STAR);
    }
    
    NSURL *starURL=book.bookIconUrlWithData;
    @MXRWeakObj(self);
    [_bookIconImageView sd_setImageWithURL:starURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            UIImage * lastImage = [image clipImageInRect:CGRectMake(0, 0, image.size.width, image.size.width)];
            selfWeak.bookIconImageView.image = lastImage;
        }else{
            selfWeak.bookIconImageView.image = MXRIMAGE(@"icon_common_bookIconPlaceholder");
        }
    }];
    _bookIconImageView.layer.borderWidth = 0.8f;
    _bookIconImageView.layer.borderColor = RGB(0xf3,0xf3, 0xf3).CGColor;
    _bookNameLabel.text = _book.bookName;
    self.seperatorLabelConstrain.constant = 0.5;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
