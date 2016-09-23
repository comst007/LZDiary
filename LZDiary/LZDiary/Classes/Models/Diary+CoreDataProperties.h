//
//  Diary+CoreDataProperties.h
//  LZDiary
//
//  Created by comst on 16/9/23.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "Diary+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Diary (CoreDataProperties)

+ (NSFetchRequest<Diary *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, copy) NSString *location;
@property (nullable, nonatomic, copy) NSNumber *month;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSNumber *year;

@end

NS_ASSUME_NONNULL_END
