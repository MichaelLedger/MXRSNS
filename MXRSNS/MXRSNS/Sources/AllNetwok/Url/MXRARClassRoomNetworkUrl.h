//
//  MXRARClassRoomNetworkUrl.h
//  huashida_home
//
//  Created by MinJing_Lin on 2018/9/27.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRARClassRoomNetworkUrl_h
#define MXRARClassRoomNetworkUrl_h

#import "MXRNetworkUrl.h"


//5.15.0 AR课堂相关接口
static inline NSString *MXR_ARClassRoom_API_URL(){
    return MXRBASE_API_URL();
}

#define SuffixURL_ARClassRoom_Course_Unit       @"/course/units"
#define ServiceURL_ARClassRoom_Course_Unit URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_Course_Unit)       // 课程详情中，单元列表

#define SuffixURL_ARClassRoom_Course_Purchase @"/course/purchases"
#define ServiceURL_ARClassRoom_Course_Purchase URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_Course_Purchase)         // AR课程购买

// add by liulong
#define SuffixURL_ARClassRoom_GetAllCourses     @"/courses"             // 获取所有课程列表/推荐课程列表（by yuanyuan.wu）
#define SuffixURL_ARClassRoom_GetUserCourses    @"/course/userCourses"  // 获取用户课程列表（by yuanyuan.wu）
#define SuffixURL_ARClassRoom_GetBanners        @"/course/banners"      // 获取AR课程banner列表 （by shuai.wang）
#define SuffixURL_ARClassRoom_AddUserCourses    @"/course/userCourses"  // 用户添加AR课程（by shuai.wang）

#define SuffixURL_ARClassRoom_Activation    @"/course/codes/activate"  // AR课程激活接口（by feng.kong）

// add by liulong
#define ServiceURL_ARClassRoom_GetAllCourses URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_GetAllCourses)       // 获取所有课程列表/推荐课程列表
#define ServiceURL_ARClassRoom_GetUserCourses URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_GetUserCourses)       // 获取用户课程列表
#define ServiceURL_ARClassRoom_GetBanners URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_GetBanners)       // 获取AR课程banner列表
#define ServiceURL_ARClassRoom_AddUserCourses URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_AddUserCourses)       // 用户添加AR课程
#define ServiceURL_ARClassRoom_ActiveCourses URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_Activation)       // 用户激活AR课程

#define SuffixURL_ARClassRoom_Course_feedback @"/course/feedbacks"
#define ServiceURL_ARClassRoom_Course_feedback URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_Course_feedback)         // 用户对AR课程反馈评价

#define SuffixURL_ARClassRoom_Course_Params       @"/course/params"
#define ServiceURL_ARClassRoom_Course_Params URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_Course_Params)      // 获取课程参数列表

// 获取书架中我的课程列表(by weichao.song) add by MT.X
#define SuffixURL_ARClassRoom_Course_List @"/course/userCourses/shelfCourseList"
#define ServiceURL_ARClassRoom_Course_List URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_Course_List)

//获取AR课程中的单元详情  /course/units/{unitId}/{courseId} （by shuai.wang） add by MT.X
#define SuffixURL_ARClassRoom_Unit_Detail @"/course/units"
#define ServiceURL_ARClassRoom_Unit_Detail URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_Unit_Detail)

//POST 上传AR课程单元阅读行为 （by shuai.wang) add by MT.X
#define SuffixURL_ARClassRoom_Behavior_Report @"/course/read/behaviors"
#define ServiceURL_ARClassRoom_Behavior_Report URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_Behavior_Report)

#define SuffixURL_ARClassRoom_Course_Add @"/course/userCourses"
#define ServiceURL_ARClassRoom_Course_Add URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_Course_Add)         // 用户添加AR课程

#define SuffixURL_ARClassRoom_Course_Unit_Books @"/course/units/books"
#define ServiceURL_ARClassRoom_Course_Unit_Books URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_Course_Unit_Books)   // 获取单元延展图书列表

#define SuffixURL_ARClassRoom_Course_Detatil @"/courses"
#define ServiceURL_ARClassRoom_Course_Detatil URLStringCat(MXR_ARClassRoom_API_URL(), SuffixURL_ARClassRoom_Course_Detatil)   // 根据课程ID获取课程详情


#endif /* MXRARClassRoomNetworkUrl_h */
