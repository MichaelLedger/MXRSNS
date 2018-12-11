//
//  MXRMXRBookSNSSearchBookAfterView.m
//  huashida_home
//
//  Created by yuchen.li on 16/9/22.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSSearchBookAfterView.h"
#import "BookInfoForShelf.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Extend.h"
#import "NSString+Ex.h"

#define EMPTY_STAR @"icon_common_bookStar_empty"
#define FILL_STAR @"icon_common_bookStar_fill"
#define HALF_STAR @"icon_common_bookStar_half"

@interface MXRBookSNSSearchBookAfterView()

@property (weak, nonatomic) IBOutlet UIImageView *rightArrowsImage;

@end

@implementation MXRBookSNSSearchBookAfterView

-(instancetype)initWithFrame:(CGRect)frame WithBookShelfModel:(BookInfoForShelf*)book
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"MXRBookSNSSearchBookAfterView" owner:nil options:nil] lastObject];
        self.frame = frame;
        self.autoresizingMask = NO;
        //若没有星星等级，默认为10
        if ([book.star integerValue] == 0) {
            book.star = @10;
        }
        float starNum = [book.star floatValue] / 2;
        if (starNum == 0) {
            self.oneImageView.image = MXRIMAGE(EMPTY_STAR);
        }else if (starNum == 0.5){
            self.oneImageView.image = MXRIMAGE(HALF_STAR);
        }else{
            self.oneImageView.image = MXRIMAGE(FILL_STAR);
        }
        if (starNum <= 1) {
            self.twoImageView.image = MXRIMAGE(EMPTY_STAR);
        }else if (starNum == 1.5){
            self.twoImageView.image = MXRIMAGE(HALF_STAR);
        }else{
            self.twoImageView.image = MXRIMAGE(FILL_STAR);
        }
        if (starNum <= 2) {
            self.threeIamgeView.image = MXRIMAGE(EMPTY_STAR);
        }else if (starNum == 2.5){
            self.threeIamgeView.image = MXRIMAGE(HALF_STAR);
        }else{
            self.threeIamgeView.image = MXRIMAGE(FILL_STAR);
        }
        if (starNum <= 3) {
            self.fourIamgeView.image = MXRIMAGE(EMPTY_STAR);
        }else if (starNum == 3.5){
            self.fourIamgeView.image = MXRIMAGE(HALF_STAR);
        }else{
            self.fourIamgeView.image = MXRIMAGE(FILL_STAR);
        }
        if (starNum <= 4) {
            self.fiveImageView.image = MXRIMAGE(EMPTY_STAR);
        }else if (starNum == 4.5){
            self.fiveImageView.image = MXRIMAGE(HALF_STAR);
        }else{
            self.fiveImageView.image = MXRIMAGE(FILL_STAR);
        }
        
        NSURL *starURL = book.bookIconUrlWithData;
        @MXRWeakObj(self);
        [self.bookIconImageView sd_setImageWithURL:starURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                UIImage * lastImage = [image clipImageInRect:CGRectMake(0, 0, image.size.width, image.size.width)];
                selfWeak.bookIconImageView.image = lastImage;
            }else{
                selfWeak.bookIconImageView.image = MXRIMAGE(@"icon_common_bookIconPlaceholder");
            }
        }];
        _bookIconImageView.layer.borderWidth = 0.8f;
        _bookIconImageView.layer.borderColor = RGB(0xe0,0xe0, 0xe0).CGColor;
        self.bookNameLabel.text = book.bookName;
        
        self.rightArrowsImage.image = MXRIMAGE(@"icon_bookSNS_searchBook");
    
    }
    return self;
}

@end
