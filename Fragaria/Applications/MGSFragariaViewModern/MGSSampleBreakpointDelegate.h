//
//  MGSSimpleBreakpointDelegate.h
//  Fragaria
//
//  Created by Daniele Cattaneo on 29/01/15.
//
//

#import <Foundation/Foundation.h>
#import <Fragaria/Fragaria.h>


/**
 *  This class serves as an example on how to use an external delegate class
 *  with MGSFragariaView.
 **/
@interface MGSSampleBreakpointDelegate : NSObject <MGSBreakpointDelegate> {
    NSMutableIndexSet *breakpoints;
}

@end
