//
//  MXRHandleFilesNetworkUrl.h
//  huashida_home
//
//  Created by 周建顺 on 2017/5/25.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRHandleFilesNetworkUrl_h
#define MXRHandleFilesNetworkUrl_h

#import "MXRNetworkUrl.h"

#define SuffixURL_handle_files_qiniu_diy_book @"handlefiles/qiniu/diy/book"
#define ServiceURL_handle_files_qiniu_diy_book  URLStringCat(MXR_HANDLE_FILE_BASE_URL(),SuffixURL_handle_files_qiniu_diy_book)
// 上传
static inline NSString *MXR_HANDLE_FILE_BASE_URL(){
    
    return MXRBASE_API_URL();
}

// 正式图书文件下载列表
#define SuffixURL_DOWNLOAD_FILELIST(__bookGUID)             [NSString stringWithFormat:@"areditor/release/filelist/%@",__bookGUID]
#define ServiceURL_DOWNLOAD_FILELIST(__bookGUID)            URLStringCat(MXR_HANDLE_FILE_BASE_URL(),SuffixURL_DOWNLOAD_FILELIST(__bookGUID))

// 编辑器预览图书信息
#define  SuffixURL_EDITOR_PREVIEW_DOWNLOAD_FILELIST(__bookGUID)             [NSString stringWithFormat:@"areditor/release/demo/%@",__bookGUID]
#define  ServiceURL_EDITOR_PREVIEW_DOWNLOAD_FILELIST(__bookGUID)            URLStringCat(MXR_HANDLE_FILE_BASE_URL(), SuffixURL_EDITOR_PREVIEW_DOWNLOAD_FILELIST(__bookGUID))

// 一审二审二维码获取图书信息
#define  SuffixURL_AUDIT_DOWNLOAD_INFO(__bookGUID)              [NSString stringWithFormat:@"areditor/release/audit/%@",__bookGUID]
#define  ServiceURL_AUDIT_DOWNLOAD_INFO(__bookGUID)             URLStringCat(MXR_HANDLE_FILE_BASE_URL(), SuffixURL_AUDIT_DOWNLOAD_INFO(__bookGUID))

#define  SuffixURL_DIY_REVIEW_DOWNLOAD_INFO(__bookGUID)              [NSString stringWithFormat:@"areditor/release/audit/diy/%@",__bookGUID]
#define  ServiceURL_DIY_REVIEW_DOWNLOAD_INFO(__bookGUID)             URLStringCat(MXR_HANDLE_FILE_BASE_URL(), SuffixURL_DIY_REVIEW_DOWNLOAD_INFO(__bookGUID))

// 获取阿里云文件下载的token
#define SuffixURL_DOWNLOAD_ALIYUN_OSS_TOKEN                 @"/base/aliyun/oss/token"
#define ServiceURL_DOWNLOAD_ALIYUN_OSS_TOKEN                URLStringCat(MXR_HANDLE_FILE_BASE_URL(), SuffixURL_DOWNLOAD_ALIYUN_OSS_TOKEN)


// 获取对应的bucket，endpoint
#define SuffixURL_DOWNLOAD_ALIYUN_OSS_BUCKET                @"/base/aliyun/oss/bucket"
#define ServiceURL_DOWNLOAD_ALIYUN_OSS_BUCKET               URLStringCat(MXR_HANDLE_FILE_BASE_URL(), SuffixURL_DOWNLOAD_ALIYUN_OSS_BUCKET)

#endif /* MXRHandleFilesNetworkUrl_h */
