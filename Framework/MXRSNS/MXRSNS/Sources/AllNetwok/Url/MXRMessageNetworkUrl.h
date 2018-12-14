//
//  MXRMessageUrl.h
//  huashida_home
//
//  Created by 周建顺 on 2017/5/25.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRMessageNetworkUrl_h
#define MXRMessageNetworkUrl_h

#import "MXRNetworkUrl.h"

static inline NSString *URL_FOR_MESSAGE_SERVER(){
    return MXRBASE_API_URL();
}

#define SuffixURL_MESSAGE_USER_GetUserMsgCommentList @"message/commentList"//before V5.8.9:message/msglistNew
#define ServiceURL_MESSAGE_USER_GetUserMsgCommentList  URLStringCat(URL_FOR_MESSAGE_SERVER(),SuffixURL_MESSAGE_USER_GetUserMsgCommentList)

#define SuffixURL_Message_Get_UnReadCount @"message/getUnreadTag"
#define ServiceURL_Message_Get_UnReadCount  URLStringCat(URL_FOR_MESSAGE_SERVER(),SuffixURL_Message_Get_UnReadCount)

#define SuffixURL_Message_Get_Count @"message/getUnreadCount"       // 获取未读消息数量
#define ServiceURL_Message_Get_Count  URLStringCat(URL_FOR_MESSAGE_SERVER(),SuffixURL_Message_Get_Count)

#define SuffixURL_UnreadMsg_Count @"message/getUnreadCountNew"
#define ServiceURL_UnreadMsg_Count URLStringCat(URL_FOR_MESSAGE_SERVER(),SuffixURL_UnreadMsg_Count)

#define SuffixURL_Message_ReadStatus_Done @"message/readStatus/done"
#define ServiceURL_Message_ReadStatus_Done URLStringCat(URL_FOR_MESSAGE_SERVER(),SuffixURL_Message_ReadStatus_Done)

#define SuffixURL_GetUserMsgZanList                       @"message/praise/listNew"//before V5.8.9:message/praise/list
#define ServiceURL_USER_GetUserMsgZanList                   URLStringCat(URL_FOR_MESSAGE_SERVER(),SuffixURL_GetUserMsgZanList)

#define SuffixURL_Message_Notice_List @"message/notice/list"
#define  ServiceURL_Message_Notice_List URLStringCat(URL_FOR_MESSAGE_SERVER(),SuffixURL_Message_Notice_List)


#define SuffixURL_message_private_send      @"message/private/send"
#define ServiceURL_comment_message_private_send  URLStringCat(URL_FOR_MESSAGE_SERVER(),SuffixURL_message_private_send)



#pragma mark --

#define SuffixURL_BookDetail_GetComments            @"message/cuscomment/getcomment"                // 获得所有图书评论
#define SuffixURL_BookDetail_GetCommentDetail       @"message/cuscomment/getcommentreply"           // 评论详情
#define SuffixURL_BookDetail_PraiseComment          @"message/cuscomment/addcommentpraise"          // 图书详情评论点赞
#define SuffixURL_BookDetail_CancelPraiseComment    @"message/cuscomment/cancelcommentpraise"       // 取消赞
#define SuffixURL_BookDetail_AddBookComment         @"message/cuscomment/addcomment"                // 增加图书评论
#define SuffixURL_BookDetail_ReplyBookComment       @"message/cuscomment/addcommentreply"           // 对书的评论进行回复
#define SuffixURL_BookDetail_DeleteComment          @"message/delcomment"                   // 删除评论
#define SuffixURL_BookDetail_DeleteReplyComment     @"message/delreply"                     // 删除评论回复
#define SuffixURL_BookDetail_GetZoneList            @"core/book/zone"    // 获取图书所属专区列表

#define ServiceURL_BookDetail_GetComments           URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_GetComments) // 更换地址 URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_GetComments)       // 获得所有图书评论
#define ServiceURL_BookDetail_GetCommentDetail      URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_GetCommentDetail) // 更换地址 URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_GetCommentDetail)  // 评论详情
#define ServiceURL_BookDetail_PraiseComment         URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_PraiseComment)     // 图书详情评论点赞
#define ServiceURL_BookDetail_CancelPraiseComment   URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_CancelPraiseComment)   // 取消赞
#define ServiceURL_BookDetail_AddBookComment        URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_AddBookComment)        // 增加图书评论
#define ServiceURL_BookDetail_ReplyBookComment      URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_ReplyBookComment) //更换地址 URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_ReplyBookComment)  // 对书的评论进行回复
#define ServiceURL_BookDetail_DeleteComment         URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_DeleteComment)     // 删除评论
#define ServiceURL_BookDetail_DeleteReplyComment    URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_DeleteReplyComment)    // 删除评论回复
#define ServiceURL_BookDetail_GetZoneList    URLStringCat(URL_FOR_MESSAGE_SERVER(), SuffixURL_BookDetail_GetZoneList)    // 获取图书所属专区列表

#pragma mark --

//私信

#define Message_DeletChatData                       @"message/private/content/delete?id="       // 5.8.0 modify by martin --- 秋阳让改的
#define Message_SendChatContent                     @"message/private/reply"        //发送私信

#define Send_Message_HostAndMethod                  URLStringCat(URL_FOR_MESSAGE_SERVER(),Message_SendChatContent)
#define Get_Chat_Page_Content_HostAndMethod         URLStringCat(URL_FOR_MESSAGE_SERVER(),Message_ChatContent)
#define Delete_Chat_Message_HostAndMethod           URLStringCat(URL_FOR_MESSAGE_SERVER(),Message_DeletChatData)






#pragma mark --

#define MyComment_GetMyCommentList                  @"message/mymsglist"                             //我的评论 获取评论列表

#define GetMyCommentList_HostAndMethod              URLStringCat(URL_FOR_MESSAGE_SERVER(),MyComment_GetMyCommentList)


#pragma mark ---

#define Message_GetCommentContent                       @"message/msglist"            //获取评论列表
#define Message_GetCommentContent_NEW                   @"message/msglist2"
#define Message_CommentList_SendComment                 @"message/comment/addcommentreply" //回复评论
#define Message_Comment_Report                          @"message/report"                   //举报评论
#define Letter_DeleteLetter_Method                      @"message/private/delete"    //删除私信列表的某个私信数据

#define Message_Noti_Delete_Comment                     @"message/notice/reply/delete" //通知消息详情删除评论
#define Message_Noti_Delete_CommentReply                @"message/notice/delreply" //删除通知评论的回复
#define Message_ChatContent                             @"message/private/contentNewV2"          //获取私信具体的数据  //before V5.8.9:message/private/contentNew
#define Message_GetMessage_Zan_Comment_Count            @"message/notice/info"  //获取通知中，点赞和评论的数目
#define Message_Noti_Add_CommentReply                   @"message/notice/reply" //新增通知评论的回复
#define Letter_GetLetterList_Method                     @"message/private/list"     //获取私信列表
#define Letter_Comment_Addnoticereply                   @"message/comment/addnoticereply"

#define Message_Reply                                   @"message/reply"    //回复网页
#define Message_DeleteNoticeByMsgId                     @"message/notice"   // 删除用户的通知信息
#define Message_GetNererGuide                       @"message/private/content/default"  // 获取新手引导

#define Comment_Get_CommentList_HostAndMethod               URLStringCat(URL_FOR_MESSAGE_SERVER(),Message_GetCommentContent)
#define Comment_Get_CommentList_HostAndMethod_New           URLStringCat(URL_FOR_MESSAGE_SERVER(),Message_GetCommentContent_NEW)
#define Comment_Send_Comment_HostAndMethod                  URLStringCat(URL_FOR_MESSAGE_SERVER(),Message_CommentList_SendComment)
#define Comment_Report_Action                               URLStringCat(URL_FOR_MESSAGE_SERVER(),Message_Comment_Report)
#define Letter_DelegetLetter                                URLStringCat(URL_FOR_MESSAGE_SERVER(),Letter_DeleteLetter_Method)


#define Message_Noti_DeleteComment_HostAndMethod            URLStringCat(URL_FOR_MESSAGE_SERVER(),Message_Noti_Delete_Comment)
#define Message_Noti_DeleteCommentReply_HostAndMethod       URLStringCat(URL_FOR_MESSAGE_SERVER(),Message_Noti_Delete_CommentReply)
#define Message_Noti_AddCommentReply_HostAndMethod          URLStringCat(URL_FOR_MESSAGE_SERVER(),Message_Noti_Add_CommentReply)
#define Get_Chat_Content_HostAndMethod(__str)               [NSString stringWithFormat:@"%@/%@?message_list_id=%@",URL_FOR_MESSAGE_SERVER(),Message_ChatContent,__str]
#define  ServiceURL_Message_GetMessage_Zan_Comment_Count    URLStringCat(URL_FOR_MESSAGE_SERVER(),Message_GetMessage_Zan_Comment_Count)
#define ServiceURL_Letter_GetLetterList_Method              URLStringCat(URL_FOR_MESSAGE_SERVER(),Letter_GetLetterList_Method)
#define ServiceURL_Letter_Comment_Addnoticereply            URLStringCat(URL_FOR_MESSAGE_SERVER(),Letter_Comment_Addnoticereply)

#define ServiceURL_Message_Reply                            URLStringCat(URL_FOR_MESSAGE_SERVER(),Message_Reply)
#define ServiceURL_Message_DeleteNoticeByMsgId              URLStringCat(URL_FOR_MESSAGE_SERVER(),Message_DeleteNoticeByMsgId)
#define ServiceURL_Message_GetNewerGuide                    URLStringCat(URL_FOR_MESSAGE_SERVER(),Message_GetNererGuide)


#endif /* MXRMessageUrl_h */
