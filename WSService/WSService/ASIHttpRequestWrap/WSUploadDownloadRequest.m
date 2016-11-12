//
//  WSUploadDownloadRequest.m
//  ASIHttpRequestProj
//
//  Created by wrs on 15/7/28.
//  Copyright (c) 2015年 wrs. All rights reserved.
//

#import "WSUploadDownloadRequest.h"


@implementation WSUploadDownloadRequest

+ (instancetype)sharedWSUploadDownloadRequest
{
    static WSUploadDownloadRequest *instance;
    static dispatch_once_t demoglobalclassonce;
    dispatch_once(&demoglobalclassonce, ^{
        instance = [[WSUploadDownloadRequest alloc] init];
    });
    return instance;
}

@end
