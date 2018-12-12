//
//  MXRPKNormalAnswerVC.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKNormalAnswerVC.h"
#import "Masonry.h"
#import "MXRPKNormalHeaderView.h"
#import "MXRPKAnswerOptionCell.h"
#import "MXRPKImageOptionCell.h"
#import "MXRPKNormalFooterView.h"
#import "MXRPKNetworkManager.h"
#import <UIButton+MAREX.h>
#import <UIDevice+MAREX.h>
#import "ALLNetworkURL.h"
//#import "MXRNewShareView.h"
//#import "MXRSettingTimerManager.h"
#import <NSArray+MAREX.h>
#import <UIView+MAREX.h>
#import "MXRPKQuestionResultViewController.h"

#ifndef QREXVC_URL_QRVALUE
//#define QREXVC_URL_QRVALUE [NSString stringWithFormat:@"%@/share/question.html?qaId=%ld&qId=%@",MXRBASE_HTML_WEB_URL(), (long)self.qaId, [self currentQutionId]];
#define QREXVC_URL_QRVALUE @"https://a.app.qq.com/o/simple.jsp?pkgname=com.mxr.dreambook"
#endif

@interface MXRPKNormalAnswerVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *topNaviView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collecitonViewFlowLayout;
@property (nonatomic, strong) MXRPKQuestionLibModel *questionLib;
@property (nonatomic, assign) NSInteger currentQuestionIndex;
@property (nonatomic, strong) MXRPKQuestionModel *currentQuestionModel;
@property (nonatomic, strong) NSMutableSet *selectedIndexSet;

@property (nonatomic, weak) UIViewController *missionCompleteVC;

@property (weak, nonatomic) IBOutlet UICollectionView *collecitonTempView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collecitonTempViewFlowLayout;

@end

@implementation MXRPKNormalAnswerVC
{
    NSInteger startTime;
    
    UIImage *snapQAImage;
    UIImage *snapQAAndQRCodeImage;
    NSInteger snapPageIndex;
    BOOL needExchangePageIndexAnim;
    
    NSInteger correctNumber;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxr_preferredNavigationBarHidden = YES;
    snapPageIndex = -101;
    correctNumber = 0;
    [self UIGlobals];
    [self loadData];
    [self addObservers];
    
//    [[MXRSettingTimerManager sharedInstance] pauseTipsTimer];
}

- (void)dealloc
{
    [self removeObservers];
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
    self.collectionView.allowsMultipleSelection = YES;
    [_topNaviView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
    }];
    
   self.collecitonViewFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10); self.collecitonViewFlowLayout.itemSize = CGSizeMake(SCREEN_WIDTH_DEVICE - self.collecitonViewFlowLayout.sectionInset.left - self.collecitonViewFlowLayout.sectionInset.right, 60);
    self.collecitonViewFlowLayout.minimumLineSpacing = 21;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MXRPKNormalHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MXRPKNormalHeaderView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MXRPKAnswerOptionCell" bundle:nil] forCellWithReuseIdentifier:@"MXRPKAnswerOptionCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MXRPKImageOptionCell" bundle:nil] forCellWithReuseIdentifier:@"MXRPKImageOptionCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MXRPKNormalFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"MXRPKNormalFooterView"];
    
    [self tempCollectionRegister];
    self.collecitonTempView.delegate = self;
    self.collecitonTempView.dataSource = self;
}

- (void)tempCollectionRegister
{
    self.collecitonTempViewFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10); self.collecitonTempViewFlowLayout.itemSize = CGSizeMake(SCREEN_WIDTH_DEVICE - self.collecitonTempViewFlowLayout.sectionInset.left - self.collecitonTempViewFlowLayout.sectionInset.right, 60);
    self.collecitonTempViewFlowLayout.minimumLineSpacing = 21;
    
    [self.collecitonTempView registerNib:[UINib nibWithNibName:@"MXRPKNormalHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MXRPKNormalHeaderView"];
    [self.collecitonTempView registerNib:[UINib nibWithNibName:@"MXRPKAnswerOptionCell" bundle:nil] forCellWithReuseIdentifier:@"MXRPKAnswerOptionCell"];
    [self.collecitonTempView registerNib:[UINib nibWithNibName:@"MXRPKImageOptionCell" bundle:nil] forCellWithReuseIdentifier:@"MXRPKImageOptionCell"];
    [self.collecitonTempView registerNib:[UINib nibWithNibName:@"MXRPKNormalFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"MXRPKNormalFooterView"];
}

- (void)loadData
{
    MXRGetQAListWithIdR *getQAListWithId = [MXRGetQAListWithIdR new];
    getQAListWithId.qaId = self.qaId; // @"7"; //self.qaId;
    __weak __typeof(self) weakSelf = self;
    [MXRPKNetworkManager getQAListWithId:getQAListWithId success:^(MXRPKQuestionLibModel *pkQuestionLibModel) {
        NSLog(@">>>>  pkQeustionLibModel : %@", pkQuestionLibModel);
        weakSelf.questionLib =pkQuestionLibModel;
        [weakSelf shuffledQuestion];
        [weakSelf p_reloadCollecitonData];
    } failure:^(id error) {
        NSLog(@">>>>> error : %@", error);
    }];
}

- (void)showNextQuestion
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showNextQuestion) object:nil];
    self.currentQuestionIndex++;
    [self p_reloadCollecitonData];
}

- (void)p_reloadCollecitonData
{
    if (self.questionLib.questionList.count > 0 && self.questionLib.questionList.count > self.currentQuestionIndex) {
        self.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"MXRQAExerciseVC_VCTitle", @"第%ld题"), (long)(self.currentQuestionIndex+1)];
    }
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
        [self updateCollecitonFlowLayout:self.collecitonViewFlowLayout];
        self.collectionView.userInteractionEnabled = YES;
        
        [self.collectionView reloadData];
        needExchangePageIndexAnim = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.collectionView.alpha = 1;
        } completion:nil];
    }];
    [self.collecitonTempView reloadData];
}

- (void)updateCollecitonFlowLayout:(UICollectionViewFlowLayout *)flowLayout
{
    NSInteger currentQuestionDisplayType = [self currentQuestionDisplayType];
    if (currentQuestionDisplayType == 2 || currentQuestionDisplayType == 3) {
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 30, 10, 30);
        
        CGFloat width = (SCREEN_WIDTH_DEVICE - flowLayout.sectionInset.left - flowLayout.sectionInset.right - 20) / 2;
        flowLayout.itemSize = CGSizeMake(width, width);
        flowLayout.minimumLineSpacing = 21;
        flowLayout.minimumInteritemSpacing = 10;
    }
    else
    {
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10); flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH_DEVICE - flowLayout.sectionInset.left - flowLayout.sectionInset.right, 60);
        flowLayout.minimumLineSpacing = 21;
    }
}

- (void)redoQAExercise
{
    self.selectedIndexSet = nil;
    self.currentQuestionIndex = 0;
    correctNumber = 0;
    [self shuffledQuestion];
    [self p_reloadCollecitonData];
}

- (void)shuffledQuestion
{
    self.questionLib.questionList = [self.questionLib.questionList mar_shuffledArray];
    for (MXRPKQuestionModel *model in self.questionLib.questionList) {
        model.answers = [model.answers mar_shuffledArray];
    }
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

- (NSString *)currentQutionId
{
    MXRPKQuestionModel* currentQuestion = [self currentQuestionModel];
    return currentQuestion.questionId ?: @"0";
}

- (void)setCurrentQuestionIndex:(NSInteger)currentQuestionIndex
{
    if (_currentQuestionIndex != currentQuestionIndex) {
        needExchangePageIndexAnim = YES;
    }
    _currentQuestionIndex = currentQuestionIndex;
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
        if (self.questionLib.questionList.count > self.currentQuestionIndex) {
            MXRPKQuestionModel *questionModel = self.questionLib.questionList[self.currentQuestionIndex];
            [headerView setCellData:questionModel];
            headerView.questionContentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - self.collecitonViewFlowLayout.sectionInset.left - self.collecitonViewFlowLayout.sectionInset.right - 80;
            
            CGSize oneLineFitSize = [questionModel.questionContent.word boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: headerView.questionContentLabel.font} context:nil].size;
            
            if (oneLineFitSize.width < headerView.questionContentLabel.preferredMaxLayoutWidth) {
                headerView.questionContentLabel.textAlignment = NSTextAlignmentCenter;
            }
            else
            {
                headerView.questionContentLabel.contentMode = NSTextAlignmentLeft;
            }
        }
        [headerView setShareStyle:collectionView != self.collectionView];
        return headerView;
    }
    else
    {
        MXRPKNormalFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MXRPKNormalFooterView" forIndexPath:indexPath];
        [footerView.askHelpBtn mar_removeAllActionBlocks];
        __weak __typeof(self) weakSelf = self;
        footerView.userInteractionEnabled = collectionView == self.collectionView;
        [footerView.askHelpBtn mar_addActionBlock:^(id sender) {
            [weakSelf snapshootCollectionViewAndShare];
        } forState:UIControlEventTouchUpInside];
        [footerView setShareStyle:collectionView != self.collectionView];
        return footerView;
    }
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
        cell.mxr_selected = [self.selectedIndexSet containsObject:@(row)];
        [cell setCellData:answerOption];
        [cell showResult];
        if (self.collectionView != collectionView) {
            cell.backgroundColor = [UIColor redColor];
        }
        return cell;
    }
    else
    {
        MXRPKAnswerOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MXRPKAnswerOptionCell" forIndexPath:indexPath];
        cell.mxr_selected = [self.selectedIndexSet containsObject:@(row)];
        [cell setCellData:answerOption];
        [cell showResult];
        if (self.collectionView != collectionView) {
            [cell setShareCellStyle];
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
    headerView.questionContentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - self.collecitonViewFlowLayout.sectionInset.left - self.collecitonViewFlowLayout.sectionInset.right - 80;
    
    MXRPKQuestionModel *questionModel = self.currentQuestionModel;
    [headerView setCellData:questionModel.questionContent.word];
    [headerView setCellData:questionModel];
    [headerView setShareStyle:collectionView != self.collectionView];
    CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    CGSize headerSize = CGSizeMake(SCREEN_WIDTH_DEVICE - self.collecitonViewFlowLayout.sectionInset.left - self.collecitonViewFlowLayout.sectionInset.right, height);
    return headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (!self.questionLib || !self.currentQuestionModel || collectionView != self.collectionView) {
        return CGSizeZero;
    }
    CGSize footerSize = CGSizeMake(SCREEN_WIDTH_DEVICE - self.collecitonViewFlowLayout.sectionInset.left - self.collecitonViewFlowLayout.sectionInset.right, 175);
    return footerSize;
}

#pragma mark - UIColleciton Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView != self.collectionView) {
        return;
    }
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
                if (self.questionLib.questionList.count > self.currentQuestionIndex + 1) {
                    [self performSelector:@selector(showNextQuestion) withObject:nil afterDelay:1.6f];
                }
            }
        }
    }
    
    [self.collectionView reloadData];
    
    // 答案选择结束
    if (self.selectedIndexSet.count >= currentCorrectOptionSet.count) {
        MXRPKQuestionModel *currentQuesitonModel = [self currentQuestionModel];
        currentQuesitonModel.isRight = [self.selectedIndexSet isEqualToSet:currentCorrectOptionSet];
        currentQuesitonModel.selectedIndexArray = [self.selectedIndexSet allObjects];
        if ([self.selectedIndexSet isEqual:currentCorrectOptionSet]) {
            correctNumber ++;
        }
        
        // 是否是最后一题
        if (self.questionLib.questionList.count > 0 && self.questionLib.questionList.count == self.currentQuestionIndex + 1) {
            self.collectionView.userInteractionEnabled = NO;
            // 提交答案
            [self performSelector:@selector(submitAnswerAction) withObject:nil afterDelay:1.5f];
        }
        else
        {
            self.collectionView.userInteractionEnabled = NO;
            [self performSelector:@selector(showNextQuestion) withObject:nil afterDelay:1.5f];
        }
    }
}

- (void)submitAnswerAction
{
    MXRSubmitPKAnswersR *submitPKAnswersR = [MXRSubmitPKAnswersR new];
    submitPKAnswersR.qaInfoId = self.qaId; // @"7";//self.qaId;
    submitPKAnswersR.startTime = startTime * 1000;
    submitPKAnswersR.endTime = [[NSDate new] timeIntervalSince1970] * 1000;
    submitPKAnswersR.ip = [UIDevice currentDevice].mar_ipAddressWIFI ?: ([UIDevice currentDevice].mar_ipAddressCell ?: @"");
    submitPKAnswersR.isPk = 1;
    NSMutableArray *questionDetailArray = [NSMutableArray arrayWithCapacity:self.questionLib.questionList.count];
    for (MXRPKQuestionModel *model in self.questionLib.questionList) {
        MXRSubmitAnswerDetailR *submitAnswerDetailR = [MXRSubmitAnswerDetailR new];
        NSMutableArray *idArray = [NSMutableArray arrayWithCapacity:model.selectedIndexArray.count];
        for (int i = 0; i<model.selectedIndexArray.count; i++) {
            [idArray addObject:@(model.answers[[model.selectedIndexArray[i] integerValue]].answerId)];
        }
        submitAnswerDetailR.answerIds = idArray;
        submitAnswerDetailR.questionId = model.questionId;
        submitAnswerDetailR.isRight = model.isRight;
        [questionDetailArray addObject:submitAnswerDetailR];
    }
    submitPKAnswersR.questionDetail = questionDetailArray;
    if (self.questionLib.questionList.count > 0) {
        submitPKAnswersR.accuracy = MIN(correctNumber * 100 / self.questionLib.questionList.count, 100);
    }
    
    __weak __typeof(self) weakSelf = self;
    [MXRPKNetworkManager submitPKAnswers:submitPKAnswersR success:^(MXRPKSubmitResultModel *submitResult) {
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
        
        MXRPKUserInfoModel *pkUserInfoModel = [MXRPKUserInfoModel new];
        pkUserInfoModel.pkQuestionLibModel = strongSelf.questionLib;
        pkUserInfoModel.mineResult = mineResult;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pkUserInfoModel mxr_modelToJSONObject]];
        NSDictionary *submitResultDict = [submitResult mxr_modelToJSONObject];
        [dict setObject:submitResultDict forKey:@"submitResult"];

        MXRPKQuestionResultViewController *vc = [[MXRPKQuestionResultViewController alloc] initWithPKUserInfoModel:pkUserInfoModel submitResultModel:submitResult];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        weakSelf.missionCompleteVC = vc;
        
        [weakSelf performSelector:@selector(redoQAExercise) withObject:nil afterDelay:0.25];
        
//        [[MXRSettingTimerManager sharedInstance] resumeTipsTimer];
    } failure:^(id error) {
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
        
//        [[MXRSettingTimerManager sharedInstance] resumeTipsTimer];
    }];
}

/**
 截图
 */
- (void)snapshootCollectionViewAndShare
{
    snapPageIndex = self.currentQuestionIndex;
    [self updateCollecitonFlowLayout:self.collecitonTempViewFlowLayout];
    UIScrollView *scrollView = self.collecitonTempView;
    if (CGRectGetHeight(scrollView.frame) >= scrollView.contentSize.height) {
        UIImage* viewImage = nil;
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);
        {
            CGPoint savedContentOffset = scrollView.contentOffset;
            CGRect savedFrame = scrollView.frame;
            
            scrollView.contentOffset = CGPointZero;
            scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, MAX(scrollView.contentSize.height, CGRectGetHeight(scrollView.frame)));
            
            [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
            viewImage = UIGraphicsGetImageFromCurrentImageContext();
            
            scrollView.contentOffset = savedContentOffset;
            scrollView.frame = savedFrame;
        }
        UIGraphicsEndImageContext();
        [self shareImageWithQuestionImage:viewImage];
        return;
    }
    CGPoint off = scrollView.contentOffset;
    off.y = scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom;
    [scrollView setContentOffset:off animated:YES];
    __weak __typeof(self)weakSelf = self;
    self.view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIImage* viewImage = nil;
        self.view.userInteractionEnabled = YES;    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(scrollView.frame), scrollView.contentSize.height/scrollView.contentSize.width * CGRectGetWidth(scrollView.frame)), scrollView.opaque, 0.0);
        {
            CGPoint savedContentOffset = scrollView.contentOffset;
            CGRect savedFrame = scrollView.frame;
            
            scrollView.contentOffset = CGPointZero;
            scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, MAX(scrollView.contentSize.height, CGRectGetHeight(scrollView.frame)));
            CGContextRef contextRef = UIGraphicsGetCurrentContext();
            
            [scrollView.layer renderInContext:contextRef];
            viewImage = UIGraphicsGetImageFromCurrentImageContext();
            
            scrollView.contentOffset = savedContentOffset;
            scrollView.frame = savedFrame;
        }
        UIGraphicsEndImageContext();
        mxr_dispatch_main_async_safe(^{
            [weakSelf shareImageWithQuestionImage:viewImage];
        });
    });
}

- (void)shareImageWithQuestionImage:(UIImage *)questionImage
{
    questionImage = [questionImage mxr_imageByRoundCornerRadius:10];   // 有黑边 去调
    snapQAImage = questionImage;
    CGFloat containerWidth = 320;
    CGFloat margin = 15;
    CGFloat space = 10;
    CGFloat hSpace = 10;
    CGFloat qrImageSize = 80;       // <= 290
    
    NSString *url = QREXVC_URL_QRVALUE;
    UIImage *qrImage = [UIImage mxr_qrImageWithString:url size:qrImageSize];
    
    UIView *captureView = [[UIView alloc] init];
    captureView.backgroundColor = [UIColor whiteColor];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIImageView* questionImageView = [UIImageView new];
    questionImageView.contentMode = UIViewContentModeScaleAspectFit;
    questionImageView.image = questionImage;
    UIView *seperatorLine = [UIView new];
    seperatorLine.backgroundColor = MXRCOLOR_F3F4F6;
    UIImageView *qrImageView = [UIImageView new];
    qrImageView.contentMode = UIViewContentModeScaleAspectFit;
    qrImageView.image = qrImage;
    UILabel *tipLabel = [UILabel new];
    tipLabel.numberOfLines = 0;
    UIFont *tipLabelFont = [UIFont systemFontOfSize:10.f];
    UIColor *tipLabelTextColor = RGBHEX(0x666666);
    tipLabel.font = tipLabelFont;
    tipLabel.textColor = tipLabelTextColor;
    
    [captureView addSubview:backView];
    [captureView addSubview:questionImageView];
    [captureView addSubview:seperatorLine];
    [captureView addSubview:qrImageView];
    [captureView addSubview:tipLabel];
    
    CGFloat quesitonImageViewHeight = 0;
    if (questionImage.size.width > 0) {
        quesitonImageViewHeight = (containerWidth - margin * 2) * questionImage.size.height / questionImage.size.width;
    }
    questionImageView.frame = CGRectMake(margin, margin, containerWidth - margin * 2, quesitonImageViewHeight);
    seperatorLine.frame = CGRectMake(0, questionImageView.mar_bottom + space * 3, containerWidth, 5);
    qrImageView.frame = CGRectMake(margin, seperatorLine.mar_bottom + space * 3, qrImageSize, qrImageSize);
    captureView.frame = CGRectMake(0, 0, containerWidth, margin + qrImageView.mar_bottom + margin);
    CGRect captureViewFrame = captureView.frame;
    captureViewFrame.size.height += 15;
    backView.frame = captureViewFrame;  // 结局去
    
//    NSString *tipStr = [NSString stringWithFormat:MXRLocalizedString(@"MXRQAExerciseVC_ShareQAForHelp", @"你的好友%@向你求助了，这题你会吗？\n赶紧长按二维码进行答题吧"), [UserInformation modelInformation].userNickName ?: @""];
    NSString *tipStr = MXRLocalizedString(@"MXRQAExerciseVC_ShareContent_DownloadApp", @"长按二维码，下载4D书城和我一起答题吧！");
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:tipStr attributes:@{NSFontAttributeName: tipLabelFont, NSForegroundColorAttributeName: tipLabelTextColor, NSParagraphStyleAttributeName: style}];
    tipLabel.attributedText = attr;
    
    CGFloat maxTipLabelWidth = containerWidth - (CGRectGetMinX(qrImageView.frame) + CGRectGetWidth(qrImageView.frame)) - hSpace - margin;
    
    CGSize tipLabelSize = [attr boundingRectWithSize:CGSizeMake(maxTipLabelWidth, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    tipLabel.frame = CGRectMake(CGRectGetMinX(qrImageView.frame) + CGRectGetWidth(qrImageView.frame) + hSpace, qrImageView.frame.origin.y + (CGRectGetHeight(qrImageView.frame) - tipLabelSize.height)/2, tipLabelSize.width, tipLabelSize.height);
    
    
    UIImage *captureImage = [UIImage getImageFromView:captureView]; // [captureView mxr_snapshotImage];
    
    snapQAAndQRCodeImage = captureImage;
    [self shareActionWithImage:captureImage];
}

- (void)shareActionWithImage:(UIImage *)image
{
    //    NSString *url = QREXVC_URL_QRVALUE;
    // 分享需要和大山交互
    //[self currentQuestionModel].questionBook.bookGuid
    NSString *tipStr = MXRLocalizedString(@"MXRQAExerciseVC_ShareContent_AskQestionForHelp", @"哪位大侠可以帮助我解决这道难题？已被题目难倒，拜请各位大侠前来相助！");
//    MXRNewShareView *shareView = [[MXRNewShareView alloc] initWithShareImg:snapQAAndQRCodeImage MXQShareContent:tipStr bookGUID:_questionLib.recommendBook.bookGuid QAID:[NSString stringWithFormat:@"%ld", [self.qaId integerValue]] originalImg:snapQAImage];
//    [shareView showInView:nil];
}

#pragma mark - observers
- (void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeMissionCompleteVC) name:Notification_RNNoti_ColseMissionCompleye object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryAgain) name:Notification_RNNoti_MissionTryAgain object:nil];
}

- (void)removeObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 关闭答题
 */
- (void)closeMissionCompleteVC{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_QuitMissionCompleteVCGoToBook object:nil];
    }];
}

/**
 再测一次
 */
- (void)tryAgain{
//    [[MXRSettingTimerManager sharedInstance] pauseTipsTimer];
    if (self.missionCompleteVC) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
