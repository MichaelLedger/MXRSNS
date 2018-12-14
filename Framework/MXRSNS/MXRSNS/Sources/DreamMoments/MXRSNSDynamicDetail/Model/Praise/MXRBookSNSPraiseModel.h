//
//  MXRBookSNSPraiseModel.h
//  huashida_home
//
//  Created by shuai.wang on 16/9/29.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRBookSNSPraiseModel : NSObject

@property (nonatomic,assign,readonly) NSInteger endRow;
@property (nonatomic,assign,readonly) NSInteger firstPage;
@property (nonatomic,assign,readonly) NSInteger hasNextPage;
@property (nonatomic,assign,readonly) NSInteger hasPreviousPage;
@property (nonatomic,assign,readonly) NSInteger isFirstPage;
@property (nonatomic,assign,readonly) NSInteger isLastPage;
@property (nonatomic,assign,readonly) NSInteger lastPage;
@property (nonatomic,strong) NSMutableArray *list;
@property (nonatomic,assign,readonly) NSInteger navigatePages;
//@property (nonatomic,strong) NSMutableArray *navigatepageNums;
@property (nonatomic,assign,readonly) NSInteger nextPage;
@property (nonatomic,copy,readonly) NSString *orderBy;
@property (nonatomic,assign,readonly) NSInteger pageNum;
@property (nonatomic,assign,readonly) NSInteger pageSize;
@property (nonatomic,assign,readonly) NSInteger pages;
@property (nonatomic,assign,readonly) NSInteger prePage;
@property (nonatomic,assign,readonly) NSInteger size;
@property (nonatomic,assign,readonly) NSInteger startRow;
@property (nonatomic,assign,readonly) NSInteger total;
@property (nonatomic,assign,readonly) BOOL hasPraise;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
