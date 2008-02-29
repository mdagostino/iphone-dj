/*
 *  AudioSeekProtocol.h
 *  iDJ
 *
 *  Created by Aaron Zinman on 2/28/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */


@protocol AudioSeekable

- (void) seekRelative:(int) relativeMsec;
- (void) seekAbsolute:(unsigned int) absMsec;

@end