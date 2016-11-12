//
//  ASIHttpWrap.h
//  CTWeMedia
//
//  Created by wrs on 15/4/8.
//  Copyright (c) 2015年 wrs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "WSBaseServiceDefine.h"

@interface WSASIHttpRequestWrap : NSObject

/**
 *  网络请求
 *
 *  @param url
 *  @param params
 *  @param header
 *  @param tag
 *  @param sucCallBack
 *  @param failCallBack
 *  @param requestMothod
 *  @param requestType
 *  @param delegate
 *
 *  @return
 */
+ (ASIFormDataRequest *)requestWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header tag:(int)tag sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack requestMethod:(WSServiceRequestMethod)requestMothod requestType:(WSServiceRequestType)requestType httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd;

/**
 *  取消请求
 *
 *  @param request
 */
+ (void)cancelRequest:(ASIHTTPRequest *)request;

#pragma mark - 下载文件
/**
 *  下载文件，开始下载与恢复下载都调用此方法
 *
 *  @param url
 *  @param savePath  保存文件路径，如xxx/xxxx.zip
 *  @param tempPath  零时文件路径，如xxx/xxxx.zip.temp
 *  @param receivingCallBack
 *  @param sucCallBack
 *  @param failCallBack
 *  @param tag
 *
 *  @return
 */
+ (ASIHTTPRequest *)downLoadFileWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header savePath:(NSString *)savePath tempPath:(NSString *)tempPath receivingCallBack:(void(^)(unsigned long long size, unsigned long long total))receivingCallBack sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack tag:(int)tag requestMethod:(WSServiceRequestMethod)requestMothod requestType:(WSServiceRequestType)requestType httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd;

#pragma mark 上传文件
/**
 *  上传文件
 *
 *  @param url
 *  @param data
 *  @param fileName
 *  @param contentType
 *  @param sendCallBack
 *  @param sucCallBack
 *  @param failCallBack
 *  @param tag          tag description
 *
 *  @return return value description
 */
+ (ASIHTTPRequest *)uploadFileWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header fileData:(NSData *)data fileName:(NSString *)fileName key:(NSString *)key contentType:(NSString *)contentType sendingCallBack:(void(^)(unsigned long long size, unsigned long long total))sendCallBack sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack requestMethod:(WSServiceRequestMethod)requestMothod tag:(int)tag requestType:(WSServiceRequestType)requestType httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd;

#pragma mark 暂停下载
/**
 *  暂停下载
 *
 *  @param url
 */
+ (void)cancelDownloadWithUrl:(NSString *)url;

#pragma mark 暂停上传
/**
 *  暂停上传
 *
 *  @param url url description
 */
+ (void)cancelUploadWithUrl:(NSString *)url;

#pragma mark - ASIHTTPRequest回调处理
+ (void)dealCompletionBlock:(ASIHTTPRequest *)request sucCallBack:(void (^)(id result))sucCallBack  failCallBack:(void (^)(id result))failCallBack;

+ (void)dealFailedBlock:(ASIHTTPRequest *)request failCallBack:(void (^)(id result))failCallBack;

#pragma mark - 调试模式下信息打印
+ (void)printRequestDataForDebug:(ASIHTTPRequest *)request;
+ (void)printResponseDataForDebug:(ASIHTTPRequest *)request;
+ (void)printRequestFailDataForDebug:(ASIHTTPRequest *)request;


@end
