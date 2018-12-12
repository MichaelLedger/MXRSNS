//
//  WaterfallColectionLayout.m
//  WaterfallCollectionLayout
//
//  Created by ci123 on 16/1/26.
//  Copyright © 2016年 tanhui. All rights reserved.
//

#import "WaterfallColectionLayout.h"


@interface WaterfallColectionLayout ()
//数组存放每列的总高度
@property(nonatomic,strong)NSMutableArray* colsHeight;
@property (nonatomic) CGFloat bottom; // 最底部

@property (nonatomic) NSInteger colCount;
@property (nonatomic) NSMutableDictionary *caches;

@end

@implementation WaterfallColectionLayout


-(instancetype)initWithColCount:(NSInteger)colCount{
    self = [super init];
    if (self) {
        _colCount = colCount;
    }
    return self;
}

-(instancetype)init{
    return [self initWithColCount:1];
}

-(void)dealloc{
    DLOG_METHOD
}

-(void)prepareLayout{
    [super prepareLayout];
     DLOG_METHOD
//    self.colWidth =( self.collectionView.frame.size.width - (colCount+1)*colMargin )/colCount;
    [self calculateFrames];
}
-(CGSize)collectionViewContentSize{
    NSNumber * longest = self.colsHeight[0];
    for (NSInteger i =0;i<self.colsHeight.count;i++) {
        NSNumber* rolHeight = self.colsHeight[i];
        if(longest.floatValue<rolHeight.floatValue){
            longest = rolHeight;
        }
    }
    DLOG_METHOD
    return CGSizeMake(self.collectionView.frame.size.width, self.bottom);
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    attr.frame = [self rectWithIndexPath:indexPath];
    return attr;
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
  
    NSMutableArray* array = [NSMutableArray array];
    NSArray *indexPaths = [self indexForItemsInRect:rect];
    
    /*避免Header高度超过屏幕高度
     (CGRect) rect = (origin = (x = 0, y = -812), size = (width = 375, height = 1624))导致cell ：
    <NSIndexPath: 0xc000000000000016> {length = 2, path = 0 - 0}" = "NSRect: {{25, 1020}, {153, 294.82894956304017}}不在其内*/
    if (indexPaths.count == 0) {
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        CGSize headerSize = [self sizeForHeaderInSection:0];
        //            UIEdgeInsets insets = [self insetForSectionAtIndex:indexPath];
//        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.collectionView.frame), headerSize.height);
        CGRect frame = CGRectMake(0, 0, headerSize.width, headerSize.height);
        attr.frame = frame;
        [array addObject:attr];
    }
    
    [indexPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = obj;
        if (indexPath.item == 0) {
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
            CGSize headerSize = [self sizeForHeaderInSection:indexPath.section];
//            UIEdgeInsets insets = [self insetForSectionAtIndex:indexPath];
//            CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.collectionView.frame), headerSize.height);
            CGRect frame = CGRectMake(0, 0, headerSize.width, headerSize.height);
            attr.frame = frame;
            [array addObject:attr];
        }
        
        UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [array addObject:attr];

    }];
    
    

    return array;
    
}

-(NSArray*)indexForItemsInRect:(CGRect)rect{
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i<items;i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGRect indexRect = [self rectWithIndexPath:indexPath];
       BOOL contains = CGRectIntersectsRect(rect, indexRect);
        if (contains) {
            [array addObject:indexPath];
        }
       
    }
    
    return array;
}

-(CGRect)rectWithIndexPath:(NSIndexPath*)indexPath{
    NSValue *value = [self.caches objectForKey:indexPath];
   return [value CGRectValue];
}

-(void)calculateFrames{
    self.colsHeight = nil;
    self.caches = [NSMutableDictionary new];
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<items;i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        NSNumber * shortest = self.colsHeight[0];
        NSInteger  shortCol = 0;
        for (NSInteger j =0;j<self.colsHeight.count;j++) {
            NSNumber* rolHeight = self.colsHeight[j];
            if(shortest.floatValue>rolHeight.floatValue){
                shortest = rolHeight;
                shortCol=j;
            }
        }
        
        CGSize headerSize = [self sizeForHeaderInSection:indexPath.section];
        UIEdgeInsets insets = [self insetForSectionAtIndex:indexPath];
        
        CGFloat height = [self cellHeightAtIndexPath:indexPath];
        CGFloat colWidth = [self cellWidthAtIndexPath:indexPath];
        
        CGFloat lineSpace = [self minimumLineSpacingForSectionAtIndex:indexPath.section];
        CGFloat interSpace = [self minimumInteritemSpacingForSectionAtIndex:indexPath.section];
        
        CGFloat x = insets.left + (shortCol)*interSpace+ shortCol * colWidth;
        CGFloat y  = headerSize.height +  insets.top + shortest.floatValue;
        
        CGRect frame= CGRectMake(x, y, colWidth, height);
        self.colsHeight[shortCol]=@(shortest.floatValue+lineSpace+height);
        
        CGFloat bottom = CGRectGetMaxY(frame)+ insets.bottom;
        if (bottom> self.bottom) {
            self.bottom = bottom;
        }
        [self.caches setObject:[NSValue valueWithCGRect:frame] forKey:indexPath];
        
    }
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    CGRect oldBounds = self.collectionView.bounds;
    
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        
        return YES;
        
    }
    
    return NO; 
}
-(NSMutableArray *)colsHeight{
    if(!_colsHeight){
        NSMutableArray * array = [NSMutableArray array];
        for(int i =0;i<self.colCount;i++){
            //这里可以设置初始高度
            [array addObject:@(0)];
        }
        _colsHeight = [array mutableCopy];
    }
    return _colsHeight;
}


-(CGFloat)cellHeightAtIndexPath:(NSIndexPath*)indexPath{
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        CGFloat height = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath].height;
        return height;
    }
    return 0;
}

-(CGFloat)cellWidthAtIndexPath:(NSIndexPath*)indexPath{
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        CGFloat width = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath].width;
        return width;
    }
    
    return 0;
}

-(CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    if ([delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return 0;
}

-(CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;

    if ([delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return 0;
}

-(UIEdgeInsets)insetForSectionAtIndex:(NSIndexPath*)indexPath{
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:indexPath.section];
    }
    return UIEdgeInsetsZero;
}

-(CGSize)sizeForHeaderInSection:(NSInteger)section{
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
    }
    return CGSizeZero;
}

@end
