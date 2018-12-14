//
//  MXRScreenShotHelper.m
//  4dBookCitySim
//
//  Created by MountainX on 2017/10/13.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRScreenShotHelper.h"

@implementation MXRScreenShotHelper

#pragma mark - 截屏
+ (UIImage *)screenShotWithView:(UIView *)view {
    UIImage* image;
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    {
        [view.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    if (image != nil)
    {
        return image;
    }
    return nil;
}

#pragma mark - 滚动视图全屏截图
+ (UIImage *)screenShotWithScrollView:(UIScrollView *)scrollView
{
    UIImage* image;
    
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil)
    {
        return image;
    }
    return nil;
}

#pragma mark - 生成二维码
+ (UIImage *)generatorlogoImageQRCodeWithUrl:(NSString *)url{
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置过滤器默认属性 (老油条)
    [qrImageFilter setDefaults];
    
    //将字符串转换成 NSdata (虽然二维码本质上是 字符串,但是这里需要转换,不转换就崩溃)
    NSData *qrImageData = [url dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置过滤器的 输入值  ,KVC赋值
    [qrImageFilter setValue:qrImageData forKey:@"inputMessage"];
    
    //取出图片
    CIImage *qrImage = [qrImageFilter outputImage];
    
    //但是图片 发现有的小 (27,27),我们需要放大..我们进去CIImage 内部看属性
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(27, 27)];
    
    //转成 UI的 类型
    UIImage *qrUIImage = [UIImage imageWithCIImage:qrImage];
    
    /*----------------给 二维码 中间增加一个 自定义图片----------------*/
    //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
    UIGraphicsBeginImageContext(qrUIImage.size);
    
    //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
    [qrUIImage drawInRect:CGRectMake(0, 0, qrUIImage.size.width, qrUIImage.size.height)];
    
    //再把小图片画上去 
    UIImage *sImage = MXRIMAGE(@"icon_common_dreamicon");
    
    CGFloat sImageW = qrUIImage.size.width * 210 / 729.0;
    CGFloat sImageH= sImageW;
    CGFloat sImageX = (qrUIImage.size.width - sImageW) * 0.5;
    CGFloat sImgaeY = (qrUIImage.size.height - sImageH) * 0.5;
    
    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];
    /*----------------给 二维码 中间增加一个 自定义图片----------------*/
    
    //获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    return finalyImage;
}

#pragma mark - 拼凑截屏和二维码以及文本（通过imageCompressForWidth先将shotImage缩放到屏幕等宽）
+ (UIImage *)jointShotImage:(UIImage *)shotImage QRCodeImage:(UIImage *)QRCodeImage Text:(NSString *)text {
    if (shotImage == nil || QRCodeImage == nil || text == nil || text.length == 0) {
        return nil;
    }
    
    CGFloat contextW = shotImage.size.width;
    CGFloat TopMargin = 30;
    CGFloat BottomMargin = 50;
    CGFloat kLRMargin = 30;
    CGFloat kMiddleMargin = 30;
    CGFloat QRCodeImgW = (contextW - 2 * kLRMargin - kMiddleMargin) / 3;
    CGFloat QRCodeImgH = QRCodeImgW * (QRCodeImage.size.height / QRCodeImage.size.width);
    CGFloat textWidth =  contextW - 2 * kLRMargin - kMiddleMargin - QRCodeImgW;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;//[UIScreen mainScreen].scale
    CGFloat fontSize = 15;
    //    CGFloat textHeight = [NSString caculateText:text andTextLabelSize:CGSizeMake(textWidth, MAXFLOAT) andFontSize:fontSize andParagraphStyle:paragraphStyle].height;
    CGFloat textHeight = [self getHeightOfString:text font:[UIFont systemFontOfSize:fontSize] width:textWidth lineSpace:paragraphStyle.lineSpacing];
    CGFloat maxHeight = textHeight > QRCodeImgH ? textHeight : QRCodeImgH;
    CGFloat contextH = shotImage.size.height + TopMargin + BottomMargin;
    contextH += maxHeight;
    CGFloat originY = shotImage.size.height + TopMargin;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, contextW, contextH)];
    scrollView.contentSize = CGSizeMake(contextW, contextH);
    scrollView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *shotIv = [[UIImageView alloc] initWithImage:shotImage];
    shotIv.frame = CGRectMake(0, 0, shotImage.size.width, shotImage.size.height);
    [scrollView addSubview:shotIv];
    
    UIImageView *QRIv = [[UIImageView alloc] initWithImage:QRCodeImage];
    QRIv.frame = CGRectMake(kLRMargin, originY + (maxHeight - QRCodeImgH) / 2, QRCodeImgW, QRCodeImgH);
    [scrollView addSubview:QRIv];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(QRIv.frame) + kMiddleMargin, originY + (maxHeight - textHeight) / 2, textWidth, textHeight)];
    textLabel.numberOfLines = 0;
    textLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: RGB(50, 50, 50), NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    [scrollView addSubview:textLabel];
    
    return [self screenShotWithScrollView:scrollView];
}

+ (CGFloat)getHeightOfString:(NSString *)str font:(UIFont *)font width:(CGFloat)width lineSpace:(CGFloat)space {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:space];
    NSDictionary *attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:style};
    CGSize retSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    return retSize.height;
}

@end
