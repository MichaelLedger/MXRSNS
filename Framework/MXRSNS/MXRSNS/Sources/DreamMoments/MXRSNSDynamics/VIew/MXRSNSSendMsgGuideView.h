//
// 梦想圈第一次发布引导页
//  MXRSNSSendMsgGuideView.h
//  huashida_home
//
//  Created by 周建顺 on 2016/12/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXRSNSSendMsgGuideView : UIView

+(instancetype)sendMsgGuideView;
-(void)tryShowBookStoreGuide;
+(BOOL)checkIsNeedShow;
@end
