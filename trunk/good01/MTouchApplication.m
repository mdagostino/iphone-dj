#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UIThreePartButton.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UITable.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UITableColumn.h>
#import "MTouchApplication.h"
#import "MTouchView.h"

@implementation MTouchApplication


- (void) applicationDidFinishLaunching: (id) unused
{
    UIWindow *window;

    window = [[UIWindow alloc] initWithContentRect: [UIHardware
        fullScreenApplicationContentRect]];
   
    struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
    rect.origin.x = rect.origin.y = 0.0f;
    UIView *mainView;


    //    mainView = [[UIView alloc] initWithFrame: rect];
    mainView = [[MTouchView alloc] initWithFrame: rect];
    // [mainView addSubview: nav]; 
    // [mainView addSubview: table]; 

    [window setContentView: mainView]; 
}

@end
