//
//  MXRPKHomeCellViewModel.h
//  huashida_home
//
//  Created by 周建顺 on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRPKHomeResponeModel.h"

//"desc": "string",
//"id": 0,
//"name": "string",
//"pic": "string",

@interface MXRPKHomeCellViewModel : NSObject <NSCoding>

-(instancetype)initWithModel:(MXRPKHomeResponeModel*)model;


@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *classifyId;

@end
