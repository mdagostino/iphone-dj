//
//  MyView.m
//  iDJ-iPhoneSDK
//
//  Created by Tom Söderlund on 3/10/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "iDJView.h"

@implementation iDJView

- (id) initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame:frame])) {
		// Set up content view
		_faderControl = [[[FaderControl alloc] initWithFrame: CGRectMake((frame.size.width - 150)/2, (frame.size.height - 55)/2, 150, 55)] autorelease];
		[self addSubview: _faderControl];
	}
	
	return self;
}

@end



