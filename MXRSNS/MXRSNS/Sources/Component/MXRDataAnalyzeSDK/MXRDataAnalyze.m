//
//  MXRDataAnalyze.m
//  huashida_home
//
//  Created by weiqing.tang on 2017/2/6.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRDataAnalyze.h"
#import "NSObject+MXRModel.h"
#import "MXRDeviceUtil.h"
#import <objc/runtime.h>
#import "MXRConstant.h"

@implementation MXRDataAnalyze
//===================================================================================
/**
 存储用户行为信息
 */
+(BOOL)saveUesrAction:(MXRDataAction *)action {
      return [action updateToDB];
}


//===================================================================================


/**
 1.获取系统的信息 封装成json
 2.获取数据库的数据的其他action的信息封装成json，把json文件上传到服务器，并设置数据为不可见
 3.在上传之前调一下这个方法获取需要上传的信息

 @param accountType 登录方式
 @param account 账户信息
 @param phoneNo 电话号码
 @param userId 用户ID
 @param callBack 包含是否成功 和 系统信息 行为信息的字典
 */
+(void)prepareUploadActionInfoAccountType:(MXRDataAccountType)accountType  Account:(NSString *)account phoneNo:(NSString *)phoneNo userId:(NSString *)userId callBack:(void(^)(NSDictionary *totalParamDict,BOOL isOk))callBack{
    //1. 获取通用参数
    __weak __typeof(self) weakSelf = self;
    [self getGeneralInformationDataWithAccountType:accountType account:account phoneNo:phoneNo userId:userId callBack:^(NSDictionary *generalDict) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //2. 获取业务参数
            NSArray *allModels                =[strongSelf getAllUnuploadModel];
            NSArray *businessArray =[strongSelf getBusinessData:allModels];
            [businessArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSDictionary*businessDict=(NSDictionary*)obj;
                    [businessDict setValue:generalDict[@"sessionId"] forKey:@"sessionId"];
                }
            }];
            //3.修改数据库中每个行为的sessionId
            [strongSelf addSessionIdToDB:generalDict[@"sessionId"] modelArray:allModels];
            //4.拼接 所有参数
            NSDictionary *totalParamDict = [[NSDictionary alloc]initWithObjects:@[businessArray,generalDict] forKeys:@[@"customInfo",@"deviceInfo"]];
            
            if (callBack) {
                callBack(totalParamDict,YES);
            } 
        });
    }];
}
/**
 获取业务参数
 @return 通用参数的数组（里面包含的是字典）
 */
+(NSArray*)getBusinessData:(NSArray*)allModels{
    __block NSMutableArray *dictArray =[[NSMutableArray alloc]init];

    for (id  _Nonnull obj in allModels) {
        if ([obj isKindOfClass:[MXRDataAction class]]) {
            
            if ([obj isKindOfClass:[MXRDataDownloadAction class]]) {
                MXRDataDownloadAction *downloadAction = (MXRDataDownloadAction *)obj;
                // downloadAction.status 表示未下载完成  只统计下载完成的状态
                if (downloadAction.status == 0) {
                    continue;
                }
            }
            
            MXRDataAction *dataAction = (MXRDataAction*)obj;
            NSDictionary *dict = [dataAction toDictionary];
            [dictArray addObject:dict];
        }
    }
    return dictArray;
}

/**
 获得通用参数

 @param accountType 登录方式
 @param account 用户的注册账户 邮箱 或 手机号
 @param phoneNo 手机号
 @param userId 用户的唯一ID
 @param callBack 包含设备基本信息和用户信息的字典
 */
+(void)getGeneralInformationDataWithAccountType:(MXRDataAccountType)accountType account:(NSString *)account phoneNo:(NSString *)phoneNo userId:(NSString *)userId callBack:(void(^)(NSDictionary *generalDict))callBack{
    [self AccessToTheRegionalWithCallBack:^(NSDictionary *ipDict) {
        MXRDataSystemAction *systemAction;
        //获取到了IP和区域信息
        if (ipDict) {
            systemAction =[[MXRDataSystemAction alloc]initWithAccountType:accountType province:ipDict[@"region"] accoutId:account phoneNo:phoneNo userId:userId city:ipDict[@"city"] ip:ipDict[@"ip"]];
            //没有获取到IP和区域信息
        }else{
             systemAction =[[MXRDataSystemAction alloc]initWithAccountType:accountType province:MXRLocalizedString(@"DidNotCheckTheProvince", @"未查到省份") accoutId:account phoneNo:phoneNo userId:userId city:MXRLocalizedString(@"DidNotFindTheCity", @"未查到市区")  ip:MXRLocalizedString(@"DidNotFindIP", @"未查到IP")];
        }
        NSDictionary *systermInfoDict= [systemAction mxr_modelToJSONObject];
        if (callBack && systermInfoDict) {
            callBack(systermInfoDict);
        }
    }];
}

/**
 统一修改数据库中,每个行为的sessionId

 @param sessionId  系统信息中的sessionId
 @param modelArray 包含各种action模型的数组
 */
+(void)addSessionIdToDB:(NSString *)sessionId modelArray:(NSArray *)modelArray{
    [modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MXRDataAction class]]) {
            MXRDataAction *dataAction = (MXRDataAction *)obj;
            [dataAction changeSessionIdToDB:sessionId];
        }
    }];
}

/**
 获得未上传成功的model
 @return 存放model的数组
 */
+ (NSArray<MXRDataAction *> *)getAllUnuploadModel
{
        MXRDataActionUploadStatus uploadStatus =MXRDataActionUploadFailStatus;
        __block NSMutableArray * totalActionArray = [[NSMutableArray alloc]init];
        NSArray *classNameArray = [self getAllSubClass: @[[MXRDataAction class]]];
        for (Class class in classNameArray) {
            NSMutableArray * actionArray = [[class getUsingLKDBHelper]search:class where:@{@"uploadStatus":@(uploadStatus)} orderBy:nil offset:0 count:0];
            [totalActionArray addObjectsFromArray:actionArray];
        }
    return  totalActionArray;
}

/**
 获取一个类的所有子类, 子类 需要有 impletation 方法

 @param allClasses 类名 需要以 数组 的形式传递
 @return 包含所有类的数组
 */
+ (NSArray *)getAllSubClass:(NSArray *)allClasses{
    __block NSMutableArray * allClassContainArray = [[NSMutableArray alloc]init];
    __weak __typeof(self) weakSelf = self;
    [allClasses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        NSArray * clssessArray = [strongSelf findAllOf:obj];
        [allClassContainArray addObjectsFromArray:clssessArray];
    }];
    if (allClassContainArray.count == 0) {
        return  allClassContainArray;
    }else{
        return [allClassContainArray arrayByAddingObjectsFromArray:[self getAllSubClass:allClassContainArray]];
    }
}


/**
 获取 A类 的所有子类的类名

 @param defaultClass  A类
 @return 包含所有子类的数组
 */
+ (NSArray *)findAllOf:(Class)defaultClass

{
    
    int count = objc_getClassList(NULL, 0);
    
    if (count <= 0)
        
    {
        @throw@"Couldn't retrieve Obj-C class-list";
        
        return [NSArray arrayWithObject:defaultClass];
    }
    NSMutableArray *output = [[NSMutableArray alloc]init];
    Class *classes = (Class *) malloc(sizeof(Class) * count);
    objc_getClassList(classes, count);
    for (int i = 0; i < count; ++i) {
        if (defaultClass == class_getSuperclass(classes[i]))//子类
        {
            [output addObject:classes[i]];
        }
        
    }
    free(classes);
    return [NSArray arrayWithArray:output];
}
/**
 上传采集信息
 */

+(void)uploadAllUnuploadCollectDataAccountType:(MXRDataAccountType)accountType account:(NSString* )account phone:(NSString *)phoneNo userId:(NSString*)userId{
    [self prepareUploadActionInfoAccountType:accountType Account:account phoneNo:phoneNo userId:userId callBack:^(NSDictionary *totalParamDict, BOOL isOk) {
        if (totalParamDict && isOk) {
            NSArray *arrayAction = totalParamDict[@"customInfo"];
            if (arrayAction.count > 0) {
                __weak __typeof(self) weakSelf = self;
                [MXRCollectionDataController uploadcollectDataToServerWithDictionary:totalParamDict callBack:^(NSArray *unuploadArray,BOOL isSuccess) {
                    __strong __typeof(weakSelf) strongSelf = weakSelf;
                    if (!strongSelf) return;
                    if (isSuccess) {
                        if (unuploadArray) {
                            [strongSelf uploadActionFailureWithFailureInfoArray:unuploadArray];
                        }else{
                            [strongSelf uploadAllActionSuccess];
                        }
                    }else{
                        DLOG(@"上传采集数据失败");
                    }
                }];
            }
        }
    }];
}
/**
 全部上传成功
 */
+(void)uploadAllActionSuccess{
    
    [self modifyUploadStatusBecomeSuccess:[self getAllUnuploadModel]];
}

/**
 部分上传失败,修改数据库中部分数据为上传成功,其它为上传失败
 
 @param infoArray 包含上传失败行为的actionSessionId和行为type的字典 结构为{“type”:1,typeSessionId:”as65da6sd6a5s4d6as"}
 */
+(void)uploadActionFailureWithFailureInfoArray:(NSArray *)infoArray{
    if (infoArray.count==0) return;
    NSArray *allUnuploadArray =[self getAllUnuploadModel];
    __block NSMutableArray *allUnuploadCopyArray=[allUnuploadArray mutableCopy];
    //剔除上传失败的model
    [infoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *objDict =(NSDictionary *)obj;
            NSString *actionSessionId =objDict[@"typeSessionId"];
            [allUnuploadArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[MXRDataAction class]]) {
                    MXRDataAction *dataAction=(MXRDataAction*)obj;
                    if ([dataAction.actionSessionId isEqualToString:actionSessionId]) {
                        [allUnuploadCopyArray removeObjectAtIndex:idx];
                        *stop = YES;
                    }
                }
            }];
        }
    }];
    [self modifyUploadStatusBecomeSuccess:allUnuploadCopyArray];
}
/**
 * 修改上传状态为成功状态
 */
+(void)modifyUploadStatusBecomeSuccess:(NSArray *)modelArray{

    for (id  _Nonnull obj in modelArray) {
        if ([obj isKindOfClass:[MXRDataAction class]]) {
            if ([obj isKindOfClass:[MXRDataDownloadAction class]]) {
                MXRDataDownloadAction *downloadAction = (MXRDataDownloadAction *)obj;
                // downloadAction.status 表示未下载完成  只统计下载完成的状态
                if (downloadAction.status == 0) {
                    continue;
                }
            }
            MXRDataAction * dataAction = (MXRDataAction *)obj;
            [dataAction modifyUploadStatusBecomeSuccess];
        }
    }
}

/**
 根据sessionID从数据库里面查找对应的下载数据改变下载状态state
 
 bookGuid  图书的bookGuid
 */
+(void)modifyDownloadStatusBecomeSuccessWithBookGuid:(NSString *)bookGuid {
    
    NSMutableArray *downloadSuccessArray = [[MXRDataDownloadAction getUsingLKDBHelper]search:[MXRDataDownloadAction class] where:@{@"guid":autoString(bookGuid),@"uploadStatus":@(0)} orderBy:nil offset:0 count:0];
    if (downloadSuccessArray.count > 0) {
        MXRDataDownloadAction *downloadAction = [downloadSuccessArray firstObject];
        downloadAction.status = MXRDataUserActionSuccessStatus;
        [downloadAction updateToDB];
    }
}

/**
 请求上传采集数据方式
 */
+(void)requestUploadCollectDataWayWithCallBack:(void(^)(CollectWay collectWay,BOOL isSuccess))callBack {
    [[MXRCollectionDataController getInstance] requestTheWayOfCollectionDataWithCallBack:^(CollectWay collectWay, BOOL isSuccess) {
        if (callBack) {
            callBack(collectWay,isSuccess);
        }
    }];
}


/**
 获取地域信息
 @param callBack 地域信息
 */
+(void)AccessToTheRegionalWithCallBack:(void(^)(NSDictionary *ipDict))callBack {
    [MXRDeviceUtil getUserLocationIPWithCallBack:^(NSDictionary *ipDict, BOOL isOk) {
        //获取到了IP和区域信息
        if (ipDict && isOk) {
            if (callBack) {
                callBack(ipDict);
            }
            //没有获取到IP和区域信息
        }else{
            if (callBack) {
                callBack(nil);
            }
        }
    }];
}
@end
