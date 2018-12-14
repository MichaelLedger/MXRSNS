//
//  MXRPKHomeNewHeaderView.m
//  huashida_home
//
//  Created by MountainX on 2018/10/15.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKHomeNewHeaderView.h"
#import "ZFChart.h"
#import "MXRUserHeaderView.h"
#import "NSString+Ex.h"
#import "MXRPKHomeMedalCollectionViewCell.h"

#define OBSERVER_NICKNAME_KEY @"nickName"
#define OBSERVER_USERICON_KEY @"userIcon"
#define OBSERVER_MEDALSCOUNT_KEY @"medalsCount"
#define OBSERVER_RECORDS_KEY @"records"

#define OBSERVER_TOTALNUM_KEY @"challengeInfoModel.totalNum"
#define OBSERCER_USEDNUM_KEY @"challengeInfoModel.usedNum"
#define OBSERVER_RANK_KEY @"challengeInfoModel.lastWeekRanking"
#define OBSERVER_BESTRECORD_KEY @"challengeInfoModel.bestRecord"
#define OBSERVER_EXCLUDECARDCOUNT_KEY @"challengeInfoModel.removeWrongCardNum"
#define OBSERVER_RESURGENCECARDCOUNT_KEY @"challengeInfoModel.reliveCardNum"
#define OBSERVER_RADAR_KEY @"challengeInfoModel.qaChallengeUserAnswerStats"
#define OBSERVER_VIPFLAG_KEY @"challengeInfoModel.vipFlag"

#define kMargin 5.f

static NSString *cellIdentifier = @"MXRPKHomeMedalCollectionViewCell";

@interface MXRPKHomeNewHeaderView () <ZFRadarChartDataSource, ZFRadarChartDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *challengeContentView;
@property (weak, nonatomic) IBOutlet UIImageView *challengeBgIv;
@property (weak, nonatomic) IBOutlet UILabel *challengeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *challengeChanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *rankTitleBtn;
@property (weak, nonatomic) IBOutlet UILabel *lastWeekRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestRankLabel;
@property (weak, nonatomic) IBOutlet UIButton *propBtn;
@property (weak, nonatomic) IBOutlet UILabel *excludeErrorTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *excludeErrorCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *resurgenceTitltLabel;
@property (weak, nonatomic) IBOutlet UILabel *resurgenceCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginChallengeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rankTagIv;
@property (weak, nonatomic) IBOutlet UIImageView *propTagIv;
@property (weak, nonatomic) IBOutlet UIView *rankBgView;
@property (weak, nonatomic) IBOutlet UIView *propBgView;
@property (weak, nonatomic) IBOutlet UIButton *rechargeVIPBtn;

@property (weak, nonatomic) IBOutlet UIView *radarView;
@property (weak, nonatomic) IBOutlet UIImageView *radarBgIv;
@property (weak, nonatomic) IBOutlet UILabel *radarTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *radarContentView;
@property (nonatomic, strong) ZFRadarChart *radarChart;

@property (weak, nonatomic) IBOutlet UIView *pkContentView;
@property (weak, nonatomic) IBOutlet UIImageView *pkBgIv;
@property (weak, nonatomic) IBOutlet MXRUserHeaderView *userHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *userNicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *medalCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *medalJumpBtn;
@property (weak, nonatomic) IBOutlet UIButton *beginPKBtn;
@property (weak, nonatomic) IBOutlet UILabel *pkTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *medalTitleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *medalCollectionViewHeightConstraint;

@end

@implementation MXRPKHomeNewHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_medalCollectionView registerNib:[UINib nibWithNibName:@"MXRPKHomeMedalCollectionViewCell" bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:cellIdentifier];
    [self setupUI];
    [self setupRadarChart];
}

- (void)setupRadarChart {
    [self.radarContentView addSubview:self.radarChart];
}

- (ZFRadarChart *)radarChart {
    if (!_radarChart) {
        _radarChart = [[ZFRadarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE - 60, SCREEN_WIDTH_DEVICE - 60)];
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
        _radarChart.isResetMaxValue = YES;
        _radarChart.radarCircleBgColor = ZFWhite;
    }
    return _radarChart;
}

//#pragma mark - Lazy Loader
//- (NSArray<NSString *> *)titleArray {
//    if (!_titleArray) {
//        _titleArray = @[@"天文", @"地理", @"百科", @"历史", @"军事", @"国学"];
//    }
//    return _titleArray;
//}
//
//- (NSArray<NSString *> *)valueArray {
//    if (!_valueArray) {
//        _valueArray = @[@"4", @"10", @"4", @"9", @"7", @"1"];
//    }
//    return _valueArray;
//}


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

#pragma mark - Setup UI
-(void)setupUI {
    self.challengeBgIv.image = MXRGRADIENTIMAGEWITHSTYLEMAIN(MXRUIViewGradientStyle_009FD8_022D71);
//    self.radarBgIv.image = MXRIMAGE(@"bg_abilitytomap@2x");
//    [self.medalJumpBtn setImage:MXRIMAGE(@"icon_indicator_right_white") forState:UIControlStateNormal];
    self.pkBgIv.image = MXRGRADIENTIMAGEWITHSTYLEMAIN(MXRUIViewGradientStyle_009FD8_022D71);
    [self.beginChallengeBtn setBackgroundImage:MXRGRADIENTIMAGEWITHSTYLEANDDIRECTION(MXRUIViewGradientStyle_FAD961_F76B1C, MXRUIViewLinearGradientDirectionVertical) forState:UIControlStateNormal];
    [self.beginPKBtn setBackgroundImage:MXRGRADIENTIMAGEWITHSTYLEANDDIRECTION(MXRUIViewGradientStyle_B4EC51_429321, MXRUIViewLinearGradientDirectionVertical) forState:UIControlStateNormal];
    
    _pkTitleLabel.font = SCREEN_WIDTH_DEVICE <= 320 ? MXRBOLDFONT(30) : MXRBOLDFONT(36);
    _beginPKBtn.titleLabel.font = SCREEN_WIDTH_DEVICE <= 320 ? MXRBOLDFONT(24) : MXRBOLDFONT(28);
    
    _challengeTitleLabel.text = MXRLocalizedString(@"MXR_CHALLENGE_TITLE", @"个人挑战赛");
    [_rankTitleBtn setTitle:MXRLocalizedString(@"MXR_CHALLENGE_RANK_TITLE", @"排行榜>>") forState:UIControlStateNormal];
    [_propBtn setTitle:MXRLocalizedString(@"MXR_CHALLENGE_PROP_TITLE", @"获取道具>>") forState:UIControlStateNormal];
    _excludeErrorTitleLabel.text = MXRLocalizedString(@"MXR_CHALLENGE_EXCLUDEERRORCARD", @"除错卡");
    _resurgenceTitltLabel.text = MXRLocalizedString(@"MXR_CHALLENGE_RESURGENCECARD", @"复活卡");
    [_beginChallengeBtn setTitle:MXRLocalizedString(@"MXR_CHALLENGE_BEGIN", @"开始挑战") forState:UIControlStateNormal];
    _radarTitleLabel.text = MXRLocalizedString(@"MXR_CHALLENGE_ABILITY_RADAR", @"能力图谱");
    _pkTitleLabel.text = MXRLocalizedString(@"MXRPKHomeViewController_PK_Title", @"脑力大战");
    [_beginPKBtn setTitle:MXRLocalizedString(@"MXR_PK_BEGIN", @"开始PK") forState:UIControlStateNormal];
    _medalTitleLabel.text = [NSString stringWithFormat:@"%@：", MXRLocalizedString(@"MXRPKMedalViewController_Medal", @"勋章")];
    [_rechargeVIPBtn setTitle:MXRLocalizedString(@"MXR_PK_RECHARGE_VIP_DOUBLE_BONUS", @"成为VIP机会翻倍哦>") forState:UIControlStateNormal];
    
    UITapGestureRecognizer *rankTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToRankList)];
    [_rankBgView addGestureRecognizer:rankTap1];
    UITapGestureRecognizer *rankTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToRankList)];
    [_rankTagIv addGestureRecognizer:rankTap2];
    [_rankTitleBtn addTarget:self action:@selector(jumpToRankList) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *propTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToPropShop)];
    [_propBgView addGestureRecognizer:propTap1];
    UITapGestureRecognizer *propTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToPropShop)];
    [_propTagIv addGestureRecognizer:propTap2];
    [_propBtn addTarget:self action:@selector(jumpToPropShop) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateNickName];
    [self updateUserIcon];
    [self updateMedals];
    [self updateRecords];
    [self updateChallengeChance];
    [self updateMineRank];
    [self updateBestRecord];
    [self updateExcludeCardNum];
    [self updateRecords];
    [self reloadRadar];
}

#pragma mark - obervsers
-(void)addObserversWithVM:(MXRPKHomeHeaderViewModel *)headerViewModel{
    [headerViewModel addObserver:self forKeyPath:OBSERVER_NICKNAME_KEY options:NSKeyValueObservingOptionNew context:nil];
    [headerViewModel addObserver:self forKeyPath:OBSERVER_USERICON_KEY options:NSKeyValueObservingOptionNew context:nil];
    [headerViewModel addObserver:self forKeyPath:OBSERVER_MEDALSCOUNT_KEY options:NSKeyValueObservingOptionNew context:nil];
    [headerViewModel addObserver:self forKeyPath:OBSERVER_RECORDS_KEY options:NSKeyValueObservingOptionNew context:nil];
    
    [headerViewModel addObserver:self forKeyPath:OBSERVER_TOTALNUM_KEY options:NSKeyValueObservingOptionNew context:nil];
    [headerViewModel addObserver:self forKeyPath:OBSERCER_USEDNUM_KEY options:NSKeyValueObservingOptionNew context:nil];
    [headerViewModel addObserver:self forKeyPath:OBSERVER_RANK_KEY options:NSKeyValueObservingOptionNew context:nil];
    [headerViewModel addObserver:self forKeyPath:OBSERVER_BESTRECORD_KEY options:NSKeyValueObservingOptionNew context:nil];
    [headerViewModel addObserver:self forKeyPath:OBSERVER_EXCLUDECARDCOUNT_KEY options:NSKeyValueObservingOptionNew context:nil];
    [headerViewModel addObserver:self forKeyPath:OBSERVER_RESURGENCECARDCOUNT_KEY options:NSKeyValueObservingOptionNew context:nil];
    [headerViewModel addObserver:self forKeyPath:OBSERVER_RADAR_KEY options:NSKeyValueObservingOptionNew context:nil];
    [headerViewModel addObserver:self forKeyPath:OBSERVER_VIPFLAG_KEY options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObserversWithVM:(MXRPKHomeHeaderViewModel *)headerViewModel{
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_NICKNAME_KEY];
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_USERICON_KEY];
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_MEDALSCOUNT_KEY];
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_RECORDS_KEY];
    
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_TOTALNUM_KEY];
    [headerViewModel removeObserver:self forKeyPath:OBSERCER_USEDNUM_KEY];
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_RANK_KEY];
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_BESTRECORD_KEY];
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_EXCLUDECARDCOUNT_KEY];
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_RESURGENCECARDCOUNT_KEY];
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_RADAR_KEY];
    [headerViewModel removeObserver:self forKeyPath:OBSERVER_VIPFLAG_KEY];
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:OBSERVER_NICKNAME_KEY]) {
        [self updateNickName];
    }else if([keyPath isEqualToString:OBSERVER_USERICON_KEY]){
        [self updateUserIcon];
    }else if([keyPath isEqualToString:OBSERVER_MEDALSCOUNT_KEY]){
        [self updateMedals];
    }else if([keyPath isEqualToString:OBSERVER_RECORDS_KEY]){
        [self updateRecords];
    }else if([keyPath isEqualToString:OBSERVER_TOTALNUM_KEY]){
        [self updateChallengeChance];
    }else if([keyPath isEqualToString:OBSERCER_USEDNUM_KEY]){
        [self updateChallengeChance];
    }else if([keyPath isEqualToString:OBSERVER_RANK_KEY]){
        [self updateMineRank];
    }else if([keyPath isEqualToString:OBSERVER_BESTRECORD_KEY]){
        [self updateBestRecord];
    }else if([keyPath isEqualToString:OBSERVER_EXCLUDECARDCOUNT_KEY]){
        [self updateExcludeCardNum];
    }else if([keyPath isEqualToString:OBSERVER_RESURGENCECARDCOUNT_KEY]){
        [self updateResurgenceCardNum];
    }else if([keyPath isEqualToString:OBSERVER_RADAR_KEY]){
        [self reloadRadar];
    } else if ([keyPath isEqualToString:OBSERVER_VIPFLAG_KEY]) {
        [self updateVIPState];
    }
}

#pragma mark - Update UI
- (void)updateChallengeChance {
    DLOG_METHOD
    self.challengeChanceLabel.text = [NSString stringWithFormat:@"%@(%ld/%ld)", MXRLocalizedString(@"MXR_CHALLENGE_CHANCE", @"机会"), _headerViewModel.challengeInfoModel.usedNum, _headerViewModel.challengeInfoModel.totalNum];
}

- (void)updateMineRank {
    DLOG_METHOD
    if (_headerViewModel.challengeInfoModel.lastWeekRanking <= 0 || _headerViewModel.challengeInfoModel.lastWeekRanking > 999) {
        NSString *weekRank = MXRLocalizedString(@"MXR_CHALLENGE_WEEK_RANK", @"个人排名：");
        NSString *weekRankStr = [NSString stringWithFormat:@"%@%@", weekRank, MXRLocalizedString(@"MXR_PK_NOT_ON_RANKLIST", @"未上榜")];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:weekRankStr];
        [attr addAttributes:@{NSForegroundColorAttributeName : MXRCOLOR_666666, NSFontAttributeName : MXRFONT(14)} range:NSMakeRange(0, weekRank.length)];
        [attr addAttributes:@{NSForegroundColorAttributeName : MXRCOLOR_333333, NSFontAttributeName : MXRFONT(18)} range:NSMakeRange(weekRank.length, weekRankStr.length - weekRank.length)];
        self.lastWeekRankLabel.attributedText = attr;
    } else {
        NSString *weekRank = MXRLocalizedString(@"MXR_CHALLENGE_WEEK_RANK", @"个人排名：");
        NSString *weekRankUnitStr = MXRLocalizedString(@"MXR_CHALLENGE_WEEK_RANK_UNIT", @"名");
        NSString *weekRankStr = [NSString stringWithFormat:@"%@%ld%@", weekRank,_headerViewModel.challengeInfoModel.lastWeekRanking, weekRankUnitStr];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:weekRankStr];
        [attr addAttributes:@{NSForegroundColorAttributeName : MXRCOLOR_666666, NSFontAttributeName : MXRFONT(14)} range:NSMakeRange(0, weekRank.length)];
        [attr addAttributes:@{NSForegroundColorAttributeName : MXRCOLOR_333333, NSFontAttributeName : MXRFONT(18)} range:NSMakeRange(weekRank.length, weekRankStr.length - weekRank.length)];
        self.lastWeekRankLabel.attributedText = attr;
    }
}

- (void)updateBestRecord {
    DLOG_METHOD
    NSString *bestRecord = MXRLocalizedString(@"MXR_CHALLENGE_BEST_RANK", @"最佳纪录：");
    NSString *bestRecordUnitStr = MXRLocalizedString(@"MXR_CHALLENGE_BEST_RANK_UNIT", @"题");
    NSString *bestRecordStr = [NSString stringWithFormat:@"%@%ld%@", bestRecord,_headerViewModel.challengeInfoModel.bestRecord, bestRecordUnitStr];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:bestRecordStr];
    [attr addAttributes:@{NSForegroundColorAttributeName : MXRCOLOR_666666, NSFontAttributeName : MXRFONT(14)} range:NSMakeRange(0, bestRecord.length)];
    [attr addAttributes:@{NSForegroundColorAttributeName : MXRCOLOR_333333, NSFontAttributeName : MXRFONT(18)} range:NSMakeRange(bestRecord.length, bestRecordStr.length - bestRecord.length)];
    self.bestRankLabel.attributedText = attr;
}

- (void)updateExcludeCardNum {
    DLOG_METHOD
    self.excludeErrorCountLabel.text = [NSString stringWithFormat:@"x%ld", _headerViewModel.challengeInfoModel.removeWrongCardNum];
}

- (void)updateResurgenceCardNum {
    DLOG_METHOD
    self.resurgenceCountLabel.text = [NSString stringWithFormat:@"x%ld", _headerViewModel.challengeInfoModel.reliveCardNum];
}

- (void)reloadRadar {
    DLOG_METHOD
    if (_headerViewModel.challengeInfoModel.qaChallengeUserAnswerStats.count == 0) {
        return;
    }
    self.radarChart.originRotationAngle = - M_PI / _headerViewModel.challengeInfoModel.qaChallengeUserAnswerStats.count;
    [self.radarChart strokePath];
}

-(void)updateNickName{
    self.userNicknameLabel.text = _headerViewModel.nickName;
}

-(void)updateUserIcon{
//    self.userHeaderView.headerUrl = [NSString encodeUrlString:_headerViewModel.userIcon];
    
    // 头像
    if ([[UserInformation modelInformation].userImage isKindOfClass:[NSString class]]) {
        self.userHeaderView.headerUrl = [UserInformation modelInformation].userImage;
    }else if([[UserInformation modelInformation].userImage isKindOfClass:[UIImage class]]){
        self.userHeaderView.placeHolderheaderImage = (UIImage *)[UserInformation modelInformation].userImage;
    }else {
        self.userHeaderView.placeHolderheaderImage = MXRIMAGE(@"icon_common_default_head");
    }
    self.userHeaderView.vip = [UserInformation modelInformation].vipFlag;
}

-(void)updateMedals{
//    [self.medalButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        UIButton *button = obj;
//        if (idx < _headerViewModel.medalsCount) {
//            button.selected = YES;
//        }else{
//            button.selected = NO;
//        }
//    }];
    [self.medalCollectionView reloadData];
}

-(void)updateRecords{
    self.recordLabel.text = autoString(_headerViewModel.records);
//    [self.recordLabel layoutIfNeeded];
    // [self.recordLabel sizeToFit];
//    self.recordLabel.attributedText =  [self maxFontSizeWithFontSize:31 str:autoString(_headerViewModel.records) inWidth:CGRectGetWidth(self.recordLabel.frame)];
}

- (void)updateVIPState {
    _rechargeVIPBtn.hidden = [UserInformation modelInformation].vipFlag;
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

#pragma mark - Dealloc
- (void)dealloc {
    DLOG_METHOD
    [self removeObserversWithVM:_headerViewModel];
}

#pragma mark - Event
- (IBAction)jumpToMedal:(UIButton *)sender {
    if (_goMedalsBlock) {
        _goMedalsBlock(self);
    }
}
- (IBAction)beginPKBtnClicked:(UIButton *)sender {
    if (_beginPKBlock) {
        _beginPKBlock();
    }
}
- (IBAction)beginChallengeBtnClicked:(UIButton *)sender {
    if (_beginChallengeBlock) {
        _beginChallengeBlock();
    }
}

#pragma mark - 充值VIP
- (IBAction)rechargeVIPBtnClicked:(UIButton *)sender {
    if (_jumpToVIPBlock) {
        _jumpToVIPBlock();
    }
}

#pragma mark - 排行榜
- (void)jumpToRankList {
    DLOG_METHOD
    if (_jumpToRankBlock) {
        _jumpToRankBlock();
    }
}

#pragma mark - 道具商店
- (void)jumpToPropShop {
    DLOG_METHOD
    if (_jumpToPropBlock) {
        _jumpToPropBlock();
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_medalCollectionViewHeightConstraint.constant, _medalCollectionViewHeightConstraint.constant);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kMargin;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.headerViewModel.medalInfoModel.medalVos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MXRPKHomeMedalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.medalModel = [self.headerViewModel.medalInfoModel.medalVos objectAtIndex:indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DLOG_METHOD
    if (_goMedalsBlock) {
        _goMedalsBlock(self);
    }
}

@end
