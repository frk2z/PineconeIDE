//
//  MGSPrefsViewControllerTests.m
//  Fragaria
//
//  Created by Jim Derry on 3/22/15.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "MGSUserDefaultsController.h"
#import "MGSPrefsEditorPropertiesViewController.h"


/**
 * Adds some basic tests for MGSPrefsViewController.
 **/
@interface MGSPrefsViewControllerTests : XCTestCase

@end


@implementation MGSPrefsViewControllerTests

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
 * - test_managedProperties
 */
- (void)test_managedProperties
{
    MGSUserDefaultsController *controller = [MGSUserDefaultsController sharedControllerForGroupID:@"managedPropertiesTest"];
    controller.managedProperties = [NSSet setWithArray:@[ MGSFragariaDefaultsShowsGutter, MGSFragariaDefaultsTextFont]];

    MGSPrefsViewController *viewController = [[MGSPrefsEditorPropertiesViewController alloc] init];
    viewController.userDefaultsController = controller;

    NSNumber *result = [viewController valueForKeyPath:@"managedProperties.showsGutter"];
    XCTAssert([result boolValue] == YES);

    result = [viewController.managedProperties valueForKey:MGSFragariaDefaultsTextFont];
    XCTAssert([result boolValue] == YES);

    result = [viewController.managedProperties valueForKey:@"SomeUnknownKey"];
    XCTAssert([result boolValue] == NO);
}

@end
