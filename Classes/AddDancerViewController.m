//
//  AddDancerViewController.m
//  Palms
//
//  Created by Saleh Shah on 5/11/12.
//  Copyright (c) 2012 Semantic Notion. All rights reserved.
//

#import "AddDancerViewController.h"
#import "MagTekDemoAppDelegate.h"
#import "Dancer.h"

@implementation AddDancerViewController

@synthesize dancerField,parentController;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self setContentSizeForViewInPopover:CGSizeMake(320, 480)];
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
	return YES;
}

#pragma mark -
#pragma mark Private Methods
#pragma mark -

-(IBAction)addDancerButtonPressed:(id)sender
{
    Dancer * dancer = [[Dancer alloc] initWithDancerName:self.dancerField.text pricePerDance:nil minsPerPrice:nil dances:@"0" houseFee:nil withTotalFee:[NSNumber numberWithInt:0] andDancerPaid:nil];
    
    MagTekDemoAppDelegate * appDelegate = (MagTekDemoAppDelegate*) [UIApplication sharedApplication].delegate;
    
    [appDelegate.dancersArray addObject:dancer];
    
    
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <[appDelegate.dancersArray count] ; i++) {
        
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[appDelegate.dancersArray objectAtIndex:i]];
        [tempArray addObject:myEncodedObject];
    }
    
    NSArray * dancers = [NSArray arrayWithArray:tempArray];
    [[NSUserDefaults standardUserDefaults] setObject:dancers forKey:@"DancersArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self.parentController dismissAddDancerPopover];
    [self.navigationController popViewControllerAnimated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Dancer has been added successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [alert show];
    [alert release];
    
}

#pragma mark -
#pragma mark UITextFild Methods
#pragma mark -

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
