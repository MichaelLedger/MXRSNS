//
//  MXRDataCollectionNetworkUrl.h
//  huashida_home
//
//  Created by 周建顺 on 2017/5/25.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRDataCollectionNetworkUrl_h
#define MXRDataCollectionNetworkUrl_h

#import "MXRNetworkUrl.h"

//GXD 6.4 ++ 2015 记录下载数据
//Martin.liu 5.0 记录下载图书记录   /download/book/logs/add 接口找张来涛
////我的消息中 点赞方面的服务（点赞 取消 查看点赞）
// 通过扫码下载图书完成后记录下载次数
static inline NSString *MXR_DataCollection_API_URL(){
    return MXRBASE_API_URL();
}

#define SuffixURL_DataCollection_Collection_Save                @"datacollection/collection/save"
#define ServiceURL_DataCollection_Collection_Save                URLStringCat(MXR_DataCollection_API_URL(),SuffixURL_DataCollection_Collection_Save)


#define SuffixURL_DATA_BINNER_CLICK                 @"datacollection/banner/clickdata" // 记录banner的点击次数API
#define ServiceURL_DATA_BINNER_CLICK                URLStringCat(MXR_DataCollection_API_URL(),SuffixURL_DATA_BINNER_CLICK)

#define SuffixURL_DATA_SHARE_COUNT                  @"datacollection/book/sharecount" // 记录每本书的分享次数API
#define ServiceURL_DATA_SHARE_COUNT                 URLStringCat(MXR_DataCollection_API_URL(),SuffixURL_DATA_SHARE_COUNT)

#define SuffixURL_DATA_READING_DURATION             @"datacollection/book/readingduration" // 阅读时长
#define ServiceURL_DATA_READING_DURATION            URLStringCat(MXR_DataCollection_API_URL(),SuffixURL_DATA_READING_DURATION)


#define SuffixURL_DATA_ADD_ERROR_BOOK_PAGE          @"datacollection/error_book_page/add" // 报错
#define ServiceURL_DATA_ADD_ERROR_BOOK_PAGE         URLStringCat(MXR_DataCollection_API_URL(),SuffixURL_DATA_ADD_ERROR_BOOK_PAGE)

#define SuffixURL_DATA_GET_REPORT_LIST              @"datacollection/report/text/list" // 获取举报具体类型
#define ServiceURL_DATA_GET_REPORT_LIST             URLStringCat(MXR_DataCollection_API_URL(),SuffixURL_DATA_GET_REPORT_LIST)

#define SuffixURL_DATA_REPORT_BOOK                  @"datacollection/report/book" // 举报（Diy图书）
#define ServiceURL_DATA_REPORT_BOOK                 URLStringCat(MXR_DataCollection_API_URL(),SuffixURL_DATA_REPORT_BOOK)

// 移到文件MXRBookDetailNetworkUrl中了
//#define SuffixURL_BookDetail_PraiseBook             @"datacollection/book/praise"                          // 用户对图书点赞
//#define SuffixURL_BookDetail_CancelPraiseBook       @"datacollection/book/praise/cancel"                   // 用户对图书取消点赞
//#define SuffixURL_BookDetail_AppraiseBook           @"datacollection/api/praise/presspraise"               // 对图书进行评价 星星评价
//#define SuffixURL_BookDetail_CheckIsAppraiseBook    @"datacollection/api/praise/checkreadypraise"          // 获取图书是否已经评价过
//
//#define ServiceURL_BookDetail_PraiseBook            URLStringCat(MXR_DataCollection_API_URL(), SuffixURL_BookDetail_PraiseBook)        // 用户对图书点赞
//#define ServiceURL_BookDetail_CancelPraiseBook      URLStringCat(MXR_DataCollection_API_URL(), SuffixURL_BookDetail_CancelPraiseBook)  // 用户对图书取消点赞
//#define ServiceURL_BookDetail_AppraiseBook          URLStringCat(MXR_DataCollection_API_URL(), SuffixURL_BookDetail_AppraiseBook)      // 对图书进行评价 星星评价
//#define ServiceURL_BookDetail_CheckIsAppraiseBook   URLStringCat(MXR_DataCollection_API_URL(), SuffixURL_BookDetail_CheckIsAppraiseBook)   // 获取图书是否已经评价过
  

//通过扫码下载完成后 将下载数据给服务器做记录
#define SuffixURL_Record_BookInfo                   @"datacollection/download/book/logs/add/downloaded"
#define ServiceURL_Upload_BookInfo_For_Record       URLStringCat(MXR_DataCollection_API_URL(),SuffixURL_Record_BookInfo)

#define SuffixURL_CollectDataURL                    @"datacollection/collection/behaviors"
#define ServiceURL_CollectDataURL                   URLStringCat(MXR_DataCollection_API_URL(),SuffixURL_CollectDataURL)

#define SuffixURL_DATA_DOWNLOAD_BOOK_LOGS           @"datacollection/download/book/logs/add" // 下载前的图书信息收集
#define ServiceURL_DATA_DOWNLOAD_BOOK_LOGS          URLStringCat(MXR_DataCollection_API_URL(),SuffixURL_DATA_DOWNLOAD_BOOK_LOGS)


#define SuffixURL_DataCollection_Share              @"datacollection/share"
#define ServiceURL_DataCollection_Share             URLStringCat(MXR_DataCollection_API_URL(),SuffixURL_DataCollection_Share)

// 移到文件MXRBookDetailNetworkUrl中了
//#define SuffixURL_Message_Noti_zan @"datacollection/notice/message/praise"                  //用户评论点赞
//#define SuffixURL_Message_Noti_CancelZan @"datacollection/notice/message/praise/cancel"     //用户评论取消点赞
//#define SuffixURL_Message_Noti_ZanState @"datacollection/notice/message/praise/check"       //获取点赞状态
//
//#define ServiceURL_Message_Zan_Action           URLStringCat(MXR_DataCollection_API_URL(),SuffixURL_Message_Noti_zan)
//#define ServiceURL_Message_UnZan_Action         URLStringCat(MXR_DataCollection_API_URL(),SuffixURL_Message_Noti_CancelZan)
//#define ServiceURL_Message_Noti_ZanState        URLStringCat(MXR_DataCollection_API_URL(),SuffixURL_Message_Noti_ZanState)


#endif /* MXRDataCollectionNetworkUrl_h */
