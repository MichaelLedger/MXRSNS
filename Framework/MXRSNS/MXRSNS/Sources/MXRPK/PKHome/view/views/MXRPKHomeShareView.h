//
//  MXRPKHomeShareView.h
//  huashida_home
//
//  Created by 周建顺 on 2018/1/20.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MXRPKHomeShareViewParam : NSObject

@property (nonatomic) NSInteger medalCount; // 勋章数
@property (nonatomic, strong) UIImage *userIcon; // 头像
@property (nonatomic, copy) NSString *userName; // 用户名
//@property (nonatomic) NSInteger win; // 胜
//@property (nonatomic) NSInteger draw; // 平
//@property (nonatomic) NSInteger lose; // 负

@end


@interface MXRPKHomeShareView : UIView

+(instancetype)pkHomeShareView;

@property (nonatomic, strong) MXRPKHomeShareViewParam *model;

- (UIImage*)createShareImageWithQR;
- (UIImage *)createShareImageNoQR;

@end
