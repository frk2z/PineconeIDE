//
//  FeaturesWindowController.h
//  Fragaria
//
//  Created by Jim Derry on 2/26/15.
//
//

#import <Cocoa/Cocoa.h>

@class MGSFragariaView;


@interface FeaturesWindowController : NSWindowController


@property (nonatomic,weak) MGSFragariaView *viewTop;

@property (nonatomic,weak) MGSFragariaView *viewBottom;


@end
