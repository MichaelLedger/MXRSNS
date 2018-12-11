//
//  MXRSearchTopicViewController.h
//  huashida_home
//
//  Created by lj on 16/9/22.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//  搜索话题页面

#import "MXRDefaultViewController.h"

@protocol MXRBookSNSTopicSelectDelegate <NSObject>
@optional
-(void)userHaveSelectTopicDelegate:(NSString*)topicString;
//跳转到 话题页
-(void)pushToTopicViewController:(UIViewController*)vc;
//退回到 发送动态页面让其变为 编辑键盘弹起状态
-(void)makeTextViewBecomeFirstResponder;
//cancel按钮点击
-(void)cancelBtnClicked;
//隐藏导航栏的代理方法
-(void)hiddenNavgationBar;
@end

@interface MXRSearchTopicViewController : MXRDefaultViewController
@property (nonatomic, weak)id<MXRBookSNSTopicSelectDelegate> delegate;
@property (nonatomic, assign)NSInteger pageIndex;
//isNeedJing 向发送动态页  传话题名称 前面是否需要#
//shouldBecomeFirstRegister 到该页面 键盘是否需要弹出
//isFromAllTopic 是否从 全部话题跳转过去
-(instancetype)initWithIsNeedJing:(BOOL)isNeedJing withSearchTextFieldBecomeFirstRegister:(BOOL)shouldBecomeFirstRegister withIsFromAllTopic:(BOOL)isFromAllTopic;
//index 表明 上拉加载列表的时候 从第几页 开始加载  (该初始化方法  从全部话题进入的时候需要  其它使用上方的初始化方法即可)
-(instancetype)initWithIsNeedJing:(BOOL)isNeedJing withSearchTextFieldBecomeFirstRegister:(BOOL)shouldBecomeFirstRegister withIsFromAllTopic:(BOOL)isFromAllTopic withPageIndex:(NSInteger)index;
@end
