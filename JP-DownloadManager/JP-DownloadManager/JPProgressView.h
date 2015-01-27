//
//  JPProgressView.h
//  JP-DownloadManager
//
//  Created by soulPo on 15/1/24.
//  Copyright (c) 2015年 soulPo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPProgressView : UIView
/** 进度 0.0~1.0 */
@property (nonatomic, assign) float progress;
/** 线宽 */
@property (nonatomic, assign) float lineWidth;

@end
