//
//  MXRBookSNSModelProxy.m
//  huashida_home
//
//  Created by gxd on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSModelProxy.h"
#import "MXRSNSShareModel.h"
#import "MXRBookSNSController.h"
#import "MXRSNSBlackListModel.h"

#define mxrBookSNSHeadTopic  @"mxrBookSNSHeadTopic.archiver"
#define mxrBookSNSMoments  @"mxrBookSNSMoments.archiver"
#define mxrBookSNSNetMoments  @"mxrBookSNSNetMoments.archiver"
#define mxrBookSNSdataNeedUpload @"mxrBookSNSdataNeedUpload.archiver"
#define mxrBookSNSRecommentMomentsArray @"mxrbookSNSRecommentMomentsArray.archiver"
@implementation MXRBookSNSModelProxy
+(instancetype)getInstance{

    static dispatch_once_t onceToken;
    static MXRBookSNSModelProxy *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MXRBookSNSModelProxy alloc] init];
    });
    return instance;
}

#pragma mark - public
-(void)creatCacheData{
    if (self.bookSNSdataNeedUploadArray) {
        [NSKeyedArchiver archiveRootObject:self.bookSNSdataNeedUploadArray toFile:[NSString stringWithFormat:@"%@/%@",Caches_Directory_BookSNS,mxrBookSNSdataNeedUpload]];
    }
    if (self.bookSNSMomentsArray) {
        [NSKeyedArchiver archiveRootObject:self.bookSNSMomentsArray toFile:[NSString stringWithFormat:@"%@/%@",Caches_Directory_BookSNS,mxrBookSNSMoments]];
    }
    if (self.bookSNSNetMomentsArray) {
        [NSKeyedArchiver archiveRootObject:self.bookSNSNetMomentsArray toFile:[NSString stringWithFormat:@"%@/%@",Caches_Directory_BookSNS,mxrBookSNSNetMoments]];
    }
    if (self.bookSNSHeadtopicModelDataArray) {
        [NSKeyedArchiver archiveRootObject:self.bookSNSHeadtopicModelDataArray toFile:[NSString stringWithFormat:@"%@/%@",Caches_Directory_BookSNS,mxrBookSNSHeadTopic]];
    }
    if (self.bookSNSRecommentMomentsArray) {
        [NSKeyedArchiver archiveRootObject:self.bookSNSRecommentMomentsArray toFile:[NSString stringWithFormat:@"%@/%@",Caches_Directory_BookSNS,mxrBookSNSRecommentMomentsArray]];
    }
}

- (BOOL)deleteCacheData{
    NSMutableArray *cacheFilePathes = [NSMutableArray arrayWithCapacity:0];
    [cacheFilePathes addObject:[NSString stringWithFormat:@"%@/%@",Caches_Directory_BookSNS,mxrBookSNSdataNeedUpload]];
    [cacheFilePathes addObject:[NSString stringWithFormat:@"%@/%@",Caches_Directory_BookSNS,mxrBookSNSMoments]];
    [cacheFilePathes addObject:[NSString stringWithFormat:@"%@/%@",Caches_Directory_BookSNS,mxrBookSNSNetMoments]];
    [cacheFilePathes addObject:[NSString stringWithFormat:@"%@/%@",Caches_Directory_BookSNS,mxrBookSNSHeadTopic]];
    [cacheFilePathes addObject:[NSString stringWithFormat:@"%@/%@",Caches_Directory_BookSNS,mxrBookSNSRecommentMomentsArray]];
    BOOL deleteCacheDataSuccess = YES;
    if (cacheFilePathes.count > 0) {
        NSFileManager *manager = [NSFileManager defaultManager];
        for (NSString *filePath in cacheFilePathes) {
            BOOL fileExist = [manager fileExistsAtPath:filePath];
            if (fileExist) {
                NSError *error;
                BOOL deleteSuccess = [manager removeItemAtPath:filePath error:&error];
                if (error) {
                    DLOG(@"deleteCacheDataError: %@", error.localizedDescription);
                }
                if (!deleteSuccess) {
                    deleteCacheDataSuccess = NO;
                }
            } else {
//                DLOG(@"deleteCacheData====file not exist at path: %@", filePath);
            }
        }
    }
    
//    _bookSNSHeadtopicModelDataArray = nil;
//    _bookSNSBannerArray = nil;
//    _bookSNSdataNeedUploadArray = nil;
    /**
     从服务端获取的原始数据 （未排序的）
     */
    _bookSNSNetMomentsArray = nil;
    _bookSNSMomentsArray = nil;
    _bookSNSRecommentMomentsArray = nil; //服务推荐的动态(精选)
    
    
    return deleteCacheDataSuccess;
}
-(void)creatNeedUploadCacheData{

     [NSKeyedArchiver archiveRootObject:self.bookSNSdataNeedUploadArray toFile:[NSString stringWithFormat:@"%@/%@",Caches_Directory_BookSNS,mxrBookSNSdataNeedUpload]];
}
-(MXRSNSShareModel *)getSNSShareModelWithId:(NSString *)modelID{

   __block MXRSNSShareModel * model;
    NSArray * tempArr = [NSArray arrayWithArray:self.bookSNSMomentsArray];
    [tempArr enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.momentId isEqualToString:modelID] || [obj.clientUuid isEqualToString:modelID]) {
            model = obj;
            *stop = YES;
        }
    }];
    tempArr = nil;
    return model;
}
-(void)deleteMomentWithId:(NSString *)momentId{

    MXRSNSShareModel * model = [self getSNSShareModelWithId:momentId];
    if (!model) {
        return;
    }
    [self.bookSNSMomentsArray removeObject:model];
    [self.bookSNSNetMomentsArray removeObject:model];
     [self.bookSNSRecommentMomentsArray removeObject:model];
    [self.bookSNSMomentsArray enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.senderType == SenderTypeOfTransmit) {
            if ([momentId isEqualToString:[(MXRSNSTransmitModel *)obj orginalModel].momentId]) {
                [(MXRSNSTransmitModel *)obj orginalModelIsDelete];
            }
        }
    }];
}
-(void)uninterestredWithunFocusUserId:(NSString *)unFocusUserId{

    [[self getMomentsBelongUserWithUserId:unFocusUserId] enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.bookSNSMomentsArray removeObject:obj];
        [self.bookSNSNetMomentsArray removeObject:obj];
        [self.bookSNSRecommentMomentsArray removeObject:obj];
    }];
}

/**
 * 获取某个用户发的所有动态
 */
-(NSArray <MXRSNSShareModel *>*)getMomentsBelongUserWithUserId:(NSString *)userid{

    __block NSMutableArray * array = [NSMutableArray array];
    NSArray * tempArr = [NSArray arrayWithArray:self.bookSNSMomentsArray];
    [tempArr enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.senderId isEqualToString:userid]) {
            [array addObject:obj];
        }
    }];
    tempArr = nil;
    return array;
}
/**
 * 获取某个用户发的所有动态id
 */
-(NSArray *)getMomentIDBelongUserWithUserId:(NSString *)userid{
    
    __block NSMutableArray * array = [NSMutableArray array];
    NSArray * tempArr = [NSArray arrayWithArray:self.bookSNSMomentsArray];
    [tempArr enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.senderId isEqualToString:userid]) {
            [array addObject:obj.momentId];
        }
    }];
    tempArr = nil;
    return array;
}
/**
 获取某些动态在数组里的顺序
 */
-(NSArray *)getMomentsOnArrayIndex:(NSArray *)momentIDArray{
    
    __block NSMutableArray * array = [NSMutableArray arrayWithCapacity:momentIDArray.count];
    [momentIDArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:[NSString stringWithFormat:@"%lu", (long)[self getMomentOnArrayIndex:obj]]];
    }];
    return array;
}
/**
   获取某个动态在数组里的顺序
 */
-(NSInteger )getMomentOnArrayIndex:(NSString *)momentID{

    NSUInteger index = [self.bookSNSMomentsArray indexOfObject:[self getSNSShareModelWithId:momentID]];
    return index;
}
-(void)updateLocalMoment:(NSArray *)dictArray andIsNewMoment:(BOOL)isNew callback:(void(^)(BOOL isSuccess))callback {

    if (isNew) {
       
    }else{
        [[MXRBookSNSController getInstance] cachedSNSBlackListModelArray:^(NSArray<MXRSNSBlackListModel *> *blackList) {
            [dictArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MXRSNSShareModel * interNetModel = [[MXRSNSShareModel alloc] createWithDictionary:obj];
                MXRSNSShareModel *localModel = [self getSNSShareModelWithId:interNetModel.clientUuid];
                if ([localModel.momentId isEqualToString:interNetModel.clientUuid]) {
                    [self.bookSNSNetMomentsArray removeObject:localModel];
                }
                
                //本地过滤黑名单 V5.8.8 by MT.X
                __block BOOL inBlackList = NO;
                [blackList enumerateObjectsUsingBlock:^(MXRSNSBlackListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([interNetModel.momentId isEqualToString:obj.momentID]) {
                        inBlackList = YES;
                        *stop = YES;
                    }
                }];
                if (!inBlackList) {
                    [self.bookSNSNetMomentsArray addObject:interNetModel];
                }
            }];
            
            [MXRBookSNSModelProxy getInstance].bookSNSMomentsArray = [[MXRBookSNSModelProxy getInstance] sortMomentArray:[MXRBookSNSModelProxy getInstance].bookSNSNetMomentsArray newArray:[MXRBookSNSModelProxy getInstance].bookSNSRecommentMomentsArray];
            
            if (callback) {
                mxr_dispatch_main_async_safe(^{
                    callback(YES);
                })
            }
        }];
    }
}
//-(BOOL)checkSrcModelIsDeleteWithId:(NSString *)momentId{
//
//    BOOL isDelete = NO;
//    MXRSNSShareModel * model = [self getSNSShareModelWithId:momentId];
//    if (model.senderType == SenderTypeOfDefault) {
//        if (model.srcMomentStatus == MXRSrcMomentStatusDelete) {
//            isDelete = YES;
//        }
//    }else if (model.senderType == SenderTypeOfTransmit){
//        
//        if ([(MXRSNSTransmitModel *)model orginalModel].srcMomentStatus == MXRSrcMomentStatusDelete) {
//            isDelete = YES;
//        }
//    }
//    return isDelete;
//}
-(void)srcMomentDeleteMomentWithId:(NSString *)momentId{

    MXRSNSShareModel * model = [self getSNSShareModelWithId:momentId];
    if (model.senderType == SenderTypeOfDefault) {
        [model modelIsDelete];
    }else if (model.senderType == SenderTypeOfTransmit){
        [[(MXRSNSTransmitModel *)model orginalModel] modelIsDelete];
    }
}
#pragma mark - Action Methods

#pragma mark - private
-(NSMutableArray *)getLocalDataWithName:(NSString *)dataName{

    NSMutableArray * array = [NSMutableArray array];
    if (dataName) {
     array = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@/%@",Caches_Directory_BookSNS,dataName]];
    }
    if (!array) {
        array = [NSMutableArray array];
    }
    return array;
    
}


/**
 给精选的动态数组赋值
 */
//-(void)addDataForBookSNSRecommentMomentsArray:(MXRSNSShareModel *)model {
//    [self.bookSNSRecommentMomentsArray addObject:model];
//}

- (NSMutableArray *)sortMomentArray:(NSMutableArray *)oldArray newArray:(NSMutableArray *)newArray{

    __block NSMutableArray * finalArray = [NSMutableArray arrayWithArray:oldArray];
    if (newArray.count > 0) {
        [newArray enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj && [obj isKindOfClass:[MXRSNSShareModel class]]) {
                if (obj.dynamicType == MXRBookSNSRecommendDynamicType) {
                    if (obj.sort >= 1 && obj.sort - 1 < finalArray.count && obj) {
                        [finalArray insertObject:obj atIndex:obj.sort - 1];
                    }else{
                        [finalArray addObject:obj];
                    }
                }
            }
           
        }];
    }
    return finalArray;
}

#pragma mark - getter
- (NSMutableArray *)bookSNSHeadtopicModelDataArray{
    
    if (!_bookSNSHeadtopicModelDataArray) {
        _bookSNSHeadtopicModelDataArray = [self getLocalDataWithName:mxrBookSNSHeadTopic];
    }
    return _bookSNSHeadtopicModelDataArray;
}
- (NSMutableArray *)bookSNSMomentsArray{

    if (!_bookSNSMomentsArray) {
        _bookSNSMomentsArray = [self getLocalDataWithName:mxrBookSNSMoments];
    }
    return _bookSNSMomentsArray;
}

- (NSMutableArray<MXRSNSShareModel *> *)bookSNSNetMomentsArray{
    
    if (!_bookSNSNetMomentsArray) {
        _bookSNSNetMomentsArray = [self getLocalDataWithName:mxrBookSNSNetMoments];
    }
    return _bookSNSNetMomentsArray;
}

-(NSMutableArray *)bookSNSdataNeedUploadArray{
    
    if (!_bookSNSdataNeedUploadArray) {
        _bookSNSdataNeedUploadArray = [self getLocalDataWithName:mxrBookSNSdataNeedUpload];
    }
    return _bookSNSdataNeedUploadArray;

}

-(NSMutableArray<MXRSNSShareModel *> *)bookSNSRecommentMomentsArray{
    
    if (!_bookSNSRecommentMomentsArray) {
        _bookSNSRecommentMomentsArray = [self getLocalDataWithName:mxrBookSNSRecommentMomentsArray];
    }
    return _bookSNSRecommentMomentsArray;
    
}
@end
