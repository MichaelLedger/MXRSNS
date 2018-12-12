//
//  MXRSearchBookViewController.h
//  huashida_home
//
//  Created by yuchen.li on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//  梦想圈已发布图书搜索页面

#import <UIKit/UIKit.h>
@class BookInfoForShelf;
@protocol MXRSNSSearchBookHaveSelectDelegate<NSObject>
-(void)userHaveDoneSelectBook:(BookInfoForShelf*)book;
@end


@interface MXRSNSSearchBookViewController : MXRDefaultViewController
@property (nonatomic, weak)id <MXRSNSSearchBookHaveSelectDelegate>delegate;
@end
