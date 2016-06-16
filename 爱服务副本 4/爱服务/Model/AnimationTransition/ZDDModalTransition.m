//
//  ZDDModalTransition.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/25.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "ZDDModalTransition.h"

@interface ZDDModalTransition ()
@property (nonatomic, assign) ZDDModalTransitionType type;
@property (nonatomic, assign) CGFloat duration;
@end

@implementation ZDDModalTransition
+ (instancetype)transitionWithType:(ZDDModalTransitionType)type
                          duration:(CGFloat)duration{
    
    ZDDModalTransition *transition = [[ZDDModalTransition alloc]init];
    
    transition.type = type;
    transition.duration = duration;
    
    return transition;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.type) {
        case ZDDModalTransitionTypePresent: {
            [self present:transitionContext];
            break;
        }
        case ZDDModalTransitionTypeDismiss: {
            [self dismiss:transitionContext];
            break;
        }
        default:
            break;
    }
}

- (void)present:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.userInteractionEnabled = NO;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    //截图
    UIView *tempView = [fromView snapshotViewAfterScreenUpdates:NO];
    tempView.frame = fromView.frame;
    
    UIView *dimmingView = [[UIView alloc]initWithFrame:fromView.bounds];
    dimmingView.layer.opacity = 0.0f;
    dimmingView.backgroundColor = color(20, 20, 20, 1);
    
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    toView.frame = CGRectMake(0, 0, Width*0.1, Width*0.1);
    toView.center = CGPointMake(Width/2, Height/2 - 60);
    
    [[transitionContext containerView] addSubview:tempView];
    [[transitionContext containerView] addSubview:dimmingView];
    [[transitionContext containerView] addSubview:toView];
    
//    POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
//    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(Width - 10, Width - 60)];
//    sizeAnimation.springBounciness = 15;
//    [sizeAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
//        [transitionContext completeTransition:YES];
//    }];
    
    POPBasicAnimation *sizeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(Width - 10, Width - 120)];
    [sizeAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
    
//    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    scaleAnimation.springBounciness = 25;
//    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.4)];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.6);
    
    [toView.layer pop_addAnimation:sizeAnimation forKey:@"sizeAnimation"];
//    [toView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];

    
}

- (void)dismiss:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    toView.userInteractionEnabled = YES;
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *containerView = [transitionContext containerView];
    UIView *dimmingView = containerView.subviews[1];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.0);
    
    POPBasicAnimation *fromViewOpacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    fromViewOpacityAnimation.toValue = @(0.0);
    
    
    POPBasicAnimation *sizeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(Width*0.1, Width*0.1)];
    [sizeAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
        [[transitionContext containerView].subviews[0] removeFromSuperview];
    }];
    
    [fromView.layer pop_addAnimation:fromViewOpacityAnimation forKey:@"fromViewOpacityAnimation"];
    [fromView.layer pop_addAnimation:sizeAnimation forKey:@"offscreensizeAnimation"];
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];

}


@end
