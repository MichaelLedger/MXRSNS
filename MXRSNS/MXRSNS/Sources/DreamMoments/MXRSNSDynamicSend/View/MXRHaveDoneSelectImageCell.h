//
//  MXRHaveDoneSelectImageCell.h
//  huashida_home
//
//  Created by yuchen.li on 16/9/20.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MXRHaveDoneSelectImageCell,MXRImageInformationModel;
@protocol MXRHaveDoneSelectImageDeleteClickDelegate <NSObject>

-(void)userClickDeleteSelectImageWithCell:(MXRHaveDoneSelectImageCell*)cell;

@end

@interface MXRHaveDoneSelectImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@property (nonatomic, assign)BOOL  isShowDelete;     // 是否显示删除图片   黑pad [image isEqual:addImage]的返回值一直为nil
@property (nonatomic, weak)id <MXRHaveDoneSelectImageDeleteClickDelegate>delegate;

-(void)configureWithImage:(UIImage *)image;

@end
