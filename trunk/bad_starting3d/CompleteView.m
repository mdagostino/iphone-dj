/*
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 
 damn hippies!  i'll sick more ninjas on you!
 
 */

#import "CompleteView.h"
#import	"PartyApplication.h";


static BOOL near(CGPoint p1, CGPoint p2, int threshold)
{
	return p1.x - threshold <= p2.x && p1.x + threshold >= p2.x &&
		p1.y - threshold <= p2.y && p1.y + threshold >= p2.y;
}



@interface FingerMagic : UIView
{
	CGPoint lastPoint[2];
	BOOL visible[2];
}
- (id)initWithFrame:(CGRect)frame;

-(void) hideFinger:(int)finger;

-(void) updateFinger:(int) finger point:(CGPoint)point;

-(void) drawRect:(CGRect)frame;


@end

@implementation FingerMagic
- (id)initWithFrame:(CGRect)frame {
	if ((self == [super initWithFrame:frame])!=nil) 
	{
		[self setOpaque:NO];
		visible[0] = NO;
		visible[1] = NO;
		[Renderer markDirty:self];
	}
	return self;
}	

-(void) hideFinger:(int)finger
{
	visible[finger] = NO;
//	[self setNeedsDisplay];
}

-(void) updateFinger:(int) finger point:(CGPoint)point
{
	lastPoint[finger] = point;
	visible[finger] = YES;
//	[self setNeedsDisplay];
}

//float clear[4] = {0.2,1,1,1};
//float finger1color[4] = {1, 0, 0, 0.5};
//float finger2color[4] = {1, 1, 0, 0.5};
//
-(void) drawRect:(CGRect)frame
{
//	CGContextRef ctx = UICurrentContext();
////
////	CGContextSetFillColor(ctx, clear);
//////	CGContextClearRect(ctx, [self frame]);
////		CGContextFillRect(ctx, [self frame]);
////
//
//	int i;
//	for (i = 0; i < 2; i++)
//	{
//		if ( ! visible[i] )
//			continue;
//
//		CGContextSetFillColor(ctx, i == 0 ? finger1color : finger2color);
//
//		CGRect rect = CGRectMake(lastPoint[i].x - 5, 0, 10, [self frame].size.height);
//		CGContextFillRect(ctx, rect);
//		rect = CGRectMake(0, lastPoint[i].y - 5, [self frame].size.width, 10);
//		CGContextFillRect(ctx, rect);
//	}
}

- (BOOL)ignoresMouseEvents 
{
	return YES;
}

@end



@implementation CompleteView

- (id)initWithFrame:(CGRect)frame {
	if ((self == [super initWithFrame:frame])!=nil) 
	{
		int screenOrientation = [UIHardware deviceOrientation: YES];
		
//		UIImageView *backgroundImage = [[UIImageView alloc] initWithImage : [UIImage applicationImageNamed:@"gfx/png/Party Screen background 01.png"] ];
//		[self addSubview: backgroundImage];
//		[backgroundImage setRotationBy:-90.0];
//		[backgroundImage setOrigin: CGPointMake(0,0)];
		
		
		
		//if (screenOrientation == 3) {
		//_controllerImage = [UIImage applicationImageNamed:@"controller_landscape.png"];
		//} else {
		//_controllerImage = [UIImage applicationImageNamed:@"controller_portrait.png"];
		//}
		
		leftView = [[[PartyApplication sharedInstance] leftTurntable] view];
		rightView = [[[PartyApplication sharedInstance] rightTurntable] view];
//		[self addSubview: leftView];
//		[self addSubview: rightView];
//		[leftView setOrigin: CGPointMake(32, 16)];
//		[rightView setOrigin: CGPointMake(32, 262)];
		
		fingerObjects = [[NSMutableArray alloc] initWithCapacity:5];
		[fingerObjects addObject:leftView];
		[fingerObjects addObject:rightView];
		
		finger1View = nil;
		finger2View = nil;

		fingerDisplay = [[FingerMagic alloc] initWithFrame:frame];
		// this makes it slow and off screen
//		[fingerDisplay _createLayerWithFrame:frame];
//		[self addSubview:fingerDisplay];


//		[leftView setRotationBy:22.5];
//		[rightView setRotationBy:-180];

		turntableView = [ [TurntableGLView alloc] initWithController:[[PartyApplication sharedInstance] leftTurntable] ];
		
	}

	return self;
}

- (BOOL)canHandleGestures 
{
	return YES;
}

- (BOOL)ignoresMouseEvents 
{
	return NO;
}



- (CGPoint)getFinger1Press:(GSEvent *)event {
	
	// check for EVERY OCNCIEBALABLRB TYPE OF EVENT!!!!!#^&!%^%!@ ***
//	CGPoint loc =  GSEventGetLocationInWindow(event);
	CGPoint InnerMostPathPos  = GSEventGetInnerMostPathPosition(event);
	
//	return loc;
	return InnerMostPathPos;
}

- (CGPoint)getFinger2Press:(GSEvent *)event {
	
	// check for EVERY OCNCIEBALABLRB TYPE OF EVENT!!!!!#^&!%^%!@ ***
	CGPoint loc =  GSEventGetLocationInWindow(event);
	CGPoint InnerMostPathPos  = GSEventGetInnerMostPathPosition(event);

        //   p2   blue(loc)   green(innermostpath) 
        //   ?    90          100
        //  80 
        //  b/c p2  =  blue - (green-blue)  =  2*blue - green
//	return InnerMostPathPos;
	return CGPointMake( (2*loc.x)-InnerMostPathPos.x ,  (2*loc.y)-InnerMostPathPos.y ) ;
}


-(BOOL) inView:(id) view point:(CGPoint) p
{
	return 
		p.x >= [view frame].origin.x && 
		p.y >= [view frame].origin.y &&
		p.x <= [view frame].origin.x + [view frame].size.width && 
		p.y <= [view frame].origin.y + [view frame].size.height;
}

- (void)echoScreenPress:(GSEvent *)event 
{

        CGPoint loc =  GSEventGetLocationInWindow(event);

        // check for EVERY OCNCIEBALABLRB TYPE OF EVENT!!!!!#^&!%^%!@ ***
        int IsChording = GSEventIsChordingHandEvent(event);
        int ClickCount = GSEventGetClickCount(event);
        float DeltaX = GSEventGetDeltaX(event); 
        float DeltaY = GSEventGetDeltaY(event); 
        CGPoint InnerMostPathPos  = GSEventGetInnerMostPathPosition(event);
        CGPoint OuterMostPathPos  = GSEventGetOuterMostPathPosition(event);
        unsigned int EventSubType = GSEventGetSubType(event);
        unsigned int EventType    = GSEventGetType(event);

        printf("%d %d  %.3f %.3f ",
               IsChording,ClickCount,
               DeltaX,DeltaY);
        
        printf("(%.3f, %.3f) ",
               InnerMostPathPos.x,
               InnerMostPathPos.y);

        printf("%d %d ",EventSubType,EventType);

        //CGPoint origin = rect.origin;
        //CGSize  size   = rect.size;

        // print debug info
        printf("org(x,y) %3.5f %3.5f",
               loc.x,loc.y);
        printf("\n");

        return;
}

- (void)mouseDown:(GSEvent *)event 
{
	NSLog(@"mouseDown");
	[self echoScreenPress:event];

	CGPoint p = [self getFinger1Press:event];
	lastPoint[0] = p;

	[fingerDisplay updateFinger:0 point:p];
	
	NSEnumerator *enumerator = [fingerObjects objectEnumerator];
	id view;
	while (view = [enumerator nextObject]) {
		if ( [self inView:view point:p] )
		{
			[view fingerDown:p];
			finger1View = view;
			return;
		}
	}
	
	NSLog(@"couldnt capture for finger 1 point: %f, %f, not in (%3.3f, %3.3f %3.3fx%3.3f) or (%3.3f, %3.3f %3.3fx%3.3f)", 
			p.x, p.y, 
			[leftView frame].origin.x, [leftView frame].origin.y,
			[leftView frame].size.width, [leftView frame].size.height,
			[rightView frame].origin.x, [rightView frame].origin.y,
			[rightView frame].size.width, [rightView frame].size.height);
}


- (void)mouseDragged:(GSEvent *)event 
{
	CGPoint p = [self getFinger1Press:event];

	if ( near(lastPoint[0], p, 0) )
		return;

	[fingerDisplay updateFinger:0 point:p];
	[self echoScreenPress:event];
	lastPoint[0] = p;

	if ( finger1View == nil )
		NSLog(@"mouseDragged without View");
	else
	{
		if ( [self inView:finger1View point:p] )
		{
			NSLog(@"mouseDragged in view %@", finger1View);
			[finger1View fingerDrag:p];
		}
		else
			NSLog(@"went out of view %@", finger1View);
	}
}

- (void)mouseUp:(GSEvent *)event 
{
	[self echoScreenPress:event];
	[fingerDisplay hideFinger:0];

	if ( finger1View != nil )
	{
		NSLog(@"mouseUp in view %@", finger1View);
		CGPoint p = [self getFinger1Press:event];
		[finger1View fingerUp:p];
		finger1View = nil;
	}
	else
		NSLog(@"mouseUp without View");
}


- (void)gestureStarted:(struct __GSEvent *)event 
//- (void)gestureStarted:(GSEvent *)event 
{
	[self echoScreenPress:event];

	NSLog(@"gestureStarted");

	CGPoint p2 = [self getFinger2Press:event];
	lastPoint[1] = p2;

	[fingerDisplay updateFinger:1 point:p2];

	NSEnumerator *enumerator = [fingerObjects objectEnumerator];
	id view;
	while (view = [enumerator nextObject]) {
		if ( [self inView:view point:p2] )
		{
			[view fingerDown:p2];
			finger2View = view;
			return;
		}
	}
	
	NSLog(@"couldnt capture for finger 2 at point: %f, %f, not in (%3.3f, %3.3f %3.3fx%3.3f) or (%3.3f, %3.3f %3.3fx%3.3f)", 
			p2.x, p2.y, 
			[leftView frame].origin.x, [leftView frame].origin.y,
			[leftView frame].size.width, [leftView frame].size.height,
			[rightView frame].origin.x, [rightView frame].origin.y,
			[rightView frame].size.width, [rightView frame].size.height);
}

- (void)gestureChanged:(struct __GSEvent *)event
{
	[self echoScreenPress:event];

	NSLog(@"gestureChanged");

	CGPoint p1 = [self getFinger1Press:event];
	CGPoint p2 = [self getFinger2Press:event];

	lastPoint[0] = p1;
	lastPoint[1] = p2;

	[fingerDisplay updateFinger:0 point:p1];
	[fingerDisplay updateFinger:1 point:p2];
	
	if ( finger1View )
	{
		if ( [self inView:finger1View point:p1] )
			[finger1View fingerDrag:p1];
		else
			NSLog(@"f1 went out of view");
	}

	if ( finger2View )
	{
		if ( [self inView:finger2View point:p2] )
			[finger2View fingerDrag:p2];
		else
			NSLog(@"f2 went out of view");
	}
}

inline float sq(float f1)
{
	return f1 * f1;
}


- (void)gestureEnded:(struct __GSEvent *)event {
	[self echoScreenPress:event];

	NSLog(@"gestureEnded");

	// p is the remaining finger
	CGPoint p = GSEventGetLocationInWindow(event);//[self getFinger1Press:event];

	float distP0 = sq(p.x - lastPoint[0].x) + sq(p.y - lastPoint[0].y);
	float distP1 = sq(p.x - lastPoint[1].x) + sq(p.y - lastPoint[1].y);

	// determine which finger just came off
	if ( distP0 < distP1 )
	{
		NSLog(@"near p0 (lowest dist) so its still on, so finger 2 came off");

		if ( finger2View )
			[finger2View fingerUp:lastPoint[1]];
		finger2View = nil;

		[fingerDisplay hideFinger:1];
		[fingerDisplay updateFinger:0 point:lastPoint[0]];
	}
	else
	{
		NSLog(@"near p1 so its still on, so finger 1 came off");
		
		// delete old finger 1
		if ( finger1View )
			[finger1View fingerUp:lastPoint[0]];

		
		// and swap
		finger1View = finger2View;
		finger2View = nil;
		[fingerDisplay hideFinger:1];
		lastPoint[0] = lastPoint[1];
		[fingerDisplay updateFinger:0 point:lastPoint[0]];
	}
/*
	else
		NSLog(@"%.3f, %.3f not near  %.3f, %.3f or  %.3f, %.3f", 
			p.x, p.y, 
			lastPoint[0].x, lastPoint[0].y,
			lastPoint[1].x, lastPoint[1].y);
*/
}

- (void) drawRect: (CGRect) rect
{
    [self beginScene];
//    [self positionCamera];
//
//    glEnable(GL_DEPTH_TEST);
//	glClearColor(0.3f, 0.3f, 0.4f, 1.0f);
//    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

//    glDisable(GL_CULL_FACE);
//    DrawCube();

		[turntableView drawGL];

    [self endScene];
}

//
//- (void)drawRect:(CGRect)rect{
//	int screenOrientation = [UIHardware deviceOrientation: YES];
//	
//	// create turntable
//	
//	
//	CGRect[2]  = {CGMakeRect(32,116200,200,), CGMakeRect(200,200) };
//	
//	
//	
//	int i;
//	
//	//if (screenOrientation == 3)  rect2.size.height = 460;
//	
//	CGContextRef ctx = UICurrentContext();
//	float red[4] = {1, 0, 0, 1};float green[4] = {0, 1, 0, 1};float blue[4] = {0, 0, 1, 1};
//	CGContextSetFillColor(ctx, red);
//	CGContextFillRect(ctx, rect);
//	
//	
//    LOGDEBUG("ControllerView.drawRect()");
//    rect2.origin.x = 0;
//    rect2.origin.y = 0;
//    rect2.size.width = 320;
//    rect2.size.height = 100;
//	
//    if (orientation == 3)
//        rect2.size.height = 480;
//	
//    [ _controllerImage draw1PartImageInRect: rect2 ];
//	
//	
//}
//

@end
