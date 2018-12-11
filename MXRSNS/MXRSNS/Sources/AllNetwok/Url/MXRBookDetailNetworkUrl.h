//
//  MXRBookDetailNetworkUrl.h
//  huashida_home
//
//  Created by Martin.liu on 2017/9/4.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRBookDetailNetworkUrl_h
#define MXRBookDetailNetworkUrl_h

#import "MXRNetworkUrl.h"

static inline NSString *MXR_BOOKDETAIL_API_URL(){
    return MXRBASE_API_URL();
}

#define SuffixURL_BookDetail_PraiseBook             @"datacollection/book/praise"                          // 用户对图书点赞
#define SuffixURL_BookDetail_CancelPraiseBook       @"datacollection/book/praise/cancel"                   // 用户对图书取消点赞
#define SuffixURL_BookDetail_AppraiseBook           @"datacollection/api/praise/presspraise"               // 对图书进行评价 星星评价
#define SuffixURL_BookDetail_CheckIsAppraiseBook    @"datacollection/api/praise/checkreadypraise"          // 获取图书是否已经评价过
#define SuffixURL_RecommendBook                     @"core/recommend-last-page-book/list"                  //获取该本图书下的图书推荐列表
#define ServiceURL_BookDetail_PraiseBook            URLStringCat(MXR_BOOKDETAIL_API_URL(), SuffixURL_BookDetail_PraiseBook)        // 用户对图书点赞
#define ServiceURL_BookDetail_CancelPraiseBook      URLStringCat(MXR_BOOKDETAIL_API_URL(), SuffixURL_BookDetail_CancelPraiseBook)  // 用户对图书取消点赞
#define ServiceURL_BookDetail_AppraiseBook          URLStringCat(MXR_BOOKDETAIL_API_URL(), SuffixURL_BookDetail_AppraiseBook)      // 对图书进行评价 星星评价
#define ServiceURL_BookDetail_CheckIsAppraiseBook   URLStringCat(MXR_BOOKDETAIL_API_URL(), SuffixURL_BookDetail_CheckIsAppraiseBook)   // 获取图书是否已经评价过
#define ServiceURL_RecommendBook                    URLStringCat(MXR_BOOKDETAIL_API_URL(), SuffixURL_RecommendBook)   // 获取图书是否已经评价过


#define SuffixURL_Message_Noti_zan                  @"datacollection/notice/message/praise"                  //用户评论点赞
#define SuffixURL_Message_Noti_CancelZan            @"datacollection/notice/message/praise/cancel"     //用户评论取消点赞
#define SuffixURL_Message_Noti_ZanState             @"datacollection/notice/message/praise/check"       //获取点赞状态

#define ServiceURL_Message_Zan_Action               URLStringCat(MXR_BOOKDETAIL_API_URL(),SuffixURL_Message_Noti_zan)
#define ServiceURL_Message_UnZan_Action             URLStringCat(MXR_BOOKDETAIL_API_URL(),SuffixURL_Message_Noti_CancelZan)
#define ServiceURL_Message_Noti_ZanState            URLStringCat(MXR_BOOKDETAIL_API_URL(),SuffixURL_Message_Noti_ZanState)


// 5.5.0
#define SuffixURL_BookDetail_ExtensionInfo          @"core/book/extension"          // 图书相关信息,包括标签列表、推荐图书列表、点赞的星星、图书话题信息等。 by meiqiuyang
#define SuffixURL_BookDetail_BooksWithTag           @"core/book/list/tag"         // 根据图书标签获取图书列表 by meiqiuyang
#define SuffixURL_BookDetail_BookCommentList        @"message/book/comment"    // 获取图书评论列表 message/book/comment/{bookGuid}/list
// 5.6.0
#define SuffixURL_BookDetail_GetBookQuestion        @"/core/qa"                 // 根据问答ID获取问答内容
#define SuffixURL_BookDetail_CommitAnswerAndGetRank @"/core/qa"                 // 提交答案并获取排行榜接口（包括当前用户排行）和推荐图书和超越人数/core/qa{qaId}/list

#define ServiceURL_BookDetail_ExtensionInfo         URLStringCat(MXR_BOOKDETAIL_API_URL(),SuffixURL_BookDetail_ExtensionInfo)   // 获取图书相关信息
#define ServiceURL_BookDetail_BooksWithTag          URLStringCat(MXR_BOOKDETAIL_API_URL(),SuffixURL_BookDetail_BooksWithTag)    // 根据图书标签获取图书列表
#define ServiceURL_BookDetail_BookCommentList       URLStringCat(MXR_BOOKDETAIL_API_URL(),SuffixURL_BookDetail_BookCommentList)    // 根据图书标签获取图书列表
#define ServiceURL_BookDetail_GetBookQuestion       URLStringCat(MXR_BOOKDETAIL_API_URL(),SuffixURL_BookDetail_GetBookQuestion)    // 根据问答ID获取问答内容
#define ServiceURL_BookDetail_CommitAnswerAndGetRank    URLStringCat(MXR_BOOKDETAIL_API_URL(),SuffixURL_BookDetail_CommitAnswerAndGetRank)    // 提交答案并获取排行榜接口（包括当前用户排行）和推荐图书和超越人数/core/qa{qaId}/list
#endif /* MXRBookDetailNetworkUrl_h */
