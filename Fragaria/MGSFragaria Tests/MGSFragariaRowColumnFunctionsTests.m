//
//  MGSFragariaRowColumnFunctionsTests.m
//  Fragaria
//
//  Created by Daniele Cattaneo on 14/12/15.
//
//

#import <XCTest/XCTest.h>
#import <Fragaria/Fragaria.h>


@interface MGSFragariaRowColumnFunctionsTests : XCTestCase

@end


@implementation MGSFragariaRowColumnFunctionsTests


- (void)testNullParams
{
    MGSFragariaView *f = [[MGSFragariaView alloc] initWithFrame:NSMakeRect(0, 0, 50, 50)];
    
    XCTAssertNoThrow([f getRow:NULL column:NULL forCharacterIndex:1234]);
    XCTAssertNoThrow([f getRow:NULL indexInRow:NULL forCharacterIndex:1234]);
}


- (void)testOutOfRange
{
    MGSFragariaView *f = [[MGSFragariaView alloc] initWithFrame:NSMakeRect(0, 0, 50, 50)];
    NSUInteger r, c;
    
    [f setString:@"012345\n789AB"];
    
    [f getRow:&r column:&c forCharacterIndex:12];
    XCTAssertEqual(r, (NSUInteger)1);
    XCTAssertEqual(c, (NSUInteger)5);
    [f getRow:&r indexInRow:&c forCharacterIndex:12];
    XCTAssertEqual(r, (NSUInteger)1);
    XCTAssertEqual(c, (NSUInteger)5);
    XCTAssertEqual([f characterIndexAtColumn:5 withinRow:1], NSNotFound);
    XCTAssertEqual([f characterIndexAtIndex:5 withinRow:1], (NSUInteger)12);
    
    [f getRow:&r column:&c forCharacterIndex:13];
    XCTAssertEqual(r, NSNotFound);
    XCTAssertEqual(c, NSNotFound);
    [f getRow:&r indexInRow:&c forCharacterIndex:13];
    XCTAssertEqual(r, NSNotFound);
    XCTAssertEqual(c, NSNotFound);
    XCTAssertEqual([f characterIndexAtColumn:0 withinRow:2], NSNotFound);
    XCTAssertEqual([f characterIndexAtIndex:0 withinRow:2], NSNotFound);
    
    [f getRow:&r column:&c forCharacterIndex:NSUIntegerMax];
    XCTAssertEqual(r, NSNotFound);
    XCTAssertEqual(c, NSNotFound);
    [f getRow:&r indexInRow:&c forCharacterIndex:NSUIntegerMax];
    XCTAssertEqual(r, NSNotFound);
    XCTAssertEqual(c, NSNotFound);
    XCTAssertEqual([f characterIndexAtColumn:0 withinRow:NSUIntegerMax], NSNotFound);
    XCTAssertEqual([f characterIndexAtIndex:0 withinRow:NSUIntegerMax], NSNotFound);
    
    XCTAssertEqual([f characterIndexAtColumn:6 withinRow:1], NSNotFound);
    XCTAssertEqual([f characterIndexAtIndex:6 withinRow:1], (NSUInteger)12);
    
    XCTAssertEqual([f characterIndexAtColumn:6 withinRow:0], (NSUInteger)6);
    XCTAssertEqual([f characterIndexAtIndex:6 withinRow:0], (NSUInteger)6);
    
    XCTAssertEqual([f characterIndexAtColumn:NSUIntegerMax withinRow:1], NSNotFound);
    XCTAssertEqual([f characterIndexAtIndex:NSUIntegerMax withinRow:1], (NSUInteger)12);
    
    XCTAssertEqual([f characterIndexAtColumn:NSUIntegerMax withinRow:0], (NSUInteger)6);
    XCTAssertEqual([f characterIndexAtIndex:NSUIntegerMax withinRow:0], (NSUInteger)6);
}


- (void)testSameResultPartialOutput
{
    [self realTestSameResultWithString:@"1234\tajfjk\nabcjdef"];
    [self realTestSameResultWithString:@"ajksjfjfk\nfjdsofjgj\n"];
    [self realTestSameResultWithString:@"\t1234\taj\tfjk\na\tbcjde\tf\t"];
    [self realTestSameResultWithString:@"\t1234\taj\tfjk\na\tbcjde\tf\t\n\n\n"];
}


- (void)realTestSameResultWithString:(NSString *)s
{
    MGSFragariaView *f = [[MGSFragariaView alloc] initWithFrame:NSMakeRect(0, 0, 50, 50)];
    NSUInteger r0, c0, r1, c2, i;
    
    f.string = s;
    
    for (i=0; i<=s.length+20; i++) {
        r0 = c0 = r1 = c2 = NSUIntegerMax;
        [f getRow:&r0 column:&c0 forCharacterIndex:i];
        [f getRow:&r1 column:NULL forCharacterIndex:i];
        [f getRow:NULL column:&c2 forCharacterIndex:i];
        XCTAssertEqual(r0, r1);
        XCTAssertEqual(c0, c2);
    }
    
    for (i=0; i<=s.length+20; i++) {
        r0 = c0 = r1 = c2 = NSUIntegerMax;
        [f getRow:&r0 indexInRow:&c0 forCharacterIndex:i];
        [f getRow:&r1 indexInRow:NULL forCharacterIndex:i];
        [f getRow:NULL indexInRow:&c2 forCharacterIndex:i];
        XCTAssertEqual(r0, r1);
        XCTAssertEqual(c0, c2);
    }
}


@end
