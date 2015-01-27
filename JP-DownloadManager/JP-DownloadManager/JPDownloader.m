//
//  JPDownloader.m
//  JP-DownloadManager
//
//  Created by soulPo on 15/1/24.
//  Copyright (c) 2015年 soulPo. All rights reserved.
//

#import "JPDownloader.h"

@interface JPDownloader ()<NSURLConnectionDataDelegate>
/**
 *  服务器文件的长度
 */
@property (nonatomic, assign) long long expectedContentLength;
/**
 *  当前本地的文件长度
 */
@property (nonatomic, assign) long long currentContentLength;
/**
 *  拼接的保存在本地的路径
 */
@property (nonatomic, copy) NSString *filePath;

/**
 *  下载url
 */
@property (nonatomic, strong) NSURL *downloadURL;
/**
 *  下载网络连接
 */
@property (nonatomic, strong) NSURLConnection *downloadConnection;

/**
 *  文件输入流
 */
@property (nonatomic, strong) NSOutputStream *fileStream;
/**
 *  下载线程的运行循环
 */
@property (nonatomic, assign) CFRunLoopRef downloadRunLoop;
/*** *block ****/
@property (nonatomic, copy) void (^progressBlcok)(float);

@property (nonatomic, copy) void (^completionBlock)(NSString *);

@property (nonatomic, copy) void (^failedBlock)(NSString *);
@end

@implementation JPDownloader
- (void)pause {
    [self.downloadConnection cancel];
}
- (void)downloadWithURL:(NSURL *)url progress:(void (^)(float))progress completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed {
 
    self.downloadURL = url;
    self.progressBlcok = progress;
    self.completionBlock = completion;
    self.failedBlock = failed;
    
    // 1 检查服务器上的资源大小
    [self serverFileInfoWithURL:url];
    
    // 2 检查本地的文件
    if (![self checkLocalFileInfo]) { // 不需要下载
        if (completion) {
            completion(self.filePath);
        }
        return;
    }
    // 3 如果需要，从服务器上开始续传下载文件
    NSLog(@"需要下载文件从%lld 开始", self.currentContentLength);
    
    [self downloadFile];
    
}
#pragma mark - NSURLConnectionDataDelegate 
/**
 *  接受到服务器的相应
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // 打开文件流
    self.fileStream = [[NSOutputStream alloc]initToFileAtPath:self.filePath append:YES];
    [self.fileStream open];
    
}
/**
 *  接收数据
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // 追加数据
    [self.fileStream write:data.bytes maxLength:data.length];
    // 计算现在进度
    self.currentContentLength += data.length;
    float progress = (float)self.currentContentLength / self.expectedContentLength;
    
    if (self.progressBlcok) {
        
        [NSThread sleepForTimeInterval:10.0];
#warning 是不是所有的更新UI必须要再主线程
        dispatch_async(dispatch_get_main_queue(), ^{
        
            self.progressBlcok(progress);
        });
    }
}

/**
 *  数据接受完成
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.fileStream close];
    CFRunLoopStop(self.downloadRunLoop);

}
/**
 *  出错
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.fileStream close];
    CFRunLoopStop(self.downloadRunLoop);
    if (self.failedBlock) {
        self.failedBlock(error.localizedDescription);
    }
}
#pragma mark - 私有方法

- (void)downloadFile {
    
    // 异步下载
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.downloadURL];
        
        // 设置文字的下载范围
        NSString *rangeStr = [NSString stringWithFormat:@"bytes= %lld-",self.currentContentLength];
        // 设置请求头字段
        [request setValue:rangeStr forHTTPHeaderField:@"Range"];
        
        self.downloadConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        [self.downloadConnection start];
        
        // 启动运行循环
        self.downloadRunLoop = CFRunLoopGetCurrent();
        CFRunLoopRun();
    });
}

/**
 *  检查服务器上的文件大小
 */
- (void)serverFileInfoWithURL:(NSURL *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"HEAD";
    NSURLResponse *respone = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&respone error:NULL];
    
    self.expectedContentLength = respone.expectedContentLength;
    self.filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:respone.suggestedFilename];
}
/**
 *  检查本地文件
 */
- (BOOL)checkLocalFileInfo {

    // 记录本地文件的大小
    long long fileSize = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        // 获取本地文件
        NSDictionary *attributes = [[NSFileManager defaultManager]attributesOfItemAtPath:self.filePath error:NULL];
        
        fileSize = [attributes fileSize];
    }
    
    if (fileSize > self.expectedContentLength) {
        [[NSFileManager defaultManager]removeItemAtPath:self.filePath error:NULL];
        fileSize = 0;
    }
    self.currentContentLength = fileSize;
    
    if (fileSize == self.expectedContentLength) {
        // 不需要下载
        return NO;
    }
    return YES;
}
@end
