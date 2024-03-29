//
//  StandardHelp.m
//  IOS_SDK
//
//  Created by Tzvi on 8/19/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "StandardHelp.h"


@implementation StandardHelp

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setHelpTitle:(NSString*)helpTitle
{
    [uilabel_helptitle setText:helpTitle];
}

-(void)closeCommand
{
    [self dismissModalViewControllerAnimated:true];
}

-(void)setHelpText:(NSString*)helpText
{
    [uiwebview_helptext loadHTMLString:helpText baseURL:nil];
}

@end
