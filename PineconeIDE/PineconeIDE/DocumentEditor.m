//
//  DocumentEditor.m
//  PineconeIDE
//
//  Created by frk2z on 26/08/2017.
//

#import "DocumentEditor.h"

@implementation DocumentEditor

- (id)init {
	if ((self = [super init])) {
		// This is the default content of a document
		self->contents = [[NSTextStorage alloc] initWithString:@""];
	}
	return self;
}

- (void)setSyntaxDefinition:(NSString *)name {
	// Not sure if necessary but keeping it just in case
	viewDoc.syntaxDefinitionName = name;
}

- (NSString *)syntaxDefinition {
	// Not sure if necessary but keeping it just in case
	return viewDoc.syntaxDefinitionName;
}

- (NSString *)windowNibName {
    return @"DocumentEditor";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
	
	viewDoc.textViewDelegate = self;
	viewDoc.syntaxColoured = YES;
	viewDoc.showsLineNumbers = YES;
	
	// Set the syntax definition and set the default text storage
	// List of all syntax definitions supported by the modified Fragaria inside :
	// Fragaria(project)/Framework/Resources/SyntaxDefinitions.plist
	// Languages added : Pinecone, TI-Basic
	[viewDoc setSyntaxDefinitionName:@"Pinecone"];
	[viewDoc replaceTextStorage:self->contents];
	
	// Make sure Fragaria knows that this document exits
	[[MGSUserDefaultsController sharedController] addFragariaToManagedSet:viewDoc];
	
	// Make Undo/Redo possible
	[self setUndoManager:[viewDoc.textView undoManager]];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
	if (outError) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:nil];
	}
	// Get current document data
	return [[self->contents string] dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
	if (outError) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:nil];
	}
	
	// Create a text storage from given data
	NSTextStorage *ts;
	ts = [[NSTextStorage alloc] initWithData:data options:@{NSDocumentTypeDocumentOption:NSPlainTextDocumentType, NSCharacterEncodingDocumentOption:@(NSUTF8StringEncoding)} documentAttributes:nil error:outError];
	
	// If the data could be read and put in the text storage, set it as the document's content
	if (ts) {
		self->contents = ts;
		// Success
		return YES;
	}
	// Failure
	return NO;
}

- (void)close {
	// Make sure that Fragaria knows that this document has been closed
	[[MGSUserDefaultsController sharedController] removeFragariaFromManagedSet:viewDoc];
	// ...Then really close it
	[super close];
}

+ (BOOL)autosavesInPlace {
	// Save the document if the app crashes/force quit
	return YES;
}

@end
