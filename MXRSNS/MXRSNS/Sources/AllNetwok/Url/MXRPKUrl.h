//
//  MXRPKUrl.h
//  huashida_home
//
//  Created by Martin.Liu on 2018/1/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRPKUrl_h
#define MXRPKUrl_h

#import "MXRNetworkUrl.h"

static inline NSString *MXR_PK_API_URL(){
    return MXRBASE_API_URL();
}

#define SuffixURL_PK_GetQAListWithId        @"qa"          // 根据问答ID获取问答详情
#define ServiceURL_PK_GetQAListWithId       URLStringCat(MXR_PK_API_URL(), SuffixURL_PK_GetQAListWithId)           // 根据问答ID获取问答详情

#define SuffixURL_PK_SubmitPkAnswers        @"qa/pk/submit/data"   // 提交 PK 问答数据

#define ServiceURL_PK_GetQAListWithId       URLStringCat(MXR_PK_API_URL(), SuffixURL_PK_GetQAListWithId)           // 根据问答ID获取问答详情
#define ServiceURL_PK_SubmitPkAnswers       URLStringCat(MXR_PK_API_URL(), SuffixURL_PK_SubmitPkAnswers)    // 提交 PK 问答数据

#define SuffixURL_PK_Search                 @"/qa/pk/random/data"  //pk搜索对战用户
#define ServiceURL_PK_Search                URLStringCat(MXR_PK_API_URL(), SuffixURL_PK_Search)

#define SuffixURL_PK_MedalList              @"/qa/medal/list"    //获取用户的勋章列表
#define ServiceURL_PK_MedalList             URLStringCat(MXR_PK_API_URL(), SuffixURL_PK_MedalList)

#define SufixURL_PK_QA_CLASSIFYS            @"/qa/classifys" // 获取pk首页分类
#define ServiceURL_PK_QA_CLASSIFYS          URLStringCat(MXR_PK_API_URL(), SufixURL_PK_QA_CLASSIFYS) // 获取pk首页分类

#define SufixURL_PK_RANKING_INFO            @"/qa/home/user/pk/ranking/info" // pk首页用户信息
#define ServiceURL_PK_RANKING_INFO          URLStringCat(MXR_PK_API_URL(), SufixURL_PK_RANKING_INFO) // // pk首页用户信息

#define SufixURL_PK_Question_List           @"/qa/list"// PK问答列表
#define ServiceURL_PK_Question_List         URLStringCat(MXR_PK_API_URL(), SufixURL_PK_Question_List)

#define SufixURL_PK_Purchase_Analysis          @"/qa/pk/analysis/mxb/deduct"// 购买错题解析
#define ServiceURL_PK_Purchase_Analysis         URLStringCat(MXR_PK_API_URL(), SufixURL_PK_Purchase_Analysis)

#define SufixURL_PK_Challenge_Info          @"/qa/challenge/index"// 个人挑战赛-用户首页信息（by weichao.song）
#define ServiceURL_PK_Challenge_Info         URLStringCat(MXR_PK_API_URL(), SufixURL_PK_Challenge_Info)

#define SufixURL_PK_Challenge_Props          @"/qa/challenge/props"// 个人挑战赛-分页获取道具列表（by dong.chen）
#define ServiceURL_PK_Challenge_Props         URLStringCat(MXR_PK_API_URL(), SufixURL_PK_Challenge_Props)

#define SufixURL_PK_Challenge_Props_Buy          @"/qa/challenge/props/buy"// 个人挑战赛-保存用户购买道具记录（by dong.chen）
#define ServiceURL_PK_Challenge_Props_Buy         URLStringCat(MXR_PK_API_URL(), SufixURL_PK_Challenge_Props_Buy)

#define SufixURL_PK_Challenge_Share          @"/qa/challenge/share"// 保存分享信息（by dong.chen）
#define ServiceURL_PK_Challenge_Share         URLStringCat(MXR_PK_API_URL(), SufixURL_PK_Challenge_Share)

#define SufixURL_PK_Rankings          @"/qa/challenge/rankings"// 个人挑战赛-用户排名
#define ServiceURL_PK_Rankings          URLStringCat(MXR_PK_API_URL(), SufixURL_PK_Rankings)

#endif /* MXRPKUrl_h */
