//
//  MGSSimpleBreakpointDelegate.h
//  Fragaria
//
//  Created by Daniele Cattaneo on 29/01/15.
//
//

#import <Foundation/Foundation.h>
#import <Fragaria/Fragaria.h>


@interface MGSSimpleBreakpointDelegate : NSObject <MGSBreakpointDelegate> {
    NSMutableSet *breakpoints;
}

@end
