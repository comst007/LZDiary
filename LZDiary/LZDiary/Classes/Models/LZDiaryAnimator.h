//
//  LZDiaryAnimator.h
//  LZDiary
//
//  Created by comst on 16/9/21.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LZDiaryAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation op;
@end
