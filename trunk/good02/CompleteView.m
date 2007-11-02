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


@implementation CompleteView

- (id)initWithFrame:(CGRect)frame {
	if ((self == [super initWithFrame:frame])!=nil) 
	{
		int screenOrientation = [UIHardware deviceOrientation: YES];
		
		UIImageView *backgroundImage = [[UIImageView alloc] initWithImage : [UIImage applicationImageNamed:@"gfx/png/Party Screen background 01.png"] ];
		[self addSubview: backgroundImage];
		[backgroundImage setRotationBy:-90.0];

		[backgroundImage setOrigin: CGPointMake(0,0)];
		
		//if (screenOrientation == 3) {
		//_controllerImage = [UIImage applicationImageNamed:@"controller_landscape.png"];
		//} else {
		//_controllerImage = [UIImage applicationImageNamed:@"controller_portrait.png"];
		//}
		
		TurntableView *leftView = [[[PartyApplication sharedInstance] leftTurntable] view];
		TurntableView *rightView = [[[PartyApplication sharedInstance] rightTurntable] view];
		[self addSubview: leftView];
		[self addSubview: rightView];
		[leftView setOrigin: CGPointMake(32, 16)];
		[rightView setOrigin: CGPointMake(32, 262)];
	}

	return self;
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
