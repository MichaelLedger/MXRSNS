//
//  MXRSTShareModel.h
//  huashida_home
//  梦想圈动态模型
//  Created by dingyang on 16/9/19.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookInfoForShelf.h"
#import "MXRBookSNSUploadImageInfo.h"

static NSString *userId = @"userId";
static NSString *content = @"content";
static NSString *name = @"name";
static NSString *icon = @"icon";
static NSString *likeCount = @"praiseNum";
static NSString *commentCount = @"commentNum";
static NSString *senderDescribe = @"senderDescribe";
static NSString *bookContentType = @"bookContentType";
static NSString *bookName = @"contentBookName";
static NSString *bookStars = @"contentBookStarlevel";

static NSString *bookIconUrl = @"contentBookLogo";
static NSString *bookGuid = @"contentBookId";
static NSString *originalCommet = @"originalCommet";
static NSString *imageList = @"imageList";
static NSString *transmitCommet = @"transmitCommet";
static NSString *originalSenderName = @"originalSenderName";
static NSString *momentId = @"id";
static NSString *momentDescription = @"contentWord";
static NSString *senderHeadUrl = @"userLogo";
static NSString *senderName = @"userName";
static NSString *senderTime = @"createTime";
static NSString *senderType = @"action";
static NSString *bookInfo = @"bookInfo";
static NSString *likeArray = @"likeArray";
static NSString *commentArray = @"commentArray";
static NSString *isMyCompany = @"publisher";
static NSString *adetailModel = @"detailModel";
static NSString *transmitArray = @"transmitArray";
static NSString *isDelete = @"isDelete";
static NSString * imageArray = @"contentPic";
static NSString *topicIDs = @"topicIds";
static NSString *trammitCount = @"retransmissionNum";
static NSString *srcId = @"srcId";
static NSString *srcUserId = @"srcUserId";
static NSString *srcUserName = @"srcUserName";
static NSString *retransmissionWord = @"retransmissionWord";
static NSString * momentSingleImageType = @"momentSingleImageType";
static NSString *cellheight = @"cellheight";
static NSString *senderIconImage=@"senderIconImage";
static NSString *contentPicType = @"contentPicType";
static NSString *hasPraised = @"hasPraised";
static NSString *clientUuid = @"clientUuid";
static NSString *orderNum = @"orderNum";
static NSString *srcStatus = @"srcStatus";
static NSString *recommend = @"recommend";
static NSString *commentNum = @"commentNum";
static NSString *commentList = @"commentList";
static NSString *commentID = @"commentID";
static NSString *delFlag = @"delFlag";
static NSString *srcContent = @"srcContent";
static NSString *sort = @"sort";
static NSString *momoentIsSort = @"isSort";
static NSString *contentZoneId = @"contentZoneId";
static NSString *contentZoneName = @"contentZoneName";
static NSString *contentZoneCover = @"contentZoneCover";
static NSString *qaId = @"qaId";

static NSString * topicnames = @"topicNames";

static NSString *topSort = @"topSort";

static const float cellOldHeight = 154;
static const float transmitCellOldHeight = 185;
static const float deleteCellOldHeight = 160;
static const float textLabelOldheight = 18;
static const float transmitTextLabelOldheight = 18;
static const float textLabelWidthMarginNormal = 15 + 38 +10 + 12;
static const float textLabelWidthMarginTransmit = textLabelWidthMarginNormal + 2 * 10;
static const float itemMargin = 7;
static const float singleImageHorizontalHeight = 163;
static const float singleImageVerticalHeight = 223;
static const float deleteCellDescriptionTextLabelHeight = 22;

static const float momentTextFont = 15.0f;
static const float tranMomentTextFont = 14.0f;
static const float momentUserNameTextFont = 15.0f;
static const float momentUserNameTextHeight = 20.0f;
static const float NoImageMargin = 8.0f;
static const float MomentBtnEnableAlpha = 0.4;
static const float MomentUserHanldBtnWidth = 80;
static const float MomentUserHanldBtnMargin = 5;
static const float StatusLikeButtonAddOneAnimationYMargin = 17.0f;

static const float textLabelHeigthMarginNormal = 3;

typedef enum SenderType{
    SenderTypeOfDefault = 1,//默认
    SenderTypeOfTransmit,//转发
    SenderTypeOfShare//分享
}SenderType;//动态发送类型

typedef enum MXRBookSNSMomentStatusType{
    MXRBookSNSMomentStatusTypeNoknown    = 0,//未知
    MXRBookSNSMomentStatusTypeOnInternet = 1,//已发布
    MXRBookSNSMomentStatusTypeOnLocal    = 2,//本地
    MXRBookSNSMomentStatusTypeOnUpload   = 3//正在发布
}MXRBookSNSMomentStatusType;//动态发布状态

typedef enum MXRSrcMomentStatus{
    MXRSrcMomentStatusDefault = 0,//默认
    MXRSrcMomentStatusDelete = 1//已删除
}MXRSrcMomentStatus;//动态服务器状态

typedef NS_ENUM(NSInteger,MXRBookSNSBelongViewtype){
    MXRBookSNSBelongViewtypeBookSNSView = 1,//梦想圈首页
    MXRBookSNSBelongViewtypeTopicView = 2,//话题页
    MXRBookSNSBelongBelongViewtypeMyBookSNSView = 3,//我的动态
    MXRBookSNSBelongViewtypeMomentDetail = 4//动态详情
};//动态所属页面类型

typedef NS_ENUM(NSInteger,MXRBookSNSDynamicType) {
    MXRBookSNSDefaultDynamicType = 0,//普通动态
    MXRBookSNSRecommendDynamicType//精选动态
};//动态类型

/**
  梦想圈绑定的图书类型

 - MXRBookSNSDynamicBookContentTypeSingleBook: 单本图书类型
 - MXRBookSNSDynamicBookContentTypeMutableBook: 图书专区类型
 */
typedef NS_ENUM(NSInteger,MXRBookSNSDynamicBookContentType) {
    MXRBookSNSDynamicBookContentTypeSingleBook = 1,
    MXRBookSNSDynamicBookContentTypeMutableBook = 2
};
/*转发的model*/
@interface  TransmitModel: NSObject<NSCoding>
@property (readonly, nonatomic) NSString *userId;
@property (readonly, nonatomic) NSString *content;
@property (readonly, nonatomic) NSString *name;
//-(instancetype)initWithUserId:(NSString *)userID WithContent:(NSString *)contentText WithName:(NSString *)contentLastName;
@end


/*点赞的model*/
@interface LikeModel : NSObject<NSCoding  >
@property (readonly, nonatomic) NSString *userId;
@property (readonly, nonatomic) NSString *icon;
@property (readonly, nonatomic) NSString *name;
@end

/*动态下显示评论的model*/
@interface MXRSNSCommentModel :NSObject <NSCoding>
@property (nonatomic, assign) NSInteger commentID; //评论ID
@property (nonatomic, assign) NSInteger srcId;   //原评论ID
@property (nonatomic, assign) NSInteger srcUserId; //原评论的用户ID
@property (nonatomic, assign) NSInteger srcStatus;  //源评论状态0：正常，1：删除
@property (nonatomic, assign) NSInteger userId;   //用户ID
@property (nonatomic, copy  ) NSString *userName;  //用户名称
@property (nonatomic, assign) NSInteger delFlag;
@property (nonatomic, copy  ) NSString *srcUserName; //原评论的用户名称
@property (nonatomic, copy  ) NSString *content; //评论内容
@property (nonatomic, copy  ) NSString *srcContent;  //原评论内容

//V5.9.1
@property (nonatomic, assign) NSInteger sort;//排序（为0则不为置顶）

-(instancetype)initWithDictionary:(NSDictionary *)senderDict;

@end

@interface MXRSNSShareModel : NSObject<NSCoding>
@property (copy, nonatomic) NSString *momentId; // 动态ID
@property (readonly, nonatomic) NSString *clientUuid; // 本地发布动态ID
@property (readonly, nonatomic) NSString *senderId;
@property (readonly, nonatomic) NSString *momentDescription; // 动态文字详情
@property (readonly, nonatomic) NSString *senderHeadUrl;
@property (readonly, nonatomic) UIImage  *senderIconImage;
@property (readonly, nonatomic) NSString *senderName;
@property (readonly, nonatomic) NSNumber *senderTime;
// V5.13.0 M by liulong 是否是vip图书
@property (nonatomic, assign) BOOL vipFlag;
@property (readonly, nonatomic) BookInfoForShelf *bookInfo;
@property (readonly, nonatomic) MXRBookSNSDynamicBookContentType bookContentType;
@property (readonly, nonatomic) NSString * bookTagId; // 图书专区ID
@property (readonly, nonatomic) NSString *bookName;
@property (readonly, nonatomic ) NSString *bookStars;
@property (readonly, nonatomic) NSString *bookIconUrl;
@property (readonly, nonatomic) NSString *orderNum; //动态排序字段
@property (readonly, nonatomic) NSNumber *isRecommend; // 是否是推荐动态 （话题页中，推荐动态排在第一位）

@property (readonly, nonatomic , strong) NSMutableArray * topicNameArray; // 需要变蓝色显示话题名称
@property (readonly,assign, nonatomic) MXRSrcMomentStatus srcMomentStatus;
//增加所有图片的总地址
@property (readonly, nonatomic) NSString *totalPicUrl;

@property (readonly, nonatomic) NSString *bookGuid;
@property (readonly, nonatomic) NSMutableArray *localImageArray;
@property (readonly, nonatomic) NSMutableArray <MXRBookSNSUploadImageInfo *> * imageArray; // 动态图片数组

@property (readonly, nonatomic) NSMutableArray *topicIdList;
@property (assign,   nonatomic) CGFloat cellheight;

@property (assign,   nonatomic) CGFloat cellImageheight;
/*点赞详情数组*/
@property (assign, nonatomic) BOOL hasPraised;//对这条动态是否已经点赞
@property (readonly, assign,nonatomic) NSInteger likeCount;
@property(readonly, nonatomic) NSMutableArray <LikeModel*>*likeArray;
/*评论详情数组*/
@property (readonly, assign, nonatomic) NSInteger commentCount;
@property(readonly,nonatomic) NSMutableArray *commentArray; //CommentModel
/*转发详情数组*/
@property (readonly, assign, nonatomic) NSInteger trammitCount;
@property (readonly, nonatomic) NSMutableArray<TransmitModel *> *shareTrammitArray;
@property (assign, nonatomic)SenderType  senderType;
@property (assign, nonatomic)MXRBookSNSMomentStatusType  momentStatusType; // 动态当前发送状态
@property(readonly,nonatomic)  BOOL isMyCompany;//是否自己公司发送的

/*动态下显示的评论*/
@property (readonly, nonatomic, assign) NSInteger commentNum;             //该动态下需要显示的评论数量
@property (readonly, nonatomic, strong) NSMutableArray<MXRSNSCommentModel *> *commentList;      //该动态下需要显示的评论数据
@property (readonly, nonatomic, assign) NSInteger sort;  //推荐插入的排序数字
@property (nonatomic, assign) MXRBookSNSDynamicType dynamicType;
/* 专区ID */
@property (nonatomic, strong) NSString *contentZoneId;
/* 专区名称 */
@property (nonatomic, strong) NSString *contentZoneName;
/* 专区封面 */
@property (nonatomic, strong) NSString *contentZoneCover;

/**
 问答ID
 */
@property (nonatomic, copy) NSString *qaId;

-(void)refreShreTypeOrDefaultType:(MXRSNSShareModel *)newModel;

/** **/

-(instancetype)createRecommentDataWithDictionary:(NSDictionary *)senderDict;

-(instancetype)createWithDictionary:(NSDictionary *)senderDict;
-(void)momentSendFail;
-(void)momentSendSuss;
-(void)momentUploading;
-(void)likeBtnClick;
-(void)cancleLikeMoment;
-(void)LikeMoment;
-(void)updataMomentLikeCount:(NSInteger )count;
-(void)addMomentComment;
-(void)deleteMomentComment;
-(void)updataMomentCommentCount:(NSInteger )count;
-(void)updataMomentComment:(NSMutableArray<MXRSNSCommentModel *> *)commentList;

-(NSInteger)dynamiclikeCount;
-(void)modelIsDelete;
-(BOOL)getIsRecommendMoment;
-(void)MXRSetMomentId:(NSString*)momentId;
- (void)MXRSetSenderTime:(NSNumber *)senderTime;
//-(void)MXRSetSenderId:(NSString*)senderId;

@end


/*分享图书的model*/
@interface MXRSNSSendModel : MXRSNSShareModel<NSCoding>
-(instancetype)initWithDictionary:(NSDictionary *)senderDict;
@end


/*转发的model*/
@interface MXRSNSTransmitModel : MXRSNSShareModel<NSCoding>
@property (strong, nonatomic) MXRSNSSendModel *orginalModel;
@property (strong, nonatomic)  NSMutableArray <TransmitModel*>*transmitArray;
@property (strong, nonatomic) NSMutableParagraphStyle *tranparagraphStyle;
-(instancetype)initWithDictionary:(NSDictionary *)senderDict;
-(void)orginalModelIsDelete;
//-(void)refreshTransmitTypeModel:(MXRSNSTransmitModel *)newModel;
@end



