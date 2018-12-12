//
//  MXRQiNiuUploadTokenModel.h
//  huashida_home
//
//  Created by yuchen.li on 16/9/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRQiNiuUploadTokenModel : NSObject

@property (nonatomic, copy, readonly) NSString *bucketName;     // bucketName = images; 空间名
@property (nonatomic, copy, readonly) NSString *cdnAddr;        // cdnAddr = "https://img.mxrcorp.cn" 地址
@property (nonatomic, copy, readonly) NSString *folderName;     // 保存文件类型 （动态，截图，分享视频等）
@property (nonatomic, copy, readonly) NSString *uploadToken;    // 上传七牛对应的token
-(instancetype)initWithDict:(NSDictionary*)dict;

@end
