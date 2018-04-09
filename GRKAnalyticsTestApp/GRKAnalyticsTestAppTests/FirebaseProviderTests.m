//
//  FirebaseProviderTests.m
//  GRKAnalyticsTestAppTests
//
//  Created by Levi Brown on 4/9/18.
//  Copyright © 2018 Levi Brown. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GRKFirebaseProvider.h"

@interface GRKFirebaseProvider ()

- (nullable NSString *)cropString:(nullable NSString *)string maxLength:(NSUInteger)maxLength;

@end

@interface FirebaseProviderTests : XCTestCase

@property (nonatomic,strong) GRKFirebaseProvider *provider;

@end

@implementation FirebaseProviderTests

- (void)setUp {
    [super setUp];
	
	self.provider = [[GRKFirebaseProvider alloc] initWithConfiguration:nil];
}

- (void)tearDown {

	self.provider = nil;
	
    [super tearDown];
}

- (void)testCropString100 {
	
	NSString *inString = @"";
	NSUInteger maxLength = 0;
	
	NSString *outString = [self.provider cropString:inString maxLength:maxLength];
	
	XCTAssertTrue(outString != nil, @"Unexpectedly recieved nil output.");
	XCTAssertTrue(outString.length <= maxLength, @"outString.length (%d) unexpectedly greater than maxLength (%d).", (int)outString.length, (int)maxLength);
}

- (void)testCropString200 {
	
	NSString *inString = @"a";
	NSUInteger maxLength = 0;
	
	NSString *outString = [self.provider cropString:inString maxLength:maxLength];

	XCTAssertTrue(outString != nil, @"Unexpectedly recieved nil output.");
	XCTAssertTrue(outString.length <= maxLength, @"outString.length (%d) unexpectedly greater than maxLength (%d).", (int)outString.length, (int)maxLength);
}

- (void)testCropString300 {
	
	NSString *inString = @"abcdeefghijklmnop";
	NSUInteger maxLength = 1;
	
	NSString *outString = [self.provider cropString:inString maxLength:maxLength];

	XCTAssertTrue(outString != nil, @"Unexpectedly recieved nil output.");
	XCTAssertTrue(outString.length <= maxLength, @"outString.length (%d) unexpectedly greater than maxLength (%d).", (int)outString.length, (int)maxLength);
}

@end
