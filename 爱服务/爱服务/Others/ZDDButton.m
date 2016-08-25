//
//  ZDDButton.m
//  爱服务
//
//  Created by 张冬冬 on 16/8/10.
//  Copyright © 2016年 张冬冬. All rights reserved.
//
//  
#import "ZDDButton.h"

@implementation ZDDButton
-(void)layoutSubviews {
    [super layoutSubviews];
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    if (iPhone4_4s) {
        center.y = self.imageView.frame.size.height/2;
    }else if (iPhone5_5s) {
        center.y = self.imageView.frame.size.height/2 + 5;
    }else if (iPhone6) {
        center.y = self.imageView.frame.size.height/2 + 7;
    }else {
        center.y = self.imageView.frame.size.height/2 + 10;
    }
    
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    if (iPhone4_4s) {
        newFrame.origin.y = self.imageView.frame.size.height;
    }else if (iPhone5_5s) {
        newFrame.origin.y = self.imageView.frame.size.height + 5;
    }else if (iPhone6) {
        newFrame.origin.y = self.imageView.frame.size.height + 10;
    }else {
        newFrame.origin.y = self.imageView.frame.size.height + 15;
    }
    
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
