//
//  JPProgressView.m
//  JP-DownloadManager
//
//  Created by soulPo on 15/1/24.
//  Copyright (c) 2015年 soulPo. All rights reserved.
//

#import "JPProgressView.h"

@interface JPProgressView ()

@property (weak, nonatomic) UILabel *progressLalel;

@end

@implementation JPProgressView

-(void)awakeFromNib {
    self.lineWidth = 10;
    
    UILabel *progressLabel = [[UILabel alloc]init];
    progressLabel.textColor = [UIColor blueColor];
    
    progressLabel.textAlignment = NSTextAlignmentCenter;
    
    progressLabel.font = [UIFont systemFontOfSize:15.0];
    
    [self addSubview:progressLabel];
    self.progressLalel = progressLabel;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.progressLalel.frame = self.bounds;
    
}
- (void)drawRect:(CGRect)rect {
    
    
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    
    // 圆心
    CGPoint center = CGPointMake(w * 0.5, h * 0.5);
    // 圆半径
    CGFloat radiu = (MIN(w, h) - self.lineWidth) * 0.5;
    
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle = self.progress * 2 * M_PI + startAngle;
    
    // 贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radiu startAngle:startAngle endAngle:endAngle clockwise:YES];
    path.lineWidth = self.lineWidth * 0.5;
    path.lineCapStyle = kCGLineCapRound;
    
    // 设置颜色
    [[UIColor redColor] setStroke];
    
    // 绘制线路
    [path stroke];
}

- (void)setProgress:(float)progress {
    _progress = progress;
    
    // 设置标题
    
    self.progressLalel.text = [NSString stringWithFormat:@"%.2f", progress*100];

    
    // 刷新视图
    [self setNeedsDisplay];
}

@end
