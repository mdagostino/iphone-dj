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

 hi, you hippies!!!!!!!

*/

#import <UIKit/UIView-Geometry.h>
#import <GraphicsServices/GraphicsServices.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import	"UIGLView.h";
#import	"TurntableGLView.h";
#import "CrossFaderView.h";
#import "Stopwatch.h";

@interface CompleteView : UIGLView 
{
//	BOOL fingerIn[2];
	TurntableGLView *leftView;
	TurntableGLView *rightView;
	NSMutableArray *fingerObjects;
	id finger1View;
	id finger2View;
	CGPoint lastPoint[2];
	id fingerDisplay;
	id turntableView;
}

- (id)initWithFrame:(CGRect)frame;
- (CGPoint)getFinger1Press:(GSEvent *)event;
- (CGPoint)getFinger2Press:(GSEvent *)event;
- (BOOL)ignoresMouseEvents;
- (BOOL)canHandleGestures;
- (void)mouseDown:(struct __GSEvent *)event;
- (void)mouseDragged:(struct __GSEvent *)event;
- (void)mouseUp:(struct __GSEvent *)event;
- (void)gestureStarted:(struct __GSEvent *)event; 
- (void)gestureChanged:(struct __GSEvent *)event;
- (void)gestureEnded:(struct __GSEvent *)event;


@end


