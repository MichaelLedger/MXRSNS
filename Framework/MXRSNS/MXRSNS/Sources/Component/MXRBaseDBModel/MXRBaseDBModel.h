//
//  MXRBaseDBModel.h
//  huashida_home
//
//  Created by Martin.liu on 2016/12/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<LKDBHelper.h>)
#import <LKDBHelper.h>
#else
#import "LKDBHelper.h"
#endif

/**
 在LKDB的基础上创建的一个 基础model 与 数据库进行交互
 和数据库交互的直接继承它就可以。 数据库在Documents下的MessageRecord.sqlite中
 与之前保存数据的数据库保持了一致。 
 
 */
@interface MXRBaseDBModel : NSObject

@end



