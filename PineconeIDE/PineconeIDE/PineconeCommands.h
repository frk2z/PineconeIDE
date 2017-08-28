//
//  PineconeCommands.h
//  PineconeIDE
//
//  Created by frk2z on 27/08/2017.
//

#import <Cocoa/Cocoa.h>

@interface Pinecone : NSObject


/**
 Execute a program with some arguments
 
 @param path Path to the program
 @param args Arguments given to the program (can be empty)
 @return Result of the command
 */
+ (NSString *)exec:(NSString *)path args:(NSArray<NSString *> *)args;

/**
 Get the path to the "pinecone" executable using "whitch" (can be really slow)

 @return Path to "pinecone"
 */
+ (NSString *)searchPineconePath;

/**
 Execute the "pinecone" executable in Terminal.app using NSAppleScript

 @param args Arguments given to "pinecone"
 @return Result of the command (as NSAppleEventDescriptor)
 */
+ (NSAppleEventDescriptor *)pinecone:(NSString *)args;

/**
 Ask the user a path and a name and use [Pinecone pinecone:] to transpile it
 The original file should be saved before calling this function

 @param type Will be used in the command "pinecone IN_FILE -TYPE OUT_FILE
 @param path Path to the original file
 */
+ (void)saveAsType:(NSString *)type origin:(NSString *)path;

@end
