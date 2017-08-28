//
//  AppDelegate.h
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/03/15.
//
//  A playground and demonstration for MGSFragariaView and the new-style
//  preferences panels.
//
//

#import <Cocoa/Cocoa.h>
#import <Fragaria/Fragaria.h>


/**
 *  This application delegate serves as the main delegate and application
 *  controller for the MGSFragariaViewModern application target. It demos
 *  most of the major features provided my MGSFragariaView.
 **/
@interface AppDelegate : NSObject <NSApplicationDelegate, MGSBreakpointDelegate, MGSDragOperationDelegate>

@property (nonatomic, assign, readonly) NSArray *availableSyntaxDefinitions;

@end

