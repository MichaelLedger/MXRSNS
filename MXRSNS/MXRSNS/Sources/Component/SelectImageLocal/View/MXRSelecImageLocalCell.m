//
//  MXRSelecImageLocalCell.m
//  xuanquTupian
//
//  Created by yuchen.li on 16/8/24.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import "MXRSelecImageLocalCell.h"
#import "MXRImageInformationModel.h"
#import "MXRSelectLocalImageProxy.h"
#import "MXRGetLocalImageController.h"
#import <Photos/Photos.h>
#import "GlobalBusyFlag.h"
@interface MXRSelecImageLocalCell()

@property (weak, nonatomic) IBOutlet UILabel *selectOrderLabel;
@property (weak, nonatomic) IBOutlet UIView *selectBackgroundView;

@end
@implementation MXRSelecImageLocalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *recognized = [[UITapGestureRecognizer alloc]init];
    [recognized addTarget:self action:@selector(tapAction)];
    self.selectBackgroundView.userInteractionEnabled = YES;
    [self.selectBackgroundView addGestureRecognizer:recognized];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    UIImage *imageB = MXRIMAGE(@"img_selectImage_photo");
    imageView.image = imageB;
    self.backgroundView = imageView;
}

-(void)configureCellWithModelSystermSeven:(MXRImageInformationModel*)model{
    _imageInfoModel = model;
    _selectFlag = NO;

    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.image = model.dic[@"img"];
    _selectFlag = [[model.dic objectForKey:@"flga"]boolValue];
    if (model.isLastSelectImage ) {
        self.isSelectImageView.hidden = NO;
        if (_selectFlag ) {
            self.isSelectImageView.image = MXRIMAGE(@"icon_selectImage_selected");
        }else{
            self.isSelectImageView.image = MXRIMAGE(@"icon_selectImage_unselected");
        }
    }else{
        self.isSelectImageView.hidden = YES;
    }
    if (model.isAddCamera) {
        self.bgImageView.hidden = NO;
    }else{
        self.bgImageView.hidden = YES;
    }
}
- (void)setImageInfoModel:(MXRImageInformationModel *)imageInfoModel
{
    _imageInfoModel = imageInfoModel;
    _selectFlag = NO;
    UITapGestureRecognizer *recognized = [[UITapGestureRecognizer alloc]init];
    [recognized addTarget:self action:@selector(tapAction)];
    self.isSelectImageView.userInteractionEnabled = YES;
    self.isSelectImageView.contentMode = UIViewContentModeScaleToFill;
    [self.isSelectImageView addGestureRecognizer:recognized];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    UIImage *imageB = MXRIMAGE(@"img_selectImage_photo");
    imageView.image = imageB;
    self.backgroundView = imageView;
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _selectFlag = [[_imageInfoModel.dic objectForKey:@"flga"]boolValue];
    if (_imageInfoModel.isLastSelectImage ) {
        self.isSelectImageView.hidden = NO;
        if (_selectFlag ) {
            self.isSelectImageView.image = MXRIMAGE(@"icon_selectImage_selected");
        }else{
            self.isSelectImageView.image = MXRIMAGE(@"icon_selectImage_unselected");
        }
    }else{
        self.isSelectImageView.hidden = YES;
    }
    if (_imageInfoModel.isAddCamera) {
        self.bgImageView.hidden = NO;
    }else{
        self.bgImageView.hidden = YES;
    }
    if (self.imageInfoModel.selectOrder == 0) {
        self.selectOrderLabel.hidden = YES;
    }else{
        self.selectOrderLabel.text = [NSString stringWithFormat:@"%ld",self.imageInfoModel.selectOrder];
        self.selectOrderLabel.hidden = NO;
    }
    //分享视频
    if (_imageInfoModel.asset.mediaType == PHAssetMediaTypeVideo) {
        _timeLabel.text = [NSString stringWithFormat:@"0:%02ld",(long)_imageInfoModel.asset.duration];
        _timeContainerView.layer.contents = (id)MXRIMAGE(@"bg_selecImageLocalCell_videoTimeBg").CGImage;
    }else{
        _timeLabel.text = @"";
        _timeContainerView.layer.contents = (id)[UIImage imageNamed:@""].CGImage;
    }
}


/**
 * 选择图片或者取消选择图片
 */
-(void)tapAction{
    // 当选中数量为1时, 请空之前选中的（不弹提示框）
    if ([MXRSelectLocalImageProxy getInstance].maxCount != 1) {
        NSInteger count = [[MXRGetLocalImageController getInstance]getSelectImageCount ];
        if (count >= [MXRSelectLocalImageProxy getInstance].maxCount && !self.selectFlag) {
            [self.delegate userHaveSelectTooMuchImage];
            return;
        }
    }
    BOOL flag = [[self.imageInfoModel.dic objectForKey:@"flga"] boolValue];
    // 改为 选中 状态
    if (!flag)
    {
        BOOL isAddSuccess = [[MXRSelectLocalImageProxy getInstance]selectImageChangeStatusWithModel:self.imageInfoModel];
        if (isAddSuccess) {
            [self setSelectFlag:!flag];
            self.selectOrderLabel.hidden = NO;
        }
        NSInteger countAfter = [[MXRGetLocalImageController getInstance]getSelectImageCount];
        // 为了选择一张时 局部刷新  
        if ([MXRSelectLocalImageProxy getInstance].maxCount == 1) {
            // 记录最近两次选择的照片位置
            __block NSMutableArray *indexPathArray = [[NSMutableArray alloc]init];
            [[MXRSelectLocalImageProxy getInstance].preSelectImageModelArray enumerateObjectsUsingBlock:^(MXRImageInformationModel * _Nonnull preObj, NSUInteger idx, BOOL * _Nonnull stop) {
                [[MXRSelectLocalImageProxy getInstance].imageInfoModelArray enumerateObjectsUsingBlock:^(MXRImageInformationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([preObj.asset.localIdentifier isEqualToString:obj.asset.localIdentifier]) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                        [indexPathArray addObject:indexPath];
                    }
                }];
            }];
            if ([MXRSelectLocalImageProxy getInstance].preSelectImageModelArray.count >= 1 ) {
                // 清除之前选择的图片,重新选择
                [[MXRSelectLocalImageProxy getInstance]removeAllPreselectImageInfoModelData];
                [[MXRSelectLocalImageProxy getInstance]becomeImagestateToUncheck];
                [[MXRSelectLocalImageProxy getInstance]selectImageChangeStatusWithModel:self.imageInfoModel];
                [self.delegate haveSelectImageWithIndexPathArray:indexPathArray];
            }
        }
        [self.delegate userPrepareToSendWithCount:countAfter];
    // 改为 未选中 状态
    } else {
        BOOL isReduceSuccess = [[MXRSelectLocalImageProxy getInstance]unselectImageChangeStatusWithModel:self.imageInfoModel];
        if (isReduceSuccess) {
            [self setSelectFlag:!flag];
            self.selectOrderLabel.hidden = YES;
        }
        NSInteger countAfter = [[MXRGetLocalImageController getInstance]getSelectImageCount];
        [self.delegate userPrepareToSendWithCount:countAfter];
    }
}
/**
 * 更改图片状态
 */
-(void)setSelectFlag:(BOOL)flag{
    _selectFlag = flag;
    if (_selectFlag) {
        self.selectOrderLabel.hidden = NO;
        self.isSelectImageView.image = MXRIMAGE(@"icon_selectImage_selected");
    }else{
        self.selectOrderLabel.hidden = YES;
        self.isSelectImageView.image = MXRIMAGE(@"icon_selectImage_unselected");
    }
}
@end
