//
//  BookInfoForShelf.m
//  HuaShiDa
//
//  Created by jxb on 14-7-30.
//  Copyright (c) 2014年 mxrcorp. All rights reserved.
//

#import "BookInfoForShelf.h"
//#import "ZipArchive.h"
#import "MXRConstant.h"
#import "MXRBase64.h"
#import "GlobalFunction.h"
#import "NSString+Ex.h"
#import "MXRBase64.h"
//#import "IsLockBook.h"

#import "SDWebImageManager.h"
//#import "MXRPurchaseManager.h"
#import "MXRJsonUtil.h"
//#import "MXRMyDiyBookManager.h"
#import <AFNetworking.h>
#import <objc/message.h>
#import "NSObject+MXRModel.h"
#import "NSString+Ex.h"
#import "MXRLocalResourceManager.h"
//#import "MXRBaseResourceModel.h"
#import "NSObject+MXRModel.h"
//#import "MXRNormalResourceModel.h"
#import "NSString+NSDate.h"


static NSMutableArray *const images;

@implementation Page

- (id)init{
    self = [super init];
    if(self)
    {
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.pageID forKey:@"pageID"];
    [aCoder encodeObject:self.pageUrl forKey:@"pageUrl"];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.pageID = [aDecoder decodeObjectForKey:@"pageID"];
        self.pageUrl = [aDecoder decodeObjectForKey:@"pageUrl"];
    }
    return self;
}
@end
//
//
//@implementation FileDown
//
//
//+(instancetype)fileDownWithDict:(NSDictionary*)dict{
//    return [self mxr_modelWithDictionary:dict];
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [self mxr_modelEncodeWithCoder:aCoder];
//}
//
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    return [self mxr_modelInitWithCoder:aDecoder];
//}
//
//
//-(NSString *)description{
//    NSString *msg;
//
//    msg =  [NSString stringWithFormat:@"%p, fileName:%@, fileMD5:%@", self, self.fileName, self.fileMD5];
//    
//    
//    return msg;
//}
//
//
//@end


@interface BookInfoForShelf()

@end
#define PublishUserDeleteMarkId @"deletedPageNos"
#define SeparatePublishUserDeleteMarkId @","
@implementation BookInfoForShelf
@synthesize unlockType = _unlockType;


- (id)init{
    self = [super init];
    if(self)
    {
        self.isDownloaded = FALSE;//是否已经下载
        self.totalhotspot = @0;
        self.hotspotCount = [NSMutableDictionary dictionary];
        self.playedMp3BtnRecord = [[NSMutableDictionary alloc] init];
        self.isNeedUpdate = FALSE;
        self.downProgress = 0.0f;
        self.publishUserDeleteMarkIdArray = [NSMutableArray array];
    }
    return self;
}

-(void)setIsNeedUpdate:(BOOL)isNeedUpdate{
    _isNeedUpdate = isNeedUpdate;
}

-(NSString*)fileListDownloadURL{
    return REPLACE_HTTP_TO_HTTPS(_fileListDownloadURL);
}

-(NSString*)bookIconURL{
    return REPLACE_HTTP_TO_HTTPS(_bookIconURL);
}

#define MXRAutoDict(arg1,arg2,arg3) [];
-(instancetype)initWithDIYDict:(NSDictionary*)dict
{
    self = [self init];
    if (self) {
        self.bookGUID = [dict objectForKey:@"bookGUID"];
        self.bookName = [dict objectForKey:@"bookName"];
        if ([dict objectForKey:@"bookStatus"] && [dict objectForKey:@"bookStatus"] != [NSNull null]) {
            self.bookStatus = [[dict objectForKey:@"bookStatus"] integerValue];
        }
        self.bookUnderCause = [dict objectForKey:@"bookUnderCause"];
        self.MAS_FullName = [dict objectForKey:@"bookPublisherName"];
        if ([dict objectForKey:@"bookSize"] && [dict objectForKey:@"bookSize"] != [NSNull null]) {
            self.totalSize = [[dict objectForKey:@"bookSize"] longLongValue];
        }
        self.bookIconURL = [dict objectForKey:@"bookCoverURL"];
        self.fileListDownloadURL = [dict objectForKey:@"bookFileList"];
        
        if ([dict objectForKey:@"bookPublisherID"] && [dict objectForKey:@"bookPublisherID"] != [NSNull null]) {
            self.publishID = [[dict objectForKey:@"bookPublisherID"] integerValue];
            self.bookPublisherID = autoString([dict objectForKey:@"bookPublisherID"]);
        }
        if ([dict objectForKey:PublishUserDeleteMarkId] && [dict objectForKey:PublishUserDeleteMarkId] != [NSNull null]){
            self.publishUserDeleteMarkId = autoString([dict objectForKey:PublishUserDeleteMarkId]);
        }
        if ([dict objectForKey:@"bookType"] && [dict objectForKey:@"bookType"] != [NSNull null]) {
            self.bookType = (BOOK_TYPE)[[dict objectForKey:@"bookType"] integerValue];
        }
        self.creatTime = [dict objectForKey:@"bookCreateTime"];
        self.bookIdx = [NSNumber numberWithUnsignedLongLong:[[NSDate date] timeIntervalSince1970]];
        NSString *tagList = [dict objectForKey:@"bookTagList"];
        if (!tagList) {
            self.bookTagList = [NSString stringWithFormat:@"%i",DIY_BOOK_TAG];
        }else{
            self.bookTagList = tagList;
        }
        self.bookSource = [[dict objectForKey:@"bookSource"] integerValue];
        self.bookCategory=autoInteger([dict objectForKey:@"bookCategory"]);
         self.bookReadType = [dict objectForKey:@"bookReadType"]?[NSString stringWithFormat:@"%@",[dict objectForKey:@"bookReadType"]]:nil;
    }
    return self;
}

#pragma mark  新的解析
-(instancetype)initWithLiteDict:(NSDictionary *)dict{
    self = [self init];
    if (self) {
        self.bookGUID = [dict objectForKey:@"bookGUID"];
        self.bookIconURL = [dict objectForKey:@"bookCoverURL"];
        self.bookName = [dict objectForKey:@"bookName"];
        self.totalSize = [[dict objectForKey:@"bookSize"] longLongValue];
        self.MAS_FullName = [dict objectForKey:@"publisherName"];
        self.BookDesc = [dict objectForKey:@"bookDESC"];
        self.unlockType = [[dict objectForKey:@"bookUnlockType"] integerValue];
        self.SurplusUnlockTimes = [dict objectForKey:@"surplusUnlockTimes"];
        self.fileListDownloadURL = [dict objectForKey:@"bookFilelistURL"];
        self.creatTime = [dict objectForKey:@"bookCreateTime"];
        self.bookTagList = [dict objectForKey:@"bookTagList"];
        self.bookListID = [dict objectForKey:@"bookListID"];
        self.lockedPage = [dict objectForKey:@"bookLockedPage"];
        self.bookType =  [[dict objectForKey:@"bookType"] intValue];
        self.codeID = [dict objectForKey:@"codeID"];
        self.bookIdx = [NSNumber numberWithUnsignedLongLong:[[NSDate date] timeIntervalSince1970]];
        self.bookCategory=autoInteger([dict objectForKey:@"bookCategory"]);
        self.bookReadType = [dict objectForKey:@"bookReadType"]?[NSString stringWithFormat:@"%@",[dict objectForKey:@"bookReadType"]]:nil;
        if ([dict objectForKey:PublishUserDeleteMarkId] && [dict objectForKey:PublishUserDeleteMarkId] != [NSNull null]){
            self.publishUserDeleteMarkId = autoString([dict objectForKey:PublishUserDeleteMarkId]);
        }
    }
    return self;
}

#pragma mark - book/detail服务的解析
-(instancetype)initWithNewDict:(NSDictionary*)dict{
    self =[self init];
    if (self) {
//        self.bookCategory = autoString([dict objectForKey:@"bookCategory"]);
        self.bookGUID = autoString([dict objectForKey:@"bookGUID"]);
        self.bookIconURL = autoString([dict objectForKey:@"bookCoverURL"]);
        self.creatTime = autoString([dict objectForKey:@"bookCreateTime"]);
        self.BookDesc = autoString([dict objectForKey:@"bookDESC"]);
        self.downloadTimes = autoNumber([dict objectForKey:@"bookDownloadTimes"]);
        self.bookReadTimes = autoNumber([dict objectForKey:@"bookReadTimes"]);
        self.bookCommentCount = [autoNumber([dict objectForKey:@"bookCommentCount"]) integerValue];
        self.fileListDownloadURL = autoString([dict objectForKey:@"bookFileList"]);
        self.lockedPage = autoString([dict objectForKey:@"bookLockedPage"]);
        self.BookMailUrl = autoString([dict objectForKey:@"bookMailURL"]);
        self.bookName = autoString([dict objectForKey:@"bookName"]);
        self.bookPraiseCount = [autoNumber([dict objectForKey:@"bookPraiseCount"]) integerValue];
        self.bookPrice = autoString([dict objectForKey:@"bookPrice"]);
        self.publishID = [autoNumber([dict objectForKey:@"pressId"]) integerValue];
        self.bookPublisherID = autoString([dict objectForKey:@"bookPublisherID"]);
        if ([dict objectForKey:PublishUserDeleteMarkId] && [dict objectForKey:PublishUserDeleteMarkId] != [NSNull null]){
            self.publishUserDeleteMarkId = autoString([dict objectForKey:PublishUserDeleteMarkId]);
        }
        self.publisher = autoString([dict objectForKey:@"bookPublisherName"]);
        self.totalSize =  [autoNumber([dict objectForKey:@"bookSize"]) longLongValue];
        self.star = autoNumber([dict objectForKey:@"bookStar"]);
        self.bookType = [autoNumber([dict objectForKey:@"bookType"]) integerValue];
        self.unlockType = [autoNumber([dict objectForKey:@"bookUnlockType"]) integerValue];
        self.IsNeedShowPublisherInfo = [autoNumber([dict objectForKey:@"isNeedShowPublisherInfo"]) integerValue];
        self.Praise = autoNumber([dict objectForKey:@"bookStarClickNum"]);
        self.bookCategory=autoInteger([dict objectForKey:@"bookCategory"]);
        NSInteger judge = autoInteger(dict[@"isFreeByScan"]);
        if (judge == 0) {
            self.isFreeByScan = NO;
        }else{
            self.isFreeByScan = YES;
        }
        self.bookReadType = [dict objectForKey:@"bookReadType"]?[NSString stringWithFormat:@"%@",[dict objectForKey:@"bookReadType"]]:nil;
        self.bookSeries = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bookSeries"]?[dict objectForKey:@"bookSeries"]:@""];
        
        // 默认为正常
        self.bookStatus =  MXRBookUploadStateOnShelf;
        //5.6.0  新加字段
        self.qaId = autoIntegerWithDefaultValue(dict[@"qaId"],0);
        // 5.9.4 专区购买 by liulong
        self.bookBelong = (autoIntegerWithDefaultValue(dict[@"bookBelong"], 0) == 1);

        // V5.13.0 M by liulong 是否是vip图书
        self.vipFlag = [dict[@"vipFlag"] boolValue];
        // V5.15.0 M by liulong 是否在课程中购买后免费的书籍
        self.isInPurchaseCourse = [dict[@"isInPurchaseCourse"] boolValue];
        
        self.courseId = [dict[@"courseId"] integerValue];
    }
    return self;
}

-(void)setPublishUserDeleteMarkId:(NSString *)publishUserDeleteMarkId{
    _publishUserDeleteMarkId = publishUserDeleteMarkId;
}

#define BookSeries @"BookSeries"
#define BookName @"BookName"
#define BarCode @"BarCode"
#define Publisher @"Publisher"
#define BookIconURL @"bookIconURL"
#define TotalSize @"TotalSize"
#define UnlockType @"unlockType"
#define BookType @"BookType"
#define CreateDate @"CreateDate"
#define MarkersURL @"MarkersURL"
#define OthersURL @"OthersURL"
#define ReadThrough @"ReadThrough"
#define BookModels @"BookModels"
#define ModelURL @"ModelURL"
#define BookGUID @"BookGUID"

#define BiNameComponent(arg) [NSString stringWithFormat:@"UserPicture/%@",arg]


+(NSDictionary *)dictLiteWithBookInfo:(BookInfoForShelf *)bookInfo{
    
    if (!bookInfo.bookGUID) {
        return nil;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:bookInfo.bookGUID forKey:@"bookGUID"];
    [dict setValue:bookInfo.bookIconURL?bookInfo.bookIconURL:@"" forKey:@"bookCoverURL"];
    [dict setValue:bookInfo.bookName?bookInfo.bookName:@"" forKey:@"bookName"];
    [dict setValue:[NSNumber numberWithLongLong:bookInfo.totalSize] forKey:@"bookSize"];
    [dict setValue:bookInfo.MAS_FullName?bookInfo.MAS_FullName:@"" forKey:@"publisherName"];
    [dict setValue:bookInfo.BookDesc?bookInfo.BookDesc:@"" forKey:@"bookDESC"];
    [dict setValue:[NSNumber numberWithInteger:bookInfo.unlockType] forKey:@"bookUnlockType"];
    [dict setValue:bookInfo.SurplusUnlockTimes?bookInfo.SurplusUnlockTimes:@"" forKey:@"surplusUnlockTimes"];
    [dict setValue:bookInfo.fileListDownloadURL?bookInfo.fileListDownloadURL:@"" forKey:@"bookFilelistURL"];
    [dict setValue:bookInfo.creatTime?bookInfo.creatTime:@"" forKey:@"bookCreateTime"];
    [dict setValue:bookInfo.bookTagList?bookInfo.bookTagList:@"" forKey:@"bookTagList"];
    [dict setValue:bookInfo.bookListID?bookInfo.bookListID:@"" forKey:@"bookListID"];
    [dict setValue:bookInfo.lockedPage?bookInfo.lockedPage:@"" forKey:@"bookLockedPage"];
    [dict setValue:[NSNumber numberWithInt:bookInfo.bookType] forKey:@"bookType"];
    [dict setValue:bookInfo.codeID?bookInfo.codeID:@0 forKey:@"codeID"];
    [dict setValue:[NSNumber numberWithInteger:bookInfo.bookCategory] forKey:@"bookCategory"];
    
    return dict;
}
#pragma mark - 出版社特殊用户相关
- (BOOL )publishUserDeleteMarkWithMarkId:(NSString *)markId{

    if (markId) {
        if (![self.publishUserDeleteMarkIdArray containsObject:markId]) {
            [self.publishUserDeleteMarkIdArray addObject:markId];
            self.publishUserDeleteMarkId = [_publishUserDeleteMarkIdArray componentsJoinedByString:SeparatePublishUserDeleteMarkId];
            return YES;
        }
        return NO;
    }
    return NO;
}

- (BOOL)judgeCurrentUserCanDeleteMarkWithMarkId:(NSString *)markId{
    
    if (markId) {
        BOOL isPublisherManager = [[UserInformation modelInformation] checkUserIsPublishUserWithPublishId:[NSString stringWithFormat:@"%ld",(long)self.publishID]];
        if (isPublisherManager) {
            BOOL currentMarkIsExist = ![self.publishUserDeleteMarkIdArray containsObject:markId]; // 判断当前mark 是否已经被删除，防止重复删除
            if (currentMarkIsExist) {
                return YES;
            }
        }
    }
    return NO;
}
- (BOOL)checkCurrentMarkHasDeletedWithMarkId:(NSString *)markId{

    BOOL currentMarkHasDeleted = NO;
    if (markId) {
         currentMarkHasDeleted = [self.publishUserDeleteMarkIdArray containsObject:markId];
    }
    return currentMarkHasDeleted;
}
#pragma mark - 归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
 
//    unsigned int count=0;
//    Ivar *ivar=class_copyIvarList([self class], &count);
//    for (int i=0; i<count; i++) {
//        Ivar iva=ivar[i];
//        const char *name=ivar_getName(iva);
//        NSString*strName=[NSString stringWithUTF8String:name];
//        id value=[self valueForKey:strName];
//        [aCoder encodeObject:value forKey:strName];
//    }
//    free(ivar);
    
    [self mxr_modelEncodeWithCoder:aCoder];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    
    return [self mxr_modelInitWithCoder:aDecoder];
//    if (self=[super init]) {
//        unsigned int count=0;
//        Ivar *ivar=class_copyIvarList([self class], &count);
//        for (int i=0; i<count; i++) {
//            Ivar iva=ivar[i];
//            const char*name=ivar_getName(iva);
//            NSString *strName=[NSString stringWithUTF8String:name];
//            id value=[aDecoder decodeObjectForKey:strName];
//            if (value) {
//                [self setValue:value forKey:strName];
//            }else{
////                DLOG(@"key value not exist,key=%@",strName);
//            }
//            
//        }
//        free(ivar);
//    }
//    return self;
    
}



-(id)copyWithZone:(NSZone *)zone
{
    return [self mxr_modelCopy];
}

-(NSArray *)bookTags{
    NSArray *array = [self.bookTagList componentsSeparatedByString:@","];
    return array;
}

-(NSArray *)bookListIDs{
    NSArray *array = [self.bookListID componentsSeparatedByString:@","];
    return array;
}


-(NSArray *)PreViewPagePic{
    if (!_PreViewPagePic) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        NSArray *preArray = self.previewResourceList;
        for (MXRBaseResourceModel *preDown in preArray) {
//            if ([preDown.fileName rangeOfString:@"UserPicture/"].length) {
//                [temp addObject:[preDown.fileName substringFromIndex:12]];
//
//            }
        }
        _PreViewPagePic = temp;
    }

    return _PreViewPagePic;
}



/**
 获取出版社特殊用户删除书里mark信息
 */
- (NSMutableArray *)publishUserDeleteMarkIdArray{

    if (!_publishUserDeleteMarkIdArray) {
        _publishUserDeleteMarkIdArray = [NSMutableArray array];
    }
    [_publishUserDeleteMarkIdArray removeAllObjects];
    NSArray * arr = [_publishUserDeleteMarkId componentsSeparatedByString:SeparatePublishUserDeleteMarkId];
    [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && obj.length > 0) {
            [_publishUserDeleteMarkIdArray addObject:obj];
        }
    }];
    return _publishUserDeleteMarkIdArray;
}
/**
 兼容新增的解锁组合 梦想币+激活码 5 ， 梦想钻+激活码 6
 */
- (MXRBookUnlockType)unlockType
{
    if (_unlockType<0) {
        return 0;
    }
    if (_unlockType == MXRBookUnlockTypeMXBAndCode) {
        return MXRBookUnlockTypeMXRCoin;
    }
    else if (_unlockType == MXRBookUnlockTypeMXZAndCode)
    {
        return MXRBookUnlockTypeMXZDiamond;
    }
    else
        return _unlockType;
}

- (void)setUnlockType:(MXRBookUnlockType)unlockType
{
    _unlockType = unlockType;
}

+(NSArray *)mxr_exceptEncodeKeys{
    return @[@"normalResourceList",@"previewResourceList"];
}

#pragma mark ---


//+ (nullable NSDictionary<NSString *, id> *)mxr_modelContainerPropertyGenericClass{
//    return @{@"normalResourceList":[MXRNormalResourceModel class], @"_previewResourceList":[MXRBaseResourceModel class]};
//}

@synthesize normalResourceList = _normalResourceList;
-(NSArray *)normalResourceList{
    if (!_normalResourceList) {
        NSArray *array = [MXRLocalResourceManager bookNormalResourcesWithBookGUID:self.bookGUID];
        _normalResourceList = array;
    }
    
    return _normalResourceList;
}

-(void)setNormalResourceList:(NSArray *)normalResourceList{
    _normalResourceList = [normalResourceList copy];
}

-(NSArray *)previewResourceList{
    if (!_previewResourceList) {
        NSArray *array = [MXRLocalResourceManager getPreListWithBookGUID:self.bookGUID];
        _previewResourceList = array;
    }
    return _previewResourceList;
}

-(void)needUpdateResourceList{
    _previewResourceList = nil;
    _PreViewPagePic = nil;
    _normalResourceList = nil;
}

@end


@implementation BookInfoForShelf (QRCode)

-(BookInfoForShelf *)parseQRCodeDiyBookInfoByDiyBookDict:(NSDictionary *)dict{
    /* 提取书本的基本信息 */
    [self extractionBasicBookInfoFromBookInfoDictWithDiy:dict];
    BookInfoForShelf * t_selfBif = [self copy]; // 直接把self传过去会导致内存泄露
    /* 发送一个通知，告诉其他模块预览资源已经解析完毕 */
    return t_selfBif;
}

/**
 *  从书本信息字典中，提取基本的书本信息  (diy 类型)
 *
 *  @param dict <#dict description#>
 */
-(void) extractionBasicBookInfoFromBookInfoDictWithDiy:(NSDictionary *)dict{
    self.bookGUID = [dict objectForKey:@"bookGUID"];
    self.bookIconURL = [dict objectForKey:@"bookCoverURL"];
    self.totalSize = [[dict objectForKey:@"bookSize"] longLongValue];
    self.bookType = [[dict objectForKey:@"bookType"] intValue];
    self.publishID = [[dict objectForKey:@"bookPublisherID"] integerValue];
    self.bookPublisherID = autoString([dict objectForKey:@"bookPublisherID"]);
    self.publisher = [dict objectForKey:@"bookPublisherName"];
    self.fileListDownloadURL = [dict objectForKey:@"bookFileList"];
    self.creatTime = [dict objectForKey:@"bookCreateTime"];
    self.bookName = [dict objectForKey:@"bookName"];
}

@end

@implementation  BookInfoForShelf (Ex)


/**
 判断是不是美慧树图书，美慧树图书需要登录美慧树账号才可使用它

 @return YES表示是美慧树的书
 */
-(BOOL)isMeiHuiShuBook{
    return self.publishID == 1;
}

/**
 *  合并DIY图书本地和服务器信息
 *
 *  @param localBook  <#localBook description#>
 *  @param serverBook <#serverBook description#>
 */
+(void)mergeDiyLocalBook:(BookInfoForShelf**)localBook serverBook:(BookInfoForShelf *)serverBook{
    if ([(*localBook).bookGUID isEqualToString:serverBook.bookGUID]) {
       // (*localBook).bookName = serverBook.bookName;
        (*localBook).bookStatus = serverBook.bookStatus;
        (*localBook).bookUnderCause = serverBook.bookUnderCause;
        (*localBook).MAS_FullName = serverBook.MAS_FullName;
        (*localBook).totalSize = serverBook.totalSize;
        (*localBook).bookIconURL = serverBook.bookIconURL; // 本地存在的书，封面已本地的为准
        (*localBook).fileListDownloadURL = serverBook.fileListDownloadURL;
        (*localBook).publishID = serverBook.publishID;
        (*localBook).bookPublisherID = serverBook.bookPublisherID;
        (*localBook).bookSource = serverBook.bookSource;
       // (*localBook).creatTime = serverBook.creatTime;
    }
}

-(void)updateWithBook:(BookInfoForShelf *)newBook{
    self.bookCategory = newBook.bookCategory;
    self.bookCommentCount = newBook.bookCommentCount;
    self.bookIconURL = newBook.bookIconURL;
    self.creatTime = newBook.creatTime;
    self.BookDesc = newBook.BookDesc;
    self.downloadTimes = newBook.downloadTimes;
    self.fileListDownloadURL = newBook.fileListDownloadURL;
    self.BookMailUrl = newBook.BookMailUrl;
    self.bookName = newBook.bookName;
    self.bookPraiseCount = newBook.bookPraiseCount;
    self.bookPrice = newBook.bookPrice;
    self.lockedPage = newBook.lockedPage;
    self.MAS_FullName = newBook.MAS_FullName;
    self.bookPublisherID = newBook.bookPublisherID;
    self.bookReadTimes = newBook.bookReadTimes;
    self.bookReadType = newBook.bookReadType;
    self.bookSeries = newBook.bookSeries;
    self.star = newBook.star;
    self.Praise = newBook.Praise;
    self.bookType = newBook.bookType;
    self.unlockType = newBook.unlockType;
    self.isFreeByScan = newBook.isFreeByScan;
    self.IsNeedShowPublisherInfo = newBook.IsNeedShowPublisherInfo;
    self.publishID = newBook.publishID;
    self.publishUserDeleteMarkId = newBook.publishUserDeleteMarkId;
    self.publisher = newBook.publisher;
}


-(BOOL)checkBookWithTag:(NSString*)tag{
    
    __block BOOL isContains = NO;
    [self.bookTags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *temp = obj;
        
        if ([temp isEqualToString:tag]) {
            *stop = YES;
            isContains = YES;
        }
    }];

    return isContains;
}

//-(BOOL)checkBookWithListID:(NSString*)ListID{
//
//    __block BOOL isContains = NO;
//    [self.bookListIDs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSString *temp = obj;
//
//        if ([temp isEqualToString:ListID]) {
//            *stop = YES;
//            isContains = YES;
//        }
//    }];
//
//    return isContains;
//}


-(void)setBookPublisherID:(NSString *)bookPublisherID{

    _bookPublisherID = bookPublisherID;
}


-(void)updateCreateTime{
    NSString *createTime = [NSString creatCurrentTimeWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
    self.creatTime = createTime;
}

/**
 *  最新编辑时间的降序排序
 *
 *  @param books <#books description#>
 *
 *  @return <#return value description#>
 */
+(NSArray*)sortBookByEditTimeDescWithBooks:(NSArray*)books{
    NSArray *sortBooks = [books sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        BookInfoForShelf *book1 = obj1;
        BookInfoForShelf *book2 = obj2;
        
        // 防止为空，程序奔溃
        if (![book1.bookIdx isKindOfClass:[NSNumber class]]) {
            book1.bookIdx =[NSNumber numberWithUnsignedLongLong:[[NSDate date] timeIntervalSince1970]];
//            [BookShelfManger saveBook:book1];
        }
        
        if (![book2.bookIdx isKindOfClass:[NSNumber class]]) {
            book2.bookIdx =[NSNumber numberWithUnsignedLongLong:[[NSDate date] timeIntervalSince1970]];
//            [BookShelfManger saveBook:book2];
        }
        
        if ([book1.bookIdx compare:book2.bookIdx] == NSOrderedDescending ) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
        
    }];
    return sortBooks;
}


/**
 *  判断是否是预览书
 *
 *  @return <#return value description#>
 */
-(BOOL)checkIsPreViewBook{
    if ([NSString isBlankString:self.bookIconURL]&&(self.bookType != BOOK_TYPE_UPLOAD_DIY)) {
        return YES;
    }
    return NO;
}


/**
 根据bookstate转换成download state
 */

-(MXRDownloadButtonState)getDownloadState{
    
    MXRDownloadButtonState downloadState= MXRDownloadButtonStateCanRead;
    if (self.State == READSTATE_READING || self.State == READSTATE_READFINISH || self.State == READSTATE_HUIBEN|| self.State == READSTATE_RECENT_DOWNLOAD) {
        //进入阅读
        if(self.isNeedUpdate){
            downloadState = MXRDownloadButtonStateNeedUpdate;
        }
        else{
            downloadState = MXRDownloadButtonStateCanRead;
        }
    }
    else if (self.State == DOWNSTATE_WAITING ) {
        if(self.isNeedUpdate)                    {
            downloadState = MXRDownloadButtonStateNeedUpdate;
        }
        else{
            downloadState = MXRDownloadButtonStateWaiting;
        }
    }
    else if(self.State == DOWNSTATE_DOWNING){
        if(self.isNeedUpdate){
            downloadState = MXRDownloadButtonStateNeedUpdate;
        }else{
            downloadState = MXRDownloadButtonStateDownloading;
        }
    }
    else if(self.State == DOWNSTATE_PAUSE){
        if(self.isNeedUpdate){
            downloadState = MXRDownloadButtonStateNeedUpdate;
        }
        else
        {
            downloadState = MXRDownloadButtonStatePause;
        }
    } else if(self.State == READSTATE_RECENT_DOWNLOAD){
        if(self.isNeedUpdate){
            downloadState = MXRDownloadButtonStateNeedUpdate;
        }
        else
        {
            downloadState = MXRDownloadButtonStateRecentDownload;
        }
    }else if (self.State == DOWNSTATE_JOINBOOKSHELF){
        downloadState = MXRDownloadButtonStateOnBookShelf;
    }
    return downloadState;
}



@end


#pragma mark - 解锁相关
@implementation BookInfoForShelf(unLock)


-(BOOL)checkIsLockWithMarkId:(NSString *)markId{
    
    if (self.bookType == BOOK_TYPE_CAIDAN) {
        return NO;
    }
    
    
    if ([NSString isBlankString:self.lockedPage]) {
        return NO;
    }
    
    NSString *str1 = [self.lockedPage stringByTrimmingWhiteSpace];
    NSString *str2 = [markId stringByTrimmingWhiteSpace];
    // modify by martin 增加NSNumericSearch 需要考虑到数字 ， 不然 9 和  10  比较就是降速了
    NSComparisonResult result = [str1 compare:str2 options:NSCaseInsensitiveSearch | NSNumericSearch];

    return result!=NSOrderedDescending;
}


-(NSInteger)lockIndexWithMarkArray:(NSArray*)markArray{
    __block NSInteger lockIndex = -1;
    @MXRWeakObj(self);
//    [markArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        MarkInfo *mark = obj;
//        NSString *str1 = [selfWeak.lockedPage stringByTrimmingWhiteSpace];
//        NSString *str2 = [mark.markId stringByTrimmingWhiteSpace];
//        if (str1) {
//            // modify by martin 增加NSNumericSearch 需要考虑到数字 ， 不然 9 和  10  比较就是降速了
//            NSComparisonResult result = [str1 compare:str2 options:NSCaseInsensitiveSearch | NSNumericSearch];
//            if (result == NSOrderedSame) {
//                lockIndex = idx;
//                *stop = YES;
//            }
//        }
//    }];
    
    return lockIndex;
}


/*
 * 书是否解锁了
 */
//-(BOOL)checkIsUnLockAtBookStore{
//    // 解锁类型为帐号和 (金币且lockedPage为空)的是上锁的书。
//    // 激活码解锁不需要上锁，下载时直接进入激活页面
//
//    BOOL isUnlock;
//    if([BookShelfManger getBookWithId:self.bookGUID]){
//        // 如果书架上有书
//
//        isUnlock = YES;
//
//    }else if  (([IsLockBook isLockBookKey:self.bookSeries withBookType:self.bookType])||
//               self.unlockType == MXRBookUnlockTypeNone||
//               (![NSString isBlankString:self.lockedPage])||
//               [self  checkBuyHistoryWithBookGUID]||
//               (self.unlockType == MXRBookUnlockTypeCode && [ActiveCodeDatabase isBookActiveState:self.bookGUID]))  {
//        isUnlock = YES;
//
//    }else {
//        // 显示锁
//
//        isUnlock = NO;
//    }
//
//    return isUnlock;
//}


//-(BOOL)checkBuyHistoryWithBookGUID{
//    return [[MXRPurchaseManager defaultManager] checkBookisInPurchaseHistory:self.bookGUID];
//}


/// 获取的书是否激活
//- (void)checkActiveCodeBookActivedWithCallBack:(void(^)(BOOL))callBack
//{
//    /* 从本地获取激活状态 */
//    BOOL isActived = [ActiveCodeDatabase isBookActiveState:self.bookGUID];
//    if ( isActived )
//    {
//        if (callBack) {
//            callBack(YES);
//        }
//
//        return;
//    }
//    if (callBack) {
//        callBack(NO);
//    }
//
//}

//
//- (void)checkLocalActiveCodeBookActivedWithCallBack:(void(^)(BOOL))callBack
//{
//    if (self.unlockType >0) {
//        /* 从本地获取激活状态 */
//        BOOL isActived = [ActiveCodeDatabase isBookActiveState:self.bookGUID];
//        if ( isActived )
//        {
//            if (callBack) {
//                callBack(YES);
//            }
//            return;
//        }else{
//            isActived = [self checkBuyHistoryWithBookGUID];
//            if (callBack) {
//                callBack(isActived);
//            }
//        }
//    }else{
//        if (callBack) {
//            callBack(YES);
//        }
//    }
// 
//}

-(void)MXRSetDownStateType:(DownStateType)stateType{
    //    DLOG(@"setState:%@, old:%i, new:%i",self.bookName,_State, stateType);
    _State = stateType;
    
}

-(void)setState:(DownStateType)State{
    //    DLOG(@"setState:%@, old:%i, new:%i",self.bookName,_State, State);
    if ( State == READSTATE_RECENT_DOWNLOAD) {
        DLOG_METHOD
    }
    _State = State;
    
}

@end

#pragma mark  - 封面相关

@implementation BookInfoForShelf (BookIcon)
/*
 * 获取转换后的封面地址
 */
-(NSURL*)bookIconUrlWithData{
        NSString *newUrl = [self bookIconURLStr];
        return [NSURL URLWithString:[newUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

-(NSURL*)bookIconUrlInBookShelfWithData{
    CGFloat w = 118.f;
    CGFloat h = 160.f;
    NSURL *url = [self bookIconUrlInBookShelfWithDataWithWidth:w heith:h];
    
    return url;
}

-(NSURL*)bookIconUrlInBookShelfWithDataWithWidth:(CGFloat)w heith:(CGFloat)h{
    NSString *newUrl = [self bookIconURLStr];
    newUrl = MXRSmartGetResizePicPath(newUrl, w, h)
    
    return [NSURL URLWithString:[newUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

/**
 *  获取封面
 *
 *  @param callback <#callback description#>
 */
-(void)getCoverImageCallBack:(void(^)(UIImage* image))callback{
    CGFloat w = 118.f;
    CGFloat h = 160.f;
//    [self getCoverImageWithWidth:w heith:h callBack:^(UIImage *image) {
//        if (callback) {
//            callback(image);
//        }
//    }];
}


/**
 *  获取封面
 *
 *  @param callback <#callback description#>
 */
//-(void)getCoverImageWithWidth:(CGFloat)width heith:(CGFloat)height callBack:(void(^)(UIImage* image))callback{
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL *imageURL = [self bookIconUrlInBookShelfWithDataWithWidth:width heith:height];
//        @MXRWeakObj(self);
//        if ([self checkIsPreViewBook]) {
//
//             [self imageCallback:callback image:MXRIMAGE(@"icon_bookcover_preview_cn")];
//
//        } else if(self.bookType == BOOK_TYPE_DIY ||self.bookType == BOOK_TYPE_UPLOAD_DIY){
//
//            [self imageCallback:callback image:MXR_BOOK_ICON_PLACEHOLDER_IMAGE];
//            [[MXRMyDiyBookManager defaultManager] getDiyBookCoverWithBookInfo:self callback:^(UIImage *image) {
//                if (image) {
//                   [selfWeak imageCallback:callback image:image];
//                }
//            }];
//
//        }else{
//
//            NSString *iconName = [NSString stringWithFormat:@"%@/%@/bookIcon.png", Caches_Directory, self.bookGUID];
//            if ([[NSFileManager defaultManager] fileExistsAtPath:iconName]) {
//                UIImage *image = [UIImage imageWithContentsOfFile:iconName];
//                [self imageCallback:callback image:image];
//
//                [SDWebImageManager.sharedManager downloadImageWithURL:imageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                    if (image) {
//
//                        if (SDImageCacheTypeNone == cacheType) {
//                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                                [selfWeak saveBookCover:image];
//                            });
//                            [[SDImageCache sharedImageCache] storeImage:image
//                                                                 forKey:[imageURL absoluteString]
//                                                                 toDisk:YES];
//                        }
//                        [selfWeak imageCallback:callback image:image];
//                    }
//                }];
//
//            }else{
//                [self imageCallback:callback image:MXR_BOOK_ICON_PLACEHOLDER_IMAGE];
//
//                [SDWebImageManager.sharedManager downloadImageWithURL:imageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                    if (image) {
//
//                        if (SDImageCacheTypeNone == cacheType) {
//                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                                [selfWeak saveBookCover:image];
//                            });
//                            [[SDImageCache sharedImageCache] storeImage:image
//                                                                 forKey:[imageURL absoluteString]
//                                                                 toDisk:YES];
//                        }
//
//                        [selfWeak imageCallback:callback image:image];
//                    }
//                }];
//
//            }
//        }
//    });
//}

-(void)imageCallback:(void(^)(UIImage* image))callback image:(UIImage*)image{
    if (callback) {
        dispatch_async(dispatch_get_main_queue(),^{
            callback(image);
        });
    }
}


-(void)saveBookCover:(UIImage*)image{

    NSString *pathsDes= [NSString stringWithFormat:@"%@/%@/bookIcon.png", Caches_Directory, self.bookGUID];
    NSString *paths = [NSString stringWithFormat:@"%@/%@", Caches_Directory, self.bookGUID];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:nil error:nil];
    NSData *dataImage = UIImagePNGRepresentation(image);
    [dataImage writeToFile:pathsDes atomically:NO];
}

-(NSString*)bookIconURLStr{
    NSString *url = self.bookIconURL;
    NSString *newUrl = nil;
    if(([url rangeOfString:@"?"].location != NSNotFound)){
        newUrl = [NSString stringWithFormat:@"%@&%@", url, [MXRConstant mxrReplaceStr:self.creatTime] ];
    }else{
        newUrl = [NSString stringWithFormat:@"%@?%@",url, [MXRConstant mxrReplaceStr:self.creatTime]];
    }
    
    return newUrl;
}


@end


@implementation BookInfoForShelf (Other)

+(NSString*)formateReadTimes:(NSString*)readTimesStr{
    double readTimes = [readTimesStr doubleValue];
    double wanFloatRead = (readTimes/10000.f);
    NSString *formatStr = nil;
    if (wanFloatRead >= 1) {
        formatStr = [NSString stringWithFormat:@"%.1f 万",wanFloatRead];
    }else{
        formatStr = [NSString stringWithFormat:@"%@",readTimesStr?readTimesStr:@"0"];
    }
    
    return formatStr;
}




@end


@implementation BookInfoForShelf (EditPreview)


/**
 解析编辑器预览图书
 
 @param previewInfo <#previewInfo description#>
 @return <#return value description#>
 */
//- (instancetype)initWithEditPreviewData:(MXREditorPreviewInfoResponseModel *)previewInfo {
//    if (self = [self init]) {
//        NSString* guid = previewInfo.bookGuid;
//        if(!guid){
//            return nil;
//        }
//        self.bookGUID          = guid;
//        //self.bookSeries        = autoString([bookInfo objectForKey:BookSeries]) ;
//        self.bookName          = previewInfo.bookName ;
//        self.bookBarcode       = previewInfo.barCode;
//        self.publisher         = previewInfo.publisher;
//        self.bookIconURL       = previewInfo.bookIconUrl;
//        self.totalSize         = [previewInfo.totalSize longLongValue];
//        //  self.unlockType        = autoInteger([bookInfo objectForKey:UnlockType]);
//        self.bookReadType = previewInfo.bookReadType;
//        NSString * bookType   = previewInfo.bookType;
//        if ( bookType.length == 0 ) {
//            self.bookType = BOOK_TYPE_NORMAL;
//        } else {
//            self.bookType = (BOOK_TYPE)[bookType integerValue];
//        }
//        self.creatTime         = previewInfo.createDate;
//
//    }
//    return self;
//}


/**
 解析编辑器预览图书并生成下载列表
 
 @param previewInfo <#previewInfo description#>
 @return <#return value description#>
 */
//+(BookInfoForShelf*)createEditPreviewBookInfoWithPreviewInfo:(MXREditorPreviewInfoResponseModel*)previewInfo{
//    BookInfoForShelf *book = [[BookInfoForShelf alloc] initWithEditPreviewData:previewInfo];
//
//    [MXRLocalResourceManager hanldeEdirPreviewBook:book downloadList:previewInfo.bookModels];
//    return book;
//
//}


@end


@implementation BookInfoForShelf (AuditBook)


/**
 解析编辑器预览图书
 
 @param previewInfo <#previewInfo description#>
 @return <#return value description#>
 */
//- (instancetype)initWithAuditDownloadInfo:(MXRAuditDownloadInfoModel *)auditDownloadInfo {
//    if (self = [self init]) {
//        NSString* guid = auditDownloadInfo.bookGuid;
//        if(!guid){
//            return nil;
//        }
//        self.bookGUID          = guid;
//        //self.bookSeries        = autoString([bookInfo objectForKey:BookSeries]) ;
//        self.bookName          = auditDownloadInfo.bookName ;
//        self.bookBarcode       = auditDownloadInfo.barCode;
//        self.publisher         = auditDownloadInfo.publisher;
//        self.bookIconURL       = auditDownloadInfo.bookIconUrl;
//        self.totalSize         = [auditDownloadInfo.totalSize longLongValue];
//        self.bookReadType      = auditDownloadInfo.bookReadType;
//        //  self.unlockType        = autoInteger([bookInfo objectForKey:UnlockType]);
//        NSString * bookType   = auditDownloadInfo.bookType;
//        if ( bookType.length == 0 ) {
//            self.bookType = BOOK_TYPE_NORMAL;
//        } else {
//            self.bookType = (BOOK_TYPE)[bookType integerValue];
//        }
//        self.creatTime         = auditDownloadInfo.createDate;
//
//    }
//    return self;
//}


/**
 解析审核图书并生成下载列表
 
 @param previewInfo <#previewInfo description#>
 @return <#return value description#>
 */
//+(BookInfoForShelf*)createAuditBookInfoWithAuditDownloadInfo:(MXRAuditDownloadInfoModel*)auditDownloadInfo{
//    BookInfoForShelf *book = [[BookInfoForShelf alloc] initWithAuditDownloadInfo:auditDownloadInfo];
//    [MXRLocalResourceManager hanldeAuditBook:book downloadFilesInfo:auditDownloadInfo.bookModel];
//    return book;
//
//}




@end

