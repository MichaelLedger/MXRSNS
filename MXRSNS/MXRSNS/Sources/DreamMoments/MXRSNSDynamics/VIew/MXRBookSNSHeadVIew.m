//
//  MXRBookSNSHeadVIew.m
//  huashida_home
//
//  Created by gxd on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSHeadVIew.h"
#import "MXRBookSNSModelProxy.h"
#import "MXRBookSNSHeadTopicCollectionViewCell.h"
//#import "AppDelegate.h"
#import "MXRTopicMainViewController.h"
#import "MXRAllTopicViewController.h"
#define mxrBookSNSHeadTopicCollectionViewCell @"MXRBookSNSHeadTopicCollectionViewCell"

@interface MXRBookSNSHeadVIew()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * collectionViewLayout;
@property (nonatomic, assign) CGSize itemSize;
@end
@implementation MXRBookSNSHeadVIew

-(instancetype)initWithFrame:(CGRect)frame andItemSize:(CGSize)size{

    self = [super initWithFrame:frame];
    if (self) {
        self.itemSize = size;
          [self addSubview:self.collectionView];
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
#pragma mark - View Life Cycle
#pragma mark - Private
-(void)reloaData{

    [self.collectionView reloadData];
}
-(void)getMoreTopic{

    MXRAllTopicViewController *vc = [[MXRAllTopicViewController alloc] init];
//    AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [del.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Delegate
-(NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [MXRBookSNSModelProxy getInstance].bookSNSHeadtopicModelDataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    MXRBookSNSHeadTopicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:mxrBookSNSHeadTopicCollectionViewCell forIndexPath:indexPath];
    cell.model = [MXRBookSNSModelProxy getInstance].bookSNSHeadtopicModelDataArray[indexPath.item];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [MXRClickUtil event:@"DreamCircle_Toptopic_Click"];
    if ([[MXRBookSNSModelProxy getInstance].bookSNSHeadtopicModelDataArray[indexPath.item] topicType] == TopicHandleTypeMoreTopic) {
        [self getMoreTopic];
    }else if([[MXRBookSNSModelProxy getInstance].bookSNSHeadtopicModelDataArray[indexPath.item] topicType] == TopicHandleTypeNormal){
        NSInteger topicId = [[MXRBookSNSModelProxy getInstance].bookSNSHeadtopicModelDataArray[indexPath.item] topicId];
        MXRTopicMainViewController * vc = [[MXRTopicMainViewController alloc] initWithMXRTopicModelID:[NSString stringWithFormat:@"%ld",(long)topicId]];
//        NSString *topicName = [[MXRBookSNSModelProxy getInstance].bookSNSHeadtopicModelDataArray[indexPath.item] name];
//        MXRTopicMainViewController *vc = [[MXRTopicMainViewController alloc] initWithMXRTopicModelName:topicName fromVC:defaultVCType];
//        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [del.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - getter
-(UICollectionView *)collectionView{

    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = BACKGROUND_COLOR_249;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:mxrBookSNSHeadTopicCollectionViewCell bundle:nil] forCellWithReuseIdentifier:mxrBookSNSHeadTopicCollectionViewCell];
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout *)collectionViewLayout{

    if (!_collectionViewLayout) {
        _collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionViewLayout.sectionInset = UIEdgeInsetsMake((20 * IPHONE6_SCREEN_HEIGHT_SCALE)/2, (20 * IPHONE6_SCREEN_HEIGHT_SCALE)/2, (20 * IPHONE6_SCREEN_HEIGHT_SCALE)/2, (20 * IPHONE6_SCREEN_HEIGHT_SCALE)/2);
        _collectionViewLayout.itemSize = self.itemSize;
    }
    return _collectionViewLayout;
}

@end
