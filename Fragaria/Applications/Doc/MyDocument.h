//
//  MyDocument.h
//  Fragaria Document
//
//  Created by Jonathan on 24/07/2010.
//  Copyright 2010 mugginsoft.com. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <Fragaria/Fragaria.h>


@class MGSFragariaView;

@interface MyDocument : NSDocument <MGSFragariaTextViewDelegate, SMLSyntaxColouringDelegate, MGSDragOperationDelegate>

@property (nonatomic,assign) NSString *syntaxDefinition;
@property NSTextStorage *contents;

@end
