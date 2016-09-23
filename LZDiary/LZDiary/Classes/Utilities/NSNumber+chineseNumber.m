//
//  NSNumber+chineseNumber.m
//  LZDiary
//
//  Created by comst on 16/9/22.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "NSNumber+chineseNumber.h"
#import "NSString+ChineseNumber.h"
@implementation NSNumber (chineseNumber)
- (NSString *)parseToChineseNumber{
    NSString *numStr = [NSString stringWithFormat:@"%@", self];
    
    return [numStr parseToChineseNumber];
}

- (NSString *)parseToChineseNumberWithUnit{
    NSString *numStr = [NSString stringWithFormat:@"%@", self];
    
    return [numStr parseToChineseNumberWithUnit];
}

@end
