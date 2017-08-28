//
//  MGSFragariaViewTests.m
//  Fragaria
//
//  Created by Jim Derry on 3/10/15.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "MGSFragariaView.h"

/**
 * Adds some basic tests for MGSFragariaView.
 **/
@interface MGSFragariaViewTests : XCTestCase

@property MGSFragariaView *fragariaView1;
@property MGSFragariaView *fragariaView2;

@property NSMutableDictionary *values;

@end


@implementation MGSFragariaViewTests

/*
 * - setUp
 *   Ensure we have a fresh view for every test.
 */
- (void)setUp
{
    [super setUp];
    self.fragariaView1 = [[MGSFragariaView alloc] initWithFrame:NSMakeRect(1.0, 1.0, 1.0, 1.0)];
    self.fragariaView2 = [[MGSFragariaView alloc] initWithFrame:NSMakeRect(1.0, 1.0, 1.0, 1.0)];

    self.values = [NSMutableDictionary dictionaryWithDictionary:@{
        @"SAMP-string" : @"Hello, world.",
    }];
}


/*
 * - tearDown
 *   Deallocate the view after every test.
 */
- (void)tearDown
{
    self.fragariaView1 = nil;
    self.fragariaView2 = nil;
    self.values = nil;
    [super tearDown];
}


/*
 * - test_simple_two_way_binding
 *   Ensure that when using bindings, two-way updates are working.
 */
- (void)test_simple_two_way_binding
{
    NSString *expect1, *result1, *result2;

    [self.fragariaView1 bind:@"string" toObject:self.values withKeyPath:@"SAMP-string" options:nil];

    // The fragariaView1 should have taken the example value.
    expect1 = @"Hello, world."; // default in -setUp.
    result1 = self.fragariaView1.string;
    result2 = self.values[@"SAMP-string"];
    XCTAssert( [result1 isEqualToString:expect1] && [result2 isEqualToString:expect1]);

    // Ensure that setting the dictionary can set the Fragaria.
    expect1 = @"sparkling water";
    [self.values setObject:expect1 forKey:@"SAMP-string"];
    result1 = self.fragariaView1.string;
    XCTAssert( [result1 isEqualToString:expect1] );

    // Ensure that changes to the Fragaria go back to the dictionary.
    expect1 = @"flat tire";
    self.fragariaView1.string = expect1;
    result1 = self.values[@"SAMP-string"];
    XCTAssert( [result1 isEqualToString:expect1] );
}


/*
 * - test_multiple_two_way_binding
 *   Make sure that bindings between multiple objects work.
 */
- (void)test_multiple_two_way_binding
{
    NSString *expect1, *result1, *result2;

    // Setup bindings for one Fragaria
    [self.fragariaView1 bind:@"string" toObject:self.values withKeyPath:@"SAMP-string" options:nil];

    // Standard test to ensure the Fragaria takes the value from the dict.
    expect1 = @"yellow crayon";
    self.values[@"SAMP-string"] = expect1;
    result1 = [self.values objectForKey:@"SAMP-string"];
    result2 = self.fragariaView1.string;
    XCTAssert( [result1 isEqualToString:expect1] && [result2 isEqualToString:expect1] );

    // Now add a second Fragaria to the mix, and it should assume the existing expect1 values.
    [self.fragariaView2 bind:@"string" toObject:self.values withKeyPath:@"SAMP-string" options:nil];
    result1 = self.fragariaView1.string;
    result2 = self.fragariaView2.string;
    XCTAssert( [result1 isEqualToString:expect1] && [result2 isEqualToString:expect1] );

    // Ensure that changes to a Fragaria are reflected in the other Fragaria and Dictionary.
    expect1 = @"spicy salsa";
    self.fragariaView1.string = expect1;
    result1 = self.values[@"SAMP-string"];
    result2 = self.fragariaView2.string;
    XCTAssert( [result1 isEqualToString:expect1] && [result2 isEqualToString:expect1]);
}


@end
