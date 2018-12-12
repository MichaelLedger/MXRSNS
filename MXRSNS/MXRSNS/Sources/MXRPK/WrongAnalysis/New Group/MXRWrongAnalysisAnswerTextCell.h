//
//  MXRWrongAnalysisAnswerTextCell.h
//  huashida_home
//
//  Created by MountainX on 2018/8/16.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRPKResponseModel.h"

@interface MXRWrongAnalysisAnswerTextCell : UICollectionViewCell

@property (nonatomic, strong)MXRPKAnswerOption *answer;

@property (nonatomic, strong)NSArray *selectedAnswers;

@end
