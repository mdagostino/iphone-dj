#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UIThreePartButton.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UITouchDiagnosticsLayer.h>
#import <LayerKit/LayerKit.h>
#import <GraphicsServices/GraphicsServices.h>

#import "TurntableController.h"
#import "CompleteView.h"
#import "Renderer.h"
#import "TurntableAudio.h"

@interface PartyApplication : UIApplication 
{
	NSMutableArray *tables;
	TurntableController *leftTurntable;
	TurntableController *rightTurntable;
	CompleteView *cView;
}

- (TurntableController *) rightTurntable;
- (TurntableController *) leftTurntable;
- (id) tables;
+ (PartyApplication *) sharedInstance;
- (CompleteView *) completeView;

@end
