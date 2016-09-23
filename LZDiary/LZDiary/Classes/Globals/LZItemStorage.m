//
//  LZItemStorage.m
//  LZDiary
//
//  Created by comst on 16/9/22.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZItemStorage.h"



//指向全局唯一的实例对象
static LZItemStorage *instance = nil;


@interface LZItemStorage ()

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation LZItemStorage


#pragma mark - user method 

- (NSArray *)allItems{
    
    return self.items;
}

- (void)addNewItem:(LZtmpItem *)newItem{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Diary" inManagedObjectContext:self.context];
    
    Diary *newDiary = [NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:self.context];
    
    newDiary.title = newItem.title;
    newDiary.content = newItem.content;
    newDiary.location = newItem.location;
    newDiary.year = @(newItem.year);
    newDiary.month = @(newItem.month);
    newDiary.createDate = newItem.createDate;
    
    [self.context save:nil];
    
    _items = nil;
    [self items];
}

- (void)deleteItem:(Diary *)item{
    
    [self.context deleteObject:item];
    
    [self.context save:nil];
    
    _items = nil;
    
    [self items];
    
}

- (void)saveItems{
    [self.context save:nil];
}

- (NSArray *)allYear{
    
    NSArray *resArr = [self.items valueForKeyPath:@"year"];
    NSSet *resSet = [[NSSet alloc] initWithArray:resArr];
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    for (NSNumber *num in resSet) {
        [arrM addObject:num];
    }
    
    [arrM sortUsingComparator:^NSComparisonResult(NSNumber *  _Nonnull obj1, NSNumber *  _Nonnull obj2) {
        
        return [obj1 compare:obj2];
    }];
    
    return arrM;
}

- (NSArray *)allMonthInYear:(NSInteger)year {
    
    NSMutableArray *yearArrM = [NSMutableArray array];
    
    [[self allItems] enumerateObjectsUsingBlock:^(Diary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.year integerValue] == year) {
            [yearArrM addObject:obj];
        }
    }];
    
    NSArray *resArr = [yearArrM valueForKeyPath:@"month"];
    NSSet *resSet = [[NSSet alloc] initWithArray:resArr];
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    for (NSNumber *num in resSet) {
        [arrM addObject:num];
    }
    
    [arrM sortUsingComparator:^NSComparisonResult(NSNumber *  _Nonnull obj1, NSNumber *  _Nonnull obj2) {
        
        return [obj2 compare:obj1];
    }];
    
    return arrM;
}

- (NSArray *)allItemsWithYear:(NSInteger)year month:(NSInteger)month{
    
    NSMutableArray * arrM = [NSMutableArray array];
    
    [self.allItems enumerateObjectsUsingBlock:^(Diary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ((obj.year.integerValue == year && obj.month.integerValue == month)) {
            
            [arrM addObject:obj];
            
        }
    }];
    
    [arrM sortUsingComparator:^NSComparisonResult(Diary*  _Nonnull obj1, Diary*  _Nonnull obj2) {
        
        return [obj2.createDate compare:obj1.createDate];
        
    }];
    
    return arrM;
}

- (NSArray *)allTitle{
    
    NSArray *resArr = [self.items valueForKeyPath:@"title"];
    
    return resArr;
}


- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:18];
    [comps setMinute:30];
    [comps setSecond:0];
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (void)productDatas{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * res = [defaults valueForKey:@"firstStart"];
    if ([res boolValue] == YES) {
        return;
    }
      NSEntityDescription *entity = [NSEntityDescription entityForName:@"Diary" inManagedObjectContext:self.context];
    
      Diary *item =  (Diary *)[NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:self.context];
    item.title = @"静夜思";
    item.content = @"窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。";
    item.location = @"深圳";
    item.year = @2016;
    item.month = @9;//15
    item.createDate = [self dateWithYear:2016 month:9 day:15];
    
    Diary *item3 =  (Diary *)[NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:self.context];
    item3.title = @"端午节";
    item3.content = @"节分端午自谁言。\n万古传闻为屈原。\n堪笑楚江空渺渺。\n不能洗得直臣冤。";
    item3.location = @"深圳";
    item3.year = @2016;
    item3.month = @6;//9
    item3.createDate = [self dateWithYear:2016 month:6 day:9];

    [self.context save:nil];
    
    [defaults setValue:@(YES) forKey:@"firstStart"];
    [defaults synchronize];
    
    return;
}
/*
- (void)setUp{
    LZDiaryItem *item = [[LZDiaryItem alloc] init];
    item.title = @"静夜思";
    item.content = @"窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。";
    item.location = @"深圳";
    item.year = 2016;
    item.month = 9;//15
    item.createDate = [self dateWithYear:2016 month:9 day:15];
   
    
    LZDiaryItem *item2 = [[LZDiaryItem alloc] init];
    item2.title = @"清明节";
    item2.content = @"清明时节雨纷纷。\n路上行人欲断魂。\n借问酒家何处有。\n牧童遥指杏花村。";
    item2.location = @"深圳";
    item2.year = 2016;
    item2.month = 4;//4
    item2.createDate = [self dateWithYear:2016 month:4 day:4];

    
    LZDiaryItem *item3 = [[LZDiaryItem alloc] init];
    item3.title = @"端午节";
    item3.content = @"节分端午自谁言。\n万古传闻为屈原。\n堪笑楚江空渺渺。\n不能洗得直臣冤。";
    item3.location = @"深圳";
    item3.year = 2016;
    item3.month = 6;//9
    item3.createDate = [self dateWithYear:2016 month:6 day:9];

    
    LZDiaryItem *item4 = [[LZDiaryItem alloc] init];
    item4.title = @"元宵节";
    item4.content = @"月上柳梢头。\n人约黄昏后。";
    item4.location = @"深圳";
    item4.year = 2016;
    item4.month = 2;//22
    item4.createDate = [self dateWithYear:2016 month:2 day:22];

    
    LZDiaryItem *item5 = [[LZDiaryItem alloc] init];
    item5.title = @"除夕夜";
    item5.content = @"爆竹声中一岁除。\n春风送暖如屠苏。\n千门万户瞳痛日。\n总把新桃换旧符。";
    item5.location = @"深圳";
    item5.year = 2016;
    item5.month = 2; //7
    item5.createDate = [self dateWithYear:2016 month:2 day:7];
    
    LZDiaryItem *item6 = [[LZDiaryItem alloc] init];
    item6.title = @"除夕夜(new)";
    item6.content = @"爆竹声中一岁除。\n春风送暖如屠苏。\n千门万户瞳痛日。\n总把新桃换旧符。";
    item6.location = @"深圳";
    item6.year = 2016;
    item6.month = 2; //7
    item6.createDate = [self dateWithYear:2016 month:2 day:17];
 
     [_items addObject:item];
     [_items addObject:item2];
     [_items addObject:item3];
     [_items addObject:item4];
     [_items addObject:item5];
     [_items addObject:item6];
     
    
    
}
*/

- (NSArray *)items{
    if (!_items) {
        /*
        _items = [[NSMutableArray alloc] init];
        [self setUp];
         */
        NSFetchRequest *request = [Diary fetchRequest];
        NSArray *res = [self.context executeFetchRequest:request error:nil];
        if (res.count == 0) {
            [self productDatas];
            res = [self.context executeFetchRequest:request error:nil];
        }
        _items = res;
        
    }
    return _items;
}

//保证单例对象无论创建多少次，永远都只有一份，多线程下要保证只有一个线程可以创建成功
+ (instancetype) allocWithZone:(struct _NSZone *)zone{
    
    //该方法只会执行一次，所以可以保障只会创建一个实例
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
        
        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
        instance.context = del.managedObjectContext;
        
    });
    
    return instance;
}

//用于返回单例对象的实例
+ (instancetype)sharedItemStorage {
    
    return [[self alloc] init ];
}

//对象在copy的过程中也只会返回同一个实例
- (id)copy{
    
    return instance;
}

// 如果是MRC还需要实现跟对象引用计数相关的几个方法

#if !__has_feature(objc_arc)

- (oneway void)release{
    //甚么也不做
}

- (instancetype)autorelease{
    return instance;
}

- (instancetype)retain{
    return instance;
}

- (NSUInteger)retainCount{
    return 1;
}

#endif


@end



