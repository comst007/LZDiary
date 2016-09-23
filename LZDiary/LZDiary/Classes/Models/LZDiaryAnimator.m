//
//  LZDiaryAnimator.m
//  LZDiary
//
//  Created by comst on 16/9/21.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZDiaryAnimator.h"


@implementation LZDiaryAnimator
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIView *containerView = [transitionContext containerView];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *fromView = fromVC.view;
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = toVC.view;
    
    toView.alpha = 0 ;
    
    if (self.op == UINavigationControllerOperationPop) {
        toView.transform = CGAffineTransformMakeScale(1, 1);
    }else{
        toView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    }
    
    [containerView insertSubview:toView aboveSubview:fromView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        if (self.op == UINavigationControllerOperationPop) {
            fromView.transform = CGAffineTransformMakeScale(3.3, 3.3);
        }else{
            toView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
        toView.alpha = 1 ;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}
@end
