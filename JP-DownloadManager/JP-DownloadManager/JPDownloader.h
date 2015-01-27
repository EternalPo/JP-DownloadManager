//
//  JPDownloader.h
//  JP-DownloadManager
//
//  Created by soulPo on 15/1/24.
//  Copyright (c) 2015年 soulPo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPDownloader : NSObject


/**
 *  下载操作
 *
 *  @param url        下载资源路径
 *  @param progress   下载进度回调
 *  @param completion 成功回调
 *  @param failed     错误回调
 */
- (void)downloadWithURL:(NSURL *)url progress:(void (^)(float progress))progress completion:(void(^)(NSString *filePath))completion failed:(void(^)(NSString *errorMessage))failed;

- (void)pause;
@end
