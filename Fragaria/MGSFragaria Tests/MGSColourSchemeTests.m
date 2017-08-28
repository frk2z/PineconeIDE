//
//  MGSColourSchemeTests.m
//  Fragaria
//
//  Created by Jim Derry on 3/16/15.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "MGSColourScheme.h"
#import "NSColor+TransformedCompare.h"


/**
 *  Basic tests for MGSColourScheme.
 **/
@interface MGSColourSchemeTests : XCTestCase

@end


@implementation MGSColourSchemeTests


/*
 * - setUp
 */
- (void)setUp
{
    [super setUp];
}


/*
 * - tearDown
 */
- (void)tearDown
{
    [super tearDown];
}


/*
 * - test_properties_to_file_and_back
 *   Make sure we can write a valid plist.
 */
- (void)test_propertiesToFile
{
    NSString *outputPath;
	NSString *expects1 = @"Monty Python";
    NSColor *expects2 = [NSColor purpleColor];

    outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test_propertiesToFile.plist"];
	MGSColourScheme *scheme = [[MGSColourScheme alloc] init];
	scheme.displayName = expects1;
    scheme.colourForComments = expects2;
	
	[scheme propertiesSaveToFile:outputPath];
	
	scheme = [[MGSColourScheme alloc] init];

	[scheme propertiesLoadFromFile:outputPath];
	
	XCTAssert([scheme.displayName isEqualToString:expects1]);
    XCTAssert([scheme.colourForComments mgs_isEqualToColor:expects2 transformedThrough:@"MGSColourToPlainTextTransformer"]);
}


/*
 * - test_initWithDictionary_simple
 */
- (void)test_initWithDictionary_simple
{
    NSString *expects = @"Autumn Noontime Moonlight";

    NSDictionary *testDict = @{ @"displayName" : expects };

    MGSColourScheme *testInstance = [[MGSColourScheme alloc] initWithDictionary:testDict];

    NSString *result = testInstance.displayName;

    XCTAssert([result isEqualToString:expects]);
}


/*
 * - test_isEqualToScheme
 */
- (void)test_isEqualToScheme
{
    NSColor *expects1 = [NSColor purpleColor];

    MGSColourScheme *scheme1 = [[MGSColourScheme alloc] init];
    MGSColourScheme *scheme2 = [[MGSColourScheme alloc] init];

    // Assert that they are equal.
    XCTAssert([scheme1 isEqualToScheme:scheme2]);

    scheme1.colourForNumbers = expects1;

    // Changing a color is detectable as a difference.
    XCTAssert(![scheme1 isEqualToScheme:scheme2]);

    scheme2.colourForNumbers = expects1;

    // Now equal again.
    XCTAssert([scheme1 isEqualToScheme:scheme2]);

    // Reset
    scheme1 = [[MGSColourScheme alloc] init];
    scheme2 = [[MGSColourScheme alloc] init];

    scheme1.coloursStrings = !scheme1.coloursStrings;

    // Should be not the same.
    XCTAssert(![scheme1 isEqualToScheme:scheme2]);

    scheme2.coloursStrings = !scheme2.coloursStrings;

    // Should be the same.
    XCTAssert([scheme1 isEqualToScheme:scheme2]);
}

/*
 * - test_isEqualToScheme_file
 *   Make sure isEqualToScheme works.
 */
- (void)test_isEqualToScheme_file
{
	NSString *outputPath;
	NSString *expects1 = @"Pecans and Cashews";
	NSColor *expects2 = [NSColor purpleColor];
	
    outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test_isEqualToScheme_file.plist"];
    
	MGSColourScheme *scheme = [[MGSColourScheme alloc] init];
	scheme.displayName = expects1;
	scheme.colourForKeywords = expects2;
	
	[scheme propertiesSaveToFile:outputPath];
	
	scheme = [[MGSColourScheme alloc] init];
	[scheme propertiesLoadFromFile:outputPath];
	
	MGSColourScheme *scheme2 = [[MGSColourScheme alloc] initWithFile:outputPath];
	
	XCTAssert([scheme isEqualToScheme:scheme2]);
}

/*
 * - test_make_classic_fragaria_theme
 *   This test always passes, but makes a virgin Classic Fragaria.plist.
 */
- (void)test_make_classic_fragaria_theme
{
	NSString *outputPath;
	
    outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Classic Fragaria.plist"];
    
	MGSColourScheme *scheme = [[MGSColourScheme alloc] init];
	scheme.displayName = @"Classic Fragaria";

	[scheme propertiesSaveToFile:outputPath];
	
	XCTAssert(YES);
}




@end
