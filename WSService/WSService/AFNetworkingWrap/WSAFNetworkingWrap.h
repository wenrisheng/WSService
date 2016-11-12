//
//  WSAFNetworkingWrap.h
//  WSService
//
//  Created by wrs on 15/9/8.
//  Copyright (c) 2015年 wrs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSBaseServiceDefine.h"
#import <AFNetworking.h>

@interface WSAFNetworkingWrap : NSObject

#pragma mark - 静态方法


/**
 *  请求
 *
 *  @param url
 *  @param requestMethod
 *  @param params
 *  @param header
 *  @param sucCallBack
 *  @param failCallBack
 *
 *  @return
 */
+ (void)requestWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack requestMethod:(WSServiceRequestMethod)requestMethod requestType:(WSServiceRequestType)requestType httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd;

/**
 *  文件上传
 *
 *  @param url
 *  @param params
 *  @param data
 *  @param fileName
 *  @param key
 *  @param contentType
 *  @param sendCallBack
 *  @param sucCallBack
 *  @param failCallBack 
 */
+ (void)uploadFileWithUrl:(NSString *)url params:(NSDictionary *)params fileData:(NSData *)data fileName:(NSString *)fileName key:(NSString *)key contentType:(NSString *)contentType sendingCallBack:(void(^)(unsigned long long size, unsigned long long total))sendCallBack sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack;

/**
 * 文件下载
 */
+ (void)downLoadFileWithUrl:(NSString *)url params:(NSDictionary *)params header:(NSDictionary *)header savePath:(NSString *)savePath receivingCallBack:(void(^)(unsigned long long size, unsigned long long total))receivingCallBack sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack;

#pragma mark - 调试模式下信息打印
+ (void)printRequestDataForDebugWithUrl:(NSString *)url params:(NSDictionary *)params method:(WSServiceRequestMethod)requestMethod;
+ (void)printResponseDataForDebugWithUrl:(NSString *)url params:(NSDictionary *)params method:(WSServiceRequestMethod)requestMethod responseData:(id)response;
+ (void)printRequestFailDataForDebugWithUrl:(NSString *)url params:(NSDictionary *)params method:(WSServiceRequestMethod)requestMethod error:(NSError *)error;

@end
