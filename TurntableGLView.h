#import <UIKit/UIKit.h>
#import <UIKit/UIImageView.h>
#import <GraphicsServices/GraphicsServices.h>
#import "Stopwatch.h";
#import "GLDrawer.h";




@interface TurntableGLView:GLDrawer
{
	//UIImage *image;
	id controller;
	CGRect frame;
}

//- (struct CGSize)size;

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

-(CGRect)frame;
-(CGSize)size;
-(CGPoint)origin;
-(void)setOrigin:(CGPoint) point;
-(void)setBounds:(CGRect) rect;
-(void)setFrame:(CGRect) rect;


@end

