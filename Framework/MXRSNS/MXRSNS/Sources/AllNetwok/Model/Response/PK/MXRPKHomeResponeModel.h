//
//  MXRPKHomeResponeModel.h
//  huashida_home
//
//  Created by 周建顺 on 2018/1/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//"desc": "string",
//"id": 0,
//"name": "string",
//"pic": "string",
//"sort": 0

@interface MXRPKHomeResponeModel : NSObject

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *classifyId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic) NSInteger sort;

@end
