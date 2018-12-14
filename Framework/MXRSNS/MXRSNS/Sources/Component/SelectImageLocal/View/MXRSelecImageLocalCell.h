//
//  MXRSelecImageLocalCell.h
//  xuanquTupian
//
//  Created by yuchen.li on 16/8/24.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MXRImageInformationModel;

@protocol MXRSelectImageLocalCellPrepareToSendDelegate <NSObject>

-(void)userPrepareToSendWithCount:(NSInteger)count;
-(void)userHaveSelectTooMuchImage;
-(void)haveSelectImageWithIndexPathArray:(NSArray *)indexPathArray;
@end

@interface MXRSelecImageLocalCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *isSelectImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *timeContainerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong)MXRImageInformationModel *imageInfoModel;
@property (nonatomic, weak) id <MXRSelectImageLocalCellPrepareToSendDelegate > delegate;

@property (nonatomic, assign, readonly) BOOL selectFlag;

-(void)configureCellWithModelSystermSeven:(MXRImageInformationModel*)model;





@end
