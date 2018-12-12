//
//  MXRBookSNSDetailCommentsModel.m
//  huashida_home
//
//  Created by shuai.wang on 16/9/27.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSDetailCommentsModel.h"
#import "MXRBookSNSDetailCommentListModel.h"

static NSString *pageNum = @"pageNum";
static NSString *pageSize = @"pageSize";
static NSString *size = @"size";
static NSString *orderBy = @"orderBy";
static NSString *startRow = @"startRow";
static NSString *endRow = @"endRow";
static NSString *total = @"total";
static NSString *pages = @"pages";
static NSString *list = @"list";
/*    */
static NSString *firstPage = @"firstPage";
static NSString *prePage = @"prePage";
static NSString *nextPage = @"nextPage";
static NSString *lastPage = @"lastPage";
static NSString *isFirstPage = @"isFirstPage";
static NSString *isLastPage = @"isLastPage";
static NSString *hasPreviousPage = @"hasPreviousPage";
static NSString *hasNextPage = @"hasNextPage";
static NSString *navigatePages = @"navigatePages";
static NSString *userLogo = @"userLogo";

@implementation MXRBookSNSDetailCommentsModel
-(instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self= [super init])
    {
        _pageNum = autoInteger(dict[pageNum]);
        _pageSize = autoInteger(dict[pageSize]);
        _size = autoInteger(dict[size]);
        _orderBy = autoString(dict[orderBy]);
        _startRow = autoInteger(dict[startRow]);
        _endRow = autoInteger(dict[endRow]);
        _total = autoInteger(dict[total]);
        _pages = autoInteger(dict[pages]);
        NSArray *arrayList = [NSArray arrayWithArray:dict[list]];
        NSMutableArray *commentArray = [NSMutableArray array];
        if (arrayList.count>0)
        {
            for (NSDictionary *dictionary in arrayList)
            {
                MXRBookSNSDetailCommentListModel *listModel = [[MXRBookSNSDetailCommentListModel alloc] initWithDictionary:dictionary withModelType:ListModelOfUpload withModelFuncType:ListModelFuncOfDefault withDataType:defaultDataType withCommentType:defaultCommentType];

                [commentArray addObject:listModel];
            }
            _list = [NSMutableArray arrayWithArray:commentArray];
   
        }
        else
        {
             _list = commentArray;
        }
        _firstPage = autoInteger(dict[firstPage]);
        _prePage = autoInteger(dict[prePage]);
        _nextPage = autoInteger(dict[nextPage]);
        _lastPage = autoInteger(dict[lastPage]);
        _isFirstPage = autoInteger(dict[isFirstPage]);
        _isLastPage = autoInteger(dict[isLastPage]);
        _hasPreviousPage = autoInteger(dict[hasPreviousPage]);
        _hasNextPage = autoInteger(dict[hasNextPage]);
        _navigatePages = autoInteger(dict[navigatePages]);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.pageNum forKey:pageNum];
    [aCoder encodeInteger:self.pageSize forKey:pageSize];
    [aCoder encodeInteger:self.size forKey:size];
    [aCoder encodeObject:self.orderBy forKey:orderBy];
    [aCoder encodeInteger:self.startRow forKey:startRow];
    [aCoder encodeInteger:self.endRow forKey:endRow];
    [aCoder encodeInteger:self.total forKey:total];
    [aCoder encodeInteger:self.pages forKey:pages];
    [aCoder encodeObject:self.list forKey:list];
    /*  */
    [aCoder encodeInteger:self.firstPage forKey:firstPage];
    [aCoder encodeInteger:self.prePage forKey:prePage];
    [aCoder encodeInteger:self.nextPage forKey:nextPage];
    [aCoder encodeInteger:self.lastPage forKey:lastPage];
    [aCoder encodeInteger:self.isFirstPage forKey:isFirstPage];
    [aCoder encodeInteger:self.isLastPage forKey:isLastPage];
    [aCoder encodeInteger:self.hasPreviousPage forKey:hasPreviousPage];
    [aCoder encodeInteger:self.hasNextPage forKey:hasNextPage];
    [aCoder encodeInteger:self.navigatePages forKey:navigatePages];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self= [super init]) {
        _pageNum = [aDecoder decodeIntegerForKey:pageNum];
        _pageSize = [aDecoder decodeIntegerForKey:pageSize];
        _size = [aDecoder decodeIntegerForKey:size];
        _orderBy = [aDecoder decodeObjectForKey:orderBy];
        _startRow = [aDecoder decodeIntegerForKey:startRow];
        _endRow = [aDecoder decodeIntegerForKey:endRow];
        _total = [aDecoder decodeIntegerForKey:total];
        _pages = [aDecoder decodeIntegerForKey:pages];
        _list = [aDecoder decodeObjectForKey:list];
        /*   */
        _firstPage =  [aDecoder decodeIntegerForKey:firstPage];
        _prePage =  [aDecoder decodeIntegerForKey:prePage];
        _nextPage =  [aDecoder decodeIntegerForKey:nextPage];
        _lastPage =  [aDecoder decodeIntegerForKey:lastPage];
        _isFirstPage =  [aDecoder decodeIntegerForKey:isFirstPage];
        _isLastPage =  [aDecoder decodeIntegerForKey:isLastPage];
        _hasPreviousPage =  [aDecoder decodeIntegerForKey:hasPreviousPage];
        _hasNextPage =  [aDecoder decodeIntegerForKey:hasNextPage];
        _navigatePages =  [aDecoder decodeIntegerForKey:navigatePages];
    }
    return self;
}
@end
