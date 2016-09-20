//
//  LZVerticalLabel.h
//  LZDiary
//
//  Created by comst on 16/9/20.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZVerticalLabel : UILabel
- (instancetype)initWithFont:(NSString *)fontName fontsize:(CGFloat)fontsize text:(NSString *)text lineHeight:(CGFloat)lineHeight;
- (void)resizeLabelWithFont:(NSString *)fontName fontSize:(CGFloat)fontsize text:(NSString *)text lineHeight:(CGFloat)lineHeight;

- (void)updateText:(NSString *)text;

- (void)updateColor:(UIColor*)color;

@end
