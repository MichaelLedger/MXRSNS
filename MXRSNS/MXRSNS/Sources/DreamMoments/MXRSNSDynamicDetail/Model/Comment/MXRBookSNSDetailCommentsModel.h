//
//  MXRBookSNSDetailCommentsModel.h
//  huashida_home
//
//  Created by shuai.wang on 16/9/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRBookSNSDetailCommentsModel : NSObject<NSCoding>

@property (assign,nonatomic,readonly) NSInteger pageNum;
@property (assign,nonatomic,readonly) NSInteger pageSize;
@property (assign,nonatomic,readonly) NSInteger size;
@property (copy,nonatomic,readonly)   NSString *orderBy;
@property (assign,nonatomic,readonly) NSInteger startRow;
@property (assign,nonatomic,readonly) NSInteger endRow;
@property (assign,nonatomic,readonly) NSInteger total;
@property (assign,nonatomic,readonly) NSInteger pages;
@property (strong,nonatomic) NSMutableArray *list;
/**   **/
@property (assign,nonatomic,readonly) NSInteger firstPage;
@property (assign,nonatomic,readonly) NSInteger prePage;
@property (assign,nonatomic,readonly) NSInteger nextPage;
@property (assign,nonatomic,readonly) NSInteger lastPage;
@property (assign,nonatomic,readonly) NSInteger isFirstPage;
@property (assign,nonatomic,readonly) NSInteger isLastPage;
@property (assign,nonatomic,readonly) NSInteger hasPreviousPage;
@property (assign,nonatomic,readonly) NSInteger hasNextPage;
@property (assign,nonatomic,readonly) NSInteger navigatePages;
//@property (strong,nonatomic) NSArray   *navigatepageNums;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
