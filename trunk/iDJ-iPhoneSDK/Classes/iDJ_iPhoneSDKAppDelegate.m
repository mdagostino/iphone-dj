//
//  iDJ_iPhoneSDKAppDelegate.m
//  iDJ-iPhoneSDK
//
//  Created by Tom Söderlund on 3/10/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "iDJ_iPhoneSDKAppDelegate.h"
#import "iDJView.h"

@implementation iDJ_iPhoneSDKAppDelegate

@synthesize window;
@synthesize contentView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	// Create window
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Set up content view
	self.contentView = [[[iDJView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	[window addSubview:contentView];
    
	// Show window
	[window makeKeyAndVisible];
}

- (void)dealloc {
	[contentView release];
	[window release];
	[super dealloc];
}

@end
