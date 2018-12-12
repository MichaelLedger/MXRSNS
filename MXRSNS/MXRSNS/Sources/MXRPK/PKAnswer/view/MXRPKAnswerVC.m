//
//  MXRPKAnswerVC.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/20.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKAnswerVC.h"
#import "Masonry.h"
#import "MXRPKNormalHeaderView.h"
#import "MXRPKAnswerOptionCell.h"
#import "MXRPKImageOptionCell.h"
#import "MXRPKNetworkManager.h"
#import <UIDevice+MAREX.h>
#import "MXRCountDownView.h"
#import <MARCategory.h>
#import "UIImageView+WebCache.h"
#import "MXRPKScoreView.h"
//#import "MXRSettingTimerManager.h"
#import "MXRUserHeaderView.h"
#import "MXRPKResultViewController.h"

#define MXRPKResultAnimationDuration 1.5f
#define MXRPKCountSectionds 20

@interface MXRPKAnswerVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *topNaviView;

@property (weak, nonatomic) IBOutlet UIView *leftUserContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *leftUserImageView;
@property (weak, nonatomic) IBOutlet MXRUserHeaderView *leftUserHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *leftUserNameLabel;
@property (weak, nonatomic) IBOutlet UIView *downTimeContainerView;

@property (weak, nonatomic) IBOutlet MXRPKScoreView *leftScoreView;
@property (weak, nonatomic) IBOutlet MXRPKScoreView *rightScoreView;

@property (weak, nonatomic) IBOutlet UIView *rightUserContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *rightUserImageView;
@property (weak, nonatomic) IBOutlet MXRUserHeaderView *rightUserHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *rightUserNameLabel;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collecitonViewFlowLayout;
@property (nonatomic, strong) MXRPKQuestionLibModel *questionLib;
@property (nonatomic, assign) NSInteger currentQuestionIndex;
@property (nonatomic, strong) MXRPKQuestionModel *currentQuestionModel;
@property (nonatomic, strong) NSMutableSet *selectedIndexSet;

@property (nonatomic, weak) UIViewController *missionCompleteVC;

@property (nonatomic, strong) MXRCountDownView *countDownView;
@property (nonatomic, copy) MARCancelBlockToken randomBlockToken;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_countCownContainerViewCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_leftUserInfoViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_rightUserInfoViewTrailing;


@end

@implementation MXRPKAnswerVC
{
    NSInteger startTime;
    NSInteger correctNumber;
    BOOL isCorrect;
    
    BOOL needShowOppnentResult;
    BOOL needShowOwnResult;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxr_preferredNavigationBarHidden = YES;
    [self UIGlobals];
    correctNumber = 0;
    _currentQuestionIndex = -1;
    // 随机答题顺序
    self.questionLib.questionList = [self.questionLib.questionList mar_shuffledArray];
    [self showNextQuestion];
//    [self p_reloadCollecitonData];
    
    [self addObservers];
    [self userImageAndNameConfig];
    self.leftScoreView.scoreTotalLength = self.rightScoreView.scoreTotalLength = self.pkUserInfoModel.pkQuestionLibModel.questionList.count;
    self.leftScoreView.scoreViewBackgoundColor = MXRCOLOR_FF405F;
    self.rightScoreView.scoreViewBackgoundColor = MXRCOLOR_29AAFE;
    
    //    [self countDownView];
    
//    [[MXRSettingTimerManager sharedInstance] pauseTipsTimer];
}

- (void)showFirstAnimation
{
    self.constraint_leftUserInfoViewLeading.constant = - SCREEN_WIDTH_DEVICE / 2;
    self.constraint_rightUserInfoViewTrailing.constant = - SCREEN_WIDTH_DEVICE / 2;
    self.constraint_countCownContainerViewCenterY.constant = -300;
    
    [UIView animateWithDuration:0.25 delay:1 usingSpringWithDamping:0.7 initialSpringVelocity:10.f options:0 animations:^{
        self.constraint_leftUserInfoViewLeading.constant = 0;
        self.constraint_rightUserInfoViewTrailing.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self p_reloadCollecitonData];
    }];
    
    [UIView animateWithDuration:0.25 delay:1 usingSpringWithDamping:0.7 initialSpringVelocity:10.f options:0 animations:^{
        self.constraint_countCownContainerViewCenterY.constant = 0;
        [self.view layoutIfNeeded];
        [self startCountdownTime];
    } completion:^(BOOL finished) {
        [self startCountdownTime];
    }];
}

- (void)dealloc
{
    [self removeObservers];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)clickBackButtonAction:(id)sender {
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)UIGlobals
{
    __weak __typeof(self) weakSelf = self;
    [_topNaviView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_topLayoutGuide);
    }];
    
    [self.leftScoreView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.mas_bottomLayoutGuide).mas_offset(-20);
    }];
    
    self.collectionView.allowsMultipleSelection = YES;
    self.collecitonViewFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10); self.collecitonViewFlowLayout.itemSize = CGSizeMake(SCREEN_WIDTH_DEVICE - self.collecitonViewFlowLayout.sectionInset.left - self.collecitonViewFlowLayout.sectionInset.right, 60);
    self.collecitonViewFlowLayout.minimumLineSpacing = 21;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MXRPKNormalHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MXRPKNormalHeaderView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MXRPKAnswerOptionCell" bundle:nil] forCellWithReuseIdentifier:@"MXRPKAnswerOptionCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MXRPKImageOptionCell" bundle:nil] forCellWithReuseIdentifier:@"MXRPKImageOptionCell"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)userImageAndNameConfig
{
    self.leftUserHeaderView.headerUrl = [UserInformation modelInformation].userImage;
    self.rightUserHeaderView.headerUrl = self.pkUserInfoModel.randomOpponentResult.userIcon;
    
    BOOL isCurrentUserVip = [UserInformation modelInformation].vipFlag;
    BOOL isThatUserVip = self.pkUserInfoModel.randomOpponentResult.vipFlag;
    self.leftUserHeaderView.vip = isCurrentUserVip;
    self.rightUserHeaderView.vip = isThatUserVip;
    
    self.leftUserNameLabel.text = [UserInformation modelInformation].userNickName ?: @"";
    self.rightUserNameLabel.text = self.pkUserInfoModel.randomOpponentResult.userName ?: @"";
}

- (void)randomShowOppentResult
{
    needShowOppnentResult = NO;
    NSInteger waitSecond = arc4random() % 6 + 2;        // [2,7] 随机数
    __weak __typeof(self) weakSelf = self;
    if (_randomBlockToken) {
        [NSObject mar_cancelBlock:_randomBlockToken];
        _randomBlockToken = nil;
    }
    self.randomBlockToken = [self mar_gcdPerformAfterDelay:waitSecond usingBlock:^(id  _Nonnull objSelf) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf->needShowOppnentResult = YES;
        [strongSelf p_reloadCollecitonData];
    }];
}

#pragma mark 展示对方答题的对错 随机时间显示
- (void)showOpponentResult
{
    NSInteger opponetCorrectNumber = 0;
    BOOL isOpponentCorrect = NO;
    for (int i = 0; i <= self.currentQuestionIndex && i < self.pkUserInfoModel.randomOpponentResult.questionModelList.count; i++) {
        MXRRandomOpponentQuestionModel *model = self.pkUserInfoModel.randomOpponentResult.questionModelList[i];
        if (model.isRight) {
            opponetCorrectNumber ++;
        }
        if (i == self.currentQuestionIndex) {
            isOpponentCorrect = model.isRight;
        }
    }
    [self.rightScoreView setLength:opponetCorrectNumber correct:isOpponentCorrect animated:YES];
}

- (void)showOwnResult
{
    [self.leftScoreView setLength:correctNumber correct:isCorrect animated:YES];
}

- (void)showNextQuestion
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showNextQuestion) object:nil];
    [self randomShowOppentResult];
    needShowOwnResult = NO;
    needShowOppnentResult = NO;
    self.currentQuestionIndex ++;
    self.collectionView.userInteractionEnabled = NO;
    isCorrect = NO;
    
    [_countDownView setFinishCallback:nil];
    if (startTime == 0) {
        startTime = [[NSDate new] timeIntervalSince1970];
    }
    [self.selectedIndexSet removeAllObjects];
    for (NSIndexPath *selectedIndex in [self.collectionView indexPathsForSelectedItems]) {
        [self.collectionView deselectItemAtIndexPath:selectedIndex animated:NO];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.collectionView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.collectionView setContentOffset:CGPointZero];
        NSInteger currentQuestionDisplayType = [self currentQuestionDisplayType];
        if (currentQuestionDisplayType == 2 || currentQuestionDisplayType == 3) {
            self.collecitonViewFlowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
            
            CGFloat width = (CGRectGetWidth(self.collectionView.frame) - self.collecitonViewFlowLayout.sectionInset.left - self.collecitonViewFlowLayout.sectionInset.right - 15) / 2;
            self.collecitonViewFlowLayout.itemSize = CGSizeMake(width, width);
            self.collecitonViewFlowLayout.minimumLineSpacing = 21;
            self.collecitonViewFlowLayout.minimumInteritemSpacing = 10;
        }
        else
        {
            self.collecitonViewFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10); self.collecitonViewFlowLayout.itemSize = CGSizeMake(SCREEN_WIDTH_DEVICE - self.collecitonViewFlowLayout.sectionInset.left - self.collecitonViewFlowLayout.sectionInset.right, 60);
            self.collecitonViewFlowLayout.minimumLineSpacing = 21;
        }
        self.collectionView.userInteractionEnabled = YES;
        
        [self p_reloadCollecitonData];
        [UIView animateWithDuration:0.25 animations:^{
            self.collectionView.alpha = 1;
        } completion:^(BOOL isFinished){
            if (isFinished) {
                if (self.questionLib.questionList.count > self.currentQuestionIndex) {
                    [self startCountdownTime];
                }
            }
        }];
    }];
}

- (void)p_reloadCollecitonData
{
    self.leftScoreView.imageView.hidden = !needShowOwnResult;
    if (needShowOwnResult) {
        [self showOwnResult];
    }
    self.rightScoreView.imageView.hidden = !needShowOppnentResult;
    if (needShowOppnentResult) {
        [self showOpponentResult];
    }
    [self.collectionView reloadData];
    
    if (needShowOwnResult && needShowOppnentResult) {
        // 是否是最后一题
        [_countDownView setFinishCallback:nil];
        if (self.questionLib.questionList.count > 0 && self.questionLib.questionList.count == self.currentQuestionIndex + 1) {
            // 提交答案
            [self performSelector:@selector(submitAnswerAction) withObject:nil afterDelay:MXRPKResultAnimationDuration];
        }
        else
        {
            [self performSelector:@selector(showNextQuestion) withObject:nil afterDelay:MXRPKResultAnimationDuration];
        }
    }
}

- (void)startCountdownTime
{
    self.downTimeContainerView.hidden = NO;
    __weak __typeof(self) weakSelf = self;
    [self.countDownView setFinishCallback:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf.collectionView.userInteractionEnabled = NO;
        strongSelf->needShowOwnResult = YES;
        [strongSelf p_reloadCollecitonData];
    }];
    self.countDownView.maxValue = MXRPKCountSectionds;
    self.countDownView.value = MXRPKCountSectionds;
}

- (void)redoQAExercise
{
    self.selectedIndexSet = nil;
    self.currentQuestionIndex = -1;
    correctNumber = 0;
    isCorrect = NO;
    [self showNextQuestion];
}

 // test
- (MXRPKQuestionLibModel *)questionLib
{
    return self.pkUserInfoModel.pkQuestionLibModel;
}

- (MXRPKQuestionModel *)currentQuestionModel
{
    if (self.questionLib.questionList.count > self.currentQuestionIndex) {
        return self.questionLib.questionList[self.currentQuestionIndex];
    }
    return nil;
}

/**
 问题答案显示类型  1-文字，2-图片，3-图文
 */
- (NSInteger)currentQuestionDisplayType
{
    MXRPKQuestionModel *questionModel = self.currentQuestionModel;
    return questionModel.answerType;
}

/**
 用户所选选项集合
 */
- (NSMutableSet *)selectedIndexSet
{
    if (!_selectedIndexSet) {
        _selectedIndexSet = [NSMutableSet setWithCapacity:4];
    }
    return _selectedIndexSet;
}

- (NSMutableSet *)currentCorrectOptionSet
{
    MXRPKQuestionModel *questionModel = self.currentQuestionModel;
    NSMutableSet *correctSet = [NSMutableSet setWithCapacity:1<<3];
    for (int i = 0; i < questionModel.answers.count; i ++) {
        MXRPKAnswerOption *option = questionModel.answers[i];
        if (option.correct) {
            [correctSet addObject:@(i)];
        }
    }
    return correctSet;
}

- (MXRCountDownView *)countDownView
{
    if (!_countDownView)
    {
        _countDownView = [[MXRCountDownView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.downTimeContainerView.frame), CGRectGetHeight(self.downTimeContainerView.frame))];
        _countDownView.maxValue = MXRPKCountSectionds;
        _countDownView.value = MXRPKCountSectionds;
        _countDownView.backgroundColor = [UIColor whiteColor];
        _countDownView.layer.masksToBounds = YES;
        _countDownView.layer.cornerRadius = CGRectGetWidth(_countDownView.frame)/2;
        [self.downTimeContainerView addSubview:_countDownView];
    }
    return _countDownView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollection Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.questionLib.questionList.count > self.currentQuestionIndex) {
        MXRPKQuestionModel *questionModel = self.questionLib.questionList[self.currentQuestionIndex];
        return questionModel.answers.count;
    }
    return self.questionLib.questionList.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        MXRPKNormalHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MXRPKNormalHeaderView" forIndexPath:indexPath];
        headerView.questionContentLabel.textColor = [UIColor whiteColor];
        if (self.questionLib.questionList.count > self.currentQuestionIndex) {
            MXRPKQuestionModel *questionModel = self.questionLib.questionList[self.currentQuestionIndex];
            [headerView setCellData:questionModel.questionContent.word];
            [headerView setCellData:questionModel];
            
            headerView.questionContentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.collectionView.frame) - self.collecitonViewFlowLayout.sectionInset.left - self.collecitonViewFlowLayout.sectionInset.right - 80;
            
            CGSize oneLineFitSize = [questionModel.questionContent.word boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: headerView.questionContentLabel.font} context:nil].size;
            
            if (oneLineFitSize.width < headerView.questionContentLabel.preferredMaxLayoutWidth) {
                headerView.questionContentLabel.textAlignment = NSTextAlignmentCenter;
            }
            else
            {
                headerView.questionContentLabel.contentMode = NSTextAlignmentLeft;
            }
        }
        return headerView;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    MXRPKQuestionModel *questionModel = self.currentQuestionModel;
    MXRPKAnswerOption *answerOption = nil;
    if (questionModel && questionModel.answers.count > row) {
        answerOption = questionModel.answers[row];
    }
    NSInteger currentQuestionDisplayType = [self currentQuestionDisplayType];
    if (currentQuestionDisplayType == 2 || currentQuestionDisplayType == 3) {
        MXRPKImageOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MXRPKImageOptionCell" forIndexPath:indexPath];
        [cell setCellData:answerOption];
        cell.mxr_selected = [self.selectedIndexSet containsObject:@(row)];
        if (needShowOwnResult) {
            [cell showResult];
        }
        return cell;
    }
    else
    {
        MXRPKAnswerOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MXRPKAnswerOptionCell" forIndexPath:indexPath];
        [cell setCellData:answerOption];
        cell.mxr_selected = [self.selectedIndexSet containsObject:@(row)];
        if (needShowOwnResult) {
            [cell showResult];
        }
        return cell;
    }
    
}

#pragma UICollection layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (!self.questionLib) {
        return CGSizeZero;
    }
    
    MXRPKNormalHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"MXRPKNormalHeaderView" owner:nil options:nil][0];
    headerView.questionContentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.collectionView.frame) - self.collecitonViewFlowLayout.sectionInset.left - self.collecitonViewFlowLayout.sectionInset.right - 80;
    MXRPKQuestionModel *questionModel = self.currentQuestionModel;
    [headerView setCellData:questionModel.questionContent.word];
    [headerView setCellData:questionModel];
    CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    CGSize headerSize = CGSizeMake(SCREEN_WIDTH_DEVICE - self.collecitonViewFlowLayout.sectionInset.left - self.collecitonViewFlowLayout.sectionInset.right, height);
    return headerSize;
}

#pragma mark - UIColleciton Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableSet *currentCorrectOptionSet = [self currentCorrectOptionSet];
    
    NSInteger row = indexPath.row;
    if ([self.selectedIndexSet containsObject:@(row)]) {
        [self.selectedIndexSet removeObject:@(row)];
    }
    else
    {
        [self.selectedIndexSet addObject:@(row)];
        if (self.currentQuestionModel.answers.count > row)
        {
            if (!self.currentQuestionModel.answers[row].correct) {
                self.collectionView.userInteractionEnabled = NO;
                needShowOwnResult = YES;
            }
        }
    }
    [self p_reloadCollecitonData];
    
    // 答案选择结束
    if (self.selectedIndexSet.count >= currentCorrectOptionSet.count) {
        MXRPKQuestionModel *currentQuesitonModel = [self currentQuestionModel];
        currentQuesitonModel.isRight = [self.selectedIndexSet isEqualToSet:currentCorrectOptionSet];
        currentQuesitonModel.selectedIndexArray = [self.selectedIndexSet allObjects];
        
        if ([self.selectedIndexSet isEqual:currentCorrectOptionSet]) {
            correctNumber ++;
            isCorrect = YES;
        }
        else
            isCorrect = NO;
        
        needShowOwnResult = YES;
        self.collectionView.userInteractionEnabled = NO;
        [self p_reloadCollecitonData];
    }
}

- (void)submitAnswerAction
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(submitAnswerAction) object:nil];
    self.collectionView.userInteractionEnabled = NO;
    // 提交答案
    MXRSubmitPKAnswersR *submitPKAnswersR = [MXRSubmitPKAnswersR new];
    // test
    submitPKAnswersR.qaInfoId = self.questionLib.qaId; // @"7";// self.questionLib.qaId
    submitPKAnswersR.startTime = startTime * 1000;
    submitPKAnswersR.endTime = [[NSDate new] timeIntervalSince1970] * 1000;
    submitPKAnswersR.ip = [UIDevice currentDevice].mar_ipAddressWIFI ?: ([UIDevice currentDevice].mar_ipAddressCell ?: @"");
    submitPKAnswersR.isPk = 0;
    NSMutableArray *questionDetailArray = [NSMutableArray arrayWithCapacity:self.questionLib.questionList.count];
    for (MXRPKQuestionModel *model in self.questionLib.questionList) {
        MXRRandomOpponentQuestionModel *submitAnswerDetailR = [MXRRandomOpponentQuestionModel new];
        NSMutableArray *idArray = [NSMutableArray arrayWithCapacity:model.selectedIndexArray.count];
        for (int i = 0; i<model.selectedIndexArray.count; i++) {
            [idArray addObject:@(model.answers[[model.selectedIndexArray[i] integerValue]].answerId)];
        }
        submitAnswerDetailR.answerIds = idArray;
        submitAnswerDetailR.questionId = model.questionId;
        submitAnswerDetailR.isRight = model.isRight;//答题是否正确也要同步!!!
        [questionDetailArray addObject:submitAnswerDetailR];
    }
    submitPKAnswersR.questionDetail = questionDetailArray;
    
    submitPKAnswersR.matchUserId = self.pkUserInfoModel.randomOpponentResult.userId;
    submitPKAnswersR.matchUserLogo = self.pkUserInfoModel.randomOpponentResult.userIcon;
    submitPKAnswersR.matchUserName = self.pkUserInfoModel.randomOpponentResult.userName;
    submitPKAnswersR.matchAccuracy = self.pkUserInfoModel.randomOpponentResult.accuracy;
    if (self.questionLib.questionList.count > 0) {
        submitPKAnswersR.accuracy = MIN(correctNumber * 100 / self.questionLib.questionList.count, 100);
    }
    submitPKAnswersR.result = submitPKAnswersR.accuracy > submitPKAnswersR.matchAccuracy ? 1 : (submitPKAnswersR.accuracy < submitPKAnswersR.matchAccuracy ? -1 : 0);
    __weak __typeof(self) weakSelf = self;
    [MXRPKNetworkManager submitPKAnswers:submitPKAnswersR success:^(MXRPKSubmitResultModel *submitResult) {
//        [[MXRSettingTimerManager sharedInstance] resumeTipsTimer];
        
        NSLog(@">>>>>>> submit answers response : %@", submitResult);
        
        //延迟刷新战绩，避免获取不了最新的战绩 V5.14.0 by MT.X
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_PK_Submit_Answer object:nil];
        });
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf.collectionView.userInteractionEnabled = YES;
        MXRRandomOpponentResult *mineResult = [MXRRandomOpponentResult new];
        mineResult.userId = [[UserInformation modelInformation].userID integerValue];
        mineResult.userName = [UserInformation modelInformation].userNickName;
        mineResult.userIcon = [UserInformation modelInformation].userImage;
        if (strongSelf.questionLib.questionList.count > 0) {
            mineResult.accuracy = MIN(strongSelf->correctNumber * 100 / strongSelf.questionLib.questionList.count, 100);
        }
        mineResult.qaId = [strongSelf.questionLib.qaId integerValue];
        mineResult.questionModelList = questionDetailArray;
        strongSelf.pkUserInfoModel.mineResult = mineResult;

        MXRPKResultViewController *vc = [[MXRPKResultViewController alloc] init];
        vc.infoModel = strongSelf.pkUserInfoModel;
        vc.submitResultModel = submitResult;
        [strongSelf.navigationController pushViewController:vc animated:YES];
        
        strongSelf.missionCompleteVC = vc;
        [strongSelf performSelector:@selector(redoQAExercise) withObject:nil afterDelay:0.25];
        
    } failure:^(id error) {
//        [[MXRSettingTimerManager sharedInstance] resumeTipsTimer];
        
        weakSelf.collectionView.userInteractionEnabled = YES;
        if ([error isKindOfClass:[NSString class]]) {
            if ([(NSString *)error length] > 0) {
                [MXRConstant showAlert:error andShowTime:1.5f];
                [weakSelf clickBackButtonAction:nil];
            }
        }
        else
        {
            [MXRConstant showAlert:MXRLocalizedString(@"UserRegisterCon_Bad_Net", @"网络开小差") andShowTime:1.5f];
            [weakSelf clickBackButtonAction:nil];
        }
    }];
}

#pragma mark - observers
- (void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeMissionCompleteVC) name:Notification_RNNoti_ColseMissionCompleye object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryAgain) name:Notification_RNNoti_MissionTryAgain object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationDidEnterBackground:(NSNotification *)noti
{
    
}

- (void)applicationDidBecomeActive:(NSNotification *)noti
{
    NSLog(@".>>>>>>>> %ld", self.countDownView.value);
    if (!self.countDownView.value || self.countDownView.value <= 0) {
        needShowOwnResult = YES;
        needShowOwnResult = YES;
        self.collectionView.userInteractionEnabled = NO;
        [self p_reloadCollecitonData];
    }
}

- (void)removeObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 关闭答题
 */
- (void)closeMissionCompleteVC{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_QuitMissionCompleteVCGoToBook object:nil];
    }];
//    NSInteger count = self.navigationController.childViewControllers;
//    UIViewController *vc = [self.navigationController.childViewControllers objectAtIndex:count-2];
//    [self.navigationController popToViewController:vc animated:YES];
}

/**
 再测一次
 */
- (void)tryAgain{
//    [[MXRSettingTimerManager sharedInstance] pauseTipsTimer];
    if (self.missionCompleteVC) {
        [self.navigationController popViewControllerAnimated:YES];
        _missionCompleteVC = nil;
    }
    
}

@end
