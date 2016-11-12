//
//  WSUploadDownloadRequest.h
//  ASIHttpRequestProj
//
//  Created by wrs on 15/7/28.
//  Copyright (c) 2015年 wrs. All rights reserved.
// 保存上传、下载的requst,方便取消上传、下载时取得request

#import <Foundation/Foundation.h>

@interface WSUploadDownloadRequest : NSObject

+ (instancetype)sharedWSUploadDownloadRequest;

@property (strong, nonatomic) NSMutableDictionary *uploadRequestDic;
@property (strong, nonatomic) NSMutableDictionary *downloadRequestDic;

@end
