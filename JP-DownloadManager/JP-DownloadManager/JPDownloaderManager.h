//
//  JPDownloaderManager.h
//  JP-DownloadManager
//
//  Created by soulPo on 15/1/24.
//  Copyright (c) 2015年 soulPo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPDownloaderManager : NSObject
/**
 *  获取单例
 */
+ (instancetype)sharedDownloaderManager;

/**
 *  下载指定的 URL
 *
 *  block － 可以当作参数传递
 */
- (void)downloadWithURL:(NSURL *)url progress:(void (^)(float progress))progress completion:(void (^)(NSString *filePath))completion failed:(void (^)(NSString *errorMessage))failed;

/**
 *  暂停下载--通过url
 */
- (void)pauseWithURL:(NSURL *)url;
@end
