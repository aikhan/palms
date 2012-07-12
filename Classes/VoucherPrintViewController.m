//
//  VoucherPrintViewController.m
//  Palms
//
//  Created by Asad Khan on 7/6/12.
//  Copyright (c) 2012 Semantic Notion Inc. All rights reserved.
//

#import "VoucherPrintViewController.h"

@interface VoucherPrintViewController ()

@end

@implementation VoucherPrintViewController
@synthesize voucherImageView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
	return YES;
}

@end
