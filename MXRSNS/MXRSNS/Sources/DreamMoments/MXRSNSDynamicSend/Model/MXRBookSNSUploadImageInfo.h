//
//  MXRBookSNSUploadImageInfo.h
//  huashida_home
//
//  Created by yuchen.li on 16/9/28.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,MXRBooKSNSSendDetailImageCurrentState) {
    MXRBooKSNSSendDetailImageOnService  = 0,
    MXRBooKSNSSendDetailImageOnLocal    = 1
};
typedef NS_ENUM(NSInteger , MXRBooKSNSSendDetailImageType) {
    MXRBooKSNSSendDetailImageTypeHorizontal = 1, // 横
    MXRBooKSNSSendDetailImageTypeVertical   = 2, // 竖
    MXRBooKSNSSendDetailImageTypeSquare     = 3  // 正方形
};
@interface MXRBookSNSUploadImageInfo : NSObject <NSCoding>

@property (nonatomic, strong)UIImage *image;           // 图片
@property (nonatomic, strong)NSString *imageUrl;       // 图片的url
@property (nonatomic, strong)NSString *keyString;      // 图片上传的key值
@property (nonatomic, strong)NSString *shrinkImageUrl; // 图片缩略图的url

@property (nonatomic, assign) MXRBooKSNSSendDetailImageType shapeType;
@property (nonatomic, assign) MXRBooKSNSSendDetailImageCurrentState state;

-(instancetype)initWithImage:(UIImage*)image ;
-(instancetype)initWithUrl:(NSString*)imageUrl WithPhotoType:(MXRBooKSNSSendDetailImageType)type;

-(void)MXRSetImageUrl:(NSString *)imageUrlSting;
-(void)MXRSetShrinkImageUrl:(NSString *)shrinkImageUrlString;
//-(void)MXRSetState:(MXRBooKSNSSendDetailImageCurrentState)state;
-(void)MXRSetKeyString:(NSString *)keyString;
@end
