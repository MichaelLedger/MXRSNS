//
//  MXRWebNetworkUrl.h
//  huashida_home
//
//  Created by 周建顺 on 2017/5/26.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRWebNetworkUrl_h
#define MXRWebNetworkUrl_h

#import "MXRNetworkUrl.h"


//处理diy上传后，网页回调
static inline NSString *URL_FOR_HANDLE_UPLOAD_START_CALLBACK(){
    return URLStringCat(MXRBASE_HTML_WEB_URL(), @"html/GoldenKey/UploadSuccess.html");
}

static inline NSString *MXB_PAYRULE_URL(){
    
    return URLStringCat(MXRBASE_HTML_WEB_URL(), @"html/charging_standard.html");
}

//动态分享 5.2.2新的激活码静态页面也用到
static inline NSString *MXRSNSShareServiceUrl(){
    return MXRBASE_HTML_WEB_URL();
}

#define APPSTORE_UPDATE @"https://itunes.apple.com/cn/app/4d-shu-cheng-er-tong-mo-fa/id842495919?mt=8"


// 认知卡帮助视频
#define XUAN_CHUAN_HTML_URL @"https://web.mxrcorp.cn/video/xuanchuan.html"

// 分享
#define URL_BookInfoShareURL(__bookGUID,__tagID)   [NSString stringWithFormat:@"%@/share/jump.html?bookGUID=%@&tagID=%@",MXRBASE_HTML_WEB_URL(),__bookGUID,__tagID]


//我界面我的梦想币网页
#define WEBVIEW_MY_MXB(arg)   [MXRBASE_HTML_WEB_URL() stringByAppendingFormat:@"/html/user_diamonds.html?diamonds=%ld",arg]

//我充值界面账单网页
#define WEBVIEW_BILL(arg)   [MXRBASE_HTML_WEB_URL() stringByAppendingFormat:@"/html/user_Bill.html?uid=%@",arg]

// 设置-》免责声明
#define MXR_Web_Url_Declaration  [MXRBASE_HTML_WEB_URL() stringByAppendingFormat:@"/html/declaration.html"]

//回复
#define SuffixURL_Message_Commentdetail(__replyid,__user_id,__para) [NSString stringWithFormat: @"message/commentdetail.html?replyid=%@&user_id=%@&para=%@",__replyid,__user_id,__para]
#define ServiceURL_Message_Commentdetail(__replyid,__user_id,__para)  URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_Message_Commentdetail(__replyid,__user_id,__para))


//等级
#define SuffixURL_MyLevel(__userid,__deviceid) [NSString stringWithFormat:@"html/MyLevel.html?userid=%@&deviceid=%@",__userid,__deviceid]
#define ServiceURL_MyLevel(__userid,__deviceid)  URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_MyLevel(__userid,__deviceid))

//
#define SuffixURL_HTML_down_4dstore @"html/down_4dstore.html"
#define ServiceURL_HTML_down_4dstore  URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_HTML_down_4dstore)

// 用户协议
#define SuffixURL_HTML_user_agreement @"html/user_agreement.html"
#define ServiceURL_HTML_user_agreement  URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_HTML_user_agreement)

// 隐私权政策
#define ServiceURL_HTML_Privacy_Policy @"http://bsweb.mxrcorp.cn/privacy/privacy.html"

// diy协议
#define SuffixURL_HTML_user_diy_agreement @"html/user_diy_agreement.html"
#define ServiceURL_HTML_user_diy_agreement  URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_HTML_user_diy_agreement)

//赚取梦想币说明
#define ServiceURL_HTML_EarnMXBExplainWebviewURL  URLStringCat(MXRBASE_HTML_WEB_URL(), @"html/coin_explain.html")

// 排行榜
#define SuffixURL_HTML_user_rank(__user_id,__user_level) [NSString stringWithFormat:@"user/rank.html?user_id=%@&user_level=%@&device_type=ios",__user_id,__user_level]
#define ServiceURL_HTML_user_rank(__user_id,__user_level)  URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_HTML_user_rank(__user_id,__user_level))

// 分享
#define SuffixURL_HTML_shareVideoUrl(__video_name) [NSString stringWithFormat:@"html/share_video.html?video_name=%@",__video_name]
#define ServiceURL_HTML_shareVideoUrl(__video_name) URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_HTML_shareVideoUrl(__video_name))

// 支付FAQ
#define ServiceURL_URL_PAY_FAQ  URLStringCat(MXRBASE_HTML_WEB_URL(),@"faq/rechargeother.html")

// 邀请好友pk
#define SuffixURL_HTML_Share_Question(__qaId) [NSString stringWithFormat:@"share/question.html?qaId=%@",__qaId]
#define ServiceURL_HTML_Share_Question(__qaId) URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_HTML_Share_Question(__qaId))

//红包活动
#define SuffixURL_HTML_Activity_RedPacket @"hongbao/index.html"
#define ServiceURL_HTML_Activity_RedPacket URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_HTML_Activity_RedPacket)

//DIY图书审核规范
#define DIY_BOOK_AUDIT_RULER @"http://bsweb.mxrcorp.cn/html/diy/standards.html"

#define SNAPLEARN_OFFICIAL_WEBSITE @"https://www.snaptolearn.com"

// 扭蛋
#define SuffixURL_CapsuleToys_WEB_URL @"/vue/#/swing-egg"
#define ServiceURL_CapsuleToys_WEB_URL URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_CapsuleToys_WEB_URL)

#define SuffixURL_SignIn_WEB_URL @"/vue/#/sign"
#define ServiceURL_SignIn_WEB_URL URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_SignIn_WEB_URL)  //5.9.1 version 签到功能

#define SuffixURL_FaceToFace_InviteFriends @"/vue/#/invitation/pop"
#define ServiceURL_FaceToFace_InviteFriends URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_FaceToFace_InviteFriends)    //邀请好友获得人气   5.9.4 Version

// 优惠券使用说明 V5.11.0
#define SuffixURL_HTML_Coupon_Ruler @"/vue/#/coupons/center/instructions?backType=mobile"
#define ServiceURL_HTML_Coupon_Ruler URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_HTML_Coupon_Ruler)

// 领券中心 V5.11.0
#define SuffixURL_HTML_Coupon_Centre @"/vue/#/coupons/center"
#define ServiceURL_HTML_Coupon_Centre URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_HTML_Coupon_Centre)

// VIP购买协议
#define ServiceURL_HTML_VIP_Member @"https://bsweb.mxrcorp.cn/others/vip-protocol.html"

#ifdef MXRSNAPLEARN
#define ServiceURL_QR_Help_Center @"https://www.snaptolearn.com/faq"
#else
// 扫码帮助
#define ServiceURL_QR_Help_Center @"https://bsweb.mxrcorp.cn/others/scan-help.html"
#endif


// 测验问答(测验ID)
#define ServiceURL_HTML_UNIT_EXAM(arg) [MXRBASE_HTML_WEB_URL() stringByAppendingFormat:@"/vue/#/qa/index?eid=%ld",arg]

// AR课堂相关
// 学习成绩
#define ServiceURL_HTML_UNIT_STUDYRESULT(courseID) [MXRBASE_HTML_WEB_URL() stringByAppendingFormat:@"/vue/#/reports/score?cid=%ld", (long)courseID]
// 学习报告
// need to do
#define ServiceURL_HTML_UNIT_STUDYREPORT(courseID) [MXRBASE_HTML_WEB_URL() stringByAppendingFormat:@"/vue/#/reports/study?eid=%ld", (long)courseID]

// 学习分享
// need to do
//#define ServiceURL_HTML_UNIT_STUDYSHARE(courseID) [MXRBASE_HTML_WEB_URL() stringByAppendingFormat:@"/vue/#/reports/share?eid=%ld", (long)courseID]
//#define ServiceURL_HTML_UNIT_STUDYSHARE(courseID) [@"http://192.168.0.145:10123" stringByAppendingFormat:@"/reports/share?eid=%ld", (long)courseID]
#define ServiceURL_HTML_UNIT_STUDYSHARE(courseID) [MXRBASE_HTMLSPECAIL_WEB_URL() stringByAppendingFormat:@"/reports/share?eid=%ld", (long)courseID]

// 个人挑战赛(Egret)
#define SuffixURL_HTML_Egret_Challenge @"/egret/wenda/index.html"
#define ServiceURL_HTML_Egret_Challenge URLStringCat(MXRBASE_HTML_WEB_URL(), SuffixURL_HTML_Egret_Challenge)

#endif /* MXRWebNetworkUrl_h */
