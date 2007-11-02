#import <UIKit/UIKit.h>
#import <UIKit/UIImageView.h>
#import <GraphicsServices/GraphicsServices.h>

@interface TurntableView:UIImageView
{
	int IsChording;
	int ClickCount;
	float DeltaX; 
	float DeltaY; 
	CGPoint InnerMostPathPos ;
	CGPoint OuterMostPathPos ;
	unsigned int EventSubType;
	unsigned int EventType   ;
}

- (struct CGSize)size;
- (BOOL)canHandleGestures;
- (BOOL)ignoresMouseEvents;


//- (void)drawRect:(CGRect)frame;
- (BOOL)ignoresMouseEvents;


// our special debugging function!!!!!! .*  .*  ! ! ! ! :) : ):)   (: (: (: 
// our special debugging function!!!!!! .*  .*  ! ! ! ! :) : ):)   (: (: (: 
- (void)echoScreenPress:(GSEvent *)event;
// our special debugging function!!!!!! .*  .*  ! ! ! ! :) : ):)   (: (: (: 
// our special debugging function!!!!!! .*  .*  ! ! ! ! :) : ):)   (: (: (: 
// B!@FFFF!!!

- (void)mouseDown:(struct __GSEvent *)event;
- (void)mouseDragged:(struct __GSEvent *)event;
- (void)mouseUp:(struct __GSEvent *)event;


@end

