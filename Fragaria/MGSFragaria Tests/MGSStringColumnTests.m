//
//  MGSStringRowColumn.m
//  Fragaria
//
//  Created by Daniele Cattaneo on 14/12/15.
//
//

#import <XCTest/XCTest.h>
#import "NSString+Fragaria.h"


@interface MGSStringRowColumn : XCTestCase

@end


@implementation MGSStringRowColumn


- (void)testSingleTab
{
    [self realTestTab:0 inLine:@"\t" tabWidth:1 expectedRealWidth:1 realLeft:0];
    [self realTestTab:0 inLine:@"\t" tabWidth:2 expectedRealWidth:2 realLeft:0];
    [self realTestTab:0 inLine:@"\t" tabWidth:3 expectedRealWidth:3 realLeft:0];
    [self realTestTab:0 inLine:@"\t\n" tabWidth:1 expectedRealWidth:1 realLeft:0];
    [self realTestTab:0 inLine:@"\t\n" tabWidth:2 expectedRealWidth:2 realLeft:0];
    [self realTestTab:0 inLine:@"\t\n" tabWidth:3 expectedRealWidth:3 realLeft:0];
}


- (void)testTabAfterCharacters
{
    [self realTestTab:1 inLine:@"0\t456" tabWidth:4 expectedRealWidth:3 realLeft:1];
    [self realTestTab:2 inLine:@"01\t456" tabWidth:4 expectedRealWidth:2 realLeft:2];
    [self realTestTab:3 inLine:@"012\t456" tabWidth:4 expectedRealWidth:1 realLeft:3];
    [self realTestTab:4 inLine:@"0123\t89A" tabWidth:4 expectedRealWidth:4 realLeft:4];
}


- (void)testTwoTabs
{
    [self realTestTab:5 inLine:@"0\t456\t8" tabWidth:4 expectedRealWidth:1 realLeft:7];
    [self realTestTab:6 inLine:@"01\t456\t8" tabWidth:4 expectedRealWidth:1 realLeft:7];
    [self realTestTab:7 inLine:@"012\t456\t8" tabWidth:4 expectedRealWidth:1 realLeft:7];
    [self realTestTab:8 inLine:@"0123\t89A\tC" tabWidth:4 expectedRealWidth:1 realLeft:11];
}


- (void)testNewline
{
    XCTAssertEqual([@"\n" mgs_columnOfCharacter:0 tabWidth:4], (NSUInteger)0);
    XCTAssertEqual([@"\n" mgs_columnOfCharacter:1 tabWidth:4], NSUIntegerMax);
    
    XCTAssertEqual([@"\n" mgs_characterInColumn:0 tabWidth:4], (NSUInteger)0);
    XCTAssertEqual([@"\n" mgs_characterInColumn:1 tabWidth:4], (NSUInteger)0);
    XCTAssertEqual([@"\n" mgs_characterInColumn:NSUIntegerMax tabWidth:4], (NSUInteger)0);
    
    XCTAssertEqual([@"A\n" mgs_characterInColumn:1 tabWidth:4], (NSUInteger)1);
    XCTAssertEqual([@"A\n" mgs_characterInColumn:2 tabWidth:4], (NSUInteger)1);
    XCTAssertEqual([@"A\n" mgs_characterInColumn:NSUIntegerMax tabWidth:4], (NSUInteger)1);
    
    XCTAssertEqual([@"no newline here" mgs_characterInColumn:50 tabWidth:4], NSNotFound);
    XCTAssertEqual([@"no newline here" mgs_characterInColumn:15 tabWidth:4], NSNotFound);
}


- (void)realTestTab:(NSUInteger)c inLine:(NSString*)s tabWidth:(NSUInteger)w expectedRealWidth:(NSUInteger)rw realLeft:(NSUInteger)l
{
    NSUInteger i, j, t;
    
    j = 0;
    XCTAssertEqual([s mgs_columnOfCharacter:0 tabWidth:w], (NSUInteger)0);
    for (i=1; i<c; i++) {
        XCTAssertGreaterThan((t=[s mgs_columnOfCharacter:i tabWidth:w]), j);
        XCTAssertLessThan(t, l);
        j = t;
    }
    XCTAssertEqual([s mgs_columnOfCharacter:c tabWidth:w], l);
    XCTAssertEqual((t=[s mgs_columnOfCharacter:c+1 tabWidth:w]), l+rw);
    for (i=c+2; i<s.length; i++) {
        j = t;
        XCTAssertGreaterThan((t=[s mgs_columnOfCharacter:i tabWidth:w]), j);
    }
    
    j = 0;
    XCTAssertEqual([s mgs_characterInColumn:0 tabWidth:w], (NSUInteger)0);
    for (i=1; i<l; i++) {
        t = [s mgs_characterInColumn:i tabWidth:w];
        XCTAssert(t == j || t == j+1);
        j = t;
    }
    for (i=l; i<l+rw; i++) {
        XCTAssertEqual([s mgs_characterInColumn:i tabWidth:w], c);
    }
    if (c+1 < s.length) {
        XCTAssertEqual((j=[s mgs_characterInColumn:l+rw tabWidth:w]), c+1);
        j = c+1;
        for (i=l+rw+1; i<s.length; i++) {
            t = [s mgs_characterInColumn:i tabWidth:w];
            XCTAssert(t == j+1 || t == j);
            j = t;
        }
    }
}


@end
