//
//  MGSUserDefaultsControllerTests.m
//  Fragaria
//
//  Created by Jim Derry on 3/11/15.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "MGSPreferencesProxyDictionary.h"
#import "MGSFragariaView+Definitions.h"
#import "MGSUserDefaultsController.h"
#import "MGSUserDefaults.h"
#import "MGSFragariaView.h"


/**
 *  Adds some basic tests for MGSUserDefaultsController.
 **/
@interface MGSUserDefaultsControllerTests : XCTestCase

@property MGSFragariaView *view1;
@property MGSFragariaView *view2;

@property MGSPreferencesProxyDictionary *dict1;
@property MGSPreferencesProxyDictionary *dict2;

@end

@implementation MGSUserDefaultsControllerTests


/*
 * - setUp
 *   Make some MGSFragariaView instances available for use.
 */
- (void)setUp
{
	[super setUp];
	
	self.view1 = [[MGSFragariaView alloc] initWithFrame:NSMakeRect(1.0, 1.0, 1.0, 1.0)];
	self.view2 = [[MGSFragariaView alloc] initWithFrame:NSMakeRect(1.0, 1.0, 1.0, 1.0)];
	
	self.dict1 = [MGSPreferencesProxyDictionary dictionaryWithDictionary:@{ @"name" : @"jim" }];
	self.dict2 = [MGSPreferencesProxyDictionary dictionaryWithDictionary:@{ @"name" : @"john" }];
}


/*
 * - tearDown
 *   Cleanup after every test to ensure virgin instances.
 */
- (void)tearDown
{
	[super tearDown];
}


/*
 *  - test_binding_dictionaries
 *    Test our assumption that two bound MGSMutableDictionary values will
 *    stay in sync. The subclass doesn't break bindings.
 */
- (void)test_binding_dictionaries
{
    NSString *result1, *result2, *expect1;

    [self bind:@"dict1" toObject:self withKeyPath:@"dict2" options:nil];
    result1 = self.dict1[@"name"];
    result2 = self.dict1[@"name"];
    XCTAssert([result1 isEqualToString:result2]);

    expect1 = @"jack";
    self.dict1[@"name"] = expect1;
    result1 = self.dict1[@"name"];
    result2 = self.dict1[@"name"];
    XCTAssert([result1 isEqualToString:expect1] && [result2 isEqualToString:expect1]);

    expect1 = @"joseph";
    self.dict1[@"name"] = expect1;
    result1 = self.dict1[@"name"];
    result2 = self.dict1[@"name"];
    XCTAssert([result1 isEqualToString:expect1] && [result2 isEqualToString:expect1]);
}


/*
 * - test_sharedControllers_groupID
 *   Check that the shared controllers are indeed separate instances, and are
 *   accessible.
 */
- (void)test_sharedControllers_groupID
{
	NSString *result1, *result2, *result3;
	
	NSString *expect1 = @"TopmostView";
	NSString *expect2 = @"SomeOtherView";
	NSString *expect3 = MGSUSERDEFAULTS_GLOBAL_ID;
	
	
	result1 = [[MGSUserDefaultsController sharedControllerForGroupID:expect1] groupID];
	result2 = [[MGSUserDefaultsController sharedControllerForGroupID:expect2] groupID];
	result3 = [[MGSUserDefaultsController sharedController] groupID];
	
	XCTAssert([result1 isEqualToString:expect1]);
	XCTAssert([result2 isEqualToString:expect2]);
	XCTAssert([result3 isEqualToString:expect3]);
}


/*
 * - test_instances_share_property_values
 *   Demonstrate that when instances are assigned to a groupID:
 *   - They take each others value.
 *   - `values` takes their value.
 *   - Changes in `values` applies to the instances.
 */
- (void)test_instances_share_property_values
{
	NSUInteger expect1 = arc4random_uniform(100) + 1;
	NSUInteger expect2 = arc4random_uniform(100) + 1;
	NSUInteger result1, result2;
	
	MGSUserDefaultsController *controller = [MGSUserDefaultsController sharedControllerForGroupID:@"UnitTest"];
	
	
	self.view1.startingLineNumber = expect1;
	self.view2.startingLineNumber = expect2;
	
	// Prove they are independent:
	XCTAssert(self.view1.startingLineNumber == expect1 && self.view2.startingLineNumber == expect2);
	
	// Add them to a group and then test.
    [controller addFragariaToManagedSet:self.view1];
    [controller addFragariaToManagedSet:self.view2];
	controller.managedProperties = [NSSet setWithArray:@[ @"startingLineNumber" ]];
	result1 = self.view1.startingLineNumber;
	result2 = self.view2.startingLineNumber;
	// We don't know the initial value, but they should now be equal.
	XCTAssert( result1 == result2 );
	
	// If we set one of them, then the storage and other one should update, too.
	self.view1.startingLineNumber = expect1;
	result1 = self.view2.startingLineNumber;
	result2 = [[controller.values valueForKey:@"startingLineNumber"] unsignedIntegerValue];
	XCTAssert(result1 == expect1 && result2 == expect1);

	// And of course if we set the values, it should update both properties.
    [controller.values setValue:@(expect2) forKey:@"startingLineNumber"];
	result1 = self.view1.startingLineNumber;
	result2 = self.view2.startingLineNumber;
	XCTAssert(result1 == expect2 && result2 == expect2);
}


/*
 * - test_persistence_changes
 *   Demonstrate:
 *   - When persistence is turned ON, the defaults values update to the
 *     current value.
 *   - When persistence is turned OFF, the current value is updated with the
 *     defaults value.
 */
- (void)test_persistence_changes
{
	NSUInteger expect;
	NSUInteger result1, result2, result3;
	
	MGSUserDefaultsController *controller = [MGSUserDefaultsController sharedControllerForGroupID:@"UnitTest"];
	MGSUserDefaults *defaults = [MGSUserDefaults sharedUserDefaultsForGroupID:@"UnitTest"];

    [controller addFragariaToManagedSet:self.view1];
    [controller addFragariaToManagedSet:self.view2];
	controller.managedProperties = [NSSet setWithArray:@[ @"startingLineNumber" ]];

	
	// Setting defaults via the controller updates the instances:
	expect = arc4random_uniform(100) + 1;
	[controller.values setValue:@(expect) forKey:@"startingLineNumber"];
	result1 = self.view1.startingLineNumber;
	result2 = self.view2.startingLineNumber;
	XCTAssert(result1 == expect && result2 == expect);
	
	// Turn ON persistence. Does defaults take the correct value now?
	expect = arc4random_uniform(100) + 101;
    [controller.values setValue:@(expect) forKey:@"startingLineNumber"];
	controller.persistent = YES;
	result1 = [defaults integerForKey:@"startingLineNumber"];
	result2 = self.view1.startingLineNumber;
	XCTAssert(result1 == expect && result2 == expect);

	// Now that we have persistence, if we set the controller, will
	// all of the views and defaults take the values, too?
	expect = arc4random_uniform(100) + 1;
    [controller.values setValue:@(expect) forKey:@"startingLineNumber"];
	result1 = self.view1.startingLineNumber;
	result2 = self.view2.startingLineNumber;
	result3 = [defaults integerForKey:@"startingLineNumber"];
	XCTAssert(result1 == expect && result2 == expect && result3 == expect);
	
    // Setting a property should reflect in defaults and the other instance.
	expect = arc4random_uniform(100) + 101;
	self.view1.startingLineNumber = expect;
	result1 = [defaults integerForKey:@"startingLineNumber"];
	result2 = self.view2.startingLineNumber;
	XCTAssert(result1 == expect && result2 == expect);

	// Does setting the user defaults change the instances?
	expect = arc4random_uniform(100) + 1;
	[defaults setInteger:expect forKey:@"startingLineNumber"];
	result1 = self.view1.startingLineNumber;
	result2 = self.view2.startingLineNumber;
	XCTAssert(result1 == expect && result2 == expect);

    // Now turn off persistence and ensure that:
    // - setting the controller updates views, but not defaults.
    expect = arc4random_uniform(100) + 101;
    controller.persistent = NO;
    [controller.values setValue:@(expect) forKey:@"startingLineNumber"];
    result1 = self.view1.startingLineNumber;
    result2 = [defaults integerForKey:@"startingLineNumber"];
    XCTAssert(result1 == expect && result2 != expect);

    // - setting the view updates the controller, but not defaults.
    expect = arc4random_uniform(100) + 201;
    self.view1.startingLineNumber = expect;
    result1 = [[controller.values valueForKey:@"startingLineNumber"] integerValue];
    result2 = [defaults integerForKey:@"startingLineNumber"];
    XCTAssert(result1 == expect && result2 != expect);

    // - setting defaults updates nothing.
    expect = arc4random_uniform(100) + 301;
    [defaults setInteger:expect forKey:@"startingLineNumber"];
    result1 = self.view1.startingLineNumber;
    result2 = [[controller.values valueForKey:@"startingLineNumber"] integerValue];
    XCTAssert(result1 != expect && result2 != expect);
}


/*
 * - test_instances_and_globals
 *   Test to make sure that global properties are shared even when
 *   instances gave different groupID's.
 */
- (void)test_instances_and_globals
{
    NSUInteger expect1 = arc4random_uniform(100) + 1;
    NSUInteger expect2 = arc4random_uniform(100) + 1;
    NSUInteger result1, result2;

    MGSUserDefaultsController *controller1 = [MGSUserDefaultsController sharedControllerForGroupID:@"Group1"];
    MGSUserDefaultsController *controller2 = [MGSUserDefaultsController sharedControllerForGroupID:@"SomeOtherGroup"];
    MGSUserDefaultsController *controllerG = [MGSUserDefaultsController sharedController];

    self.view1.startingLineNumber = expect1;
    self.view2.startingLineNumber = expect2;

    // Prove they are independent:
    XCTAssert(self.view1.startingLineNumber == expect1 && self.view2.startingLineNumber == expect2);

    // Add each instance to a different group, and then test.
    [controller1 addFragariaToManagedSet:self.view1];
    [controller2 addFragariaToManagedSet:self.view2];

    // Prove they are *still* independent:
    XCTAssert(self.view1.startingLineNumber == expect1 && self.view2.startingLineNumber == expect2);

    // Let the global controller manage the startingLineNumberProperty.
    
    controllerG.managedProperties = [NSSet setWithArray:@[ @"startingLineNumber" ]];

    // Check that their properties are now linked.
    expect1 = arc4random_uniform(100) + 1;
    self.view1.startingLineNumber = expect1;
    result1 = [[controllerG.values valueForKey:@"startingLineNumber"] integerValue];
    result2 = self.view2.startingLineNumber;
    XCTAssert(result1 == expect1 && result2 == expect1);
}


/*
 * - test_all_properties
 *   Demonstrate:
 *   - We can handle all properties, some of which require special archiving.
 */
- (void)test_all_properties
{
    MGSUserDefaultsController *controller = [MGSUserDefaultsController sharedControllerForGroupID:@"test_all_properties"];
    NSArray *managedProperties = [[MGSFragariaView defaultsDictionary] allKeys];

    [controller addFragariaToManagedSet:self.view1];
    controller.managedProperties = [NSSet setWithArray:managedProperties];

    XCTAssert(YES, @"Did not pass without an error.");
    
    // Clean up to pave way for other tests
    controller.managedProperties = [NSSet set];
}


- (void)test_bugCatchers
{
    MGSUserDefaultsController *c2 = [MGSUserDefaultsController sharedControllerForGroupID:@"bugCatch1"];
    MGSUserDefaultsController *c1 = [MGSUserDefaultsController sharedControllerForGroupID:@"bugCatch2"];
    MGSUserDefaultsController *g = [MGSUserDefaultsController sharedController];
    
    [c1 addFragariaToManagedSet:self.view1];
    XCTAssertThrows([c2 addFragariaToManagedSet:self.view1], @"Adding an "
      "already registered Fragaria to another controller did not raise an "
      "exception.");
    
    [c1 setManagedProperties:[NSSet setWithArray:@[@"startingLineNumber"]]];
    XCTAssertThrows([g setManagedProperties:[NSSet setWithArray:@[@"startingLineNumber"]]],
      @"Adding an already managed property to the global controller did not "
      "raise an exception.");
    [c1 setManagedProperties:[NSSet set]];
}


@end
