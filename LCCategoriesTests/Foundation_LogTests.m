//
//  Foundation_LogTests.m
//  LCCategories
//
//  Created by Liu-Mac on 2/4/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Foundation_LogTests : XCTestCase

@end

@implementation Foundation_LogTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    NSDictionary *dict = @{@"我是": @"很牛逼的", @"我是": @"很牛逼的",
                           @"字典": @{@"我是": @"很牛逼的", @"我是": @"很牛逼的"},
                           @"数组": @[@"来吧", @"测试我吧"]
                           };
    
    NSArray *array = @[@"我是", @"很牛逼的", dict];
    
    NSLog(@"%@", dict);
    NSLog(@"%@", array);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
