//
//  LZDiaryTests.m
//  LZDiaryTests
//
//  Created by comst on 16/9/7.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+ChineseNumber.h"
#import "LZItemStorage.h"
@interface LZDiaryTests : XCTestCase

@end

@implementation LZDiaryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSArray *res = [[LZItemStorage sharedItemStorage] allYear];
    
    
    NSLog(@"hello");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
