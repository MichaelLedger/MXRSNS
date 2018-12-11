//
//  UIImage+Extend.h
//  huashida_home
//
//  Created by Mac on 15-5-16.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Extend)
//+(UIImage *)MXRImageNamed:(NSString *)name;
/**
 * 根据颜色生成图片
 */
+(UIImage*)imageWithColor:(UIColor*)color;

/**
 绘制指定大小的图片
 */
- (UIImage *)scaleToSize:(CGSize)size;
/**
 获取图片指定区域内的内容
 */
- (UIImage *)clipImageInRect:(CGRect)rect;


/**
 压缩到指定大小以内

 @param maxKBytes 希望压缩后的大小(以KB为单位)
 @return 压缩后的图片
 */
- (UIImage *)compressToMaxDataSizeKBytes:(CGFloat)maxKBytes;


/**
 快速压缩到指定大小以内

 @param maxKBytes 希望压缩后的大小(以KB为单位)
 @return 压缩后的图片
 */
-(UIImage *)quickCompressToMaxDataSizeKBytes:(CGFloat)maxKBytes;

/*
 *  旋转
 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

/*
 * 截取view中的图片
 */
+(UIImage *)getImageFromView:(UIView *)orgView;

+(UIImage *)getImageFromView:(UIView *)orgView withSize:(CGSize )size;
//根据传入的width重新绘制图片 宽高比不变
+(UIImage*)drawImageWithImage:(UIImage*)image WithTargetWidth:(CGFloat)targetWidth;

//根据传入的width和 压缩比列 representation 重新绘制图片 宽高比不变
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
/*
 * 返回的图片忽略自身的颜色，使用tint color绘制图片颜色
 */
+(UIImage*)imageNamedUseTintColor:(NSString *)name;

/**
  使用原图渲染
 */
+(UIImage *)imageNamedRenderingModeAlwaysOriginal:(NSString *)name;

+(void)setBookStarGrade:(NSString *)grade andStarImageViewArray:(NSArray *)starArray;
//按比例缩放,size是你要把图显示到 多大区域 ,例如:CGSizeMake(300, 400)
+(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

///=================================================================
/// add by Martin.liu
///=================================================================
/**
 Tint the image in alpha channel with the given color
 @param color  The color.
 */
- (UIImage *)imageByTintColor:(UIColor *)color;

+ (UIImage *)thumbnailImageRequest:(CGFloat )timeBySecond videoUrl:(NSURL*)videoUrl;

/**
 按照私信中的图片形状裁切图片

 @param srcImg 源图片
 @return 裁切后的图片
 */
+ (UIImage *)clipImageToShape:(UIImage *)srcImg;



/**
 转换成灰色

 @param source <#source description#>
 @return <#return value description#>
 */
+(UIImage*)createGrayCopy:(UIImage*)source;


/**
 生成二维码图片

 */
+ (UIImage *)mxr_qrImageWithString:(NSString *)qrValue size:(CGFloat)size;


/**
 Applies a blur, tint color, and saturation adjustment to this image,
 optionally within the area specified by @a maskImage.
 
 @param blurRadius     The radius of the blur in points, 0 means no blur effect.
 
 @param tintColor      An optional UIColor object that is uniformly blended with
 the result of the blur and saturation operations. The
 alpha channel of this color determines how strong the
 tint is. nil means no tint.
 
 @param tintBlendMode  The @a tintColor blend mode. Default is kCGBlendModeNormal (0).
 
 @param saturation     A value of 1.0 produces no change in the resulting image.
 Values less than 1.0 will desaturation the resulting image
 while values greater than 1.0 will have the opposite effect.
 0 means gray scale.
 
 @param maskImage      If specified, @a inputImage is only modified in the area(s)
 defined by this mask.  This must be an image mask or it
 must meet the requirements of the mask parameter of
 CGContextClipToMask.
 
 @return               image with effect, or nil if an error occurs (e.g. no
 enough memory).
 */
- (UIImage *)mxr_imageByBlurRadius:(CGFloat)blurRadius
                                  tintColor:(UIColor *)tintColor
                                   tintMode:(CGBlendMode)tintBlendMode
                                 saturation:(CGFloat)saturation
                                  maskImage:(UIImage *)maskImage;

/**
 Rounds a new image with a given corner size.
 
 @param radius  The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to half
 the width or height.
 */
- (UIImage *)mxr_imageByRoundCornerRadius:(CGFloat)radius;

/**
 Rounds a new image with a given corner size.
 
 @param radius       The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to
 half the width or height.
 
 @param borderWidth  The inset border line width. Values larger than half the rectangle's
 width or height are clamped appropriately to half the width
 or height.
 
 @param borderColor  The border stroke color. nil means clear color.
 */
- (UIImage *)mxr_imageByRoundCornerRadius:(CGFloat)radius
                                       borderWidth:(CGFloat)borderWidth
                                       borderColor:(UIColor *)borderColor;

/**
 Rounds a new image with a given corner size.
 
 @param radius       The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to
 half the width or height.
 
 @param corners      A bitmask value that identifies the corners that you want
 rounded. You can use this parameter to round only a subset
 of the corners of the rectangle.
 
 @param borderWidth  The inset border line width. Values larger than half the rectangle's
 width or height are clamped appropriately to half the width
 or height.
 
 @param borderColor  The border stroke color. nil means clear color.
 
 @param borderLineJoin The border line join.
 */
- (UIImage *)mxr_imageByRoundCornerRadius:(CGFloat)radius
                                           corners:(UIRectCorner)corners
                                       borderWidth:(CGFloat)borderWidth
                                       borderColor:(UIColor *)borderColor
                                    borderLineJoin:(CGLineJoin)borderLineJoin;

- (UIImage *)mxr_blurImageWithBlur:(CGFloat)blur;

@end
