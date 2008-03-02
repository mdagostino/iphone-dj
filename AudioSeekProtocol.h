/*
 *  AudioSeekProtocol.h
 *  iDJ
 *
 *  Created by Aaron Zinman on 2/28/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */


@protocol AudioSeekable

- (void) seekRelative:(float) relativeMsec;
- (void) seekAbsolute:(float) absMsec;

@end