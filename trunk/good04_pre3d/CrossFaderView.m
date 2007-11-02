//
//  CrossFaderView.m
//  iphonedj
//
//  Created by Aaron Zinman on 10/22/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "CrossFaderView.h"


@implementation CrossFaderView


- (void)sliderBoundsChanged

{
   [ super sliderBoundsChanged ] ;
   
   NSLog(@"sliderBOunds Changed %f",[ self value ] );


}


@end
