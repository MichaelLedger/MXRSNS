//
//  Enums.h
//  huashida_home
//
//  Created by weiqing.tang on 16/2/19.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef Enums_h
#define Enums_h

#define kMXRDefaultButtonType @"default"  // 图书默认的按钮
#define kMXRUGCCustomButtonType @"custom" // 用户添加的ugc
#define kMXRUGCDiyDefaultButtonType @"diy_default" // diy图书作者添加的ugc

/**
 view的显示方式
 */
typedef enum : NSUInteger {
    show_by_default = 0,
    show_by_present = 1,
    show_by_push = show_by_default
} ViewShowType;

typedef NS_ENUM(NSUInteger, MXRViewControllerTransitionType) {
    MXRViewControllerTransitionTypeNone,
    MXRViewControllerTransitionTypePush,
    MXRViewControllerTransitionTypePresent
};

typedef NS_ENUM(NSUInteger, MXRBookUploadSource) {
    MXRBookUploadSourceNormal = 0,// 普通的diy图书
};

// diy图书作者类型
typedef NS_ENUM(NSUInteger, MXRDiyBookAuthorType) {
    MXRDiyBookAuthorTypeUnknow, // 未知
    MXRDiyBookAuthorTypeGuest, // 游客
    MXRDiyBookAuthorTypeUser, // 正式注册的用户
};

/*
 * 用户对书架的操作类型
 */
typedef NS_ENUM(NSUInteger, MXRBookShelfOperationType) {
    MXRBookShelfOperationUnknow,
    MXRBookShelfOperationAdd,
    MXRBookShelfOperationDelete,
    MXRBookShelfOperationUpdate,
    MXRBookShelfOperationChangeSortPos, // 修改位置
};

typedef enum {
    DOWNSTATE_WAITING = 0x00,    // 等待下载
    DOWNSTATE_DOWNING = 0x01,    // 下载中
    DOWNSTATE_PAUSE = 0x02,      // 暂停
    READSTATE_READING = 0x03,    // 读书中，普通图书
    READSTATE_READFINISH = 0x04, // 已读完
    READSTATE_HUIBEN = 0x05,     // 读书中，非普通图书
    READSTATE_PRE = 0x06,
    READSTATE_UNDEL = 0x07,
    READSTATE_RECENT_DOWNLOAD = 0x08,   // 刚下载
    DOWNSTATE_JOINBOOKSHELF = 0x09,     // 添加到书架

    /// 上传
    UPLOADSTATE_WAITING = 0x20,    // 上传等待
    UPLOADSTATE_UPLOADING = 0x21,  // 上传中
    UPLOADSTATE_PAUSE = 0x22,      // 上传暂停中
    UPLOADSTATE_REVIEW = 0x23,     // 上传完成审核中
} DownStateType;


typedef enum : NSUInteger {
    MXRBookUploadStateUnknow = 100,   // 本地默认值，其他几个值为服务端返回
    MXRBookUploadStateOffShelf = 0,   //  下架
    MXRBookUploadStateOnShelf = 1,    // 正常可阅读
    MXRBookUploadStateOnReview = 2 ,  // 正在审核
    MXRBookUploadStateReviewFail = 3 ,// 审核不通过
} MXRBookUploadState;


typedef enum {
    BOOK_TYPE_NORMAL = 0x00,
    BOOK_TYPE_HUIBEN = 0x01,       //绘本
    //不需添加这个分类    测试的书本
    BOOK_TYPE_PREVIEW = 0x02,
    
    BOOK_TYPE_PINTU = 0x03,
    BOOK_TYPE_CAIDAN = 0x04,       //彩蛋
    
    
    /**认知卡*/
    BOOK_TYPE_COGNIVECARD = 0x05,  //识字卡片//
    BOOK_TYPE_HELP = 0x64,         //帮助界面//
    BOOK_TYPE_QIHUANKAKA = 0x65,   //奇幻类图书//
    BOOK_TYPE_ZHOUZHUANG = 0x66,   //周庄类图书//
    BOOK_TYPE_SHIZIDABAIKE = 0x67, //识字卡片-大百科、火箭//
    BOOK_TYPE_SHIZITINGTING = 0x68,//识字卡片-听听//
    
    
    BOOK_TYPE_4D_GLASSES = 0x69,   // 4D 魔镜
    BOOK_TYPE_4D_TIMETABLE = 0x6A, // 4D 课程表
    BOOK_TYPE_SECURITY = 0x6B ,    // 儿童安全
    BOOK_TYPE_DIY = 0x70,          // DIY
    BOOK_TYPE_UPLOAD_DIY = 0xc8
    
} BOOK_TYPE;

/**
 *  图书的压缩状态
 */
typedef NS_ENUM(NSUInteger, MXRBookZipState) {
    /**
     *  <#Description#>
     */
    MXRBookZipStateUnZip = 0,
    /**
     *  等待压缩
     */
    MXRBookZipStateWaiting = 1,
    /**
     *  压缩中
     */
    MXRBookZipStateZipping = 2,
    /**
     *  压缩完成
     */
    MXRBookZipStateZipped = 3,
};


// 图书解锁的方式（1,梦想币;2,激活码;3,账号解锁;4梦想钻解锁;5梦想币+激活码;6梦想钻+激活码）
typedef NS_ENUM(NSUInteger, MXRBookUnlockType) {
    MXRBookUnlockTypeNone = 0,
    MXRBookUnlockTypeMXRCoin = 1,
    MXRBookUnlockTypeCode = 2,
    MXRBookUnlockTypeAccount =3,
    MXRBookUnlockTypeMXZDiamond=4,
    MXRBookUnlockTypeMXBAndCode=5,
    MXRBookUnlockTypeMXZAndCode=6,
};


typedef enum{
    PerfectBookInfoFail_JSONError = 'jser',
    PerfectBookInfoFail_ReadFileError = 'rfer',
    PerfectBookInfoFail_NetworkError  = '!net',
    PerfectBookInfoFail_CancelError  = 'ccel', // 取消
}PerfectBookInfoFailReason;

typedef enum {
    DE_ACTION_DEFAULT = 0x00,
    DE_ACTION_2D_VIDEO = 0x01,
    DE_ACTION_AUDIO = 0x02,
    DE_ACTION_3D_MODEL = 0x03,
    DE_ACTION_WEBSITE = 0x04,
    DE_ACTION_2D_IMAGE = 0x05,
    DE_ACTION_FACEREC_ANDROID = 0x06,
    DE_ACTION_OFFICE = 0x07,
    DE_ACTION_FACEREC = 0x08,
    DE_ACTION_360_SCENE_IMAGE=0X09,//在离线界面可点击的360的按钮
    DE_ACTION_COMMENT = 0x0b,// ugc批注
    DE_ACTION_JUMP_360_SCENE_IMAGE = 0x0c,//360 跳转按钮
    DE_ACTION_EXIT = 0x0d, // 360 退出按钮
    DE_ACTION_AUTO_READ=0x0e,//认知卡中的自动读按钮
    DE_ACTION_3D_VIDEO = 0x10,
    DE_ACTION_3D_COMMON_MODEL = 0x11, // 公共模型
    DE_ACTION_GAME = 0x12, // 游戏
    DE_ACTION_CUSTOMMODEL = 0x13, //自定义模型(遥控彩蛋)
    DE_ACTION_CLOUDPANORAMA = 0x14, //自定义模型
    DE_ACTION_2D_ANIMATION = 0x15,  //2D动画模型
} CustomBtnType;

typedef enum {
    DE_EVENT_DEFAULT = 0x00,
    DE_EVENT_ZONE = 0x01,
} CustomBtnEventType;



//摄像机状态
typedef NS_ENUM(NSUInteger, MXRCameraState) {
    MXRCameraStateFrontClose,//前置摄像头关闭
    MXRCameraStateFrontOpened,//前置摄像头开启
    MXRCameraStateBackClose,//后置摄像头关闭
    MXRCameraStateBackOpened,//后置摄像头开启
};

/**
 *   用户排名趋势
 */
typedef NS_ENUM(NSInteger , MXRRankChangeType) {
    MXRRankChangeTypeUp,
    MXRRankChangeTypeDown,
    MXRRankChangeTypeNone
};
/**
 *   二维码类型
 */
typedef enum QRType{
    QRTypeOfNormalBook =  0,
    /*Diy图书*/
    QRTypeOfNormalDiy = 1,
    /*一维码*/
    QRTypeOfBarCode = 2,
    /*出版社定制二维码*/
    QRTypeOfPublisherOnly = 3,
    /*不是梦想人的二维码*/
    QRTypeOfNotMXR = 4,
    /*未识别的*/
    QRTypeOfNotFound = 5,
    /*扫一扫绑定渠道码*/
    QRTypeOfBandleChannelCode = 6,
    /*资源商店预览*/
    QRTypeOfResourcePreview = 7,
    /*图书预览二维码*/
    QRTypeOfPreview = 8,
    /*审核二维码*/
    QRTypeOfCheck = 9
}QRType;
/**
 *   用户查看图书详情中评论详情的类型
 */
typedef NS_ENUM(NSUInteger, MXRBookCommentType) {
    /**
     *  不是评论网页
     */
    MXRBookCommentTypeNone,
    /**
     *  对用户评论
     */
    MXRBookCommentTypeToUser,
    /**
     *  查看更多回复
     */
    MXRBookCommentTypeToAll,
    /**
     *  对图书评论
     */
     MXRBookCommentTypeToBook
};
typedef NS_ENUM(NSInteger,ActionSheetType){
    CommentSheet = 1,
    ReportSheet = 2,
};

typedef NS_ENUM(NSUInteger, MXRModelSwitchType){
    MXRModelSwitchTypeDay=0, //1：按扫描日期切换
    MXRModelSwitchTypeTime=1, //0：按扫描次数切换
    MXRARCardTypeZhenCai=2,//2:真彩扫描解锁
    MXRARCardTypeCanBaby=3,//3:蚕宝宝模式
};

typedef NS_ENUM(NSUInteger, MXRARCardType){
    MXRARCardTypeDefault=0, //0：认知卡类型
    MXRARCardTypeCommon=1,//1：通用类型
    
};

//识别类型
typedef NS_ENUM(NSUInteger, MXRARRecognitionType){
    MXRARRecognitionTypeDefault=0, //0：认知卡识别圈类型
    MXRARRecognitionTypeCommon=1,//1：通用识别圈类型
};


typedef NS_ENUM(NSUInteger, AlertViewType) {
    AlertViewType_3G = 1
};

//1内网 2外网测试 3外网正式
typedef NS_ENUM(NSUInteger, MXRARServerType){
    MXRARServerTypeInnerUnknow=0,//未知服务器
    MXRARServerTypeInnerNet=1, //内网(http://192.168.0.125:20000)
    MXRARServerTypeOuterNetTest=2, //外网测试(http://192.168.0.145:20000)(http://47.75.67.198)
    MXRARServerTypeOuterNetFormal=3,//外网正式(https://bs-api.mxrcorp.cn)(https://sl-api.mxrcorp.cn)
    MXRARServerTypeOuterNetFormalReview=4,//外网正式 搜索链接为审核(https://bs-api.mxrcorp.cn)(https://sl-api.mxrcorp.cn)
    MXRARServerTypeOuterNetFormalHTTP=5,//给服务端人员专门抓包测试用的(http://bs-api.mxrcorp.cn)(http://sl-api.mxrcorp.cn)
    MXRARServerTypeOuterNetTestHTTPS=6,//新增外网测试(https://bs-api-test.mxrcorp.cn)
    MXRARServerTypeOuterNetTestHTTP=7,//新增外网测试(http://bs-api-test.mxrcorp.cn)
};

typedef NS_ENUM(NSUInteger, MXRPicSelectType) {
    MXRPicSelectTypeNone,
    MXRPicSelectTypeAddNewPage,
    MXRPicSelectTypeAddUGC,
    MXRPicSelectTypeChangeMark,
};

//送梦想币时  送的原因
typedef NS_ENUM(NSUInteger,promptViewType)
{
    FirstLuanch,
    Upgrade,
    LoginSuccess,
    RegisterSuccess,
    Common
};


//消息 上一次所选中的按钮

typedef NS_ENUM(NSUInteger,LastSelectedBtn)
{
    LastIsLetter,
    LastIsComment,
    LastIsNotification,
    LastIsNotFound
};

typedef NS_ENUM(NSUInteger,CurrentSelectBtn)
{
    CurrentIsLetterBtn,
    CurrentIsCommentBtn,
    CurrentIsNotificationBtn
};
//私信界面 scrollview 的类型
typedef NS_ENUM(NSUInteger , ChatScrollVeiwType)
{
    TYPE_Browser = 1,
    TYPE_Browser_Left,
    TYPE_Browser_Center,
    TYPE_Browser_Right,
    TYPE_TableView
    
};
//私信用户上传图片 状态
typedef NS_ENUM(NSUInteger , ChatSelfImageStatus)
{
    Status_Ready,
    Status_Laoding,
    Status_Complete,
    Status_None
};
//私信删除消息类型
typedef NS_ENUM(NSUInteger , ChatDeleteMessageType)
{
    Delete_All = 10,
    Delete_Single
};

/**
 *  用户更改信息类型
 */
typedef NS_ENUM(NSUInteger,UserInfoChangeType) {
    /**
     *  <#Description#>
     */
    UserInfoChangeTypeSex,
    /**
     *  <#Description#>
     */
    UserInfoChangeTypeAge,
    /**
     *  <#Description#>
     */
    UserInfoChangeTypeClass
};
/**
 *  现在离某天是否超过一天
 */
typedef NS_ENUM(NSUInteger, CurrentDayBeyoundSomeDayType) {
    /**
     *  刚好一天
     */
    CurrentDayBeyoundSomeDayTypeOneDay,
    /**
     *  少于一天（相等）
     */
    CurrentDayBeyoundSomeDayTypeleastOneDay,
    /**
     *  大于一天
     */
    CurrentDayBeyoundSomeDayTypeBeyoundOneDay
};

/**
 搜索话题 搜索框的状态
 */
typedef NS_ENUM(NSInteger, SearchTextFieldStatus) {
//正常状态
    SearchTextFieldStatus_Normal = 1,
//第一响应者
    SearchTextFieldStatus_FirstRegister = 2
};

//外部网页 打开APP的枚举
typedef  enum OpenAppType{
    OpenAppTypeOfShareDefault       = 0,    // 默认类型
    OpenAppTypeOfShareTopic         = 1,    // 话题
    OpenAppTypeOfShareNotification  = 2,    // 通知
    OpenAppTypeOfShareLetter        = 3,    // 私信
    OpenAppTypeOfBookDetail         = 4,    // 图书详情
    OpenAppTypeOfQuestionAnswer     = 5,    // 问答
}OpenAppType;


typedef NS_ENUM(NSInteger,KUnityState){
    KUnityStateClose = 1,
    KUnityStateStart = 2,
    KUnityStatePause = 3
};


typedef NS_ENUM(NSInteger,KJPushType){
    KJPushTypeUnknow =0,//未知
    KJPushTypeFormal=1,//正式
    KJPushTypeTest=2 //测试
};

/*
 * 图书icon的类型
 */
typedef NS_ENUM(NSUInteger, MXRBookStoreBookIconType) {
    MXRBookStoreBookItemTypeUnknow = 0,
    MXRBookStoreBookItemTypeColorEgg = 1, // 彩蛋
    MXRBookStoreBookItemTypeDraw = 2, // 绘本
    MXRBookStoreBookItemTypeGlass = 3, // 魔镜
    MXRBookStoreBookItemTypeARBook = 4, // ar图书
    MXRBookStoreBookItemTypeNormal = 5, // 点读书
    MXRBookStoreBookItemTypeDIY = 8     // DIY
};

typedef NS_ENUM(NSInteger,GetLetterListStatus){
    GetLetterList_Requesting = 0,//未知
    GetLetterList_Success = 1,//正式
    GetLetterList_Fail = 2 //测试
};

typedef enum : NSUInteger {
    MXRDownloadButtonStateCanRead = 0x00, // 下载完成
    MXRDownloadButtonStateWaiting = 0x01, // 等待
    MXRDownloadButtonStateDownloading = 0x02, // 下载中
    MXRDownloadButtonStateCanDownload = 0x03, // 可下载
    MXRDownloadButtonStateNeedUpdate = 0x04, // 需要更新
    MXRDownloadButtonStatePause = 0x05, // 暂停
    MXRDownloadButtonStateOnBookShelf = 0x06, // 添加到书架的书，可下载
    MXRDownloadButtonStateRecentDownload = 0x07, // 最新下载的图书，可阅读
    
    MXRDownloadButtonStateUploadWaiting = 0x20, // 上传等待中
    MXRDownloadButtonStateUploading = 0x21,    // 上传中
    MXRDownloadButtonStateUploadPause = 0x22, // 上传暂停中
    MXRDownloadButtonStateUploadReview = 0x23, // 上传完成审核中
    MXRDownloadButtonStateNeedUpload = 0x24,    // 需要上传，可阅读
    
    MXRDownloadButtonStateZipping = 0x30 // 压缩中
} MXRDownloadButtonState;

typedef enum : NSUInteger {
    MXRShowMarkAnimationTypeNone,       // 离线阅读中显示mark的效果
    MXRShowMarkAnimationTypeFlip,
    MXRShowMarkAnimationTypeMove
} MXRShowMarkAnimationType;

/**
 知识树做题页面根据题目字数来调整字数大小
 */
typedef NS_ENUM(NSInteger, MXRQeustionCssStyle)
{
    MXRQeustionStyleCssNomal = 0 , // 题目超过26个字
    MXRQuestionStyleCssSmall
};


typedef NS_ENUM(NSUInteger, MXRAudioStatus) {
    MXRAudioStatusStop = 0,
    MXRAudioStatusStartPlay = 1,
    MXRAudioStatusPause = 2,
};




/*
 扫一扫界面ActionClick返回的unity定义的按钮类型
 btnType
 0 video
 1 audio
 2 model
 3 links
 4 image
 5 3dvideo
 */

typedef NS_ENUM(NSUInteger, MXRUnityButtonType){
    MXRUnityButtonTypeVideo = 0,
    MXRUnityButtonTypeAudio = 1,
    MXRUnityButtonTypeModel = 2,
    MXRUnityButtonTypeLinks = 3,
    MXRUnityButtonTypeImage = 4,
    MXRUnityButtonType3DVideo = 5,
    MXRUnityButtonTypeUGC     = 100,//这个是我们自己增加的UGC按钮
};


/**
 表示做题的类型。 从那种入口进入做题的
 - MXRDoExerciseTypeNormal: 一般点读书做题
 - MXRDoExerciseTypeCanbaby: 蚕宝宝做题
 */
typedef NS_ENUM(NSUInteger, MXRDoExerciseEntranceType){
    MXRDoExerciseEntranceTypeNormal = 0,
    MXRDoExerciseEntranceTypeCanbaby = 1,
};


typedef NS_ENUM (NSInteger,MXRSelctImageOperationType){
    //私信
    MXRSelctImageOperationTypeChatView = 0,
    //分享
    MXRSelctImageOperationTypeShare    = 1,
    //梦想圈
    MXRSelctImageOperationTypeBookSNS  = 2,
    // DIY
    MXRSelctImageOperationTypeDIY      = 3
};



// 图书下载解锁的方式（1,梦想币;2,激活码;3,账号解锁;4梦想钻解锁）
typedef NS_OPTIONS(NSUInteger, MXRBookDownLoadLockType) {
    MXRBookDownLoadLockTypeNone         = 1,                    // 无锁
    MXRBookDownLoadLockTypeActivityFree = 1 << 5,               // 限时免费 无锁
    MXRBookDownLoadLockTypeDreamCoin    = 1 << 1,               // 梦想币锁
    MXRBookDownLoadLockTypeCode         = 1 << 2,               // 激活码锁
    MXRBookDownLoadLockTypeAccount      = 1 << 3,               // 账号锁 需要登录美慧树账号
    MXRBookDownLoadLockTypeDreamDiamond = 1 << 4,               // 梦想钻锁
    MXRBookDownLoadLockTypeActivityBargainPrice = 1 << 6,       // 限时特价锁
    MXRBookDownLoadLockTypeActivityCode = 1 << 7,               // 活动激活码

    MXRBookDownLoadLockTypeError        = 1 << 15               // 出现错误无法下载
};

// 图书下载解锁的方式（1,梦想币;2,激活码;3,账号解锁;4梦想钻解锁）
typedef NS_ENUM(NSUInteger, MXRNewBookDownLoadLockType) {
    MXRNewBookDownLoadLockTypeNone      = 1,               // 无锁
    MXRNewBookDownLoadLockTypeActivityFree ,               // 限时免费 无锁
    MXRNewBookDownLoadLockTypeDreamCoin    ,               // 梦想币锁
    MXRNewBookDownLoadLockTypeCode         ,               // 激活码锁
    MXRNewBookDownLoadLockTypeAccount      ,               // 账号锁 需要登录美慧树账号
    MXRNewBookDownLoadLockTypeDreamDiamond ,               // 梦想钻锁
    MXRNewBookDownLoadLockTypeActivityBargainPrice ,       // 限时特价锁
    MXRNewBookDownLoadLockTypeActivityCode ,               // 活动激活码
    MXRNewBookDownLoadLockTypeActivityCodeAndMXZ,          // 激活码加梦想钻
    MXRNewBookDownLoadLockTypeActivityCodeAndMXB,          // 激活码加梦想币
    MXRNewBookDownLoadLockTypeError                        // 出现错误无法下载
};

typedef NS_ENUM(NSInteger, MXRAccountRechargeType)
{
    MXRAccountRechargeTypeNone,
    MXRAccountRechargeTypeMXB,
    MXRAccountRechargeTypeMXZ
};

// 图书需要的解锁的方式（1,梦想币;2,激活码;3,账号解锁;4梦想钻解锁）  保持与上面一致 ， 不然可能出现bug
typedef NS_OPTIONS(NSUInteger, MXRNewUnLockBookType) {
    MXRNewUnLockBookTypeNone           = 1,                    // 无锁
    MXRNewUnLockBookTypeActivityFree    = 1 << 5,               // 限时免费 无锁
    MXRNewUnLockBookTypeDreamCoin       = 1 << 1,               // 梦想币锁
    MXRNewUnLockBookTypeCode            = 1 << 2,               // 激活码锁
    MXRNewUnLockBookTypeAccount         = 1 << 3,               // 账号锁 需要登录美慧树账号
    MXRNewUnLockBookTypeDreamDiamond    = 1 << 4,               // 梦想砖锁
    MXRNewUnLockBookTypeActivityBargainPrice = 1 << 6,          // 限时特价锁
    MXRNewUnLockBookTypeActivityCode    = 1 << 7,               // 活动激活码
    
    MXRNewUnLockBookTypeError        = 1 << 15               // 出现错误无法解锁
};
// 用户消息回复类型
typedef NS_ENUM(NSInteger ,MXRMessageReplyType){
    MXRMessageReplyTypeNone               = 0,
    
    MXRMessageReplyZanType                = 1,
    MXRMessageReplyZanTypeBook            = 1 << 1,
    MXRMessageReplyZanTypeMoment          = 1 << 2,
    MXRMessageReplyZanTypeEssay           = 1 << 3,
    
    MXRMessageReplyCommentType            = 2,
    MXRMessageReplyCommentTypeBook        = 2 << 4,
    MXRMessageReplyCommentTypeMoment      = 2 << 5,
    MXRMessageReplyCommentTypeEssay       = 2 << 6
};
// 用户消息回复已读未读状态
typedef NS_ENUM(NSInteger, MXRMessageReplyReadType) {

    MXRMessageReplyReadTypeUnKnown = 0,
    MXRMessageReplyReadTypeRead = 2,
    MXRMessageReplyReadTypeUnRead = 1
};
// 图书下载来源
typedef NS_ENUM(NSInteger, MXRDownloadSourceType){
    
    MXROtherDownloadType = 0,                //其他类型图书下载方式                >>> 其他下载 <<<
    MXRBookShelfDownloadType,                //书架页面下载                      >>> 书架下载 <<<
    MXRPurchaseRecordsDownloadType,          //购买记录页面已购图书下载             >>> 购买记录下载 <<<
    MXRSearchListDownloadType,               //搜索列表页面点击下载按钮直接下载图书   >>> 搜索列表按钮下载 <<<
    MXRBookClassficationListDownloadType,    //图书分类列表页点击下载按钮下载        >>> 图书分类列表按钮下载 <<<
    MXRBookFloorListDownloadType,            //楼层列表页点击下载按钮下载           >>> 楼层按钮下载 <<<
    MXRBookPrefectureListDownloadType,       //专区楼层列表页点击下载按钮下载        >>> 专区楼层按钮下载 <<<
    MXRBookFloorToBookDetailDownloadType,    //书城首页各楼层点击封面进入图书详情页后下载图书（除专区楼层）   >>> 楼层下载 <<<
    MXRBookPrefectureToBookDetailDownloadType,//点击专区楼层后点击图书封面          >>> 专区楼层下载 <<<
    MXRSearchListToBookDetailDownloadType,   //搜索关键词进入图书详情页后下载        >>> 搜索页 <<<
    MXRFlipRecommendToBookDetailDownloadType,//点击首屏图书类型弹窗进入图书详情页后下载 >>> 弹窗 <<<
    MXRBannerToBookDetailDownloadType,       //点击图书类型banner进入图书详情页后下载 >>> banner <<<
    MXRMagicLampToBookDetailDownloadType,    //点击图书类型神灯进入图书详情页后下载    >>> 神灯 <<<
    MXRBookSNSToBookDetailDownloadType,      //点击梦想圈动态关联图书进入图书详情页后下载 >>> 梦想圈 <<<
    MXRNotificationRecommendDownloadType,    //点击通知推广中内链图书进入图书详情页后下载 >>> 通知推广 <<<
    MXRPrivateLetterRecommendDownloadType,   //点击私信中推送图书进入图书详情页后下载    >>> 私信 <<<
    MXRBookClassficationToDetailDownloadType,//点击图书分类图书列表进入图书详情页后下载  >>> 图书分类下载 <<<
    MXRActivateCodeDownloadType,             //通过激活码激活下载图书                >>> 激活码 <<<
    MXRQRCodeDownloadType,                   //通过二维码下载图书                   >>> 二维码下载 <<<
    MXRShareBookDownloadType                 //应用外图书分享链接打开应用后下载图书     >>> 分享下载 <<<

};

// 图书分类。图书详情接口中的booktype
typedef NS_ENUM(NSInteger, MXRBookType){
    MXRBookTypeNone = 0,
    MXRBookType4DTalkingBook            =1, // 4D点读     点读书
    MXRBookType4DTeachingBook           =2, // 4D教材     点读书
    MXRBookType4DSchedule               =3, // 4D课程表   新增的一个
    MXRBookType4DColorEgg               =4, // 4D彩蛋     4D彩蛋
    MXRBookType4DKnowledgeCard          =5, // 4D认知卡A   4D认知卡
    MXRBookType4DKnowledgeCardB         =6, // 4D认知卡B   4D认知卡
    MXRBookType4DDrawing                =7, // 4D绘本      绘本
    MXRBookType4DMagicMirror            =8, // 4D魔镜     4D魔镜
    MXRBookType4DFullScene              =9  // 4D全景     4D魔镜
};

// 资源商店中资源类型
// 资源类型，0=通用，1=3D-ios，2=3D-android，3=自定义-ios，4=自定义-andriod，6=视频，7=图片，8=全景 ,
typedef NS_ENUM(NSUInteger, MXRResStoreResourceType) {
    MXRResStoreResourceTypeCommon = 0,
    MXRResStoreResourceType3D_iOS = 1,
    MXRResStoreResourceType3D_android = 2,
    MXRResStoreResourceTypeCustom_iOS = 3,
    MXRResStoreResourceTypeCustom_android = 4,
    MXRResStoreResourceTypeVideo = 6,
    MXRResStoreResourceTypeImage = 7,
    MXRResStoreResourceTypePanorama =8 ,
    
};

#endif /* Enums_h */
