//
//  MXRAutoCoding.h
//  huashida_home
//
//  Created by 周建顺 on 2016/11/29.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AutoCoding)
-(instancetype)MXR_initWithCoder:(NSCoder *)aDecoder;
-(void)MXR_encodeWithCoder:(NSCoder *)aCoder;
@end
