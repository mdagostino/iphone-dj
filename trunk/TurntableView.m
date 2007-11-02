#import "TurntableView.h"


@implementation TurntableView



-(id)initWithController:(id)c
{
	
	if ( self = [ super init ] )      
	{ 
		controller = c;
		NSLog(@"view init, making image");
		UIImage *img = [UIImage applicationImageNamed:@"gfx/png/Party disc gfx.png"];
		NSLog(@"setting image");
		[self setImage: img];
		NSLog(@"done");
		
	}
	
	
	return self;
}


//-(void) drawRect:(CGRect)frame
//{
//	[super drawRect:frame];
//	[stopwatch tick];
//}
	

// return image's width and height
- (struct CGSize)size
{
	return [[self image] size ];
}





-( void) fingerDown:(CGPoint) point
{
	NSLog(@"fingerDown");
	[controller pauseTicking];
}
-( void) fingerDrag:(CGPoint) point
{
	NSLog(@"fingerDrag");
}
-( void) fingerUp:(CGPoint) point
{
	NSLog(@"fingerUP");
	[controller resumeTicking];
}



// teach macros in emacs at hacker seminar

//
//- (void)simpleEchoScreenPress:(GSEvent *)event {
//	
//  //printf("(%.3f, %.3f) ",	       InnerMostPathPos.x,	       InnerMostPathPos.y);	printf("%d %d ",EventSubType,EventType);	printf("\n");
//	
//	
//	
//}
//
//- (void)echoScreenPress:(GSEvent *)event {
//	
//	[ self getScreenPress : event ] ;
//
//	//printf("%d %d  %.3f %.3f ", IsChording,ClickCount, DeltaX,DeltaY);
//	//printf("(%.3f, %.3f)  ", InnerMostPathPos.x,  InnerMostPathPos.y);
//	//printf("%d %d ",EventSubType,EventType);
//	//printf("org(x,y) %3.5f %3.5f",	       loc.x,loc.y);	printf("\n");	
//	
//	// CG is written in C....rembmmber that.
//	
//	return;
//}





@end

