//
//  MXRBookSNSDeleteForwardTableViewCell.m
//  huashida_home
//
//  Created by gxd on 16/10/13.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSDeleteForwardTableViewCell.h"
#import "MXRBookSNSDetailViewController.h"
#import "TTTAttributedLabel.h"
#import "MXRBookSNSUserHandleMomentView.h"
#import "UIImageView+WebCache.h"
#import "GlobalFunction.h"
#import "NSString+Ex.h"
#import "UIImage+Extend.h"
#import "Masonry.h"
#import "MXRBookSNSPraiseListModel.h"
#import "MXRBookSNSController.h"
#import "MXRBookSNSMomentStatusNoUploadManager.h"
//#import "MXRPromptView.h"
//#import "MXRLoginVC.h"
#import "MXRNavigationViewController.h"
#import "MXRSNSPraiseDetailViewController.h"
#import "MXRTopicMainViewController.h"
#import "MXRUserHeaderView.h"
#import "NSString+NSDate.h"
#import "UIViewController+Ex.h"

#define lineSpace 5.0f
#define LinkAlpha 0.7f
#define INTERVAL_LENGTH 10
#define ZanImageWidth 26
#define ZanImageSpace 4
#define LableZanFont 12
#define IMAGETAG 100


@interface MXRBookSNSDeleteForwardTableViewCell()<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet MXRUserHeaderView *userHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *tipsDeleteLabel;
@property (weak, nonatomic) IBOutlet UIView *transmitMomentDetailView;
@property (weak, nonatomic) IBOutlet UIView *userHandleStatusView;

@property (weak, nonatomic) IBOutlet UIView *statusCommentView;
@property (weak, nonatomic) IBOutlet UILabel *statusCommentFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusCommentSecondLabel;
@property (strong, nonatomic) TTTAttributedLabel *transmitMomentDetailLabel;

@property (strong, nonatomic) NSMutableParagraphStyle *paragraphStyle;

@property (strong, nonatomic) UIButton * statusLikeButton;
@property (strong, nonatomic) UIButton * statusCommentButton;
@property (strong, nonatomic) UIButton * statusForwardButton;
@property (weak, nonatomic) IBOutlet UIImageView *hotSNSTipsImageView;

@property (strong, nonatomic) UILabel *handpickedTagLabel;

// 动态详情ui
@property (strong , nonatomic) UILabel *labZanCount;
@property (strong , nonatomic) UILabel *praiseAnimotionLable;
@property (strong , nonatomic) UIImageView *morePraiseImage;
@property (assign, nonatomic) BOOL isPraise;
@property (assign , nonatomic) CGSize textSize;
// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLabelWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transmitMomentDetailLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusCommentViewTopConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *testLabelWidthConstraints;
@end

@implementation MXRBookSNSDeleteForwardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.testLabelWidthConstraints.constant = SCREEN_WIDTH_DEVICE;
//    [self layoutIfNeeded];
    [self setup];
    // Initialization code
}
-(void)drawRect:(CGRect)rect{
    if ([self.isSNSDetailView boolValue]) {
        self.moreButton.hidden = YES;
        [self setUserPraiseView];
    }else{
        self.moreButton.hidden = NO;
        [self setupUserHandleStatusView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setup{
    self.userHeaderView.hasVIPLabel = YES;
    [self.moreButton setImage:MXRIMAGE(@"btn_bookSNS_moreHandle") forState:UIControlStateNormal];
    
    self.tipsDeleteLabel.text = MXRLocalizedString(@"MXRBookSNSDeleteForwardTableViewCellTipsLabelText", @"原动态已删除");
    self.statusCommentFirstLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal;
    self.statusCommentSecondLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal;
    
    //字体国际化
    _userNameLabel.font = MXRBOLDFONT(momentUserNameTextFont);
    _statusDescriptionLabel.font = MXRFONT(13);
    _statusTimeLabel.font = MXRFONT(12);
    _transmitMomentDetailLabel.font = MXRFONT(momentTextFont);
    _tipsDeleteLabel.font = MXRFONT(12);
    _statusCommentFirstLabel.font = MXRFONT(momentTextFont);
    _statusCommentSecondLabel.font = MXRFONT(momentTextFont);
    
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
    BOOL notMyMoment = YES ;
    if ([_model.senderId isEqualToString:[UserInformation modelInformation].userID]) {
        notMyMoment = NO;
    }
    [[MXRBookSNSUserHandleMomentView getInstance]  showWithIsXiaomengMoment:notMyMoment momentID:self.model.momentId andUnFocusUserId:self.model.senderId andMomentBelongViewtype:self.belongViewtype];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MXRBookSNS_ScrollTopNoEnable object:nil];
}
-(void)statusLikeButtonClcik:(UIButton *)sender{
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
    
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result{
    
    
    NSAttributedString * mutableStr = [label.attributedText attributedSubstringFromRange:result.range];
    dispatch_async(dispatch_get_main_queue(), ^{
        MXRTopicMainViewController * vc = [[MXRTopicMainViewController alloc] initWithMXRTopicModelName:mutableStr.string fromVC:defaultVCType];
        [[UIViewController currentViewController].navigationController pushViewController:vc animated:YES];
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
    });
}

#pragma mark - setter
-(void)setModel:(MXRSNSShareModel *)model{

    [self layoutIfNeeded];
    _model = model;
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
     NSMutableAttributedString * transmitStr = [[NSMutableAttributedString alloc] initWithString:_model.momentDescription attributes:@{NSFontAttributeName:MXRFONT(momentTextFont),NSParagraphStyleAttributeName:self.paragraphStyle,NSForegroundColorAttributeName:RGB(51, 51, 51)}];
    self.transmitMomentDetailLabel.text = transmitStr;
    [self checkTopic:self.transmitMomentDetailLabel];
//    [self setupHandpickedTagLabel];
    [self setHotImageView];
    [self setupMomentComment];
    if ([self.isSNSDetailView boolValue]) {
        [self setupMomentDetailUserHandleView];
    }else{
        [self setupUserHandleView];
    }
    [self layoutIfNeeded];
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
    
    [_handpickedTagLabel.superview layoutIfNeeded];//重新绘制
    _handpickedTagLabel.layer.backgroundColor = RGBHEX(0xFF392F).CGColor;
}

- (void)setHotImageView{
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
}

/**
 设置动态评论 (可能有0，1，2 条)
 */
- (void)setupMomentComment{
    
    if ([self.isSNSDetailView boolValue]) {
        self.statusCommentViewTopConstraint.constant = -1000;
        self.statusCommentView.hidden = YES;
        self.statusCommentFirstLabel.text = nil;
        self.statusCommentSecondLabel.text = nil;
        return;
    }
    if (_model.commentList.count == 0) {
        self.statusCommentViewTopConstraint.constant = -1000;
        self.statusCommentView.hidden = YES;
        self.statusCommentFirstLabel.text = nil;
        self.statusCommentSecondLabel.text = nil;
    }else if(_model.commentList.count > 0){
        self.statusCommentViewTopConstraint.constant = 8;
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

//跳转点赞列表页
-(void)goToPraiseDetailVC {
    MXRSNSPraiseDetailViewController
    *prsiseDetailVC = [[MXRSNSPraiseDetailViewController alloc] initWithMXRSNSShareModel:self.model];
//    [APP_DELEGATE.navigationController pushViewController:prsiseDetailVC animated:YES];
}


-(void)checkTopic:(TTTAttributedLabel *)view{
    
    if (!view.text) {
        return;
    }
     NSString * text = view.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:view.attributedText];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, view.attributedText.string.length)];
    NSString *topicPattern = @"#([^\\#]+)#";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:topicPattern options:0 error:nil];
    NSArray *results = [regex matchesInString:view.text options:0 range:NSMakeRange(0, view.attributedText.length)];
    if (results.count>0) {
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
        view.textColor=[UIColor blackColor];
    }
}
-(void)setBtnEnableAlpha:(BOOL )show{
    
    if (show) {
        self.statusLikeButton.alpha = 1.0f;
        [self.statusLikeButton setAdjustsImageWhenHighlighted:YES];
        self.statusCommentButton.alpha = 1.0f;
        [self.statusCommentButton setAdjustsImageWhenHighlighted:YES];
        [self.statusForwardButton setAdjustsImageWhenHighlighted:NO];
    }else{
        self.statusLikeButton.alpha = MomentBtnEnableAlpha;
        [self.statusLikeButton setAdjustsImageWhenHighlighted:NO];
        self.statusCommentButton.alpha = MomentBtnEnableAlpha;
        [self.statusCommentButton setAdjustsImageWhenHighlighted:NO];
        self.statusForwardButton.alpha = MomentBtnEnableAlpha;
        [self.statusForwardButton setAdjustsImageWhenHighlighted:NO];
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
        [_statusForwardButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
        _statusForwardButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _statusForwardButton.adjustsImageWhenHighlighted = NO;
        _statusForwardButton.imageView.contentMode = UIViewContentModeCenter;
        [_statusForwardButton setImage:MXRIMAGE(@"btn_bookSNS_forward") forState:UIControlStateNormal];
        _statusForwardButton.alpha = MomentBtnEnableAlpha;
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

-(TTTAttributedLabel *)transmitMomentDetailLabel{
    
    if (!_transmitMomentDetailLabel) {
        _transmitMomentDetailLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _transmitMomentDetailLabel.numberOfLines = 0;
//         _transmitMomentDetailLabel.textInsets = UIEdgeInsetsMake(3, 0, 0, 0);
        _transmitMomentDetailLabel.preferredMaxLayoutWidth = SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal;
        _transmitMomentDetailLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        _transmitMomentDetailLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
        _transmitMomentDetailLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentBottom;
        _transmitMomentDetailLabel.delegate = self;
        _transmitMomentDetailLabel.textColor = RGB(51, 51, 51);
        _transmitMomentDetailLabel.textAlignment=NSTextAlignmentLeft;
        _transmitMomentDetailLabel.numberOfLines=0;
        NSDictionary *linkAttrs= @{NSForegroundColorAttributeName:RGB(6, 119, 154),NSParagraphStyleAttributeName:self.paragraphStyle};
        NSDictionary *activeLinkAttrs= @{NSForegroundColorAttributeName:RGBA(6, 119, 154,LinkAlpha)};
        _transmitMomentDetailLabel.linkAttributes = linkAttrs;
        _transmitMomentDetailLabel.activeLinkAttributes = activeLinkAttrs;
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
         _paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _paragraphStyle;
}
@end
