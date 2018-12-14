//
//  MXRCommunityNetworkUrl.h
//  huashida_home
//
//  Created by yuchen.li on 2017/5/25.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRCommunityNetworkUrl_h
#define MXRCommunityNetworkUrl_h

#import "MXRNetworkUrl.h"

//动态，话题相关
static inline NSString *MXRSNSServiceUrl(){

    return MXRBASE_API_URL();

}


/**
 * dynamics
 */
#define SuffixURL_BookSNS_BannerIconUrl @"community/banner/list"
#define ServiceURL_BookSNS_BannerIconUrl URLStringCat(MXRSNSServiceUrl(), SuffixURL_BookSNS_BannerIconUrl)

// 获取运营调整过的动态排序或话题下的动态排序
#define SuffixURL_BookSNS_RecommentDynamic @"community/dynamics/priority/sort"
#define ServiceURL_BookSNS_RecommentDynamic URLStringCat(MXRSNSServiceUrl(), SuffixURL_BookSNS_RecommentDynamic)

 #define SuffixURL_BASE_TOPICS_DETAIL @"community/topics"//获取某个话题的动态列表
#define ServiceURL_BASE_TOPICS_DETAIL URLStringCat(MXRSNSServiceUrl(), SuffixURL_BASE_TOPICS_DETAIL)

// 获取梦想圈动态详情列表
#define SuffixURL_Community_Dynamics @"community/dynamics"
#define ServiceURL_Community_Dynamics URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Dynamics)

// 获取动态点赞用户列表
#define SuffixURL_Book_SNS_Praise_List(__str) [NSString stringWithFormat:@"community/dynamics/%@/praises",__str]
#define ServiceURL_Book_SNS_Praise_List(__str) URLStringCat(MXRSNSServiceUrl(), SuffixURL_Book_SNS_Praise_List(__str))

// 梦想圈动态详情评论列表数据
#define SuffixURL_Book_SNS_Detail_Data(__str) [NSString stringWithFormat:@"community/dynamics/%@/comments",__str]
#define ServiceURL_Book_SNS_Detail_Data(__str) URLStringCat(MXRSNSServiceUrl(),SuffixURL_Book_SNS_Detail_Data(__str))

#define Delete_Moment_MomentId(__interger) [NSString stringWithFormat:@"%@/%ld/unsubscribe",ServiceURL_Community_Dynamics,__interger]
#define User_Cancle_Like_MomentId(__interger) [NSString stringWithFormat:@"%@/%ld/unlike",ServiceURL_Community_Dynamics,__interger]

#define SuffixURL_Community_Dynamics_Previous @"community/dynamics/previous"
#define ServiceURL_Community_Dynamics_Previous URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Dynamics_Previous)

#define SuffixURL_Community_Dynamics_Previous_Count  @"community/dynamics/previous/count"
#define ServiceURL_Community_Dynamics_Previous_Count URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Dynamics_Previous_Count)

#define SuffixURL_Community_Dynamics_Next @"community/dynamics/next"
#define ServiceURL_Community_Dynamics_Next URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Dynamics_Next)
/**
 * user
 */

#define SuffixURL_Community_Dynamics_User_Cancel @"community/dynamics/user/cancel"
#define ServiceURL_Community_Dynamics_User_Cancel URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Dynamics_User_Cancel)

#define SuffixURL_Community_Dynamics_User_Like @"community/dynamics/user/like"
#define ServiceURL_Community_Dynamics_User_Like  URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Dynamics_User_Like)

#define SuffixURl_Community_Dynamics_User_Report @"community/dynamics/user/report"
#define ServiceURL_Community_Dynamics_User_Report URLStringCat(MXRSNSServiceUrl(), SuffixURl_Community_Dynamics_User_Report)

#define SuffixURL_Community_Dynamics_User_Forward @"community/dynamics/user/forward"
#define ServiceURL_Community_Dynamics_User_Forward URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Dynamics_User_Forward)



/**
 * my
 */
#define SuffixURL_Community_Dynamics_My @"community/dynamics/my"

#define ServiceURL_Community_Dynamics_My URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Dynamics_My)

#define SuffixURL_Community_Dynamics_My_Previous @"community/dynamics/my/previous"
#define ServiceURL_Community_Dynamics_My_Previous URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Dynamics_My_Previous)

#define SuffixURL_Community_Dynamics_My_Pevious_Count @"community/dynamics/my/previous/count"
#define ServiceURL_Community_Dynamics_My_Pevious_Count URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Dynamics_My_Pevious_Count)

#define SuffixURL_Community_Dynamics_My_next @"community/dynamics/my/next"
#define ServiceURL_Community_Dynamics_My_next URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Dynamics_My_next)
/**
 * topics
 */
#define SuffixURL_Community_Topics_Recommend @"community/topics/recommend"
#define ServiceURL_Community_Topics_Recommend URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Topics_Recommend)

#define SuffixURL_Community_Topics_Fuzzy_Query @"community/topics/fuzzy/query"
#define ServiceURL_Community_Topics_Fuzzy_Query URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Topics_Fuzzy_Query)

#define SuffixURL_Community_Topics_Hot  @"community/topics/hot"
#define ServiceURL_Community_Topics_Hot URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Topics_Hot)

#define SuffixURL_Community_Topics_Collect_Share @"community/topics/collect/share"
#define ServiceURL_Community_Topics_Collect_Share URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Topics_Collect_Share)



/**
 * comments
 */
#define SuffixURL_Community_Comments_Create @"community/comments/create"
#define ServiceURL_Community_Comments_Create URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Comments_Create)

#define  SuffixURL_Community_Comments_Relpy @"community/comments/relpy"
#define  ServiceURL_Community_Comments_Relpy URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Comments_Relpy)

#define SuffixURL_Community_Comments_Like  @"community/comments/like"
#define ServiceURL_Community_Comments_Like URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Comments_Like)

#define SuffixURL_Community_Comments_Cancel @"community/comments/cancel"
#define ServiceURL_Community_Comments_Cancel URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Comments_Cancel)

#define SuffixURL_Community_Comments_Report @"community/comments/report"

#define ServiceURL_Community_Comments_Report URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Comments_Report)

#define SuffixURL_Community_Delete_Comment(__interger) [NSString stringWithFormat:@"community/comments/%ld/delete",__interger]
#define ServiceURL_Community_Delete_Comment(__interger) URLStringCat(MXRSNSServiceUrl(),SuffixURL_Community_Delete_Comment(__interger) )

/**
 * books
 */

#define SuffixURL_Community_Books_Stars @"community/books/stars"
#define ServiceURL_Community_Books_Stars URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Books_Stars)
/**
 *  qiniu
 */
#define SuffixURL_Community_Dynamics_Qiniu_Uploadtoken @"community/dynamics/qiniu/uploadtoken"
#define ServiceURL_Community_Dynamics_Qiniu_Uploadtoken URLStringCat(MXRSNSServiceUrl(), SuffixURL_Community_Dynamics_Qiniu_Uploadtoken)



#endif /* MXRCommunityNetworkUrl_h */
