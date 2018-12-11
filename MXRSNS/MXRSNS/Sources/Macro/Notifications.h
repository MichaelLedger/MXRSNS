//
//  Notifications.h
//  该文件中存放着所有的全局通知
//
//  Created by MXR on 15-4-16.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#ifndef huashida_home_Notifications_h
#define huashida_home_Notifications_h

/*
 *    后台播放mp3 － 控制中心 － 点击暂停按钮
 *    之后发的通知
 */
#define Notification_For_RemoteControl_Pause @"notificationForRemoteControlPause"

/*
 *    后台播放mp3 － 控制中心 － 点击播放按钮
 *    之后发的通知
 */
#define Notification_For_RemoteControl_Play @"notificationForRemoteControlPlay"

/*
 *
 *    程序进入后台
 *    通知mp3播放停止
 */
#define Notification_For_StopMp3Player_When_Entry_Background @"notificationForStopMp3WhenEntryBackground"
/*
 *
 *    程序进入后台
 *    通知图书阅读引导视频停止播放
 */
#define Notification_For_StopBookGuidePlayer_When_Entry_Background @"notificationForStopBookGuideVideoWhenEntryBackground"
/*
 *
 *    程序进入前台
 *    通知图书阅读引导视频继续播放
 */
#define Notification_For_PlayBookGuidePlayer_When_Entry_Foreground @"notificationForPlayBookGuideVideoWhenEntryForeground"
/*
 *
 *    休息提醒
 *    通知自动阅读暂停播放
 */
#define Notification_For_RestPauseAutomaticReadingMp3 @"Notification_For_RestPauseAutomaticReadingMp3"

/*
 *
 *    休息提醒
 *    通知自动阅读继续播放
 */
#define Notification_For_RestRestartAutomaticReadingMp3 @"Notification_For_RestRestartAutomaticReadingMp3"

/*
 *    用于刷新赚取梦想币界面
 *    之后发的通知
 */
#define Notification_For_RefreshEarnMXBView @"notificationForRefreshEarnMXB"

/*
 *    用于刷新发现界面
 *    之后发的通知
 */
#define Notification_For_RefreshBookFindVC @"notificationForRefreshBookFindVC"
/*
 *    用于刷新赚取梦想币界面
 *    之后发的通知
 */
#define Notification_For_RefreshMXBInPersonVC @"notificationForRefreshMXBInPersonVC"

/*
 *退到后台发出的通知
 *停止录制屏幕
 */
#define Notification_For_StopRecord @"notificationForStopRecord"

/*
 *退到后台发出的通知
 *隐藏键盘
 */
#define Notification_For_HiddenCommentView_When_Entry_Background @"notificationForHiddenCommentView"


/**
 *  有图书下架
 *
 */
#define Notification_For_Book_Unshelve @"NotificationForBookUnshelve"

/*
 *复位按钮是否激活
 *
 */
#define Notification_Fot_ResetButtonIsActive @"ResetButtonIsActive"


#define Notification_For_ResetButtonIsActive @"notificationForResetButtonIsActive"
/**
 * 显示与隐藏模型加载提示
 */
#define Notification_For_ShowARLoadingView @"notificationForShowARLoadingView"
/**
 *   隐藏小梦(翻书动画)loading的视图
 */
#define Notification_For_RemoveGameLoading @"notificationForRemoveGameLoading"
/**
 *   显示与隐藏 梦想人水印图集动画
 */
#define Notification_For_ShowAndHiddenMXRLogoLoading @"notificationForShowAndHiddenMXRLogoLoading"
/*
 *  关闭地面功能开启
 */
#define Notification_For_HideGroudShow @"NotificationForHideGroudShow"
/*
 *  关闭地面功能关闭
 */
#define Notification_For_HideGroudHide @"NotificationForHideGroudHide"


/**
 扫描二维码之后通知UI变化
 */
#define  Notification_For_QRScanOverCheck  @"QRScanOverCheck"
/**
 AR界面上方的导航条重新记时的通知 5秒
 */
#define Notification_For_ARTopView @"notificationForARTopView"
#define Notification_For_HideColorEgg @"Refresh_Shelf_withHideColorEggView"

/**
 刷新私信聊天界面的view的通知
 */
#define RefreshChatNotification @"RefreshChatNotification"
/**
 刷新私信列表的通知
 */
#define RefreshLetterNotification @"RefreshLetterNotification"
/**
 重新请求私信列表通知
 */
#define RequestLetterNotification @"RequestLetterNotification"
/**
 刷新评论列表的通知
 */
#define RefreshCommentNotification @"RefreshCommentNotification"
/**
 当评论回复的推送过来后 需要重新请求评论回复列表页的数据
 */
#define RequestComment @"RequestComment"
/**
 当通知中心的推送过来后  需要重新请求一下通知中心的数据
 */
#define RequestNotification @"RequestNotification"
/**
 刷新私信的红点
 */
#define letterReadPointShow    @"letterReadPointShow"
/**
 刷新通知红点
 */
#define showNotiReadPoint    @"showNotiReadPoint"
/**
 私信上传图片进度通知
 */
#define ChatUpLoadImageProgressChanged @"ChatUpLoadImageProgressChanged"
/**
 私信上传图片数组完成
 */
#define ChatUpLoadImageCompleted @"ChatUpLoadImageCompleted"
/**
 私信上传图片数组错误
 */
#define ChatUpLoadImageError @"ChatUpLoadImageError"
/**
 私信上传图片url 到服务器完成后
 */
#define ChatSendImageUrlComplete @"ChatSendImageUrlComplete"
/**
 私信聊天界面需要重新请求聊天数据
 */
#define chatDataRequest @"chatDataRequest"
/**
 刷新评论的红点
 */
#define showCommentRedPoint    @"showCommentRedPoint"
/**
 刷新我界面的红点
 */
#define showSelfReadPoint @"showSelfReadPoint"
/**
 在我界面去请求消息的数据 好让红点信息可以显示
 */
#define SelfShouldRequestMessageData @"SelfShouldRequestMessageData"
/**
 当评论详情整条删除后 退回到上一级页面 需要刷新一下 评论回复列表
 */
#define RefreshCommentList @"RefreshCommentList"

#define MyComment_RefreshView @"MyComment_RefreshView"

/**
 刷新"我"的界面的梦想币
 */
#define Notification_ForReloadMXBData @"Notification_For_ReloadMXBData"
/**
  刷新界面上的用户的钻石
 */
#define Notification_For_RefreshUserDiamond @"notificationForRefreshUserDiamond"

/// 刷新"我"的界面的用户优惠券个数
#define Notification_For_RefreshUserCouponCount @"notificationForRefreshUserCouponCount"

/**
 绑定渠道码成功后送梦想币
 */
#define  Notification_For_BandleChannelCodeSuccess @"BandleChannelCodeSuccess"

/*
 充值成功后的通知
 */
#define Notification_For_Pay_Success @"notificationForPaySuccess"


#pragma mark - 上传
/**
 *  开始上传
 *
 *  @return <#return value description#>
 */
#define Notification_For_Upload_Begin @"Notification_For_Upload_Begin"

/**
 消息模块的通知 当数据库中的所有数据清为已读后，发送通知  通知界面刷新界面
 */
#define Notification_For_Update_NotificationCenterView @"Notification_For_Update_NotificationCenterView"
/**
 注册成功之后的通知
 */
#define Notification_For_RegisterSuccess @"Notification_For_For_RegisterSuccess"

/**
 *  图书评论，删除主评论失败
 *
 */
#define deleteMainCommentFailNotification @"deleteMainCommentFail"
/**
 *  更新数据源成功
 *
 */
#define updateDatasourceSuccess @"updateDatasourceSuccess"
/**
 *  图书评论刷新数据
 *
 *
 */
#define Notification_Book_Comment_To_ReloadData @"NotificationBookCommentToReloadData"

/**
 *  取消赞失败
 *
 *  @return <#return value description#>
 */
#define notificationCancelPraiseFailure    @"notificationCancelPraiseFailure"
/**
 *  回复评论成功
 *
 *  @return <#return value description#>
 */
#define notificationAddReplyCommentSuccess @"notificationAddReplyCommentSuccess"
/**
 *  回复评论失败
 *
 *  @return <#return value description#>
 */
#define notificationAddReplyCommentFailure @"notificationAddReplyCommentFailure"
/**
 *  新增评论成功
 *
 *  @return <#return value description#>
 */
#define notificationAddNewCommentSuccess   @"notificationAddNewCommentSuccess"
/**
 *  新增评论失败
 *
 *  @return <#return value description#>
 */
/*
 *取消所有请求通知
 */
#define notificationCancelAllNotifications   @"notificationCancelAll"

/**
 *  新增评论失败
 *
 */
#define notificationAddNewCommentFailure     @"notificationAddNewCommentFailure"
/**
 *  刷新表格成功
 *
 */
#define notificationTabViewReloadDataSuccess @"notificationTabViewReloadDataSuccess"

#define notificationEqualParamHaveReturn     @"notificationEqualParamHaveReturn"

#define notificationDeleteANotiFication @"notificationDeleteANotiFication"
/**
 *  刷新评论
 *
 */
#define notificationRefreshComment           @"notificationRefreshComment"
/*
 *私信界面 图片请求成功 通知刷新界面
 */
#define ChatRefreshChat                      @"ChatRefreshChat"
/**
 *
 *评论状态改变
 */
#define notificationStatusHaveChanged        @"notificationStatusHaveChanged"
/**
 *  用户登录失败通知
 *
 */
#define notificationUserLoginFailure         @"notificationUserLoginFailure"

/*
 登录成功的通知
 */
#define notificationForUserLoginSuss         @"MXRUSerLoginSuss"


/**
 用户退出通知
 */
#define Notification_UserLogout               @"Notification_UserLogout"

/*
 点击任务事件的通知
 */
#define notificationForTaskClick     @"notificationForTaskClick"

/**
 *  删除diy云端图书
 *
 *  @return <#return value description#>
 */
#define notificationForDeleteDiyBookOnServer @"notificationForDeleteDiyBookOnServer"
/**
 *  解除账号绑定
 *
 *  @return <#return value description#>
 */
#define notificationForChangeBandel @"notificationForChangeBandel "

/**
 *  搜索请求失败
 *
 *  @return <#return value description#>
 */
#define Request_Search_Filed @"request_Filed"
/**
 *  搜索历史按钮点击
 *
 *  @return <#return value description#>
 */
#define History_Button_Ciclk @"historyButtonCiclk"
/**
 *  改变搜索历史本地数组
 *
 *  @return <#return value description#>
 */
#define Chang_SaveArray_History @"changSaveArrayHistory"
/**
 *  没有搜索到结果
 *
 *  @return <#return value description#>
 */
#define No_More_Result @"haveNoResult"
/**
 *  程序退出通知
 */
#define Notification_ApplicationWillTerminate @"MXRApplicationWillTerminate"

/*
 *搜索话题 当搜索结果请求完成后插入到缓存数组的时候 这个时候需要通知界面去刷新界面
 */
#define SearchTopic_RefreshView @"SearchTopic_RefreshView"
/**
 *梦想圈首页刷新数据
 */
#define Notification_MXRBookSNS_ReloadData  @"NotificationMXRBookSNSReloadData"
/**
 *梦想圈首页可以快速回到顶部
 */
#define Notification_MXRBookSNS_ScrollTopEnable  @"NotificationMXRBookSNSScrollTopEnable"
/**
 *梦想圈首页禁止快速回到顶部
 */
#define Notification_MXRBookSNS_ScrollTopNoEnable  @"NotificationMXRBookSNSScrollTopNoEnable"
/**
 *梦想圈首页所有动态的刷新
 */
#define Notification_MXRBookSNS_UpdateALLMoment  @"NotificationMXRBookSNSUpdateALLMoment"
/**
 *梦想圈首页热门话题的刷新
 */
#define Notification_MXRBookSNS_UpdateHotTopic  @"NotificationMXRBookSNSUpdateHotTopic"
/**
 *梦想圈点击图书进入图书详情前
 */
//#define Notification_MXRBookSNS_GotoBookDetailBefore  @"NotificationMXRBookSNSGotoBookDetailBefore  "
/**
 *梦想圈点击图书进入图书详情后
 */
//#define Notification_MXRBookSNS_GotoBookDetailAfter    @"NotificationMXRBookSNSGotoBookDetailAfter"
/**
 *梦想圈显示tabbar
 */
#define Notification_MXRBookSNS_ShowTabbar   @"NotificationMXRBookSNSShowTabbar"
/**
 * 动态被删除
 */
#define Notification_MXRBookSNS_MomentDelete   @"NotificationMXRBookSNSMomentDelete"
/**
 * 动态被用户操作
 */
#define Notification_MXRBookSNS_UserHandleMoment   @"NotificationMXRBookSNSUserHandleMoment"
#define Notification_MXRBookSNS_TopicShare @"NotificationMXRBookSNSTopicShare"
#define Notification_MXRSelectImageLocal_ReloadData @"NotificationMXRSelectImageLocalReloadData"
#define Notification_LetterFriendList_Share @"LetterFriendShareListNotification"
#define Notification_BookStore_SubjectDetail_NoMoreData @"notificationBookStoreSubjectDetailNoMoreData"
#define Notification_MXRBookSNS_TopicNoData @"NotificationMXRBookSNSTopicNoData"
#define Chat_Show_Share_Status @"ChatShowSHareStatus"

/**
当分享图片到点私信聊天界面的时候 点击退出 这个时候发送该通知  在选择好友界面 退出
*/
#define Dissmiss_SelectFriend @"DissmissSelectFriend"



#define Notification_BookPress_HaveMakeService @"NotificationBookPressHaveMakeService"

/**
 分享视频时，上传视频到七牛服务器相关通知
 */
#define Notification_Share_UploadVideo_Complete @"notification_Share_UploadVideo_Complete"
#define Notification_Share_UploadVideo_Fail @"notification_Share_UploadVideo_Fail"
#define Notification_Share_UploadVideo_Progress @"notification_Share_UploadVideo_Progress"

/**
 5.0 当试题解锁需要离线阅读中的图书的图书更新解锁信息
 缓存（MXRControl和BookExManager）的不用更新吗
 */
/// 答题解锁的时候发送通知 或者 答完题的时候发送通知（V5.1.1 蚕宝宝） 该主要用在更新缓存的时候用
#define Notification_NeedUpdateBookCoursesStateByBookGuid @"Notification_NeedUpdateBookCoursesStateByBookGuid"
//／ 更新离线阅读中的书和蚕宝宝中的书
#define Notification_NeedUpdateBookCoursesUnlockStateByBookGuid @"Notification_NeedUpdateBookCoursesUnlockStateByBookGuid"
/// 更新蚕宝宝中的书
#define Notification_NeedUpdateBookCoursesHadAnsweredStateByBookGuid @"Notification_NeedUpdateBookCoursesHadAnsweredStateByBookGuid"
/// 答题成功插入到服务器数据的时候发送通知
#define Notification_NeedUpdateBookCoursesByBookGuid @"notification_NeedUpdateBookCoursesByBookGuid"
/// 发送需要分享蚕宝宝 （V5.1.1 蚕宝宝）
#define Notification_NeedShareCanbabyBookByBookGuid @"Notification_NeedShareCanbabyBookByBookGuid"

// 书架
#define Notification_Shelf_Pan_Notification @"Notification_Shelf_Pan_Notification"

#define NSNotification_To_Download_Book @"NSNotification_To_Download_Book"
//播放视频（分享）
#define Notification_Video_To_Play  @"NotificationVideoToPlay"
#define Notification_Video_To_Pause @"NotificationVideoToPause"
#define Notification_PreviewScroll_End_Decceleting   @"NotificationPreviewScrollEndDecceleting"
//删除图片，刷新数据
#define Notification_Go_To_Reload_Data_After_Delete @"NotificationGoToReloadDataAfterDelete"



/******下载相关*******/
#define MXRBookDownloadProgressChangedNotification @"MXR_BOOK_DOWNLOAD_PROGRESS_CHANGED_NOTIFICATION" // 进度修改
#define MXRBookDownloadFailNotification @"MXR_BOOK_DOWNLOAD_FAIL_NOTIFICATION" // 下载失败
#define MXRBookDownloadCompleteNotification @"MXR_BOOK_DOWNLOAD_COMPLETE_NOTIFICATION" // 下载成功
#define MXRDoBookDownloadNotification @"MXR_DO_BOOK_DOWNLOAD_NOTIFICATION" // 下载图书操作      // add by martin.liu 5.7.0
// 第一次请求到设备ID后的通知
#define MXRRequestDeviceIdNotification @"MXR_RequestDeviceId_Notification"


// unlockwebview
#define Notification_MXRUnlockWebviewUnlockSuccess @"Notification_MXRUnlockWebviewUnlockSuccess" // 解锁成功通知

#define Notification_ClickAppStatusBar @"needPopToRootViewController"   // 识别图片

#define Notification_Have_NoMore_Topic @"notificationHaveNoMoreTopic"       // 没有更多话题

#define Notification_NeedBackFromOfflineRecommendVC @"needBackFromOfflineRecommendView"  //图书推荐页跳转图书详情前退出图书通知
#define Notification_GoToQuestionDetailVC @"Notification_GoToQuestionDetailVC" //图书推荐页跳转问答先退出图书的通知
// UserReplyNoti

#define Notification_UserReplyNoti_NoRead @"notification_UserReplyNoti_NoRead"   // 消息未读通知

#define Notification_RNNoti_Share @"Notification_RNNoti_Share"//react-native 分享页面

#define Notification_RNNoti_ColseMissionCompleye @"Notification_RNNoti_ColseMissionCompleye" // 关闭答题
#define Notification_RNNoti_MissionTryAgain @"Notification_RNNoti_MissionTryAgain" // 再测一次
#define Notification_RNNoti_MissionCompleteInviteFriends @"Notification_RNNoti_MissionCompleteInviteFriends" // 邀请好友pk

#define Notification_RNNoti_PKAgain @"Notification_RNNoti_PKAgain" // 继续PK

#define Notification_QuitMissionCompleteVCGoToBook @"QuitMissionCompleteVCGoToBook" //推出完成答题界面后通知问答列表页面进入另一本图书

#define Notification_ClearMXQCacheNoti @"Notification_ClearMXQCacheNoti"//清空梦想圈数据&刷新

#define Notification_ModifyUserAgeSuccess @"Notification_ModifyUserAgeSuccess"//用户选择年龄／修改年龄成功后刷新数据

#define NOtification_ChoosedServerType @"NOtification_ChoosedServerType"//测试包选择了服务器（用于刷新数据）

#define Notification_ClickHomeButton @"Notification_ClickHomeButton"    // 点击了书城页面的首页按钮

#define Notification_Google_Login_Result @"Notification_Google_Login_Result" //Google登录回调通知

#define Notification_PK_Submit_Answer @"Notification_PK_Submit_Answer" //pk提交答题成功通知

#define Notification_TabBar_Selected @"Notification_TabBar_Selected"//tabbar点击事件（object为selectedIndex）

#define NOtificatino_APP_DidBecomeActive @"NOtificatino_APP_DidBecomeActive"//App进入前台通知

#define Notification_Need_Skip_APPGuide_And_AgeSelect @"Notification_Need_Skip_APPGuide_And_AgeSelect"  //外部App条转过来的跳过启动引导页和年龄选择页 （例如：美慧树）

#define Notification_AuthenticatingName_Close @"Notification_AuthenticatingName_Close" // 第三方登录后昵称鉴定页面关闭通知

/*
 扭蛋做任务刷新梦想币功能
 */
#define NotificationForCapsulesToysToRefreshMXB     @"NotificationForCapsulesToysToRefreshMXB"

#define Notification_AllAdvertView_Close @"Notification_AllAdvertView_Close"    //5.9.1 Version 点击某一个启动弹窗后关闭其它弹窗通知

#define  Notification_UpdateZoneStatus @"Notification_UpdateZoneStatus" // 更新购买专区上新是否显示

#define Notification_BookReading_AudioStateNoti @"Notification_BookReading_AudioStateNoti"  //图书阅读界面的音频播放状态更改通知 V5.9.5

#define Notification_GuestLoginSuccess @"Notification_GuestLoginSuccess"  // V5.10.0 by liulong  增加游客登录成功通知

#define Notification_MXRSearchZoneResult_NoMoreData @"Notification_MXRSearchZoneResult_NoMoreData"    //搜索话题页没有更多数据通知

#define Notification_MXRShareVideoUrlSuccess @"Notification_MXRShareVideoUrlSuccess"    //分享视频连接成功之后，通知 5.12.0

#define Notification_VIPHeadViewHeightDidChange @"Notification_VIPHeadViewHeightDidChange"  //VIP 头部视图高度 5.13.0

#define Notification_VIPHeadViewSelectedEventType @"Notification_VIPHeadViewSelectedEventType"  //VIP 头部视图事件传递

#define Notification_ReloadPersonInfo @"reloadPersonInfo"  //刷新个人信息

#define Notification_FlipToMarkIdFromUnity @"Notification_FlipToMarkIdFromUnity"  //刷新个人信息

#define Notification_SubjectDetail_ZoneClicked @"Notification_SubjectDetail_ZoneClicked"  //专区详情，图书购买弹窗，专题按钮点击 5.14.0

#define Notification_Course_Pay_Success @"Notification_Course_Pay_Success"  //课程支付成功 5.15.0

#define Notification_Share_Success @"Notification_Share_Success"// 分享成功通知

#endif
