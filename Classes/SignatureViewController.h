//
//  SignatureViewController.h
//  SmartSwipe
//
//  Created by Saleh Shah on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignatureView.h"


@class SignatureViewController;
@class ViewController;

@protocol SignatureViewControllerDelegate
- (void)signatureViewControllerDidFinish:(SignatureViewController *)controller;
@end

@interface SignatureViewController : UIViewController <TouchViewDelegate>
{
    SignatureView *sigView;
    //the layer we draw to
    
	CALayer *canvasLayer;
    
    
	//the layer we use to display the cached image
	CALayer *backgroundLayer;
    
	//the image we cache to
	UIImage *cacheImage;
    
    
    
	//the path that represents the currently drawn line
	CGMutablePathRef path;
    
    
    
	//a flag to track if we're in the middle of a touch event
	BOOL touching;
    
    
    
	//a point to store the current location of a touch event
    CGPoint pathPoint;
    

}
@property (nonatomic, retain) id <SignatureViewControllerDelegate> delegate;
@property (nonatomic, retain) ViewController *parentViewController;
-(IBAction)resetTapped:(id)sender;
-(IBAction)doneButtonPressed:(id)sender;

- (UIImage *)captureView: (UIView *)view inSize: (CGSize)size;


@end
