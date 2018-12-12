//
//  MXREgretInterfaceModel.m
//  huashida_home
//
//  Created by MountainX on 2018/10/24.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXREgretInterfaceModel.h"
#import <objc/runtime.h>

@implementation MXREgretInterfaceModel

- (NSDictionary *)interfaceDict {
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [dict setValue:[self valueForKey:propertyName] forKey:propertyName];
    }
    
    free(properties);
    return dict;
}

@end
