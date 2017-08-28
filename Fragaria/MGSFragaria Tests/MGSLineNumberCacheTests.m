//
//  MGSLineNumberCacheTests.m
//  Fragaria
//
//  Created by Daniele Cattaneo on 13/12/15.
//
//

#import <XCTest/XCTest.h>
#import <Cocoa/Cocoa.h>
#import "NSTextStorage+Fragaria.h"


@interface MGSLineNumberCacheTests : XCTestCase

@end


@implementation MGSLineNumberCacheTests


- (void)testEmptyStorage
{
    NSTextStorage *ts;
    
    ts = [[NSTextStorage alloc] init];
    [self realTestExaustiveLine:0 inTextStorage:ts start:0 end:0 contentsEnd:0];
    [self realTestIntegerMaxOnTextStorage:ts];
}


- (void)testSingleUnixNewline
{
    NSTextStorage *ts;
    
    ts = [[NSTextStorage alloc] initWithString:@"\n"];
    [self realTestExaustiveLine:0 inTextStorage:ts start:0 end:1 contentsEnd:0];
    [self realTestIntegerMaxOnTextStorage:ts];
}


- (void)testSingleDOSNewline
{
    NSTextStorage *ts;
    
    ts = [[NSTextStorage alloc] initWithString:@"\r\n"];
    [self realTestExaustiveLine:0 inTextStorage:ts start:0 end:2 contentsEnd:0];
    [self realTestIntegerMaxOnTextStorage:ts];
}


- (void)testSingleMacintoshNewline
{
    NSTextStorage *ts;
    
    ts = [[NSTextStorage alloc] initWithString:@"\r"];
    [self realTestExaustiveLine:0 inTextStorage:ts start:0 end:1 contentsEnd:0];
    [self realTestIntegerMaxOnTextStorage:ts];
}


- (void)testStringWithTrailingNewline
{
    NSTextStorage *ts;
    
    ts = [[NSTextStorage alloc] initWithString:@"1234\n6789ABCD\n\nGHIJK\n"];
    [self realTestExaustiveLine:0 inTextStorage:ts start:0 end:5 contentsEnd:4];
    [self realTestExaustiveLine:1 inTextStorage:ts start:5 end:14 contentsEnd:13];
    [self realTestExaustiveLine:2 inTextStorage:ts start:14 end:15 contentsEnd:14];
    [self realTestExaustiveLine:3 inTextStorage:ts start:15 end:21 contentsEnd:20];
    [self realTestIntegerMaxOnTextStorage:ts];
}


- (void)testStringWithoutTrailingNewline
{
    NSTextStorage *ts;
    
    ts = [[NSTextStorage alloc] initWithString:@"1234\n6789ABCD\n\nGHIJK"];
    [self realTestExaustiveLine:0 inTextStorage:ts start:0 end:5 contentsEnd:4];
    [self realTestExaustiveLine:1 inTextStorage:ts start:5 end:14 contentsEnd:13];
    [self realTestExaustiveLine:2 inTextStorage:ts start:14 end:15 contentsEnd:14];
    [self realTestExaustiveLine:3 inTextStorage:ts start:15 end:20 contentsEnd:20];
    [self realTestIntegerMaxOnTextStorage:ts];
}


- (void)testEditing
{
    NSTextStorage *ts;
    
    ts = [[NSTextStorage alloc] initWithString:@"1234\n6789ABCD\n\nGHI"];
    [self realTestExaustiveLine:0 inTextStorage:ts start:0 end:5 contentsEnd:4];
    [self realTestExaustiveLine:1 inTextStorage:ts start:5 end:14 contentsEnd:13];
    [self realTestExaustiveLine:2 inTextStorage:ts start:14 end:15 contentsEnd:14];
    [self realTestExaustiveLine:3 inTextStorage:ts start:15 end:18 contentsEnd:18];
    [self realTestIntegerMaxOnTextStorage:ts];
    
    [ts.mutableString replaceCharactersInRange:NSMakeRange(13, 1) withString:@"E"];
    [ts.mutableString appendString:@"JK"];
    /* resulting string: 1234\n6789ABCDE\nGHIJK */
    [self realTestExaustiveLine:0 inTextStorage:ts start:0 end:5 contentsEnd:4];
    [self realTestExaustiveLine:1 inTextStorage:ts start:5 end:15 contentsEnd:14];
    [self realTestExaustiveLine:2 inTextStorage:ts start:15 end:20 contentsEnd:20];
    [self realTestIntegerMaxOnTextStorage:ts];
    
    [ts replaceCharactersInRange:NSMakeRange(9, 9) withString:@"ABCDEFGHIJ\nLMNOP\nRST\n"];
    /* resulting string: 1234\n6789ABCDEFGHIJ\nLMNOP\nRST\nJK */
    [self realTestExaustiveLine:0 inTextStorage:ts start:0 end:5 contentsEnd:4];
    [self realTestExaustiveLine:1 inTextStorage:ts start:5 end:20 contentsEnd:19];
    [self realTestExaustiveLine:2 inTextStorage:ts start:20 end:26 contentsEnd:25];
    [self realTestExaustiveLine:3 inTextStorage:ts start:26 end:30 contentsEnd:29];
    [self realTestExaustiveLine:4 inTextStorage:ts start:30 end:32 contentsEnd:32];
    [self realTestIntegerMaxOnTextStorage:ts];
    
    [ts replaceCharactersInRange:NSMakeRange(30, 2) withString:@""];
    /* resulting string: 1234\n6789ABCDEFGHIJ\nLMNOP\nRST\n */
    [self realTestExaustiveLine:0 inTextStorage:ts start:0 end:5 contentsEnd:4];
    [self realTestExaustiveLine:1 inTextStorage:ts start:5 end:20 contentsEnd:19];
    [self realTestExaustiveLine:2 inTextStorage:ts start:20 end:26 contentsEnd:25];
    [self realTestExaustiveLine:3 inTextStorage:ts start:26 end:30 contentsEnd:29];
    [self realTestExaustiveLine:4 inTextStorage:ts start:30 end:30 contentsEnd:30];
    [self realTestIntegerMaxOnTextStorage:ts];
    
    [ts replaceCharactersInRange:NSMakeRange(29, 1) withString:@""];
    /* resulting string: 1234\n6789ABCDEFGHIJ\nLMNOP\nRST */
    [self realTestExaustiveLine:0 inTextStorage:ts start:0 end:5 contentsEnd:4];
    [self realTestExaustiveLine:1 inTextStorage:ts start:5 end:20 contentsEnd:19];
    [self realTestExaustiveLine:2 inTextStorage:ts start:20 end:26 contentsEnd:25];
    [self realTestExaustiveLine:3 inTextStorage:ts start:26 end:29 contentsEnd:29];
    [self realTestIntegerMaxOnTextStorage:ts];
    
    [ts replaceCharactersInRange:NSMakeRange(4, 1) withString:@"5"];
    /* resulting string: 123456789ABCDEFGHIJ\nLMNOP\nRST */
    [self realTestExaustiveLine:0 inTextStorage:ts start:0 end:20 contentsEnd:19];
    [self realTestExaustiveLine:1 inTextStorage:ts start:20 end:26 contentsEnd:25];
    [self realTestExaustiveLine:2 inTextStorage:ts start:26 end:29 contentsEnd:29];
    [self realTestIntegerMaxOnTextStorage:ts];
}


- (void)testLineNumberCache
{
    NSTextStorage *ts;
    
    ts = [[NSTextStorage alloc] initWithString:@"1234\n56789A\nBCDEF"];
    XCTAssertEqual([ts mgs_rowOfCharacter:ts.length-1], (NSUInteger)2);
    XCTAssertEqual([ts mgs_lineCount], (NSUInteger)3);
    
    [ts replaceCharactersInRange:NSMakeRange(4,1) withString:@""];
    [ts replaceCharactersInRange:NSMakeRange(10,1) withString:@""];
    /* resulting string: 123456789ABCDEF */
    XCTAssertEqual([ts mgs_lineCount], (NSUInteger)1);
    XCTAssertEqual([ts mgs_rowOfCharacter:ts.length-1], (NSUInteger)0);
    
    [ts replaceCharactersInRange:NSMakeRange(4,0) withString:@"\n\n\n"];
    /* resulting string: 1234\n\n\n56789ABCDEF */
    XCTAssertEqual([ts mgs_lineCount], (NSUInteger)4);
    XCTAssertEqual([ts mgs_rowOfCharacter:ts.length-1], (NSUInteger)3);
    
    [ts replaceCharactersInRange:NSMakeRange(5,1) withString:@""];
    /* resulting string: 1234\n\n56789ABCDEF */
    XCTAssertEqual([ts mgs_lineCount], (NSUInteger)3);
    XCTAssertEqual([ts mgs_rowOfCharacter:ts.length-1], (NSUInteger)2);
    
    [ts replaceCharactersInRange:NSMakeRange(ts.length,0) withString:@"\n\n\n"];
    /* resulting string: 1234\n\n56789ABCDEF\n\n\n */
    XCTAssertEqual([ts mgs_lineCount], (NSUInteger)6);
    XCTAssertEqual([ts mgs_rowOfCharacter:ts.length-1], (NSUInteger)4);
    
    [ts replaceCharactersInRange:NSMakeRange(ts.length-3,0) withString:@"\r\n"];
    /* resulting string: 1234\n\n56789ABCDEF\r\n\n\n\n */
    XCTAssertEqual([ts mgs_lineCount], (NSUInteger)7);
    XCTAssertEqual([ts mgs_rowOfCharacter:ts.length-1], (NSUInteger)5);
    
    [ts replaceCharactersInRange:NSMakeRange(ts.length-4,0) withString:@"G"];
    /* resulting string: 1234\n\n56789ABCDEF\rG\n\n\n\n */
    XCTAssertEqual([ts mgs_lineCount], (NSUInteger)8);
    XCTAssertEqual([ts mgs_rowOfCharacter:ts.length-1], (NSUInteger)6);
    
    [ts replaceCharactersInRange:NSMakeRange(6,1) withString:@""];
    /* resulting string: 1234\n\n6789ABCDEF\rG\n\n\n\n */
    XCTAssertEqual([ts mgs_lineCount], (NSUInteger)8);
    XCTAssertEqual([ts mgs_rowOfCharacter:ts.length-1], (NSUInteger)6);
    
    [ts replaceCharactersInRange:NSMakeRange(3,1) withString:@""];
    /* resulting string: 123\n\n6789ABCDEF\rG\n\n\n\n */
    XCTAssertEqual([ts mgs_lineCount], (NSUInteger)8);
    XCTAssertEqual([ts mgs_rowOfCharacter:ts.length-1], (NSUInteger)6);
    
    [ts replaceCharactersInRange:NSMakeRange(ts.length-5,1) withString:@""];
    /* resulting string: 123\n\n6789ABCDEF\r\n\n\n\n */
    XCTAssertEqual([ts mgs_lineCount], (NSUInteger)7);
    XCTAssertEqual([ts mgs_rowOfCharacter:ts.length-1], (NSUInteger)5);
    
    [ts replaceCharactersInRange:NSMakeRange(0,ts.length) withString:@""];
    /* resulting string:  */
    XCTAssertEqual([ts mgs_lineCount], (NSUInteger)1);
}


- (void)realTestExaustiveLine:(NSUInteger)l inTextStorage:(NSTextStorage *)ts start:(NSUInteger)s end:(NSUInteger)e contentsEnd:(NSUInteger)ce
{
    NSUInteger i;
    
    if (s != 0)
        XCTAssertEqual([ts mgs_rowOfCharacter:s-1], (NSUInteger)l-1,
                   @"Character %lu is not on the previous line", (unsigned long)s-1);
    
    for (i=s; i<e; i++) {
        XCTAssertEqual([ts mgs_rowOfCharacter:i], (NSUInteger)l,
                       @"Character %lu is not on its line", (unsigned long)i);
    }
    if (ce != e) {
        XCTAssertEqual([ts mgs_rowOfCharacter:e], (NSUInteger)l+1,
                   @"After a newline, character %lu is not on the next line", (unsigned long)e);
        if (e == [ts length])
            XCTAssertEqual([ts mgs_rowOfCharacter:e+1], (NSUInteger)NSNotFound,
                           @"Inexistent character %lu found", (unsigned long)e+1);
    } else {
        XCTAssertEqual([ts mgs_rowOfCharacter:e], (NSUInteger)l,
                   @"Without a newline, character %lu is not on the same line", (unsigned long)e);
        XCTAssertEqual([ts mgs_rowOfCharacter:e+1], (NSUInteger)NSNotFound,
                   @"Inexistent character %lu found", (unsigned long)e+1);
    }
    
    
    XCTAssertEqual([ts mgs_firstCharacterInRow:l], (NSUInteger)s,
                   @"Line %ld does not begin with character %lu", (unsigned long)l, (unsigned long)s);
    if (ce != e) {
        XCTAssertEqual([ts mgs_firstCharacterInRow:l+1], (NSUInteger)e,
                    @"Next line %lu does not begin with character %lu", (unsigned long)l+1, (unsigned long)e);
        if (e == [ts length])
            XCTAssertEqual([ts mgs_firstCharacterInRow:l+2], (NSUInteger)NSNotFound,
                           @"Found inexistent line %lu", (unsigned long)l+2);
    } else
        XCTAssertEqual([ts mgs_firstCharacterInRow:l+1], (NSUInteger)NSNotFound,
                       @"Found inexistent line %lu", (unsigned long)l+1);
    
    
    for (i=s; i<ce; i++) {
        XCTAssertEqual([ts mgs_characterAtIndex:i-s withinRow:l], (NSUInteger)i,
                   @"Character %lu within row %lu is not %lu", (unsigned long)(i-s), (unsigned long)l, (unsigned long)i);
    }
    for (i=ce; i<e+10; i++) {
        XCTAssertEqual([ts mgs_characterAtIndex:i-s withinRow:l], (NSUInteger)ce,
                       @"%@ Character %lu within row %lu is not %lu", i < e ? @"Newline" : @"",
                       (unsigned long)(i-s), (unsigned long)l, (unsigned long)ce);
    }
    XCTAssertEqual([ts mgs_characterAtIndex:NSUIntegerMax withinRow:l], (NSUInteger)ce,
                   @"NSUIntegerMax not correctly handled");
    if (ce == e) {
        XCTAssertEqual([ts mgs_characterAtIndex:0 withinRow:l+1], (NSUInteger)NSNotFound,
                       @"Found a line which does not exist");
        XCTAssertEqual([ts mgs_characterAtIndex:1 withinRow:l+1], (NSUInteger)NSNotFound,
                       @"Found a line which does not exist");
        XCTAssertEqual([ts mgs_characterAtIndex:NSUIntegerMax withinRow:l+1], (NSUInteger)NSNotFound,
                   @"NSUIntegerMax not correctly handled in an inexistent line");
    } else {
        XCTAssertEqual([ts mgs_characterAtIndex:0 withinRow:l+1], (NSUInteger)e,
                       @"Next line does not start at %lu", (unsigned long)e);
    }
}


- (void)realTestIntegerMaxOnTextStorage:(NSTextStorage *)ts
{
    XCTAssertEqual([ts mgs_rowOfCharacter:NSUIntegerMax], (NSUInteger)NSNotFound,
                   @"NSUIntegerMax not correctly handled");
    XCTAssertEqual([ts mgs_firstCharacterInRow:NSUIntegerMax], (NSUInteger)NSNotFound,
                   @"NSUIntegerMax not correctly handled");
    XCTAssertEqual([ts mgs_characterAtIndex:0 withinRow:NSUIntegerMax], (NSUInteger)NSNotFound,
                   @"Found a line which does not exist");
    XCTAssertEqual([ts mgs_characterAtIndex:1 withinRow:NSUIntegerMax], (NSUInteger)NSNotFound,
                   @"Found a line which does not exist");
    XCTAssertEqual([ts mgs_characterAtIndex:NSUIntegerMax withinRow:NSUIntegerMax], (NSUInteger)NSNotFound,
                   @"NSUIntegerMax not correctly handled in an inexistent line");
}


@end
