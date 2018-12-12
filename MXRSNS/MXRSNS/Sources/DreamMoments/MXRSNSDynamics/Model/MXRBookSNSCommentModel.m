//
//  MXRBookSNSCommentModel.m
//  huashida_home
//
//  Created by gxd on 2017/7/4.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSCommentModel.h"
#import <objc/message.h>
@implementation MXRBookSNSCommentModel
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        unsigned int count=0;
        Ivar *ivar=class_copyIvarList([self class], &count);
        for (int i=0; i<count; i++) {
            Ivar iva=ivar[i];
            const char*name=ivar_getName(iva);
            NSString *strName=[NSString stringWithUTF8String:name];
            id value=[aDecoder decodeObjectForKey:strName];
            if (value) {
                [self setValue:value forKey:strName];
            }else{
                //                DLOG(@"key value not exist,key=%@",strName);
            }
        }
        free(ivar);
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count=0;
    Ivar *ivar=class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        Ivar iva=ivar[i];
        const char *name=ivar_getName(iva);
        NSString*strName=[NSString stringWithUTF8String:name];
        id value=[self valueForKey:strName];
        [aCoder encodeObject:value forKey:strName];
    }
    free(ivar);
}

@end
