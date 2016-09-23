//
//  UIWebView+LZScreenShot.m
//  LZDiary
//
//  Created by comst on 16/9/22.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "UIWebView+LZScreenShot.h"

@implementation UIWebView (LZScreenShot)
- (UIImage *)screenShot{
    
    CGRect tmpFrame = self.frame;
    
    CGRect newFrame = tmpFrame;
    newFrame.size.width = [self sizeThatFits:[UIScreen mainScreen].bounds.size].width;
    
    self.frame = newFrame;
    
    UIGraphicsBeginImageContextWithOptions([self sizeThatFits:[UIScreen mainScreen].bounds.size], YES, [UIScreen mainScreen].scale);
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.frame = tmpFrame;
    return image;
}
@end
