//
//  MXRPKRankListHeaderReusableView.h
//  huashida_home
//
//  Created by mengxiangren on 2018/11/13.
//  Copyright © 2018 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRPKRankListModel.h"
@interface MXRPKRankListHeaderReusableView : UICollectionReusableView

- (void)parseCellDataWithModel:(MXRPKRankListModel *)listModel;
@end
