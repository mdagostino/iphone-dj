//
//  Stopwatch.h
//  iphonedj
//
//  Created by Aaron Zinman on 10/23/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#include <assert.h>
#include <CoreServices/CoreServices.h>
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <unistd.h>
#include <sys/time.h>
#import <UIKit/UIKit.h>

@interface Stopwatch : NSObject {
	struct timeval lastTime;
	float secondTimer;
	int fps;
	int fpsCounter;
	NSString *name;
	struct timeval currentTime, elapsedtp;
	NSTimer *fpsTicker;
}

-(id) init;
-(void) start;
-(float) tick;
-(id) initWithName:(NSString *) n;
-(void) startFPS;
-(void) stopFPS;

@end
