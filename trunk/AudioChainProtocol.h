/*
 *  AudioChainProtocol.h
 *  iDJ
 *
 *  Created by Aaron Zinman on 2/24/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "AudioStructures.h"

@protocol AudioChain

-(void) setSource:(id<AudioSource>) newSource;

@end