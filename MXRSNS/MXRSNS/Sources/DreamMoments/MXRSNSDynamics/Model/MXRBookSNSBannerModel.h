//
//  MXRBookSNSBannerModel.h
//  huashida_home
//
//  Created by weiqing.tang on 2018/2/28.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MXRBookSNSBannerType) {
    MXRBookSNSBannerQuestionType = 0
};
@interface MXRBookSNSBannerModel : NSObject

@property (nonatomic, strong) NSString *bannerUrl;
@property (nonatomic, assign) MXRBookSNSBannerType bookSNSBannerType;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
