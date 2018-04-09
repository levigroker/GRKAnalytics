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
	
	NSString *inString = nil;
	NSUInteger maxLength = 0;
	
	NSString *outString = [self.provider cropString:inString maxLength:maxLength];
	
	XCTAssertTrue(outString == nil, @"Unexpectedly did not recieve nil output.");
}

- (void)testCropString200 {
	
	NSString *inString = @"";
	NSUInteger maxLength = 0;
	NSUInteger expectedLength = 0;

	NSString *outString = [self.provider cropString:inString maxLength:maxLength];
	
	XCTAssertTrue(outString != nil, @"Unexpectedly recieved nil output.");
	XCTAssertTrue(outString.length <= maxLength, @"outString.length (%d) unexpectedly greater than maxLength (%d).", (int)outString.length, (int)maxLength);
	XCTAssertTrue(outString.length == expectedLength, @"outString.length (%d) unexpectedly not equal to expectedLength (%d).", (int)outString.length, (int)expectedLength);
}

- (void)testCropString300 {
	
	NSString *inString = @"a";
	NSUInteger maxLength = 0;
	NSUInteger expectedLength = 0;

	NSString *outString = [self.provider cropString:inString maxLength:maxLength];

	XCTAssertTrue(outString != nil, @"Unexpectedly recieved nil output.");
	XCTAssertTrue(outString.length <= maxLength, @"outString.length (%d) unexpectedly greater than maxLength (%d).", (int)outString.length, (int)maxLength);
	XCTAssertTrue(outString.length == expectedLength, @"outString.length (%d) unexpectedly not equal to expectedLength (%d).", (int)outString.length, (int)expectedLength);
}

- (void)testCropString400 {
	
	NSString *inString = @"";
	NSUInteger maxLength = 1;
	NSUInteger expectedLength = 0;

	NSString *outString = [self.provider cropString:inString maxLength:maxLength];
	
	XCTAssertTrue(outString != nil, @"Unexpectedly recieved nil output.");
	XCTAssertTrue(outString.length <= maxLength, @"outString.length (%d) unexpectedly greater than maxLength (%d).", (int)outString.length, (int)maxLength);
	XCTAssertTrue(outString.length == expectedLength, @"outString.length (%d) unexpectedly not equal to expectedLength (%d).", (int)outString.length, (int)expectedLength);
}

- (void)testCropString500 {
	
	NSString *inString = @"a";
	NSUInteger maxLength = 1;
	NSUInteger expectedLength = maxLength;

	NSString *outString = [self.provider cropString:inString maxLength:maxLength];
	
	XCTAssertTrue(outString != nil, @"Unexpectedly recieved nil output.");
	XCTAssertTrue(outString.length <= maxLength, @"outString.length (%d) unexpectedly greater than maxLength (%d).", (int)outString.length, (int)maxLength);
	XCTAssertTrue(outString.length == expectedLength, @"outString.length (%d) unexpectedly not equal to expectedLength (%d).", (int)outString.length, (int)expectedLength);
}

- (void)testCropString600 {
	
	NSString *inString = @"abcdeefghijklmnop";
	NSUInteger maxLength = 1;
	NSUInteger expectedLength = maxLength;

	NSString *outString = [self.provider cropString:inString maxLength:maxLength];
	
	XCTAssertTrue(outString != nil, @"Unexpectedly recieved nil output.");
	XCTAssertTrue(outString.length <= maxLength, @"outString.length (%d) unexpectedly greater than maxLength (%d).", (int)outString.length, (int)maxLength);
	XCTAssertTrue(outString.length == expectedLength, @"outString.length (%d) unexpectedly not equal to expectedLength (%d).", (int)outString.length, (int)expectedLength);
}

- (void)testCropString700 {
	
	NSString *inString = @"abcdeefghijklmnop";
	NSUInteger maxLength = inString.length - 1;
	NSUInteger expectedLength = maxLength;

	NSString *outString = [self.provider cropString:inString maxLength:maxLength];
	
	XCTAssertTrue(outString != nil, @"Unexpectedly recieved nil output.");
	XCTAssertTrue(outString.length <= maxLength, @"outString.length (%d) unexpectedly greater than maxLength (%d).", (int)outString.length, (int)maxLength);
	XCTAssertTrue(outString.length == expectedLength, @"outString.length (%d) unexpectedly not equal to expectedLength (%d).", (int)outString.length, (int)expectedLength);
}

- (void)testCropString800 {
	
	NSString *inString = @"abcdeefghijklmnop";
	NSUInteger maxLength = inString.length;
	NSUInteger expectedLength = maxLength;

	NSString *outString = [self.provider cropString:inString maxLength:maxLength];
	
	XCTAssertTrue(outString != nil, @"Unexpectedly recieved nil output.");
	XCTAssertTrue(outString.length <= maxLength, @"outString.length (%d) unexpectedly greater than maxLength (%d).", (int)outString.length, (int)maxLength);
	XCTAssertTrue(outString.length == expectedLength, @"outString.length (%d) unexpectedly not equal to expectedLength (%d).", (int)outString.length, (int)expectedLength);
}

- (void)testCropString900 {
	
	NSString *inString = @"abcdeefghijklmnop";
	NSUInteger maxLength = inString.length + 1;
	NSUInteger expectedLength = inString.length;

	NSString *outString = [self.provider cropString:inString maxLength:maxLength];
	
	XCTAssertTrue(outString != nil, @"Unexpectedly recieved nil output.");
	XCTAssertTrue(outString.length <= maxLength, @"outString.length (%d) unexpectedly greater than maxLength (%d).", (int)outString.length, (int)maxLength);
	XCTAssertTrue(outString.length == expectedLength, @"outString.length (%d) unexpectedly not equal to expectedLength (%d).", (int)outString.length, (int)expectedLength);
}

@end
