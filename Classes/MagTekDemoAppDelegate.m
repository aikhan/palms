//
//  MagTekDemoAppDelegate.m
//  MagTekDemo
//
//  Created by MagTek  on 11/27/11.
//  Copyright 2011 MagTek. All rights reserved.
//

#import "MagTekDemoAppDelegate.h"
#import "MagTekDemoViewController.h"
#import "ViewController.h"



@implementation MagTekDemoAppDelegate

@synthesize window;
@synthesize mtSCRALib, dancersArray, viewController1, selectedDancersArray;

//#define PROTOCOLSTRING @"com.magtek.idynamo"

//int gMagTekReader = MAGTEKIDYNAMO;
//int gMagTekReader = MAGTEKAUDIOREADER;


- (MTSCRA *) getSCRALib
{
    return mtSCRALib;
}


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{    
    if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) 
	{
		NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
	}
    self.mtSCRALib = [[MTSCRA alloc] init];
    self.selectedDancersArray = [[NSMutableArray alloc] init];
    // TRANS_STATUS_START should be used with caution. CPU intensive
    // tasks done after this events and before TRANS_STATUS_OK
    // may interfere with reader communication
    [self.mtSCRALib listenForEvents:(TRANS_EVENT_START|TRANS_EVENT_OK|TRANS_EVENT_ERROR)]; 
    //[self.mtSCRALib listenForEvents:(TRANS_EVENT_OK|TRANS_EVENT_ERROR)]; 
    NSArray * tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"DancersArray"];
    
    if (tempArray) {
       
        self.dancersArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [tempArray count]; i++) {
            
            NSData *myEncodedObject = [tempArray objectAtIndex:i];
            Dancer * dancer = (Dancer *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
            [self.dancersArray addObject:dancer];
     
        }
    }
    else
    {
        self.dancersArray = [[NSMutableArray alloc] init];
        
    }
    self.viewController1 = [[ViewController alloc] initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    self.viewController1.view.frame = CGRectMake(0, 20, 768, 1924);
    window.rootViewController = self.viewController1;
    [window addSubview:self.viewController1.view];
    [window bringSubviewToFront:window.rootViewController.view];
    [window makeKeyAndVisible];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   // [viewController1 closeDevice];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [viewController1 closeDevice]; 
}


- (void)dealloc {
    [viewController1 release];
    [mtSCRALib release];
    [window release];
    [super dealloc];
}


@end
