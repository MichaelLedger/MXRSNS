//
//  MXRPKHomeRankingInfoResponseModel.h
//  huashida_home
//
//  Created by 周建顺 on 2018/1/20.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MXRPKHomeRankingInfoResponseModel : NSObject <NSCoding>

@property (nonatomic) NSInteger medalCount; // 勋章数
//@property (nonatomic, copy) NSString *userIcon; // 头像
//@property (nonatomic, copy) NSString *userId;
//@property (nonatomic, copy) NSString *userName; // 用户名
@property (nonatomic) NSInteger win; // 胜
@property (nonatomic) NSInteger draw; // 平
@property (nonatomic) NSInteger lose; // 负

@end



//"id": 0,

//"medalCount": 0,
//"userIcon": "string",
//"userId": 0,
//"userName": "string",
//"win": 0
//"draw": 0,
//"lose": 0,

