//
//  MGSLineRangeForCharacterTests.m
//  Fragaria
//
//  Created by Daniele Cattaneo on 14/12/15.
//
//

#import <XCTest/XCTest.h>
#import "NSString+Fragaria.h"


@interface MGSLineRangeForCharacterTests : XCTestCase

@end


@implementation MGSLineRangeForCharacterTests


- (void)testNormalCase
{
    [self realTestLineRange:NSMakeRange(0, 5) ofString:@"1234\n1234567\n"];
    [self realTestLineRange:NSMakeRange(0, 5) ofString:@"12345"];
    [self realTestLineRange:NSMakeRange(5, 8) ofString:@"1234\n1234567\n"];
    [self realTestLineRange:NSMakeRange(5, 8) ofString:@"1234\n12345678"];
}


- (void)testOutOfRange
{
    NSRange r;
    
    XCTAssert(NSEqualRanges([@"0123" mgs_lineRangeForCharacterIndex:4], NSMakeRange(0, 4)));
    XCTAssert(NSEqualRanges([@"0123\n" mgs_lineRangeForCharacterIndex:5], NSMakeRange(5, 0)));
    
    r = [@"0123" mgs_lineRangeForCharacterIndex:5];
    XCTAssert(r.location == NSNotFound && r.length == 0);
    r = [@"0123" mgs_lineRangeForCharacterIndex:NSUIntegerMax];
    XCTAssert(r.location == NSNotFound && r.length == 0);
    
    r = [@"0123\n" mgs_lineRangeForCharacterIndex:6];
    XCTAssert(r.location == NSNotFound && r.length == 0);
    r = [@"0123\n" mgs_lineRangeForCharacterIndex:NSUIntegerMax];
    XCTAssert(r.location == NSNotFound && r.length == 0);
}


- (void)testEmptyString
{
    NSRange r;
    
    XCTAssert(NSEqualRanges([@"" mgs_lineRangeForCharacterIndex:0], NSMakeRange(0, 0)));
    XCTAssert(NSEqualRanges([@"\n" mgs_lineRangeForCharacterIndex:0], NSMakeRange(0, 1)));
    XCTAssert(NSEqualRanges([@"\n" mgs_lineRangeForCharacterIndex:1], NSMakeRange(1, 0)));
    
    r = [@"" mgs_lineRangeForCharacterIndex:1];
    XCTAssert(r.location == NSNotFound && r.length == 0);
    r = [@"" mgs_lineRangeForCharacterIndex:NSUIntegerMax];
    XCTAssert(r.location == NSNotFound && r.length == 0);
    
    r = [@"\n" mgs_lineRangeForCharacterIndex:2];
    XCTAssert(r.location == NSNotFound && r.length == 0);
    r = [@"\n" mgs_lineRangeForCharacterIndex:NSUIntegerMax];
    XCTAssert(r.location == NSNotFound && r.length == 0);
}


- (void)realTestLineRange:(NSRange)r ofString:(NSString*)s
{
    NSUInteger i;
    
    for (i=0; i<r.location; i++) {
        XCTAssert(!NSEqualRanges([s mgs_lineRangeForCharacterIndex:i], r));
    }
    for (i=r.location; i<NSMaxRange(r); i++) {
        XCTAssert(NSEqualRanges([s mgs_lineRangeForCharacterIndex:i], r));
    }
    for (i=NSMaxRange(r); i<s.length; i++) {
        XCTAssert(!NSEqualRanges([s mgs_lineRangeForCharacterIndex:i], r));
    }
}


@end
