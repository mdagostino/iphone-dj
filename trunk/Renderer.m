//
//  Renderer.m
//  iphonedj
//
//  Created by Aaron Zinman on 10/24/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Renderer.h"

Renderer *singleton;

@implementation Renderer

-(id) init
{
	if ( self =[super init])
	{
		singleton = self;
		dirty = [[NSMutableArray alloc] initWithCapacity: 10];
		renderTimer = [[Stopwatch alloc] initWithName:@"renderTimer"];
	}
	
	return self;
}

-(void) _markDirty:(id) d
{
	NSLog(@"adding %@ to dirty %@", d, dirty);
	[dirty addObject:d];
}

+(void) markDirty:(id) dirty
{
	[singleton _markDirty:dirty];
}


-(void) start
{
	leftView = [[[PartyApplication sharedInstance] leftTurntable] view];
	rightView = [[[PartyApplication sharedInstance] rightTurntable] view];
	leftController = [ [PartyApplication sharedInstance] leftTurntable];
	rightController = [ [PartyApplication sharedInstance] rightTurntable];


	[renderTimer startFPS];
	id timer = [NSTimer scheduledTimerWithTimeInterval: 1.0/30
                target: self
                selector: @selector(tick:)
                userInfo: nil
                repeats: YES];
}

-(void) tick:(NSTimer *)timer
{
//	NSEnumerator *enumerator = [dirty objectEnumerator];
//	id view;
//
//	while (view = [enumerator nextObject]) {
//		[view setNeedsDisplay];
//	}
	
//	[dirty removeAllObjects];
	[[[PartyApplication sharedInstance] completeView] setNeedsDisplay];
	[renderTimer tick];
//	[leftController tick];
//	[rightController tick];
}
@end
