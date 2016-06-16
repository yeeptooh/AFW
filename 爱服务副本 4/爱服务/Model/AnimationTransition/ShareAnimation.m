//
//  ShareAnimation.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/28.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "ShareAnimation.h"

@interface ShareAnimation ()
@property (nonatomic, assign) ShareAnimationType type;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat presentHeight;
@end

@implementation ShareAnimation
+ (instancetype)shareAnimationWithType:(ShareAnimationType)type
                              duration:(CGFloat)duration
                         presentHeight:(CGFloat)presentHeight {
    
    ShareAnimation *shareAnimation = [[ShareAnimation alloc]init];
    shareAnimation.type = type;
    shareAnimation.duration = duration;
    shareAnimation.presentHeight = presentHeight;
    
    return shareAnimation;
 
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.type) {
        case ShareAnimationTypePresent: {
            [self present:transitionContext];
        }
            break;
        case ShareAnimationTypeDismiss: {
            [self dismiss:transitionContext];
        }
            break;
        default:
            break;
    }
}

- (void)present:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.userInteractionEnabled = NO;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;

    
    UIView *dimmingView = [[UIView alloc]initWithFrame:fromView.bounds];
    dimmingView.layer.opacity = 0.0f;
    dimmingView.backgroundColor = color(20, 20, 20, 1);
    
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    toView.frame = CGRectMake(0, 0, Width, self.presentHeight);
    toView.center = CGPointMake(Width/2, Height + self.presentHeight/2);
    
    //    [[transitionContext containerView] addSubview:tempView];
    [[transitionContext containerView] addSubview:dimmingView];
    [[transitionContext containerView] addSubview:toView];
    
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(Height - self.presentHeight/2);
    
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
    
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.6);
    
    [toView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
}

- (void)dismiss:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    toView.userInteractionEnabled = YES;
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *containerView = [transitionContext containerView];
    UIView *dimmingView = containerView.subviews[0];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.0);
    
    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    offscreenAnimation.toValue = @(Height + self.presentHeight/2);
    [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
        //        [[transitionContext containerView].subviews[0] removeFromSuperview];
    }];
    [fromView.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    
}



@end
