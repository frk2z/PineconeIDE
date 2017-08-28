//
//  FragariaAppDelegate.h
//  Fragaria
//
//  Created by Jonathan on 30/04/2010.
//  Copyright 2010 mugginsoft.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Fragaria/Fragaria.h>

@class SMLTextView;
@class MGSSimpleBreakpointDelegate;

@interface FragariaAppDelegate : NSObject <NSApplicationDelegate, MGSFragariaTextViewDelegate, SMLSyntaxColouringDelegate, MGSDragOperationDelegate>

- (IBAction)copyToPasteBoard:(id)sender;
- (IBAction)reloadString:(id)sender;

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic,assign) NSString *syntaxDefinition;

@property NSString *row;
@property NSString *column;


@end
