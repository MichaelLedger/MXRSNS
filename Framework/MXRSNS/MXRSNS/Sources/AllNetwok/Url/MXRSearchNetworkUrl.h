//
//  MXRSearchNetworkUrl.h
//  huashida_home
//
//  Created by 周建顺 on 2017/5/25.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRSearchNetworkUrl_h
#define MXRSearchNetworkUrl_h

#import "MXRNetworkUrl.h"

static inline NSString *MXR_SEARCH_API_URL(){
    return MXRBASE_API_URL();
   // return [MXRBASE_API_URL() stringByAppendingPathComponent:@"search"];
}
#define SuffixURL_GET_SuggestWordURL                @"search/solr/book/suggest"     /*获取推荐提示词*/
#define SuffixURL_GET_Hot_Words                     @"search/hot/words"          /*搜索热词*/
#define SuffixURL_GET_QR_DIY_BOOK_INFO              @"search/qrcode/diy/review/book/data"
#define SuffixURL_Search_HomePage                   @"search/solr/book/records"     /*新的搜索服务*/
#define SuffixURL_Search_HomePage_Review            @"search/home/bit"              /*内审版搜索*/
#define SuffixURL_Search_FeedBack                   @"/search/solr/feedback"        /*搜索反馈*/
#define SuffixURL_Search_Type_All                   @"/search/all"        /*全部搜索*/
#define SuffixURL_Search_Type_Specific              @"/search/all/detail"   /*分类搜索*/

#define ServiceURL_GET_QR_DIY_BOOK_INFO  URLStringCat(MXR_SEARCH_API_URL(),SuffixURL_GET_QR_DIY_BOOK_INFO)
#define ServiceURL_Search_HomePage URLStringCat(MXR_SEARCH_API_URL(),SuffixURL_Search_HomePage)
#define ServiceURL_Search_HomePage_Review URLStringCat(MXR_SEARCH_API_URL(),SuffixURL_Search_HomePage_Review)
#define ServiceURL_Search_HomePage_Hot_Word URLStringCat(MXRBASE_API_URL(),SuffixURL_GET_Hot_Words)
#define ServiceURL_Search_GET_SuggestWordURL URLStringCat(MXRBASE_API_URL(),SuffixURL_GET_SuggestWordURL)
#define ServiceURL_Search_FeedBack URLStringCat(MXRBASE_API_URL(),SuffixURL_Search_FeedBack)
#define ServiceURL_Search_Type_All URLStringCat(MXRBASE_API_URL(),SuffixURL_Search_Type_All)
#define ServiceURL_Search_Type_Specific URLStringCat(MXRBASE_API_URL(),SuffixURL_Search_Type_Specific)

#endif /* MXRSearchNetworkUrl_h */
