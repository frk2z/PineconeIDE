//
//  MGSUserDefaultsControllerTests.m
//  Fragaria
//
//  Created by Jim Derry on 3/3/15.
//
//

#import <Cocoa/Cocoa.h>
#import <objc/runtime.h>
#import <XCTest/XCTest.h>
#import "Fragaria.h"
#import "MGSUserDefaults.h"


/**
 *  Adds some basic tests for MGSUserDefaults.
 **/
@interface MGSUserDefaultsTests : XCTestCase

@property (nonatomic,strong) NSMutableDictionary *values;

@property NSTextView *gFrag1; // todo: (jsd) fix ugly hack
@property NSTextView *gFrag2; // todo: (jsd) fix ugly hack


@end

@implementation MGSUserDefaultsTests

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
 *  Demonstrate that we don't have to go to great lengths to ensure
 *  that an application can only register defaults a single time.
 */
- (void)test_multiple_registerDefaults
{
	NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *dict1;
	
	NSString *expect1, *expect2, *result1, *result2;
	
	expect1 = @"Der Spiegel";
	expect2 = @"donkey";
 
	dict1 = @{ @"periodical" : expect1 };
	[sud registerDefaults:dict1];
	
	dict1 = @{ @"animal" : expect2 };
	[sud registerDefaults:dict1];
	
	result1 = [sud stringForKey:@"periodical"];
	result2 = [sud stringForKey:@"animal"];
	
	XCTAssert(expect1 == result1 && expect2 == result2);
}


/*
 *  Check that the sharedUserDefaults are indeed separate instances, and are
 *  accessible.
 */
- (void)test_sharedUserDefaults_groupID
{
	NSString *result1, *result2, *result3;
	
	NSString *expect1 = @"TopmostView";
	NSString *expect2 = @"SomeOtherView";
	NSString *expect3 = MGSUSERDEFAULTS_GLOBAL_ID;
	
	
	result1 = [[MGSUserDefaults sharedUserDefaultsForGroupID:expect1] groupID];
	result2 = [[MGSUserDefaults sharedUserDefaultsForGroupID:expect2] groupID];
	result3 = [[MGSUserDefaults sharedUserDefaults] groupID];
	
	XCTAssert([result1 isEqualToString:expect1]);
	XCTAssert([result2 isEqualToString:expect2]);
	XCTAssert([result3 isEqualToString:expect3]);
}



/*
 *  Make sure that MGSUserDefaults can read and write userDefaults, and delete them.
 */
- (void)test_sharedUserDefaults_rw
{
	NSString *instanceID = @"DefaultsTest";
	NSString *key = @"MyKey";
	NSString *value = @"SampleValue";
	MGSUserDefaults *defaults = [MGSUserDefaults sharedUserDefaultsForGroupID:instanceID];
	
	[defaults setObject:value forKey:key];
	[defaults setBool:YES forKey:@"BooleanSample"];
	
	// Using NSUserDefaults sees a dictionary for the instanceID.
	NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
	NSDictionary *results = [sud objectForKey:instanceID];
	
	// Using MGSUserDefaults should return the value.
	NSString *result = [defaults objectForKey:@"MyKey"];
	
	NSLog(@"%@", @"Prefs .plist is at ~/Library/Preferences/xctest.plist");
	XCTAssert(results && [result isEqualToString:value]);
	
	[defaults removeObjectForKey:key];
	XCTAssert(![defaults objectForKey:key]);
}


@end
