//
//  MXRBookSNSUploadImageInfo.m
//  huashida_home
//
//  Created by yuchen.li on 16/9/28.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSUploadImageInfo.h"
#import "MXRQiNiuUploadTokenModel.h"
#import "MXRBookSNSSendDetailProxy.h"
#import "GlobalFunction.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Extend.h"
#import <objc/message.h>
#import "SDWebImageManager.h"
#import "MXRDeviceUtil.h"

@implementation MXRBookSNSUploadImageInfo
@synthesize shrinkImageUrl;
@synthesize imageUrl;
-(instancetype)initWithImage:(UIImage *)image 
{
    if (self = [super init]) {
        _state = MXRBooKSNSSendDetailImageOnLocal;
        MXRQiNiuUploadTokenModel * model;
        if ([MXRBookSNSSendDetailProxy getInstance].qiNiuUploadTokenArray.count > 0) {
            model = [MXRBookSNSSendDetailProxy getInstance].qiNiuUploadTokenArray[0];
        }
        if (image.size.width > image.size.height) {
            _shapeType = MXRBooKSNSSendDetailImageTypeHorizontal;
        }else if (image.size.width < image.size.height){
            _shapeType = MXRBooKSNSSendDetailImageTypeVertical;
        }else{
            _shapeType = MXRBooKSNSSendDetailImageTypeSquare;
        }
        _image = [UIImage drawImageWithImage:image WithTargetWidth:500];
        _keyString = [NSString stringWithFormat:@"%@/%@.png",model.folderName,[MXRDeviceUtil getUUID]];//图片上传的key值
        imageUrl = [NSString stringWithFormat:@"%@/%@",model.cdnAddr,_keyString]; //图片上传到七牛后的url
        shrinkImageUrl = [NSString stringWithFormat:@"%@%@",imageUrl,QiNiuShrink]; //缩略图的七牛url
    }
    return self;
}
-(instancetype)initWithUrl:(NSString *)imageUrlSting WithPhotoType:(MXRBooKSNSSendDetailImageType)type{
    if (self = [super init]) {
        //七牛
        if ([imageUrl hasPrefix:@"http://7xtg61.com1.z0.glb.clouddn.com/dynamic"]||[imageUrl hasPrefix:@"https://7xtg61.com1.z0.glb.clouddn.com/dynamic"]) {
            shrinkImageUrl = [NSString stringWithFormat:@"%@%@",imageUrl,QiNiuShrink];
//            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:shrinkImageUrl] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            }];
            //UIImageView *imageView = [[UIImageView alloc]init];
            //[imageView sd_setImageWithURL:[NSURL URLWithString:shrinkImageUrl]];
            imageUrl = imageUrlSting;
        }else{
            //小梦
            shrinkImageUrl = imageUrlSting;
            imageUrl = imageUrlSting;
        
        }
        _state = MXRBooKSNSSendDetailImageOnService;
        _shapeType = type;
    }
    return self;
}

-(void)MXRSetImageUrl:(NSString *)imageUrlSting{
    imageUrl = imageUrlSting;
}

-(void)MXRSetShrinkImageUrl:(NSString *)shrinkImageUrlString{
    shrinkImageUrl = shrinkImageUrlString;
}

//-(void)MXRSetState:(MXRBooKSNSSendDetailImageCurrentState)state{
//    _state = state;
//}

-(void)MXRSetKeyString:(NSString *)keyString{
    _keyString = keyString;
}
-(NSString *)imageUrl{

    return REPLACE_HTTP_TO_HTTPS(imageUrl);
}
-(NSString *)shrinkImageUrl{

    return REPLACE_HTTP_TO_HTTPS(shrinkImageUrl);
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivar = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            Ivar iva = ivar[i];
            const char *name = ivar_getName(iva);
            NSString *strName = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:strName];
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
    unsigned int count = 0;
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar iva = ivar[i];
        const char *name = ivar_getName(iva);
        NSString *strName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:strName];
        [aCoder encodeObject:value forKey:strName];
    }
    free(ivar);
}
@end
