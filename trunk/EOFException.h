//
//  EOFException.h
//  iDJ
//
//  Created by Aaron Zinman on 2/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSException.h>

@interface EOFException : NSException 
{
}

+ (NSException *) hitStart;
+ (NSException *) hitEnd;

@end


