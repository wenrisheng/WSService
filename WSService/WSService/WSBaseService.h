//
//  WSService.h
//  WSService
//
//  Created by wrs on 15/9/2.
//  Copyright (c) 2015年 wrs. All rights reserved.
// smart git etse
/*  WSService 放在项目同等级目录下，并且添加pod依赖：
 xcodeproj '../WSService/WSService'

 # service
 target :WSService do
    pod 'ASIHTTPRequest'
    pod 'AFNetworking'
    xcodeproj '../WSService/WSService'
 end
 
在项目的Building Setting -> User Header Search Paths增加一项
 $(PROJECT_DIR)/../WSService
 来搜索WSService的头文件，在项目中引入WSBaseService.h文件即可
 
*/


#import <Foundation/Foundation.h>
#import "WSBaseServiceDefine.h"

@interface WSBaseService : NSObject

+ (void)requestWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack requestMethod:(WSServiceRequestMethod)requestMethod requestType:(WSServiceRequestType)requestType httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd frameworkType:(WSServiceFrameworkType)frameworkType;

+ (void)uploadFileWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header fileData:(NSData *)data fileName:(NSString *)fileName key:(NSString *)key contentType:(NSString *)contentType sendingCallBack:(void(^)(unsigned long long size, unsigned long long total))sendingCallBack sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack requestMethod:(WSServiceRequestMethod)requestMethod requestType:(WSServiceRequestType)requestType httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd frameworkType:(WSServiceFrameworkType)frameworkType;

+ (void)downLoadFileWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header savePath:(NSString *)savePath tempPath:(NSString *)tempPath receivingCallBack:(void(^)(unsigned long long size, unsigned long long total))receivingCallBack sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack requestMethod:(WSServiceRequestMethod)requestMethod requestType:(WSServiceRequestType)requestType httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd frameworkType:(WSServiceFrameworkType)frameworkType;

+ (WSServiceRequestMethod)converToServiceRequestMethod:(NSString *)requestMethod;

+ (NSString *)converToServiceRequestMethodString:(WSServiceRequestMethod)requestMethod;

@end
