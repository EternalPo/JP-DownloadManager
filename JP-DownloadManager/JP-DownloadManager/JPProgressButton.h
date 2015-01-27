//
//  JPProgressButton.h
//  JP-05-NSSession下载进度
//
//  Created by soulPo on 15/1/19.
//  Copyright (c) 2015年 soulPo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPProgressButton : UIButton
/** 进度 0.0~1.0 */
@property (nonatomic, assign) float progress;
/** 线宽 */
@property (nonatomic, assign) float lineWidth;
@end
