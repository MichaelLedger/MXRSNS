//
//  MXRBookSNSSearchZoneView.m
//  huashida_home
//
//  Created by yuchen.li on 2017/7/4.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSSearchZoneView.h"
#import "UIImageView+WebCache.h"
#import "MXRSubjectInfoModel.h"
#import "NSString+Ex.h"
@interface MXRBookSNSSearchZoneView ()
@property (weak, nonatomic) IBOutlet UIImageView *zoneImageView;
@property (weak, nonatomic) IBOutlet UILabel *zoneNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowsImageView;


@end

@implementation MXRBookSNSSearchZoneView
-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.rightArrowsImageView.image = MXRIMAGE(@"icon_common_arrows");
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle bundleForClass:[self class]]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
        self.frame = frame;
        self.autoresizingMask = NO;
       // self.backgroundColor = RGB(0xf3, 0xf4, 0xf6);
    }
    return self;
}

-(void)setZoneModel:(MXRSubjectInfoModel *)zoneModel{
    _zoneModel = zoneModel;
    
    [self.zoneImageView sd_setImageWithURL: [NSURL URLWithString: [NSString encodeUrlString:    zoneModel.subjectCover]]  placeholderImage:MXRIMAGE(@"img_bookSNS_topicPlaceholder")];
    self.zoneNameLabel.text = zoneModel.subjectName;
}
@end
