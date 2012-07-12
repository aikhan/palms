//
//  SignatureViewController.m
//  SmartSwipe
//
//  Created by Saleh Shah on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SignatureViewController.h"
#import "MagTekDemoAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"


@implementation SignatureViewController
@synthesize parentViewController;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)doneButtonPressed:(id)sender

{
    [self.parentViewController beginTransaction];
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate signatureViewControllerDidFinish:self];
}

-(IBAction)resetTapped:(id)sender {
    
    
    cacheImage = nil;
    //set up drawing layer
    canvasLayer = [CALayer layer];
    canvasLayer.bounds = CGRectMake(0, 0, 730, 500);
    canvasLayer.position = CGPointMake(600/2, 500/2);
    [canvasLayer setDelegate:self];
    
    
    
    //set up storage layer
    backgroundLayer = [CALayer layer];
    backgroundLayer.bounds = CGRectMake(0, 0, 730, 500);
    //backgroundLayer.position = CGPointMake(screenBounds.size.width/1.5, screenBounds.size.height/1.5);
    backgroundLayer.position = CGPointMake(730/2, 500/2);
    [backgroundLayer setDelegate:self];
    
    
    backgroundLayer.frame = CGRectMake(0, 0, 730, 500);
    canvasLayer.frame = CGRectMake(0, 0, 730, 500);
    
    //set up view and add layers
    sigView = [[SignatureView alloc] initWithFrame:CGRectMake(15, 40, 500, 500)];
    sigView.backgroundColor = [UIColor grayColor];
    [sigView.layer addSublayer:canvasLayer];
    [sigView.layer addSublayer:backgroundLayer];
    [sigView setDelegate:self];
    
    
    
    //set up window and add view
    [self.view addSubview:sigView];
    
    
    //initialize some other variables
    cacheImage = nil;
    touching = NO;
    [backgroundLayer setNeedsDisplay];
    [canvasLayer setNeedsDisplay];
    
}

#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //set up drawing layer
    canvasLayer = [CALayer layer];
    canvasLayer.bounds = CGRectMake(0, 0, 730, 500);
    canvasLayer.position = CGPointMake(600/2, 500/2);
    [canvasLayer setDelegate:self];
    
    
    
    //set up storage layer
    backgroundLayer = [CALayer layer];
    backgroundLayer.bounds = CGRectMake(0, 0, 730, 500);
    //backgroundLayer.position = CGPointMake(screenBounds.size.width/1.5, screenBounds.size.height/1.5);
    backgroundLayer.position = CGPointMake(730/2, 500/2);
    [backgroundLayer setDelegate:self];
    
    
    backgroundLayer.frame = CGRectMake(0, 0, 730, 500);
    canvasLayer.frame = CGRectMake(0, 0, 730, 500);
    
    //set up view and add layers
    sigView = [[SignatureView alloc] initWithFrame:CGRectMake(15, 40, 500, 500)];
    sigView.backgroundColor = [UIColor grayColor];
    [sigView.layer addSublayer:canvasLayer];
    [sigView.layer addSublayer:backgroundLayer];
    [sigView setDelegate:self];
    
    
    
    //set up window and add view
    [self.view addSubview:sigView];
    
    
    //initialize some other variables
    cacheImage = nil;
    touching = NO;
    
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    // self.view.frame = CGRectMake(0, -10, 500, 500);
    
}








- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


- (UIImage *)captureView: (UIView *)view inSize: (CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGSize viewSize = view.frame.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM( context, size.width/viewSize.width, size.height/viewSize.height);
    
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
	if (touching){
       // CGPathRelease(path);
        UITouch *touch = (UITouch *)[touches anyObject];
        CGPathMoveToPoint(path, NULL, [touch locationInView:sigView].x, [touch locationInView:sigView].y);
        return;
    }
    
    NSLog(@"START");
    
	//start a new path
    
	path = CGPathCreateMutable();
	//set the path's starting point
	UITouch *touch = (UITouch *)[touches anyObject];
	CGPathMoveToPoint(path, NULL, [touch locationInView:sigView].x, [touch locationInView:sigView].y);
	touching = YES;
}



-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (touching)
	{
        NSLog(@"MOVE");
		//get the current location of the touch event
		UITouch *theTouch = (UITouch *)[touches anyObject];
		pathPoint = [theTouch locationInView:sigView];
		CGPathAddLineToPoint(path, NULL, pathPoint.x, pathPoint.y);
        [canvasLayer setNeedsDisplay];
	}
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
	if (!touching) return;
    NSLog(@"END");
	//create a new image context    
	UIGraphicsBeginImageContext(CGSizeMake(backgroundLayer.bounds.size.width, backgroundLayer.bounds.size.height));
    
    //grab a reference to the new image context
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //push the image context to the top of the drawing stack
    UIGraphicsPushContext(ctx);
    
    
    
    //set the blend mode to prevent white pixels from
    
    //covering up the lines that have already been drawn
    
    CGContextSetBlendMode(ctx, kCGBlendModeDarken);
    if (cacheImage != nil) {
        //draw the cached state of the image to the image context and release it       
//        [cacheImage drawInRect:CGRectMake(0,0,backgroundLayer.bounds.size.width,backgroundLayer.bounds.size.height)];
        
    }
    
    
    
    //blend the drawing layer into the image context
    
    [canvasLayer drawInContext:ctx];
    
    
    
    //we're done drawing to the image context
    
    UIGraphicsPopContext();
    
    
    
    //store the image context so we can add to it again later
    
    cacheImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    
    
	//we're finished with the image context altogether
    
	UIGraphicsEndImageContext();
    
    
    
	//touching = NO;
    
    
    
	//release the path
    
	//CGPathRelease(path);
    
    
    
	//update the background layer (we'll need to draw the cached image to the background)
    
	[backgroundLayer setNeedsDisplay];
    
    
}



- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    	//this method is handling multiple layers, so first
	//determine which layer we're drawing to

	if (layer == canvasLayer) {
        NSLog(@"Canvas Layer");

		//we don't want this to fire after the background layer update
		//and after the path has been released
		if (!touching) return;
        //add the path to the context
		CGContextAddPath(ctx, path);
		//set a line width and draw the path
		CGContextSetLineWidth(ctx, 2.0f);
		CGContextStrokePath(ctx);
        //CGContextRestoreGState(ctx);    
	}
	else if (layer == backgroundLayer) {
        
        NSLog(@"Background Layer");
		//remember the current state of the context
		CGContextSaveGState(ctx);
		//the cached image coordinate system is upside down, so do a backflip        
		CGContextTranslateCTM(ctx, 0, backgroundLayer.bounds.size.height);
		CGContextScaleCTM(ctx, 1.0, -1.0);
		//draw the image
        cacheImage = UIGraphicsGetImageFromCurrentImageContext();
		CGImageRef ref = cacheImage.CGImage;
		CGContextDrawImage(ctx, backgroundLayer.bounds, ref);        
		//restore the context to its pre-flipped state
		CGContextRestoreGState(ctx);
        
	}
    
}






@end
