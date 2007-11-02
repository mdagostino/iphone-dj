#import "TurntableView.h"


@implementation TurntableView


-(id)init
{

  if ( self = [ super init ] )      
  { 
	NSLog(@"view init, making image");
	UIImage *img = [UIImage applicationImageNamed:@"gfx/png/Party disc gfx.png"];
	NSLog(@"setting image");
	[self setImage: img];
	NSLog(@"done");
  }

  return self;

}

// return image's width and height
- (struct CGSize)size
{
  return [[self image] size ];
}


// teach macros in emacs at hacker seminar

- (void)getScreenPress:(GSEvent *)event {
	
	// check for EVERY OCNCIEBALABLRB TYPE OF EVENT!!!!!#^&!%^%!@ ***
	IsChording = GSEventIsChordingHandEvent(event);
	ClickCount = GSEventGetClickCount(event);
	DeltaX = GSEventGetDeltaX(event); 
	DeltaY = GSEventGetDeltaY(event); 
	InnerMostPathPos  = GSEventGetInnerMostPathPosition(event);
	OuterMostPathPos  = GSEventGetOuterMostPathPosition(event);
	EventSubType = GSEventGetSubType(event);
	EventType    = GSEventGetType(event);
	
	return;
}

- (void)simpleEchoScreenPress:(GSEvent *)event {
	
	printf("(%.3f, %.3f) ",
	       InnerMostPathPos.x,
	       InnerMostPathPos.y);
	
	printf("%d %d ",EventSubType,EventType);
	
	printf("\n");
	
	
	
}

- (void)echoScreenPress:(GSEvent *)event {
	CGPoint loc =  GSEventGetLocationInWindow(event);
	
	
	[ self getScreenPress : event ] ;

	printf("%d %d  %.3f %.3f ",
	       IsChording,ClickCount,
	       DeltaX,DeltaY);
	
	printf("(%.3f, %.3f)  ",
	       InnerMostPathPos.x,
	       InnerMostPathPos.y);
	
	printf("%d %d ",EventSubType,EventType);
	
	//CGPoint origin = rect.origin;
	//CGSize  size   = rect.size;
	
	// print debug info
	printf("org(x,y) %3.5f %3.5f",
	       loc.x,loc.y);
	printf("\n");
	
	// CG is written in C....rembmmber that.
	
	return;
}



- (BOOL)canHandleGestures {
	
	return YES;
}

- (BOOL)ignoresMouseEvents {
	return NO;
}


- (void)mouseDown:(GSEvent *)event {
	printf("0 down ");
	
	[ self getScreenPress:event ];
	
	
	{
		// pick:
		
		// verbose one
		//[ self echoPress:event ];
		
		
		// non-verbose one
		[ self simpleEchoScreenPress:event ];
		
		
	}
	
	//  [ self handleScreenPress:event ];
	
}





- (void)mouseDragged:(GSEvent *)event {
	printf("1 drag ");
	[ self getScreenPress:event ];
	
	// chewing gum tactic
	
    [ self simpleEchoScreenPress:event ];
	
	
}





- (void)mouseUp:(GSEvent *)event {
	printf("2 -up- ");
	[ self getScreenPress:event ];
	
	
    [ self simpleEchoScreenPress:event ];
}





- (void)gestureStarted:(struct __GSEvent *)event {
    printf("3 gs ");
    printf("\n");
    [ self gestureChanged: event ];
}

- (void)gestureEnded:(struct __GSEvent *)event {
    printf("4 ge ");
    printf("\n");
    [ self getScreenPress:event ];
}

- (void)gestureChanged:(struct __GSEvent *)event {
    printf("5 gc ");
    printf("\n");
    [ self getScreenPress:event ];
}





@end

