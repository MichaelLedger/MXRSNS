//
//  MXRSNSSearchNoBookView.h
//  huashida_home
//
//  Created by yuchen.li on 16/9/19.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXRSNSSearchNoBookView : UIView

@property (weak, nonatomic) IBOutlet UIButton *promptBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageSearch;

-(instancetype)initWithFrame:(CGRect)frame withText:(NSString *)text withPromptText:(NSString *)promptText andImageName:(NSString *)imgName;

@end
