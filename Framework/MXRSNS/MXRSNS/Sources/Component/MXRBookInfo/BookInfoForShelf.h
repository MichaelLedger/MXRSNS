//
//  BookInfoForShelf.h
//  HuaShiDa
//
//  Created by jxb on 14-7-30.
//  Copyright (c) 2014年 mxrcorp. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "HttpClient.h"
#import "Enums.h"
//#import "MXRSortableObject.h"
//#import "MXRCheckBookStatusModel.h"
//#import "MXREditorPreviewInfoResponseModel.h"
//#import "MXRAuditDownloadInfoModel.h"
//#import "MXRBookDetailResponseModel.h"
@class MXRBookPaymodeModel;
#define MXR_FILEDOWN_PUBLISHER_TYPE_MXR @"mxr" //

@class AFURLSessionManager;

@interface Page : NSObject <NSCoding>

@property (strong, nonatomic) NSString *pageID;
@property (strong, nonatomic) NSString *pageUrl;

- (id)init;
@end

//@interface FileDown : NSObject <NSCoding>
//
//+(instancetype)fileDownWithDict:(NSDictionary*)dict;
//
//@property (strong, nonatomic) NSString *fileName;
//@property (strong, nonatomic) NSString *fileMD5;
//@property (strong, nonatomic) NSString *fileSize;
////@property (assign, nonatomic) BOOL      isUpdate;
//@property (assign, nonatomic) NSUInteger       index;
//
///*
// *下载方式（lazy），为false时，直接下载文件；为true时，再根据rule的规则下载文件。
// */
//@property (nonatomic) BOOL lazy;
///*
// *下载规则（Rule），为click时，点击下载文件；为nearby时，根据index判断前后文件是否被下载了，如果被下载了，则触发下载动作。
// */
//@property (nonatomic, copy) NSString *rule;
///*
// *规则参数（interval），作用在规则nearby下，表示距离多少区间就触发下载动作。不指定interval，则默认区间为1，即相邻1个位置及触发下载动作。不同的规则有不同的规则参数。
// */
//@property (nonatomic) NSInteger interval;
///*
// * 公共资源库引用（ref），ref的值对应filelist中index的值
// */
//@property (nonatomic, copy) NSString *ref;
//
//
//
//@end



typedef void(^perfectBookInfoSuccess)(id);
typedef void(^perfectBookInfoFail)(PerfectBookInfoFailReason);
typedef enum{
    DIYBook_Exist_Local = 0,
    DIYBook_Exist_Cloud = 1,
    DIYBook_Exist_Both = 2,
} DIYBook_Exist_Status;



@class BookInfoForShelf;

typedef enum bookSourceType{
    BookSource_Default = 0,
    BookSource_Scan
}bookSourceType;


@interface BookInfoForShelf : NSObject <NSCoding,NSCopying>
{
}
- (id)init;
/*
 *解析DIY
 */
-(instancetype)initWithDIYDict:(NSDictionary*)dict;
/*
 *新的解析
 */
-(instancetype)initWithLiteDict:(NSDictionary *)dict;
/**
 book/detail服务的解析
 */
-(instancetype)initWithNewDict:(NSDictionary*)dict;


+(NSDictionary *)dictLiteWithBookInfo:(BookInfoForShelf *)bookInfo;


/**
 出版社用户删除mark

 @param markId 要删除的markId
 */
- (BOOL )publishUserDeleteMarkWithMarkId:(NSString *)markId;
/**
 判断当前mark是否需要显示删除按钮
 分为以下情况：
 1.当前用户是超级用户且当前页面没有被删除过。返回YES
 2.当前用户是超级用户且当前页面已经被删除。返回NO
 3。当前用户不是超级用户。返沪NO
 @param markId 当前markId
 */
- (BOOL )judgeCurrentUserCanDeleteMarkWithMarkId:(NSString *)markId;

/**
 判断当前mark 上面热点是否已经被删除
 @param markId markId
 */
- (BOOL )checkCurrentMarkHasDeletedWithMarkId:(NSString *)markId;

-(void)needUpdateResourceList;


//图书来源
@property (nonatomic, assign) bookSourceType sourceType;
//==================预览信息
@property (nonatomic, copy) NSString          *bookBarcode;               //一维码
@property (nonatomic, copy) NSString          *BookMailUrl;               //图书购买地址
@property (nonatomic, copy) NSString          *BookDesc;                  //图书描述  DB
/*
 modify ----- 5.6.0
 */
@property (nonatomic, assign) NSInteger       qaId;                       //问答id
/*
 Modify+-----2015.07.16
 **/

@property (nonatomic, copy) NSString          *bookPrice;
//======================下载图书信息
@property (nonatomic, copy) NSString          *bookGUID;                  //全局id DB
@property (nonatomic, copy) NSString          *bookName;                  //图书名称 DB
@property (nonatomic, copy) NSString          *publisher;                 //出版社 DB
@property (nonatomic) NSInteger          publishID;                 //出版社 DB
@property (nonatomic, copy) NSString          *publishUserDeleteMarkId;  // 用来接收服务端返回的用户删除mark的信息（暂定为字符串，以 “ ，”连接） DB （只用于接收服务数据以及存取数据库之用）

@property (nonatomic, strong) NSMutableArray * publishUserDeleteMarkIdArray; // 用来获取用户删除mark的信息 （根据publishUserDeleteMarkId 转换而来 ）

@property (nonatomic, copy) NSString *bookPublisherID; // 出版人id
@property (nonatomic, copy) NSString          *bookIconURL;               //图书封面 DB
@property (nonatomic, assign) signed long long  totalSize;                  //图书总的大小 DB
@property (nonatomic, assign) BOOK_TYPE         bookType;                   //绘本 DB
@property (nonatomic, assign) BOOL downloadByScan; 


//@property (nonatomic, strong) NSMutableArray    *preList;                   //预览下载包  DB
//@property (nonatomic, strong) NSMutableArray    *downList;                  //所有文件下载包  DB
//@property (nonatomic, copy) NSString          *preUrl;                    //前缀下载地址 DB
@property (nonatomic, copy) NSString          *fileListDownloadURL;       //filelist.dat配置文件的下载路径 DB
//@property (nonatomic, strong) NSMutableArray    *updateList;                //增量更新中需要更新的文件列表 DB

//======================图书加锁信息
@property (nonatomic, copy) NSString          *bookSeries;                // 该书所属的系列，用于解锁一个系列的书  DB

//-- jxb 添加图书创建时间 用于图书更新
@property (nonatomic, copy) NSString          *creatTime;                 //图书创建时间  DB
@property (nonatomic, assign) BOOL              isNeedUpdate;              //图书是否需要从服务器上更新  DB
//======================本地业务信息
@property (nonatomic, assign) BOOL                          isDownloaded;               //下载完成标识  DB
//@property (nonatomic, assign) signed long long              downloadedSize;             //已下载图书大小

@property (nonatomic, strong) NSMutableDictionary           *hotspotCount;              //已读热点的数量  DB
@property (nonatomic, strong) NSNumber                      *totalhotspot;              //本书总共热点的数量 DB
//@property (nonatomic, strong) NSNumber                      *isPreview;
@property (nonatomic, strong) NSMutableDictionary           *playedMp3BtnRecord; // DB

@property (nonatomic, copy) NSString                      *bookid;                    //书城里返回的id 用于预览  DB
@property (nonatomic, strong) NSNumber                      *bookIdx;                   //本书排序位置  DB
@property (nonatomic, assign,readonly) DownStateType                 State;                      //本书状态  DB

@property (nonatomic, assign) float                         downProgress;               //图书下载进度信息  DB
@property (nonatomic, assign) BOOL                      isFreeByScan;                //扫码是否免费

//=====================用于判断是否是第一次下载书本，第一次下载的书本需要自动打开
@property (assign, nonatomic) BOOL                          isFirstDownBook;           // 用于判断是否是程序第一次安装时，自动下载的书 YES == > 是 DB
@property (assign, nonatomic) BOOL                          isUserChangedDownState;    // 用户是否手动修改过这本书的状态 YES ==> 修改过 DB

//=====================用于控制打开书籍之后的逻辑
@property (copy, nonatomic) NSString                      *bookReadType;              // （1，点读模式；2，AR模式） DB


//zjs=======  认知卡 解锁
@property (nonatomic) MXRBookUnlockType unlockType;           // 图书解锁的方式（1,梦想币;2,激活码;3,账号解锁;） DB
@property (nonatomic) MXRBookUnlockType ivar_unlockType;
@property (nonatomic,copy) NSString *lockedPage;           // //如果无加锁页面，则返回空字符，如果有加锁，则返回加锁的页码，如"p02" DB


//2015/9/25
@property (nonatomic,strong) NSNumber *propertyId;
@property (nonatomic,strong) NSNumber *downloadTimes; // 下载次数
@property (nonatomic,strong) NSNumber *bookReadTimes;
@property (nonatomic,strong) NSNumber *Praise;
@property (nonatomic,strong) NSNumber *appIsNeedUpdate; // 程序是否需要更新，才能使用此书, 1表示可下载
@property (nonatomic) NSInteger IsNeedShowPublisherInfo;
@property (nonatomic,strong) NSNumber *star; // 星 DB
@property (nonatomic,copy) NSString *MAS_FullName; // 作者名  DB
@property (nonatomic,copy) NSString *bookTagList; // DB
@property (nonatomic,copy) NSString *bookListID; // DB

@property (nonatomic,strong) NSNumber *SurplusUnlockTimes; // 剩余的可下载次数
@property (nonatomic,strong) NSNumber *codeID; // 激活码id  DB

// 2016/3/2 为diy图书上传添加
@property (nonatomic) MXRBookUploadState bookStatus; // 0 下架，1正常，2审核中  DB
@property (nonatomic, copy) NSString *bookUnderCause; // 下架的原因
@property (nonatomic,assign) DIYBook_Exist_Status diyBookExistStatus;
@property (nonatomic,assign) MXRBookZipState diyZipState; // diy图书的压缩状态 DB
@property (nonatomic,copy) NSString *diyGroup; // 分为普通和金钥匙 //已不用2018.4.12
@property (nonatomic) MXRBookUploadSource bookSource;
@property (nonatomic) MXRDiyBookAuthorType diyBookAuthorType;

/***** 魔镜购买记录 *****/
@property (nonatomic) BOOL isBookInfoHasSend;  // DB


/**不需要写入数据库**/
/***** 自定义添加的********/
@property (nonatomic,strong,readonly) NSArray *bookTags;
@property (nonatomic,strong,readonly) NSArray *bookListIDs;
@property (nonatomic, strong) NSArray *PreViewPagePic;            //预读图片

//  图书详情 评论总数、赞总数
@property (nonatomic, assign) NSInteger  bookCommentCount;
@property (nonatomic, assign) NSInteger  bookPraiseCount;
@property (nonatomic, strong) AFURLSessionManager *afSessionManager;

/**图书使用状态**/

/*
 * bookStatus	short	图书需要处理的状态
 */
//@property (nonatomic) MXRBookUseStatus bookUseStatus;
/*
 * appDownloadPath	string	APP下载地址
 */
@property (nonatomic, copy) NSString *appDownloadPath;

/*
 * deleteBookReason	string	删除原因
 */
@property (nonatomic, copy) NSString *deleteBookReason;
//   图书类别
//@property (nonatomic, copy) NSString *bookCategory;
/*
 *图书新类型 (AR 墨镜 点读书 认知卡 彩蛋)
 */
@property (nonatomic, assign) MXRBookStoreBookIconType  bookCategory;

/// 5.2.2 付费增加的限时优惠和限时免费
@property (nonatomic, strong) MXRBookPaymodeModel  *bookPaymode;

// 5.9.4 是否在专区中购买 add by liulong
@property (nonatomic, assign) BOOL bookBelong;
// V5.13.0 M by liulong 是否是vip图书
@property (nonatomic, assign) BOOL vipFlag;
// V5.15.0 M by liulong 是否在课程中购买后免费的书籍
@property (nonatomic, assign) BOOL isInPurchaseCourse;

/**
 绑定的课程ID V5.15.0 by MT.X
 */
@property (nonatomic, assign) NSUInteger courseId;

//****不需要存入数据库****//
@property (nonatomic, copy) NSArray *normalResourceList;
@property (nonatomic, copy) NSArray *previewResourceList;
//end ****不需要存入数据库****//
@end

@interface BookInfoForShelf(QRCode)

-(BookInfoForShelf *)parseQRCodeDiyBookInfoByDiyBookDict:(NSDictionary *)dict;


@end



@interface BookInfoForShelf (Ex)

/**
 判断是不是美慧树图书，美慧树图书需要登录美慧树账号才可使用它
 
 @return YES表示是美慧树的书
 */
-(BOOL)isMeiHuiShuBook;

/**
 *  合并DIY图书本地和服务器信息
 *
 *  @param localBook  <#localBook description#>
 *  @param serverBook <#serverBook description#>
 */
+(void)mergeDiyLocalBook:(BookInfoForShelf**)localBook serverBook:(BookInfoForShelf *)serverBook;

-(void)updateWithBook:(BookInfoForShelf*)newBook;


/*
 *  检测tag是否是本书
 */
-(BOOL)checkBookWithTag:(NSString*)tag;
/*
 *  检测listID是否是本书
 */
//-(BOOL)checkBookWithListID:(NSString*)ListID;

/**
 *  修改创建时间
 */
-(void)updateCreateTime;

/**
 *  最新编辑时间的降序排序
 *
 *  @param books <#books description#>
 *
 *  @return <#return value description#>
 */
+(NSArray*)sortBookByEditTimeDescWithBooks:(NSArray*)books;

/**
 *  判断是否是预览书
 *
 *  @return <#return value description#>
 */
-(BOOL)checkIsPreViewBook;

/**
 根据bookstate转换成download state
 */

-(MXRDownloadButtonState)getDownloadState;

@end



#pragma mark - 解锁相关
@interface BookInfoForShelf(unLock)

/**
 判断当前markid(P05)是否锁住
 */
-(BOOL)checkIsLockWithMarkId:(NSString *)markId;

/**
 获取锁住的index
 */
-(NSInteger)lockIndexWithMarkArray:(NSArray*)markArray;

/*
 *在书城上是否需要加锁
 */
-(BOOL)checkIsUnLockAtBookStore;

/*
 * 检测购买记录
 */
-(BOOL)checkBuyHistoryWithBookGUID;

/*
 *  获取拼图的书是否激活
 */
- (void)checkActiveCodeBookActivedWithCallBack:(void(^)(BOOL))callBack;

/**
 *  检测是否已经激活
 *
 *  @param callBack <#callBack description#>
 */
- (void)checkLocalActiveCodeBookActivedWithCallBack:(void(^)(BOOL))callBack;

-(void)MXRSetDownStateType:(DownStateType)stateType;
@end


#pragma mark - 封面相关的方法
@interface BookInfoForShelf(BookIcon)

/*
 * 获取封面URL
 */
-(NSURL*)bookIconUrlWithData;

/*
 * 尺寸根据分辨率适配的封面118x160
 */
-(NSURL*)bookIconUrlInBookShelfWithData;


/**
 *  获取封面，如果本地不存在，则请求网络
 *  注意：这里获取封面的尺寸为：118x160
 *
 *  @param callback <#callback description#>
 */
-(void)getCoverImageCallBack:(void(^)(UIImage* image))callback;

/**
 *  将指定图片保存为封面
 *
 *  @param image <#image description#>
 */
-(void)saveBookCover:(UIImage*)image;



@end

@interface BookInfoForShelf (Other)

/*
 * 格式化阅读次数
 */
+(NSString*)formateReadTimes:(NSString*)readTimesStr;




@end

@interface BookInfoForShelf (EditPreview)

/**
 解析编辑器预览图书并生成下载列表
 
 @param previewInfo <#previewInfo description#>
 @return <#return value description#>
 */
//+(BookInfoForShelf*)createEditPreviewBookInfoWithPreviewInfo:(MXREditorPreviewInfoResponseModel*)previewInfo;

@end

@interface BookInfoForShelf (AuditBook)

/**
 解析审核图书并生成下载列表
 
 @param previewInfo <#previewInfo description#>
 @return <#return value description#>
 */
//+(BookInfoForShelf*)createAuditBookInfoWithAuditDownloadInfo:(MXRAuditDownloadInfoModel*)auditDownloadInfo;


@end


