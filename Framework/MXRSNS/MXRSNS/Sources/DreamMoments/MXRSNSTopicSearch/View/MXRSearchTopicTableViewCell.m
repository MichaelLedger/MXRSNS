//
//  MXRSearchTopicTableViewCell.m
//  huashida_home
//
//  Created by lj on 16/9/22.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSearchTopicTableViewCell.h"
#import "MXRSearchTopicModel.h"
#import "UIImageView+WebCache.h"

@implementation MXRSearchTopicTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - 配置界面
-(void)configUI
{
    NSString *picUrlStr = [self getPicUrlStr:_model.searchPic];
    _topicHeaderImageView.layer.borderWidth=0.8f;
    _topicHeaderImageView.layer.borderColor=RGB(0xe0,0xe0, 0xe0).CGColor;
    if (_model.isNewTopic) {   //是新话题 头像使用默认的
        _topicHeaderImageView.image = MXRIMAGE(@"icon_common_bookIconPlaceholder");
    }
    else{
        [_topicHeaderImageView sd_setImageWithURL:[NSURL  URLWithString:picUrlStr]  placeholderImage:MXRIMAGE(@"icon_common_bookIconPlaceholder") options:SDWebImageRefreshCached]; //设置标题图片
    }
    NSString *titileStr = [_model.name stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    _titleLabel.text = titileStr;
    //设置标题的名称  判断该话题是否是新话题
    _numberLabel.text = _model.isNewTopic?MXRLocalizedString(@"MXRSearchTopicViewController_NewTopic", @"新话题"):[NSString stringWithFormat:@"%ld%@",(long)_model.publishDynamicNum<0?0:(long)_model.publishDynamicNum,MXRLocalizedString(@"MXRSsearchTopicViewController_Dynamic", @"条动态")]; //设置参加的人数
}

#pragma mark - setter
-(void)setModel:(MXRSearchTopicModel *)model
{
    _model = model;
    [self configUI];
}
#pragma mark - 私有方法
-(NSString*)getPicUrlStr:(NSString*)picStr
{
    NSString *newPicStr = picStr;
    if ([newPicStr rangeOfString:@"http://"].location == NSNotFound && [newPicStr rangeOfString:@"https://"].location == NSNotFound) {
        newPicStr = [NSString stringWithFormat:@"http://%@",newPicStr];
    }
    newPicStr = [newPicStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //防止中文出现 无法请求到图片
    return newPicStr;
}
-(void)dealloc
{
    _model = nil;
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.contentView removeFromSuperview];
    
}

@end
