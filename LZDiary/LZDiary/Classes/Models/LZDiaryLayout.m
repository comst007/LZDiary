//
//  LZDiaryLayout.m
//  LZDiary
//
//  Created by comst on 16/9/20.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZDiaryLayout.h"

extern CGFloat itemWidth;
extern CGFloat itemHeight;

@implementation LZDiaryLayout
- (void)prepareLayout{
    
    [super prepareLayout];
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
}
@end
