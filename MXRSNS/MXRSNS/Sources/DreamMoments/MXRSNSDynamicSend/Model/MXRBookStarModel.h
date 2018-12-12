//
//  MXRBookStarModel.h
//  huashida_home
//
//  Created by yuchen.li on 16/10/8.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRBookStarModel : NSObject
@property(nonatomic, copy, readonly) NSString *bookGuid;     
@property(nonatomic, assign, readonly) NSInteger star;
-(instancetype)initWithDict:(NSDictionary*)dict;
@end
