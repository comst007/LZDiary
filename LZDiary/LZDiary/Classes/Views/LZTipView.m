//
//  LZTipView.m
//  LZDiary
//
//  Created by comst on 16/9/23.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZTipView.h"

@interface LZTipView ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *okButton;
@end
@implementation LZTipView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor whiteColor];
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 280)];
        [self addSubview:self.imgView];
        self.imgView.image = [UIImage imageNamed:@"tip"];
        self.imgView.center = self.center;
        
        self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        
        [self addSubview:self.okButton];
        
        self.okButton.center = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 40 - 20);
        
        [self.okButton setImage:[UIImage imageNamed:@"tipOk"] forState:UIControlStateNormal];
        
        [self.okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.imgView.alpha = 0;
        self.okButton.alpha = 0;
        
        
    }
    
    return self;
}

- (void)okAction{
    
    [self hide];
}

- (void)show{
    
    CGPoint destCenter = self.imgView.center;
    
    CGPoint sourceCenter = CGPointMake(destCenter.x, - 140);
    self.imgView.center = sourceCenter;
    self.imgView.alpha = 1 ;
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.imgView.center = destCenter;
        
    } completion:^(BOOL finished) {
        
        self.okButton.alpha = 1 ;
    }];
}

- (void)hide{
    
    self.okButton.alpha = 0;
    CGPoint sourceCenter = self.imgView.center;
    CGPoint destCenter = CGPointMake(sourceCenter.x, self.frame.size.height + 140);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.imgView.center = destCenter;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
