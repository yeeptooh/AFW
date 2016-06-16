//
//  ShareAnimation.h
//  爱服务
//
//  Created by 张冬冬 on 16/4/28.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShareAnimationType) {
    ShareAnimationTypePresent,
    ShareAnimationTypeDismiss
};
@interface ShareAnimation : NSObject
<
UIViewControllerAnimatedTransitioning
>
+ (instancetype)shareAnimationWithType:(ShareAnimationType)type
                              duration:(CGFloat)duration
                         presentHeight:(CGFloat)presentHeight;

@end
