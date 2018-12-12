//
//  MXRPKChallengeShareView.m
//  huashida_home
//
//  Created by MountainX on 2018/10/22.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKChallengeShareView.h"
#import "MXRUserHeaderView.h"
#import "ZFRadarChart.h"
#import "MXRScreenShotHelper.h"

#define kScale (609.0 / 320)

@interface MXRPKChallengeShareView () <ZFRadarChartDataSource, ZFRadarChartDelegate>

@property (weak, nonatomic) IBOutlet MXRUserHeaderView *userHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UIView *radarContentView;
@property (weak, nonatomic) IBOutlet UIImageView *QRIv;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, strong) ZFRadarChart *radarChart;

@property (nonatomic, strong) UIImage *qrImage;

@end

@implementation MXRPKChallengeShareView

+ (instancetype)shareView {
    MXRPKChallengeShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"MXRPKChallengeShareView" owner:self options:nil] firstObject];
    shareView.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_WIDTH_DEVICE * kScale);
    return shareView;
}

- (void)setHeaderViewModel:(MXRPKHomeHeaderViewModel *)headerViewModel {
    _headerViewModel = headerViewModel;
    [self setup];
    [self setupRadarChart];
}

- (void)setup {
    if ([[UserInformation modelInformation].userImage isKindOfClass:[NSString class]]) {
        self.userHeaderView.headerUrl = [UserInformation modelInformation].userImage;
    }else if([[UserInformation modelInformation].userImage isKindOfClass:[UIImage class]]){
        self.userHeaderView.headerImage = (UIImage *)[UserInformation modelInformation].userImage;
    }else {
        self.userHeaderView.headerImage = MXRIMAGE(@"icon_common_default_head");
    }
    self.userHeaderView.vip = [UserInformation modelInformation].vipFlag;
    
    self.QRIv.image = self.qrImage;
    
    self.nicknameLabel.text = [UserInformation modelInformation].userNickName;
    
    self.rankLabel.text = [NSString stringWithFormat:@"%ld", _headerViewModel.challengeInfoModel.lastWeekRanking];
    
    NSString *rateStr = [NSString stringWithFormat:@"%ld%%", _headerViewModel.challengeInfoModel.beatPerCent];
    NSString *userStr = @"用户";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[rateStr stringByAppendingString:userStr]];
    [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:26] range:NSMakeRange(0, rateStr.length)];
    [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(rateStr.length, userStr.length)];
    _rateLabel.attributedText = attr;
}

- (void)setupRadarChart {
    if (_headerViewModel.challengeInfoModel.qaChallengeUserAnswerStats.count == 0) {
        return;
    }
    [self.radarContentView addSubview:self.radarChart];
    self.radarChart.originRotationAngle = - M_PI / _headerViewModel.challengeInfoModel.qaChallengeUserAnswerStats.count;
    [self.radarChart strokePath];
}

- (ZFRadarChart *)radarChart {
    if (!_radarChart) {
        _radarChart = [[ZFRadarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE - 40, SCREEN_WIDTH_DEVICE - 40)];
        _radarChart.dataSource = self;
        _radarChart.delegate = self;
        //        _radarChart.unit = @"分";
        _radarChart.itemTextColor = ZFWhite;
        //    self.radarChart.backgroundColor = ZFCyan;
        _radarChart.itemFont = MXRFONT(15);
        _radarChart.valueFont = MXRFONT(15);
        _radarChart.radarLineWidth = 1.f;
        _radarChart.separateLineWidth = 1.f;
        _radarChart.polygonLineWidth = 3.f;
        //    self.radarChart.valueType = kValueTypeDecimal;
        //    self.radarChart.isShowPolygonLine = NO;
        //    self.radarChart.isShowValue = NO;
        //    self.radarChart.isAnimated = NO;
        //    self.radarChart.isShowSeparate = NO;
        _radarChart.valueType = kValueTypeDecimal;
        //    self.radarChart.isResetMinValue = YES;
        _radarChart.radarLineColor = [UIColor colorWithWhite:1.0 alpha:0.5f];
        //        _radarChart.backgroundColor = ZFClear;
        _radarChart.valueTextColor = ZFWhite;
        _radarChart.radarPatternType = kRadarPatternTypeCircle;
        //    self.radarChart.radarLineColor = ZFBlack;
        _radarChart.isShowValue = NO;
        _radarChart.isShowRadarPeak = YES;
        _radarChart.radarPeakRadius = 2.f;
        _radarChart.radarCircleBgColor = ZFWhite;
        _radarChart.isResetMaxValue = YES;
    }
    return _radarChart;
}

#pragma mark - ZFRadarChartDataSource

- (NSArray *)itemArrayInRadarChart:(ZFRadarChart *)radarChart{
    NSMutableArray *titleArray = [NSMutableArray array];
    [self.headerViewModel.challengeInfoModel.qaChallengeUserAnswerStats enumerateObjectsUsingBlock:^(MXRPKRadarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleArray addObject:autoString(obj.tagName)];
    }];
    return titleArray;
}

- (NSArray *)valueArrayInRadarChart:(ZFRadarChart *)radarChart{
    NSMutableArray *valueArray = [NSMutableArray array];
    [self.headerViewModel.challengeInfoModel.qaChallengeUserAnswerStats enumerateObjectsUsingBlock:^(MXRPKRadarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [valueArray addObject:autoString(@(obj.correctRate))];
    }];
    return valueArray;
}

- (NSArray *)colorArrayInRadarChart:(ZFRadarChart *)radarChart{
    return @[RGBHEX(0xFF56DC)];
}

- (CGFloat)maxValueInRadarChart:(ZFRadarChart *)radarChart{
    return 100;
}

#pragma mark - ZFRadarChartDelegate

- (CGFloat)radiusForRadarChart:(ZFRadarChart *)radarChart{
    
    //    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
    //        return (SCREEN_HEIGHT - 100) / 2;
    //    }else{
    //        return (SCREEN_WIDTH - 100) / 2;
    //    }
    
    return (SCREEN_WIDTH - 160) / 2;
}

- (NSUInteger)sectionCountInRadarChart:(ZFRadarChart *)radarChart{
    return 3;
}

//- (CGFloat)radiusExtendLengthForRadarChart:(ZFRadarChart *)radarChart itemIndex:(NSInteger)itemIndex{
//    if (itemIndex == 7) {
//        return 50.f;
//    }
//
//    return 25.f;
//}

//- (CGFloat)valueRotationAngleForRadarChart:(ZFRadarChart *)radarChart{
//    return 45.f;
//}

- (void)radarChart:(ZFRadarChart *)radarChart didSelectItemLabelAtIndex:(NSInteger)labelIndex{
    DLOG(@"当前点击的下标========%ld", (long)labelIndex);
}

-(UIImage *)qrImage{
    if (!_qrImage) {
        //        NSString *url = ServiceURL_HTML_Share_Question(self.param.qaId);
        //        url = WrapperH5Url(url);
        NSString *url = @"https://a.app.qq.com/o/simple.jsp?pkgname=com.mxr.dreambook";//http://page.mxrcorp.cn/1516796053357/index.html
        UIImage *qrImage = [MXRScreenShotHelper generatorlogoImageQRCodeWithUrl:url];
        _qrImage = qrImage;
    }
    return _qrImage;
}

@end
