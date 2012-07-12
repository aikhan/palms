//
//  MagTekDemoAppDelegate.h
//  MagTekDemo
//
//  Created by MagTek  on 11/27/11.
//  Copyright 2011 MagTek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>
#import "MTSCRA.h"


@class ViewController;
@class MagTekDemoViewController;

@interface MagTekDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
   // MagTekDemoViewController *viewController;
    ViewController *viewController1;
    MTSCRA *mtSCRALib;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
//@property (nonatomic, retain) IBOutlet MagTekDemoViewController *viewController;
@property (nonatomic, retain) IBOutlet ViewController *viewController1;
@property (nonatomic, retain) MTSCRA *mtSCRALib;
@property(nonatomic,retain) NSMutableArray * dancersArray;
@property(nonatomic,retain) NSMutableArray * selectedDancersArray;

- (MTSCRA *) getSCRALib;

@end

