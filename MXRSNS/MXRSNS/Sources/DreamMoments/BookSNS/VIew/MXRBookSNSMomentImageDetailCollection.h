//
//  MXRBookSNSMomentImageDetailCollection.h
//  huashida_home
//
//  Created by gxd on 16/9/30.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXRBookSNSMomentImageDetailCollection : UIView

@property (assign, nonatomic) NSInteger          selectIndex;
@property (strong, nonatomic) UICollectionView * collectionView;

-(instancetype)initWithFrame:(CGRect)frame anditem:(UIView *)itemView andSelectIndex:(NSInteger )index andImageInfos:(NSArray *)imageInfoArray;
-(void)beganAnimation;

@end
