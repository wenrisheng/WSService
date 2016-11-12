//
//  ASIHttpWrap.m
//  CTWeMedia
//
//  Created by wrs on 15/4/8.
//  Copyright (c) 2015年 wrs. All rights reserved.
//


#import "WSASIHttpRequestWrap.h"
#import "ASIFormDataRequest.h"
#import "WSUploadDownloadRequest.h"
#import "WSBaseService.h"

@interface WSASIHttpRequestWrap ()


@end

@implementation WSASIHttpRequestWrap

+ (ASIFormDataRequest *)requestWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header tag:(int)tag sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack requestMethod:(WSServiceRequestMethod)requestMothod requestType:(WSServiceRequestType)requestType httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd
{
    url = [self dealUrl:url requestMethod:requestMothod params:params];
    
    // 生成request
    ASIFormDataRequest *request = [self getRequestWithUrl:url header:header httpsCerData:httpsCerData cerPwd:cerPwd];
    
    request.tag = tag;
    [request setTimeOutSeconds:ASIHTTPWRAP_TIMEOUT_DEFAULT];
    
    // 设置请求方法和参数
    [self addRequestParamsWithRequest:request params:params requestMethod:requestMothod];
    
    // 设置请求回调
    [self addRequestCallBackWithRequest:request sucCallBack:sucCallBack failCallBack:failCallBack];
    
    // 开始请求
    [self startRequestWithRequest:request requestType:requestType];
    
    // 调试 打印请求url及入参
#ifdef DEBUG
    [WSASIHttpRequestWrap printRequestDataForDebug:request];
#endif
    
    return request;
}

+ (void)cancelRequest:(ASIHTTPRequest *)request
{
    if (request) {
        [request cancel];
    }
}

#pragma mark - 下载文件
+ (ASIHTTPRequest *)downLoadFileWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header savePath:(NSString *)savePath tempPath:(NSString *)tempPath receivingCallBack:(void(^)(unsigned long long size, unsigned long long total))receivingCallBack sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack tag:(int)tag requestMethod:(WSServiceRequestMethod)requestMothod requestType:(WSServiceRequestType)requestType httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd
{
    url = [self dealUrl:url requestMethod:requestMothod params:params];
    
    ASIFormDataRequest *request = [self getRequestWithUrl:url header:header httpsCerData:httpsCerData cerPwd:cerPwd];
    
    // 设置请求方法和参数
    [self addRequestParamsWithRequest:request params:params requestMethod:requestMothod];
    
    [request setShowAccurateProgress:YES];
    [request setDownloadDestinationPath:savePath];
    [request setTemporaryFileDownloadPath:tempPath];
    [request setAllowResumeForFileDownloads:YES];
    [request setShouldContinueWhenAppEntersBackground:YES];
    request.tag = tag;
    
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        float before = [[userDefaults objectForKey:[NSString stringWithFormat:@"%@%@", DOWNLOAD_URL, url]] floatValue];
        float cur = size + before;
//        float percent = 1.0000 * cur / total;
        //        float showCur = size * 1.000 / 1024 /1024 / 1024;
        //        float showTotal = total * 1.0000 / 1024.0000 /1024 / 1024;
        if (receivingCallBack) {
            receivingCallBack(size, total);
        }
        // NSLog(@"下载精度:%.2f cur:%.2f total:%.2f", percent, showCur, showTotal);
        
        // 保存当前已下载量
        [userDefaults setObject:[NSNumber numberWithFloat:cur] forKey:[NSString stringWithFormat:@"%@%@", DOWNLOAD_URL, url]];
    }];
    __weak ASIFormDataRequest *weakRequest = request;
    [request setCompletionBlock:^{
        // 下载成功后，删除保存的下载量
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:[NSString stringWithFormat:@"%@%@", DOWNLOAD_URL, url]];
        
        // 下载成功后，删除request
        NSMutableDictionary *downloadRequestDic = [WSUploadDownloadRequest sharedWSUploadDownloadRequest].downloadRequestDic;
        [downloadRequestDic removeObjectForKey:[NSString stringWithFormat:@"%@%@", DOWNLOAD_REQUEST, url]];
        
        [self dealCompletionBlock:weakRequest sucCallBack:sucCallBack failCallBack:failCallBack];
    }];
    [request setFailedBlock:^{
        // 下载失败时，删除保存的下载量
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:[NSString stringWithFormat:@"%@%@", DOWNLOAD_URL, url]];
        
        // 下载失败时，删除request
        NSMutableDictionary *downloadRequestDic = [WSUploadDownloadRequest sharedWSUploadDownloadRequest].downloadRequestDic;
        [downloadRequestDic removeObjectForKey:[NSString stringWithFormat:@"%@%@", DOWNLOAD_REQUEST, url]];
        
        [self dealFailedBlock:weakRequest failCallBack:failCallBack];
    }];
    
    // 保存下载request,方便暂停下载时获得request
    WSUploadDownloadRequest *uploadDownloadRequest = [WSUploadDownloadRequest sharedWSUploadDownloadRequest];
    if (!uploadDownloadRequest.downloadRequestDic) {
        uploadDownloadRequest.downloadRequestDic = [[NSMutableDictionary alloc] init];
    }
    [uploadDownloadRequest.downloadRequestDic setObject:request forKey:[NSString stringWithFormat:@"%@%@", DOWNLOAD_REQUEST, url]];
    
    // 开始请求
    [self startRequestWithRequest:request requestType:requestType];
    
    return request;
}

#pragma mark 上传文件
+ (ASIHTTPRequest *)uploadFileWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header fileData:(NSData *)data fileName:(NSString *)fileName key:(NSString *)key contentType:(NSString *)contentType sendingCallBack:(void(^)(unsigned long long size, unsigned long long total))sendCallBack sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack requestMethod:(WSServiceRequestMethod)requestMothod tag:(int)tag requestType:(WSServiceRequestType)requestType httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd
{
    url = [self dealUrl:url requestMethod:requestMothod params:params];
    
    ASIFormDataRequest *request = [self getRequestWithUrl:url header:header httpsCerData:httpsCerData cerPwd:cerPwd];
    
    // 设置请求方法和参数
    [self addRequestParamsWithRequest:request params:params requestMethod:requestMothod];
    
    request.tag = tag;
    [request setShowAccurateProgress:YES];
    [request setData:data withFileName:fileName andContentType:contentType forKey:key];
    [request setShouldContinueWhenAppEntersBackground:YES];
    
    [request setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        float before = [[userDefaults objectForKey:[NSString stringWithFormat:@"%@%@", UPLOAD_URL, url]] floatValue];
        float cur = size + before;
        float percent = 1.0000 * cur / total;
        float showCur = size * 1.000 / 1024 /1024 / 1024;
        float showTotal = total * 1.0000 / 1024.0000 /1024 / 1024;
        if (sendCallBack) {
            sendCallBack(size, total);
        }
        NSLog(@"上传进度:%.2f cur:%.2f total:%.2f", percent, showCur, showTotal);
        
        // 保存当前已上传量
        [userDefaults setObject:[NSNumber numberWithFloat:cur] forKey:[NSString stringWithFormat:@"%@%@", UPLOAD_URL, url]];
    }];
   
    
    __weak ASIHTTPRequest *weakRequest = request;
    [request setCompletionBlock:^{
        // 上传完成时，删除当前上传量
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:[NSString stringWithFormat:@"%@%@", UPLOAD_URL, url]];
        
        // 上传完成时，删除request
        NSMutableDictionary *uploadRequestDic = [WSUploadDownloadRequest sharedWSUploadDownloadRequest].uploadRequestDic;
        [uploadRequestDic removeObjectForKey:[NSString stringWithFormat:@"%@%@", UPLOAD_URL, url]];
        
        [WSASIHttpRequestWrap dealCompletionBlock:weakRequest sucCallBack:sucCallBack failCallBack:failCallBack];
    }];
    
    [request setFailedBlock:^{
        // 上传失败时，删除当前上传量
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:[NSString stringWithFormat:@"%@%@", UPLOAD_URL, url]];
        
        // 上传失败时，删除request
        NSMutableDictionary *uploadRequestDic = [WSUploadDownloadRequest sharedWSUploadDownloadRequest].uploadRequestDic;
        [uploadRequestDic removeObjectForKey:[NSString stringWithFormat:@"%@%@", UPLOAD_URL, url]];
        
        [WSASIHttpRequestWrap dealFailedBlock:weakRequest failCallBack:failCallBack];
    }];
    
    // 保存上传request,方便暂停下载时获得request
    WSUploadDownloadRequest *uploadDownloadRequest = [WSUploadDownloadRequest sharedWSUploadDownloadRequest];
    if (!uploadDownloadRequest.uploadRequestDic) {
        uploadDownloadRequest.uploadRequestDic = [[NSMutableDictionary alloc] init];
    }
    [uploadDownloadRequest.uploadRequestDic setObject:request forKey:[NSString stringWithFormat:@"%@%@", UPLOAD_REQUEST, url]];
    
    // 调试 打印请求url及入参
#ifdef DEBUG
    [WSASIHttpRequestWrap printRequestDataForDebug:request];
#endif
    
    // 开始请求
    [self startRequestWithRequest:request requestType:requestType];
    
    return request;
    
}

#pragma mark 暂停下载
+ (void)cancelDownloadWithUrl:(NSString *)url
{
    NSMutableDictionary *downloadRequestDic = [WSUploadDownloadRequest sharedWSUploadDownloadRequest].downloadRequestDic;
    ASIHTTPRequest *downloadRequest = [downloadRequestDic valueForKey:[NSString stringWithFormat:@"%@%@", DOWNLOAD_REQUEST, url]];
    if (downloadRequest) {
        [downloadRequest clearDelegatesAndCancel];
    }
}

#pragma mark 暂停上传
+ (void)cancelUploadWithUrl:(NSString *)url
{
    NSMutableDictionary *uploadRequestDic = [WSUploadDownloadRequest sharedWSUploadDownloadRequest].uploadRequestDic;
    ASIHTTPRequest *uploadRequest = [uploadRequestDic valueForKey:[NSString stringWithFormat:@"%@%@", UPLOAD_REQUEST, url]];
    if (uploadRequest) {
        [uploadRequest clearDelegatesAndCancel];
    }
}

#pragma mark - 处理url, 针对GET请求时param不为nil拼接参数问题
+ (NSString *)dealUrl:(NSString *)url requestMethod:(WSServiceRequestMethod)requestMothod params:(id)params
{
    if (requestMothod == WSServiceRequestMethodGet) {
        if (params != nil && [params isKindOfClass:[NSDictionary class]]) {
            NSDictionary *paramDic = params;
            if (paramDic.allKeys.count > 0) {
                NSMutableString *paramStr = [NSMutableString string];
                NSArray *allKeys = paramDic.allKeys;
                NSInteger count = allKeys.count;
                for (int i = 0; i < count; i++) {
                    NSString *key = [allKeys objectAtIndex:i];
                    NSString *value = [params objectForKey:key];
                    [paramStr appendString:[NSString stringWithFormat:@"%@=%@", key, value]];
                    if (i != count - 1) {
                        [paramStr appendString:@"&"];
                    }
                }
                url = [NSString stringWithFormat:@"%@?%@", url, paramStr];
            }
        }
    }
    return url;
}

+ (ASIFormDataRequest *)getRequestWithUrl:(NSString *)url header:(NSDictionary *)header httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    // 添加请求头信息
    [self addRequestHeaderWithRequest:request header:header];
    
    // 设置https
    [self addHttpsCerWithRequest:request httpsCerData:httpsCerData cerPwd:(NSString *)cerPwd];
    
    return request;
}

#pragma mark - 增加请求头信息
+ (void)addRequestHeaderWithRequest:(ASIHTTPRequest *)request header:(NSDictionary *)header
{
    if (header && header.allKeys.count > 0) {
        NSArray *headerKeys = header.allKeys;
        for (id key in headerKeys) {
            id value = [header valueForKey:key];
            [request addRequestHeader:key value:value];
        }
        [request buildRequestHeaders];
#ifdef DEBUG
        NSLog(@"请求头：%@", request.requestHeaders);
#endif
    }

}

#pragma mark 增加请求参数
+ (void)addRequestParamsWithRequest:(ASIFormDataRequest *)request params:(id)params requestMethod:(WSServiceRequestMethod)requestMothod
{
    request.requestMethod = [WSBaseService converToServiceRequestMethodString:requestMothod];
    switch (requestMothod) {
        case WSServiceRequestMethodGet:
        {
            request.requestMethod = @"GET";
        }
            break;
        case WSServiceRequestMethodPOST:
        {
            request.requestMethod = @"POST";
            // 入参
            NSArray *allKeys = [params allKeys];
            for(id key in allKeys)
            {
                id value = [params valueForKey:key];
                [request setPostValue:value forKey:(NSString *)key];
            }
            
        }
            break;
        case WSServiceRequestMethodPOSTBODY:
        {
            request.requestMethod = @"POST";
            if (params) {
                NSData *jsonData;
                if ([params isKindOfClass:[NSString class]]) {
                    jsonData = [params dataUsingEncoding:NSUTF8StringEncoding];
                } else {
                    jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:nil];
                }
               
                NSMutableData *data = [NSMutableData dataWithData:jsonData];
                [request setPostBody:data];
            }
        }
            break;
        case WSServiceRequestMethodPatch:
        {
            request.requestMethod = @"PATCH";
            if (params) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                     error:nil];
                NSMutableData *data = [NSMutableData dataWithData:jsonData];
                [request setPostBody:data];
            }
        }
            break;
        default:
            break;
    }
    [request buildPostBody];
}

#pragma mark 增加https
+ (void)addHttpsCerWithRequest:(ASIHTTPRequest *)request httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd
{
    [request setValidatesSecureCertificate:NO];//是否验证服务器端证书，如果此项为yes那么服务器端证书必须为合法的证书机构颁发的，而不能是自己用openssl 或java生成的证书
    if (httpsCerData) {
        SecIdentityRef identity = NULL;
        SecTrustRef trust = NULL;
        [self extractIdentity:&identity andTrust:&trust fromPKCS12Data:httpsCerData cerPwd:(NSString *)cerPwd];
        [request setClientCertificateIdentity:identity];
    }
}

+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data cerPwd:(NSString *)cerPwd
{
    OSStatus securityError = errSecSuccess;
//    CFStringRef password = CFSTR("p@ssw0rd888"); //证书密码
//    CFStringRef password = (__bridge CFStringRef)cerPwd;
//    const void *keys[] =   { kSecImportExportPassphrase };
//    const void *values[] = { password };
    
//    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys,values, 1,NULL, NULL);
    NSMutableDictionary *optionsDictionary = [NSMutableDictionary dictionary];
    if (cerPwd && cerPwd.length > 0) {
        [optionsDictionary setObject:cerPwd forKey:(id)kSecImportExportPassphrase];
    }
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((CFDataRef)inPKCS12Data, (CFDictionaryRef)optionsDictionary,&items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failed with error code %d",(int)securityError);
        return NO;
    }
    return YES;
}

#pragma mark 增加请求回调
+ (void)addRequestCallBackWithRequest:(ASIHTTPRequest *)request sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack
{
    __weak ASIHTTPRequest *respRequest = request;
    // 请求完成
    [request setCompletionBlock:^{
        [WSASIHttpRequestWrap dealCompletionBlock:respRequest sucCallBack:sucCallBack failCallBack:failCallBack];
    }];
    
    // 请求失败
    [request setFailedBlock:^{
        [WSASIHttpRequestWrap dealFailedBlock:respRequest failCallBack:failCallBack];
    }];
}

#pragma mark 开始请求
+ (void)startRequestWithRequest:(ASIHTTPRequest *)request requestType:(WSServiceRequestType)requestType
{
    switch (requestType) {
             // 开始异步请求
        case WSServiceRequestTypeAsync:
        {
            [request startAsynchronous];
        }
            break;
             // 开始同步请求
        case WSServiceRequestTypeSync:
        {
            [request startSynchronous];
        }
            break;
        default:
            break;
    }
}

#pragma mark - ASIHTTPRequest回调处理
+ (void)dealCompletionBlock:(ASIHTTPRequest *)request sucCallBack:(void (^)(id result))sucCallBack  failCallBack:(void (^)(id result))failCallBack
{
    NSData *responseData = [request responseData];
//    NSError *jsonError = nil;
//    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
    // 块回调
    if (sucCallBack) {
        sucCallBack(responseData);
    }

    // 调试打印响应数据
#ifdef DEBUG
    [WSASIHttpRequestWrap printResponseDataForDebug:request];
#endif
    
}

+ (void)dealFailedBlock:(ASIHTTPRequest *)request failCallBack:(void (^)(id result))failCallBack
{
    // 调试 打印请求错误
#ifdef  DEBUG
    [WSASIHttpRequestWrap printRequestFailDataForDebug:request];
#endif
    
    // 请求错误回调
    if (failCallBack) {
        failCallBack(request.responseString);
    }
}

#pragma mark - 调试模式下信息打印
+ (void)printRequestDataForDebug:(ASIHTTPRequest *)request
{
    NSString *url = request.url.absoluteString;
    NSInteger tag = request.tag;
    NSString *requestMethod = request.requestMethod;
    NSString *params = [[NSString alloc] initWithData:[request postBody] encoding:NSUTF8StringEncoding];
    NSLog(@"\n/%@请求报文%@/ \n"
          "request: \n"
          "{ \n  "
          "url:%@, \n  "
          "method:%@, \n  "
          "params:%@, \n  "
          "tag:%ld \n"
          "} \n"
          "浏览器URL: \n"
          "%@ \n"
          "/%@/ \n",
          HALF_LINE_START,
          HALF_LINE_START,
          url,
          requestMethod,
          params,
          (long)tag,
          [NSString stringWithFormat:@"%@?%@", url, params],
          LINE_START);
}

+ (void)printResponseDataForDebug:(ASIHTTPRequest *)request
{
    NSString *params = [[NSString alloc] initWithData:[request postBody] encoding:NSUTF8StringEncoding];
    NSString *url = request.url.absoluteString;
    NSInteger tag = request.tag;
    NSString *requestMethod = request.requestMethod;
    
    NSError *requestError = request.error;
    
    //请求有错误
    if (requestError) {
        NSLog(@"/%@请求失败!%@/ \n"
              "request: \n"
              "{ \n"
              "error:%@, \n"
              "responseString:%@, \n"
              "url:%@, \n"
              "method:%@, \n"
              "params:%@, \n"
              "tag:%ld \n"
              "} \n"
              "浏览器URL: \n"
              "%@ \n"
              "/%@/ \n",
              HALF_LINE_START,
              HALF_LINE_START,
              requestError,
              [request responseString],
              url,
              requestMethod,
              params,
              (long)tag,
              [NSString stringWithFormat:@"%@?%@", url, params],
              LINE_START);
    }
    NSData *responseData = [request responseData];
    NSError *jsonError = nil;
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
    
    // json格式解析失败
    if (jsonError) {
        NSLog(@"\n/%@JSON解析失败!%@/ \n"
              "request: \n"
              "{ \n  "
              "error:%@, \n"
              "responseString:%@, \n"
              "url:%@, \n"
              "method:%@, \n"
              "params:%@, \n"
              "tag:%ld\n"
              "} \n"
              "浏览器URL:%@ \n"
              "/%@/ \n",
              HALF_LINE_START,
              HALF_LINE_START,
              requestError,
              [request responseString],
              url,
              requestMethod,
              params,
              (long)tag,
              [NSString stringWithFormat:@"%@?%@", url, params],
              LINE_START);
        return;
        
    }
    
    // 打印json格式的响应报文，方便观看
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resultDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // 查看对应的请求url
    NSLog(@"\n/%@响应报文:%@/\n"
          "response：\n"
          "%@ \n"
          "request:\n"
          "{ \n  "
          "url:%@ \n  "
          "method:%@ \n  "
          "params:%@ \n  "
          "tag:%ld\n"
          "} \n"
          "浏览器URL:%@ \n"
          "/%@/ \n",
          HALF_LINE_START,
          HALF_LINE_START,
          jsonStr,
          url,
          requestMethod,
          params,
          (long)tag,
          [NSString stringWithFormat:@"%@?%@", url, params],
          LINE_START
          );
}

+ (void)printRequestFailDataForDebug:(ASIHTTPRequest *)request
{
    NSString *params = [[NSString alloc] initWithData:[request postBody] encoding:NSUTF8StringEncoding];
    NSString *url = request.url.absoluteString;
    NSInteger tag = request.tag;
    NSString *requestMethod = request.requestMethod;
    NSError *requestError = request.error;
    
    NSLog(@"/%@/ \n"
          "/%@请求失败!%@/ \n"
          "request: \n"
          "{ \n"
          "error:%@, \n"
          "responseString:%@, \n"
          "url:%@, \n"
          "method:%@, \n"
          "params:%@, \n"
          "tag:%ld \n"
          "} \n"
          "浏览器URL: \n"
          "%@ \n"
          "/%@/ \n",
          LINE_START,
          HALF_LINE_START,
          HALF_LINE_START,
          requestError,
          [request responseString],
          url,
          requestMethod,
          params,
          (long)tag,
          [NSString stringWithFormat:@"%@?%@", url, params],
          LINE_START);
    
}

@end
