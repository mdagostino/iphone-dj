#import "PartyApplication.h"

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


- (void) applicationDidFinishLaunching: (id) unused
{
	NSLog(@"applicationDidFinishLaunching");
	_sharedInstance = self;
    UIWindow *window;

    window = [[UIWindow alloc] initWithContentRect: [UIHardware
        fullScreenApplicationContentRect]];

    struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
    rect.origin.x = rect.origin.y = 0.0f;


	NSLog(@"allocating turntables, doing left");
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
	//initAudioController();


	NSLog(@"throwing our shit in front bitches!!");
    [window orderFront: self];
    [window makeKey: self];
    [window _setHidden: NO];

    NSLog(@"done with applicatioonDidFinishLaunching\n");
}

@end
