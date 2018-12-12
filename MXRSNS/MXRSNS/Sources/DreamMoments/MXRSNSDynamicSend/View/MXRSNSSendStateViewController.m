//
//  MXRSendStateViewController.m
//  huashida_home
//
//  Created by yuchen.li on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSNSSendStateViewController.h"
#import "MXRHaveDoneSelectImageCell.h"
#import "MXRGetLocalImageController.h"
#import "MXRBookSNSSendDetailProxy.h"
#import <Photos/Photos.h>
#import "MXRSelectLocalImageProxy.h"
#import "MXRLocalAlbumModel.h"
#import "MXRImageInformationModel.h"
#import "MXRBookSNSSearchBookBeforeView.h"
#import "MXRSNSSearchBookViewController.h"
#import "MXRBookSNSSearchBookAfterView.h"
#import "MXRSearchTopicViewController.h"
#import "MXRBookSNSSendDetailManager.h"
#import "MXRBookSNSSendDetailController.h"
#import "MXRSNSShareModel.h"
#import "GlobalFunction.h"
#import "MXRBookSNSModelProxy.h"
#import "MXRDeviceUtil.h"
#import "MXRDataAnalyze.h"
#import "MXRTopicMainViewController.h"
#import "MXRTextView.h"
#import "MXRTopicModel.h"
#import "MXRBookSNSSearchZoneView.h"
#import "UIImage+Extend.h"
#define MXRHaveDoneSelectImageCellID @"MXRHaveDoneSelectImageCellID"
@interface MXRSNSSendStateViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MXRHaveDoneSelectImageDeleteClickDelegate,MXRSNSSearchBookHaveSelectDelegate,MXRBookSNSTopicSelectDelegate>
@property (weak, nonatomic) IBOutlet MXRTextView *sendDetailTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIView *bookContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *selectImageCollection;
/*话题栏*/
@property (weak, nonatomic) IBOutlet UIToolbar *huaTiLan;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *huaTiItem;                                                // #...#
@property (weak, nonatomic) IBOutlet UIBarButtonItem *characterCountItem;                                       // 字符数

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bookContainerViewHeightConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendTextViewHeightConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentSizeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageCollectionHeightConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *huaTiLanBottomConstrain;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;                                           // 点击隐藏键盘的手势
@property (nonatomic, strong) NSMutableArray <MXRImageInformationModel*> *localBookSNSImageModelArray;      // 图片model

@property (nonatomic, strong) NSMutableArray <UIImage*> *localFinalImageArray;                              // 选中的图片(获取imageInfo)    数据源中的图片多一个 + 号图片
@property (nonatomic, strong) UILabel *characterCountLabel;                                                 // 字符数
@property (nonatomic, strong) UIButton *sendButton;                                                         // 发送按钮
@property (nonatomic, strong) UIButton *returnButton;                                                         // 返回按钮

@property (nonatomic, strong) MXRLocalAlbumModel *localModel;                                               // 记录 上次选择的相册信息
@property (nonatomic, strong) MXRSNSShareModel *shareModel;                                                 // 梦想圈内 转发
@property (nonatomic, strong) BookInfoForShelf *shareBookInfo;                                          // 发送到梦想圈的图书
@property (nonatomic, strong) MXRImageInformationModel *shareImageInfomationModel;                      // 分享到梦想圈的图片
@property (nonatomic, assign) MXRBookSNSSendDetailOperateType sendDetailOperateType;
@property (nonatomic, copy)   NSString *shareTextString;                                              // 分享到梦想圈的默认文字
@property (nonatomic, copy)   NSAttributedString *greenSendTitle;
@property (nonatomic, copy)   NSAttributedString *graySendTitlt;
@property (nonatomic, copy)   NSString *topicString;                                                        // 话题名字
/* 话题Model */
@property (nonatomic, strong)MXRTopicModel *topicModel; // 判断是否绑定专区或图书

@end
static const CGFloat kSpaceWidth = 6.0;

@implementation MXRSNSSendStateViewController
{
    BOOL _isSelectTopic;                            // 用来判断是否有#号,是否跳话题页
    BOOL _isHaveGesture;                            // 是否含有点击键盘消失的手势
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
-(instancetype)init
{
    if (self = [super init]) {
        _sendDetailOperateType = MXRBookSNSSendDetailOperateTypedDefault;
    }
    return self;
}
-(instancetype)initWithModel:(MXRSNSShareModel *)model
{
    if (self=[super init]) {
        _shareModel = model;
        _sendDetailOperateType = MXRBookSNSSendDetailOperateTypeTransmit;
    }
    return self;
}

- (instancetype)initWithTopicModel:(MXRTopicModel *)topicModel{
    if (self = [super init]) {
        _topicString = topicModel.name;
        _topicModel  = topicModel;
        _sendDetailOperateType = MXRBookSNSSendDetailOperateTypeJoinTopic;
    }
    return self;
}


-(instancetype)initWithTopic:(NSString *)topicString
{
    if (self=[super init]) {
        _topicString = topicString;
        _sendDetailOperateType = MXRBookSNSSendDetailOperateTypeJoinTopic;
    }
    return self;
}
//-(instancetype)initWithBookInfo:(BookInfoForShelf *)bookInfo WithMXRImageInformationModel:(MXRImageInformationModel *)model
//{
//    if (self=[super init]) {
//        _shareBookInfo = bookInfo;
//        _shareImageInfomationModel = model;
//        _sendDetailOperateType = MXRBookSNSSendDetailOperateTypeShareToBookSNS;
//    }
//    return self;
//}

- (instancetype)initWithBookInfo:(BookInfoForShelf *)bookInfo imageInfoModel:(MXRImageInformationModel *)model shareTextString:(NSString *)shareTextString
{
    if (self = [super init]) {
        _shareBookInfo = bookInfo;
        _shareImageInfomationModel = model;
        _shareTextString = shareTextString;
        _sendDetailOperateType = MXRBookSNSSendDetailOperateTypeShareToBookSNS;
    }
    return self;
}

- (instancetype)initWithTopic:(NSString *)topicString operationType:(MXRBookSNSSendDetailOperateType)operationType
{
    if (self = [super init]) {
        _topicString = topicString;
        _sendDetailOperateType = MXRBookSNSSendDetailOperateTypeChatJoinTopic;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self addNotification];
    if (self.sendDetailOperateType != MXRBookSNSSendDetailOperateTypeTransmit) {
        [self requestDynamicQiNiuUploadToken];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.sendDetailTextView becomeFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MXRClickUtil beginEvent:@"MengXiangQuanPage"];
    [MXRClickUtil beginLogPageView:@"MXRSNSSendStateViewController"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    [MXRClickUtil endEvent:@"MengXiangQuanPage"];
    [MXRClickUtil endLogPageView:@"MXRSNSSendStateViewController"];
}

-(void)dealloc{
    DLOG_METHOD;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //isneedSet 设为no之后（图片选择相关）
    [[MXRSelectLocalImageProxy getInstance]becomeImagestateToUncheck];
    [[MXRSelectLocalImageProxy getInstance]removeAllPreselectImageInfoModelData];
    [[MXRBookSNSSendDetailManager getInstance] clearRecordTopicArray];
}

-(void)addNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 七牛token
 */
-(void)requestDynamicQiNiuUploadToken{
    
    if (![UserInformation modelInformation].userID) return;

    [[MXRBookSNSSendDetailController getInstance] dynamicAcquisitionQiNiuUploadTokenUserId:[UserInformation modelInformation].userID moduleName:@"dynamic" callBack:nil];
}
/**
 *  图片分享 手动添加一个model
 */
-(void)setUpWithImageModel:(MXRImageInformationModel*)model{
    [self.localBookSNSImageModelArray addObject:model];
    [self.localFinalImageArray addObject:model.assetImage];
    [[MXRBookSNSSendDetailProxy getInstance].selectImageArray insertObject:model.assetImage atIndex:0];
}

#pragma mark --collectionView代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger imageCount = [[MXRBookSNSSendDetailProxy getInstance].selectImageArray count];
    if (imageCount > 9) {
        return imageCount - 1;
    }
    if (imageCount >= 0 && imageCount <= 9){
        return imageCount;
    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MXRHaveDoneSelectImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MXRHaveDoneSelectImageCellID forIndexPath:indexPath];
    [cell configureWithImage:[MXRBookSNSSendDetailProxy getInstance].selectImageArray[indexPath.item]];
    if (indexPath.item == [MXRBookSNSSendDetailProxy getInstance].selectImageArray.count - 1) {
        cell.isShowDelete = NO;
    }else{
        cell.isShowDelete = YES;
    }
    cell.delegate = self;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MXRHaveDoneSelectImageCell *cell = (MXRHaveDoneSelectImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
    UIImage *addImage = [[MXRBookSNSSendDetailProxy getInstance].selectImageArray lastObject];
    if ([cell.mainImageView.image isEqual:addImage]) {
        @MXRWeakObj(self);
        [[MXRGetLocalImageController getInstance]presentToSelectImageLocalType:PHAssetMediaTypeImage maxCount:9 isAddPhotoItem:YES lastSelectAlbumModel:self.localModel lastSelectModelArray:selfWeak.localBookSNSImageModelArray presentCompletion:^(BOOL finish) {
            
        } selectDoneCompletion:^(NSMutableArray *objectArray) {
                selfWeak.localBookSNSImageModelArray = [[MXRSelectLocalImageProxy getInstance].preSelectImageModelArray mutableCopy];
                [selfWeak getImageFromAlbum:objectArray];
        }];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat itemWH = (SCREEN_WIDTH_DEVICE_ABSOLUTE - 8 * kSpaceWidth - 20) / 4.0;
    return CGSizeMake(itemWH, itemWH);
}
// 设置每个图片的Margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kSpaceWidth,kSpaceWidth,kSpaceWidth,kSpaceWidth);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (![scrollView isKindOfClass:[UITextView class]]) {
        [self.sendDetailTextView resignFirstResponder];
        self.huaTiLanBottomConstrain.constant = 0;
    }
}
#pragma mark---MXRHaveDoneSelectImageDeleteClickDelegate
/**
 * 删除数据源中的图片和 图片信息模型
 */
-(void)userClickDeleteSelectImageWithCell:(MXRHaveDoneSelectImageCell *)cell
{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    NSIndexPath *indexPAth = [self.selectImageCollection indexPathForCell:cell];
    //数据源显示的image
    [[MXRBookSNSSendDetailProxy getInstance].selectImageArray removeObjectAtIndex:indexPAth.item];
    if (IOS8_OR_LATER) {
        if (self.localBookSNSImageModelArray.count > indexPAth.item) {
            //缓存的图片model
            [self deleteImageAndModelFromLocalData:indexPAth.item];
        }
    }
    if (iphone4Size) {
        CGFloat itemWH = (SCREEN_WIDTH_DEVICE_ABSOLUTE- 8 * kSpaceWidth - 20) / 4.0;
        if (self.localFinalImageArray.count + 1 >= 9) {
            self.imageCollectionHeightConstrain.constant = (itemWH + kSpaceWidth)* (self.localFinalImageArray.count/4 + 1)+ 10;
            CGFloat collectOriginalY = self.selectImageCollection.frame.origin.y;
            self.scrollContentSizeHeight.constant = collectOriginalY + self.imageCollectionHeightConstrain.constant + itemWH;
        }else{
            self.scrollContentSizeHeight.constant = SCREEN_HEIGHT_DEVICE_ABSOLUTE-64+10;
        }
    }
    [self.selectImageCollection reloadData];
}
#pragma mark--获取照片
-(void)getImageFromAlbum:(NSMutableArray *)imageArray{
    if (imageArray.count == 0) return;
    NSInteger  selectImageCount = [[MXRBookSNSSendDetailProxy getInstance].selectImageArray count] - 1;
    if (selectImageCount > 0) {
        NSIndexSet *indexset = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(0, selectImageCount)];
        [[MXRBookSNSSendDetailProxy getInstance].selectImageArray removeObjectsAtIndexes:indexset];
    }
    NSInteger imageCount = imageArray.count;
    if (imageCount > 0) {
        NSMutableIndexSet *indexSetTwo = [[NSMutableIndexSet alloc]init];
        [indexSetTwo addIndexesInRange:NSMakeRange(0,imageCount)];
        [[MXRBookSNSSendDetailProxy getInstance].selectImageArray insertObjects:imageArray atIndexes:indexSetTwo];
        if (IOS8_OR_LATER) {
            [self deliverProxyImageAndAlbumInformationToVC:imageArray];
        }
        if (iphone4Size) {
            CGFloat itemWH = (SCREEN_WIDTH_DEVICE_ABSOLUTE - 8 * kSpaceWidth - 20) / 4.0;
            if (imageCount + 1 >= 9) {
                self.imageCollectionHeightConstrain.constant = (itemWH + kSpaceWidth)* (imageCount/4 + 1) + 10;
                CGFloat collectOriginalY = self.selectImageCollection.frame.origin.y;
                self.scrollContentSizeHeight.constant = collectOriginalY + self.imageCollectionHeightConstrain.constant+itemWH;
            }
        }
        [self.selectImageCollection reloadData];
    }
}
#pragma mark - UITextViewDelegate 代理
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [self.sendDetailTextView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    // 如果话题绑定图书或者绑定专区,话题不可编辑且不可以在次输入 ‘#’
    if (self.topicModel.relevantType == TopicRelevantBook || self.topicModel.relevantType == TopicRelevantZone) {
        //话题不可编辑
        if (range.location < self.sendDetailTextView.disableEditNum) {
            return NO;
        }else{
             NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
            // 不可输入“#”    <efbc83>: 中文#的data description
            if ([text containsString:@"#"] || [data.description isEqualToString:@"<efbc83>"]) {
                return NO;
            }
        }
    }
    
    if ([text isEqualToString:@"#"]) {
        _isSelectTopic = YES;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }else{
        self.placeholderLabel.hidden = YES;
    }
    [[MXRBookSNSSendDetailManager getInstance] textStringToRegularExpressionWithTextView:self.sendDetailTextView];
    // 输入#号 跳转至全部话题
//    if (_isSelectTopic) {
//        MXRSearchTopicViewController *searchTopicVC = [[MXRSearchTopicViewController alloc]initWithIsNeedJing:NO withSearchTextFieldBecomeFirstRegister:NO withIsFromAllTopic:NO];
//        searchTopicVC.delegate = self;
//        [self presentViewController:searchTopicVC animated:YES completion:^{
//            _isSelectTopic = NO;
//        }];
//    }

    if (self.sendDetailTextView.text.length == 0) {
        if (self.sendDetailOperateType == MXRBookSNSSendDetailOperateTypeTransmit) {
            [self setSendBtnEnableAndGreenColor];
        }else{
            [self setSendBtnNoEnableAndGrayColor];
        }
    }else if(self.sendDetailTextView.text.length <= 140){
        [self setSendBtnEnableAndGreenColor];
    }else{
        [self setSendBtnNoEnableAndGrayColor];
    }
    NSInteger stringlength = textView.text.length;
    self.characterCountLabel.text = [NSString stringWithFormat:@"%ld", (long)stringlength];
    if (stringlength > 140) {
         self.characterCountLabel.textColor = [UIColor redColor];
    }else{
         self.characterCountLabel.textColor = RGB(153, 153, 153);
    }
    
    
}
#pragma mark--选取图书
-(void)toSelectBookFromLocal{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    MXRSNSSearchBookViewController *searchBookVC = [[MXRSNSSearchBookViewController alloc]init];
    searchBookVC.delegate = self;
    searchBookVC.hideBackButton = YES;
    [self.navigationController  pushViewController:searchBookVC animated:YES];
}
#pragma mark--MXRSNSSearchBookHaveSelectDelegate选取图书
-(void)userHaveDoneSelectBook:(BookInfoForShelf *)book
{
    _shareBookInfo = book;
    for (UIView *view in self.bookContainerView.subviews) {
        [view removeFromSuperview];
    }
    MXRBookSNSSearchBookAfterView *afterView = [[MXRBookSNSSearchBookAfterView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH_DEVICE_ABSOLUTE - 32, 60) WithBookShelfModel:book];
    self.bookContainerViewHeightConstrain.constant = 60;
    self.bookContainerView.layer.borderColor = RGB(212, 214, 216).CGColor;
    [self.bookContainerView addSubview:afterView];
    [self setSendBtnEnableAndGreenColor];
}
#pragma mark--发布
-(void)sendDetailClick{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    [MXRClickUtil event:@"DreamCircle_Publish_Click"];
    [self.sendDetailTextView resignFirstResponder];
    self.huaTiLanBottomConstrain.constant = 0;
    self.sendDetailTextView.selectedRange = NSMakeRange(0, 500);
    BOOL isRelevantZone = self.topicModel.relevantType == TopicRelevantZone ? YES : NO;
    
    @MXRWeakObj(self);
    [[MXRBookSNSSendDetailManager getInstance]userClickSendToPublicBookSNSDetail:self.sendDetailTextView bookInfoShelf:_shareBookInfo associateView:self.bookContainerView isRelevantZone: isRelevantZone operateType:self.sendDetailOperateType callBack:^(BOOL isOkay) {
        if (isOkay) {
            if ([[UserInformation modelInformation]getIsLogin]) {
                if (selfWeak.localFinalImageArray.count > 0) {
                    [[MXRBookSNSSendDetailProxy  getInstance] getImageUrlAndStateWithImageArray:selfWeak.localFinalImageArray];
                }
                selfWeak.sendButton.enabled = NO;
                switch (selfWeak.sendDetailOperateType) {
                    case MXRBookSNSSendDetailOperateTypedDefault:
                    case MXRBookSNSSendDetailOperateTypeJoinTopic:
                        [selfWeak sendSNSDefaultWithTextView:selfWeak.sendDetailTextView];
                        break;
                    case MXRBookSNSSendDetailOperateTypeTransmit:
                        [selfWeak sendSNSTransitWithTextView:selfWeak.sendDetailTextView];
                        break;
                    case MXRBookSNSSendDetailOperateTypeShareToBookSNS:
                        [selfWeak sendSNSShareWithTextView:selfWeak.sendDetailTextView];
                        break;
                    case MXRBookSNSSendDetailOperateTypeChatJoinTopic:
                         [selfWeak sendSNSDefaultWithTextView:selfWeak.sendDetailTextView];
                    default:
                        break;
                }
            }
        }else{
            [selfWeak setSendBtnNoEnableAndGrayColor];
            return ;
        }
    }];
    [[MXRBookSNSSendDetailManager getInstance] clearRecordTopicArray]; //清空用户此次操作所选的话题
}
#pragma mark--退出
-(void)backClick{
    [self.sendDetailTextView resignFirstResponder];
    self.huaTiLanBottomConstrain.constant = 0;
    [self resetDataArrayAfterExit];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)resetDataArrayAfterExit{
    if (self.sendDetailOperateType == MXRBookSNSSendDetailOperateTypeShareToBookSNS) {
        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_MXRSelectImageLocal_ReloadData object:nil];
        [[[MXRSelectLocalImageProxy getInstance] preSelectImageModelArray] removeAllObjects];
    }
    [[MXRBookSNSSendDetailProxy getInstance]removeAllBookInfo];
    [[MXRBookSNSSendDetailProxy getInstance]removeAllSelectImage];
    [[MXRBookSNSSendDetailProxy getInstance]removeAllImageInfo];

}
#pragma mark--选取话题代理
-(void)userHaveSelectTopicDelegate:(NSString *)topicString{
    [[MXRBookSNSSendDetailManager getInstance].recordTopicArray addObject:topicString];
    if (self.sendDetailTextView.text.length == 0) {
        self.placeholderLabel.layer.zPosition = -50;
    }
    
    if (topicString) {
        self.sendDetailTextView.text = [self.sendDetailTextView.text stringByAppendingString:topicString];
        [self textViewDidChange:self.sendDetailTextView];
        [self.sendDetailTextView becomeFirstResponder];
    }
}

-(void)makeTextViewBecomeFirstResponder
{
    [self.sendDetailTextView becomeFirstResponder];
}

-(void)huaTiItemClick{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    MXRSearchTopicViewController *searchTopicVC = [[MXRSearchTopicViewController alloc]initWithIsNeedJing:YES withSearchTextFieldBecomeFirstRegister:NO withIsFromAllTopic:NO];
    searchTopicVC.delegate = self;
    [self presentViewController:searchTopicVC animated:YES completion:nil];
}

-(void)tapToResignKeyboard{
    if ((_isHaveGesture && iphone4Size)||(_isHaveGesture && self.sendDetailOperateType == MXRBookSNSSendDetailOperateTypeTransmit)) {
        [self.sendDetailTextView resignFirstResponder];
        [self.view removeGestureRecognizer:self.tapGesture];
        _isHaveGesture = NO;
        self.huaTiLanBottomConstrain.constant = 0;
    }
}


#pragma mark - 键盘代理方法
-(void)keyBoardWillShow:(NSNotification*)notify{
    CGRect keyBoardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    @MXRWeakObj(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        selfWeak.huaTiLanBottomConstrain.constant = keyBoardFrame.size.height;
        if (selfWeak.sendDetailOperateType == MXRBookSNSSendDetailOperateTypeTransmit || iphone4Size) {
            CGFloat heightNum = selfWeak.view.frame.size.height - 64 - 15 - 44 - keyBoardFrame.size.height;
            selfWeak.sendTextViewHeightConstrain.constant = heightNum;
        };
    });
    if ((!_isHaveGesture && iphone4Size)||(!_isHaveGesture && self.sendDetailOperateType == MXRBookSNSSendDetailOperateTypeTransmit)) {
        self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToResignKeyboard)];
        [self.view addGestureRecognizer:self.tapGesture];
        _isHaveGesture = YES;
    }
}

-(void)keyBoardWillHide:(NSNotification*)notify{
    @MXRWeakObj(self);
    [UIView animateWithDuration:1.0 animations:^{
        selfWeak.huaTiLanBottomConstrain.constant = 0;
        if (selfWeak.sendDetailOperateType == MXRBookSNSSendDetailOperateTypeTransmit) {
            selfWeak.sendTextViewHeightConstrain.constant = selfWeak.view.frame.size.height - 44 - 64 - 15;
        }else{
            selfWeak.sendTextViewHeightConstrain.constant = 130;
        }
    }];
}

#pragma mark--初始化设置
-(void)setUp{
    [self setupBackgroundScroll];
    [self setupSendTextview];
    [self setupHuaTiLan];
    [self setupImageDisplayCollectionView];
    [self setupNavigation];
    [self setupBookContainerView];
}

-(void)setupBackgroundScroll{
    if (self.sendDetailOperateType == MXRBookSNSSendDetailOperateTypeTransmit) {
        self.selectImageCollection.hidden = YES;
        self.bgScrollView.scrollEnabled = NO;
      
    }
    self.bgScrollView.delegate = self;
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    if (iPhone6||iPhone6Plus||iPhone5) {
        self.scrollContentSizeHeight.constant = SCREEN_HEIGHT_DEVICE_ABSOLUTE - 64 + 10;
        //5s以下
    }else if(iphone4Size){
        self.scrollContentSizeHeight.constant = SCREEN_HEIGHT_DEVICE_ABSOLUTE- 64 + 10;
    }else{
        self.scrollContentSizeHeight.constant = SCREEN_HEIGHT_DEVICE_ABSOLUTE- 64 + 10;
    }
}

-(void)setupNavigation{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.returnButton];
    if (self.sendDetailOperateType == MXRBookSNSSendDetailOperateTypeTransmit) {
        [self setNavTitleLabelText:MXRLocalizedString(@"MXRSNSSendStateViewController_transitDetail", @"转发动态")];
        [self setSendBtnEnableAndGreenColor];
    }else{
        [self setNavTitleLabelText:MXRLocalizedString(@"MXRSNSSendStateViewController_sendDetail", @"发布动态")];
        [self setSendBtnNoEnableAndGrayColor];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.sendButton];
}

/**
 图书信息
 */
-(void)setupBookContainerView{

    switch (self.sendDetailOperateType) {
        case MXRBookSNSSendDetailOperateTypeChatJoinTopic:
        case MXRBookSNSSendDetailOperateTypedDefault:
            // 默认设置
            [self setupSearchBookBeforeView];
            break;
        case MXRBookSNSSendDetailOperateTypeTransmit:
        {
            // 隐藏图书
            self.bookContainerView.userInteractionEnabled = NO;
            self.bookContainerView.hidden = YES;
        }
            break;
        case MXRBookSNSSendDetailOperateTypeJoinTopic:
        {
            //2,判断有无绑定图书
            if (self.topicModel.relevantType == TopicRelevantBook) {
                [self userHaveDoneSelectBook:self.topicModel.bookInfo];
                //3,判断有无绑定专区
            }else if (self.topicModel.relevantType == TopicRelevantZone){
                [self setupSearchZoneView];
            }else {
                // 默认设置
                [self setupSearchBookBeforeView];
            }
        }
            break;
            
        case MXRBookSNSSendDetailOperateTypeShareToBookSNS:

        {
            //分享图书至梦想圈,自动选择图书
            if (self.shareBookInfo) {
                [self userHaveDoneSelectBook:self.shareBookInfo];
            }
        }
            break;
     
        default:
            break;
    }
}

- (void)setupSearchBookBeforeView{
    MXRBookSNSSearchBookBeforeView *beforeView = [[MXRBookSNSSearchBookBeforeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE_ABSOLUTE - 32, 38)];
    UIColor *borderColor = RGB(212, 214, 216);
    self.bookContainerView.layer.borderWidth = 1.0f;
    self.bookContainerView.layer.borderColor = borderColor.CGColor;
    [self.bookContainerView addSubview:beforeView];
    self.bookContainerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toSelectBookFromLocal)];
    [self.bookContainerView addGestureRecognizer:tap];
}

/**
 关联专区
 */
- (void)setupSearchZoneView{
    
    MXRBookSNSSearchZoneView *zoneView = [[MXRBookSNSSearchZoneView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE_ABSOLUTE - 32, 60)];
    self.bookContainerViewHeightConstrain.constant = 60;
    self.bookContainerView.layer.borderWidth = 1.0f;
    self.bookContainerView.layer.borderColor = RGB(212, 214, 216).CGColor;
    zoneView.zoneModel = self.topicModel.zoneModel;
    [self.bookContainerView addSubview:zoneView];
    [self setSendBtnEnableAndGreenColor];
}
-(void)setupSendTextview{

    NSAttributedString *sendAttributeString = [[NSAttributedString alloc]initWithString:self.sendDetailTextView.text attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.sendDetailTextView.delegate = self;
    self.sendDetailTextView.attributedText = sendAttributeString;
    self.sendDetailTextView.contentInset = UIEdgeInsetsMake(-8.f, 0.f, 0.0f, 0.f);
    self.sendTextViewHeightConstrain.constant = 120;
    
    switch (self.sendDetailOperateType) {
        case MXRBookSNSSendDetailOperateTypedDefault:
        case MXRBookSNSSendDetailOperateTypeShareToBookSNS:
            self.placeholderLabel.text = MXRLocalizedString(@"BookDetailComment_Say_Something",@"说点什么吧...");
            if (self.shareTextString.length > 0){
                self.sendDetailTextView.text = self.shareTextString;
                [self textViewDidChange:self.sendDetailTextView];
            }
             [self setSendBtnEnableAndGreenColor];
            break;
        case MXRBookSNSSendDetailOperateTypeTransmit:
        {
            // 转发 转发动态
            if (_shareModel.senderType == SenderTypeOfTransmit) {
                self.sendDetailTextView.text = [NSString stringWithFormat:@"//%@:%@",_shareModel.senderName,_shareModel.momentDescription];
                [self textViewDidChange:self.sendDetailTextView];
                self.sendTextViewHeightConstrain.constant = 200;
                self.sendDetailTextView.selectedRange = NSMakeRange(0, 0);
                // 转发 原动态
            }else{
                self.placeholderLabel.text = MXRLocalizedString(@"MXRSNSSendStateViewController_share_get",@"说说分享心得...");
            }
        }
            break;
        case MXRBookSNSSendDetailOperateTypeJoinTopic:
        case MXRBookSNSSendDetailOperateTypeChatJoinTopic:
        {
            
            if (self.topicModel.relevantType == TopicRelevantZone || self.topicModel.relevantType == TopicRelevantBook) {
                self.sendDetailTextView.disableEditNum = self.topicModel.name.length;
                self.sendDetailTextView.disablePasteTopic = YES;
            }
            self.sendDetailTextView.text = self.topicString;
            [self textViewDidChange:self.sendDetailTextView];
        }
            break;
      
        default:
            break;
    }
    [self.sendDetailTextView becomeFirstResponder];
}

-(void)setupImageDisplayCollectionView{
   
    [[MXRBookSNSSendDetailProxy getInstance].selectImageArray addObject:MXRIMAGE(@"btn_bookSNS_addPicture_nor")];
    self.selectImageCollection.delegate   = self;
    self.selectImageCollection.dataSource = self;
    [self.selectImageCollection registerNib:[UINib nibWithNibName:@"MXRHaveDoneSelectImageCell" bundle:nil] forCellWithReuseIdentifier:MXRHaveDoneSelectImageCellID];
    self.selectImageCollection.layer.zPosition = 50;
    self.selectImageCollection.scrollEnabled = NO;
    
    if (self.sendDetailOperateType == MXRBookSNSSendDetailOperateTypeShareToBookSNS) {
        if (self.shareImageInfomationModel){
            [self setUpWithImageModel:self.shareImageInfomationModel];
        }
    }
    
    
}

-(void)setupHuaTiLan{
    
    //键盘消息的手势
    _isHaveGesture = NO;
    if (self.sendDetailOperateType == MXRBookSNSSendDetailOperateTypeJoinTopic) {
        //1,判断有无关联话题或者专区
        if (self.topicModel.relevantType == TopicRelevantBook || self.topicModel.relevantType == TopicRelevantZone) {
            //2,隐藏 “#”
            [self setupCharactersNumLabel];
        }else{
            [self setupCharactersNumLabel];
            [self setupTopicItem];
        }
        
    }else{
        [self setupCharactersNumLabel];
        [self setupTopicItem];
    }
}

/**
 已输入的字符数
 */
-(void)setupCharactersNumLabel{
    
    self.huaTiLan.hidden = NO;
    self.characterCountItem.customView = self.characterCountLabel;
}

/**
 设置话题栏的"#"按钮
 */
-(void)setupTopicItem{
    UIButton *bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [bgBtn addTarget:self action:@selector(huaTiItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 12, 20, 20)];
    [btn addTarget:self action:@selector(huaTiItemClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:MXRIMAGE(@"btn_bookSNS_selectTopic") forState:UIControlStateNormal];
    [btn setImage:MXRIMAGE(@"btn_bookSNS_selectTopic") forState:UIControlStateHighlighted];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.enabled = NO;
    btn.adjustsImageWhenHighlighted = NO;
    btn.adjustsImageWhenDisabled = NO;
    [bgBtn addSubview:btn];
    
    self.huaTiItem.customView = bgBtn;
}

#pragma mark--点击发送事件
-(void)sendSNSDefaultWithTextView:(UITextView*)textView{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    
    MXRBookSNSDynamicBookContentType contentType;
    if (self.topicModel.relevantType == TopicRelevantZone) {
        contentType = MXRBookSNSDynamicBookContentTypeMutableBook;
    }else{
        contentType = MXRBookSNSDynamicBookContentTypeSingleBook;
    }
    
    
    //在本地新建一个发送model ，发动态
    MXRSNSShareModel *shareModel = [[MXRBookSNSSendDetailManager getInstance]getOneSendModelFromLocalText:textView.text imageArray:[MXRBookSNSSendDetailProxy getInstance].imageInfoArray bookInfoShelf:_shareBookInfo userInformation:[UserInformation modelInformation] clientUUid:[MXRDeviceUtil getUUID] senderType:SenderTypeOfDefault bookContentType:contentType subjectModel:self.topicModel.zoneModel QAID:@"0"];
   
    shareModel.momentStatusType = MXRBookSNSMomentStatusTypeOnUpload;
    [[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray insertObject:shareModel atIndex:0];
    [[NSNotificationCenter defaultCenter]postNotificationName:Notification_MXRBookSNS_ReloadData object:nil];
    [[MXRBookSNSSendDetailManager getInstance]sendModelToSevice:shareModel callBack:nil];
    [self resetDataArrayAfterExit];
    // 从私信进入
    if (self.sendDetailOperateType == MXRBookSNSSendDetailOperateTypeChatJoinTopic) {
        NSArray *results = [[MXRBookSNSSendDetailManager getInstance] textStringToRegularExpressionWithTextView:textView];
        if (results.count > 0) {
            __block BOOL isContainTopic = NO;
            [results enumerateObjectsUsingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *topicString = [textView.text substringWithRange:result.range];
                if ([topicString isEqualToString:self.topicString]) {
                    isContainTopic = YES;
                    *stop = YES;
                }
            }];
            
            if (isContainTopic) {
                // 当前话题保持不变
            }else{
                NSTextCheckingResult *result = results.firstObject;
                NSString *topicString = [textView.text substringWithRange:result.range];
                self.topicString = topicString;
            }
            
            MXRTopicMainViewController *topicMainVC = [[MXRTopicMainViewController alloc]initWithMXRTopicModelName:self.topicString fromVC:bookSNSSendDetailViewController];
            topicMainVC.backTitle = MXRLocalizedString(@"Return",@"返回");
            [self.navigationController pushViewController:topicMainVC animated:YES];
        }else{
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }else{
          [self dismissViewControllerAnimated:YES completion:nil];
    }
  
}

-(void)sendSNSTransitWithTextView:(UITextView*)textView{
    //转发
    MXRSNSShareModel * shareModel = [[MXRBookSNSSendDetailManager getInstance]getOneShareModelFromLocal:_shareModel senderType:SenderTypeOfTransmit userName:[UserInformation modelInformation].userNickName userId:[[UserInformation modelInformation].userID integerValue] retransmissionWord:textView.text  clientUUId:[MXRDeviceUtil getUUID] QAID:_shareModel.qaId];
    shareModel.momentStatusType = MXRBookSNSMomentStatusTypeOnUpload;
    [[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray insertObject:shareModel atIndex:0];
    [[NSNotificationCenter defaultCenter]postNotificationName:Notification_MXRBookSNS_ReloadData object:nil];
    [[MXRBookSNSSendDetailManager getInstance]sendModelToSevice:shareModel callBack:nil];
    [self resetDataArrayAfterExit];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//分享
-(void)sendSNSShareWithTextView:(UITextView*)textView{
    MXRSNSShareModel *shareModel = [[MXRBookSNSSendDetailManager getInstance]getOneSendModelFromLocalText:textView.text imageArray:[MXRBookSNSSendDetailProxy getInstance].imageInfoArray bookInfoShelf:_shareBookInfo userInformation:[UserInformation modelInformation] clientUUid:[MXRDeviceUtil getUUID] senderType:SenderTypeOfShare bookContentType:MXRBookSNSDynamicBookContentTypeSingleBook subjectModel:self.topicModel.zoneModel QAID:@"0"];
    shareModel.momentStatusType = MXRBookSNSMomentStatusTypeOnUpload;
    [[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray insertObject:shareModel atIndex:0];
    [[NSNotificationCenter defaultCenter]postNotificationName:Notification_MXRBookSNS_ReloadData object:nil];
    [[MXRBookSNSSendDetailManager getInstance]sendModelToSevice:shareModel callBack:nil];
    [self resetDataArrayAfterExit];
    [self dismissViewControllerAnimated:YES completion:^{
        MXRDataShareAction *shareAction = [[MXRDataShareAction alloc] initWithAccount:USER_ACCOUNT shareType:MXRCollectSharePicture shareChannel:MXRCollectShareChannelMengXiangQuan statu:MXRDataUserActionSuccessStatus];
        [MXRDataAnalyze saveUesrAction:shareAction];
    }];
}
#pragma mark--设置发送按钮
-(void)setSendBtnEnableAndGreenColor{
    
//    [self.sendButton setAttributedTitle:self.greenSendTitle forState:UIControlStateNormal];
    self.sendButton.enabled = YES;
}

-(void)setSendBtnNoEnableAndGrayColor{
    
//    [self.sendButton setAttributedTitle:self.graySendTitlt forState:UIControlStateNormal];
    self.sendButton.enabled = NO;
}

#pragma mark ---将proxy单例中的数据传递给ViewController
-(void)deliverProxyImageAndAlbumInformationToVC:(NSMutableArray *)imageArray{
    self.localFinalImageArray = [imageArray mutableCopy];
    self.localModel = [[MXRSelectLocalImageProxy getInstance].bookSNSAlbumModel mutableCopy];
}



/**
 点击 × 从动态图片数组中删除数据

 @param index
 */
-(void)deleteImageAndModelFromLocalData:(NSInteger)index{

    [self.localBookSNSImageModelArray removeObjectAtIndex:index];
    //选中的图片
    [self.localFinalImageArray removeObjectAtIndex:index];
    
}

#pragma mark-getter
- (UIButton *)returnButton
{
    if (!_returnButton) {
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnButton.frame = CGRectMake(0, 0, 30, 30);
        _returnButton.contentEdgeInsets = UIEdgeInsetsMake(0, -23, 0, 0);
        [_returnButton setImage:[[UIImage imageNamedUseTintColor:@"icon_gray_left_arrow"] imageByTintColor:MXRCOLOR_FFFFFF] forState:UIControlStateNormal];
        [_returnButton setImage:MXRIMAGE(@"icon_gray_left_arrow_pre") forState:UIControlStateHighlighted];
        [_returnButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnButton;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 48, 25)];
        _sendButton.backgroundColor = RGBHEXA(0x000000, 0.6);
        _sendButton.layer.masksToBounds = YES;
        _sendButton.layer.cornerRadius = 12.5;
//        _sendButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_sendButton addTarget:self action:@selector(sendDetailClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendButton setTitleColor:MXRNAVIBARTINTCOLOR forState:UIControlStateNormal];
        _sendButton.titleLabel.font = MXRFONT(12.f);
        [_sendButton setTitle:MXRLocalizedString(@"MXRSNSSendStateViewController_send", @"发布") forState:UIControlStateNormal];
    }
    return _sendButton;
}

- (UILabel *)characterCountLabel
{
    if (!_characterCountLabel) {
        _characterCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
        _characterCountLabel.textColor = RGB(153, 153, 153);
        _characterCountLabel.text = @"140";
        _characterCountLabel.textAlignment = NSTextAlignmentRight;
        [_characterCountLabel setFont:[UIFont systemFontOfSize:16]];
    }
    return _characterCountLabel;
}

-(NSAttributedString *)greenSendTitle{
    if (!_greenSendTitle) {
        _greenSendTitle=[[NSAttributedString alloc]initWithString:MXRLocalizedString(@"MXRSNSSendStateViewController_send",   @"发布")attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:MXRNAVIBARTINTCOLOR}];
    }
    return _greenSendTitle;
}

-(NSAttributedString *)graySendTitlt{
    if (!_graySendTitlt) {
        _graySendTitlt= [[NSAttributedString alloc]initWithString: MXRLocalizedString(@"MXRSNSSendStateViewController_send",   @"发布")attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGBHEX(0x999999)}];
    }
    return _graySendTitlt;
}

-(NSMutableArray<MXRImageInformationModel *> *)localBookSNSImageModelArray{
    if (!_localBookSNSImageModelArray) {
        _localBookSNSImageModelArray=[[NSMutableArray alloc]init];
    }
    return _localBookSNSImageModelArray;
    
}

-(NSMutableArray<UIImage *> *)localFinalImageArray{
    if (!_localFinalImageArray) {
        _localFinalImageArray=[[NSMutableArray alloc]init];
    }
    return _localFinalImageArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
