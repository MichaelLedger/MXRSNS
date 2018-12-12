//
//  MXRBookSNSPraiseModel.m
//  huashida_home
//
//  Created by shuai.wang on 16/9/29.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSPraiseModel.h"
#import "MXRBookSNSPraiseListModel.h"

static NSString *endRow = @"endRow";
static NSString *firstPage = @"firstPage";
static NSString *hasNextPage = @"hasNextPage";
static NSString *hasPreviousPage = @"hasPreviousPage";
static NSString *isFirstPage = @"isFirstPage";
static NSString *isLastPage = @"isLastPage";
static NSString *lastPage = @"lastPage";
static NSString *list = @"list";
static NSString *navigatePages = @"navigatePages";
static NSString *navigatepageNums = @"navigatepageNums";
static NSString *nextPage = @"nextPage";
static NSString *orderBy = @"orderBy";
static NSString *pageNum = @"pageNum";
static NSString *pageSize = @"pageSize";
static NSString *pages = @"pages";
static NSString *prePage = @"prePage";
static NSString *size = @"size";
static NSString *startRow = @"startRow";
static NSString *total = @"total";
static NSString *userId = @"userId";
@implementation MXRBookSNSPraiseModel

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        //        _navigatepageNums = autoInteger(dict[navigatepageNums]);
        _endRow = autoInteger(dict[endRow]);
        _firstPage = autoInteger(dict[firstPage]);
        _hasNextPage = autoInteger(dict[hasNextPage]);
        _hasPreviousPage = autoInteger(dict[hasPreviousPage]);
        _isFirstPage = autoInteger(dict[isFirstPage]);
        _isLastPage = autoInteger(dict[isLastPage]);
        _lastPage = autoInteger(dict[lastPage]);
        _list = [NSMutableArray array];
        NSArray *praiseList = dict[list];
        if (praiseList.count > 0) {
            for (NSDictionary *dictionary in dict[list]) {
                if ([autoString(dictionary[userId]) isEqualToString:MAIN_USERID] ) {
                    _hasPraise = YES;
                }
                MXRBookSNSPraiseListModel *model = [[MXRBookSNSPraiseListModel alloc] initWithDictionary:dictionary];
                [_list addObject:model];
            }
        }
        
        _navigatePages = autoInteger(dict[navigatePages]);
        _nextPage = autoInteger(dict[nextPage]);
        _orderBy = autoString(dict[orderBy]);
        _pageNum = autoInteger(dict[pageNum]);
        _pageSize = autoInteger(dict[pageSize]);
        _pages = autoInteger(dict[pages]);
        _prePage = autoInteger(dict[prePage]);
        _size = autoInteger(dict[size]);
        _startRow = autoInteger(dict[startRow]);
        _total = autoInteger(dict[total]);
    }
    return self;
}

@end
