//
//  MXRBookSNSForwardTableViewCell.m
//  huashida_home
//
//  Created by gxd on 16/9/19.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSForwardTableViewCell.h"
#import "Masonry.h"
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
#import "GlobalBusyFlag.h"
//#import "MXRBookStoreNetworkManager.h"
//#import "MXRBookManager.h"
#import "MXRNavigationViewController.h"
#import "MXRSNSSendStateViewController.h"
#import "MXRBookSNSDetailViewController.h"
#import "TTTAttributedLabel.h"
#import "MXRTopicMainViewController.h"
//#import "MXRPromptView.h"
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

#define TextFileText @"textFileText"
#define IMAGETAG 100
#define ZanImageWidth 26
#define ZanImageSpace 4
#define LableZanFont 12

#define INTERVAL_LENGTH 10
#define cellId @"cellId"
#define lineSpace 5.0f
#define LinkAlpha 0.7f
static NSString * const commentTableViewCell = @"commentTableViewCell";
@interface MXRBookSNSForwardTableViewCell()<MXRBookSNSMomentImageViewDelegate,
                                            TTTAttributedLabelDelegate>

// ui
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet MXRUserHeaderView *userHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIView *transmitMomentDetailView;
@property (strong, nonatomic) TTTAttributedLabel *transmitMomentDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *srcStatusDetailView;
@property (strong, nonatomic) TTTAttributedLabel *srcStatusDetailLabel;
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
@property (strong, nonatomic) UIButton * statusLikeButton;
@property (strong, nonatomic) UIButton * statusCommentButton;
@property (strong, nonatomic) UIButton * statusForwardButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *hotSNSTipsImageView;
@property (weak, nonatomic) IBOutlet UIView *statusCommentView;

@property (weak, nonatomic) IBOutlet UILabel *statusCommentFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusCommentSecondLabel;

// 动态详情ui
@property (strong , nonatomic) UILabel *labZanCount;
@property (strong , nonatomic) UILabel *praiseAnimotionLable;

@property (strong , nonatomic) UIImageView *morePraiseImage;

// constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *srcMomentDetailLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transmitMomentDetailLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLabelWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusImageCollectionViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusImageCollectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusCommentViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusCommentViewBottomConstraint;

@property (strong, nonatomic) UILabel *handpickedTagLabel;

// 属性
@property (assign , nonatomic) CGSize itemImageSize;
@property (assign, nonatomic) CGFloat itemRightMargin;
@property (strong, nonatomic) NSMutableParagraphStyle *paragraphStyle;
@property (assign , nonatomic) CGSize textSize;
@end
@implementation MXRBookSNSForwardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.testLabelWidthConstraints.constant = SCREEN_WIDTH_DEVICE;
//    [self layoutIfNeeded];
    [self setup];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawRect:(CGRect)rect{
    if ([self.isSNSDetailView boolValue]) {
        self.statusCommentFirstLabel.text = nil;
        self.statusCommentSecondLabel.text = nil;

        self.moreButton.hidden = YES;
        [self setUserPraiseView];
    }else{
        self.moreButton.hidden = NO;
        [self setupUserHandleStatusView];
    }
}
#pragma mark - Private methods
-(void)setup{
    self.userHeaderView.hasVIPLabel = YES;
    [self.moreButton setImage:MXRIMAGE(@"btn_bookSNS_moreHandle") forState:UIControlStateNormal];
    
    self.statusBookIconImageView.layer.masksToBounds = YES;
    self.statusBookIconImageView.layer.borderColor = RGB(243, 243, 243).CGColor;
    self.statusBookIconImageView.layer.borderWidth = 0.8f;
    
    self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.layer.cornerRadius = 3.0f;
    
    self.statusCommentFirstLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal;
    self.statusCommentSecondLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal;
    
    //字体国际化
    _userNameLabel.font = MXRBOLDFONT(momentUserNameTextFont);
    _statusDescriptionLabel.font = MXRFONT(13);
    _statusTimeLabel.font = MXRFONT(12);
    _transmitMomentDetailLabel.font = MXRFONT(momentTextFont);
    _srcStatusDetailLabel.font = MXRFONT(tranMomentTextFont);
    _statusBookNameLabel.font = MXRFONT(14);
    _bookTagNameLabel.font = MXRFONT(14);
    _statusCommentFirstLabel.font = MXRFONT(momentTextFont);
    _statusCommentSecondLabel.font = MXRFONT(momentTextFont);
    
    [self setupHandpickedTagLabel];
    
#ifdef MXRSNAPLEARN
    self.statusDescriptionLabel.hidden = YES;
#endif
    
}

-(void)setupUserHandleStatusView{
    
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
-(void)setUserPraiseView{
    [self setupMomentDetailUserHandleView];
}
-(void)setupTransmitView{
//    [self setupHandpickedTagLabel];
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
//    _handpickedTagLabel.font = MXRFONT(9);
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
    
    [_handpickedTagLabel.superview layoutIfNeeded];//重新绘制
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
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
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
            } else {
                self.userHeaderView.placeHolderheaderImage = MXRIMAGE(@"icon_common_default_head");
            }
        }else{
            self.userHeaderView.headerUrl = _model.senderHeadUrl;
        }
    }
    
    self.userNameLabel.text = _model.senderName;
    self.userNameLabel.font = MXRBOLDFONT(momentUserNameTextFont);
//    [self.userNameLabel sizeToFit];
//    CGFloat userNameLabelwidth = self.userNameLabel.frame.size.width;
//    if (userNameLabelwidth > (SCREEN_WIDTH_DEVICE - 140)) {
//        userNameLabelwidth = SCREEN_WIDTH_DEVICE - 140;
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
    
    NSMutableAttributedString * transmitStr = [[NSMutableAttributedString alloc] initWithString:autoString(_model.momentDescription) attributes:@{NSFontAttributeName:MXRFONT(momentTextFont),NSParagraphStyleAttributeName:self.paragraphStyle,NSForegroundColorAttributeName:RGB(51, 51, 51)}];
    self.transmitMomentDetailLabel.text= transmitStr;
    [self checkTopic:self.transmitMomentDetailLabel andIsOrginMomentDetail:NO];
    
    NSString *agreementStr = [NSString stringWithFormat:@"%@: %@",_model.orginalModel.senderName,_model.orginalModel.momentDescription];
    if (!_model.orginalModel.senderName) {
        return;
    }
    NSRange range = [agreementStr rangeOfString:_model.orginalModel.senderName];
    NSMutableAttributedString * srcStatusDetailStr = [[NSMutableAttributedString alloc] initWithString:agreementStr attributes:@{NSFontAttributeName:MXRFONT(tranMomentTextFont),NSParagraphStyleAttributeName:self.paragraphStyle,NSForegroundColorAttributeName:RGB(102, 102, 102)}];
    [srcStatusDetailStr addAttribute:NSForegroundColorAttributeName value:MXRCOLOR_2FB8E2 range:range];
    [srcStatusDetailStr addAttribute:NSFontAttributeName value:MXRFONT(tranMomentTextFont) range:range];
    self.srcStatusDetailLabel.text = srcStatusDetailStr;
    [self checkQuestion:self.srcStatusDetailLabel];
    [self checkTopic:self.srcStatusDetailLabel andIsOrginMomentDetail:YES];

}
-(void)setupMomentImages{
    
    [[self.statusImageView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_model.orginalModel.imageArray.count > 0) {
        self.statusImageCollectionViewTopConstraint.constant = 8;
        if (_model.orginalModel.imageArray.count == 1) {
            [self setSingleImage:[_model.orginalModel.imageArray lastObject]];
        }else if (_model.orginalModel.imageArray.count > 1){
            CGFloat itemWidth = (SCREEN_WIDTH_DEVICE - textLabelWidthMarginTransmit - 2 * itemMargin)/3 ;
            self.itemImageSize = CGSizeMake(itemWidth, itemWidth);
        }
        
        self.statusImageCollectionViewHeightConstraint.constant = _model.orginalModel.cellImageheight;
        
        MXRBookSNSMomentImageView * imagesView = [[MXRBookSNSMomentImageView alloc] initWithimagesArray:_model.orginalModel.imageArray andFrame:self.statusImageView.bounds andItemSize:self.itemImageSize];
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
        self.itemImageSize = CGSizeMake(SCREEN_WIDTH_DEVICE - textLabelWidthMarginTransmit, singleImageHorizontalHeight);
    }else if (imageInfo.shapeType == MXRBooKSNSSendDetailImageTypeVertical){
        self.itemRightMargin = SCREEN_WIDTH_DEVICE - textLabelWidthMarginTransmit - SCREEN_WIDTH_DEVICE/2;
        self.itemImageSize = CGSizeMake(SCREEN_WIDTH_DEVICE/2, singleImageVerticalHeight);
    }else{
        self.itemImageSize = CGSizeMake(SCREEN_WIDTH_DEVICE - textLabelWidthMarginTransmit, singleImageVerticalHeight);
    }
}
-(void)setupBookInfo{
    
    @MXRWeakObj(self);
    if (_model.orginalModel.bookContentType == MXRBookSNSDynamicBookContentTypeSingleBook) {
        self.bookTagView.hidden = YES;
        self.statusBookNameLabel.hidden = NO;
        self.statusBookIconImageView.hidden = NO;
        self.statusBookIconImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.statusBookNameLabel.text = _model.orginalModel.bookName;
        //[NSURL URLWithString:_model.orginalModel.bookIconUrl]
        /*V5.6.1 图书封面拼接时间戳，实时更新*/
        NSString *imgDateStr = [NSString stringWithFormat:@"%@?%@", _model.orginalModel.bookIconUrl, [NSString stringWithFormat:@"t=%f", [NSDate timeIntervalSinceReferenceDate]]];
        NSURL *imgDateUrl = [NSURL URLWithString:imgDateStr];
        /*V5.6.1 图书封面拼接时间戳，实时更新*/
        [self.statusBookIconImageView sd_setImageWithURL:imgDateUrl placeholderImage:MXRIMAGE(@"img_bookSNS_defaultBookIcon") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                UIImage * lastImage = [image clipImageInRect:CGRectMake(0, 0, image.size.width, image.size.width)];
                selfWeak.statusBookIconImageView.image = lastImage;
            }
        }];
        [UIImage setBookStarGrade:_model.orginalModel.bookStars andStarImageViewArray:[NSArray arrayWithObjects:self.statusBookStarOneImageView,self.statusBookStarTwoImageView,self.statusBookStarThreeImageView,self.statusBookStarFourImageView,self.statusBookStarFiveImageView, nil]];
    }else if (_model.orginalModel.bookContentType == MXRBookSNSDynamicBookContentTypeMutableBook){
        self.bookTagView.hidden = NO;
        self.statusBookNameLabel.hidden = YES;
        self.statusBookIconImageView.hidden = YES;
        self.bookTagNameLabel.text = _model.contentZoneName;
        [self.bookTagImageView sd_setImageWithURL:[NSURL URLWithString:_model.orginalModel.contentZoneCover] placeholderImage:MXRIMAGE(@"img_bookSNS_defaultBookIcon") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
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
-(void)gotoBookDetail:(NSString *)bookGuid{
//    [MXRBookManager defaultManager].downloadSourceType = MXRBookSNSToBookDetailDownloadType;
//    /// 5.2.2 modify by Martin.liu
//    DDYBookDetailViewController *bookDetailViewCon = [[DDYBookDetailViewController alloc] init];
//    bookDetailViewCon.bookGuid = bookGuid;
//    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [del.navigationController pushViewController:bookDetailViewCon animated:YES];

}

-(void)checkTopic:(TTTAttributedLabel *)view andIsOrginMomentDetail:(BOOL )isOrgin{
    
    NSString * text = view.text;
    NSArray * array;
    if (isOrgin) {
        array = _model.orginalModel.topicNameArray;
    }else{
        array = _model.topicNameArray;
    }
    if (!view.text) {
        return;
    }
    NSString *topicPattern = @"#([^\\#]+)#";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:topicPattern options:0 error:nil];
    NSArray *results = [regex matchesInString:view.text options:0 range:NSMakeRange(0, view.attributedText.length)];
    if (results.count>0) {
        for (NSTextCheckingResult *result in results) {
            NSString * temp = [text substringWithRange:result.range];
            if ([array containsObject:temp]) {
                
                NSDictionary *linkAttrs= @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2,NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:MXRFONT(tranMomentTextFont)};
                NSDictionary *activeLinkAttrs= @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2_A(LinkAlpha),NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:MXRFONT(tranMomentTextFont)};
                NSDictionary * inactiveLinkAtts = @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2,NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:MXRFONT(tranMomentTextFont)};
                view.linkAttributes = linkAttrs;
                view.activeLinkAttributes = activeLinkAttrs;
                view.inactiveLinkAttributes = inactiveLinkAtts;
                
                [view addLinkWithTextCheckingResult:result];
            }
        }
    }else{
       // view.textColor=[UIColor blackColor];
    }
}
- (void)checkQuestion:(TTTAttributedLabel *)label {
    if ([_model.qaId integerValue] <= 0) {
        return;
    }
    
    NSString *text = label.text;
    if (text == nil) {
        text = @"";
    }
    text = [text stringByAppendingString:@"\n"];
    NSString *suffixText = MXRLocalizedString(@"MXRQAExerciseVC_ClickToJoin", @"点击此处直接参与");
    NSString *composeText = [text stringByAppendingString:suffixText];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:suffixText options:0 error:nil];
    NSArray *results = [regex matchesInString:composeText options:0 range:NSMakeRange(0,composeText.length)];
    label.text = [[NSMutableAttributedString alloc] initWithString:composeText attributes:@{NSFontAttributeName:MXRFONT(tranMomentTextFont),NSParagraphStyleAttributeName:self.paragraphStyle,NSForegroundColorAttributeName:RGB(51, 51, 51)}];
    if (results.count > 0) {
        NSTextCheckingResult *lastResult = results.lastObject;
        
        NSDictionary *linkAttrs= @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2,NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:MXRFONT(tranMomentTextFont)};
        NSDictionary *activeLinkAttrs= @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2_A(LinkAlpha),NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:MXRFONT(tranMomentTextFont)};
        NSDictionary * inactiveLinkAtts = @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2,NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:MXRFONT(tranMomentTextFont)};
        label.linkAttributes = linkAttrs;
        label.activeLinkAttributes = activeLinkAttrs;
        label.inactiveLinkAttributes = inactiveLinkAtts;
        
        [label addLinkWithTextCheckingResult:lastResult];
        
//        [label addLinkWithTextCheckingResult:lastResult attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:tranMomentTextFont],NSParagraphStyleAttributeName:self.paragraphStyle,NSForegroundColorAttributeName:MXRCOLOR_2FB8E2}];
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
#pragma mark - Actions
- (IBAction)moreBntClick:(UIButton *)sender {
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
    [MXRClickUtil event:@"DreamCircle_Book_click"];
    if (self.model.orginalModel.bookContentType == MXRBookSNSDynamicBookContentTypeSingleBook) {
        [self gotoBookDetail:_model.bookGuid];
    }else{
//        MXRBookStoreSubjectDetailViewController * vc = [[MXRBookStoreSubjectDetailViewController alloc] initWithRecommendId:[self.model.contentZoneId integerValue]];
//        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [del.navigationController pushViewController:vc animated:YES];
    }
}

-(void)statusLikeButtonClcik:(UIButton *)sender{
    [MXRClickUtil event:@"DreamCircle_Like_Click"];
    if (_model.momentStatusType == MXRBookSNSMomentStatusTypeOnLocal || _model.momentStatusType == MXRBookSNSMomentStatusTypeOnUpload) {
        return;
    }
    if (![[UserInformation modelInformation] checkIsLogin]) {
        return;
    }
    sender.enabled = NO;
    self.userInteractionEnabled = NO;
    [self.model likeBtnClick];
    self.statusLikeButton.selected = _model.hasPraised;
    for (UIView *view in self.userHandleStatusView.subviews) {
        if (view.tag == IMAGETAG) {
            [view removeFromSuperview];
        }
    }
    if (self.model.hasPraised) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(self.statusLikeButton.center.x - 5, self.statusLikeButton.center.y - StatusLikeButtonAddOneAnimationYMargin, 13, 13)];
        [self.userHandleStatusView addSubview:view];
        if ([self.isSNSDetailView boolValue]) {
            [self showAddCountAnimationWithView:_praiseAnimotionLable];
        }else{
            [self showAddCountAnimationWithView:view];
        }
    }
    @MXRWeakObj(self);
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
            }
        }];
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
            }
        }];
    }
    
    if (self.isSNSDetailView) {
        [self setupMomentDetailUserHandleView];
    }else{
        [self setupUserHandleView];
    }
}

-(void)removeUserHandleStatusViewSubviews {
    [self.morePraiseImage removeFromSuperview];
    [_labZanCount removeFromSuperview];
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

//跳转点赞列表页
-(void)goToPraiseDetailVC {
    MXRSNSPraiseDetailViewController
    *prsiseDetailVC = [[MXRSNSPraiseDetailViewController alloc] initWithMXRSNSShareModel:self.model];
//    [APP_DELEGATE.navigationController pushViewController:prsiseDetailVC animated:YES];
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


-(void)statusCommentButtonClcik:(UIButton *)sender{
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


#pragma mark - MXRBookSNSMomentImageViewDelegate
-(void)btnImageViewClick:(NSInteger)index andSelf:(UIView *)sender{
    
    if (_model.imageArray.count == 0) {
        return;
    }
    if (_imageClick) {
        _imageClick(NO);
    }
    MXRBookSNSMomentImageDetailCollection * imagesView = [[MXRBookSNSMomentImageDetailCollection alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE) anditem:sender andSelectIndex:index andImageInfos:_model.orginalModel.imageArray];
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
    if ([_model.qaId integerValue] > 0 && [mutableStr.string isEqualToString:MXRLocalizedString(@"MXRQAExerciseVC_ClickToJoin", @"点击此处直接参与")]) {
        DLOG(@"qaid:%ld", [_model.qaId integerValue]);
//        if (![[UserInformation modelInformation] getIsLogin]) {
//            MXRLoginVC *vc = [[MXRLoginVC alloc] init];
//            @weakify(self)
//            NSInteger qaId = [_model.qaId integerValue];
//            vc.loginResultBlock = ^(MXRLoginVCResult result) {
//                @strongify(self)
//                if (!strong_self) return;
//                if (result & MXRLoginVCResultSuccess) {
//                    MXRPKNormalAnswerVC *vc = [[MXRPKNormalAnswerVC alloc] init];
//                    vc.qaId = autoString(@(qaId));
//                    MXRNavigationViewController *navi = [[MXRNavigationViewController alloc] initWithRootViewController:vc];
//                    [navi.navigationBar setTitleTextAttributes:@{NSFontAttributeName:MXRNAVITITLEFONT,NSForegroundColorAttributeName:MXRNAVITITLCOLOR}];
//                    navi.navigationBar.barTintColor = MXRNAVIBARTINTCOLOR;
//                    [APP_DELEGATE.navigationController presentViewController:navi animated:YES completion:nil];
//                }
//            };
//            UINavigationController *navi = [[MXRNavigationViewController alloc] initWithRootViewController:vc];
//            [APP_DELEGATE.navigationController presentViewController:navi animated:YES completion:nil];
//
//        } else {
////            MXRQAExerciseViewController *vc = [[MXRQAExerciseViewController alloc] init];
////            vc.qaId = [_model.qaId integerValue];
//            MXRPKNormalAnswerVC *vc = [[MXRPKNormalAnswerVC alloc] init];
//            vc.qaId = autoString(_model.qaId);
//            MXRNavigationViewController *navi = [[MXRNavigationViewController alloc] initWithRootViewController:vc];
//            [navi.navigationBar setTitleTextAttributes:@{NSFontAttributeName:MXRNAVITITLEFONT,NSForegroundColorAttributeName:MXRNAVITITLCOLOR}];
//            navi.navigationBar.barTintColor = MXRNAVIBARTINTCOLOR;
//            [APP_DELEGATE.navigationController presentViewController:navi animated:YES completion:nil];
//        }
    } else {
        MXRTopicMainViewController * vc = [[MXRTopicMainViewController alloc] initWithMXRTopicModelName:mutableStr.string fromVC:defaultVCType];
//        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        BOOL isPushTopicVC = YES;
//        UIViewController * lastVC = [del.navigationController.childViewControllers lastObject];
//        if ([lastVC isKindOfClass:[MXRTopicMainViewController class]]) {
//            if ([[(MXRTopicMainViewController *)lastVC p_topicName] isEqualToString:mutableStr.string]) {
//                isPushTopicVC = NO;
//            }
//        }
//        if (isPushTopicVC) {
//            [del.navigationController pushViewController:vc animated:YES];
//        }
    }
}

#pragma mark - setter
-(void)setModel:(MXRSNSTransmitModel *)model{
    
    _model = model;
    if (model) {
        [self setupTransmitView];
        [self setButtonExclusiveTouch];
        [self layoutIfNeeded];
    }
}

#pragma mark - getter
-(UIButton *)statusLikeButton{
    if (!_statusLikeButton) {
        _statusLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusLikeButton addTarget:self action:@selector(statusLikeButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
        [_statusLikeButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _statusLikeButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
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
        _statusCommentButton.imageView.contentMode = UIViewContentModeCenter;
        [_statusCommentButton setImage:MXRIMAGE(@"btn_bookSNS_comment") forState:UIControlStateNormal];
//        [_statusCommentButton setImage:[UIImage imageNamed:@"btn_bookSNS_comment_select"] forState:UIControlStateHighlighted];
    }
    return _statusCommentButton;
}
-(UIButton *)statusForwardButton{
    
    if (!_statusForwardButton) {
        _statusForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusForwardButton addTarget:self action:@selector(statusForwardButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
        [_statusForwardButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _statusForwardButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
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
        _labZanCount.text =  _labZanCount.text = [NSString stringWithFormat:@"%ld",(long)self.model.likeCount];;
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


-(TTTAttributedLabel *)srcStatusDetailLabel{

    if (!_srcStatusDetailLabel) {
        _srcStatusDetailLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
//        _srcStatusDetailLabel.textInsets = UIEdgeInsetsMake(3, 0, 0, 0);
        _srcStatusDetailLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - textLabelWidthMarginTransmit;
        _srcStatusDetailLabel.numberOfLines = 0;
        _srcStatusDetailLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        _srcStatusDetailLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
        _srcStatusDetailLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentBottom;
        _srcStatusDetailLabel.delegate = self;
        _srcStatusDetailLabel.textAlignment=NSTextAlignmentLeft;
        _srcStatusDetailLabel.numberOfLines=0;
//        NSDictionary *linkAttrs= @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2,NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:tranMomentTextFont]};
//        NSDictionary *activeLinkAttrs= @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2_A(LinkAlpha),NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:tranMomentTextFont]};
//        NSDictionary * inactiveLinkAtts = @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2,NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:tranMomentTextFont]};
//        _srcStatusDetailLabel.linkAttributes = linkAttrs;
//        _srcStatusDetailLabel.activeLinkAttributes = activeLinkAttrs;
//        _srcStatusDetailLabel.inactiveLinkAttributes = inactiveLinkAtts;
        [_srcStatusDetailView addSubview:_srcStatusDetailLabel];
        [_srcStatusDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_srcStatusDetailView.mas_right).offset(0);
            make.top.equalTo(_srcStatusDetailView.mas_top).offset(0);
            make.bottom.equalTo(_srcStatusDetailView.mas_bottom).offset(0);
            make.left.equalTo(_srcStatusDetailView.mas_left).offset(0);
        }];
    }
    return _srcStatusDetailLabel;
}
-(TTTAttributedLabel *)transmitMomentDetailLabel{

    if (!_transmitMomentDetailLabel) {
        _transmitMomentDetailLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
//        _transmitMomentDetailLabel.textInsets = UIEdgeInsetsMake(3, 0, 0, 0);
         _transmitMomentDetailLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal;
        _transmitMomentDetailLabel.numberOfLines = 0;
        _transmitMomentDetailLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        _transmitMomentDetailLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
        _transmitMomentDetailLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentBottom;
        _transmitMomentDetailLabel.delegate = self;
        _transmitMomentDetailLabel.textAlignment=NSTextAlignmentLeft;
        _transmitMomentDetailLabel.numberOfLines=0;
//        NSDictionary *linkAttrs= @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2,NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:momentTextFont]};
//        NSDictionary *activeLinkAttrs= @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2_A(LinkAlpha),NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:momentTextFont]};
//        NSDictionary * inactiveLinkAtts = @{NSForegroundColorAttributeName:MXRCOLOR_2FB8E2,NSParagraphStyleAttributeName:self.paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:momentTextFont]};
//        _transmitMomentDetailLabel.linkAttributes = linkAttrs;
//        _transmitMomentDetailLabel.activeLinkAttributes = activeLinkAttrs;
//        _transmitMomentDetailLabel.activeLinkAttributes = inactiveLinkAtts;
        [_transmitMomentDetailView addSubview:_transmitMomentDetailLabel];
        [_transmitMomentDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_transmitMomentDetailView.mas_right).offset(0);
            make.top.equalTo(_transmitMomentDetailView.mas_top).offset(0);
            make.bottom.equalTo(_transmitMomentDetailView.mas_bottom).offset(0);
            make.left.equalTo(_transmitMomentDetailView.mas_left).offset(0);
        }];
    }
    return _transmitMomentDetailLabel;
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
