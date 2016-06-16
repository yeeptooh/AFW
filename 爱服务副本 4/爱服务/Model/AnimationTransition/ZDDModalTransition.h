//
//  ZDDModalTransition.h
//  爱服务
//
//  Created by 张冬冬 on 16/4/25.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ZDDModalTransitionType) {
    ZDDModalTransitionTypePresent,
    ZDDModalTransitionTypeDismiss
};

@interface ZDDModalTransition : NSObject
<
UIViewControllerAnimatedTransitioning
>

+ (instancetype)transitionWithType:(ZDDModalTransitionType)type
                          duration:(CGFloat)duration;

@end
