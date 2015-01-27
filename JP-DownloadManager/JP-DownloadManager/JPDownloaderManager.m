//
//  JPDownloaderManager.m
//  JP-DownloadManager
//
//  Created by soulPo on 15/1/24.
//  Copyright (c) 2015年 soulPo. All rights reserved.
//

#import "JPDownloaderManager.h"
#import "JPDownloader.h"

@interface JPDownloaderManager()
/** 下载操作缓冲池 */
@property (nonatomic, strong) NSMutableDictionary *downloaderCache;

/** 失败的回调属性 */
@property (nonatomic, copy) void (^failedBlock) (NSString *);
@end

@implementation JPDownloaderManager

- (NSMutableDictionary *)downloaderCache {
    if (_downloaderCache== nil) {
        _downloaderCache = [[NSMutableDictionary alloc]init];
    }
    return _downloaderCache;
}


/**
 每实例化一个 HMDownloader 对应一个文件的下载操作！
 
 如果该操作没有执行完成，不需要再次开启！
 
 解决思路：下载操作缓冲池
 */
+ (instancetype)sharedDownloaderManager {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (void)downloadWithURL:(NSURL *)url progress:(void (^)(float))progress completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed {
    self.failedBlock = failed;
    
    JPDownloader *downloader = self.downloaderCache[url.path];
    
    if (downloader != nil) {
        //
        NSLog(@"正在拼命加载中，请稍等");
        return;
    }
    
    // 传递 block 的参数
    /**
     下载完成之后清除下载操作
     
     问题：下载完成是异步的回调
     */
    downloader = [[JPDownloader alloc]init];
    
    // 添加下载操作到缓冲池
    [self.downloaderCache setObject:downloader forKey:url.path];
    
    
    [downloader downloadWithURL:url progress:progress completion:^(NSString *filePath) {
        // 1. 从缓冲池中删除任务
        [self.downloaderCache removeObjectForKey:url.path];
        
        // 2. 判断调用方是否传递了completion
        if (completion) {
            completion(filePath);
        }
        
    } failed:failed];
    
}

- (void)pauseWithURL:(NSURL *)url {
    JPDownloader *downloader = self.downloaderCache[url.path];
    
    if (downloader == nil) {
        if (self.failedBlock) {
            self.failedBlock([NSString stringWithFormat:@"操作不存在，无需暂停--%@",[NSThread currentThread]]);
        }
        //        NSLog(@"操作不存在，无需暂停");
        return;
    }
    
    [downloader pause];
    
    [self.downloaderCache removeObjectForKey:url.path];
    
}
@end

