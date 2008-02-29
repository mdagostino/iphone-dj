#import "PartyApplication.h"
#import <Foundation/NSThread.h>
#include <sched.h>

@implementation PartyApplication

static PartyApplication *_sharedInstance;

+ (PartyApplication *) sharedInstance
{
	return _sharedInstance;
}


- (TurntableController *) leftTurntable
{
	return leftTurntable;
}

- (TurntableController *) rightTurntable
{
	return rightTurntable;
}

-(id) tables
{
	return tables;
}

- (void)deviceOrientationChanged:(struct __GSEvent *)fp8
{
	NSLog(@"dev orient chng: %d",[ self orientation ]);

}


- (void)acceleratedInX:(float)x Y:(float)y Z:(float)z;	// IMP=0x323b24f8

{
	NSLog(@"acc [ %f ] [ %f ] [ %f ]",	x,y,z );
}


- (CompleteView *) completeView
{
	return cView;
}


- (void) applicationDidFinishLaunching: (id) unused
{
	[[NSThread currentThread] setName:@"main gui thread"];
	NSLog(@"applicationDidFinishLaunching %d",[ UIHardware deviceOrientation: YES ]);

	// make our process max priority
	setpriority(PRIO_PROCESS, 0, PRIO_MIN); //0 means current process

	NSLog(@"LKPurpleServerIsRunning: %d", LKPurpleServerIsRunning());
	NSLog(@"LKContext localContext: %@", [LKContext localContext]);
	NSLog(@"LKContext allContexts: %@", [LKContext allContexts]);
	NSLog(@"LKContext local layer/level: %d/%d", [[LKContext localContext] layer], [[LKContext localContext] level]);

	id renderer = [[Renderer alloc] init];

    [ self setUIOrientation:1 ];

	_sharedInstance = self;
    UIWindow *window;
	[UIHardware _setStatusBarHeight:0.0f];
	[self setStatusBarMode:0 orientation:0 duration:0.0f fenceID:0];

    struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	NSLog(@"%f, %f %fx%f", rect.origin.x,rect.origin.y, rect.size.width, rect.size.height);

//    window = [[UIWindow alloc] initWithContentRect: [UIHardware
//        fullScreenApplicationContentRect]];
    window = [[UIWindow alloc] initWithContentRect: rect];

//	frame.size.height -= [UIApplication statusBarRect].size.height;

//	rect.origin.x = rect.origin.y = 0;



	


	
	NSLog(@"allocating turntables, allocating their audio");
	//TurntableAudioStruct turntables[MAX_TURNTABLES];
//	numTurntables = 2;
//	initAudioTurntables(numTurntables);
	
	NSLog(@"doing left");
//	leftTurntable = [[TurntableController alloc] initWithAudioStruct:(&turntables[0]) ];
	leftTurntable = [[TurntableController alloc] init];
	NSLog(@"doing righT");
	rightTurntable = [[TurntableController alloc] init];
	
	NSLog(@"doing dynamic array");
	tables = [[NSMutableArray arrayWithObjects: leftTurntable, rightTurntable, nil] retain];
	
	NSLog(@"allocating completeview");
    cView = [[CompleteView alloc] initWithFrame: rect];

	NSLog(@"setting content");
	
    [window setContentView: cView]; 

	NSLog(@"going to initAudio");
	setupAudioChain();

	NSLog(@"throwing our shit in front bitches!!");
    [window orderFront: self];
    [window makeKey: self];
    [window _setHidden: NO];

	NSLog(@"second UIOrientation!!!!");
    [ self setUIOrientation:1 ];



	NSLog(@"starting renderer");
	[renderer start];

	NSLog(@"starting audio");
	startAudio();

    NSLog(@"done with applicatioonDidFinishLaunching\n");
}


- (void) applicationWillSuspend
{
    NSLog(@"applicationWillSuspend");
}

- (void) applicationWillTerminate
{
    NSLog(@"applicationWillTerminate");
}

- (void) willSleep {
    NSLog(@"willSleep");
}

- (void) didWake {
    NSLog(@"didWake");
}


@end
