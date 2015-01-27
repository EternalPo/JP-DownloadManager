//
//  ViewController.m
//  JP-DownloadManager
//
//  Created by soulPo on 15/1/24.
//  Copyright (c) 2015年 soulPo. All rights reserved.
//

#import "ViewController.h"
#import "JPProgressView.h"
#import "JPDownloader.h"
#import "JPDownloaderManager.h"
#import "JPProgressButton.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet JPProgressView *progress;
@property (weak, nonatomic) IBOutlet JPProgressButton *progress1;

/**
 *  当前执行的下载路径
 */
@property (nonatomic, strong) NSURL *url;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)start {
//    NSString *urlString = @"http://free2.macx.cn:8182/Tools/System/BetterZip234.dmg";
//    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    self.url = [NSURL URLWithString:urlString];
//    
//    [[JPDownloaderManager sharedDownloaderManager] downloadWithURL:self.url progress:^(float progress) {
//        self.progress.progress = progress;
//    } completion:^(NSString *filePath) {
//        NSLog(@"下载完成下载到了%@",filePath);
//    } failed:^(NSString *errorMessage) {
//        NSLog(@"错误%@",errorMessage );
//    }];
}
- (IBAction)pause {
//    [[JPDownloaderManager sharedDownloaderManager] pauseWithURL:self.url];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    JPDownloader *downloader = [[JPDownloader alloc]init];

    NSString *urlString = @"http://localhost/04-NSFileHandle拼接文件.mp4";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.url = [NSURL URLWithString:urlString];
    
    
    [downloader downloadWithURL:self.url progress:^(float progress) {

        self.progress.progress = progress;
        self.progres1.progress = progress;
        NSLog(@"%f,%@", progress, [NSThread currentThread]);
        
    } completion:^(NSString *filePath) {
        NSLog(@"成功下载到了 %@",filePath);
    } failed:^(NSString *errorMessage) {
        NSLog(@"错误%@", errorMessage);
        
    }];
}

@end
