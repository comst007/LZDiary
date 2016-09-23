//
//  LZLocation.h
//  LZDiary
//
//  Created by comst on 16/9/21.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LZLocation;

@protocol LZLocation <NSObject>

- (void)locationDidUpdate:(LZLocation *)currentLocation;

@end

@interface LZLocation : NSObject

@property (nonatomic, weak) id<LZLocation> delegate;
@property (nonatomic, copy) NSString *address;
- (instancetype)init ;
@end
