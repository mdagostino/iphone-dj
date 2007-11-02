#import "move.h"

#define NDEBUG
#include <OpenGLES/gl.h>
#include <OpenGLES/egl.h>
#include <CoreGraphics/CGDirectDisplay.h>

#include <stdio.h>
#include <unistd.h>


#import "TurntableGLView.h"


@implementation TurntableGLView



-(id)initWithController:(id)c
{
	
	if ( self = [ super init ] )      
	{ 
		controller = c;
		//NSLog(@"view init, making image");
		//img = [UIImage applicationImageNamed:@"gfx/png/Party disc gfx.png"];

		NSLog(@"done");
		
        init_move(100);
	}
	
	
	return self;
}



-(void) drawGL
{
		glClearColor(0, 0, 0, 0);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
		
    // Enable vertex arrays
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    
	int i;
	for (i = 0; i < elistElts; i++) 
    {
        struct elem_t* el = elist + i;
        
        float verts[] =
        {
            el->pos[0] + el->vervec[0],
            el->pos[1] + el->vervec[1],
            el->pos[2],
            el->col[0], el->col[1], el->col[2], 1.0f,
            
            el->pos[0] + el->vervec[1],
            el->pos[1] - el->vervec[0],
            el->pos[2],
            el->col[0], el->col[1], el->col[2], 1.0f,
            
            el->pos[0] - el->vervec[0],
            el->pos[1] - el->vervec[1],
            el->pos[2],
            el->col[0], el->col[1], el->col[2], 1.0f
        };
        
        // Points the the vertex data
        glVertexPointer(3, GL_FLOAT, 28, verts + 0);
        glColorPointer (4, GL_FLOAT, 28, verts + 3);
        
        glDrawArrays(GL_TRIANGLES, 0, 3);
    }
		
//		if (!eglSwapBuffers(eglGetCurrentDisplay(), eglGetCurrentSurface(EGL_DRAW)))
//			printf("swap error: %04x\n", eglGetError());
		
		move_increment();
}


//void DrawTriangle()
//{
//	// Vertex data
//	GLfloat vertices[] = 
//    {  -0.4f,	-0.4f,	0.0f,
//        0.4f,	-0.4f,	0.0f,
//        0.0f,	 0.4f,	0.0f };
//	
//	// Enable vertex arrays
//	glEnableClientState(GL_VERTEX_ARRAY);
//	
//	// Points the the vertex data
//	glVertexPointer(3, GL_FLOAT, 0, vertices);
//    
//	// Set color data in the same way
//	GLfloat colors[] = 
//    {	
//        1,0,0,1, //Red
//        0,1,0,1, //Green
//        0,0,1,1  //Blue
//    };
//    
//	glEnableClientState(GL_COLOR_ARRAY);
//	glColorPointer(4, GL_FLOAT, 0, colors);
//    
//	glDrawArrays(GL_TRIANGLES, 0, 3);
//}




        


//-(void) drawRect:(CGRect)frame
//{
//	[super drawRect:frame];
//	[stopwatch tick];
//}
	
//
//// return image's width and height
//- (struct CGSize)size
//{
//	return [[self image] size ];
//}
//
//



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







-(CGRect)frame
{
	return frame;
}

-(CGSize)size
{
	return frame.size;
}

-(CGPoint)origin
{
	return frame.origin;
}

-(void)setOrigin:(CGPoint) point
{
	frame.origin = point;
}
-(void)setBounds:(CGRect) rect
{
	frame = rect;
}
-(void)setFrame:(CGRect) rect
{
	frame = rect;
}



@end

