//
//  WSService.m
//  WSService
//
//  Created by wrs on 15/9/2.
//  Copyright (c) 2015年 wrs. All rights reserved.
//

#import "WSBaseService.h"
#import "WSASIHttpRequestWrap.h"
#import "WSAFNetworkingWrap.h"

@implementation WSBaseService

+ (void)requestWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack requestMethod:(WSServiceRequestMethod)requestMethod requestType:(WSServiceRequestType)requestType httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd frameworkType:(WSServiceFrameworkType)frameworkType
{
    switch (frameworkType) {
        case WSServiceFrameworkTypeASIHttpRequest:
        {
            [WSASIHttpRequestWrap requestWithUrl:url params:params header:header tag:0 sucCallBack:sucCallBack failCallBack:failCallBack requestMethod:requestMethod requestType:requestType httpsCerData:httpsCerData cerPwd:cerPwd];
        }
            break;
        case WSServiceFrameworkTypeAFNetworking:
        {
            [WSAFNetworkingWrap requestWithUrl:url params:params header:header sucCallBack:sucCallBack failCallBack:failCallBack requestMethod:requestMethod requestType:requestType httpsCerData:httpsCerData cerPwd:cerPwd];
        }
            break;
        default:
            break;
    }
}

+ (void)uploadFileWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header fileData:(NSData *)data fileName:(NSString *)fileName key:(NSString *)key contentType:(NSString *)contentType sendingCallBack:(void(^)(unsigned long long size, unsigned long long total))sendingCallBack sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack requestMethod:(WSServiceRequestMethod)requestMethod requestType:(WSServiceRequestType)requestType httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd frameworkType:(WSServiceFrameworkType)frameworkType
{
    switch (frameworkType) {
        case WSServiceFrameworkTypeASIHttpRequest:
        {
             [WSASIHttpRequestWrap uploadFileWithUrl:url params:params header:header fileData:data fileName:fileName key:key contentType:contentType sendingCallBack:sendingCallBack sucCallBack:sucCallBack failCallBack:failCallBack requestMethod:requestMethod tag:0 requestType:requestType httpsCerData:httpsCerData cerPwd:cerPwd];
        }
            break;
        case WSServiceFrameworkTypeAFNetworking:
        {
            [WSAFNetworkingWrap uploadFileWithUrl:url params:params fileData:data fileName:fileName key:key contentType:contentType sendingCallBack:sendingCallBack sucCallBack:sucCallBack failCallBack:failCallBack];
        }
            break;
        default:
            break;
    }
}

+ (void)downLoadFileWithUrl:(NSString *)url params:(id)params header:(NSDictionary *)header savePath:(NSString *)savePath tempPath:(NSString *)tempPath receivingCallBack:(void(^)(unsigned long long size, unsigned long long total))receivingCallBack sucCallBack:(void (^)(id result))sucCallBack failCallBack:(void (^)(id error))failCallBack requestMethod:(WSServiceRequestMethod)requestMethod requestType:(WSServiceRequestType)requestType httpsCerData:(NSData *)httpsCerData cerPwd:(NSString *)cerPwd frameworkType:(WSServiceFrameworkType)frameworkType
{
    switch (frameworkType) {
        case WSServiceFrameworkTypeASIHttpRequest:
        {
            [WSASIHttpRequestWrap downLoadFileWithUrl:url params:params header:header savePath:savePath tempPath:tempPath receivingCallBack:receivingCallBack sucCallBack:sucCallBack failCallBack:failCallBack tag:0 requestMethod:requestMethod requestType:requestType httpsCerData:httpsCerData cerPwd:cerPwd];
        }
            break;
        case WSServiceFrameworkTypeAFNetworking:
        {
            [WSAFNetworkingWrap downLoadFileWithUrl:url params:params header:header savePath:savePath receivingCallBack:receivingCallBack sucCallBack:sucCallBack failCallBack:failCallBack];
        }
            break;
        default:
            break;
    }
}

+ (WSServiceRequestMethod)converToServiceRequestMethod:(NSString *)requestMethod
{
    WSServiceRequestMethod resultMethod;
    NSString *tempMethod = [requestMethod uppercaseString];
    if ([tempMethod isEqualToString:@"GET"]) {
        resultMethod = WSServiceRequestMethodGet;
    } else if ([tempMethod isEqualToString:@"POST"]) {
        resultMethod = WSServiceRequestMethodPOST;
    } else if ([tempMethod isEqualToString:@"PATCH"]) {
        resultMethod = WSServiceRequestMethodPatch;
    } else {
        resultMethod = WSServiceRequestMethodNone;
    }
    return resultMethod;
}

+ (NSString *)converToServiceRequestMethodString:(WSServiceRequestMethod)requestMethod
{
    NSString *resultMethod;
    switch (requestMethod) {
        case WSServiceRequestMethodGet:
        {
            resultMethod = @"GET";
        }
            break;
        case WSServiceRequestMethodPOST:
        {
            resultMethod = @"POST";
        }
            break;
        case WSServiceRequestMethodPatch:
        {
            resultMethod = @"PATCH";
        }
            break;
        case WSServiceRequestMethodPOSTBODY:
        {
            resultMethod = @"POST";
        }
            break;
        default:
            break;
    }
    return resultMethod;
}


@end
