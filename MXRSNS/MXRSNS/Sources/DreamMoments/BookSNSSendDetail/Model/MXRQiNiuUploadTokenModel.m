//
//  MXRQiNiuUploadTokenModel.m
//  huashida_home
//
//  Created by yuchen.li on 16/9/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRQiNiuUploadTokenModel.h"

@implementation MXRQiNiuUploadTokenModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        _uploadToken    = autoString(dict[@"uploadToken"]);
        _cdnAddr        = autoString(dict[@"cdnAddr"]);
        _bucketName     = autoString(dict[@"bucketName"]);
        if (!dict[@"cdnAddr"]) {
            _cdnAddr = QiNiuUrlHttps;
        }
        _folderName     = autoString(dict[@"folderName"]);
    }
    return self;
}
@end
