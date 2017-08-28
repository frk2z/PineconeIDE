//
//  AppDelegate.h
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/02/07.
//
//  A playground and demonstration for MGSFragariaView, and
//  Fragaria and Smultron in general.
//

#import "AppDelegate.h"
#import <Fragaria/Fragaria.h>
#import "FeaturesWindowController.h"


#pragma mark - PRIVATE INTERFACE


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet MGSFragariaView *viewTop;

@property (weak) IBOutlet MGSFragariaView *viewBottom;


@property (nonatomic, strong) FeaturesWindowController *featuresWindowController;


@property (strong) NSArray *breakpoints;

@end


#pragma mark - IMPLEMENTATION


@implementation AppDelegate

@synthesize featuresWindowController = _featuresWindowController;


#pragma mark - Initialization and Setup


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	applicationDidFinishLaunching:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	#pragma unused(aNotification)

    /* Get a sample file to pre-populate the views. */
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Lorem" ofType:@"html"];
    NSString *fileContent;
    NSError *error;
    if (file)
    {
        fileContent = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    }
    if (!file || error)
    {
        fileContent = @"<p>There was a nice file to load for you, but some reason I couldn't open it.</p>";
    }

    /* Make the upper view interesting. */
    self.viewTop.textView.string = fileContent;
    self.viewTop.startingLineNumber = 314;
	self.viewTop.showsLineNumbers = YES;

    /* Make the lower view interesting. */
    [self.viewBottom replaceTextStorage:self.viewTop.textView.textStorage];
	self.viewBottom.showsLineNumbers = YES;


	/* Sample Syntax Error Definitions */
    self.viewTop.syntaxErrors = [self makeSyntaxErrors];
}


#pragma mark - Property Accessors

/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	@featuresWindowController
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (NSWindowController *)featuresWindowController
{
    if (!_featuresWindowController)
    {
        _featuresWindowController = [[FeaturesWindowController alloc] initWithWindowNibName:@"Features"];
        _featuresWindowController.viewTop = self.viewTop;
        _featuresWindowController.viewBottom = self.viewBottom;
    }
    return _featuresWindowController;
}


#pragma mark - Delegate methods

/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	textDidChange:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)textDidChange:(NSNotification *)notification
{
	#pragma unused(notification)
	NSLog(@"%@", @"textDidChange: notification.");
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	breakpointsForView:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (NSSet*) breakpointsForFragaria:(id)sender
{
    return [NSSet setWithArray:self.breakpoints];
}

/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	toggleBreakpointForFragaria:onLine
        This simple demonstration simply toggles breakpoints every
        time the line number is clicked.
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)toggleBreakpointForFragaria:(id)sender onLine:(NSUInteger)line;
{
	if ([self.breakpoints containsObject:@(line)])
	{
		self.breakpoints = [self.breakpoints filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
			return ![evaluatedObject isEqualToValue:@(line)];
		}]];
	}
	else
	{
		if (self.breakpoints)
		{
			self.breakpoints = [self.breakpoints arrayByAddingObject:@(line)];
		}
		else
		{
			self.breakpoints = @[@(line)];
		}
	}
	
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	concludeDragOperation:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
	#pragma unused(sender)
	NSLog(@"%@", @"concludeDragOperation: delegate method.");
}


#pragma mark - UI Handling

/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	openFeatures:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (IBAction)openFeatures:(id)sender
{
    [self.featuresWindowController showWindow:nil];
}


#pragma mark - Private

/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	makeSyntaxErrors
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (NSArray *)makeSyntaxErrors
{
    SMLSyntaxError *error1 = [SMLSyntaxError errorWithDictionary:@{
                                                                   @"errorDescription" : @"Syntax errors can be defined",
                                                                   @"line" : @(4),
                                                                   @"character" : @(3),
                                                                   @"length" : @(5),
                                                                   @"hidden" : @(NO),
                                                                   @"warningLevel" : @(kMGSErrorCategoryError)
                                                                   }];

    SMLSyntaxError *error2 = [[SMLSyntaxError alloc] initWithDictionary:@{
                                                                          @"errorDescription" : @"Multiple syntax errors can be defined for the same line, too.",
                                                                          @"line" : @(4),
                                                                          @"character" : @(12),
                                                                          @"length" : @(7),
                                                                          @"hidden" : @(NO),
                                                                          @"warningLevel" : @(kMGSErrorCategoryAccess)
                                                                          }];

    SMLSyntaxError *error3 = [[SMLSyntaxError alloc] init];
    error3.errorDescription = @"This error will appear on top of a line break.";
    error3.line = 6;
    error3.character = 1;
    error3.length = 2;
    error3.hidden = NO;
    error3.warningLevel = kMGSErrorCategoryConfig;

    SMLSyntaxError *error4 = [SMLSyntaxError new];
    error4.errorDescription = @"This error will not be hidden.";
    error4.line = 10;
    error4.character = 12;
    error4.length = 7;
    error4.hidden = NO;
    
    SMLSyntaxError *error5 = [SMLSyntaxError errorWithDescription:@"Yet another error" ofLevel:-912454 atLine:5];

    return @[error1, error2, error3, error4, error5];
}


@end
