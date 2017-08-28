//
//  ApplicationDelegate.m
//  Fragaria
//
//  Created by Daniele Cattaneo on 30/05/15.
//
//

#import "ApplicationDelegate.h"
#import <Fragaria/Fragaria.h>
#import "MASPreferencesWindowController.h"


@implementation ApplicationDelegate {
    MASPreferencesWindowController *prefsWindow;
}


- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    MGSUserDefaultsController *shc;
    NSMutableSet *tmp;
    
    shc = [MGSUserDefaultsController sharedController];
    
    tmp = [[shc managedProperties] mutableCopy];
    [tmp removeObject:MGSFragariaDefaultsSyntaxDefinitionName];
    [shc setManagedProperties:tmp];
    
    [shc setPersistent:YES];
}


- (IBAction)openPreferences:(id)sender
{
    NSArray *c;
    NSViewController *color, *editor;
    
    if (!prefsWindow) {
        color = [[MGSPrefsColourPropertiesViewController alloc] init];
        editor = [[MGSPrefsEditorPropertiesViewController alloc] init];
        c = @[color, editor];
        prefsWindow = [[MASPreferencesWindowController alloc] initWithViewControllers:c];
    }
    [prefsWindow showWindow:self];
}


@end
