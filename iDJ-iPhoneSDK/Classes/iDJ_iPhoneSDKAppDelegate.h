//
//  iDJ_iPhoneSDKAppDelegate.h
//  iDJ-iPhoneSDK
//
//  Created by Tom Söderlund on 3/10/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iDJView;

@interface iDJ_iPhoneSDKAppDelegate : NSObject {
    UIWindow *window;
    iDJView *contentView;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) iDJView *contentView;

@end
