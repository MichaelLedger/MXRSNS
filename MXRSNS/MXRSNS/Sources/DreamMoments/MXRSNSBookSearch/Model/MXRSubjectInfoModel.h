//
//  MXRSubjectInfoModel.h
//  huashida_home
//
//  Created by yuchen.li on 2017/6/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MXRZonePriceType) {
    MXRZonePriceFreeType = 0,   //免费
    MXRZonePriceMXZType  = 1    //梦想钻
};
@interface MXRSubjectInfoModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *subjectName;              // 专区名称
@property (nonatomic, copy) NSString *subjectCover;             // 专区封面
@property (nonatomic, copy) NSString *subjectDescription;       // 专区描述
@property (nonatomic, copy) NSString *subjectCreateTime;        // 创建时间戳
@property (nonatomic, copy) NSString *subjectUpdateTime;        // 更新时间戳

@property (nonatomic, assign) NSInteger subjectSort;            // 排序字段
@property (nonatomic, assign) NSInteger subjectID;              // 专区id

//5.9.3 Version 新加字段  by shuai.wang   start
@property (nonatomic, assign) NSInteger bookNum;                // 图书数量
@property (nonatomic, assign) NSInteger bookAveragePrice;       // 图书平均价格
@property (nonatomic, assign) NSInteger price;                  // 专区价格
@property (nonatomic, assign) NSInteger priceOld;               // 专区原价
@property (nonatomic, assign) MXRZonePriceType priceType;       // 价格类型
@property (nonatomic, assign) BOOL hasBuy;                      // 是否购买过专区
//5.9.3 Version 新加字段  by shuai.wang   end

//5.11.0 version 新加字段  by shuai.wang
@property (nonatomic, assign) NSInteger couponNum;              //优惠券数量
//5.13.0 version  by shuai.wang
@property (nonatomic, assign) BOOL vipFlag;                     //专区是否绑定优惠券
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
