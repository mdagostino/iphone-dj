//
//  MyView.h
//  iDJ-iPhoneSDK
//
//  Created by Tom Söderlund on 3/10/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iDJUtility.h"
#import "FaderControl.h"
#import "TurntableControl.h"

@interface iDJView : UIView {
	FaderControl* _crossFader;
	TurntableControl* _turntable1;
	TurntableControl* _turntable2;
}

@end
