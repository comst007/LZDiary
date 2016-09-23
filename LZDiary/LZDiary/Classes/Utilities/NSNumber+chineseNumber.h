//
//  NSNumber+chineseNumber.h
//  LZDiary
//
//  Created by comst on 16/9/22.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (chineseNumber)
- (NSString *)parseToChineseNumber;

- (NSString *)parseToChineseNumberWithUnit;
@end
