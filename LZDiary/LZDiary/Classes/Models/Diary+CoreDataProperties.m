//
//  Diary+CoreDataProperties.m
//  LZDiary
//
//  Created by comst on 16/9/23.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "Diary+CoreDataProperties.h"

@implementation Diary (CoreDataProperties)

+ (NSFetchRequest<Diary *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Diary"];
}

@dynamic content;
@dynamic createDate;
@dynamic location;
@dynamic month;
@dynamic title;
@dynamic year;

@end
