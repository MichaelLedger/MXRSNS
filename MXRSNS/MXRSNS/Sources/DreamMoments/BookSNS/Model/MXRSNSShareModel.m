
//
//  MXRSTShareModel.m
//  huashida_home
//
//  Created by dingyang on 16/9/19.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSNSShareModel.h"
#import <objc/message.h>
#import "NSString+Ex.h"

@implementation TransmitModel

//-(instancetype)initWithUserId:(NSString *)userID WithContent:(NSString *)contentText WithName:(NSString *)contentLastName
//{
//    if (self=[super init]) {
//        _userId=userID;
//        _content=contentText;
//        _name=contentLastName;
//    }
//    return self;
//}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _userId = [aDecoder decodeObjectForKey:userId];
        _content = [aDecoder decodeObjectForKey:content];
        _name = [aDecoder decodeObjectForKey:name];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_userId forKey:userId];
    [aCoder encodeObject:_content forKey:content];
    [aCoder encodeObject:_name  forKey:name];
}
@end


@implementation LikeModel
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _userId = [aDecoder decodeObjectForKey:userId];
        _icon = [aDecoder decodeObjectForKey:icon];
        _name = [aDecoder decodeObjectForKey:name];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_userId forKey:userId];
    [aCoder encodeObject:_icon forKey:icon];
    [aCoder encodeObject:_name forKey:name];
}
@end


@interface MXRSNSShareModel()
@end
@implementation MXRSNSShareModel
#pragma mark - NSCoding
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        Class currentClass = self.class;
        while (currentClass && currentClass != [NSObject class])
        {
            unsigned int count = 0;
            Ivar *ivar = class_copyIvarList(currentClass, &count);
            if (count > 0) {
                for (int i = 0;i < count;i++) {
                    NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar[i])];
                    id value = [aDecoder  decodeObjectForKey:key];
                    if (value) {
                        [self setValue:value forKey:key];
                    }
                }
            }
            currentClass = class_getSuperclass(currentClass);
            free(ivar);
        }
    }
    return  self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    Class currentClass = self.class;
    if (currentClass == NSObject.class) {
        return;
    }
    while (currentClass && currentClass != [NSObject class])
    {
        unsigned int count = 0;
        Ivar *ivar = class_copyIvarList(currentClass, &count);
        if (count>0) {
            for (int i=0;i<count;i++) {
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar[i])];
                [aCoder encodeObject: [self valueForKey:key] forKey:key];
            }
        }
        currentClass = class_getSuperclass(currentClass);
        free(ivar);
    }
}

#pragma mark initWithDictionary
-(instancetype)createWithDictionary:(NSDictionary *)senderDict{
    SenderType  asenderType = autoInteger(senderDict[senderType]);
    
    MXRSNSShareModel *aself;
    if (asenderType == SenderTypeOfDefault || asenderType == SenderTypeOfShare) {
        aself = [[MXRSNSSendModel alloc] initWithDictionary:senderDict];
    }else{
        aself = [[MXRSNSTransmitModel alloc] initWithDictionary:senderDict];
    }
    aself.dynamicType = MXRBookSNSDefaultDynamicType;
    return aself;
}

-(instancetype)createRecommentDataWithDictionary:(NSDictionary *)senderDict{
    SenderType  asenderType = autoInteger(senderDict[senderType]);
    MXRSNSShareModel *aself;
    aself.dynamicType = MXRBookSNSRecommendDynamicType;
    if (asenderType == SenderTypeOfDefault || asenderType == SenderTypeOfShare) {
        aself = [[MXRSNSSendModel alloc] initWithDictionary:senderDict];
    }else{
        aself = [[MXRSNSTransmitModel alloc] initWithDictionary:senderDict];
    }
   
    return aself;
}


-(void)refreShreTypeOrDefaultType:(MXRSNSShareModel *)newModel {
    _senderTime = newModel.senderTime;
    _momentDescription =newModel.momentDescription;
    _momentId = newModel.momentId;
    _bookContentType = newModel.bookContentType;
    _contentZoneId = newModel.contentZoneId;
    _contentZoneName = newModel.contentZoneName;
    _contentZoneCover = newModel.contentZoneCover;
    _bookGuid = newModel.bookGuid;
    _bookIconUrl = newModel.bookIconUrl;
    _bookName = newModel.bookName;
    _bookStars = newModel.bookStars;
    _senderId = newModel.senderId;
    _senderName = newModel.senderName;
    _senderHeadUrl = newModel.senderHeadUrl;
    _senderIconImage = newModel.senderIconImage;
    _likeCount = newModel.likeCount;
    _hasPraised = newModel.hasPraised;
    _senderType = newModel.senderType;
    _commentCount = newModel.commentCount;
    _trammitCount = newModel.trammitCount;
    _clientUuid= newModel.clientUuid;
    _orderNum = newModel.orderNum;
    _srcMomentStatus = newModel.srcMomentStatus;
    _isRecommend = newModel.isRecommend;
    _sort = newModel.sort;
    _dynamicType = newModel.dynamicType;
    _commentNum = newModel.commentNum;
    _commentList = newModel.commentList;
    _imageArray = newModel.imageArray;
    _topicIdList = newModel.topicIdList;
    _isMyCompany = newModel.isMyCompany;
    _qaId = newModel.qaId;
}

-(instancetype)initWithDictionary:(NSDictionary *)senderDict{
    self = [super init];
    if (self) {
        _senderTime = autoNumber(senderDict[senderTime]);
        _momentDescription = autoString(senderDict[momentDescription]);
        _momentId = autoString(senderDict[momentId]);
        _bookContentType = autoInteger(senderDict[bookContentType]);
        if (_bookContentType <= 0) {
            _bookContentType = MXRBookSNSDynamicBookContentTypeSingleBook;
        }
        if (_bookContentType == MXRBookSNSDynamicBookContentTypeMutableBook) {
            _contentZoneId = autoString(senderDict[contentZoneId]);
            _contentZoneName = autoString(senderDict[contentZoneName]);
            _contentZoneCover = [NSString encodeUrlString:REPLACE_HTTP_TO_HTTPS(autoString(senderDict[contentZoneCover]))];
        }else{
            _bookGuid = autoString(senderDict[bookGuid]);
            _bookIconUrl = [NSString encodeUrlString:REPLACE_HTTP_TO_HTTPS(autoString(senderDict[bookIconUrl]))];
            _bookName = autoString(senderDict[bookName]);
            _bookStars = autoString(senderDict[bookStars]);
        }
        
        _vipFlag = [senderDict[@"vipFlag"] integerValue] > 0 ? YES : NO;
        _senderId = autoString(senderDict[userId]);
        _senderName = autoString(senderDict[senderName]);
        _senderHeadUrl = REPLACE_HTTP_TO_HTTPS(autoString(senderDict[senderHeadUrl]));
        _senderIconImage = senderDict[senderIconImage];
        _likeCount = autoInteger(senderDict[likeCount]);
        NSNumber * num = autoNumber(senderDict[hasPraised]);
        _hasPraised = [num boolValue];
        _senderType = autoInteger(senderDict[senderType]);
        _commentCount = autoInteger(senderDict[commentCount]);
        _trammitCount = autoInteger(senderDict[trammitCount]);
        _clientUuid = autoString(senderDict[clientUuid]);
        _orderNum = autoString(senderDict[orderNum]);
        _srcMomentStatus = autoInteger(senderDict[srcStatus]);
        _isRecommend = autoNumber(senderDict[recommend]);
        _sort = autoInteger(senderDict[sort]);
        _qaId = autoString(senderDict[qaId]);
        
        BOOL isSort = [(NSNumber *)autoNumber([senderDict objectForKey:momoentIsSort]) boolValue];
        if (isSort) {
            _dynamicType = MXRBookSNSRecommendDynamicType;
        }else{
            _dynamicType = MXRBookSNSDefaultDynamicType;
        }
        
        _commentNum = autoInteger(senderDict[commentNum]);
        
        _topicNameArray = [NSMutableArray array];
        if (senderDict[topicnames]) {
            [[autoString(senderDict[topicnames]) componentsSeparatedByString:@","] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj && obj.length > 0) {
                    [_topicNameArray addObject:obj];
                }
            }];
        }
        
        
        if ([senderDict[commentList] isKindOfClass:[NSArray class]]) {
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dict in senderDict[commentList]) {
                MXRSNSCommentModel *commentModel = [[MXRSNSCommentModel alloc] initWithDictionary:dict];
                [mutableArray addObject:commentModel];
            }
            _commentList = [NSMutableArray arrayWithArray:mutableArray];
        }
        
        if ([senderDict[imageArray] isKindOfClass:[NSMutableArray class]]) {
            _imageArray= [NSMutableArray arrayWithArray:senderDict[@"contentPic"]];
        }else{
            _imageArray = [self getImageInfo:autoString(senderDict[imageArray]) andImageType:autoString(senderDict[contentPicType])];
        }
        _topicIdList = [NSMutableArray arrayWithArray:[NSString cupWordsByCommaForString:autoString(senderDict[topicIDs])]];
        NSInteger publisher = autoInteger(senderDict[isMyCompany]);
        if (publisher == 1) {
            _isMyCompany = YES;
        }else{
            _isMyCompany = NO;
        }
      _cellImageheight = [self caculateTextImageHeight];
    }
    return self;
}

-(CGFloat )caculateTextImageHeight{
    
    CGFloat imageHeight = 0.0f;
    NSInteger count = _imageArray.count;
    if (count > 9) {
        count = 9;
    }
    switch (count) {
        case 0:
            break;
        case 1:
            imageHeight = [self caculateSingleImage:[_imageArray lastObject]];
            break;
        case 2:case 3:case 4:case 5:case 6:case 7:case 8:case 9:
            imageHeight = [self caculateMutableImage:count];
            break;
        default:
            imageHeight = 0;
            break;
    }
    return imageHeight;
}

-(CGFloat )caculateSingleImage:(MXRBookSNSUploadImageInfo *)imageInfo{
    
    if (imageInfo.shapeType == MXRBooKSNSSendDetailImageTypeHorizontal) {
        return singleImageHorizontalHeight;
    }else if (imageInfo.shapeType == MXRBooKSNSSendDetailImageTypeVertical){
        return singleImageVerticalHeight;
    }else{
        return singleImageVerticalHeight;
    }
}

-(CGFloat )caculateMutableImage:(NSInteger )imageCount{
    
    CGFloat itemWidth = (SCREEN_WIDTH_DEVICE - textLabelWidthMarginNormal - 2 * itemMargin)/3 ;
    CGFloat height = 0.0f;
    switch (imageCount) {
        case 2:
        case 3:
            height = itemWidth;
            break;
        case 4:case 5:case 6:
            height = itemWidth * 2 + itemMargin;
            break;
        case 7:case 8:case 9:
            height = itemWidth * 3 + itemMargin * 2;
        default:
            break;
    }
    return height;
}

-(void)createSenderId:(NSString *)aSenderId{
    _senderId = aSenderId;
}
-(void)createMomentId:(NSString *)aMomentId{
    _momentId = aMomentId;
}
-(void)createSenderName:(NSString *)aSenderName{
    if (!aSenderName) {
        aSenderName = @"";
    }
    _senderName = aSenderName;
}
-(void)createMomentDescription:(NSString *)aMomentDescription{
    _momentDescription = aMomentDescription;
}
#pragma mark - Private Methods
-(NSMutableArray *)getImageInfo:(id )imgStr andImageType:(NSString *)type{
       __block NSMutableArray * array =[NSMutableArray array];
    if ([imgStr isKindOfClass:[NSString class]]) {
        if ([(NSString *)imgStr length] == 0) {
            return array;
        }
        //增加所有图片的总地址
        _totalPicUrl=imgStr;
        if ([imgStr rangeOfString:@","].location !=NSNotFound) {
            [[NSString cupWordsByCommaForString:autoString(imgStr)]  enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MXRBookSNSUploadImageInfo * imgInfo = [[MXRBookSNSUploadImageInfo alloc] initWithUrl:obj WithPhotoType:MXRBooKSNSSendDetailImageTypeSquare];
                [array addObject:imgInfo];
            }];
        }else{
            MXRBooKSNSSendDetailImageType imgType = MXRBooKSNSSendDetailImageTypeSquare;
            if ([type isEqualToString:@"H"]) {
                imgType = MXRBooKSNSSendDetailImageTypeHorizontal;
            }else if([type isEqualToString:@"V"]){
                imgType = MXRBooKSNSSendDetailImageTypeVertical;
            }
            MXRBookSNSUploadImageInfo * imgInfo = [[MXRBookSNSUploadImageInfo alloc] initWithUrl:imgStr WithPhotoType:imgType];
            [array addObject:imgInfo];
        }
    }else if ([imgStr isKindOfClass:[NSMutableArray class]]){
      NSMutableArray*sendArray=(NSMutableArray*)imgStr;
        if (sendArray.count==0) {
            array=nil;
        }else{
         array=sendArray;
        }
    }
    return array;
}
-(void)momentSendFail{

    [self momentSendWithIsSuss:NO];
}
-(void)momentSendSuss{

    [self momentSendWithIsSuss:YES];
}
-(void)momentUploading{
    _momentStatusType=MXRBookSNSMomentStatusTypeOnUpload;

}
-(void)likeBtnClick{

    if (_hasPraised) {
        if (_likeCount > 0) {
            _likeCount--;
        }
    }else{
        _likeCount++;
    }
    _hasPraised = !_hasPraised;
}
-(void)cancleLikeMoment{

    _hasPraised = NO;
}
-(void)LikeMoment{

    _hasPraised = YES;
}
-(void)updataMomentLikeCount:(NSInteger)count{

    if (count >= 0) {
        _likeCount = count;
    }
}
-(NSInteger)dynamiclikeCount {
    return _likeCount;
}
-(void)addMomentComment{

    [self momentCommentChangeWith:YES];
}
-(void)deleteMomentComment{

    [self momentCommentChangeWith:NO];
}

//- (void)MXRSetSenderId:(NSString *)senderId{
//
//    _senderId = senderId;
//}

-(void)MXRSetMomentId:(NSString *)momentId{
    _momentId=momentId;
}

- (void)MXRSetSenderTime:(NSNumber *)senderTime{

    _senderTime = senderTime;
}
-(void)updataMomentCommentCount:(NSInteger)count{

    if (count >= 0) {
        _commentCount = count;
    }
}

-(void)updataMomentComment:(NSMutableArray<MXRSNSCommentModel *> *)commentList {
    _commentList = commentList;
}

-(void)momentCommentChangeWith:(BOOL )isAdd{

    if (isAdd) {
        _commentCount ++;
    }else{
        if (_commentCount > 0) {
            _commentCount--;
        }
    }
}
/*
 ** 改变动态发送状态
 */
-(void)momentSendWithIsSuss:(BOOL )isSuss{

    if (isSuss) {
        _momentStatusType = MXRBookSNSMomentStatusTypeOnInternet;
    }else{
        _momentStatusType = MXRBookSNSMomentStatusTypeOnLocal;
    }
}
-(void)setHasPraised:(BOOL)hasPraised{

    _hasPraised = hasPraised;
}
-(BOOL)getIsRecommendMoment{

    if ([_isRecommend boolValue]) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - public
-(void)modelIsDelete{
    
    _srcMomentStatus = MXRSrcMomentStatusDelete;
}
#pragma mark - private
#pragma mark - getter

@end



@implementation MXRSNSSendModel
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        Class currentClass = self.class;
        while (currentClass && currentClass != [NSObject class])
        {
            unsigned int count = 0;
            Ivar *ivar = class_copyIvarList(currentClass, &count);
            if (count > 0) {
                for (int i = 0;i < count;i++) {
                    NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar[i])];
                    id value = [aDecoder  decodeObjectForKey:key];
                    if (value) {
                        [self setValue:value forKey:key];
                    }
                }
            }
            currentClass = class_getSuperclass(currentClass);
            free(ivar);
        }
    }
    return  self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    Class currentClass = self.class;
    if (currentClass == NSObject.class) {
        return;
    }
    while (currentClass && currentClass != [NSObject class])
    {
        unsigned int count = 0;
        Ivar *ivar = class_copyIvarList(currentClass, &count);
        if (count>0) {
            for (int i=0;i<count;i++) {
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar[i])];
                [aCoder encodeObject: [self valueForKey:key] forKey:key];
            }
        }
        currentClass = class_getSuperclass(currentClass);
        free(ivar);
    }
}

-(instancetype)initWithDictionary:(NSDictionary *)senderDict{
    self = [super initWithDictionary:senderDict];
    return self;
}
@end

@implementation MXRSNSTransmitModel
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        Class currentClass = self.class;
        while (currentClass && currentClass != [NSObject class])
        {
            unsigned int count = 0;
            Ivar *ivar = class_copyIvarList(currentClass, &count);
            if (count > 0) {
                for (int i = 0;i < count;i++) {
                    NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar[i])];
                    id value = [aDecoder  decodeObjectForKey:key];
                    if (value) {
                        [self setValue:value forKey:key];
                    }
                }
            }
            currentClass = class_getSuperclass(currentClass);
            free(ivar);
        }
    }
    return  self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    Class currentClass = self.class;
    if (currentClass == NSObject.class) {
        return;
    }
    while (currentClass && currentClass != [NSObject class])
    {
        unsigned int count = 0;
        Ivar *ivar = class_copyIvarList(currentClass, &count);
        if (count>0) {
            for (int i=0;i<count;i++) {
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar[i])];
                [aCoder encodeObject: [self valueForKey:key] forKey:key];
            }
        }
        currentClass = class_getSuperclass(currentClass);
        free(ivar);
    }
}

-(instancetype)initWithDictionary:(NSDictionary *)senderDict{
    self = [super initWithDictionary:senderDict];
    _transmitArray=[[NSMutableArray alloc]init];
    
    _orginalModel = [[MXRSNSSendModel alloc] initWithDictionary:senderDict];
    if (self) {
        [_orginalModel createMomentId:autoString(senderDict[srcId])];
        [_orginalModel createSenderId:autoString(senderDict[userId])];
        [_orginalModel createSenderName:autoString(senderDict[srcUserName])];
        [self createMomentDescription:autoString(senderDict[retransmissionWord])];
        
        _orginalModel.cellImageheight = [self caculateOrginalTextImageHeight];
    }
    return self;
}

-(CGFloat )caculateOrginalTextImageHeight{
    
    CGFloat imageHeight = 0.0f;
    NSInteger count = self.orginalModel.imageArray.count;
    if (count > 9) {
        count = 9;
    }
    switch (count) {
        case 0:
            break;
        case 1:
            imageHeight = [self caculateOrginalSingleImage:[self.orginalModel.imageArray lastObject]];
            break;
        case 2:case 3:case 4:case 5:case 6:case 7:case 8:case 9:
            imageHeight = [self caculateOrginalMutableImage:count];
            break;
        default:
            imageHeight = 0;
            break;
    }
    return imageHeight;
}

-(CGFloat )caculateOrginalSingleImage:(MXRBookSNSUploadImageInfo *)imageInfo{
    
    if (imageInfo.shapeType == MXRBooKSNSSendDetailImageTypeHorizontal) {
        return singleImageHorizontalHeight;
    }else if (imageInfo.shapeType == MXRBooKSNSSendDetailImageTypeVertical){
        return singleImageVerticalHeight;
    }else{
        return singleImageVerticalHeight;
    }
}
-(CGFloat )caculateOrginalMutableImage:(NSInteger )imageCount{
    
    CGFloat itemWidth = (SCREEN_WIDTH_DEVICE - textLabelWidthMarginTransmit- 2 * itemMargin)/3;
    CGFloat height = 0.0f;
    switch (imageCount) {
        case 2:
        case 3:
            height = itemWidth;
            break;
        case 4:case 5:case 6:
            height = itemWidth * 2 + itemMargin;
            break;
        case 7:case 8:case 9:
            height = itemWidth * 3 + itemMargin * 2;
        default:
            break;
    }
    return height;
}

-(instancetype)init{
    if (self=[super init]) {

        _transmitArray=[[NSMutableArray alloc]init];
    }
    return self;

}

//-(void)refreshTransmitTypeModel:(MXRSNSTransmitModel *)newModel {
//    [self refreShreTypeOrDefaultType:newModel];
//    [self.orginalModel refreShreTypeOrDefaultType:[newModel orginalModel]];
//}
#pragma mark - public
-(void)orginalModelIsDelete{

    [_orginalModel modelIsDelete];
}
#pragma mark - private methods
#pragma mark - getter
@end


@implementation MXRSNSCommentModel

-(instancetype)initWithDictionary:(NSDictionary *)senderDict {
    if (self = [super init]) {
        _commentID = autoInteger(senderDict[commentID]);
        _srcId = autoInteger(senderDict[srcId]);
        _srcUserId = autoInteger(senderDict[srcUserId]);
        _srcStatus = autoInteger(senderDict[srcStatus]);
        _delFlag = autoInteger(senderDict[delFlag]);
        _srcUserName = autoString(senderDict[srcUserName]);
        _content = autoString(senderDict[content]);
        _srcContent = autoString(senderDict[srcContent]);
        _userId = autoInteger(senderDict[userId]);
        _userName = autoString(senderDict[senderName]);
        _sort = autoInteger(senderDict[topSort]);//V5.9.1 新增评论置顶排序功字段 by MT.X
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_commentID forKey:commentID];
    [aCoder encodeInteger:_srcId forKey:srcId];
    [aCoder encodeInteger:_srcUserId forKey:srcUserId];
    [aCoder encodeInteger:_srcStatus forKey:srcStatus];
    [aCoder encodeInteger:_delFlag forKey:delFlag];
    [aCoder encodeObject:_srcUserName forKey:srcUserName];
    [aCoder encodeObject:_content forKey:content];
    [aCoder encodeObject:_srcContent forKey:srcContent];
    [aCoder encodeObject:_userName forKey:senderName];
    [aCoder encodeInteger:_userId forKey:userId];
    [aCoder encodeInteger:_sort forKey:sort];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _commentID = [aDecoder decodeIntegerForKey:commentID];
        _srcId = [aDecoder decodeIntegerForKey:srcId];
        _srcUserId = [aDecoder decodeIntegerForKey:srcUserId];
        _srcStatus = [aDecoder decodeIntegerForKey:srcStatus];
        _delFlag = [aDecoder decodeIntegerForKey:delFlag];
        _srcUserName = [aDecoder decodeObjectForKey:srcUserName];
        _content = [aDecoder decodeObjectForKey:content];
        _srcContent = [aDecoder decodeObjectForKey:srcContent];
        _userName = [aDecoder decodeObjectForKey:senderName];
        _userId = [aDecoder decodeIntegerForKey:userId];
        _sort = [aDecoder decodeIntegerForKey:sort];
    }
    return self;
}
@end
