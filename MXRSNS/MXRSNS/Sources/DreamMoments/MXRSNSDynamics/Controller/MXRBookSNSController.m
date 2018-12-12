//
//  MXRBookSNSController.m
//  huashida_home
//
//  Created by gxd on 16/9/29.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSController.h"
#import "AFNetworking.h"
#import "ALLNetworkURL.h"
#import "GlobalFunction.h"
#import "NSMutableURLRequest+Ex.h"
#import "MXRJsonUtil.h"
#import "MXRTopicModel.h"
#import "MXRSNSShareModel.h"
#import "MXRBookSNSModelProxy.h"
#import "MXRNetworkManager.h"
#import "NSDictionary+URL.h"
#import "MXRBookSNSBannerModel.h"
#import "LKDBHelper.h"
#import "MXRSNSBlackListModel.h"

// 用户操作动态（点赞、取消点赞、举报）错误码：动态已被删除
static NSString *MomentDeletedErrcode = @"600002";

#define SNSPageNum 30 //V5.9.1 请求动态列表单页的动态数量，应该大于等于最大的精选动态排序(精选动态最大的序号为30) by MT.X

@interface MXRBookSNSController()

/**
 梦想圈动态黑名单缓存
 */
@property (nonatomic, strong)NSMutableArray <MXRSNSBlackListModel *> *blackListCache;

@end
@implementation MXRBookSNSController

#pragma mark - 单例
+(instancetype)getInstance{
    static MXRBookSNSController *search = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        search = [[MXRBookSNSController alloc] init];
    });
    return search;
}

#pragma mark - 动态黑名单（记录本地删除的所有动态）
- (void)cachedSNSBlackListModelArray:(void(^)(NSArray <MXRSNSBlackListModel *> *blackList))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (self.blackListCache.count == 0) {
            NSString *sql = [NSString stringWithFormat:@"select * from %@ where userID = %@", NSStringFromClass([MXRSNSBlackListModel class]), [UserInformation modelInformation].userID];
            if (block) {
                NSArray *blackList = [[MXRSNSBlackListModel searchWithSQL:sql] copy];
                [self.blackListCache addObjectsFromArray:blackList];
                block(blackList);
            }
        } else {
            MXRSNSBlackListModel *firstModel = [self.blackListCache firstObject];
            if (firstModel.userID == [[UserInformation modelInformation].userID integerValue]) {
                if (block) {
                    block(self.blackListCache);
                }
            } else {
                NSString *sql = [NSString stringWithFormat:@"select * from %@ where userID = %@", NSStringFromClass([MXRSNSBlackListModel class]), [UserInformation modelInformation].userID];
                if (block) {
                    NSArray *blackList = [[MXRSNSBlackListModel searchWithSQL:sql] copy];
                    [self.blackListCache removeAllObjects];
                    [self.blackListCache addObjectsFromArray:blackList];
                    block(blackList);
                }
            }
        }
    });
}

#pragma mark - 删除动态（添加到本地数据库）
- (void)addSNSBlackListModel:(MXRSNSBlackListModel *)model {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MXRSNSBlackListModel insertWhenNotExists:model];
        [self.blackListCache addObject:model];
    });
}

#pragma mark - 获取梦想圈动态首页所有动态（包含全部精选动态）
-(void)getBookSNSAllMomentWithHandleUserId:(NSString *)handleUserID Success:(successCallback)success failure:(failureCallback)fail{
    
    NSDictionary *parametersDic = @{@"uid":[MXRBase64 encodeBase64WithString:autoString(handleUserID)],
                                    @"page":@1,
                                    @"rows":@(SNSPageNum)};

    @MXRWeakObj(self)
    [MXRNetworkManager mxr_get:ServiceURL_Community_Dynamics parameters:parametersDic success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {

        if (response.isSuccess&&response.body) {
            NSArray * array = [(NSDictionary *)response.body objectForKey:@"list"];

            if (array.count > 0) {
                
                __block NSNumber *newestTime;
                [[MXRBookSNSModelProxy getInstance].bookSNSNetMomentsArray enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (![obj.momentId isEqualToString:obj.clientUuid]) {
                        newestTime = obj.senderTime;
                        *stop = YES;
                    }
                }];
                
                [[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray removeAllObjects];
                [[MXRBookSNSModelProxy getInstance].bookSNSNetMomentsArray removeAllObjects];
                
                //本地过滤黑名单 V5.8.8 by MT.X
                [selfWeak cachedSNSBlackListModelArray:^(NSArray<MXRSNSBlackListModel *> *blackList) {
                    __block NSInteger freshNum = 0;//新增动态
                    [array enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        MXRSNSShareModel *model = [[MXRSNSShareModel alloc] createWithDictionary:obj];
                        
                        //本地过滤黑名单 V5.8.8 by MT.X
                        __block BOOL inBlackList = NO;
                        [blackList enumerateObjectsUsingBlock:^(MXRSNSBlackListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([model.momentId isEqualToString:obj.momentID]) {
                                inBlackList = YES;
                                *stop = YES;
                            }
                        }];
                        if (!inBlackList) {
                            if ([newestTime isKindOfClass:[NSNumber class]] && [model.senderTime compare:newestTime] == NSOrderedDescending) {
                                freshNum ++;
                            }
                            [[MXRBookSNSModelProxy getInstance].bookSNSNetMomentsArray addObject:model];
                        }
                    }];
                    
                    [selfWeak getServerRecommendDynamicWithTopicID:@"" topicName:@"" success:^(id result) {
                        
                        if ([result isKindOfClass:[NSArray class]]) {
                            NSArray * array = (NSArray *)result;

                            NSMutableArray <MXRSNSShareModel *>*recommendMoments = [NSMutableArray array];
                            for (NSDictionary *dictionary in array) {
                                MXRSNSShareModel *model = [[MXRSNSShareModel alloc] createRecommentDataWithDictionary:dictionary];
                                [recommendMoments addObject:model];
                            }
                            [[MXRBookSNSController getInstance] cachedSNSBlackListModelArray:^(NSArray<MXRSNSBlackListModel *> *blackList) {
                                NSMutableArray *filterRecommendMoments = [NSMutableArray array];
                                [recommendMoments enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                                    //本地过滤黑名单 V5.8.8 by MT.X
                                    __block BOOL inBlackList = NO;
                                    [blackList enumerateObjectsUsingBlock:^(MXRSNSBlackListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        if ([model.momentId isEqualToString:obj.momentID]) {
                                            inBlackList = YES;
                                            *stop = YES;
                                        }
                                    }];
                                    if (!inBlackList) {
                                        __block BOOL isLoaded = NO;
                                        [[MXRBookSNSModelProxy getInstance].bookSNSRecommentMomentsArray enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                            if ([obj.momentId isEqualToString:model.momentId]) {
                                                isLoaded = YES;
                                                *stop = YES;
                                            }
                                        }];
                                        if (!isLoaded) {
                                            freshNum ++;
                                        }
                                        [filterRecommendMoments addObject:model];
                                    }
                                }];
                                
                                [[MXRBookSNSModelProxy getInstance].bookSNSRecommentMomentsArray removeAllObjects];
                                [[MXRBookSNSModelProxy getInstance].bookSNSRecommentMomentsArray addObjectsFromArray:filterRecommendMoments];
                                
                                [MXRBookSNSModelProxy getInstance].bookSNSMomentsArray =   [[MXRBookSNSModelProxy getInstance] sortMomentArray:[MXRBookSNSModelProxy getInstance].bookSNSNetMomentsArray newArray:[MXRBookSNSModelProxy getInstance].bookSNSRecommentMomentsArray];
                                
                                if (success) {
                                    mxr_dispatch_main_async_safe(^{
                                        success([NSNumber numberWithInteger:freshNum]);
                                    })
                                }
                            }];
                        }
                    } failure:^(MXRServerStatus status, id result) {
                        [[MXRBookSNSModelProxy getInstance].bookSNSRecommentMomentsArray removeAllObjects];
                        [MXRBookSNSModelProxy getInstance].bookSNSMomentsArray = [[MXRBookSNSModelProxy getInstance] sortMomentArray:[MXRBookSNSModelProxy getInstance].bookSNSNetMomentsArray newArray:[MXRBookSNSModelProxy getInstance].bookSNSRecommentMomentsArray];
                        if (success) {
                            mxr_dispatch_main_async_safe(^{
                                success([NSNumber numberWithInteger:0]);
                            })
                        }
                    }];
                }];
            }else{
                if (fail) {
                    fail(MXRServerStatusFail,response.errMsg);
                }
            }
        }else{
            if (fail) {
                fail(MXRServerStatusFail,response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {

        if (fail) {
            fail(MXRServerStatusNetworkError,nil);
        }
    }];
}

#pragma mark - 获取梦想圈更早的动态列表（不含精选动态）
-(void)getPreviousBookSNSMomentWithandHandleUserId:(NSString *)handleUserID Success:(successCallback)success failure:(failureCallback)fail{

    __block NSNumber * time;
    if (!([MXRBookSNSModelProxy getInstance].bookSNSNetMomentsArray.count > 0)) {
        if (fail) {
            fail(MXRServerStatusFail,nil);
            return;
        }
    }
    for (int i = [MXRBookSNSModelProxy getInstance].bookSNSNetMomentsArray.count - 1; i >= 0 ; i--) {
        MXRSNSShareModel * model = [MXRBookSNSModelProxy getInstance].bookSNSNetMomentsArray[i];
        if (![model.momentId isEqualToString:model.clientUuid]) {
            time = [model senderTime];
            break;
        }
    }
    if (time == nil) {
        if (fail) {
            fail(MXRServerStatusFail,nil);
        }
        
        return;
    }
    NSDictionary *parametersDic = @{@"uid":[MXRBase64 encodeBase64WithString:autoString(handleUserID)],
                                    @"timestamp":autoNumber(time),
                                    @"rows":@(SNSPageNum)};
    
    [MXRNetworkManager mxr_get:ServiceURL_Community_Dynamics_Next parameters:parametersDic success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess&&response.body) {
            NSArray * dictArray = [(NSDictionary *)response.body objectForKey:@"list"];
            if (!dictArray || dictArray.count == 0) {
                if (fail) {
                    fail(MXRServerStatusFail,nil);
                }
            }else{
                [[MXRBookSNSModelProxy getInstance] updateLocalMoment:dictArray andIsNewMoment:NO callback:^(BOOL isSuccess) {
                    if (success) {
                        success([NSNumber numberWithInteger:[dictArray count]]);
                    }
                }];
            }
            
        }else{
            if (fail) {
                fail(MXRServerStatusFail,response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (fail) {
            fail(MXRServerStatusNetworkError,nil);
        }
    }];
}

#pragma mark - 删除梦想圈动态
-(void)deleteMomentWithMomentId:(NSString *)momentId andHandleUserId:(NSString *)handleUserID success:(successCallback)success failure:(failureCallback)fail{
    
    NSString * url = [NSString stringWithFormat:@"%@?uid=%@",Delete_Moment_MomentId((long)[momentId integerValue]),[MXRBase64 encodeBase64WithString:autoString(handleUserID)]];
    
    [MXRNetworkManager mxr_delete:url parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            if (success) {
                success([NSNumber numberWithBool:YES]);
            }
        }else{
            if (fail) {
                fail(MXRServerStatusFail,response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (fail) {
            fail(MXRServerStatusNetworkError,nil);
        }
    }];
}

#pragma mark - 对动态不感兴趣
-(void)cancleFocusWithUserId:(NSString *)t_userId andHandleUserId:(NSString *)handleUserID success:(successCallback)success failure:(failureCallback)fail{
    

    NSDictionary *paramDict = @{@"suid":[MXRBase64 encodeBase64WithString:autoString(handleUserID)],
                                @"tuid":[MXRBase64 encodeBase64WithString:autoString(t_userId)]
                                };
    
    /*V5.6.1 动态不感兴趣的接口请求参数请放在url后面（现在在body中），参数内容加密。*/
    NSString *deleteURLStr = [paramDict URLRequestStringWithURLStr:ServiceURL_Community_Dynamics_User_Cancel];
    [MXRNetworkManager mxr_delete:deleteURLStr parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            if (success) {
                success([NSNumber numberWithBool:YES]);
            }
        }else{
            if (fail) {
                fail(MXRServerStatusFail,response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (fail) {
            fail(MXRServerStatusNetworkError,nil);
        }
    }];
    /*V5.6.1 动态不感兴趣的接口请求参数请放在url后面（现在在body中），参数内容加密。*/
}

#pragma mark - 对动态进行点赞
-(void)userLikeMomentWithMomentId:(NSString *)momentId andHandleUserId:(NSString *)handleUserID success:(successCallback)success failure:(failureCallback)fail{
    
    NSString * userImageUrl = @"";
    if ([UserInformation modelInformation].userImage) {
        userImageUrl = [UserInformation modelInformation].userImage;
    }
    NSDictionary *parametersDic = @{@"userId":autoString(handleUserID),
                                    @"dynamicId":autoString(momentId),
                                    @"userLogo":autoString(userImageUrl),
                                    @"userName":autoString([UserInformation modelInformation].userNickName)};
    // 代码质量优化 M by liulong
    NSString *urlString = ServiceURL_Community_Dynamics_User_Like;
    [MXRNetworkManager mxr_post:urlString parameters:parametersDic success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            if (success) {
                success([NSNumber numberWithBool:YES]);
            }
        }else{
            if ([[response.errCode stringValue] isEqualToString:MomentDeletedErrcode]) {
                [[MXRBookSNSModelProxy getInstance] srcMomentDeleteMomentWithId:momentId];
            }
            if (fail) {
                fail(MXRServerStatusFail,response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (fail) {
            fail(MXRServerStatusNetworkError,nil);
        }
    }];
}

#pragma mark - 对动态取消点赞
-(void)userCancleLikeMomentWithMomentId:(NSString *)momentId andHandleUserId:(NSString *)handleUserID success:(successCallback)success failure:(failureCallback)fail{
    
    NSDictionary *paramDict = @{@"uid":[MXRBase64 encodeBase64WithString:autoString(handleUserID)]};
    
    NSString * url = User_Cancle_Like_MomentId([momentId integerValue]);
    
    /*V5.8.0 delete请求直接拼接在路径上，不放在HttpBody中*/
    NSString *deleteUrl = [paramDict URLRequestStringWithURLStr:url];
    /*V5.8.0 delete请求直接拼接在路径上，不放在HttpBody中*/
    
    [MXRNetworkManager mxr_delete:deleteUrl parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            if (success) {
                success([NSNumber numberWithBool:YES]);
            }
        }else{
            if ([[response.errCode stringValue] isEqualToString:MomentDeletedErrcode]) {
                [[MXRBookSNSModelProxy getInstance] srcMomentDeleteMomentWithId:momentId];
            }
            if (fail) {
                fail(MXRServerStatusFail,response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (fail) {
            fail(MXRServerStatusNetworkError,nil);
        }
    }];
}

#pragma mark - 举报动态
-(void)userReportMomentWithReportDetail:(NSString *)reportStr andHandleUserId:(NSString *)handleUserID andMomentId:(NSString *)momentId success:(successCallback)success failure:(failureCallback)fail{
    NSDictionary *parametersDic = @{@"userId":autoString(handleUserID),
                                    @"reportId":autoString(momentId),
                                    @"reportReason":autoString(reportStr)};
    
    NSString *urlString = ServiceURL_Community_Dynamics_User_Report;
    [MXRNetworkManager mxr_post:urlString parameters:parametersDic success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            if (success) {
                success([NSNumber numberWithBool:YES]);
            }
        }else{
            if ([[response.errCode stringValue] isEqualToString:MomentDeletedErrcode]) {
                [[MXRBookSNSModelProxy getInstance] srcMomentDeleteMomentWithId:momentId];
            }
            if (fail) {
                fail(MXRServerStatusFail, response.errCode);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (fail) {
            fail(MXRServerStatusNetworkError,nil);
        }
    }];
}

#pragma mark - 获取梦想圈热门话题列表
-(void)getHotTopicListWithSuccess:(successCallback)success failure:(failureCallback)fail{

    NSDictionary *parametersDic = @{@"page":@1,
                                    @"rows":@10};
    
    [MXRNetworkManager mxr_get:ServiceURL_Community_Topics_Recommend parameters:parametersDic success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
      
        if (response.isSuccess&&response.body) {
            NSArray * array = (NSArray *)response.body;
            if (array.count > 0 ) {
                [[MXRBookSNSModelProxy getInstance].bookSNSHeadtopicModelDataArray removeAllObjects];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MXRTopicModel *model = [[MXRTopicModel alloc] initWithDictionary:obj];
                [[MXRBookSNSModelProxy getInstance].bookSNSHeadtopicModelDataArray addObject:model];
            }];
            MXRTopicModel * t_model = [[MXRTopicModel alloc] initMoreSystemItem];
            [[MXRBookSNSModelProxy getInstance].bookSNSHeadtopicModelDataArray addObject:t_model];
            if (success) {
                success([NSNumber numberWithBool:YES]);
            }
        }else{
            if (fail) {
                fail(MXRServerStatusFail,response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (fail) {
            fail(MXRServerStatusNetworkError,nil);
        }
    }];
}

#pragma mark - 获取我的动态相关服务
-(void)getMyBookSNSAllMomentWithHandleUserId:(NSString *)handleUserID Success:(successCallback)success failure:(failureCallback)fail{

    NSDictionary *parametersDic = @{@"uid":[MXRBase64 encodeBase64WithString:handleUserID],
                                    @"page":@1,
                                    @"rows":@(SNSPageNum)};
    
    [MXRNetworkManager mxr_get:ServiceURL_Community_Dynamics_My parameters:parametersDic success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess&&response.body) {
            NSArray * array = [(NSDictionary *)response.body objectForKey:@"list"];
            if (array.count > 0) {
                if (success) {
                    success(array);
                }
            }else{
                if (fail) {
                    fail(MXRServerStatusFail,response.errMsg);
                }
            }
        }else{
            if (fail) {
                fail(MXRServerStatusFail,response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (fail) {
            fail(MXRServerStatusNetworkError,nil); 
        }
    }];
}

#pragma mark - 获取个人更早的动态数量
-(void)getMyOldBookSNSMomentWithandHandleUserId:(NSString *)handleUserID andTime:(NSNumber *)time Success:(successCallback)success failure:(failureCallback)fail{

    NSDictionary *parametersDic = @{@"uid":[MXRBase64 encodeBase64WithString:autoString(handleUserID)],
                                    @"timestamp":autoNumber(time)};
    
    [MXRNetworkManager mxr_get:ServiceURL_Community_Dynamics_My_next parameters:parametersDic success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess&&response.body) {
            NSArray * array = [(NSDictionary *)response.body objectForKey:@"list"];
            if (array.count > 0) {
                if (success) {
                    success(array);
                }
            }else{
                if (fail) {
                    fail(MXRServerStatusFail,response.errMsg);
                }
            }
        }else{
            if (fail) {
                fail(MXRServerStatusFail,response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (fail) {
            fail(MXRServerStatusNetworkError,nil);
        }
    }];
}

#pragma mark - 获取个人最新动态的数量
-(void)getMyNewBookSNSMomentCountWithandHandleUserId:(NSString *)handleUserID andTime:(NSNumber *)time Success:(successCallback)success failure:(failureCallback)fail{

    NSDictionary *parametersDic = @{@"uid":[MXRBase64 encodeBase64WithString:autoString(handleUserID)],
                                    @"timestamp":autoNumber(time)};
    
    [MXRNetworkManager mxr_get:ServiceURL_Community_Dynamics_My_Pevious_Count parameters:parametersDic success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            NSString * strCount = response.responseBodyString;
            if (success) {
                success([NSNumber numberWithInteger:[strCount integerValue]]);
            }
        }else{
            if (fail) {
                fail(MXRServerStatusFail,response.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (fail) {
            fail(MXRServerStatusNetworkError,nil);
        }
    }];
}

#pragma mark - 获取运营调整过的动态排序或话题下的动态排序
-(void)getServerRecommendDynamicWithTopicID:(NSString *)topicId topicName:(NSString *)topicName success:(successCallback)success failure:(failureCallback)fail {
    
    NSString *urlString = ServiceURL_BookSNS_RecommentDynamic;
    if (!topicId) {
        topicId = @"";
    }
    if (!topicName) {
        topicName = @"";
    }
    NSDictionary * dic = @{@"topicId":topicId,
                            @"name":topicName};
    
    [MXRNetworkManager mxr_get:urlString parameters:dic success:^(NSURLSessionTask *task, MXRNetworkResponse *responce) {
        if (responce.isSuccess&&responce.body) {
            NSArray * array = (NSArray *)responce.body;
            if (array.count > 0) {
                
                if (success) {
                    success(array);
                }
            }else{
                if (fail) {
                    fail(MXRServerStatusFail,responce.errMsg);
                }
            }
        }else{
            if (fail) {
                fail(MXRServerStatusFail,responce.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (fail) {
            fail(MXRServerStatusNetworkError,nil);
        }
    }];
}

#pragma mark - 获取梦想圈顶部banner图片
-(void)getBookSNSBannerIconUrlStringSuccess:(successCallback )success failure:(failureCallback )fail {
    [MXRNetworkManager mxr_get:ServiceURL_BookSNS_BannerIconUrl parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *responce) {
        if (responce.isSuccess&&responce.body) {
            NSArray * array = (NSArray *)responce.body;
            if (array.count > 0) {
                NSMutableArray *bookSNSBannerArray = [NSMutableArray array];
                for (NSDictionary *dict in array) {
                    MXRBookSNSBannerModel *bannerModel = [[MXRBookSNSBannerModel alloc] initWithDictionary:dict];
                    [bookSNSBannerArray addObject:bannerModel];
                }
                [[MXRBookSNSModelProxy getInstance] setBookSNSBannerArray:bookSNSBannerArray];
                if (success) {
                    success(bookSNSBannerArray);
                }
            }else{
                if (fail) {
                    fail(MXRServerStatusFail,responce.errMsg);
                }
            }
        }else{
            if (fail) {
                fail(MXRServerStatusFail,responce.errMsg);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (fail) {
            fail(MXRServerStatusNetworkError,nil);
        }
    }];
}

#pragma mark - Lazy Loader
- (NSMutableArray<MXRSNSBlackListModel *> *)blackListCache {
    if (!_blackListCache) {
        _blackListCache = [NSMutableArray array];
    }
    return _blackListCache;
}

@end
