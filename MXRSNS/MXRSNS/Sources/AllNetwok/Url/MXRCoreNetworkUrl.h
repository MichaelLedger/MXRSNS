//
//  MXRCoreNetworkUrl.h
//  huashida_home
//
//  Created by 周建顺 on 2017/5/25.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRCoreNetworkUrl_h
#define MXRCoreNetworkUrl_h

#import "MXRNetworkUrl.h"

// 通过扫码下载图书完成后记录下载次数
//知识树
// 通过扫码下载图书完成后记录下载次数
//新的书城服务
static inline NSString *MXR_CORE_API_URL(){
    return MXRBASE_API_URL();
}

// 获取图书发布者信息
#define SuffixURL_Get_Book_PublishInfo         @"core/publisher/info"
#define ServiceURL_Get_Book_PublishInfo        URLStringCat(MXR_CORE_API_URL(), SuffixURL_Get_Book_PublishInfo)


//#define  SuffixURL_Core_Download_Book_Before_Info @"core/download/book/before/info"
//#define  ServiceURL_Core_Download_Book_Before_Info        URLStringCat(MXR_CORE_API_URL(), SuffixURL_Core_Download_Book_Before_Info)

#define SuffixURL_Core_My_Coin_Read_add         @"core/my/coin/read/add"
#define ServiceURL_Core_My_Coin_Read_add        URLStringCat(MXR_CORE_API_URL(), SuffixURL_Core_My_Coin_Read_add)

//一维码请求书本详情
#define SuffixURL_BABCODE                           @"core/book/scanning"
#define ServiceURL_BarCode                              URLStringCat(MXR_BASE_SERVICE_API_URL(),SuffixURL_BABCODE)

/// ==========================================================================================
/// author : liulongDev
/// 图书详情、图书评论相关服务的后缀路径
#define SuffixURL_BookDetail_GetDetail              @"core/book/detail"                          // 获取图书的详情

#define SuffixURL_BookDetail_CacncelCollectionBook  @"core/user/book/collection/cancel"          // 批量删除
#define SuffixURL_BookDetail_DeleteBookPage         @"core/book/delete/page"                    // 特殊用户删除指定图书指定页

/// 图书详情、图书评论相关服务的全路径
#define ServiceURL_BookDetail_GetDetail             URLStringCat(MXR_CORE_API_URL(), SuffixURL_BookDetail_GetDetail)     // 获取图书的详情

#define ServiceURL_BookDetail_CacncelCollectionBook URLStringCat(MXR_CORE_API_URL(), SuffixURL_BookDetail_CacncelCollectionBook) // 批量删除
#define ServiceURL_BookDetail_DeleteBookPage        URLStringCat(MXR_CORE_API_URL(), SuffixURL_BookDetail_DeleteBookPage)      // 特殊用户删除指定图书指定页


#pragma mark -
#pragma mark 知识树相关服务
/// ==========================================================================================
/// author : liulongDev
/// 知识树相关服务的后缀路径
#define SuffixURL_KnowledgeTree_PostAnswer                  @"core/knowledge/user/question/record/insert"           // 用户答题记录   by 张来涛
#define SuffixURL_KnowledgeTree_GetBookLockTreeInfo         @"core/knowledge/subject/info"                          // 知识柱树状信息  by 张来涛
#define SuffixURL_KnowledgeTree_ClearBookKnowledgeTreeInfo  @"core/knowledge/user/question/record/delete"    // 知识树清除用户记录 by 张来涛 蚕宝宝死亡的时候用到

/// 知识树相关服务的全路径
#define ServiceURL_KnowledgeTree_PostAnswer                     URLStringCat(MXR_CORE_API_URL(), SuffixURL_KnowledgeTree_PostAnswer)                // 获取图书的详情
#define ServiceURL_KnowledgeTree_GetBookLockTreeInfo            URLStringCat(MXR_CORE_API_URL(), SuffixURL_KnowledgeTree_GetBookLockTreeInfo)       // 知识柱树状信息  by 张来涛
#define ServiceURL_KnowledgeTree_ClearBookKnowledgeTreeInfo     URLStringCat(MXR_CORE_API_URL(), SuffixURL_KnowledgeTree_ClearBookKnowledgeTreeInfo)// 知识树清除用户记录 by 张来涛 蚕宝宝死亡的时候用到

#define SuffixURL_RankListUrl                                   @"core/knowledge"
#define SuffixURL_knowledgel_subject_info                       @"core/knowledge/subject/info"
#define ServiceURL_RankListUrl                                  URLStringCat(MXR_CORE_API_URL(),SuffixURL_RankListUrl)
#define ServiceURL_RankListAcknowlegeUrl                        URLStringCat(MXR_CORE_API_URL(),SuffixURL_knowledgel_subject_info)

#define SuffixURL_home_advert_info                              @"core/home/advert/info"
#define ServiceURL_home_advert_info                             URLStringCat(MXR_CORE_API_URL(),SuffixURL_home_advert_info)

//V5.8.4 首页多条弹窗
#define SuffixURL_home_advert_infos                              @"core/home/advert/infos"
#define ServiceURL_home_advert_infos                             URLStringCat(MXR_CORE_API_URL(),SuffixURL_home_advert_infos)

//V5.8.6  赠送图书
#define SuffixURL_home_presentingBooks                           @"core/book/present/pop"
#define ServiceURL_home_presentingBooks                          URLStringCat(MXR_CORE_API_URL(),SuffixURL_home_presentingBooks)

//V5.13.0 获取签到列表
#define SuffixURL_home_User_Sign_In                              @"core/sign/page/data"
#define ServiceURL_home_User_Sign_In                          URLStringCat(MXR_CORE_API_URL(),SuffixURL_home_User_Sign_In)

//5.8.6 记录用户赠送记录
#define SuffixURL_home_record_presentingBooks                    @"core/book/present/save/record"
#define ServiceURL_home_record_presentingBooks                   URLStringCat(MXR_CORE_API_URL(),SuffixURL_home_record_presentingBooks)

//V5.8.6 首页悬浮红包活动（检查活动状态）
#define SuffixURL_home_activity_status                           @"core/activity/gift/present/check/status"
#define ServiceURL_home_activity_status                          URLStringCat(MXR_CORE_API_URL(),SuffixURL_home_activity_status)

//V5.8.6 首页悬浮红包活动（检查用户当天能否领取）
#define SuffixURL_home_activity_draw_status                      @"core/activity/gift/present/check/present"
#define ServiceURL_home_activity_draw_status                     URLStringCat(MXR_CORE_API_URL(),SuffixURL_home_activity_draw_status)

//V5.8.6 首页悬浮红包活动(领取 1:buttonNum)
#define SuffixURL_home_activity_draw                             @"core/activity/gift/present/get/1"
#define ServiceURL_home_activity_draw                            URLStringCat(MXR_CORE_API_URL(),SuffixURL_home_activity_draw)

//V5.9.0 首页悬浮扭蛋按钮（检查活动状态）
#define SuffixURL_home_check_egg_status                           @"/core/activity/swing/egg/check/time"
#define ServiceURL_home_check_egg_status                         URLStringCat(MXR_CORE_API_URL(),SuffixURL_home_check_egg_status)

#pragma mark---

//获取赠送图书数据
#define SuffixURL_PresentBook                                       @"core/magicLamp/present"
#define ServiceURL_PresentBook                                      URLStringCat(MXR_CORE_API_URL(),SuffixURL_PresentBook)

#define SuffixURL_Core_Book_state(__userId,__bookGuid)      [NSString stringWithFormat:@"core/book/status/user/%@/%@", __userId, __bookGuid]
#define ServiceURL_Core_Book_state(__userId,__bookGuid)     URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_Book_state(__userId,__bookGuid))

#define SuffixURL_home_floor_books(__moduleId)              [NSString stringWithFormat:@"core/home/floor/books/%@", __moduleId]
#define ServiceURL_home_floor_books(__moduleId)             URLStringCat(MXR_CORE_API_URL(),SuffixURL_home_floor_books(__moduleId))


#define SuffixURL_Core_banner_template(__captionId)                   [NSString stringWithFormat:@"core/banner/template/%@", __captionId]
#define ServiceURL_Core_banner_template(__captionId)                  URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_banner_template(__captionId))

#define SuffixURL_Core_home_recommend_all                           @"core/home/recommend/all"
#define ServiceURL_Core_home_recommend_all                          URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_home_recommend_all)

//5.17.0 专题列表新增无序接口
#define SuffixURL_Core_home_recommend_all_New                           @"/core/home/recommend/allNew"
#define ServiceURL_Core_home_recommend_all_New                          URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_home_recommend_all_New)
#pragma mark -- 

#define SuffixURL_Core_share_content_tag                            @"core/share/tag" // 图书内分享
#define ServiceURL_Core_share_content_tag                           URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_share_content_tag)

#define SuffixURL_Core_share_content                                @"core/share/content" // 分享
#define ServiceURL_Core_share_content                               URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_share_content)

#pragma mark --

// 图书分类列表服务
#define SuffixURL_BookClassification                            @"core/classification/book/tag"
#define ServiceURL_BookClassification     URLStringCat(MXR_CORE_API_URL(),SuffixURL_BookClassification)

// 图书分类列表最后一层获取分类下所有图书的服务
#define SuffixURL_GETBOOKDATAWITHTAGID                          @"core/classification/book/info"
#define ServiceURL_GETBOOKDATAWITHTAGID                         URLStringCat(MXR_CORE_API_URL(),SuffixURL_GETBOOKDATAWITHTAGID)

#define SuffixURL_GetBookDataWithInterestTagId                  @"core/book/list/tag"
#define ServiceURL_GetBookDataWithInterestTagId                 URLStringCat(MXR_CORE_API_URL(),SuffixURL_GetBookDataWithInterestTagId)

#define SuffixURL_BookCategory                                  @"core/book/display/all"
#define ServiceURL_BookCategory                                 URLStringCat(MXR_CORE_API_URL(),SuffixURL_BookCategory)

//根据出版社id获取出版社下面图书信息 V5.14.0
#define SuffixURL_PressBookList                                  @"core/book/display/getBookInfoByPressId"
#define ServiceURLL_PressBookList                               URLStringCat(MXR_CORE_API_URL(),SuffixURL_PressBookList)

#define SuffixURL_BookCategoryInterest                          @"core/book/display"//@"core/booktag"
#define ServiceURL_BookCategoryInterest                         URLStringCat(MXR_CORE_API_URL(),SuffixURL_BookCategoryInterest)

#pragma mark 

#define SuffixURL_homePageRecommendSubjectDetailAllBookUrl(__recommendId)         [NSString stringWithFormat:@"core/home/recommend/%ld/books",__recommendId]
#define ServiceURL_homePageRecommendSubjectDetailAllBookUrl(__recommendId)        URLStringCat(MXR_CORE_API_URL(),SuffixURL_homePageRecommendSubjectDetailAllBookUrl(__recommendId))

#define SuffixURL_homePageRecommendSubjectDetailPurchaseZone @"/core/purchase/zone/save"
#define ServiceURL_homePageRecommendSubjectDetailPurchaseZone        URLStringCat(MXR_CORE_API_URL(),SuffixURL_homePageRecommendSubjectDetailPurchaseZone)   //5.9.3Version 购买专区服务

#define SuffixURL_Core_book_realtime_data(__bookGuid)                         [NSString stringWithFormat:@"core/book/realtime/data/%@",__bookGuid]
#define ServiceURL_Core_book_realtime_data(__bookGuid)                        URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_book_realtime_data(__bookGuid))


#pragma mark --

#define SuffixURL_Core_diy_book_config(__guid,__fileSize)           [NSString stringWithFormat:@"core/diy/book/config/%@/%lld",__guid,__fileSize]
#define ServiceURL_Core_diy_book_config(__guid,__fileSize)          URLStringCat(MXR_CORE_API_URL(), SuffixURL_Core_diy_book_config(__guid,__fileSize))

#define SuffixURL_Core_diy_book_list                        @"core/diy/book/list"
#define ServiceURL_Core_diy_book_list                       URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_diy_book_list)

#define SuffixURL_Core_diy_book_delete                      @"core/diy/book/delete"
#define ServiceURL_Core_diy_book_delete                     URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_diy_book_delete)

#define SuffixURL_Core_diy_book_offline                     @"core/diy/book/offline"
#define ServiceURL_Core_diy_book_offline                    URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_diy_book_offline)

#pragma mark -- 

#define SuffixURL_Core_ActiveURL                            @"core/activate/device/active"
#define ServiceURL_Core_ActiveURL                           URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_ActiveURL)

#pragma mark --
#define SuffixURL_homePageRecommendUrl                      @"core/home/recommend"
#define ServiceURL_homePageRecommendUrl                     URLStringCat(MXR_CORE_API_URL(),SuffixURL_homePageRecommendUrl)

#pragma mark --

#define SuffixURL_Core_inviteFriendUrl                      @"core/activity/invite/check"
#define ServiceURL_Core_inviteFriendUrl                     URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_inviteFriendUrl)


#define SuffixURL_Core_inviteGetList                        @"core/activity/invite/get/list"
#define ServiceURL_Core_inviteGetList                       URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_inviteGetList)

// 新书城
#define SuffixURL_BookStore_New_Home(__tempId)                  [NSString stringWithFormat:@"core/home/%@",__tempId]// 书城首页
#define ServiceURL_BookStore_New_Home(__tempId)                   URLStringCat(MXR_CORE_API_URL(),SuffixURL_BookStore_New_Home(__tempId))

#define SuffixURL_Core_MXR_BOOKSTORE_COLLECTION_ADD             @"core/user/book/collection/add" // 收藏
#define ServiceURL_Core_MXR_BOOKSTORE_COLLECTION_ADD             URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_MXR_BOOKSTORE_COLLECTION_ADD)


#define SuffixURL_Core_MXR_BOOKSTORE_COLLECTION_LIST            @"core/user/book/collection/list" // 收藏列表
#define ServiceURL_Core_MXR_BOOKSTORE_COLLECTION_LIST            URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_MXR_BOOKSTORE_COLLECTION_LIST)

#define SuffixURL_Core_MXR_BOOKSTORE_COLLECTION_DELETES         @"core/user/book/collection/cancel" // 批量删除
#define ServiceURL_Core_MXR_BOOKSTORE_COLLECTION_DELETES            URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_MXR_BOOKSTORE_COLLECTION_DELETES)


#define SuffixURL_Core_Advertisement_Link                       @"core/home/wordLink/list"  //文字链广告
#define ServiceURL_Core_Advertisement_Link      URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_Advertisement_Link)

#pragma mark -- 充值送大礼包

#define SuffixURL_Core_Bookstore_Recharge                       @"core/gift/packages/status"  //书城首页首冲大礼包
#define ServiceURL_Core_Bookstore_Recharge      URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_Bookstore_Recharge)

#define SuffixURL_Core_Bookstore_Recharge_Info                       @"core/gift/packages/info"  //首冲大礼包详情
#define ServiceURL_Core_Bookstore_Recharge_Info      URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_Bookstore_Recharge_Info)

#define SuffixURL_Core_Bookstore_Recharge_Purchases                       @"core/gift/package/purchases"  //首冲大礼包购买
#define ServiceURL_Core_Bookstore_Recharge_Purchases       URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_Bookstore_Recharge_Purchases)

#pragma mark -- 
#define SuffixURL_Core_booktag_boot_show                        @"core/booktag/boot/show"
#define ServiceURL_Core_booktag_boot_show                       URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_booktag_boot_show)

#define SuffixURL_Core_booktag_device_record                    @"core/booktag/device/record"
#define ServiceUR_Core_booktag_device_record                    URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_booktag_device_record)


#pragma mark -- 

#define  SuffixURL_Core_TreeOfKnowledge                         @"core/knowledge/question/count"
#define  ServiceUR_Core_TreeOfKnowledge                         URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_TreeOfKnowledge)

#pragma mark 检查版本
#define SuffixURL_Core_app_version_check                       @"core/app/version/check"
#define ServiceURL_Core_App_Version_Check                      URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_app_version_check)

//国际化
#pragma mark -- 邀请好友
#define  ServiceUR_SnapLearn_Invite                             @"http://www.snaptolearn.com"

#pragma mark 专区购买记录
#define SuffixURL_Zone_Purchase_History                         @"core/purchase/zone/list"
#define ServiceURL_Zone_Purchase_History                        URLStringCat(MXR_CORE_API_URL(),SuffixURL_Zone_Purchase_History)


#define SuffixURL_Core_UploadInviteFriends                       @"core/activity/invite/award/have"
#define ServiceURL_Core_UploadInviteFriends      URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_UploadInviteFriends)  //上传邀请好友获得人气

// 图书赠一得一活动信息 V5.9.3
#define SuffixURL_Core_BookPresentCampaign                      @"/core/activity/invite/get/info"
#define ServiceURL_Core_BookPresentCampaign      URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_BookPresentCampaign)

// 图书赠一得一分享信息 V5.9.3
#define SuffixURL_Core_BookPresentCampaign_Share                     @"/core/activity/invite/book/start"
#define ServiceURL_Core_BookPresentCampaign_Share      URLStringCat(MXR_CORE_API_URL(),SuffixURL_Core_BookPresentCampaign_Share)

//启动广告页   5.10.0 version
#define SuffixURL_BASE_SERVICE_LAUNCH_ADVERT                    @"/core/home/advert/loading/info"
#define ServiceURL_BASE_SERVICE_LAUNCH_ADVERT           URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_BASE_SERVICE_LAUNCH_ADVERT)

//专区搜索  5.11.0 version
#define SuffixURL_BASE_SERVICE_SEARCH_ZONE_ADVERT                @"/search/recommendZone/records"
#define ServiceURL_BASE_SERVICE_SEARCH_ZONE_ADVERT           URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_BASE_SERVICE_SEARCH_ZONE_ADVERT)

//获取首页banner下方的四个主要功能入口  5.12.0 version
#define SuffixURL_BASE_BOOKSTORE_MAIN_ENTRANCE   @"/core/homepage/navigator/list"
#define ServiceURL_BASE_BOOKSTORE_MAIN_ENTRANCE           URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_BASE_BOOKSTORE_MAIN_ENTRANCE)

// 排行榜  5.12.0
#define SuffixURL_Core_Ranking_list               @"/core/book/ranking/list"
#define ServiceURL_Core_Ranking_list                URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_Core_Ranking_list)

// VIP图书列表  5.13.0
#define SuffixURL_VIP_Book_list               @"/core/vip/book/list"
#define ServiceURL_VIP_Book_list                URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_VIP_Book_list)

// VIP专区列表  5.13.0
#define SuffixURL_VIP_Zone_list               @"/core/vip/zone/list"
#define ServiceURL_VIP_Zone_list                URLStringCat(MXR_BASE_SERVICE_API_URL(), SuffixURL_VIP_Zone_list)

// V5.16.0  添加用户隐私政策记录
#define SuffixURL_home_Privacy_Save          @"/core/home/policy/record/save"
#define ServiceURL_home_Privacy_Save                          URLStringCat(MXR_CORE_API_URL(),SuffixURL_home_Privacy_Save)

// V5.17.0 获取专区图书guid排序列表，用于专区图书通读（by : shuai.wang）
#define SuffixURL_Zone_RecommendBookList          @"/core/home/recommend/bookGuid"
#define ServiceURL_Zone_RecommendBookList         URLStringCat(MXR_CORE_API_URL(),SuffixURL_Zone_RecommendBookList)

#endif /* MXRCoreNetworkUrl_h */
