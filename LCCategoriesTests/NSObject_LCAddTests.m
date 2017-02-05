//
//  NSObject_LCAddTests.m
//  LCCategories
//
//  Created by Liu-Mac on 2/5/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+LCAdd.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

@interface NSObject_LCAddTests : XCTestCase

@end

@implementation NSObject_LCAddTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testClassInheritChain {
    
    NSLog(@"\n");
    
    NSLog(@"%@", [UITableView lc_classInheritChain]);

    NSLog(@"\n");
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
