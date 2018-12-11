//
//  MXRBookSNSHeadTopicCollectionViewCell.m
//  huashida_home
//
//  Created by gxd on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSHeadTopicCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "MXRTopicModel.h"
@interface MXRBookSNSHeadTopicCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *topicimageView;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;

@end
@implementation MXRBookSNSHeadTopicCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
    // Initialization code
}
-(void)setup{

    self.topicimageView.layer.masksToBounds = YES;
    self.topicimageView.layer.cornerRadius = 4.0f;
    self.maskImageView.layer.masksToBounds = YES;
    self.maskImageView.layer.cornerRadius = 4.0f;
}
-(void)setModel:(MXRTopicModel *)model{

    _model = model;
    if (model) {
        [self.topicimageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:MXRIMAGE(@"img_bookSNS_topicPlaceholder") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
         self.topicLabel.text = model.name;
//        if (model.topicType == TopicHandleTypeMoreTopic) {
//            self.maskImageView.hidden = YES;
//        }else{
            self.maskImageView.hidden = NO;
//        }
    }
}
@end
