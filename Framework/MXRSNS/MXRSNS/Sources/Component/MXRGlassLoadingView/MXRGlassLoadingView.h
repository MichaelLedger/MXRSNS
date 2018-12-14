//
//  MXRGlassLoadingView.h
//  huashida_home
//
//  Created by 周建顺 on 15/11/19.
//  Copyright © 2015年 mxrcorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXRGlassLoadingView : UIView
+(instancetype)glassLoadingView;
@property (nonatomic ,assign) BOOL betweenTwoBook;   //是否为图书推荐页内部跳转到另一本书创建的loadingView;
@property (nonatomic ,assign) BOOL betweenTwoEggs;   //是否为彩蛋之间跳转创建的Loading
@end
