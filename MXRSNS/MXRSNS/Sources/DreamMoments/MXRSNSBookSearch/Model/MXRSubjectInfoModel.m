//
//  MXRSubjectInfoModel.m
//  huashida_home
//
//  Created by yuchen.li on 2017/6/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSubjectInfoModel.h"
#import <objc/message.h>


@implementation MXRSubjectInfoModel

/*
 cover = "http://olpp623md.bkt.clouddn.com/mxroms/20170522093248987_7px75boq6a.jpg";
 createTime = 1494662051327;
 desc = "\U6d4b\U8bd5   \U201c\U7684\U65b9\U5f0f\U201d  \U2026\U2026 \Uff0c\U2018\Uff1b
 \n
 \n\U2019\U3001 \U3002 .; &
 \ngg";
 id = 180;
 name = "\U6885\U79cb\U6d0b\U6d4b\U8bd5\U4e13\U533a";
 updateTime = 1495874601753;
 
 */

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _subjectID           = autoInteger(dict[@"id"]);
        _subjectName         = autoString(dict[@"name"]);
        _subjectDescription  = autoString(dict[@"desc"]);
        _subjectCover        = autoString(dict[@"cover"]);
        _subjectCreateTime   = autoString(dict[@"createTime"]);
        _subjectUpdateTime   = autoString(dict[@"updateTime"]);
        _subjectSort         = autoInteger(dict[@"sort"]);
        
        //5.9.3 Version 新加字段  by shuai.wang   start
        _bookNum = autoInteger(dict[@"bookNum"]);
        _bookAveragePrice = autoInteger(dict[@"bookAveragePrice"]);
        _price = autoInteger(dict[@"price"]);
        _priceOld = autoInteger(dict[@"priceOld"]);
        _priceType = autoInteger(dict[@"priceType"]);
        NSNumber * num = autoNumber(dict[@"hasBuy"]);
        _hasBuy = [num boolValue];
        //5.9.3 Version 新加字段  by shuai.wang   end
        _couponNum = autoInteger(dict[@"couponNum"]);
        NSNumber * vipFlag = autoNumber(dict[@"vipFlag"]);
        _vipFlag = [vipFlag boolValue];
        
    }
    return self;

}

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
