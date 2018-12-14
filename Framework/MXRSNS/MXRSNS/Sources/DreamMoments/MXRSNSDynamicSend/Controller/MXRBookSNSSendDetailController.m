//
//  MXRBookSNSSendDetailController.m
//  huashida_home
//
//  Created by yuchen.li on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSSendDetailController.h"
#import "MXRBookSNSSendDetailProxy.h"
#import "ALLNetworkURL.h"
#import "MXRSearchTopicModel.h"
//#import "BookShelfManger.h"
#import "BookInfoForShelf.h"
#import "MXRBookSNSSendDetailProxy.h"
#import "NSMutableURLRequest+Ex.h"
#import <AFNetworking/AFNetworking.h>
#import "MXRBase64.h"
#import "MXRQiNiuUploadTokenModel.h"
#import "MXRSNSSendStateViewController.h"
#import "MXRConstant.h"
#import "MXRSNSShareModel.h"
#import "MXRBookSNSSendDetailManager.h"
#import "Notifications.h"
#import "MXRBookStarModel.h"
#import "MXRBookSNSModelProxy.h"
#import "MXRBookSNSMomentStatusNoUploadManager.h"
//#import <QiniuSDK.h>
//#import "MXRQiNiuHelper.h"
#import "MXRNetworkManager.h"




static NSInteger ErrCode = 600002;
@interface MXRBookSNSSendDetailController()

@end

@implementation MXRBookSNSSendDetailController

+(instancetype)getInstance{
    static MXRBookSNSSendDetailController *instance;
    static dispatch_once_t pre;
    dispatch_once(&pre, ^{
        instance = [[MXRBookSNSSendDetailController alloc] init];
    });
    return instance;
}

-(instancetype)init{
    if (self=[super init]) {
        
    }
    return self;
}

//-(void)saveBookFromBookShelf{
//    NSArray *bookArray = [BookShelfManger bookList];
//    NSMutableArray *finalArray = [[NSMutableArray alloc]init];
//    //筛选书架中未上传的DIY图书
//    for (BookInfoForShelf *bookInfo in bookArray) {
//
//        if (bookInfo.bookType == BOOK_TYPE_DIY ||bookInfo.bookType == BOOK_TYPE_UPLOAD_DIY) {
//            // 只有审核通过的图书才能显示
//            if (bookInfo.bookStatus == MXRBookUploadStateOnShelf) {
//                [finalArray addObject:bookInfo];
//            }else{
//
//            }
//        }else{
//            [finalArray addObject:bookInfo];
//        }
//    }
//    [[MXRBookSNSSendDetailProxy getInstance]saveShelfBooksInformationWithArray:finalArray];
//}

#pragma mark - 搜索话题接口
//根据关键字来搜索 话题
-(void)searchTopicByKeyword:(NSString*)keyWord WithCallBack:(void(^)(BOOL))callBack
{
    @MXRWeakObj(self);
    NSString *newKeyWord; //关键字的第一个字
    if (keyWord.length<1 || [keyWord isEqualToString:HotTopicArrayKey]) {
        return;
    }
    else{
        newKeyWord = [keyWord substringWithRange:NSMakeRange(0, 1)];
    }
    if ([self.searchTopicKeyWordArray containsObject:newKeyWord]) {  //判断请求队列中是否已经存在该关键字的请求
        return;
    }
    [self addStringToSearchTopicKeyWordArray:newKeyWord];           //将该请求加入到请求队列中
    
    NSString *requestUrlStr = ServiceURL_Community_Topics_Fuzzy_Query;
    requestUrlStr = [requestUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //转为UTF8防止中文会出现无法请求的情况
    
    NSDictionary *paramDict = @{@"topic_name":autoString(newKeyWord),
                                };
    
    
    [MXRNetworkManager mxr_get:requestUrlStr parameters:paramDict success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        NSMutableArray *resultArray = [NSMutableArray new];
        if (response.isSuccess && response.body) {
            NSArray *array = (NSArray *) response.body;
            for (NSDictionary *dict in array) {
                MXRSearchTopicModel *model = [[MXRSearchTopicModel alloc] initWithDict:dict];
                [resultArray addObject:model];
            }
            if (callBack) {
                callBack(YES);
            }
        }else{
            if (callBack) {
                callBack(YES);
            }
        }
        //将获取到的数组 需要添加到缓存池中的数组中 cacheSearchTopicArray
        [[MXRBookSNSSendDetailProxy getInstance] setOneSearchTopicArrayToSearchTopicArray:resultArray WithKey:keyWord postNotification:YES];
        [selfWeak removesStringFromeTopicKeyWordArray:newKeyWord];
    } failure:^(NSURLSessionTask *task, NSError *error) {
        //服务错误
        [selfWeak removesStringFromeTopicKeyWordArray:newKeyWord];
        if (callBack) {
            callBack(NO);
        }
    }];
}

//根据页码 和 pageSize获取热门话题
-(void)getHotTopicWithPage:(NSInteger)page WithPageSize:(NSInteger)pageSize WithCallBack:(void(^)(BOOL))callBack
{
    
    NSDictionary *paramDict = @{@"page" : @(page),
                                @"rows" : @(pageSize)
                                };
    

    NSString *urlString = ServiceURL_Community_Topics_Hot;
    NSString *requestUrlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //转为UTF8防止中文会出现无法请求的情况
    [MXRNetworkManager mxr_get:requestUrlStr parameters:paramDict success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        NSMutableArray *resultArray = [NSMutableArray new];
        if (response.isSuccess && response.body) {
            NSDictionary *dict = (NSDictionary *)response.body;
            NSArray *array = dict[@"list"];
            if (array.count>0) {
                for (NSDictionary *dict in array) {
                    MXRSearchTopicModel *model = [[MXRSearchTopicModel alloc] initWithDict:dict];
                    // 去除动态数为0的动态
                    if (model.publishDynamicNum != 0) {
                        [resultArray addObject:model];
                    }
                }
            }
            if ([dict[@"hasNextPage"] integerValue]== 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Have_NoMore_Topic object:nil];
            }
            //将获取到的数组 需要添加到缓存池中的数组中 cacheSearchTopicArray
            [[MXRBookSNSSendDetailProxy getInstance] setOneSearchTopicArrayToSearchTopicArray:resultArray WithKey:HotTopicArrayKey postNotification:YES];
            
            if ([dict[@"hasNextPage"] integerValue]== 0) {
                if (callBack) {
                    callBack(NO);
                }
            }else {
                if (callBack) {
                    callBack(YES);
                }
            }
            
            
        }else{
            if (callBack) {
                callBack(NO);
            }
        }
        
       
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (callBack) {
            callBack(NO);
        }
    }];
}
#pragma mark - 管理搜索话题的操作方法
-(void)addStringToSearchTopicKeyWordArray:(NSString*)keyWord
{
    if (keyWord) [self.searchTopicKeyWordArray addObject:keyWord];
}
-(void)removesStringFromeTopicKeyWordArray:(NSString*)keyWord
{
    if (keyWord) [self.searchTopicKeyWordArray removeObject:keyWord];
    
}
-(void)removeSearchTopicKeyWordArray
{
    [self.searchTopicKeyWordArray removeAllObjects];
}

#pragma mark - 判断数组中是否存在 某个话题
-(BOOL)checkIsCurrentTopicExistinArray:(NSArray*)topicArray WithTopicName:(NSString*)topicName{
    BOOL result = NO;
    NSString *newTopicName = [NSString stringWithFormat:@"#%@#",topicName];
    for (MXRSearchTopicModel *model in topicArray) {
        if([model.name isEqualToString:newTopicName]){
            result = YES;
            break;
        }
    }
    return result;
}


#pragma mark - getter
-(NSMutableArray*)searchTopicKeyWordArray
{
    if (!_searchTopicKeyWordArray) {
        _searchTopicKeyWordArray = [NSMutableArray new];
    }
    return _searchTopicKeyWordArray;
}

// 动态获取七牛上传token
-(void)dynamicAcquisitionQiNiuUploadTokenUserId:(NSString *)userId moduleName:(NSString *)moduleName callBack:(void (^)(BOOL))callBack {
    
    NSDictionary *paramDict = @{@"moduleName" : autoString(moduleName)};
    NSString *str = ServiceURL_Community_Dynamics_Qiniu_Uploadtoken;
    [MXRNetworkManager mxr_get:str parameters:paramDict success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess && response.body) {
            NSDictionary *dict = (NSDictionary *)response.body;
            MXRQiNiuUploadTokenModel *model = [[MXRQiNiuUploadTokenModel alloc]initWithDict:dict];
            [[MXRBookSNSSendDetailProxy getInstance].qiNiuUploadTokenArray removeAllObjects];//先移除之前缓存的配置
            [[MXRBookSNSSendDetailProxy getInstance].qiNiuUploadTokenArray addObject:model];
        }
        if (callBack) {
            callBack(YES);
        }
        
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (callBack) {
            callBack(NO);
        }
    }];
}
// 发送本地动态
-(void)sendDynamicDetail:(MXRSNSShareModel*)shareModel callBack:(void (^)(BOOL))callBack
{
    MXRSNSSendModel *model = (MXRSNSSendModel*)shareModel;
    NSString *moduleName = @"dynamic";
    //动态中没有图片的时候，直接发送
    if (model.imageArray.count == 0) {
        [self sendDetailInformationWithSendModel: model WithUrlString:nil WithType:MXRBooKSNSSendDetailImageTypeHorizontal withCallBack:^(BOOL isOkay) {
            callBack ? callBack(isOkay) : NULL;
        }];
    }else{
        //有图片,如果没有token,请求token
        if ([MXRBookSNSSendDetailProxy getInstance].qiNiuUploadTokenArray.count == 0) {
            @MXRWeakObj(self);
            [self dynamicAcquisitionQiNiuUploadTokenUserId:model.senderId moduleName:moduleName callBack:^(BOOL isOkay) {
                if (isOkay) {
//                    [selfWeak prepareSendImagesToQiNiuWithModel:model completion:^(BOOL isOkay) {
//                        if (isOkay) {
//                            NSString *totalPicString = model.imageArray[0].imageUrl;
//                            for (int i = 1; i< model.imageArray.count; i++) {
//                                totalPicString = [NSString stringWithFormat:@"%@,%@",totalPicString,model.imageArray[i].imageUrl];
//                            }
//                            [selfWeak sendDetailInformationWithSendModel:model WithUrlString:totalPicString WithType:model.imageArray[0].shapeType withCallBack:^(BOOL isOkay) {
//                                callBack ? callBack(isOkay) : NULL;
//                            }];
//                        }
//                    }];
                }else{
                    callBack ? callBack(NO) : NULL;
                }
            }];
        // 有图片 有token
        }else{
            @MXRWeakObj(self);
//            [self prepareSendImagesToQiNiuWithModel:model completion:^(BOOL isOkay) {
//                if (isOkay) {
//                    NSString *totalPicString = model.imageArray[0].imageUrl;
//                    for (int i = 1; i< model.imageArray.count; i++) {
//                        totalPicString = [NSString stringWithFormat:@"%@,%@",totalPicString,model.imageArray[i].imageUrl];
//                    }
//                    [selfWeak sendDetailInformationWithSendModel:model WithUrlString:totalPicString WithType:model.imageArray[0].shapeType withCallBack:^(BOOL isOkay) {
//                        callBack ? callBack(isOkay) : NULL;
//                    }];
//                }else{
//                    callBack ? callBack(NO) : NULL;
//                }
//            }];
        }
    }
}
/**
 准备上传 所需的 图片,图片key(名字),token

 @param model
 @param completion
 */
//- (void)prepareSendImagesToQiNiuWithModel:(MXRSNSSendModel *)model completion:(void (^)(BOOL isOkay))completion
//{
//    //更新图片地址路径
//    [[MXRBookSNSSendDetailProxy getInstance]changeImageInfoUrlWithImageInfoArray:model.imageArray];
//    NSMutableArray *imagesArray = [[NSMutableArray alloc]init];         // 图片
//    NSMutableArray *keyStringArray = [[NSMutableArray alloc]init];      // 图片的名字
//    NSMutableArray *tokenArray  = [[NSMutableArray alloc]init];         // token数组
//    [model.imageArray enumerateObjectsUsingBlock:^(MXRBookSNSUploadImageInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [imagesArray addObject:obj.image];
//        [keyStringArray addObject:obj.keyString];
//        [tokenArray addObject:[MXRQiNiuHelper makeBookSNSDynamicsImageUploadTokenWithFileName:obj.keyString]];
//    }];
//    [self uploadImagesToQNService:imagesArray imageKeyStringArray:keyStringArray index:0 tokenArray: tokenArray completion:^(BOOL finish) {
//        completion ? completion(finish) : NULL;
//    }];
//}


/**
 上传所有图片

 @param imagesArray 图片数组
 @param keyStringArray 图片名字数组
 @param index 当前的位置
 @param tokenArray
 @param completion
 */
- (void)uploadImagesToQNService:(NSMutableArray *)imagesArray  imageKeyStringArray:(NSMutableArray *)keyStringArray  index:(NSInteger )index tokenArray:(NSMutableArray *)tokenArray   completion:(void(^)(BOOL finish))completion{
    if (imagesArray.count != keyStringArray.count ) return;
    if (index >= imagesArray.count) completion ? completion(YES) : NULL;
    __block  NSInteger currentIndex = index;
    if (imagesArray.count > 0 && imagesArray.count > index) {
        @MXRWeakObj(self);
//        [self uploadOneImage:imagesArray[index] keyString:keyStringArray[index] token:tokenArray[index] callBack:^(BOOL isSuccess) {
//            if (isSuccess) {
//                DLOG(@"图片上传成功 %ld",currentIndex);
//                currentIndex ++;
//                [selfWeak uploadImagesToQNService:imagesArray imageKeyStringArray:keyStringArray index:currentIndex tokenArray: tokenArray completion:^(BOOL finish) {
//                    if(completion) completion(finish);
//                }];
//            }else{
//                DLOG(@"图片上传失败 %ld",currentIndex);
//            }
//        }];
    }
}

/**
 上传单张图片的实现

 @param image 图片
 @param keyString 图片的key
 @param token 上传该图片所需的token
 @param callBack
 */
//-(void)uploadOneImage:(UIImage *)image keyString:(NSString *)keyString  token:(NSString *)token callBack:(void (^)(BOOL isSuccess))callBack{
//
//    NSData *imageData = UIImagePNGRepresentation(image);
//    if (!imageData) imageData = UIImageJPEGRepresentation(image, 1.0f);
//    if (!imageData) return ;
//    QNUploadOption *op = [[QNUploadOption alloc]initWithMime:nil progressHandler:nil params:nil checkCrc:NO cancellationSignal:nil];
//    QNUploadManager *upManager = [[QNUploadManager alloc] init];
//    [upManager putData:imageData key:keyString token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        if (callBack) callBack(info.isOK);
//    } option:op];
//}

//MXRSNSShareModel
-(void)sendDetailInformationWithSendModel:(MXRSNSSendModel*)model WithUrlString:(NSString*)picUrlString WithType:(MXRBooKSNSSendDetailImageType)type  withCallBack:(void(^)(BOOL isOkay))callBack {
    
    [self sendDetailInformationToServiceWithUserID:model.senderId withUserName:model.senderName WithUserLogo:model.senderHeadUrl WithClientUUId:model.clientUuid  WithContentWord:model.momentDescription WithBookId:model.bookGuid WithBookPicURL:model.bookIconUrl WithContentBookName:model.bookName WithContentPic:picUrlString WithContentBookStarlevel:[model.bookStars integerValue] WithImageShapeType:type  WithMXRSNSSendModel:model withQaId:autoInteger(model.qaId) WithCallBack:^(BOOL isOkay) {
        if (callBack) callBack(isOkay);
    }];
}
//上传图片 完毕之后 发送动态 至 服务器
-(void)sendDetailInformationToServiceWithUserID:(NSString *)userId withUserName:(NSString *)userName WithUserLogo:(NSString *)userLogo WithClientUUId:(NSString *)clientUUid WithContentWord:(NSString *)contentWord WithBookId:(NSString *)contentBookId WithBookPicURL:(NSString *)bookPicURL WithContentBookName:(NSString *)contentBookName WithContentPic:(NSString *)totalUrlString WithContentBookStarlevel:(NSInteger)starLevel WithImageShapeType:(MXRBooKSNSSendDetailImageType)type WithMXRSNSSendModel:(MXRSNSSendModel *)model withQaId:(NSInteger)qaId WithCallBack:(void (^)(BOOL))callBack
{
    NSInteger contentType;
    if (model.bookContentType == MXRBookSNSDynamicBookContentTypeSingleBook) {
        contentType = 1;
    }else if(model.bookContentType == MXRBookSNSDynamicBookContentTypeMutableBook){
        contentType = 2;
    }else{
        contentType = 3;
    }
    
    NSDictionary *params;
    if (totalUrlString == nil ) {
        params=@{@"userId":@([userId integerValue]),
                 @"userName":autoString(userName),
                 @"userLogo":autoString(userLogo),
                 @"contentWord":autoString(contentWord),
                 @"contentBookId":autoString(contentBookId),
                 @"contentBookName":autoString(contentBookName),
                 @"contentBookStarlevel":@(starLevel),
                 @"clientUuid":autoString(clientUUid),
                 @"contentBookLogo":autoString(bookPicURL),
                 @"bookContentType" : @(contentType),
                 @"contentZoneId" : autoString(model.contentZoneId),
                 @"contentZoneName" : autoString(model.contentZoneName),
                 @"contentZoneCover" : autoString(model.contentZoneCover),
                 @"qaId": @(autoInteger(model.qaId))
                 };
    }else if(totalUrlString != nil && type) {
        NSString * typeString;
        if (type == MXRBooKSNSSendDetailImageTypeVertical) {
            typeString = @"V";
        }else if (type == MXRBooKSNSSendDetailImageTypeHorizontal){
            typeString = @"H";
        }else if(type == MXRBooKSNSSendDetailImageTypeSquare){
            typeString = @"S";
        }
        
        params = @{@"userId":@([userId integerValue]),
                 @"userName":autoString(userName),
                 @"userLogo":autoString(userLogo),
                 @"contentWord":autoString(contentWord),
                 @"contentBookId":autoString(contentBookId),
                 @"contentBookName":autoString(contentBookName),
                 @"contentBookStarlevel":@(starLevel),
                 @"contentBookLogo":autoString(bookPicURL),
                 @"contentPic": autoString(totalUrlString),
                 @"contentPicType":autoString(typeString),
                 @"clientUuid":autoString(clientUUid),
                 @"bookContentType" : @(contentType),
                 @"contentZoneId" : autoString(model.contentZoneId),
                 @"contentZoneName" : autoString(model.contentZoneName),
                 @"contentZoneCover" : autoString(model.contentZoneCover),
                 @"qaId": @(autoInteger(model.qaId))
                 };
    }else if(totalUrlString != nil && !type){
        params = @{@"userId":@([userId integerValue]),
                 @"userName":autoString(userName),
                 @"userLogo":autoString(userLogo),
                 @"contentWord":autoString(contentWord),
                 @"contentBookId":autoString(contentBookId),
                 @"contentBookName":autoString(contentBookName),
                 @"contentBookStarlevel":@(starLevel),
                 @"contentBookLogo":autoString(bookPicURL),
                 @"contentPic":autoString(totalUrlString),
                 @"clientUuid":autoString(clientUUid),
                 @"bookContentType" : @(contentType),
                 @"contentZoneId" : autoString(model.contentZoneId),
                 @"contentZoneName" : autoString(model.contentZoneName),
                 @"contentZoneCover" : autoString(model.contentZoneCover),
                 @"qaId": @(autoInteger(model.qaId))
                 };
    }

    
    [MXRNetworkManager mxr_post:ServiceURL_Community_Dynamics parameters:params success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            MXRSNSShareModel *shareModel;
            if ([response.body isKindOfClass:[NSDictionary class]]) {
                shareModel = [[MXRSNSShareModel alloc]createWithDictionary:response.body];
            }else{
                
            }
            //改变数据源中的momentId
            if (shareModel) {
                [[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([shareModel.clientUuid isEqualToString:obj.clientUuid]) {
                        [obj MXRSetMomentId: shareModel.momentId];
                        [obj MXRSetSenderTime:shareModel.senderTime];
                        *stop = YES;
                    }
                }];
            }else{
                
            }
            if (callBack) callBack(YES);
        }else{
            DLOG(@"%@",response.errMsg);
            if (callBack) callBack(NO);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (callBack) {
            callBack(NO);
        }
    }];
    

}

/**
 转发的服务

 @param model
 @param isShowPrompt 是否显示 操作失败 toast
 @param callback
 */
-(void)transmitDetailInformationToServiceWith:(MXRSNSShareModel*)model isShowFailPrompt:(BOOL)isShowPrompt withCallBack:(void (^)(BOOL))callback{
    MXRSNSTransmitModel *transmitModel = (MXRSNSTransmitModel*)model;
    NSInteger contentType;
    if (transmitModel.bookContentType == MXRBookSNSDynamicBookContentTypeSingleBook) {
        contentType = 1;
    }else if(transmitModel.bookContentType == MXRBookSNSDynamicBookContentTypeMutableBook){
        contentType = 2;
    }else{
        contentType = 3;
    }
    NSDictionary *params;
    if (transmitModel.orginalModel.totalPicUrl) {
        params = @{@"userId":@([model.senderId integerValue]),
                   @"contentBookId": autoString(transmitModel.orginalModel.bookGuid),
                   @"contentBookName":autoString(transmitModel.orginalModel.bookName),
                   @"contentBookLogo":autoString(transmitModel.orginalModel.bookIconUrl),
                   @"contentBookStarlevel":@([transmitModel.orginalModel.bookStars integerValue]),
                   @"contentPic":autoString(transmitModel.orginalModel.totalPicUrl),
                   @"userName":autoString(transmitModel.senderName),
                   @"userLogo":autoString(transmitModel.senderHeadUrl),
                   @"srcId":@([transmitModel.orginalModel.momentId integerValue]),
                   @"srcUserId":@([transmitModel.orginalModel.senderId integerValue]),
                   @"srcUserName":autoString(transmitModel.orginalModel.senderName),
                   @"retransmissionWord": autoString(transmitModel.momentDescription),
                   @"clientUuid":autoString(transmitModel.clientUuid),
                   @"bookContentType" : @(contentType),
                   @"contentZoneId" : autoString(model.contentZoneId),
                   @"contentZoneName" : autoString(model.contentZoneName),
                   @"contentZoneCover" : autoString(model.contentZoneCover),
                   @"qaId": @(autoInteger(model.qaId))
                   };
    }else{
        params = @{@"userId":@([transmitModel.senderId integerValue]),
                 @"contentBookId": autoString(transmitModel.orginalModel.bookGuid),
                 @"contentBookName":autoString(transmitModel.orginalModel.bookName),
                 @"contentBookLogo":autoString(transmitModel.orginalModel.bookIconUrl),
                 @"contentBookStarlevel":@([transmitModel.orginalModel.bookStars integerValue]),
                 @"userName":autoString(transmitModel.senderName),
                 @"userLogo":autoString(transmitModel.senderHeadUrl),
                 @"srcId":@([transmitModel.orginalModel.momentId integerValue]),
                 @"srcUserId":@([transmitModel.orginalModel.senderId integerValue]),
                 @"srcUserName":autoString(transmitModel.orginalModel.senderName),
                 @"retransmissionWord": autoString(transmitModel.momentDescription),
                 @"clientUuid":autoString(transmitModel.clientUuid),
                 @"bookContentType" : @(contentType),
                 @"contentZoneId" : autoString(transmitModel.contentZoneId),
                 @"contentZoneName" : autoString(transmitModel.contentZoneName),
                 @"contentZoneCover" : autoString(transmitModel.contentZoneCover),
                 @"qaId": @(autoInteger(model.qaId))
                 };
    
    }
    
    
    [MXRNetworkManager mxr_post:ServiceURL_Community_Dynamics_User_Forward parameters:params success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
    
        NSInteger errCode = [response.errCode integerValue];
        // 原动态已删除
        if (errCode == ErrCode) {
            if (isShowPrompt) {
                [MXRConstant showAlert:MXRLocalizedString(@"MXRBookSNSPromptFail", @"操作失败") andShowTime:2.0f];
            }
            [[MXRBookSNSModelProxy getInstance] deleteMomentWithId:transmitModel.momentId];
            [[MXRBookSNSModelProxy getInstance] deleteMomentWithId:transmitModel.orginalModel.momentId];
        }

        if (callback) {
            if (response.isSuccess) {
                MXRSNSShareModel *shareModel;
                if ([response.body isKindOfClass:[NSDictionary class]]) {
                    shareModel = [[MXRSNSShareModel alloc]createWithDictionary:response.body];
                }else{
                    
                }
                //改变数据源中的momentId
                if (shareModel) {
                    [[MXRBookSNSModelProxy getInstance].bookSNSMomentsArray enumerateObjectsUsingBlock:^(MXRSNSShareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([shareModel.clientUuid isEqualToString:obj.clientUuid]) {
                            [obj MXRSetMomentId: shareModel.momentId];
                            [obj MXRSetSenderTime:shareModel.senderTime];
                            *stop = YES;
                        }
                    }];
                }else{
                    
                }
            }
            
            callback(response.isSuccess);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (callback) {
            callback(NO);
        }
    }];
    

}
//获得图书星级
-(void)getBookStarWithBookGuids:(NSString*)bookGuids callBack:(void (^)(BOOL isOkay))callBack{

    NSDictionary * param = @{@"guids":bookGuids};
    
    [MXRNetworkManager mxr_post:ServiceURL_Community_Books_Stars parameters:param success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (response.isSuccess) {
            NSArray *array = response.body;
            for (NSDictionary *dict in array) {
                MXRBookStarModel *model = [[MXRBookStarModel alloc]initWithDict:dict];
                [[MXRBookSNSSendDetailProxy getInstance].bookStarModelArray addObject:model];
            }
            if (callBack){
                callBack(YES);
            }
        }else{
            if (callBack) {
                callBack(NO);
            }
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        DLOG(@"网络连接失败");
        if (callBack)
        {
            callBack(NO);
        }
    }];


}

//获取当前的网络状态
-(BOOL)getNetStatus
{
    BOOL isNet;
    // 判断网络状态 无网络的话
    AFNetworkReachabilityManager *mangaer = [AFNetworkReachabilityManager sharedManager];
    NSString* netStatus=[mangaer localizedNetworkReachabilityStatusString];
    if ([netStatus isEqualToString:@"Not Reachable"] || [netStatus isEqualToString:@"Unknown"]){
        isNet = NO;
    }
    else{
        isNet = YES;
    }
    return isNet;
}

@end
