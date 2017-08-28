//
//  MGSSimpleBreakpointDelegate.m
//  Fragaria
//
//  Created by Daniele Cattaneo on 29/01/15.
//
//

#import "MGSSampleBreakpointDelegate.h"


@implementation MGSSampleBreakpointDelegate


/*
 *  -init
 */
- (instancetype)init
{
    self = [super init];
    breakpoints = [[NSMutableIndexSet alloc] init];
    return self;
}


/*
 *  -breakpointColourForLine:ofFragaria:
 */
- (NSColor *)breakpointColourForLine:(NSUInteger)line ofFragaria:(MGSFragariaView *)sender
{
	if (line % 2 == 0)
        /* Non-standard-color breakpoint */
        return [NSColor orangeColor];
    
    if (line % 3 == 0)
        /* Transparent breakpoint */
        return [[NSColor greenColor] colorWithAlphaComponent:0.25];
    
    /* Standard color breakpoint */
    return nil;
}


/*
 * -toggleBreakpointForFragaria:onLine:
 */
- (void)toggleBreakpointForFragaria:(MGSFragariaView *)sender onLine:(NSUInteger)line
{
    if ([breakpoints containsIndex:line])
        [breakpoints removeIndex:line];
    else
        [breakpoints addIndex:line];
}


/*
 *   -fixBreakpointsOfAddedLines:inLineRange:ofFragaria:
 *
 *  We want to keep our breakpoints in sync with the movement of the text.
 *    newRange is a range of lines that were edited, and delta is the amount of
 *  lines added (or removed, if negative).
 *    If delta is positive, we just want to shift the existing breakpoints
 *  down delta lines, from the beginning of the added range. If delta is
 *  negative, we also want to move the breakpoints that were located on lines 
 *  that do not exist anymore.
 */
- (void)fixBreakpointsOfAddedLines:(NSInteger)delta inLineRange:(NSRange)newRange ofFragaria:(MGSFragariaView *)sender
{
    NSRange oldRange;
    BOOL changed = NO;
    NSUInteger tmp, minAffectedIdx;
    
    oldRange = newRange;
    oldRange.length -= delta;
    
    if (delta < 0) {
        tmp = [breakpoints indexLessThanIndex:NSMaxRange(oldRange)];
        if (tmp != NSNotFound && tmp >= NSMaxRange(newRange)) {
            /* Move all breakpoints that were located in deleted lines to the
             * end of the new range. */
            [breakpoints addIndex:NSMaxRange(newRange)-1];
            changed = YES;
        }
        minAffectedIdx = NSMaxRange(newRange);
    } else {
        minAffectedIdx = NSMaxRange(oldRange);
    }
    
    if ([breakpoints indexGreaterThanOrEqualToIndex:minAffectedIdx] != NSNotFound) {
        [breakpoints shiftIndexesStartingAtIndex:NSMaxRange(oldRange) by:delta];
        changed = YES;
    }
    if (changed)
        [sender reloadBreakpointData];
}


/*
 *  -breakpointsForFragaria:
 */
- (NSIndexSet *)breakpointsForFragaria:(MGSFragariaView *)sender
{
    return [breakpoints copy];
}


- (NSMenu *)menuForBreakpointInLine:(NSUInteger)line ofFragaria:(MGSFragariaView *)sender
{
    if ([breakpoints containsIndex:line]) {
        NSMenu *menu = [[NSMenu alloc] init];
        [menu addItemWithTitle:@"Menu item example" action:nil keyEquivalent:@""];
        return menu;
    }
    return nil;
}


@end
