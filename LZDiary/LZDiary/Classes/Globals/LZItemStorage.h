//
//  LZItemStorage.h
//  LZDiary
//
//  Created by comst on 16/9/22.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"
#import "Diary+CoreDataClass.h"
#import "Diary+CoreDataProperties.h"
#import "LZtmpItem.h"
@interface LZItemStorage : NSObject
+ (instancetype)sharedItemStorage;

- (NSArray *)allItems;

- (void)addNewItem:(LZtmpItem *)newItem;

- (void)deleteItem:(Diary *)item;

- (void)saveItems;

- (NSArray *)allYear ;

- (NSArray *)allMonthInYear:(NSInteger)year ;

- (NSArray *)allItemsWithYear:(NSInteger)year month:(NSInteger)month;

- (NSArray *)allTitle ;

- (void)productDatas;
@end
