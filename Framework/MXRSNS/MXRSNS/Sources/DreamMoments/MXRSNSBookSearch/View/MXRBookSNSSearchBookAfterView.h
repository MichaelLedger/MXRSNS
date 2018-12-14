//
//  MXRMXRBookSNSSearchBookAfterView.h
//  huashida_home
//
//  Created by yuchen.li on 16/9/22.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BookInfoForShelf;
@interface MXRBookSNSSearchBookAfterView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bookIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *threeIamgeView;
@property (weak, nonatomic) IBOutlet UIImageView *fourIamgeView;
@property (weak, nonatomic) IBOutlet UIImageView *fiveImageView;

-(instancetype)initWithFrame:(CGRect)frame WithBookShelfModel:(BookInfoForShelf*)book;
@end
