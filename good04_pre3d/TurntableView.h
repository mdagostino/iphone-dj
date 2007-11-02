#import <UIKit/UIKit.h>
#import <UIKit/UIImageView.h>
#import <GraphicsServices/GraphicsServices.h>
#import "Stopwatch.h";




@interface TurntableView:UIImageView
{
	id controller;
}

- (struct CGSize)size;

-(id)initWithController:(id)c;

//- (void)drawRect:(CGRect)frame;


// our special debugging function!!!!!! .*  .*  ! ! ! ! :) : ):)   (: (: (: 
// our special debugging function!!!!!! .*  .*  ! ! ! ! :) : ):)   (: (: (: 
//- (void)echoScreenPress:(GSEvent *)event;
// our special debugging function!!!!!! .*  .*  ! ! ! ! :) : ):)   (: (: (: 
// our special debugging function!!!!!! .*  .*  ! ! ! ! :) : ):)   (: (: (: 
// B!@FFFF!!!

-( void) fingerDown:(CGPoint) point;
-( void) fingerDrag:(CGPoint) point;
-( void) fingerUp:(CGPoint) point;

@end

