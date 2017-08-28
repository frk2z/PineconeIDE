//
//  AppDelegate.m
//  PineconeIDE
//
//  Created by frk2z on 26/08/2017.
//

//
// TODOs
//

// TODOs Here

//
// Code
//

#import "AppDelegate.h"

// Unused but can be used to save as cpp or bin quickly
#define CHANGE_PATH_EXTENSION(path, new_ext) [[path stringByDeletingPathExtension] stringByAppendingPathExtension:new_ext]

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	MGSUserDefaultsController *shc = [MGSUserDefaultsController sharedController];
	NSMutableSet *tmp;
	
	// Load saved user preferences
	tmp = [[shc managedProperties] mutableCopy];
	[tmp removeObject:MGSFragariaDefaultsSyntaxDefinitionName];
	[shc setManagedProperties:tmp];
	
	// Make the app able to save the preferences of the user
	[shc setPersistent:YES];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	/*//Check that pinecone is installed at launch but slow down the app
	NSString *pineconePath = [Pinecone searchPineconePath];
	if (!pineconePath || [pineconePath isEqualToString:@""]) {
		// Disable compilling & running
		itemSaveAndRun.enabled = NO;
		itemSaveAsBinFile.enabled = NO;
		itemSaveAsCppFile.enabled = NO;
	}*/
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
	// This is pretty much self-explainatory, so just read the method's name for the documentation
	return YES;
}

- (NSDocument *)getActiveDocument {
	// Get the opened documents
	NSArray *docs = [[NSApplication sharedApplication] orderedDocuments];
	// Check that at least 1 document is opened
	if ([docs count] != 0) {
		// Return the most recently active one
		return docs[0];
	}
	// Return nil if no documents are active
	return nil;
}

- (IBAction)openPreferences:(id)sender {
	NSArray *c;
	NSViewController *color, *editor;
	// If the preferences window ain't initialized, do it
	// Also add the preferences Colors and Editor
	if (!prefsWindow) {
		color = [[MGSPrefsColourPropertiesViewController alloc] init];
		editor = [[MGSPrefsEditorPropertiesViewController alloc] init];
		c = @[color, editor];
		prefsWindow = [[MASPreferencesWindowController alloc] initWithViewControllers:c];
	}
	// Now that we checked that everything was initialized, show the preferences
	[prefsWindow showWindow:self];
}

- (IBAction)saveAndRun:(id)sender {
	// Save the document if not already done
	NSDocument *mainDoc = [self getActiveDocument];
	if (mainDoc.documentEdited || mainDoc.isDraft) [mainDoc saveDocument:self];
	NSString *path = [mainDoc.fileURL path];
	if (!path) return;
	// Run the document in Terminal.app
	[Pinecone pinecone:[path stringByAppendingString:@" -r"]];
}

- (IBAction)saveAsBinFile:(id)sender {
	// Save the document if not already done
	NSDocument *mainDoc = [self getActiveDocument];
	if (mainDoc.documentEdited || mainDoc.isDraft) [mainDoc saveDocument:self];
	NSString *path = [mainDoc.fileURL path];
	if (!path) return;
	// Use Termianl.app and pinecone to save the document as bin
	[Pinecone saveAsType:@"bin" origin:path];
}

- (IBAction)saveAsCppFile:(id)sender {
	// Save the document if not already done
	NSDocument *mainDoc = [self getActiveDocument];
	if (mainDoc.documentEdited || mainDoc.isDraft) [mainDoc saveDocument:self];
	NSString *path = [mainDoc.fileURL path];
	if (!path) return;
	// Use Termianl.app and pinecone to save the document as cpp
	[Pinecone saveAsType:@"cpp" origin:path];
}

@end
