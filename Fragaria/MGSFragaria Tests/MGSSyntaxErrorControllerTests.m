//
//  MGSSyntaxErrorControllerTests.m
//  Fragaria
//
//  Created by Jim Derry on 2/15/15.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "MGSSyntaxErrorController.h"
#import "SMLSyntaxError.h"


/**
 *  Performs some basic testing on MGSSyntaxErrorController.
 **/
@interface MGSSyntaxErrorControllerTests : XCTestCase

@property (nonatomic,strong) MGSSyntaxErrorController *errorController;

@end


@implementation MGSSyntaxErrorControllerTests

/*
 *  - setup
 *    Provide sample data for self.errorController.
 */
- (void)setUp
{
    [super setUp];

    NSArray *tmp = @[
                     [SMLSyntaxError errorWithDictionary:@{
                                                           @"errorDescription" : @"Sample error 1.",
                                                           @"line" : @(4),
                                                           @"hidden" : @(NO),
                                                           @"warningLevel" : @(kMGSErrorCategoryAccess)
                                                           }],

                     [SMLSyntaxError errorWithDictionary:@{
                                                           @"errorDescription" : @"Sample error 2.",
                                                           @"line" : @(4),
                                                           @"hidden" : @(YES),
                                                           @"warningLevel" : @(kMGSErrorCategoryPanic)
                                                           }],
                     [SMLSyntaxError errorWithDictionary:@{
                                                           @"errorDescription" : @"Sample error 3.",
                                                           @"line" : @(37),
                                                           @"hidden" : @(NO),
                                                           @"warningLevel" : @(kMGSErrorCategoryDocument)
                                                           }],
                     [SMLSyntaxError errorWithDictionary:@{
                                                           @"errorDescription" : @"Sample error 4.",
                                                           @"line" : @(37),
                                                           @"hidden" : @(NO),
                                                           @"warningLevel" : @(kMGSErrorCategoryDocument)
                                                           }],
                     [NSString stringWithFormat:@"%@", @"I don't belong here."],
                     [SMLSyntaxError errorWithDictionary:@{
                                                           @"errorDescription" : @"Sample error 5.",
                                                           @"line" : @(189),
                                                           @"hidden" : @(NO),
                                                           @"warningLevel" : @(kMGSErrorCategoryError)
                                                           }],
                     [SMLSyntaxError errorWithDictionary:@{
                                                           @"errorDescription" : @"Sample error 6.",
                                                           @"line" : @(212),
                                                           @"hidden" : @(YES),
                                                           @"warningLevel" : @(kMGSErrorCategoryPanic)
                                                           }],
                     ];
    self.errorController = [[MGSSyntaxErrorController alloc] init];
    [self.errorController setSyntaxErrors:tmp];
}


/*
 *  - tearDown
 */
- (void)tearDown
{
    [super tearDown];
}


/*
 *  - test_linesWithErrors
 */
- (void)test_linesWithErrors
{
    NSArray *result = [[self.errorController linesWithErrors] sortedArrayUsingSelector:@selector(compare:)];
    NSArray *expects = @[@(4), @(37), @(189)];

    XCTAssertEqualObjects(result, expects);
}


/*
 *  - test_errorCountForLine
 */
- (void)test_errorCountForLine
{
    NSInteger result4 = [self.errorController errorCountForLine:4];
    NSInteger result37 = [self.errorController errorCountForLine:37];
    NSInteger result189 = [self.errorController errorCountForLine:189];
    NSInteger result212 = [self.errorController errorCountForLine:212];

    XCTAssert(result4 == 1 && result37 == 2 && result189 == 1 && result212 == 0);
}


/*
 *  - test_errorForLine
 */
- (void)test_errorForLine
{
    // We should get kMGSErrorAccess, because the other error is hidden.
    float result4 = [[self.errorController errorForLine:4] warningLevel];

    // We should get @"Sample error 3." because error level is the same, and this is the first one.
    NSString *result37 = [[self.errorController errorForLine:37] errorDescription];

    XCTAssert(result4 == kMGSErrorCategoryAccess && [result37 isEqualToString:@"Sample error 3."]);

}


/*
 *  - test_errorsForLine
 */
- (void)test_errorsForLine
{
    SMLSyntaxError *testContent = [[self.errorController errorsForLine:4] objectAtIndex:0];
    NSInteger testQuantity = [[self.errorController errorsForLine:37] count];

    XCTAssert([testContent.errorDescription isEqualToString:@"Sample error 1."] && testQuantity == 2);
}


/*
 *  - test_nonHiddenErrors
 */
- (void)test_nonHiddenErrors
{
    NSInteger testQuantity = [[self.errorController nonHiddenErrors] count];

    XCTAssert(testQuantity == 4);
}


/*
 *  - test_errorDecorations
 */
- (void)test_errorDecorations
{
    NSDictionary *resultDict = [self.errorController errorDecorations];
    SMLSyntaxError *decor = [resultDict objectForKey:@(189)];

    XCTAssert(decor.line == 189);
}


@end
