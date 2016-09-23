//
//  UIButton+LZDiaryButton.h
//  LZDiary
//
//  Created by comst on 16/9/20.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LZDiaryButton)
+ (UIButton *)diarybuttonWithText:(NSString *)title fontSize:(CGFloat)fontSize width:(CGFloat)width normalImageName:(NSString *)normalName hightlightImageName:(NSString *)hightName;
@end
