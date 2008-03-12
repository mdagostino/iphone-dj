//
//  main.m
//  iDJ-iPhoneSDK
//
//  Created by Tom Söderlund on 3/10/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"iDJ_iPhoneSDKAppDelegate");
    [pool release];
    return retVal;
}
