//
//  MXRAutoCoding.m
//  huashida_home
//
//  Created by 周建顺 on 2016/11/29.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRAutoCoding.h"
#import <objc/runtime.h>

@implementation NSObject (AutoCoding)

-(instancetype)MXR_initWithCoder:(NSCoder *)aDecoder{
   // self = [self init];
    if (self) {
        unsigned int count=0;
        Class subclass = [self class];
        while (subclass != [NSObject class]) {
            Ivar *ivar=class_copyIvarList(subclass, &count);
            for (int i=0; i<count; i++) {
                Ivar iva=ivar[i];
                const char*name=ivar_getName(iva);
                NSString *strName=[NSString stringWithUTF8String:name];
                id value=[aDecoder decodeObjectForKey:strName];
                if (value) {
                    [self setValue:value forKey:strName];
                }else{
//                    DLOG(@"key value not exist,key=%@",strName);
                }
            }
            free(ivar);
            subclass = [subclass superclass];
        }
        
    }
    return self;
}

-(void)MXR_encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count=0;
    Class subclass = [self class];
    while (subclass != [NSObject class]) {
        Ivar *ivar=class_copyIvarList(subclass, &count);
        for (int i=0; i<count; i++) {
            Ivar iva=ivar[i];
            const char *name=ivar_getName(iva);
            NSString*strName=[NSString stringWithUTF8String:name];
            id value=[self valueForKey:strName];
            [aCoder encodeObject:value forKey:strName];
        }
        free(ivar);
        subclass = [subclass superclass];
    }
    
}

@end
