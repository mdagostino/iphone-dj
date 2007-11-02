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

 take a shower!!!!!  damn hippies!

*/

#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIView-Geometry.h>
#import "MTouchView.h"

@implementation MTouchView
- (id)initWithFrame:(CGRect)frame {
       if ((self == [super initWithFrame:frame])!=nil) 
       {
	 int screenOrientation = [UIHardware deviceOrientation: YES];

	 //if (screenOrientation == 3) {
	 //_controllerImage = [UIImage applicationImageNamed:@"controller_landscape.png"];
	 //} else {
	 //_controllerImage = [UIImage applicationImageNamed:@"controller_portrait.png"];
	 //}

       }

       return self;
}

- (void)echoScreenPress:(GSEvent *)event {
	CGRect rect =  GSEventGetLocationInWindow(event);

	//CGPoint origin = rect.origin;
	//CGSize  size   = rect.size;

	// print debug info
	printf("org(x,y) %3.5f %3.5f   size(w,h) %3.5f %3.5f",
	       rect.origin.x,rect.origin.y,
	       rect.size.width,rect.size.height);
	printf("\n");
	       

	// CG is written in C....rembmmber that.

	return;
}


- (BOOL)ignoresMouseEvents {
	return NO;
}

- (void)mouseDown:(GSEvent *)event {
  printf("0 do ");
  [ self echoScreenPress:event ];
}


- (void)mouseDragged:(GSEvent *)event {
  printf("1 dr ");
  [ self echoScreenPress:event ];

  // chewing gum tactic
}


- (void)mouseUp:(GSEvent *)event {
  printf("2 up ");
  [ self echoScreenPress:event ];
}



- (void)drawRect:(CGRect)rect{
        int screenOrientation = [UIHardware deviceOrientation: YES];

        //if (screenOrientation == 3)  rect2.size.height = 460;

	CGContextRef ctx = UICurrentContext();
	float red[4] = {1, 0, 0, 1};float green[4] = {0, 1, 0, 1};float blue[4] = {0, 0, 1, 1};
	CGContextSetFillColor(ctx, red);
	CGContextFillRect(ctx, rect);
}


@end
