//
//  EOFException.m
//  iDJ
//
//  Created by Aaron Zinman on 2/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "EOFException.h"


@implementation EOFException

+ (NSException *) hitStart
{
	NSException *e = [EOFException
		exceptionWithName: @"EOFException"
		reason: @"hitStart"
		userInfo: nil];
	return e;
}
	
+ (NSException *) hitEnd
{
	NSException *e = [EOFException
		exceptionWithName: @"EOFException"
		reason: @"hitEnd"
		userInfo: nil];
	return e;
}
	
@end
