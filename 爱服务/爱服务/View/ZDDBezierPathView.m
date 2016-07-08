//
//  ZDDBezierPathView.m
//  爱服务
//
//  Created by 张冬冬 on 16/7/7.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "ZDDBezierPathView.h"

@implementation ZDDBezierPathView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2, self.bounds.size.width - 4, self.bounds.size.width - 4) cornerRadius:5];
    
    [[UIColor whiteColor] setStroke];
//    [[UIColor whiteColor] setFill];
    [path setLineWidth:1];
    [path stroke];
}


@end
