//
//  MXRPKMedalInfoModel.h
//  huashida_home
//
//  Created by shuai.wang on 2018/1/20.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRPKMedalDetailModel : NSObject<MXRModelDelegate, NSCopying, NSCoding>
@property (nonatomic, copy) NSString *iconActive;         //激活后的勋章图片
@property (nonatomic, copy) NSString *iconInactive;       //没被激活的图片
@property (nonatomic, copy) NSString *name;               //勋章名称
@property (nonatomic, copy) NSString *qaMedalConditionDesc;    //勋章条件描述
@property (nonatomic, assign) NSInteger medalNum;     //勋章数量
@property (nonatomic, assign) NSInteger isHold;     //当前用户是否含有该勋章 0没有；1有
@property (nonatomic, assign) NSInteger medalId;    //勋章id
@property (nonatomic, assign) NSInteger qaMedalConditionId;    //条件id
@property (nonatomic, assign) NSInteger skipToQaClassifyId;    //该勋章对应的classifyId
@end



@interface MXRPKMedalInfoModel : NSObject <MXRModelDelegate, NSCopying, NSCoding>
@property (nonatomic, strong) NSArray <MXRPKMedalDetailModel *> *medalVos;
@property (nonatomic, assign) NSInteger medalCount;   //已获得的勋章数量
@end


