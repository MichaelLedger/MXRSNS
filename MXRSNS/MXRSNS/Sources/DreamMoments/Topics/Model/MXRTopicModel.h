//
//  MXRTopicModel.h
//  huashida_home
//
//  Created by dingyang on 16/9/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MXRModel.h"
@class BookInfoForShelf,MXRSubjectInfoModel;

@interface MXRTopicModel : NSObject<MXRModelDelegate>
typedef NS_ENUM(NSInteger, TopicHandleType){
    TopicHandleTypeNormal,
    TopicHandleTypeMoreTopic
};
typedef NS_ENUM(NSInteger, TopicRelevantDetail){
    TopicRelevantNone = 0,                  // 没有绑定图书或者专区
    TopicRelevantBook = 1,                  // 绑定图书
    TopicRelevantZone = 2                   // 绑定专区
};

@property (strong, nonatomic) NSString *createTime;
@property (assign, nonatomic) NSInteger topicId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *participateUserNum;
@property (strong, nonatomic) NSString *picUrl;
@property (copy, nonatomic) NSString *publishDynamicNum;
@property (strong, nonatomic) NSString *topicDescription;
@property (strong, nonatomic) NSMutableArray *dynamicList;
@property (assign, nonatomic) TopicHandleType topicType;
/* type为1时绑定图书，解析bookSmall,type为2时绑定专区解析 recommendZoneSmall */
@property (nonatomic, assign) TopicRelevantDetail relevantType;

/*关联的图书*/
@property (nonatomic, strong)BookInfoForShelf *bookInfo;
/*关联的专区*/
@property (nonatomic, strong)MXRSubjectInfoModel *zoneModel;


-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(instancetype)initMoreSystemItem;
@end
