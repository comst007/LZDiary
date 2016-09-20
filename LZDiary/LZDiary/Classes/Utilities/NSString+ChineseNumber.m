//
//  NSString+ChineseNumber.m
//  LZDiary
//
//  Created by comst on 16/9/7.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "NSString+ChineseNumber.h"

@implementation NSString (ChineseNumber)

- (NSString *)parseToChineseNumber{
    
    NSString *sum = @"";
    NSString *res = nil;
    
    NSInteger len = self.length;
    
    for (NSInteger i = 0; i < len; i ++) {
        
        res = [[self substringWithRange:NSMakeRange(i, 1)] parseToSingleChinesNumber];
        
        sum = [sum stringByAppendingString:res];
        
    }
    
    return sum ;
}

- (NSString *)parseToSingleChinesNumber{
    
    switch ([self characterAtIndex:0]) {
            
        case  '0':
            return @"零";
            break;
        
        case  '1':
            return @"一";
            break;
        
        case  '2':
            return @"二";
            break;
            
        case  '3':
            return @"三";
            break;
        
        case  '4':
            return @"四";
            break;
        
        case  '5':
            return @"五";
            break;
        
        case  '6':
            return @"六";
            break;
            
        case  '7':
            return @"七";
            break;
        
        case  '8':
            return @"八";
            break;
            
        case  '9':
            return @"九";
            break;
            
        default:
            break;
    }
    return @"";
}

@end
