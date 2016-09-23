//
//  UIButton+LZDiaryButton.m
//  LZDiary
//
//  Created by comst on 16/9/20.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "UIButton+LZDiaryButton.h"

@implementation UIButton (LZDiaryButton)
+ (UIButton *)diarybuttonWithText:(NSString *)title fontSize:(CGFloat)fontSize width:(CGFloat)width normalImageName:(NSString *)normalName hightlightImageName:(NSString *)highlightName{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, width, width);
    
    UIFont *font = [UIFont fontWithName:@"Wyue-GutiFangsong-NC" size:fontSize];
    
    UIColor *textColor = [UIColor whiteColor];
    NSDictionary *attr = @{NSForegroundColorAttributeName : textColor , NSFontAttributeName : font};
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:title attributes:attr];
    
    [btn setAttributedTitle:attrText forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:normalName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highlightName] forState:UIControlStateHighlighted];
    
    return btn;

 
}
@end
