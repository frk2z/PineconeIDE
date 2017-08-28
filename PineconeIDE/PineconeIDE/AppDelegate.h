//
//  AppDelegate.h
//  PineconeIDE
//
//  Created by frk2z on 26/08/2017.
//

#import "Fragaria/Fragaria.h"
#import "MASPreferencesWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
	/// Default preferences window
	MASPreferencesWindowController *prefsWindow;
	
	__weak IBOutlet NSMenuItem *itemSaveAndRun;
	__weak IBOutlet NSMenuItem *itemSaveAsBinFile;
	__weak IBOutlet NSMenuItem *itemSaveAsCppFile;
	
}

@end
