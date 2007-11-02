//
//  Renderer.h
//  iphonedj
//
//  Created by Aaron Zinman on 10/24/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stopwatch.h"
#import "TurntableGLView.h"
#import "PartyApplication.h"

@interface Renderer : NSObject {
	NSMutableArray *dirty;
	Stopwatch *renderTimer;
	TurntableGLView *leftView;
	TurntableGLView *rightView;
	id leftController;
	id rightController;
}

-(id) init;
+(void) markDirty:(id) dirty;
-(void) start;
-(void) tick:(NSTimer *)timer;

@end
