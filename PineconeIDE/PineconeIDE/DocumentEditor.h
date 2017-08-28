//
//  DocumentEditor.h
//  PineconeIDE
//
//  Created by frk2z on 26/08/2017.
//

#import "Fragaria/Fragaria.h"

@interface DocumentEditor : NSDocument <MGSFragariaTextViewDelegate, SMLSyntaxColouringDelegate, MGSDragOperationDelegate> {
	__weak IBOutlet MGSFragariaView *viewDoc;
	 NSTextStorage *contents;
}

@end
