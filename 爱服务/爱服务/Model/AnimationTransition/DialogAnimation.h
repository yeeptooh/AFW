//
//  DialogAnimation.h
//  爱服务
//
//  Created by 张冬冬 on 16/6/29.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DialogAnimationType) {
    DialogAnimationTypePresent,
    DialogAnimationTypeDismiss
};
@interface DialogAnimation : NSObject
<
UIViewControllerAnimatedTransitioning
>
+ (instancetype)dialogAnimationWithType:(DialogAnimationType)type
                               duration:(CGFloat)duration;
@end
