//
//  MXRQuestionBanner.m
//  huashida_home
//
//  Created by MountainX on 2017/9/30.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRQuestionBanner.h"
#import "MXRQuestionBannerCell.h"
#import "AppDelegate.h"

//图片物理像素比例
#define kCellScale (1023 / 3528.0)

#define MXRQuestionBannerCellIdentifier @"MXRQuestionBannerCellIdentifier"

@interface MXRQuestionBanner()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)UICollectionViewFlowLayout *collectionViewFlowLayout;

@end

@implementation MXRQuestionBanner

#pragma mark - Class Method
+ (CGSize)itemSize {
    CGFloat itemW = SCREEN_WIDTH_DEVICE - IPHONE6_SCREEN_WIDTH_SCALE * 10 * 2;
    return CGSizeMake(itemW, itemW * kCellScale);
}

+ (CGFloat)topEdgeInset {
    return IPHONE6_SCREEN_WIDTH_SCALE * 10;
}

#pragma mark - Public Method
- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - Rewrite Father Method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.collectionView];
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewFlowLayout];
        [_collectionView registerClass:[MXRQuestionBannerCell class] forCellWithReuseIdentifier:MXRQuestionBannerCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = BACKGROUND_COLOR_249;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        _collectionViewFlowLayout.itemSize = self.itemSize;
    }
    return _collectionViewFlowLayout;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MXRQuestionBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MXRQuestionBannerCellIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [MXRQuestionBanner itemSize];
}

//行与行之间的最小距离(纵向)，或者列与列之间的最小距离(横向)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return IPHONE6_SCREEN_WIDTH_SCALE * 10;
}

//列与列之间的最小距离(纵向)，或者行与行之间的最小距离(横向)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake([MXRQuestionBanner topEdgeInset], IPHONE6_SCREEN_WIDTH_SCALE * 10, 0, IPHONE6_SCREEN_WIDTH_SCALE * 10);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(MXRQuestionBannerDidSelectItemAtIndexPath:)]) {
        [_delegate MXRQuestionBannerDidSelectItemAtIndexPath:indexPath];
    }
}

@end
