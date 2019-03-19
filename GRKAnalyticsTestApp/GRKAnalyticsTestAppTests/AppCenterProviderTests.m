//
//  AppCenterProviderTests.m
//  GRKAnalyticsTestAppTests
//
//  Created by Levi Brown on 2019-03-18.
//  Copyright © 2019 Levi Brown. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GRKAppCenterProvider.h"

@interface GRKAppCenterProvider ()

- (NSString *)sanitizeUserPropertyKey:(nullable NSString *)propertyKey;

@end

@interface AppCenterProviderTests : XCTestCase

@property (nonatomic,strong) GRKAppCenterProvider *provider;

@end

@implementation AppCenterProviderTests

- (void)setUp {
    [super setUp];
	
	self.provider = [[GRKAppCenterProvider alloc] init];
}

- (void)tearDown {

	self.provider = nil;
	
    [super tearDown];
}

- (void)testSanitizeUserPropertyKey100 {
	
	NSString *inString = nil;
	NSString *expectedString = @"";
	
	NSString *outString = [self.provider sanitizeUserPropertyKey:inString];
	
	XCTAssertTrue([outString isEqualToString:expectedString], @"Expected \"%@\" but received \"%@\".", expectedString, outString);
}

- (void)testSanitizeUserPropertyKey200 {
	
	NSString *inString = @"";
	NSString *expectedString = @"";
	
	NSString *outString = [self.provider sanitizeUserPropertyKey:inString];
	
	XCTAssertTrue([outString isEqualToString:expectedString], @"Expected \"%@\" but received \"%@\".", expectedString, outString);
}

- (void)testSanitizeUserPropertyKey300 {
	
	NSString *inString = @" ";
	NSString *expectedString = @"";
	
	NSString *outString = [self.provider sanitizeUserPropertyKey:inString];
	
	XCTAssertTrue([outString isEqualToString:expectedString], @"Expected \"%@\" but received \"%@\".", expectedString, outString);
}

- (void)testSanitizeUserPropertyKey400 {
	
	NSString *inString = @" A";
	NSString *expectedString = @"A";
	
	NSString *outString = [self.provider sanitizeUserPropertyKey:inString];
	
	XCTAssertTrue([outString isEqualToString:expectedString], @"Expected \"%@\" but received \"%@\".", expectedString, outString);
}

- (void)testSanitizeUserPropertyKey500 {
	
	NSString *inString = @" A ";
	NSString *expectedString = @"A";
	
	NSString *outString = [self.provider sanitizeUserPropertyKey:inString];
	
	XCTAssertTrue([outString isEqualToString:expectedString], @"Expected \"%@\" but received \"%@\".", expectedString, outString);
}

- (void)testSanitizeUserPropertyKey600 {
	
	NSString *inString = @" A.B.C.";
	NSString *expectedString = @"ABC";
	
	NSString *outString = [self.provider sanitizeUserPropertyKey:inString];
	
	XCTAssertTrue([outString isEqualToString:expectedString], @"Expected \"%@\" but received \"%@\".", expectedString, outString);
}

- (void)testSanitizeUserPropertyKey700 {
	
	NSString *inString = @".A.B.C.";
	NSString *expectedString = @"aABC";
	
	NSString *outString = [self.provider sanitizeUserPropertyKey:inString];
	
	XCTAssertTrue([outString isEqualToString:expectedString], @"Expected \"%@\" but received \"%@\".", expectedString, outString);
}

- (void)testSanitizeUserPropertyKey800 {
	
	NSString *inString = @".A.B.C.d";
	NSString *expectedString = @"aABCd";
	
	NSString *outString = [self.provider sanitizeUserPropertyKey:inString];
	
	XCTAssertTrue([outString isEqualToString:expectedString], @"Expected \"%@\" but received \"%@\".", expectedString, outString);
}

@end
