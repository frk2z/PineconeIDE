//
//  PineconeCommands.m
//  PineconeIDE
//
//  Created by frk2z on 26/08/2017.
//

#import "PineconeCommands.h"

//
// Functions
//

@implementation Pinecone

+ (NSString *)exec:(NSString *)path args:(NSArray<NSString *> *)args {
	// Initialize pipe and task
	NSPipe *pipe = [NSPipe pipe];
	NSTask *task = [[NSTask alloc] init];
	// Setup the task and set the output to the pipe
	task.launchPath = path;
	task.arguments = args;
	task.standardOutput = pipe;
	// Launch the task and wait for it to end to make sure that we have the whole output
	[task launch];
	[task waitUntilExit];
	// Read the output and translate it to NSString*
	return [[NSString alloc] initWithData:
			[[pipe fileHandleForReading] readDataToEndOfFile] encoding:NSUTF8StringEncoding];
}

+ (NSString *)searchPineconePath {
	// Execute the command "which pinecone"
	// It should return something like @"/usr/local/bin/pinecone"
	return [self exec:@"which" args:@[@"pinecone"]];
}

+ (NSAppleEventDescriptor *)pinecone:(NSString *)args {
	// cmd now has the format "pinecone args"
	NSString *cmd = [@"pinecone " stringByAppendingString:args];
	// Escape all backslashes
	cmd = [cmd stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
	// Escape all double-quotes
	cmd = [cmd stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
	// Use printf to show a message, read to pause, and exit to close the terminal
	cmd = [cmd stringByAppendingString:@"; printf \\\"\\\\n-== Press ENTER to exit ==-\\\"; read; exit"];
	// Create a program in AppleScript to open Terminal.app and execute the command
	cmd = [NSString stringWithFormat:@"tell application \"Terminal\" to do script\"%@\"", cmd];
	// Initialize NSAppleScript using the tiny program that we wrote before
	NSAppleScript *as = [[NSAppleScript alloc] initWithSource:cmd];
	// Execute it and return the result as NSAppleEventDescriptor*
	return [as executeAndReturnError:nil];
}

+ (void)saveAsType:(NSString *)type origin:(NSString *)path {
	// Initialize a save panel
	NSSavePanel *sp = [NSSavePanel savePanel];
	// Set its title
	[sp setTitle:[NSString stringWithFormat:@"Save %@ as %@ file", [path lastPathComponent], type]];
	// Force the user to save it as the type given
	[sp setAllowedFileTypes:@[type]];
	// If the user pressed OK, save the document
	[sp beginWithCompletionHandler:^(NSInteger result) { if (result == NSOKButton) {
		// Get the save path as NSString*
		NSString *savePath = [[sp URL] path];
		// execute the command : pinecone IN_FILE -TYPE -OUT_FILE
		[self pinecone:[NSString stringWithFormat:@"%@ -%@ %@", path, type, savePath]];
	}}];
}

@end
