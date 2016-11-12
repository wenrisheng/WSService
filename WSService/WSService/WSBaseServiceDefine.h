//
//  WSServiceDefine.h
//  WSService
//
//  Created by wrs on 15/9/2.
//  Copyright (c) 2015年 wrs. All rights reserved.
//

#ifndef WSService_WSServiceDefine_h
#define WSService_WSServiceDefine_h

#define LINE_START       @"***********************************************"
#define HALF_LINE_START  @"***********************"

#define DOWNLOAD_REQUEST      @"DOWNLOAD_REQUEST"     // 保存下载request请求key
#define DOWNLOAD_URL          @"DOWNLOAD_URL"         // 保存下载量key

#define UPLOAD_REQUEST        @"UPLOAD_REQUEST"       // 保存上传请求key
#define UPLOAD_URL            @"UPLOAD_URL"           // 保存上传量key

typedef NS_OPTIONS(NSUInteger, WSServiceRequestMethod) {
    WSServiceRequestMethodNone                = 0,
    WSServiceRequestMethodGet                 = 1 << 0,         // GET请求
    WSServiceRequestMethodPOST                = 2 << 1,         // POST请求
    WSServiceRequestMethodPOSTBODY            = 3 << 2,        // POST请求，入参放到requestBody中
    WSServiceRequestMethodPatch               = 4 << 3
};

typedef NS_OPTIONS(NSUInteger, WSServiceRequestType) {
    WSServiceRequestTypeAsync                 = 0,        // 异步请求
    WSServiceRequestTypeSync                  = 1 << 0,   // 同步请求
};

typedef NS_OPTIONS(NSUInteger, WSServiceFrameworkType) {
    WSServiceFrameworkTypeASIHttpRequest                 = 0,        // ASIHTTPRequest
    WSServiceFrameworkTypeAFNetworking                  = 1 << 0,   //  AFNetworking
};

#define ASIHTTPWRAP_TIMEOUT_DEFAULT           10    //默认超时,下载、上传没有设置超时

typedef void(^ServiceSucCallBack)(id result);
typedef void(^ServiceFailCallBack)(id error);

typedef void(^ReceivingCallBack)(unsigned long long size, unsigned long long total, float percent, NSString *url, int tag) ;
typedef void(^DownloadSucCallBack)(NSString *url, int tag);
typedef void(^DownloadFailCallBack)(NSError *error, NSString *url, int tag) ;

typedef void(^SendingCallBack)(unsigned long long size, unsigned long long total, float percent, NSString *url, int tag) ;
typedef void(^UploadSucCallBack)(NSString *url, int tag);
typedef void(^UploadFailCallBack)(NSError *error, NSString *url, int tag) ;


#endif
