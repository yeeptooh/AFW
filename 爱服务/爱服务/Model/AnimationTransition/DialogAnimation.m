//
//  DialogAnimation.m
//  爱服务
//
//  Created by 张冬冬 on 16/6/29.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "DialogAnimation.h"

@interface DialogAnimation()
@property (nonatomic, assign) DialogAnimationType type;
@property (nonatomic, assign) CGFloat duration;
@end
@implementation DialogAnimation
+ (instancetype)dialogAnimationWithType:(DialogAnimationType)type
                               duration:(CGFloat)duration {
    DialogAnimation *dialogAnimation = [[DialogAnimation alloc]init];
    dialogAnimation.type = type;
    dialogAnimation.duration = duration;
    
    
    return dialogAnimation;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.type) {
        case DialogAnimationTypePresent: {
            [self present:transitionContext];
        }
            break;
        case DialogAnimationTypeDismiss: {
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
    
    toView.frame = CGRectMake(20, 120, Width - 40, Height - 200);
    toView.layer.transform = CATransform3DScale(toView.layer.transform, 1, 0.01, 1);
    toView.layer.opacity = 0;
    POPBasicAnimation *toViewOpacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
//    toViewOpacityAnimation.fromValue = @(0.0);
    toViewOpacityAnimation.toValue = @(1.0);
    
    [toView.layer pop_addAnimation:toViewOpacityAnimation forKey:@"toViewOpacityAnimation"];
    
    [[transitionContext containerView] addSubview:dimmingView];
    [[transitionContext containerView] addSubview:toView];
    
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    
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
    
    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    offscreenAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 0.0)];
    [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
//        [UIView animateWithDuration:0.2 animations:^{
//            fromView.alpha = 0;
//        }completion:^(BOOL finished) {
//            
//        }];
        //        [[transitionContext containerView].subviews[0] removeFromSuperview];
    }];
    
//    POPBasicAnimation *fromViewOpacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
//    fromViewOpacityAnimation.toValue = @(0.0);
////    fromViewOpacityAnimation.toValue = @(1.0);
//    
//    [fromView.layer pop_addAnimation:fromViewOpacityAnimation forKey:@"fromViewOpacityAnimation"];
//    [UIView animateWithDuration:self.duration animations:^{
//        fromView.alpha = 0;
//    }];
    [fromView.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    
}

@end
