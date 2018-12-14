//
//  MXRBookSNSSendDetailProxy.m
//  huashida_home
//
//  Created by yuchen.li on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSSendDetailProxy.h"
#import "MXRQiNiuUploadTokenModel.h"
#import "MXRSearchTopicModel.h" 
#import "Notifications.h"
#import "MXRSNSShareModel.h"
#import "GlobalFunction.h"
#import "MXRDeviceUtil.h"

@implementation MXRBookSNSSendDetailProxy
+(instancetype)getInstance{
    static MXRBookSNSSendDetailProxy *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[MXRBookSNSSendDetailProxy alloc]init];
    });
    return instance;
}
-(instancetype)init{
    self=[super init];
    if (self) {
        _bookDataArray = [NSMutableArray new];
        _selectImageArray = [NSMutableArray new];
        _qiNiuUploadTokenArray = [NSMutableArray new];
        _imageInfoArray = [[NSMutableArray alloc]init];
        _bookStarModelArray = [NSMutableArray new];
        }

    return self;

}

-(void)changeImageInfoUrlWithImageInfoArray:(NSMutableArray *)imageInfoArray
{
    MXRQiNiuUploadTokenModel*model;
    if ([MXRBookSNSSendDetailProxy getInstance].qiNiuUploadTokenArray.count>0) {
        model=[MXRBookSNSSendDetailProxy getInstance].qiNiuUploadTokenArray[0];
    }
    for (MXRBookSNSUploadImageInfo*imageInfo in imageInfoArray) {
        NSString *key = [NSString stringWithFormat:@"%@/%@.png",model.folderName,[MXRDeviceUtil getUUID]];//图片上传的key值
        [imageInfo MXRSetKeyString:key];
        NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",model.cdnAddr,key]; //图片上传到七牛后的url
        [imageInfo  MXRSetImageUrl:imageUrl];
        NSString *shrinkImageUrl = [NSString stringWithFormat:@"%@%@",imageUrl,QiNiuShrink]; //缩略图的七牛url
        [imageInfo MXRSetShrinkImageUrl:shrinkImageUrl];
    }
}
/**
 将图片转化为 imageInfo  在上传之前 获取每个图片的url
 
 @param imageArray 图片数组
 */
-(void)getImageUrlAndStateWithImageArray:(NSMutableArray*)imageArray {
    for (int i = 0; i < imageArray.count; i++) {
        MXRBookSNSUploadImageInfo *imageInfo = [[MXRBookSNSUploadImageInfo alloc]initWithImage:imageArray[i]];
        [_imageInfoArray addObject:imageInfo];
    }
}
#pragma mark-搜索图书
-(void)saveShelfBooksInformationWithArray:(NSArray *)bookArray
{
    _bookDataArray = (NSMutableArray *)bookArray;
}
#pragma mark - 搜索话题 对数组的操作方法
//根据key值 到缓存的数组中查找 内容  如果返回nil那么 表明 需要去请求 服务，，返回 空数组 表明为 该话题为新话题
-(NSMutableArray*)getOneSearchTopicArrayByKey:(NSString*)key{
    NSMutableArray *array = nil;
    if (!key) {       //防止传入的key值 有问题
        return array;
    }
    for (NSDictionary *dict in self.cacheSearchTopicArray) {
        if (dict.allKeys.count<1) {
            continue;
        }
        //在缓存的数组中 查找 符合条件的 结果
        if ([key rangeOfString:[dict.allKeys firstObject]].location != NSNotFound) {
            NSMutableArray *resultArray = [NSMutableArray new];
            NSArray *tempArray = dict[[dict.allKeys firstObject]];
            for (MXRSearchTopicModel *model in tempArray) {
                if ([model.name rangeOfString:key].location != NSNotFound || [key isEqualToString:HotTopicArrayKey]) {
                    [resultArray addObject:model];
                }
            }
            return resultArray;
        }
    }
    return array;
}

//覆盖缓存池中的数组 不需要 管原来的数据
-(void)setStrongOneSearchTopicArrayToSearchTopicArray:(NSArray*)array WithKey:(NSString*)key
{
    if([key isEqualToString:HotTopicArrayKey]){ //如果是热门话题的话 走这边
        if (array.count>0) {
            NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:HotTopicArrayKey];
            for (int i = 0; i<self.cacheSearchTopicArray.count; i++) {//如果原数组存在  需要删除原来的
                NSDictionary *dict = self.cacheSearchTopicArray[i];
                if([dict objectForKey:HotTopicArrayKey])
                {
                    [self.cacheSearchTopicArray removeObjectAtIndex:i];
                    break;
                }
            }
            [self.cacheSearchTopicArray addObject:dict];
        }
    }
    else{                               //搜索的走这边
        if (array&&key) {
            for (int i = 0; i<self.cacheSearchTopicArray.count; i++) {//如果原数组存在  需要删除原来的
                NSDictionary *dict = self.cacheSearchTopicArray[i];
                if([dict objectForKey:key])
                {
                    [self.cacheSearchTopicArray removeObjectAtIndex:i];
                    break;
                }
            }
            NSDictionary *dict = [NSDictionary  dictionaryWithObjects:@[array] forKeys:@[key]];
            [self.cacheSearchTopicArray addObject:dict];
        }
    }
}

//将 某个关键字的搜索结果 放到cacheSearchTopicArray 数组中  如果原数组中存在该关键字的查询结果 我们需要覆盖原来的
-(void)setOneSearchTopicArrayToSearchTopicArray:(NSArray*)array WithKey:(NSString*)key postNotification:(BOOL)isPostNotification
{
    if([key isEqualToString:HotTopicArrayKey]){ //如果是热门话题的话 走这边
        if (array.count>0) {
            NSMutableArray *reslutArray = [self mixHotTopicArrayWithArray:array];   //将网络获取的和本地存储的混合
            NSDictionary *dict = [NSDictionary dictionaryWithObject:reslutArray forKey:HotTopicArrayKey];
            [self.cacheSearchTopicArray addObject:dict];
            if (isPostNotification) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SearchTopic_RefreshView object:nil];
            }
            
        }
    }
    else{                               //搜索的走这边
        if (array&&key) {
            for (int i = 0; i<self.cacheSearchTopicArray.count; i++) {//如果原数组存在  需要删除原来的
                NSDictionary *dict = self.cacheSearchTopicArray[i];
                if([dict objectForKey:key])
                {
                    [self.cacheSearchTopicArray removeObjectAtIndex:i];
                    break;
                }
            }
            NSDictionary *dict = [NSDictionary  dictionaryWithObjects:@[array] forKeys:@[key]];
            [self.cacheSearchTopicArray addObject:dict];
            
            if (isPostNotification) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SearchTopic_RefreshView object:nil];
            }
        }
    }
}
//私有方法
-(NSMutableArray*)mixHotTopicArrayWithArray:(NSArray*)array
{
    NSMutableArray *resultArray = [NSMutableArray new];
    NSArray *exsitArray = nil;
    for (int i = 0; i<self.cacheSearchTopicArray.count; i++) {//如果原数组存在  需要删除原来的
        NSDictionary *dict = self.cacheSearchTopicArray[i];
        if([dict objectForKey:HotTopicArrayKey])
        {
            exsitArray = dict[HotTopicArrayKey];
            [self.cacheSearchTopicArray removeObjectAtIndex:i];
            break;
        }
    }
    if (!exsitArray) {
        [resultArray addObjectsFromArray:array];
        return resultArray;
    }
    else{
        [resultArray addObjectsFromArray:exsitArray];
    }
    for (MXRSearchTopicModel *model in array) {
        BOOL flag = NO;
        for (MXRSearchTopicModel *subModel in exsitArray) {
            if (subModel.topicId == model.topicId) {
                flag = YES;
                break;
            }
        }
        if (!flag) {
            [resultArray addObject:model];
        }
    }
    return resultArray;
}

//删除某个key值所对应数组的某个模型
-(NSInteger)removeModelWithKey:(NSString*)key topicId:(NSString*)topicId
{
    NSInteger index = 0;
    NSMutableArray *mutableArray = [self getOneSearchTopicArrayByKey:key];
    if (!mutableArray) {
        return -1;
    }
    for (MXRSearchTopicModel *model in mutableArray) {
        if (model.topicId == [autoNumber(topicId) integerValue]) {
            [mutableArray removeObject:model];
            break;
        }
        index++;
    }
    [self setStrongOneSearchTopicArrayToSearchTopicArray:mutableArray WithKey:key];
    return index;
}
//删除 cacheSearchTopicArray数组
-(void)removecacheSearchTopicArray
{
    [self.cacheSearchTopicArray removeAllObjects];
}

-(void)removeAllImageInfo{
    [_imageInfoArray removeAllObjects];
}

-(void)removeAllSelectImage{
    [_selectImageArray removeAllObjects];
}

-(void)removeAllBookInfo{
    [_bookDataArray removeAllObjects];
}

-(void)removeQiNiuUploadImageToken{
    [_qiNiuUploadTokenArray removeAllObjects];
}



#pragma mark - getter
-(NSMutableArray*)cacheSearchTopicArray
{
    if (!_cacheSearchTopicArray) {
        _cacheSearchTopicArray = [[NSMutableArray alloc] init];
    }
    return _cacheSearchTopicArray;
}

@end
