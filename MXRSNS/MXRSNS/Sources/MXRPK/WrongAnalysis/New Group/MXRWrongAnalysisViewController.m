//
//  MXRWrongAnalysisViewController.m
//  huashida_home
//
//  Created by MountainX on 2018/8/16.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRWrongAnalysisViewController.h"
#import "MXRPKQuestionResultBookTableViewCell.h"
#import "MXRWrongAnalysisAnswerTextCell.h"
#import "MXRWrongAnalysisAnswerImageCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "UIImageView+WebCache.h"

@interface MXRWrongAnalysisViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateLeftAlignedLayout>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (strong, nonatomic) IBOutlet UIView *tableviewHeader;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLeadingConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *analysisLabel;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorHintLabel;
@property (weak, nonatomic) IBOutlet UILabel *analysisHintLabel;
@property (weak, nonatomic) IBOutlet UIImageView *questionIv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionIvHeightConstraint;

@property (nonatomic, assign) NSInteger currentQAIndex;// 当前解析的下标
@property (nonatomic, strong) NSMutableArray <MXRPKQuestionModel *>* wrongQAList;// 所有错题
@property (nonatomic, strong) NSMutableArray <NSArray *>* wrongAnswers;// 所有错误选择
@property (nonatomic, strong) NSMutableArray <NSNumber *>* sortArray;// 题目序号数组

@property (nonatomic, copy) NSArray <NSString *>* chnNumChar;
@property (nonatomic, copy) NSArray <NSString *>* chnUnitSection;
@property (nonatomic, copy) NSArray <NSString *>* chnUnitChar;

@end

@implementation MXRWrongAnalysisViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = MXRLocalizedString(@"MXR_PK_MC_WRONG_ANALYSIS", @"答案解析");
    
    [_previousBtn setTitle:MXRLocalizedString(@"MXR_PK_WA_LAST_QUESTION", @"上一题") forState:UIControlStateNormal];
    [_nextBtn setTitle:MXRLocalizedString(@"MXR_PK_WA_NEXT_QUESTION", @"下一题") forState:UIControlStateNormal];
    _errorHintLabel.text = MXRLocalizedString(@"MXR_PK_WA_WRONG", @"呜呜，答错了！");
    _analysisHintLabel.text = [NSString stringWithFormat:@"%@:", MXRLocalizedString(@"MXR_PK_WA_ANALYSIS", @"解析")];
    
    [self setupTableView];
    [self setupCollectionView];
    
    [self analysisData];
    
    [self resetBottomBtns];
}

- (void)dealloc {
    DLOG_METHOD
}

#pragma mark - Private Method
- (void)setupTableView {
    _sortLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - 2 * _titleLabelLeadingConstraint.constant;
    _titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - 2 * _titleLabelLeadingConstraint.constant;
    _analysisLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - 2 * _titleLabelLeadingConstraint.constant;
    
//    _tableView.estimatedRowHeight = 146.f;
    _tableView.tableHeaderView = _tableviewHeader;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

static NSString *MXRWrongAnalysisAnswerTextCellIdentifier = @"MXRWrongAnalysisAnswerTextCellIdentifier";
static NSString *MXRWrongAnalysisAnswerImageCellIdentifier = @"MXRWrongAnalysisAnswerImageCellIdentifier";
- (void)setupCollectionView {
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MXRWrongAnalysisAnswerTextCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:MXRWrongAnalysisAnswerTextCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MXRWrongAnalysisAnswerImageCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:MXRWrongAnalysisAnswerImageCellIdentifier];
}

- (void)reloadData {
    [_collectionView reloadData];
    _collectionViewHeightConstraint.constant = _collectionView.collectionViewLayout.collectionViewContentSize.height;
//    [_collectionView layoutIfNeeded];
    
    NSNumber *sort = [self.sortArray objectAtIndex:self.currentQAIndex];
    NSString *sortStr;
    switch (APPCURRENTTYPE) {
        case MXRAppTypeSnapLearn:
            sortStr = [NSString stringWithFormat:MXRLocalizedString(@"MXR_PK_WA_SORT", @"第%@题"), autoString(@(sort.integerValue))];
            break;
        default:
            sortStr = [NSString stringWithFormat:MXRLocalizedString(@"MXR_PK_WA_SORT", @"第%@题"), [self changeNumberToChinese:sort.integerValue]];
            break;
    }
    
    _sortLabel.text = sortStr;
    
    MXRPKQuestionModel *model = [self.wrongQAList objectAtIndex:self.currentQAIndex];
    
    __block NSInteger correctAnswerNum = 0;
    [model.answers enumerateObjectsUsingBlock:^(MXRPKAnswerOption * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.correct) {
            correctAnswerNum ++;
        }
    }];
    BOOL isMultipleChoose = correctAnswerNum > 1;
    _titleLabel.text = [NSString stringWithFormat:@"%@（%@）", model.questionContent.word, isMultipleChoose ? MXRLocalizedString(@"MXR_PK_WA_MULTIPLE_CHOICE", @"多选") : MXRLocalizedString(@"MXR_PK_WA_SINGLE_CHOICE", @"单选")];
    
    if (autoString(model.questionContent.pic).length > 0) {
        [_questionIv sd_setImageWithURL:[NSURL URLWithString:autoString(model.questionContent.pic)]];
        _questionIvHeightConstraint.constant = 100;
    } else {
        _questionIv.image = nil;
        _questionIvHeightConstraint.constant = 0;
    }
    
    _analysisLabel.text = autoString(model.analysis);
    
    CGFloat height = [_tableviewHeader systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = _tableviewHeader.frame;
    frame.size.height = height;
    _tableviewHeader.frame = frame;
    
    [self.tableView setTableHeaderView:_tableviewHeader];
    
    [self.tableView reloadData];
}

#pragma mark - AnalysisData
- (void)analysisData {
    [self.mineResult.questionModelList enumerateObjectsUsingBlock:^(MXRRandomOpponentQuestionModel * _Nonnull result, NSUInteger idx1, BOOL * _Nonnull stop) {
        if (result.isRight == 0) {
            [self.pkQuestionLibModel.questionList enumerateObjectsUsingBlock:^(MXRPKQuestionModel * _Nonnull question, NSUInteger idx2, BOOL * _Nonnull stop) {
                if ([result.questionId integerValue] == [question.questionId integerValue]) {
                    [self.wrongQAList addObject:question];
                    [self.wrongAnswers addObject:result.answerIds];
                    [self.sortArray addObject:[NSNumber numberWithInteger:idx1+1]];
                    *stop = YES;
                }
            }];
        }
    }];
    if (self.wrongQAList.count > 0) {
        [self reloadData];
    } else {
        self.previousBtn.enabled = NO;
        self.nextBtn.enabled = NO;
        [MXRConstant showAlert:MXRLocalizedString(@"MXR_PK_WA_ERROR", @"没有错题，无法解析！") andShowTime:1.f];
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.wrongQAList.count == 0) {
        return 0;
    }
    MXRPKQuestionModel *model = [self.wrongQAList objectAtIndex:self.currentQAIndex];
    return (model.questionBook && model.questionBook.bookGuid && model.questionBook.bookGuid.length > 0) ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MXRPKQuestionResultBookTableViewCell *cell = [MXRPKQuestionResultBookTableViewCell cellWithTableView:tableView];
    MXRPKQuestionModel *model = [self.wrongQAList objectAtIndex:self.currentQAIndex];
    cell.book = model.questionBook;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UICollectionViewDelegateLeftAlignedLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    CGFloat minimumInteritemSpacing = layout.minimumInteritemSpacing;
    // the item width must be less than the width of the UICollectionView minus the section insets left and right values, minus the content insets left and right values.
    MXRPKQuestionModel *model = [self.wrongQAList objectAtIndex:self.currentQAIndex];
    MXRPKAnswerOption *answer = [model.answers objectAtIndex:indexPath.row];
    if (autoString(answer.pic).length > 0) {
        CGFloat itemW = (SCREEN_WIDTH_DEVICE - 2 * 30 - minimumInteritemSpacing) / 2;
        CGFloat stateIvWidth = 40.f;
        CGFloat itemH = itemW - stateIvWidth;
        return CGSizeMake(itemW, itemH);
    } else {
        CGFloat itemW = SCREEN_WIDTH_DEVICE - 2 * 30;
        CGFloat scale = 58 / 252.0;
        CGFloat itemH = itemW * scale;
        return CGSizeMake(itemW, itemH);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.wrongQAList.count <= self.currentQAIndex) {
        return 0;
    }
    
    MXRPKQuestionModel *model = [self.wrongQAList objectAtIndex:self.currentQAIndex];
    return model.answers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MXRPKQuestionModel *model = [self.wrongQAList objectAtIndex:self.currentQAIndex];
    MXRPKAnswerOption *answer = [model.answers objectAtIndex:indexPath.row];
    NSArray *selectedAnswers = [self.wrongAnswers objectAtIndex:self.currentQAIndex];
    if (autoString(answer.pic).length > 0) {
        MXRWrongAnalysisAnswerImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MXRWrongAnalysisAnswerImageCellIdentifier forIndexPath:indexPath];
        cell.selectedAnswers = selectedAnswers;
        cell.answer = answer;
        return cell;
    } else {
        MXRWrongAnalysisAnswerTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MXRWrongAnalysisAnswerTextCellIdentifier forIndexPath:indexPath];
        cell.selectedAnswers = selectedAnswers;
        cell.answer = answer;
        return cell;
    }
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Events
- (IBAction)previousBtnClicked:(UIButton *)sender {
    if (_currentQAIndex <= 0) {
        _currentQAIndex = 0;
    } else {
        _currentQAIndex --;
    }
    [self resetBottomBtns];
    [self reloadData];
}

- (IBAction)nextBtnClicked:(UIButton *)sender {
    if (_currentQAIndex >= self.wrongQAList.count - 1) {
        _currentQAIndex = self.wrongQAList.count - 1;
    } else {
        _currentQAIndex ++;
    }
    [self resetBottomBtns];
    [self reloadData];
}

#pragma mark - resetBottomBtns
- (void)resetBottomBtns {
    if (self.wrongQAList.count == 0) {
        _previousBtn.enabled = NO;
        _nextBtn.enabled = NO;
    } else {
        _previousBtn.enabled = _currentQAIndex != 0;
        _nextBtn.enabled = _currentQAIndex < self.wrongQAList.count - 1;
    }

    _previousBtn.backgroundColor = _previousBtn.enabled ? MXRCOLOR_2FB8E2 : MXRCOLOR_CCCCCC;
    _nextBtn.backgroundColor = _nextBtn.enabled ? MXRCOLOR_2FB8E2 : MXRCOLOR_CCCCCC;
}

#pragma mark - Lazy Loader
- (NSMutableArray<MXRPKQuestionModel *> *)wrongQAList {
    if (!_wrongQAList) {
        _wrongQAList = [NSMutableArray array];
    }
    return _wrongQAList;
}

- (NSMutableArray<NSArray *> *)wrongAnswers {
    if (!_wrongAnswers) {
        _wrongAnswers = [NSMutableArray array];
    }
    return _wrongAnswers;
}

- (NSMutableArray<NSNumber *> *)sortArray {
    if (!_sortArray) {
        _sortArray = [NSMutableArray array];
    }
    return _sortArray;
}

- (NSArray<NSString *> *)chnNumChar {
    if (!_chnNumChar) {
        _chnNumChar = @[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];
    }
    return _chnNumChar;
}

- (NSArray<NSString *> *)chnUnitSection {
    if (!_chnUnitSection) {
        _chnUnitSection = @[@"",@"万",@"亿",@"万亿",@"亿亿"];
    }
    return _chnUnitSection;
}

- (NSArray<NSString *> *)chnUnitChar {
    if (!_chnUnitChar) {
        _chnUnitChar = @[@"",@"十",@"百",@"千"];
    }
    return _chnUnitChar;
}

#pragma mark - Helper
- (NSString *)changeNumberToChinese:(NSUInteger)num {
    NSInteger unitPos = 0;
    NSString *strIns = @"";
    NSString *chnStr = @"";
    BOOL needZero = NO;
    
    if (num == 0) {
        return self.chnNumChar[0];
    }
    
    while (num > 0) {
        NSInteger section = num % 10000;
        if (needZero) {
            chnStr = [self.chnNumChar[0] stringByAppendingString:chnStr];
        }
        strIns = [self sectionToChinese:section];
        strIns = [strIns stringByAppendingString:section != 0 ? self.chnUnitSection[unitPos] : self.chnUnitSection[0]];
        chnStr = [strIns stringByAppendingString:chnStr];
        needZero = section < 1000 && section > 0;
        num = floor(num / 10000);
        unitPos ++;
    }
    
    return chnStr;
}

- (NSString *)sectionToChinese:(NSUInteger)section {
    NSInteger unitPos = 0;
    NSString *strIns = @"";
    NSString *chnStr = @"";
    BOOL needZero = YES;
    NSInteger originalSection = section;
    
    while (section > 0) {
        NSInteger v = section % 10;
        if (v == 0) {
            if (!needZero) {
                needZero = YES;
                chnStr = [self.chnNumChar[v] stringByAppendingString:chnStr];
            }
        } else {
            needZero = NO;
            if (originalSection < 100 && originalSection >= 10 && section == 1) {
                strIns = @"";
            } else {
                strIns = self.chnNumChar[v];
            }
            strIns = [strIns stringByAppendingString:self.chnUnitChar[unitPos]];
            chnStr = [strIns stringByAppendingString:chnStr];
        }
        unitPos ++;
        section = floor(section / 10);
    }
    return chnStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
