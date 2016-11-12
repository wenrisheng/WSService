//
//  WSAFNetworkingWrap.m
//  WSService
//
//  Created by wrs on 15/9/8.
//  Copyright (c) 2015年 wrs. All rights reserved.
//

#import "WSAFNetworkingWrap.h"
#import "AFURLSessionManager.h"
#import "WSBaseService.h"

@implementation WSAFNetworkingWrap

#pragma mark - POST
+ (void)asyncPostWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd
{
#ifdef DEBUG
    [WSAFNetworkingWrap printRequestDataForDebugWithUrl:url params:params method:WSServiceRequestMethodPOST];
#endif
    
    AFHTTPSessionManager *manager = [self getHTTPSessionManagerWithHeaer:header httpsCerData:httpsCerData cerPwd:cerPwd];
    
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                NSLog(@"上传进度");
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifdef DEBUG
                [WSAFNetworkingWrap printResponseDataForDebugWithUrl:url params:params method:WSServiceRequestMethodPOST responseData:responseObject];
#endif
                if (sucCallBack) {
                    sucCallBack(responseObject);
                }
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
                     [WSAFNetworkingWrap printRequestFailDataForDebugWithUrl:url params:params method:WSServiceRequestMethodPOST error:error];
#endif
                     if (failCallBack) {
                         failCallBack(error);
                     }
    }];
}

#pragma mark GET
+ (void)asyncGetWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd
{
#ifdef DEBUG
    [WSAFNetworkingWrap printRequestDataForDebugWithUrl:url params:nil method:WSServiceRequestMethodGet];
#endif
    
    AFHTTPSessionManager *manager = [self getHTTPSessionManagerWithHeaer:header httpsCerData:httpsCerData cerPwd:cerPwd];
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifdef DEBUG
        [WSAFNetworkingWrap printResponseDataForDebugWithUrl:url params:nil method:WSServiceRequestMethodGet responseData:responseObject];
#endif
        if (sucCallBack) {
            sucCallBack(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
        [WSAFNetworkingWrap printRequestFailDataForDebugWithUrl:url params:nil method:WSServiceRequestMethodGet error:error];
#endif
        
        if (failCallBack) {
            failCallBack(error);
        }
    }];
}


#pragma mark -
+ (void)requestWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack requestMethod:(WSServiceRequestMethod)requestMethod requestType:(WSServiceRequestType)requestType httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd
{
    switch (requestMethod) {
        case WSServiceRequestMethodGet:
        {
            [self asyncGetWithUrl:url params:params header:header sucCallBack:sucCallBack failCallBack:failCallBack httpsCerData:httpsCerData cerPwd:cerPwd];
        }
            break;
        case WSServiceRequestMethodPOST:
        case WSServiceRequestMethodPOSTBODY:
        {
            [self asyncPostWithUrl:url params:params header:header sucCallBack:sucCallBack failCallBack:failCallBack httpsCerData:httpsCerData cerPwd:cerPwd];
        }
            break;
        case WSServiceRequestMethodPatch:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 文件上传
+ (void)uploadFileWithUrl:(NSString *)url params:(NSDictionary *)params fileData:(NSData *)data fileName:(NSString *)fileName key:(NSString *)key contentType:(NSString *)contentType sendingCallBack:(void (^)(unsigned long long size, unsigned long long total))sendCallBack sucCallBack:(void (^)(id))sucCallBack failCallBack:(void (^)(id))failCallBack
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
   NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:data progress:^(NSProgress * _Nonnull uploadProgress) {
        if (sendCallBack) {
            int64_t completedUnitCount = uploadProgress.completedUnitCount;
            int64_t totalUnitCount = uploadProgress.totalUnitCount;
            sendCallBack(completedUnitCount, totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if (sucCallBack) {
                sucCallBack(responseObject);
            }
        } else {
            if (failCallBack) {
                failCallBack(error);
            }
        }
    }];
    [uploadTask resume];
    
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    NSError *error = nil;
//    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:data name:key fileName:fileName mimeType:contentType];
//    } error:&error];
//    if (error) {
//        failCallBack(error);
//        return;
//    }
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    AFHTTPRequestOperation *operation =
//    [manager HTTPRequestOperationWithRequest:request
//                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                         if (sucCallBack) {
//                                             sucCallBack(responseObject);
//                                         }
//                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                         if (failCallBack) {
//                                             failCallBack(error);
//                                         }
//                                         
//                                     }];
//    
//    // 4. Set the progress block of the operation.
//    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
//                                        long long totalBytesWritten,
//                                        long long totalBytesExpectedToWrite) {
//        if (sendCallBack) {
//            NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
//            sendCallBack(bytesWritten, totalBytesWritten);
//        }
//    }];
//    
//    // 5. Begin!
//    [operation start];
}

+ (void)downLoadFileWithUrl:(NSString *)url params:(NSDictionary *)params header:(NSDictionary *)header savePath:(NSString *)savePath receivingCallBack:(void (^)(unsigned long long, unsigned long long))receivingCallBack sucCallBack:(void (^)(id))sucCallBack failCallBack:(void (^)(id))failCallBack
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  NSURLSessionDownloadTask *downloadTask =  [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (receivingCallBack) {
            int64_t completedUnitCount = downloadProgress.completedUnitCount;
            int64_t totalUnitCount = downloadProgress.totalUnitCount;
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (receivingCallBack) {
                     receivingCallBack(completedUnitCount, totalUnitCount);
                 }
             });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *path = [savePath stringByAppendingPathComponent:response.suggestedFilename];
#ifdef DEBUG
        NSLog(@"保存路径：%@", path);
#endif
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (failCallBack) {
                failCallBack(error);
            }
        } else {
            if (sucCallBack) {
                sucCallBack(filePath);
            }
        }
    }];
    [downloadTask resume];
//    //下载附件
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.inputStream   = [NSInputStream inputStreamWithURL:[NSURL URLWithString:url]];
//    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:savePath append:NO];
//    
//    //下载进度控制
//  
//     [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//         float percent = bytesRead * 1.00 / totalBytesRead;
//         NSLog(@"Wrote %lld/%lld", bytesRead, totalBytesRead);
//         if (receivingCallBack) {
//             receivingCallBack(bytesRead, totalBytesRead);
//         }
//     }];
//    
//    
//    //已完成下载
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (sucCallBack) {
//            sucCallBack(responseObject);
//        }
//       
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failCallBack) {
//            failCallBack(error);
//        }
//       
//    }];
//    
//    [operation start];
}

#pragma mark - 获取AFHTTPSessionManager
+ (AFHTTPSessionManager *)getHTTPSessionManagerWithHeaer:(NSDictionary *)header httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd
{
    AFHTTPSessionManager *manager = [self getHTTPSessionManager];
    if (httpsCerData) {
        AFSecurityPolicy *securityPolicy = [self getSecurityPolicyWithHttpsCerData:httpsCerData cerPwd:cerPwd];
        manager.securityPolicy = securityPolicy;
    } else {
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; // 不进行https验证
    }
    [self addRequestHeaerWithAFHTTPRequestSerializer:manager.requestSerializer header:header];
    return manager;
}

+ (AFHTTPSessionManager *)getHTTPSessionManager;
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    return manager;
}

#pragma mark 增加请求头
+ (void)addRequestHeaerWithAFHTTPRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer header:(NSDictionary *)header
{
    if (header && header.allKeys.count > 0) {
        for (id key in header.allKeys) {
            id value = [header objectForKey:key];
            [requestSerializer setValue:value forHTTPHeaderField:key];
        }
#ifdef DEBUG
        NSLog(@"请求头：%@", requestSerializer.HTTPRequestHeaders);
#endif
    }
}

+ (AFSecurityPolicy *)getSecurityPolicyWithHttpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd
{
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[httpsCerData];
    
    return securityPolicy;
}

#pragma mark - 打印调试信息
+ (void)printRequestDataForDebugWithUrl:(NSString *)url params:(NSDictionary *)params method:(WSServiceRequestMethod)requestMethod
{
    NSString *method;
    switch (requestMethod) {
        case WSServiceRequestMethodGet:
        {
            method = @"GET";
        }
            break;
        case WSServiceRequestMethodPOST:
        {
            method = @"POST";
        }
            break;
        case WSServiceRequestMethodPOSTBODY:
        {
            method = @"POST_BODY";
        }
            break;
        default:
            break;
    }
    
    
    
    NSLog(@"\n/%@请求报文%@/ \n"
          "request: \n"
          "{ \n  "
          "url:%@, \n  "
          "method:%@, \n  "
          "params:%@, \n  "
          "} \n"
          "%@ \n"
          "/%@/ \n",
          HALF_LINE_START,
          HALF_LINE_START,
          url,
          method,
          [params description],
          LINE_START);
    
}

+ (void)printResponseDataForDebugWithUrl:(NSString *)url params:(NSDictionary *)params method:(WSServiceRequestMethod)requestMethod responseData:(id)response
{
    NSString *method;
    switch (requestMethod) {
        case WSServiceRequestMethodGet:
        {
            method = @"GET";
        }
            break;
        case WSServiceRequestMethodPOST:
        {
            method = @"POST";
        }
            break;
        case WSServiceRequestMethodPOSTBODY:
        {
            method = @"POST_BODY";
        }
            break;
        case WSServiceRequestMethodPatch:
        {
            method = @"PATCH";
        }
            break;
        default:
            break;
    }
    NSMutableString *formatParams = [NSMutableString string];
    for (id key in params.allKeys) {
        id value = [params objectForKey:key];
        [formatParams appendFormat:@"%@=%@&", key, value];
    }
    NSString *paramsStr;
    if (formatParams.length > 1) {
        paramsStr  = [formatParams substringToIndex:formatParams.length - 1];
    }
    NSString *jsonStr = @"";
    if (response) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:response
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    // 打印json格式的响应报文，方便观看
    
    // 查看对应的请求url
    NSLog(@"\n/%@响应报文:%@/\n"
          "response：\n"
          "%@ \n"
          "request:\n"
          "{ \n  "
          "url:%@ \n  "
          "method:%@ \n  "
          "params:%@ \n  "
          "} \n"
          "浏览器URL:%@ \n"
          "/%@/ \n",
          HALF_LINE_START,
          HALF_LINE_START,
          jsonStr,
          url,
          method,
          params,
          [NSString stringWithFormat:@"%@?%@", url, paramsStr],
          LINE_START
          );
}

+ (void)printRequestFailDataForDebugWithUrl:(NSString *)url params:(NSDictionary *)params method:(WSServiceRequestMethod)requestMethod error:(NSError *)error
{
    NSString *method;
    switch (requestMethod) {
        case WSServiceRequestMethodGet:
        {
            method = @"GET";
        }
            break;
        case WSServiceRequestMethodPOST:
        {
            method = @"POST";
        }
            break;
        case WSServiceRequestMethodPOSTBODY:
        {
            method = @"POST_BODY";
        }
            break;
        default:
            break;
    }
    NSString *paramsStr = @"";
    NSMutableString *formatParams = [NSMutableString string];
    for (id key in params.allKeys) {
        id value = [params objectForKey:key];
        [formatParams appendFormat:@"%@=%@&", key, value];
    }
    if (formatParams.length > 0) {
        paramsStr = [formatParams substringToIndex:formatParams.length - 1];;
    }
    
    //请求有错误
    NSLog(@"/%@请求失败!%@/ \n"
          "request: \n"
          "{ \n"
          "error:%@, \n"
          "url:%@, \n"
          "method:%@, \n"
          "params:%@, \n"
          "} \n"
          "浏览器URL: \n"
          "%@ \n"
          "/%@/ \n",
          HALF_LINE_START,
          HALF_LINE_START,
          error,
          url,
          method,
          params,
          [NSString stringWithFormat:@"%@?%@", url, paramsStr],
          LINE_START);
    
}

@end
