//
//  MXRPKHomeShareView.m
//  huashida_home
//
//  Created by 周建顺 on 2018/1/20.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKHomeShareView.h"

@interface MXRPKHomeShareViewParam()
@end

@implementation MXRPKHomeShareViewParam


@end

@interface MXRPKHomeShareView()

@property (strong, nonatomic) IBOutlet UIView *shareNoQrView;
@property (strong, nonatomic) IBOutlet UIView *shareWithQrView;

@property (strong, nonatomic) IBOutlet UIView *userIconBgView;
@property (strong, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *recordsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *qrImageView;

@property (nonatomic, strong) UIImage *qrImage;
@property (nonatomic, strong) UIImage *shareImageNoQR;
@property (nonatomic, strong) UIImage *shareImageWithQR;
@end

@implementation MXRPKHomeShareView

+(instancetype)pkHomeShareView{
    MXRPKHomeShareView *instance =[[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MXRPKHomeShareView" owner:nil options:nil] firstObject];
    instance.frame = CGRectMake(0, 0, 375, 667);
    return instance;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.userIconBgView.layer.cornerRadius = 30.f;
    self.userIconBgView.layer.masksToBounds = YES;

}


-(void)setModel:(MXRPKHomeShareViewParam *)model{
    _model = model;
    self.nickNameLabel.text =  self.model.userName;
    self.userIconImageView.image = self.model.userIcon;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//
//NSURL *userIconUrl = [NSURL URLWithString:[UserInformation modelInformation].userImage];
//if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:userIconUrl]) {
//    DLOG(@"has icon")
//    [self shareAfterUserIconLoadComplete:notification];
//}else{
//    
//    DLOG(@"no icon")
//    [[GlobalBusyFlag sharedInstance] showBusyFlagOnView:self.view];
//    @MXRWeakObj(self);
//    [[SDWebImageManager sharedManager] downloadImageWithURL:userIconUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        [[GlobalBusyFlag sharedInstance] hideBusyFlag];
//        [selfWeak shareAfterUserIconLoadComplete:notification];
//    }];
//}


- (UIImage *)shareImageWithQR{
    if (!_shareImageWithQR) {
        self.qrImageView.image = self.qrImage;
//        UIView *view = [self snapshotViewAfterScreenUpdates:YES];
        UIImage *image = [UIImage getImageFromView:self.shareWithQrView];
        _shareImageWithQR = image;
    }
    return _shareImageWithQR;
}

- (UIImage *)shareImageNoQR{
    if (!_shareImageNoQR) {
//        UIView *view = [self snapshotViewAfterScreenUpdates:YES];
        UIImage *image = [UIImage getImageFromView:self.shareNoQrView];
        _shareImageNoQR = image;
    }
    return _shareImageNoQR;
}


- (UIImage*)createShareImageWithQR{
    return self.shareImageWithQR;
}

- (UIImage *)createShareImageNoQR{
    return self.shareImageNoQR;
}

@end
