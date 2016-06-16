//
//  PresentAnimation.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/12.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "PresentAnimation.h"

@implementation PresentAnimation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.userInteractionEnabled = NO;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
//截图
//    UIView *tempView = [fromView snapshotViewAfterScreenUpdates:NO];
//    tempView.frame = fromView.frame;
    
    UIView *dimmingView = [[UIView alloc]initWithFrame:fromView.bounds];
    dimmingView.layer.opacity = 0.0f;
    dimmingView.backgroundColor = color(20, 20, 20, 1);
    
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    CGFloat height;
    CGFloat width;
    if (iPhone6_plus) {
        height = Height - 420;
        width = Width - 100;
    }else if (iPhone6) {
        height = Height - 400;
        width = Width - 100;
    }else if (iPhone5_5s) {
        height = Height - 350;
        width = Width - 100;
    }else {
        height = Height - 200;
        width = Width - 100;
    }
    toView.frame = CGRectMake(0, 0, width, height);
    toView.center = CGPointMake(Width/2, - Height/2);
    
//    [[transitionContext containerView] addSubview:tempView];
    [[transitionContext containerView] addSubview:dimmingView];
    [[transitionContext containerView] addSubview:toView];
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(transitionContext.containerView.center.y);
    positionAnimation.springBounciness = 10;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.4)];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.6);
    
    [toView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [toView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
}
@end
