//
//  MXRBookSNSTableViewCell.m
//  huashida_home
//
//  Created by gxd on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSTableViewCell.h"
#import "Masonry.h"
#import "MXRSNSShareModel.h"
#import "MXRBookSNSUserHandleMomentView.h"
#import "UIImageView+WebCache.h"
#import "GlobalFunction.h"
#import "NSString+Ex.h"
#import "UIImage+Extend.h"
#import "MXRBookSNSUploadImageInfo.h"
#import "MXRBookSNSPraiseModel.h"
#import "MXRBookSNSPraiseListModel.h"
#import "MXRBookSNSMomentImageDetailCollection.h"
#import "MXRBookSNSController.h"
#import "MXRBookSNSDetailViewController.h"
#import "GlobalBusyFlag.h"
//#import "MXRBookStoreNetworkManager.h"
//#import "MXRBookManager.h"
#import "MXRNavigationViewController.h"
#import "MXRSNSSendStateViewController.h"
#import "MXRBookSNSMomentStatusNoUploadManager.h"
#import "TTTAttributedLabel.h"
#import "MXRTopicMainViewController.h"
//#import "MXRLoginVC.h"
#import "MXRBookSNSMomentImageView.h"
//#import "DDYBookDetailViewController.h"
#import "MXRSNSPraiseDetailViewController.h"
//#import "MXRBookStoreSubjectDetailViewController.h"
//#import "MXRQAExerciseViewController.h"
//#import "MXRPKNormalAnswerVC.h"
#import "MXRBookSNSViewController.h"
#import "MXRUserHeaderView.h"
#import "NSString+NSDate.h"

#define lineSpace 5.0f
#define INTERVAL_LENGTH 10
#define ZanImageWidth 26
#define ZanImageSpace 4
#define LableZanFont 12
#define cellId @"cellId"
#define TextFileText @"textFileText"
#define LinkAlpha 0.7f
#define IMAGETAG 100
@interface MXRBookSNSTableViewCell()<TTTAttributedLabelDelegate,MXRBookSNSMomentImageViewDelegate>
// ui
@property (weak, nonatomic) IBOutlet MXRUserHeaderView *userHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIView *statusView;

@property (strong, nonatomic)  TTTAttributedLabel *statusDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *statusDetailView;
@property (weak, nonatomic) IBOutlet UIView *statusImageView;

@property (weak, nonatomic) IBOutlet UIView *statusBookView;
@property (weak, nonatomic) IBOutlet UIImageView *statusBookIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusBookNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusBookStarOneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusBookStarTwoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusBookStarThreeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusBookStarFourImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusBookStarFiveImageView;
// 图书专区
@property (weak, nonatomic) IBOutlet UIView *bookTagView;
@property (weak, nonatomic) IBOutlet UIImageView *bookTagImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTagNameLabel;
// 
@property (weak, nonatomic) IBOutlet UIView *userHandleStatusView;
@property (weak, nonatomic) IBOutlet UIImageView *hotSNSTipsImageView;
@property (strong, nonatomic) UIButton * statusLikeButton;
@property (strong, nonatomic) UIButton * statusCommentButton;
@property (strong, nonatomic) UIButton * statusForwardButton;
@property (weak, nonatomic) IBOutlet UIView *statusCommentView;

@property (weak, nonatomic) IBOutlet UILabel *statusCommentFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusCommentSecondLabel;

// 动态详情ui
@property (strong , nonatomic) UILabel *labZanCount;
@property (strong , nonatomic) UILabel *praiseAnimotionLable;
@property (strong , nonatomic) UIImageView *morePraiseImage;
// constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusDetailLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLabelWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusImageCollectionViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusImageCollectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusCommentViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusCommentViewBottomConstraint;
@property (strong, nonatomic) UILabel *handpickedTagLabel;//精选角标

// 属性
@property (assign , nonatomic) CGSize itemImageSize;
@property (assign, nonatomic) CGFloat itemRightMargin;
@property (assign, nonatomic) CGFloat itemLeftMargin;
@property (strong, nonatomic) NSMutableParagraphStyle *paragraphStyle;
@property (assign, nonatomic) BOOL isPraise;
@property (assign , nonatomic) CGSize textSize;
@end
@implementation MXRBookSNSTableViewCell
#pragma mark - View Life
- (void)awakeFromNib {
    [super awakeFromNib];
//    self.testLabelWidthConstraints.constant = SCREEN_WIDTH_DEVICE;
//    [self layoutIfNeeded];
    [self setup];
    // Initialization code
}
-(void)drawRect:(CGRect)rect{
    if ([self.isSNSDetailView boolValue]) {
        self.statusCommentFirstLabel.text = nil;
        self.statusCommentSecondLabel.text = nil;
        self.moreButton.hidden = YES;
        [self setupMomentDetailUserHandleView];
    }else{
        [self setupUserHandleStatusView];
         self.moreButton.hidden = NO;
        if (self.model.isMyCompany) {
            self.moreButton.hidden = YES;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.headImageView.hidden = NO;
    // Configure the view for the selected state
}
#pragma mark - Private methods
-(void)setup{
    self.userHeaderView.hasVIPLabel = YES;
    [self.moreButton setImage:MXRIMAGE(@"btn_bookSNS_moreHandle") forState:UIControlStateNormal];
    
    self.statusBookIconImageView.layer.masksToBounds = YES;
    self.statusBookIconImageView.layer.borderColor = RGB(243, 243, 243).CGColor;
    self.statusBookIconImageView.layer.borderWidth = 0.8f;
    
    //字体国际化
    _userNameLabel.font = MXRBOLDFONT(momentUserNameTextFont);
    _statusDescriptionLabel.font = MXRFONT(13);
    _statusTimeLabel.font = MXRFONT(12);
    _statusDetailLabel.font = MXRFONT(momentTextFont);
    _statusBookNameLabel.font = MXRFONT(14);
    _bookTagNameLabel.font = MXRFONT(14);
    _statusCommentFirstLabel.font = MXRFONT(momentTextFont);
    _statusCommentSecondLabel.font = MXRFONT(momentTextFont);
    
    self.statusCommentFirstLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal;
    self.statusCommentSecondLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal;
    
    [self setupHandpickedTagLabel];
    
#ifdef MXRSNAPLEARN
    self.statusDescriptionLabel.hidden = YES;
#endif
}
-(void)setupUserHandleStatusView{
    
    [[self.userHandleStatusView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.statusLikeButton removeFromSuperview];
    [self.statusCommentButton removeFromSuperview];
    [self.statusForwardButton removeFromSuperview];
    
//    CGFloat buttonWidth = MomentUserHanldBtnWidth;
//    CGFloat momentUserHanldBtnMargin = (CGRectGetWidth(self.userHandleStatusView.frame) - buttonWidth*3)/2;
    
    CGFloat momentUserHanldBtnMargin = 10;
    CGFloat buttonWidth = (CGRectGetWidth(self.userHandleStatusView.frame) - 2 * momentUserHanldBtnMargin) / 3.0;
    CGFloat buttonHeight = self.userHandleStatusView.frame.size.height;
    
    self.statusLikeButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    self.statusCommentButton.frame = CGRectMake(momentUserHanldBtnMargin + buttonWidth , 0, buttonWidth, buttonHeight);
    self.statusForwardButton.frame = CGRectMake(momentUserHanldBtnMargin * 2 + 2 * buttonWidth , 0, buttonWidth, buttonHeight);
    [self.userHandleStatusView addSubview:self.statusLikeButton];
    [self.userHandleStatusView addSubview:self.statusCommentButton];
    [self.userHandleStatusView addSubview:self.statusForwardButton];
}

-(void)setupDefaultView{
    [self setupUserInfo];
    [self setupMomentDetail];
    [self setupMomentImages];
    [self setupBookInfo];
    [self setupMomentComment];
    if ([self.isSNSDetailView boolValue]) {
        [self setupMomentDetailUserHandleView];
    }else{
        [self setupUserHandleView];
    }
}

- (void)setupHandpickedTagLabel {
    //避免重复添加
//    if (_handpickedTagLabel && _handpickedTagLabel.superview) {
//        [_handpickedTagLabel removeFromSuperview];
//    }
    
    _handpickedTagLabel = [[UILabel alloc] init];
    [_headImageView setClipsToBounds:YES];
    [_headImageView addSubview:_handpickedTagLabel];
    
    @MXRWeakObj(self)
    [_handpickedTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selfWeak.headImageView);
        make.bottom.equalTo(selfWeak.headImageView);
        make.width.equalTo(selfWeak.headImageView.mas_width);
        make.height.equalTo(selfWeak.headImageView.mas_height).multipliedBy(1/3.0);
    }];
    
    _handpickedTagLabel.text = MXRLocalizedString(@"MXRHandpicked", @"精选");
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:ceilf(MXRFONTSIZE(9))];
    if (!font) {
        font = MXRFONT(9);
    }
#ifdef MXRSNAPLEARN
    _handpickedTagLabel.font = MXRFONT(10);
#else
    _handpickedTagLabel.font = font;
#endif
    _handpickedTagLabel.textColor = [UIColor whiteColor];
    _handpickedTagLabel.textAlignment = NSTextAlignmentCenter;
    _handpickedTagLabel.layer.backgroundColor = RGBHEX(0xFF392F).CGColor;
}

-(void)setupUserInfo{
    self.hotSNSTipsImageView.hidden = YES;
    switch (_model.dynamicType) {
        case MXRBookSNSDefaultDynamicType:
//            self.hotSNSTipsImageView.hidden = YES;
            _handpickedTagLabel.hidden = YES;
            break;
        case MXRBookSNSRecommendDynamicType:
//            self.hotSNSTipsImageView.hidden = NO;
            _handpickedTagLabel.hidden = NO;
            break;
        default:
//            self.hotSNSTipsImageView.hidden = NO;
            _handpickedTagLabel.hidden = YES;
            break;
    }
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.height/2;
    BOOL isThatUserVIP = _model.vipFlag;
    if ([_model.senderId isEqual:MAIN_USERID]) {
        isThatUserVIP = [UserInformation modelInformation].vipFlag;
    }
    self.userHeaderView.vip = isThatUserVIP;
    
    if (![[UserInformation modelInformation] getIsLogin]) {
        self.userHeaderView.headerUrl = _model.senderHeadUrl;
    }else{
        if ([_model.senderId isEqualToString:[UserInformation modelInformation].userID]) {
            if ([[UserInformation modelInformation].userImage isKindOfClass:[NSString class]]) {
                self.userHeaderView.headerUrl = [UserInformation modelInformation].userImage;
            }else if([[UserInformation modelInformation].userImage isKindOfClass:[UIImage class]]){
                self.userHeaderView.placeHolderheaderImage = (UIImage *)[UserInformation modelInformation].userImage;
            }else {
                self.userHeaderView.placeHolderheaderImage = MXRIMAGE(@"icon_common_default_head");
            }
        }else{
            self.userHeaderView.headerUrl = _model.senderHeadUrl;
        }
    }
    self.userNameLabel.text = _model.senderName;
    
//    [self.userNameLabel sizeToFit];
//    CGFloat userNameLabelwidth = self.userNameLabel.frame.size.width;
//    
//    if (userNameLabelwidth > (SCREEN_WIDTH_DEVICE - 160)) {
//        userNameLabelwidth = SCREEN_WIDTH_DEVICE - 160;
//    }
//    self.userNameLabelWidthConstraint.constant = userNameLabelwidth ;
    self.statusTimeLabel.text = [NSString convertTimeWithDateStr:[_model.senderTime stringValue]];
    if (_model.senderType == SenderTypeOfDefault) {
        self.statusDescriptionLabel.text = MXRLocalizedString(@"MXRBookSNSViewControllerSenderTypeDefault", @"分享图书");
    }else if(_model.senderType == SenderTypeOfTransmit){
        self.statusDescriptionLabel.text =   MXRLocalizedString(@"MXRBookSNSViewControllerSenderTypeTransmit",@"转发");
    }
}
-(void)setupMomentDetail{
    
    self.statusDetailLabel.text = [[NSMutableAttributedString alloc] initWithString:_model.momentDescription attributes:@{NSFontAttributeName:MXRFONT(momentTextFont),NSParagraphStyleAttributeName:self.paragraphStyle,NSForegroundColorAttributeName:RGB(51, 51, 51)}];
    [self checkQuestion:self.statusDetailLabel];
    [self checkTopic:self.statusDetailLabel];
    
//    CGFloat detailTextLabelHeight = [NSString caculateText:_model.momentDescription andTextLabelSize:CGSizeMake(SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal, 0) andFont:MXRFONT(momentTextFont) andParagraphStyle:self.paragraphStyle].height;
    CGFloat detailTextLabelHeight = [NSString getHeightOfString:_model.momentDescription andFont:MXRFONT(momentTextFont) andWidth:SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal andLineSpace:self.paragraphStyle.lineSpacing];
    _statusDetailLabelHeightConstraint.constant = detailTextLabelHeight;
    
//    NSInteger doubleLineBreakCount = 0;//连续两次换行
//    if ([_model.momentDescription containsString:@"\n\n"]) {
//        doubleLineBreakCount = [_model.momentDescription componentsSeparatedByString:@"\n\n"].count - 1;
//    } else if ([_model.momentDescription containsString:@"\r\n\r\n"]) {
//        doubleLineBreakCount = [_model.momentDescription componentsSeparatedByString:@"\r\n\r\n"].count - 1;
//    } else if ([_model.momentDescription containsString:@"\r\n\n"]) {
//        doubleLineBreakCount = [_model.momentDescription componentsSeparatedByString:@"\r\n\n"].count - 1;
//    } else if ([_model.momentDescription containsString:@"\n\r\n"]) {
//        doubleLineBreakCount = [_model.momentDescription componentsSeparatedByString:@"\n\r\n"].count - 1;
//    }
//    self.statusDetailLabelHeightConstraint.constant = detailTextLabelHeight + textLabelHeigthMarginNormal + doubleLineBreakCount * [MXRFONT(momentTextFont) pointSize];
    
//    if ([_model.qaId integerValue] > 0) {
//        self.statusDetailLabelHeightConstraint.constant = detailTextLabelHeight + textLabelHeigthMarginNormal + 30;
//    } else {
//        self.statusDetailLabelHeightConstraint.constant = detailTextLabelHeight + textLabelHeigthMarginNormal + 10;
//    }
}

-(void)setupMomentImages{

     [[self.statusImageView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_model.imageArray.count > 0) {
        self.statusImageCollectionViewTopConstraint.constant = 8;
        if (_model.imageArray.count == 1) {
            [self setSingleImage:[_model.imageArray lastObject]];
        }else if (_model.imageArray.count > 1){
            CGFloat itemWidth = (SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal - 2 * itemMargin)/3 ;
            self.itemImageSize = CGSizeMake(itemWidth, itemWidth);
        }
        
        self.statusImageCollectionViewHeightConstraint.constant = _model.cellImageheight;
        
        MXRBookSNSMomentImageView * imagesView = [[MXRBookSNSMomentImageView alloc] initWithimagesArray:_model.imageArray andFrame:self.statusImageView.bounds andItemSize:self.itemImageSize];
        imagesView.delegate = self;
        
        [self.statusImageView addSubview:imagesView];
        [imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_statusImageView.mas_right).offset(0);
            make.top.equalTo(_statusImageView.mas_top).offset(0);
            make.bottom.equalTo(_statusImageView.mas_bottom).offset(0);
            make.left.equalTo(_statusImageView.mas_left).offset(0);
        }];
        [imagesView reloadData];
    }else{
        self.statusImageCollectionViewHeightConstraint.constant = 0;
        self.statusImageCollectionViewTopConstraint.constant = 0;
    }
}
-(void)setSingleImage:(MXRBookSNSUploadImageInfo *)imageInfo{
    
    self.itemRightMargin = 0;
    if (imageInfo.shapeType == MXRBooKSNSSendDetailImageTypeHorizontal) {
        self.itemImageSize = CGSizeMake(SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal, singleImageHorizontalHeight);
    }else if (imageInfo.shapeType == MXRBooKSNSSendDetailImageTypeVertical){
        self.itemRightMargin = SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal - SCREEN_WIDTH_DEVICE/2;
        self.itemImageSize = CGSizeMake(SCREEN_WIDTH_DEVICE/2, singleImageVerticalHeight);
    }else{
        self.itemImageSize = CGSizeMake(SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal, singleImageVerticalHeight);
    }
}
-(void)setupBookInfo{
    
    @MXRWeakObj(self);
    if (_model.bookContentType == MXRBookSNSDynamicBookContentTypeSingleBook) {
        self.bookTagView.hidden = YES;
        self.statusBookNameLabel.hidden = NO;
        self.statusBookIconImageView.hidden = NO;
        self.statusBookNameLabel.text = _model.bookName;
        self.statusBookIconImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        /*V5.6.1 图书封面拼接时间戳，实时更新*/
        //BookInfoForShelf: bookIconUrlWithData
        /*
          http://books.mxrcorp.cn/605BB9214EF84C3C8E61E415C1818759/UserPicture/bookIcon.png?t=20170930103237
          http://books.mxrcorp.cn/5315FDE09E8449EDB293F54110A6DBB7/UserPicture/bookIcon.png
          http://books.mxrcorp.cn/5315FDE09E8449EDB293F54110A6DBB7/UserPicture/bookIcon.png?t=20170930103237
        */
        //Old:[NSURL URLWithString:_model.bookIconUrl]
        NSString *imgDateStr = [NSString stringWithFormat:@"%@?%@", _model.bookIconUrl, [NSString stringWithFormat:@"t=%f", [NSDate timeIntervalSinceReferenceDate]]];
        NSURL *imgDateUrl = [NSURL URLWithString:imgDateStr];
        /*V5.6.1 图书封面拼接时间戳，实时更新*/
    
        [self.statusBookIconImageView sd_setImageWithURL:imgDateUrl placeholderImage:MXRIMAGE(@"img_bookSNS_defaultBookIcon") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                UIImage * lastImage = [image clipImageInRect:CGRectMake(0, 0, image.size.width, image.size.width)];
                selfWeak.statusBookIconImageView.image = lastImage;
            }
        }];
        [UIImage setBookStarGrade:_model.bookStars andStarImageViewArray:[NSArray arrayWithObjects:self.statusBookStarOneImageView,self.statusBookStarTwoImageView,self.statusBookStarThreeImageView,self.statusBookStarFourImageView,self.statusBookStarFiveImageView, nil]];
    }else if (_model.bookContentType == MXRBookSNSDynamicBookContentTypeMutableBook){
        self.bookTagView.hidden = NO;
        self.statusBookNameLabel.hidden = YES;
        self.statusBookIconImageView.hidden = YES;
        self.bookTagNameLabel.text = _model.contentZoneName;
        [self.bookTagImageView sd_setImageWithURL:[NSURL URLWithString:_model.contentZoneCover] placeholderImage:MXRIMAGE(@"img_bookSNS_defaultBookIcon") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
    
}

/**
 设置动态评论 (可能有0，1，2 条)
 */
- (void)setupMomentComment{

    if ([self.isSNSDetailView boolValue]) {
//        self.statusCommentViewTopConstraint.constant = -1000;
        _statusCommentViewTopConstraint.constant = 0;
        _statusCommentViewBottomConstraint.constant = 0;
        self.statusCommentView.hidden = YES;
        self.statusCommentFirstLabel.text = nil;
        self.statusCommentSecondLabel.text = nil;
        return;
    }
    if (_model.commentList.count == 0) {
//        self.statusCommentViewTopConstraint.constant = -1000;
        _statusCommentViewTopConstraint.constant = 0;
        _statusCommentViewBottomConstraint.constant = 0;
        self.statusCommentView.hidden = YES;
        self.statusCommentFirstLabel.text = nil;
        self.statusCommentSecondLabel.text = nil;
    }else if(_model.commentList.count > 0){
//        self.statusCommentViewTopConstraint.constant = 8;
        _statusCommentViewTopConstraint.constant = 10;
        _statusCommentViewBottomConstraint.constant = 10;
        self.statusCommentView.hidden = NO;
        [self setMomentCommentDetail];
    }
}

- (void)setMomentCommentDetail{

    if (_model.commentList.count == 1) {
        MXRSNSCommentModel * firstModel = [_model.commentList firstObject];
        [self setMomentComment:firstModel showView:self.statusCommentFirstLabel];
        self.statusCommentSecondLabel.text = nil;
    }else{
        MXRSNSCommentModel * firstModel = [_model.commentList firstObject];
        [self setMomentComment:firstModel showView:self.statusCommentFirstLabel];
        MXRSNSCommentModel * secondModel = [_model.commentList lastObject];
        [self setMomentComment:secondModel showView:self.statusCommentSecondLabel];
    }
}

- (void)setMomentComment:(MXRSNSCommentModel *)commentModel showView:(UILabel *)showLabel{

    NSString * userStr = commentModel.userName;
    NSString * userReplyStr = [NSString stringWithFormat:@"%@%@",userStr,MXRLocalizedString(@"MXRMessageReplyViewControllerMyReplyStr", @"回复")];
    if (commentModel.srcContent.length > 0 && commentModel.srcUserName.length > 0) {
        NSString * userReplyOtherStr;
        userReplyOtherStr = [NSString stringWithFormat:@"%@%@",userReplyStr,commentModel.srcUserName];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ : %@",userReplyOtherStr,commentModel.content]];
        //V5.9.1
        if (commentModel.sort == 0 || commentModel.sort == -1) {
            [str addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_2FB8E2 range:NSMakeRange(0, userStr.length)];
            [str addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_2FB8E2 range:NSMakeRange(userReplyStr.length, commentModel.srcUserName.length)];
        } else {
            [str addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_FF3B30 range:NSMakeRange(0, userStr.length)];
            [str addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_2FB8E2 range:NSMakeRange(userReplyStr.length, commentModel.srcUserName.length)];
            [str addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_FF3B30 range:NSMakeRange(str.length - commentModel.content.length, commentModel.content.length)];
        }
        showLabel.attributedText = str;
    }else{
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ : %@",userStr,commentModel.content]];
        //V5.9.1
        if (commentModel.sort == 0 || commentModel.sort == -1) {
            [str addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_2FB8E2 range:NSMakeRange(0, userStr.length)];
        } else {
            [str addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_FF3B30 range:NSMakeRange(0, userStr.length)];
            [str addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_FF3B30 range:NSMakeRange(str.length - commentModel.content.length, commentModel.content.length)];
        }
        showLabel.attributedText = str;
    }
}

-(void)setupUserHandleView{
    
    NSString * likeText;
    if(_model.likeCount > 0){
        likeText = [NSString stringWithFormat:@"%ld",(long)_model.likeCount];
    }else{
//        likeText = MXRLocalizedString(@"MXRBookSNSViewControllerUserLike",@"点赞");
        likeText = @"";
    }
    NSString * commentText;
    if (_model.commentCount > 0) {
        commentText = [NSString stringWithFormat:@"%ld",(long)_model.commentCount];
    }else{
//        commentText = MXRLocalizedString(@"MXRBookSNSViewControllerUserComment",@"评论");
        commentText = @"";
    }
    NSString * tranText;
    if (_model.trammitCount > 0) {
        tranText = [NSString stringWithFormat:@"%ld",(long)_model.trammitCount];
    }else{
//        tranText = MXRLocalizedString(@"MXRBookSNSViewControllerSenderTypeTransmit",@"转发");
        tranText = @"";
    }
    [self.statusLikeButton setTitle:likeText forState:UIControlStateNormal];
    [self.statusLikeButton setTitle:likeText forState:UIControlStateHighlighted];
    [self.statusCommentButton setTitle:commentText forState:UIControlStateNormal];
    [self.statusCommentButton setTitle:commentText forState:UIControlStateHighlighted];
    [self.statusForwardButton setTitle:tranText forState:UIControlStateNormal];
    [self.statusForwardButton setTitle:tranText forState:UIControlStateHighlighted];
    
    if ([[UserInformation modelInformation] getIsLogin]) {
        self.statusLikeButton.selected = _model.hasPraised;
    }else{
        self.statusLikeButton.selected = NO;
    }
    if (_model.momentStatusType == MXRBookSNSMomentStatusTypeOnLocal || _model.momentStatusType == MXRBookSNSMomentStatusTypeOnUpload) {
        [self setBtnEnableAlpha:NO];
        self.statusLikeButton.selected = NO;
    }else{
        [self setBtnEnableAlpha:YES];
    }
}

-(void)removeUserHandleStatusViewSubviews {
    [self.morePraiseImage removeFromSuperview];
    [self.labZanCount removeFromSuperview];
    _labZanCount = nil;
    for (UIView *view in self.userHandleStatusView.subviews) {
        if (view.tag == IMAGETAG) {
            [view removeFromSuperview];
        }
    }
}

-(void)setupMomentDetailUserHandleView{
    
    [self removeUserHandleStatusViewSubviews];
    [self addPraiseAnimotionLable];
    [self addMorePraiseImageToUserHandleView];
    [self.userHandleStatusView addSubview:self.labZanCount];

    if ([self.model dynamiclikeCount] >= 0) {
        self.labZanCount.text = [NSString stringWithFormat:@"%ld%@",(long)[self.model dynamiclikeCount],MXRLocalizedString(@"Praise", @"赞")];
    }
    NSDictionary *attributes = @{NSFontAttributeName:MXRFONT(12)};
    self.textSize = [_labZanCount.text boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    @MXRWeakObj(self);
    [_labZanCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selfWeak.userHandleStatusView.mas_left).offset(0);
        make.top.equalTo(selfWeak.userHandleStatusView.mas_top).offset(8);
        make.width.mas_equalTo(selfWeak.textSize.width+1);
        make.height.mas_equalTo(@20);
    }];
    
//    MXRBookSNSPraiseModel *model = [MXRBookSNSPraiseListProxy getInstance].arrayData.lastObject;
    [self loadPraiseListViewWithArray:self.praiseModel.list];

}
#define SpaceDistance 10
-(void)loadPraiseListViewWithArray:(NSArray *)array{
    
    for (int i = 0; i<array.count; i++ ){
        MXRUserHeaderView *imageZan = [[MXRUserHeaderView alloc] init];
        imageZan.frame = CGRectMake((ZanImageWidth+ZanImageSpace)*i+(self.textSize.width+SpaceDistance) , 4, ZanImageWidth, ZanImageWidth);
        MXRBookSNSPraiseListModel *listModel = array[i];
        if ([MAIN_USERID isEqualToString:[NSString stringWithFormat:@"%ld",listModel.userId]]) {
//            [imageZan sd_setImageWithURL:[NSURL URLWithString:CURRENT_USERICON_URL] placeholderImage:MXR_USER_ICON_PLACEHOLDER_IMAGE];
            imageZan.headerUrl = CURRENT_USERICON_URL;
            imageZan.vip = [UserInformation modelInformation].vipFlag;
        }else {
//            [imageZan sd_setImageWithURL:[NSURL URLWithString:listModel.userLogo] placeholderImage:MXR_USER_ICON_PLACEHOLDER_IMAGE];
            imageZan.headerUrl = autoString(listModel.userLogo);
            imageZan.vip = listModel.vipFlag;
        }
        
//        imageZan.layer.cornerRadius = imageZan.frame.size.width/2;
//        imageZan.clipsToBounds = YES;
//        imageZan.layer.borderColor = RGB(0xE0, 0xE0, 0xE0).CGColor;
//        imageZan.layer.borderWidth = SINGLE_LINE_HEIGHT;
        
        imageZan.tag = IMAGETAG;
        if (imageZan.frame.origin.x>self.userHandleStatusView.frame.size.width-self.textSize.width-SpaceDistance)
        {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToPraiseDetailVC)];
            [self.userHandleStatusView addGestureRecognizer:tapGesture];
            self.morePraiseImage.hidden =NO;
            return;
        }
        [self.userHandleStatusView addSubview:imageZan];
    }
}

//跳转点赞列表页
-(void)goToPraiseDetailVC {
    MXRSNSPraiseDetailViewController
    *prsiseDetailVC = [[MXRSNSPraiseDetailViewController alloc] initWithMXRSNSShareModel:self.model];
//    [APP_DELEGATE.navigationController pushViewController:prsiseDetailVC animated:YES];
}

-(void)gotoBookDetail:(NSString *)bookGuid{
//    [MXRBookManager defaultManager].downloadSourceType = MXRBookSNSToBookDetailDownloadType;
////    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_GotoBookDetailBefore object:nil];
//    
//    /// 5.2.2 modify by Martin.liu
//    DDYBookDetailViewController *bookDetailViewCon = [[DDYBookDetailViewController alloc] init];
//    bookDetailViewCon.bookGuid = bookGuid;
//    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [del.navigationController pushViewController:bookDetailViewCon animated:YES];
    
}
- (void)checkQuestion:(TTTAttributedLabel *)label {
    if ([_model.qaId integerValue] <= 0) {
        return;
    }
    
    NSString *text = label.text;
    if (text == nil) {
        text = @"";
    }
    text = [text stringByAppendingString:@"\n"];//换行
    NSString *suffixText = MXRLocalizedString(@"MXRQAExerciseVC_ClickToJoin", @"点击此处直接参与");
    NSString *composeText = [text stringByAppendingString:suffixText];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:suffixText options:0 error:nil];
    NSArray *results = [regex matchesInString:composeText options:0 range:NSMakeRange(0,composeText.length)];
    label.text = [[NSMutableAttributedString alloc] initWithString:composeText attributes:@{NSFontAttributeName:MXRFONT(momentTextFont),NSParagraphStyleAttributeName:self.paragraphStyle,NSForegroundColorAttributeName:MXRCOLOR_333333}];
    if (results.count > 0) {
        NSTextCheckingResult *lastResult = results.lastObject;
        
        NSDictionary *linkAttrs= @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2,NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:MXRFONT(momentTextFont)};
        NSDictionary *activeLinkAttrs= @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2_A(LinkAlpha),NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:MXRFONT(momentTextFont)};
        NSDictionary * inactiveLinkAtts = @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2,NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:MXRFONT(momentTextFont)};
        label.linkAttributes = linkAttrs;
        label.activeLinkAttributes = activeLinkAttrs;
        label.inactiveLinkAttributes = inactiveLinkAtts;
        
        [label addLinkWithTextCheckingResult:lastResult];
        
//        [label addLinkWithTextCheckingResult:lastResult attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:momentTextFont],NSParagraphStyleAttributeName:self.paragraphStyle,NSForegroundColorAttributeName:MXRCOLOR_2FB8E2}];
    }
}
-(void)checkTopic:(TTTAttributedLabel *)view{
    
    if (!view.text) {
        return;
    }
    NSString * text = view.text;
//    NSString *topicPattern = @"#([^\\#|.]+)#";
    NSString *topicPattern = @"#([^\\#]+)#";
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:topicPattern options:0 error:&error];
    if (error) {
        DLOG(@"%@", error.localizedDescription);
    }
    NSArray *results = [regex matchesInString:view.text options:0 range:NSMakeRange(0, text.length)];
    if (results.count>0) {
//        view.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        for (NSTextCheckingResult *result in results) {
            NSString * temp = [text substringWithRange:result.range];
            if ([_model.topicNameArray containsObject:temp]) {
                
                NSDictionary *linkAttrs= @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2,NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:MXRFONT(momentTextFont)};
                NSDictionary *activeLinkAttrs= @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2_A(LinkAlpha),NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:MXRFONT(momentTextFont)};
                NSDictionary * inactiveLinkAtts = @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2,NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:MXRFONT(momentTextFont)};
                view.linkAttributes = linkAttrs;
                view.activeLinkAttributes = activeLinkAttrs;
                view.inactiveLinkAttributes = inactiveLinkAtts;
                
               [view addLinkWithTextCheckingResult:result];
            }
        }
    }else{
        view.textColor=RGB(51, 51, 51);
    }
}
-(void)setBtnEnableAlpha:(BOOL )show{
    
    if (show) {
        self.statusLikeButton.alpha = 1.0f;
        [self.statusLikeButton setAdjustsImageWhenHighlighted:YES];
        self.statusCommentButton.alpha = 1.0f;
        [self.statusCommentButton setAdjustsImageWhenHighlighted:YES];
        self.statusForwardButton.alpha = 1.0f;
        [self.statusForwardButton setAdjustsImageWhenHighlighted:YES];
    }else{
        self.statusLikeButton.alpha = MomentBtnEnableAlpha;
        [self.statusLikeButton setAdjustsImageWhenHighlighted:NO];
        self.statusCommentButton.alpha = MomentBtnEnableAlpha;
        [self.statusCommentButton setAdjustsImageWhenHighlighted:NO];
        self.statusForwardButton.alpha = MomentBtnEnableAlpha;
        [self.statusForwardButton setAdjustsImageWhenHighlighted:NO];
    }
}
#pragma mark - 点赞+1动画处理
-(void)showAddCountAnimationWithView:(UIView *)view{
    
    UILabel * animationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width , view.frame.size.height)];
    animationLabel.text = @"+1";
    animationLabel.font = [UIFont systemFontOfSize:INTERVAL_LENGTH];
    [view addSubview:animationLabel];
    animationLabel.textColor = MXRCOLOR_2FB8E2;
    [view bringSubviewToFront:animationLabel];
    [UIView animateWithDuration:1.0f animations:^
     {
         animationLabel.alpha = 0;
         animationLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
     } completion:^(BOOL finished)
     {
         [animationLabel removeFromSuperview];
     }];
}
#pragma mark - Actions

- (IBAction)moreBntClick:(UIButton *)sender {
    [MXRClickUtil event:@"MengXiangQuanClick"];
    if (![[UserInformation modelInformation] checkIsLogin]) {
        return;
    }
    BOOL notMyMoment = YES ;
    if ([_model.senderId isEqualToString:[UserInformation modelInformation].userID]) {
        notMyMoment = NO;
    }
    [[MXRBookSNSUserHandleMomentView getInstance]  showWithIsXiaomengMoment:notMyMoment momentID:self.model.momentId andUnFocusUserId:self.model.senderId andMomentBelongViewtype:self.belongViewtype];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_ScrollTopNoEnable object:nil];
}
- (IBAction)bookViewClick:(UIButton *)sender {
    [MXRClickUtil event:@"MengXiangQuanClick"];
    [MXRClickUtil event:@"DreamCircle_Book_click"];
    if (self.model.bookContentType == MXRBookSNSDynamicBookContentTypeSingleBook) {
       [self gotoBookDetail:_model.bookGuid];
    }else{
//        MXRBookStoreSubjectDetailViewController * vc = [[MXRBookStoreSubjectDetailViewController alloc] initWithRecommendId:[self.model.contentZoneId integerValue]];
//        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [del.navigationController pushViewController:vc animated:YES];
    }
}

-(void)statusLikeButtonClcik:(UIButton *)sender{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    [MXRClickUtil event:@"DreamCircle_Like_Click"];
    if (_model.momentStatusType == MXRBookSNSMomentStatusTypeOnLocal || _model.momentStatusType == MXRBookSNSMomentStatusTypeOnUpload) {
        return;
    }
    if (![[UserInformation modelInformation] checkIsLogin]) {
        return;
    }
    @MXRWeakObj(self);
    sender.enabled = NO;
    self.userInteractionEnabled = NO;
    [self.model likeBtnClick];
    self.statusLikeButton.selected = _model.hasPraised;
    if (self.model.hasPraised) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(self.statusLikeButton.center.x - 5, self.statusLikeButton.center.y - StatusLikeButtonAddOneAnimationYMargin, 13, 13)];
        [self.userHandleStatusView addSubview:view];
        if ([self.isSNSDetailView boolValue]) {
            [self showAddCountAnimationWithView:_praiseAnimotionLable];
        }else{
            [self showAddCountAnimationWithView:view];
        }
    }
    if (_model.hasPraised) {

        // 点赞
        [[MXRBookSNSController getInstance] userLikeMomentWithMomentId:self.model.momentId andHandleUserId:[UserInformation modelInformation].userID success:^(id result) {
            if ([(NSNumber *)result boolValue]) {
                sender.enabled = YES;
                selfWeak.userInteractionEnabled = YES;
            }
        } failure:^(MXRServerStatus status, id result) {
            if (status == MXRServerStatusNetworkError || status == MXRServerStatusFail) {
                sender.enabled = YES;
                selfWeak.userInteractionEnabled = YES;
                [[MXRBookSNSMomentStatusNoUploadManager getInstance] addLikeAndUnlikeAndDeleteAndUploadMomentDetailNoUploadModelWithUserHandleNoUploadStatusType:MXRBookSNSUserHandleNoUploadStatusTypeLikeBookSNSStatus andBookSNSMomentId:selfWeak.model.momentId andHandleUserId:[UserInformation modelInformation].userID];
            }
        }];
        
        self.isPraise = YES;
    }else{
        // 取消赞
        
        [[MXRBookSNSController getInstance] userCancleLikeMomentWithMomentId:self.model.momentId andHandleUserId:[UserInformation modelInformation].userID success:^(id result) {
            if ([(NSNumber *)result boolValue]) {
                sender.enabled = YES;
                selfWeak.userInteractionEnabled = YES;
            }
        } failure:^(MXRServerStatus status, id result) {
            
            if (status == MXRServerStatusNetworkError || status == MXRServerStatusFail) {
                sender.enabled = YES;
                selfWeak.userInteractionEnabled = YES;
                
                [[MXRBookSNSMomentStatusNoUploadManager getInstance] addLikeAndUnlikeAndDeleteAndUploadMomentDetailNoUploadModelWithUserHandleNoUploadStatusType:MXRBookSNSUserHandleNoUploadStatusTypeCancleLikeBookSNSStatus andBookSNSMomentId:selfWeak.model.momentId andHandleUserId:[UserInformation modelInformation].userID];
            }
        }];
        self.isPraise = NO;
    }
    
    if ([self.isSNSDetailView boolValue]) {
        [self setupMomentDetailUserHandleView];
    }else{
        [self setupUserHandleView];
    }
}


-(void)statusCommentButtonClcik:(UIButton *)sender{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    [MXRClickUtil event:@"DreamCircle_Comment_Click"];
    if (_model.momentStatusType == MXRBookSNSMomentStatusTypeOnLocal || _model.momentStatusType == MXRBookSNSMomentStatusTypeOnUpload) {
        return;
    }
    if (![[UserInformation modelInformation] checkIsLogin]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MXRBookSNSDetailViewController * vc = [[MXRBookSNSDetailViewController alloc] initWithModel:self.model];
//        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [del.navigationController pushViewController:vc animated:YES];
    });
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentSNSFromCell:)]) {
        [self.delegate commentSNSFromCell:self.model];
    }
}
-(void)statusForwardButtonClcik:(UIButton *)sender{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    [MXRClickUtil event:@"DreamCircle_Forwarding_Click"];
    if (_model.momentStatusType == MXRBookSNSMomentStatusTypeOnLocal || _model.momentStatusType == MXRBookSNSMomentStatusTypeOnUpload) {
        return;
    }
    if (![[UserInformation modelInformation] checkIsLogin]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        MXRSNSSendStateViewController *vc = [[MXRSNSSendStateViewController alloc] initWithModel:self.model];
        MXRNavigationViewController *nav=[[MXRNavigationViewController alloc]initWithRootViewController:vc];
//        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [del.navigationController presentViewController:nav animated:YES completion:nil];
    });
}

#pragma mark - MXRBookSNSMomentImageViewDelegate
-(void)btnImageViewClick:(NSInteger)index andSelf:(UIView *)sender{
    [MXRClickUtil event:@"MengXiangQuanClick"];
    if (_model.imageArray.count == 0) {
        return;
    }
    if (_imageClick) {
        _imageClick(NO);
    }
    MXRBookSNSMomentImageDetailCollection * imagesView = [[MXRBookSNSMomentImageDetailCollection alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE) anditem:sender andSelectIndex:index andImageInfos:_model.imageArray];
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC;
    if (appRootVC.presentedViewController) {
        topVC = appRootVC.presentedViewController;
    }else{
//        AppDelegate* app =  (AppDelegate*)[UIApplication sharedApplication].delegate;
//        topVC = app.navigationController;
    }
    [topVC.view addSubview:imagesView];
    [imagesView beganAnimation];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_ScrollTopNoEnable object:nil];
    
}

-(void)registerForImagePreviewingWithDelegate:(id<UIViewControllerPreviewingDelegate>)delegate sourceView:(UIView *)sourceView {
    if (self.delegate && [self.delegate isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)self.delegate;
        [vc registerForPreviewingWithDelegate:delegate sourceView:sourceView];
    } else {
        DLOG(@"RegisterForPreviewingError:Delegate should be UIViewController!");
    }
}

- (BOOL)checkPraiseStatus {
    return self.model.hasPraised;
}

- (void)praiseSNS {
    if (self.delegate && [self.delegate isKindOfClass:[MXRBookSNSDetailViewController class]]) {
        if ([self.delegate respondsToSelector:@selector(praiseSNSFromPreview)]) {
            [self.delegate praiseSNSFromPreview];
        } else {
            [self statusLikeButtonClcik:self.statusLikeButton];
        }
    } else {
        [self statusLikeButtonClcik:self.statusLikeButton];
    }
}

- (void)commentSNS {
    if (self.delegate && [self.delegate isKindOfClass:[MXRBookSNSDetailViewController class]]) {
        if ([self.delegate respondsToSelector:@selector(commentSNSFromPreview)]) {
            [self.delegate commentSNSFromPreview];
        } else {
            [self statusCommentButtonClcik:self.statusCommentButton];
        }
    } else {
        [self statusCommentButtonClcik:self.statusCommentButton];
    }
}

- (void)promoteSNS {
    [self statusForwardButtonClcik:self.statusForwardButton];
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TextFileText];
    NSAttributedString * mutableStr = [label.attributedText attributedSubstringFromRange:result.range];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_model.qaId integerValue] > 0 && [mutableStr.string isEqualToString:MXRLocalizedString(@"MXRQAExerciseVC_ClickToJoin", @"点击此处直接参与")]) {
            DLOG(@"qaid:%ld", [_model.qaId integerValue]);
//            if (![[UserInformation modelInformation] getIsLogin]) {
//                MXRLoginVC *vc = [[MXRLoginVC alloc] init];
//                @weakify(self)
//                NSInteger qaId = [_model.qaId integerValue];
//                vc.loginResultBlock = ^(MXRLoginVCResult result) {
//                    @strongify(self)
//                    if (!strong_self) return;
//                    if (result & MXRLoginVCResultSuccess) {
//                        MXRPKNormalAnswerVC *vc = [[MXRPKNormalAnswerVC alloc] init];
//                        vc.qaId = autoString(@(qaId));
//                        MXRNavigationViewController *navi = [[MXRNavigationViewController alloc] initWithRootViewController:vc];
//                        [navi.navigationBar setTitleTextAttributes:@{NSFontAttributeName:MXRNAVITITLEFONT,NSForegroundColorAttributeName:MXRNAVITITLCOLOR}];
//                        navi.navigationBar.barTintColor = MXRNAVIBARTINTCOLOR;
//                        [APP_DELEGATE.navigationController presentViewController:navi animated:YES completion:nil];
//                    }
//                };
//                UINavigationController *navi = [[MXRNavigationViewController alloc] initWithRootViewController:vc];
//                [APP_DELEGATE.navigationController presentViewController:navi animated:YES completion:nil];
//
//            } else {
////                MXRQAExerciseViewController *vc = [[MXRQAExerciseViewController alloc] init];
//                MXRPKNormalAnswerVC *vc = [[MXRPKNormalAnswerVC alloc] init];
//                vc.qaId = autoString(_model.qaId);
//                MXRNavigationViewController *navi = [[MXRNavigationViewController alloc] initWithRootViewController:vc];
//                [navi.navigationBar setTitleTextAttributes:@{NSFontAttributeName:MXRNAVITITLEFONT,NSForegroundColorAttributeName:MXRNAVITITLCOLOR}];
//                navi.navigationBar.barTintColor = MXRNAVIBARTINTCOLOR;
//                [APP_DELEGATE.navigationController presentViewController:navi animated:YES completion:nil];
//            }
        } else {
            MXRTopicMainViewController * vc = [[MXRTopicMainViewController alloc] initWithMXRTopicModelName:mutableStr.string fromVC:defaultVCType];
//            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            BOOL isPushTopicVC = YES;
//            UIViewController * lastVC = [del.navigationController.childViewControllers lastObject];
//            if ([lastVC isKindOfClass:[MXRTopicMainViewController class]]) {
//                if ([[(MXRTopicMainViewController *)lastVC p_topicName] isEqualToString:mutableStr.string]) {
//                    isPushTopicVC = NO;
//                }
//            }
//            if (isPushTopicVC) {
//                [del.navigationController pushViewController:vc animated:YES];
//            }
        }
    });
}

#pragma mark - setter
-(void)setModel:(MXRSNSShareModel *)model{
    
    _model = model;
    if (model) {
        [self setupDefaultView];
        [self setButtonExclusiveTouch];
        [self layoutIfNeeded];
    }
}
-(void)setButtonExclusiveTouch{

    [self.userHandleStatusView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([(UIView *)obj isKindOfClass:[UIButton class]]) {
                [(UIView *)obj setExclusiveTouch:YES];
            }
    }];
    [self.statusImageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([(UIView *)obj isKindOfClass:[UIButton class]]) {
            [(UIView *)obj setExclusiveTouch:YES];
        }
    }];
    [self.statusBookView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([(UIView *)obj isKindOfClass:[UIButton class]]) {
            [(UIView *)obj setExclusiveTouch:YES];
        }
    }];
    [self.moreButton setExclusiveTouch:YES];
}
#pragma mark - getter
-(UIButton *)statusLikeButton{
    if (!_statusLikeButton) {
        _statusLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusLikeButton addTarget:self action:@selector(statusLikeButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
        [_statusLikeButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _statusLikeButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _statusLikeButton.contentMode = UIViewContentModeScaleAspectFill;
        _statusLikeButton.imageView.contentMode = UIViewContentModeCenter;
        [_statusLikeButton setImage:MXRIMAGE(@"btn_bookSNS_like") forState:UIControlStateNormal];
        [_statusLikeButton setImage:MXRIMAGE(@"btn_bookSNS_like_select") forState:UIControlStateHighlighted];
        [_statusLikeButton setImage:MXRIMAGE(@"btn_bookSNS_unlike") forState:UIControlStateSelected];
        _statusLikeButton.selected = NO;
    }
    return _statusLikeButton;
}
-(UIButton *)statusCommentButton{
    
    if (!_statusCommentButton) {
        _statusCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusCommentButton addTarget:self action:@selector(statusCommentButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
        [_statusCommentButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _statusCommentButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _statusCommentButton.contentMode = UIViewContentModeScaleAspectFit;
        _statusCommentButton.imageView.contentMode = UIViewContentModeCenter;
        [_statusCommentButton setImage:MXRIMAGE(@"btn_bookSNS_comment") forState:UIControlStateNormal];
        [_statusCommentButton setImage:MXRIMAGE(@"btn_bookSNS_comment_select") forState:UIControlStateHighlighted];
    }
    return _statusCommentButton;
}
-(UIButton *)statusForwardButton{
    
    if (!_statusForwardButton) {
        _statusForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusForwardButton addTarget:self action:@selector(statusForwardButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
        [_statusForwardButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _statusForwardButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _statusForwardButton.contentMode = UIViewContentModeScaleAspectFit;
        _statusForwardButton.imageView.contentMode = UIViewContentModeCenter;
        [_statusForwardButton setImage:MXRIMAGE(@"btn_bookSNS_forward") forState:UIControlStateNormal];
        [_statusForwardButton setImage:MXRIMAGE(@"btn_bookSNS_forward_select") forState:UIControlStateHighlighted];
    }
    return _statusForwardButton;
}


// 动态详情 getter
-(UILabel *)labZanCount{
    if (!_labZanCount) {
        _labZanCount = [[UILabel alloc] init];
        _labZanCount.textColor = MXRCOLOR_2FB8E2;
        _labZanCount.font = MXRFONT(LableZanFont);
        _labZanCount.textAlignment = NSTextAlignmentRight;
    }
    return  _labZanCount;
}

-(UILabel *)praiseAnimotionLable {
    if (!_praiseAnimotionLable) {
        _praiseAnimotionLable = [[UILabel alloc] init];
    }
    return _praiseAnimotionLable;
}

-(UIImageView *)morePraiseImage {
    if (!_morePraiseImage) {
        _morePraiseImage = [[UIImageView alloc] initWithImage:MXRIMAGE(@"icon_more")];
        _morePraiseImage.hidden = YES;
    }
    return _morePraiseImage;
}

-(void)addMorePraiseImageToUserHandleView {
    @MXRWeakObj(self);
    [self.userHandleStatusView addSubview:self.morePraiseImage];
    [self.morePraiseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(selfWeak.userHandleStatusView.mas_right).offset(0);
        make.top.equalTo(selfWeak.userHandleStatusView.mas_top).offset(10);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(15);
    }];
}

-(void)addPraiseAnimotionLable{
    @MXRWeakObj(self);
    [self.userHandleStatusView addSubview:selfWeak.praiseAnimotionLable];
    [self.praiseAnimotionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(selfWeak.userHandleStatusView.mas_right).offset(0);
        make.top.equalTo(selfWeak.userHandleStatusView.mas_top).offset(-1);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(13);
    }];
}

-(TTTAttributedLabel *)statusDetailLabel{
    
    if (!_statusDetailLabel) {
        _statusDetailLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
//        _statusDetailLabel.textInsets = UIEdgeInsetsMake(3, 0, 0, 0);
        _statusDetailLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal;
        _statusDetailLabel.numberOfLines = 0;
        _statusDetailLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        _statusDetailLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
        _statusDetailLabel.delegate = self;
        _statusDetailLabel.textAlignment=NSTextAlignmentLeft;
        _statusDetailLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
//        NSDictionary *linkAttrs= @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2,NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:momentTextFont]};
//        NSDictionary *activeLinkAttrs= @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2_A(LinkAlpha),NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:momentTextFont]};
//        NSDictionary * inactiveLinkAtts = @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2,NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:momentTextFont]};
//        _statusDetailLabel.linkAttributes = linkAttrs;
//        _statusDetailLabel.activeLinkAttributes = activeLinkAttrs;
//        _statusDetailLabel.inactiveLinkAttributes = inactiveLinkAtts;
        [_statusDetailView addSubview:_statusDetailLabel];
        [_statusDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_statusDetailView.mas_right).offset(0);
            make.top.equalTo(_statusDetailView.mas_top).offset(0);
            make.bottom.equalTo(_statusDetailView.mas_bottom).offset(0);
            make.left.equalTo(_statusDetailView.mas_left).offset(0);
        }];
    }
    return _statusDetailLabel;
}
-(NSMutableParagraphStyle*)paragraphStyle
{
    if (!_paragraphStyle)
    {
        _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [_paragraphStyle setLineSpacing:lineSpace];
    }
    return _paragraphStyle;
}
@end
