//
//  Stopwatch.m
//  iphonedj
//
//  Created by Aaron Zinman on 10/23/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Stopwatch.h"


@implementation Stopwatch

-(id) init
{
	if ( self = [super init] )
	{
		name = @"DEFAULT";
		
		[self start];
	}
	
	return self;
}

-(id) initWithName:(NSString *) n
{
	if ( self = [super init] )
	{
		name = n;
		[self start];
	}
	
	return self;
}

-(void) printFPS : (NSTimer *)timer
{
	NSLog(@"%@", self);
}



-(void) start
{
	gettimeofday(&lastTime, NULL);
	fps = 0;
	secondTimer = 0.0;
	fpsCounter = 0;
}

-(void) startFPS
{
	fpsTicker = [NSTimer scheduledTimerWithTimeInterval: 1.0
                target: self
                selector: @selector(printFPS:)
                userInfo: nil
                repeats: YES];
}

-(void) stopFPS
{
	[fpsTicker invalidate];
	[fpsTicker release];
	fpsTicker = nil;
}

-(float) tick
{
	gettimeofday(&currentTime, NULL);
	
	timersub(&currentTime, &lastTime, &elapsedtp);

	lastTime.tv_sec = currentTime.tv_sec;		/* seconds */
	lastTime.tv_usec = currentTime.tv_usec;	/* and microseconds */

	double elapsedNano = (double)elapsedtp.tv_sec + (double)elapsedtp.tv_usec/1000000.0;
	float msecPassed = elapsedNano * 1000.0;

	fpsCounter++;
	if ( secondTimer < 1000.0 )
		secondTimer += msecPassed;
	else
	{
		fps = fpsCounter;
		fpsCounter = 0;
		secondTimer = 0;
	}
	
	return msecPassed;
}

-(NSString *)description
{
	return [NSString stringWithFormat:@"[Stopwatch %@ FPS:%d]", name, fps];
}

@end
