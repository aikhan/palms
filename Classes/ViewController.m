//
//  ViewController.m
//  Palms
//
//  Created by Saleh Shah on 5/8/12.
//  Copyright (c) 2012 Semantic Notion. All rights reserved.
//
#import "SignatureViewController.h"
#import "ViewController.h"
#import "AddDancerViewController.h"
#import "MagTekDemoAppDelegate.h"
#import "Dancer.h"
#import "ExtendedButton.h"
#import "EditDancerListViewController.h"
#import "SettingsViewController.h"
#import "StarIO/Port.h"
#import <sys/time.h>
#include <unistd.h>
#import "VIPDacneViewController.h"
#import "Constants.h"
#import "rasterPrinting.h"
#import "MagTekDemoViewController.h"
#import "PrinterManager.h"
#import "AddDancerListViewController.h"
#import "VoucherPrintViewController.h"
#define kOFFSET_FOR_KEYBOARD 260.0
#define PROTOCOLSTRING @"com.magtek.idynamo"
#define _DGBPRNT

@implementation ViewController

@synthesize dancersArray,dancersTable,segmentedControl,dancerSearchField,creditCardButton,cashButton,voucherButton,addDancerPopoverController,lastClickedCell,currentButton,totalAmountLabel,dancesPaymentArray,dancesPaymentTable,minsPerPriceButton,minsPerDanceOptions,pricePerDanceButton,houseFeeLabel,houseFeeButton,currentDancer,dancesPaymentDetails, vipDanceViewController, vipPopOverController, vipDanceButton, dancerPayTextField, myMutableData, creditCardCVVTextField, creditCardExpiryTextField, creditCardNumberTextField, deviceStatus, mtSCRALib, signatureImage, labelAboveCC, buttonAmountAboveCC, labelAmountAboveCC, buttonPaynow, buttonPayByCC, buttonPayByCash;
@synthesize signatureViewController, selectedDancersArray;
static BOOL pushedUp = NO;
static NSString *portName = nil;
static NSString *portSettings = nil;

static NSString *printerAddress = @"TCP:192.168.1.81";
static NSString *printerPort = @"9100";
//static NSString *printerPort = @"mini";

static NSString *amountToBeCharged = 0;
static BOOL isCreditCardButtonSelected = NO;
static BOOL isCashButtonSelected = NO;
static BOOL isVoucherButtonSelected = NO;
static BOOL isSwipe = NO;
static NSString *track1;
static BOOL isMasterPrint = NO;
static BOOL isVoucherPrint = NO;
static NSUInteger voucherCount = 0 ;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"dev WSDL URL %@", devMercuryWSDLURL);
    MagTekDemoAppDelegate * appDelegate = (MagTekDemoAppDelegate*) [UIApplication sharedApplication].delegate;
    
    self.dancersArray = appDelegate.dancersArray;
    self.vipDanceViewController = [[VIPDacneViewController alloc] init];
    vipPopOverController = [[UIPopoverController alloc] initWithContentViewController:vipDanceViewController];
    self.selectedDancersArray = appDelegate.selectedDancersArray;
    
    self.dancesPaymentArray = [[NSMutableArray alloc] initWithObjects:@"15 mins/100",@"30 mins/200",@"45 mins/300",@"60 mins/400", nil];
   
    self.mtSCRALib = (MTSCRA *)([appDelegate getSCRALib]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackDataReady:) name:@"trackDataReadyNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devConnStatusChange) name:@"devConnectionNotification" object:nil];
    
    
    [self devConnStatusChange];
    
//    if (![mtSCRALib isDeviceConnected]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please connect the swipe device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
   // miniPrinterFunctions = [[MiniPrinterFunctions alloc]init];
    printerFunctions = [[PrinterFunctions alloc] init];
    //[self GetStatus];
    
    [self performSelector:@selector(setIDynamoSwitch:) withObject:nil afterDelay:1.0];
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
        self.mtSCRALib = nil;
    self.deviceStatus = nil;
}

- (IBAction)MegTekDemoTapped:(id)sender{
    MagTekDemoViewController *megVC = [[MagTekDemoViewController alloc] init];
    [self presentModalViewController:megVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboardForTextField:) 
												 name:UIKeyboardDidHideNotification object:self.view.window];
    MagTekDemoAppDelegate * appDelegate = (MagTekDemoAppDelegate*) [UIApplication sharedApplication].delegate;
    self.dancersArray = appDelegate.dancersArray;
    //[self.dancesPaymentDetails removeAllObjects];
    self.mtSCRALib = (MTSCRA *)([appDelegate getSCRALib]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackDataReady:) name:@"trackDataReadyNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devConnStatusChange) name:@"devConnectionNotification" object:nil];
    
    
    [self devConnStatusChange];
    [self performSelector:@selector(setIDynamoSwitch:) withObject:nil afterDelay:0.50];
    [self.dancersTable reloadData];
    [self.dancesPaymentTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationPortrait;
}

#pragma mark -
#pragma mark Private Methods Methods
#pragma mark -


-(IBAction)payNowButtonPressed:(id)sender
{
    if ([sender tag] == 112) {//Pay by Cash Voucher
        isVoucherPrint = YES;
        if ([self.creditCardNumberTextField.text isEqualToString:@""] || [self.creditCardExpiryTextField.text isEqualToString:@""] || [self.creditCardCVVTextField.text isEqualToString:@""] ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill up all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        else {
            self.signatureViewController = nil;
            self.signatureViewController = [[SignatureViewController alloc] initWithNibName:@"SignatureViewController" bundle:[NSBundle mainBundle]];
            self.signatureViewController.delegate = self;
            self.signatureViewController.modalPresentationStyle = UIModalPresentationFormSheet;
            self.signatureViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:self.signatureViewController animated:YES];
            return;
        }
    }
    if ([sender tag] == 111){
        UIImage *voucherImage = [UIImage imageNamed:@"voucherprint"];
        [PrinterManager PrintImageWithPortname:printerAddress portSettings:printerPort imageToPrint:voucherImage maxWidth:480];
        PrinterManager *pm = (PrinterManager*)[PrinterManager shared];
        [pm openCashDrawerWithPortname:portName portSettings:portSettings];
        return;
    }
    
    if (!self.currentDancer) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select the dancer first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (!(isVoucherButtonSelected || isCashButtonSelected || isCreditCardButtonSelected)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a payment method from above" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    NSString *tempString = self.dancerPayTextField.text;
    tempString = [tempString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    NSLog(@"[tempString intValue] %d", [tempString intValue]);
    
    if ([tempString intValue] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Payment Value cannot be less then or equal to 0" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (isCreditCardButtonSelected) {
        if ([self.creditCardNumberTextField.text isEqualToString:@""] || [self.creditCardExpiryTextField.text isEqualToString:@""] || [self.creditCardCVVTextField.text isEqualToString:@""] ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill up all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        else {
            self.signatureViewController = nil;
            self.signatureViewController = [[SignatureViewController alloc] initWithNibName:@"SignatureViewController" bundle:[NSBundle mainBundle]];
            self.signatureViewController.delegate = self;
            self.signatureViewController.modalPresentationStyle = UIModalPresentationFormSheet;
            self.signatureViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:self.signatureViewController animated:YES];
           
        }
    }
    if (isCashButtonSelected) {
        [self deductAndUpdateView];
        //[self OpenCashDrawer];
        PrinterManager *pm = (PrinterManager*)[PrinterManager shared];
        [pm openCashDrawerWithPortname:portName portSettings:portSettings];
        [self TextRasterPrinting];
        
    }else if (isCreditCardButtonSelected) {
       [self TextRasterPrinting]; 
    }
    else if (isVoucherButtonSelected) {
        PrinterManager *pm = (PrinterManager*)[PrinterManager shared];
        [pm openCashDrawerWithPortname:portName portSettings:portSettings];
    }
        
        
       
        
  //  }
    
    /*self.signatureViewController = nil;
     self.signatureViewController = [[SignatureViewController alloc] initWithNibName:@"SignatureViewController" bundle:[NSBundle mainBundle]];
    
    [self presentModalViewController:self.signatureViewController animated:YES];
[self beginTransaction];
     */
    
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    [self.dancerPayTextField resignFirstResponder];
}

-(IBAction)creditCartButtonPressed:(id)sender
{
    self.labelAboveCC.text = @"Amount";
    self.labelAmountAboveCC.hidden = YES;
    self.buttonAmountAboveCC.hidden = YES;
    self.buttonPaynow.hidden = NO;
    self.buttonPayByCash.hidden = YES;
    self.buttonPayByCC.hidden = YES;
    isCreditCardButtonSelected  = YES;
    isCashButtonSelected = NO;
    isVoucherButtonSelected = NO;
    [self.creditCardButton setBackgroundImage:[UIImage imageNamed:@"btn_credit_card_selected.png"] forState:UIControlStateNormal];
    [self.cashButton setBackgroundImage:[UIImage imageNamed:@"btn_cash.png"] forState:UIControlStateNormal];
    [self.voucherButton setBackgroundImage:[UIImage imageNamed:@"btn_voucher.png"] forState:UIControlStateNormal];
}


-(IBAction)cashButtonPressed:(id)sender
{   
    self.buttonPaynow.hidden = NO;
    self.buttonPayByCash.hidden = YES;
    self.buttonPayByCC.hidden = YES;
    self.labelAboveCC.text = @"Amount";
    self.labelAmountAboveCC.hidden = YES;
    self.buttonAmountAboveCC.hidden = YES;
    isCreditCardButtonSelected  = NO;
    isCashButtonSelected = YES;
    isVoucherButtonSelected = NO;
    [self.creditCardButton setBackgroundImage:[UIImage imageNamed:@"btn_credit_card.png"] forState:UIControlStateNormal];
    [self.cashButton setBackgroundImage:[UIImage imageNamed:@"btn_cash_selected.png"] forState:UIControlStateNormal];
    [self.voucherButton setBackgroundImage:[UIImage imageNamed:@"btn_voucher.png"] forState:UIControlStateNormal];
    self.creditCardCVVTextField.text = @"";
    self.creditCardExpiryTextField.text = @"";
    self.creditCardNumberTextField.text = @"";
}

-(IBAction)voucherButtonPressed:(id)sender
{
    isCreditCardButtonSelected  = NO;
    isCashButtonSelected = NO;
    isVoucherButtonSelected = YES;
    [self.creditCardButton setBackgroundImage:[UIImage imageNamed:@"btn_credit_card.png"] forState:UIControlStateNormal];
    [self.cashButton setBackgroundImage:[UIImage imageNamed:@"btn_cash.png"] forState:UIControlStateNormal];
    [self.voucherButton setBackgroundImage:[UIImage imageNamed:@"btn_voucher_selected.png"] forState:UIControlStateNormal];
    self.creditCardCVVTextField.text = @"";
    self.creditCardExpiryTextField.text = @"";
    self.creditCardNumberTextField.text = @"";
    self.labelAboveCC.text = @"Voucher";
    self.labelAmountAboveCC.hidden = NO;
    self.buttonAmountAboveCC.hidden = NO;
    self.buttonPaynow.hidden = YES;
    self.buttonPayByCash.hidden = NO;
    self.buttonPayByCC.hidden = NO;
}

-(void) addDancerPriceButtonPressed:(id)sender {
    
    ExtendedButton * button = (ExtendedButton*) sender;
    
    Dancer * dancer = button.dancer;
    NSInteger dances = [dancer.dances intValue];
    dances += 1;
    dancer.dances = [NSString stringWithFormat:@"%d",dances];
    button.dancesLabel.text = [NSString stringWithFormat:@"%@",dancer.dances];
    [self saveDancers];
    
    [self calculatePaymentDetails];
    
}

-(void) minusDancerPriceButtonPressed:(id)sender {
    
    ExtendedButton * button = (ExtendedButton*) sender;
    NSLog(@"Minus Dancers button pressed");
    Dancer * dancer = button.dancer;
    NSInteger dances = [dancer.dances intValue];
    dances -= 1;
    if(dances < 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Dances cannot be less then zero" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        dances += 1;
        return;
    }
    [self calculatePaymentDetails];
    dancer.dances = [NSString stringWithFormat:@"%d",dances];
    button.dancesLabel.text = [NSString stringWithFormat:@"%@",dancer.dances];
    
    
    
    
    NSInteger vipDanceAmount = 0;
    NSInteger totalAmount = 0;
    NSString *vipDancesDetails;
    vipDanceAmount = [self.currentDancer.dances intValue] * [self.currentDancer.pricePerDance intValue];
    vipDancesDetails = [NSString stringWithFormat:@"   %d           VIP Dances                                        -$%d", [self.dancesPaymentDetails count]+1 , [self.currentDancer.pricePerDance intValue]];
    //  NSLog(@"dances %@", [self.currentDancer.dances intValue]);
    [self.dancesPaymentDetails addObject:vipDancesDetails];
    totalAmount = [self.currentDancer.totalFee intValue];
    totalAmount = totalAmount - [self.currentDancer.pricePerDance intValue];
    self.currentDancer.totalFee = [NSNumber numberWithInt:totalAmount];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"$ %d",totalAmount];
    [self.dancesPaymentTable reloadData];
    
    [self saveDancers];
}

-(void) saveDancers {
    
    MagTekDemoAppDelegate * appDelegate = (MagTekDemoAppDelegate*) [UIApplication sharedApplication].delegate;
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <[appDelegate.dancersArray count] ; i++) {
        
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[appDelegate.dancersArray objectAtIndex:i]];
        [tempArray addObject:myEncodedObject];
    }
    
    NSArray * dancers = [NSArray arrayWithArray:tempArray];
    [[NSUserDefaults standardUserDefaults] setObject:dancers forKey:@"DancersArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void) calculatePaymentDetails {
    NSLog(@"Calculate payment");
    NSInteger totalAmount = 0;
    self.dancesPaymentDetails = nil;
    self.dancesPaymentDetails = [[NSMutableArray alloc] init];
    NSInteger vipDanceAmount = 0;
    NSString * vipDancesDetails = nil;
    NSString * minsPerDanceDetails = nil;
    NSString * houseFeeDetails = nil;
    
    
    if (self.currentDancer.dances && self.currentDancer.pricePerDance) {
        
        vipDanceAmount = [self.currentDancer.dances intValue] * [self.currentDancer.pricePerDance intValue];
         vipDancesDetails = [NSString stringWithFormat:@"   1           VIP Dances                                         $%d",vipDanceAmount];
      //  NSLog(@"dances %@", [self.currentDancer.dances intValue]);
        [self.dancesPaymentDetails addObject:vipDancesDetails];
        totalAmount += vipDanceAmount;
    }
    
    
    if (self.currentDancer.houseFee) {
        
        houseFeeDetails = [NSString stringWithFormat:@"   2           House Fee                                          $%@",self.currentDancer.houseFee];
        
        [self.dancesPaymentDetails addObject:houseFeeDetails];
        
        totalAmount += [self.currentDancer.houseFee intValue];
        
    }
    
    
    if (self.currentDancer.minsPerPrice)
    {
        for (int i = 0; i < [self.currentDancer.minsPerPrice count]; i++) {
                
            //@"15 mins/100",@"30 mins/200",@"45 mins/300",@"60 mins/400
                
            NSString * temp = [self.currentDancer.minsPerPrice objectAtIndex:i];
            NSArray * stringComponents = [temp componentsSeparatedByString:@"/"];
            NSString * mins = [stringComponents objectAtIndex:0];
            NSInteger amount = [[stringComponents objectAtIndex:1] intValue];
                    
            minsPerDanceDetails = [NSString stringWithFormat:@"   %d            %@                                              $%d",i+3,mins,amount];
            [self.dancesPaymentDetails addObject:minsPerDanceDetails];
                    
            totalAmount += amount;
                
        }
    }
    if (self.currentDancer.dancerPaid) {
        NSLog(@"inside");
        for (int i = 0; i < [self.currentDancer.dancerPaid count]; i++) {
            int paidValue = [[self.currentDancer.dancerPaid objectAtIndex:i] intValue];
            NSString *dancerString =  [NSString stringWithFormat:@"   %d           Dancer Paid                                        -$%d", [self.dancesPaymentDetails count] +1,  paidValue];
            [self.dancesPaymentDetails addObject:dancerString];
            totalAmount -= paidValue;
        }
    }
    self.currentDancer.totalFee = [NSNumber numberWithInt:totalAmount];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"$ %d",totalAmount];
    [self.dancesPaymentTable reloadData];
}

#pragma mark -
#pragma mark UISegmentedControl Methods
#pragma mark -


- (IBAction)didChangeSegmentControl:(UISegmentedControl *)control {
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            NSLog(@"Segment 1 selected.");
            
            [self.segmentedControl setImage:[UIImage imageNamed:@"btn_add_dancer_selected.png"] forSegmentAtIndex:0];
            [self.segmentedControl setImage:[UIImage imageNamed:@"btn_edit_list.png"]forSegmentAtIndex:1];
            [self.segmentedControl setImage:[UIImage imageNamed:@"btn_print_details.png"]forSegmentAtIndex:2];
            
            AddDancerListViewController *addDancerList = [[AddDancerListViewController alloc] initWithNibName:@"AddDancerListViewController" bundle:[NSBundle mainBundle]];
            addDancerList.parentVC = self;
            AddDancerViewController * addDancerViewController = [[AddDancerViewController alloc] initWithNibName:@"AddDancerViewController" bundle:[NSBundle mainBundle]];
            addDancerViewController.parentController = self;
            
            self.addDancerPopoverController = [[UIPopoverController alloc]initWithContentViewController:addDancerList];
            self.addDancerPopoverController.delegate = self;
            
            float dx = self.segmentedControl.frame.origin.x - 100;
            CGRect frame = CGRectMake(dx, self.segmentedControl.frame.origin.y, self.segmentedControl.frame.size.width, self.segmentedControl.frame.size.height);
            
            [self.addDancerPopoverController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
            [self.addDancerPopoverController setPopoverContentSize:CGSizeMake(320, 500)];
            
            break;
            
        }
        case 1:
        {
            NSLog(@"Segment 2 selected.");
            
            [self.segmentedControl setImage:[UIImage imageNamed:@"btn_add_dancer.png"] forSegmentAtIndex:0];
            [self.segmentedControl setImage:[UIImage imageNamed:@"btn_edit_list_selected.png"]forSegmentAtIndex:1];
            [self.segmentedControl setImage:[UIImage imageNamed:@"btn_print_details.png"]forSegmentAtIndex:2];
            
            EditDancerListViewController * editDancerListViewController = [[EditDancerListViewController alloc] initWithNibName:@"EditDancerListViewController" bundle:[NSBundle mainBundle]];
            UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:editDancerListViewController] autorelease];
           // navController.navigationBarHidden = YES;
           // [self presentModalViewController:navController animated:YES];
            self.addDancerPopoverController = [[UIPopoverController alloc]initWithContentViewController:navController];
            self.addDancerPopoverController.delegate = self;
            
            float dx = self.segmentedControl.frame.origin.x;
            CGRect frame = CGRectMake(dx, self.segmentedControl.frame.origin.y, self.segmentedControl.frame.size.width, self.segmentedControl.frame.size.height);
            
            [self.addDancerPopoverController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
            [self.addDancerPopoverController setPopoverContentSize:CGSizeMake(320, 500)];
            
            break;
            
        }
        case 2:
        {
            NSLog(@"Segment 3 selected.");
            [self.segmentedControl setImage:[UIImage imageNamed:@"btn_add_dancer.png"] forSegmentAtIndex:0];
            [self.segmentedControl setImage:[UIImage imageNamed:@"btn_edit_list.png"]forSegmentAtIndex:1];
            [self.segmentedControl setImage:[UIImage imageNamed:@"btn_print_details_selected.png"]forSegmentAtIndex:2];
            [self TextRasterPrinting];
            isMasterPrint = YES;
            break;
        }
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark UIPopoverDelegate Methods
#pragma mark -

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == self.addDancerPopoverController) {
        
        self.addDancerPopoverController = nil;
        
        [self.segmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [self.segmentedControl setImage:[UIImage imageNamed:@"btn_add_dancer.png"] forSegmentAtIndex:0];
        [self.segmentedControl setImage:[UIImage imageNamed:@"btn_edit_list.png"]forSegmentAtIndex:1];
        [self.segmentedControl setImage:[UIImage imageNamed:@"btn_print_details.png"]forSegmentAtIndex:2];
        
        self.currentDancer = nil;
        if ([self.dancersArray count] == 0) {
            
            [self.dancesPaymentDetails removeAllObjects];
        }
        [self.dancesPaymentTable reloadData];
        [self.dancersTable reloadData];
        
    }
    
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return YES;
}

- (IBAction)voucherAmountButtonTapped:(id)sender{
    NSLog(@"Do something");
    vipDanceViewController.tagNumber = 200;
    self.vipPopOverController.delegate = self;
    CGRect frame = self.buttonAmountAboveCC.frame;
    [self.vipPopOverController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    [self.vipPopOverController setPopoverContentSize:CGSizeMake(320, 440)];
    self.vipDanceViewController.parentController = self;
    vipDanceViewController.tagNumber = 200;
    //vipDanceViewController.dancesPaymentArray = self.dancesPaymentArray;
    vipDanceViewController.view.frame = CGRectMake(0, 0, 320, 440);
}

-(void) dismissAddDancerPopover
{
    NSLog(@"dismiss");
    if (self.addDancerPopoverController != nil) {
        
        [self.addDancerPopoverController dismissPopoverAnimated:YES];
        self.addDancerPopoverController = nil;
        
        [self.segmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [self.segmentedControl setImage:[UIImage imageNamed:@"btn_add_dancer.png"] forSegmentAtIndex:0];
        [self.segmentedControl setImage:[UIImage imageNamed:@"btn_edit_list.png"]forSegmentAtIndex:1];
        [self.segmentedControl setImage:[UIImage imageNamed:@"btn_print_details.png"]forSegmentAtIndex:2];
        
        self.currentDancer = nil;
        NSLog(@"dancers count : %d",[self.dancersArray count]);
        if ([self.dancersArray count] == 0) {
            
            [self.dancesPaymentDetails removeAllObjects];
        }
        [self.dancesPaymentTable reloadData];
        [self.dancersTable reloadData];
        
    }
}



#pragma mark -
#pragma mark UITextFild Methods
#pragma mark -

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
        NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    if (textField.tag = 100) {
        amountToBeCharged = textField.text;
        NSLog(@"amount to be charged %@", amountToBeCharged);
    }
    return YES;
}




#pragma mark -
#pragma mark UITableView Methods
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.dancersTable) {
        
        return [self.selectedDancersArray count];
    }
    else
    {
        return [self.dancesPaymentDetails count];
    }
    
    
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == self.dancersTable) {
        
        return 36;
    }
    else
    {
        return 30;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"section%icell%i",indexPath.section,indexPath.row];
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	cell = nil;
    
    if(cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (tableView == self.dancersTable) {
        
        UIImageView * cellBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 316, 36)];
        cellBG.image = [UIImage imageNamed:@"bg_dancer_cell.png"];
        cell.backgroundView = (UIView*) cellBG;
        
        Dancer * dancer = [self.selectedDancersArray objectAtIndex:indexPath.row];
        
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 270, 20)];
        nameLabel.textColor = [UIColor colorWithRed:106.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:15.0];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = UITextAlignmentLeft;
        
        
        nameLabel.text = [NSString stringWithFormat:@"%@",dancer.dancerName];
        
        [cell addSubview:nameLabel];
        
        UIView * priceControlView = [[UIView alloc] initWithFrame:CGRectMake(216, 0, 100, 36)];
        priceControlView.backgroundColor = [UIColor clearColor];
        priceControlView.tag = indexPath.row;
        priceControlView.hidden = YES;
        
        UILabel * dancesLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 40, 26)];
        dancesLabel.textColor = [UIColor colorWithRed:106.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0];
        dancesLabel.backgroundColor = [UIColor clearColor];
        dancesLabel.font = [UIFont boldSystemFontOfSize:15.0];
        dancesLabel.backgroundColor = [UIColor clearColor];
        dancesLabel.textAlignment = UITextAlignmentCenter;
        dancesLabel.text = [NSString stringWithFormat:@"%@",dancer.dances];
        [priceControlView addSubview:dancesLabel];
        
        ExtendedButton * plusButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        plusButton.frame = CGRectMake(0, 5, 26, 26);
        plusButton.dancesLabel = dancesLabel;
        plusButton.dancer = dancer;
        [plusButton setBackgroundImage:[UIImage imageNamed:@"btn_plus_white.png"] forState:UIControlStateNormal];
        [plusButton addTarget:self action:@selector(addDancerPriceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [priceControlView addSubview:plusButton];
        
        
        
        ExtendedButton * minusButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        minusButton.frame = CGRectMake(70, 5, 26, 26);
        minusButton.dancesLabel = dancesLabel;
        minusButton.dancer = dancer;
        [minusButton setBackgroundImage:[UIImage imageNamed:@"btn_minus_white.png"] forState:UIControlStateNormal];
        [minusButton addTarget:self action:@selector(minusDancerPriceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [priceControlView addSubview:minusButton];
        
        
        [cell addSubview:priceControlView];
        return cell;
    }
    else
    {
        NSString * paymentDetails = [self.dancesPaymentDetails objectAtIndex:indexPath.row];
        UILabel * paymentDetailsText = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 434, 26)];
        paymentDetailsText.textColor = [UIColor colorWithRed:106.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0];
        paymentDetailsText.backgroundColor = [UIColor clearColor];
        paymentDetailsText.font = [UIFont boldSystemFontOfSize:15.0];
        paymentDetailsText.backgroundColor = [UIColor clearColor];
        paymentDetailsText.textAlignment = UITextAlignmentLeft;
        paymentDetailsText.text = [NSString stringWithFormat:@"%@",paymentDetails];
        [cell addSubview:paymentDetailsText];
        NSLog(@"self payment detail sizr %d", [self.dancesPaymentDetails count]);
        return cell;
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.dancersTable) {
        
        [tableView reloadData];
        
        
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        
        UIImageView * cellBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 316, 36)];
        cellBG.image = [UIImage imageNamed:@"bg_dancer_cell_selected.png"];
        cell.backgroundView = (UIView*) cellBG;
        
        UIView * priceControlView = [cell.subviews objectAtIndex:3];
        priceControlView.hidden = NO;
        [cell bringSubviewToFront:priceControlView];
        
        self.currentDancer = [self.selectedDancersArray objectAtIndex:indexPath.row];
        
        [self calculatePaymentDetails];
        if (self.currentDancer.pricePerDance) {
            [self.pricePerDanceButton setTitle:self.currentDancer.pricePerDance forState:UIControlStateNormal];
        }
        if (self.currentDancer.houseFee) {
            [self.houseFeeButton setTitle:self.currentDancer.houseFee forState:UIControlStateNormal];
        }
        
    }
    
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        //TODO: Need to enter delete web service URL
       // NSLog(@"name is %@", [[self.myWhishlistArray objectAtIndex:indexPath.row] couponName]); 
        NSString *deletedRow = [self.dancesPaymentDetails objectAtIndex:indexPath.row];
        NSRange range = [deletedRow rangeOfString:@"VIP" 
                                      options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound) {
                self.currentDancer.dances = @"";
            NSLog(@"Removed vip");
        }
        range = [deletedRow rangeOfString:@"House" 
                                  options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound) {
            self.currentDancer.houseFee = @"";
            NSLog(@"Removed house fee");
        }
        range = [deletedRow rangeOfString:@"mins" 
                                  options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound) {
            [self.currentDancer.minsPerPrice removeObjectAtIndex:0];
            NSLog(@"Removed mins");
        }
        [self.dancesPaymentDetails removeObjectAtIndex:indexPath.row];
//        [self.dancesPaymentTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        [self.dancersTable reloadData];
        [self calculatePaymentDetails];
      //  [self.dancesPaymentTable reloadData];
        
    }
}





- (IBAction)settingButtonTapped:(id)sender{
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    settingsVC.modalPresentationStyle = UIModalPresentationFormSheet;
	settingsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:settingsVC animated:YES];
    
}

- (IBAction)vipDanceButtonTapped:(id)sender{
   
    
   // vipDanceViewController.currentDancer = [appDelegate.dancersArray objectAtIndex:0];
    vipDanceViewController.currentDancer = self.currentDancer;
    if ([sender tag] == 100) {
        self.vipPopOverController.delegate = self;
        CGRect frame = CGRectMake(475, 60, 273, 33);
        [self.vipPopOverController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        [self.vipPopOverController setPopoverContentSize:CGSizeMake(320, 460)];
        self.vipDanceViewController.parentController = self;
        vipDanceViewController.tagNumber = [sender tag];
    }
    if ([sender tag] == 101) {
        self.vipPopOverController.delegate = self;
        CGRect frame = CGRectMake(475, 115, 273, 35);
        [self.vipPopOverController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        [self.vipPopOverController setPopoverContentSize:CGSizeMake(320, 460)];
        self.vipDanceViewController.parentController = self;
        vipDanceViewController.tagNumber = [sender tag];
        
    }
    if ([sender tag] == 102) {
        NSLog(@"TAG 102");
        self.vipPopOverController.delegate = self;
        CGRect frame = CGRectMake(475, 172, 273, 33);
        [self.vipPopOverController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        [self.vipPopOverController setPopoverContentSize:CGSizeMake(320, 240)];
        self.vipDanceViewController.parentController = self;
        vipDanceViewController.tagNumber = [sender tag];
        vipDanceViewController.dancesPaymentArray = self.dancesPaymentArray;
        vipDanceViewController.view.frame = CGRectMake(0, 0, 320, 240);
    }
    
    [vipDanceViewController.myTableView reloadData];

}
#pragma mark TextField Methods

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
    if (textField.tag == 100) {
        amountToBeCharged = textField.text;
        NSLog(@"amount to be charged %@", amountToBeCharged);
       /* self.signatureViewController = [[SignatureViewController alloc] initWithNibName:@"SignatureViewController" bundle:[NSBundle mainBundle]];
        self.signatureViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        self.signatureViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
      //  self.signatureViewController.parentViewController = self;
        [self presentModalViewController:self.signatureViewController animated:NO];
        */
//        [self beginTransaction];
        
        
    }
    [self.dancerPayTextField resignFirstResponder];
    

}

- (void)dismissEverything{
    NSLog(@"dismiss everything");
    [self.dancerPayTextField resignFirstResponder];
}

- (void)beginTransaction{
      /* if ([ViewController checkReachabilityForHost:@"www.google.com"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Make sure you are connected to the internet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    */
    NSMutableString *tempExpString;
    if(!isSwipe){
        NSMutableString *expirationString = [NSMutableString stringWithString:self.creditCardCVVTextField.text];//TODO: CCV field is connected with the expiration field from the IBOUtlet
        NSLog(@"Original expString = %@", expirationString);
        expirationString = [NSMutableString stringWithString:[expirationString stringByReplacingOccurrencesOfString:@"/" withString:@""]];
        NSLog(@"changed expString = %@", expirationString);
        NSMutableArray *chars = [[NSMutableArray alloc] initWithCapacity:[expirationString length]];
        for (int i=0; i < [expirationString length]; i++) {
            NSString *ichar  = [NSString stringWithFormat:@"%C", [expirationString characterAtIndex:i]];
            [chars addObject:ichar];
        }
        NSLog(@"lenght of parsed array = %d", [chars count]);
        tempExpString = [NSMutableString stringWithString:[chars objectAtIndex:2]];
        [tempExpString appendString:[chars objectAtIndex:3]];
        [tempExpString appendString:[chars objectAtIndex:0]];
        [tempExpString appendString:[chars objectAtIndex:1]];
        NSLog(@"Exp date IS %@", tempExpString);
        NSLog(@"begin Transaction");
        NSLog(@"%@ label balye", dancerPayTextField.text);
    }
    
    NSString *tempString;// = [NSString stringWithString:dancerPayTextField.text];
    if (isVoucherPrint) {
        tempString = self.labelAboveCC.text;
    }else {
        tempString = [NSString stringWithString:dancerPayTextField.text];
    }
    
    tempString = [tempString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    tempString = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"AMOUNT IS %@", tempString);
    NSString *xmlString;
    if (!isSwipe) {
        
    xmlString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> <soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><CreditTransaction xmlns=\"http://www.mercurypay.com\"><tran>&lt;?xml version=\"1.0\"?&gt;&lt;TStream&gt;&lt;Transaction&gt;&lt;MerchantID&gt;595901&lt;/MerchantID&gt;&lt;OperatorID&gt;test&lt;/OperatorID&gt;&lt;TranType&gt;Credit&lt;/TranType&gt;&lt;TranCode&gt;Sale&lt;/TranCode&gt;&lt;InvoiceNo&gt;10&lt;/InvoiceNo&gt;&lt;RefNo&gt;10&lt;/RefNo&gt;&lt;Memo&gt;exuromar&lt;/Memo&gt;&lt;Account&gt; &lt;Track2&gt;%@=%@5025432198712345&lt;/Track2&gt;&lt;Name&gt;MPS TEST&lt;/Name&gt;&lt;/Account&gt;&lt;Amount&gt;&lt;Purchase&gt;%@.00&lt;/Purchase&gt;&lt;/Amount&gt;&lt;/Transaction&gt;&lt;/TStream&gt;</tran><pw>xyz</pw></CreditTransaction></soap:Body></soap:Envelope>", self.creditCardNumberTextField.text, tempExpString, tempString];
        NSLog(@"XML STring %@", xmlString);
   // NSString *xmlString = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><CreditTransaction xmlns=\"http://www.mercurypay.com\"><tran>&lt;?xml version=\"1.0\"?&gt;&lt;TStream&gt;&lt;Transaction&gt;&lt;MerchantID&gt;595901&lt;/MerchantID&gt;&lt;OperatorID&gt;test&lt;/OperatorID&gt;&lt;TranType&gt;Credit&lt;/TranType&gt;&lt;TranCode&gt;Sale&lt;/TranCode&gt;&lt;InvoiceNo&gt;10&lt;/InvoiceNo&gt;&lt;RefNo&gt;10&lt;/RefNo&gt;&lt;Memo&gt;exuromar&lt;/Memo&gt;&lt;Account&gt; &lt;Track2&gt;4003000123456781=09085025432198712345&lt;/Track2&gt;&lt;Name&gt;MPS TEST&lt;/Name&gt;&lt;/Account&gt;&lt;Amount&gt;&lt;Purchase&gt;1.00&lt;/Purchase&gt;&lt;/Amount&gt;&lt;/Transaction&gt;&lt;/TStream&gt;</tran><pw>xyz</pw></CreditTransaction></soap:Body></soap:Envelope>";
    }
    else {
        xmlString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> <soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><CreditTransaction xmlns=\"http://www.mercurypay.com\"><tran>&lt;?xml version=\"1.0\"?&gt;&lt;TStream&gt;&lt;Transaction&gt;&lt;MerchantID&gt;395347305=E2ETKN&lt;/MerchantID&gt;&lt;OperatorID&gt;test&lt;/OperatorID&gt;&lt;TranType&gt;Credit&lt;/TranType&gt;&lt;TranCode&gt;Sale&lt;/TranCode&gt;&lt;InvoiceNo&gt;10&lt;/InvoiceNo&gt;&lt;RefNo&gt;10&lt;/RefNo&gt;&lt;Memo&gt;exuromar&lt;/Memo&gt;&lt;Account&gt; &lt;Track1&gt;%@&lt;/Track1&gt;&lt;Name&gt;MPS TEST&lt;/Name&gt;&lt;/Account&gt;&lt;Amount&gt;&lt;Purchase&gt;%@.00&lt;/Purchase&gt;&lt;/Amount&gt;&lt;/Transaction&gt;&lt;/TStream&gt;</tran><pw>123E2ETKN</pw></CreditTransaction></soap:Body></soap:Envelope>", track1, self.creditCardNumberTextField.text, tempString];
        isSwipe = NO;
    }
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:devMercuryURL]];
    
    [req setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"MPS Transact 1.2.0.4" forHTTPHeaderField:@"User-Agent"];
    [req setValue:@"utf-8" forHTTPHeaderField:@"charset"];
    [req setValue:@"http://www.mercurypay.com/CreditTransaction" forHTTPHeaderField:@"SOAPAction"];
     
    NSString *contentLength = [NSString stringWithFormat:@"%d", [xmlString length]];
	[req addValue:contentLength forHTTPHeaderField:@"Content-Length"];
	
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        self.myMutableData = [[NSMutableData alloc] init];
        NSLog(@"Conn for product is true");
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
-(NSCachedURLResponse *)connection:(NSURLConnection *)connection
                 willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger statusCode = [httpResponse statusCode];
    NSLog(@"Http Status Code: %i",statusCode);
    NSLog(@"%@", [httpResponse allHeaderFields]);
    
    if ([response respondsToSelector:@selector(statusCode)])
    {
        int statusCode = [((NSHTTPURLResponse *)response) statusCode];
        if (statusCode >= 400)
        {
            [connection cancel];  // stop connecting; no more delegate messages
            NSDictionary *errorInfo
            = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
                                                  NSLocalizedString(@"Server returned status code %d",@""),
                                                  statusCode]
                                          forKey:NSLocalizedDescriptionKey];
            NSError *statusError
            = [NSError errorWithDomain:@"HTTP Error"
                                  code:statusCode
                              userInfo:errorInfo];
            [self connection:connection didFailWithError:statusError];
        }
    }
    [self.myMutableData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.myMutableData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    connection = nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Server has returned an error. Please try again in a few moments" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    self.myMutableData = nil;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *result =[[NSString alloc]initWithData:self.myMutableData encoding:NSUTF8StringEncoding];   
    NSLog(@"downloaded output  %@",result);
   
    
    NSRange range = [result rangeOfString:@"declined" 
                                      options:NSCaseInsensitiveSearch];
    NSRange range1 = [result rangeOfString:@"invalid" 
                                  options:NSCaseInsensitiveSearch];
    if(range.location != NSNotFound || range1.location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Transaction has been declined" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    range = [result rangeOfString:@"Approved" 
                                  options:NSCaseInsensitiveSearch];
    if(range.location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Transaction has been accepted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        if (!isVoucherPrint) {
            [self deductAndUpdateView];
            [self TextRasterPrinting];
        }else {
            [self displayVoucherPrintScreen];
        }
        
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (void)displayVoucherPrintScreen{
    UIImage *voucherImage = [UIImage imageNamed:@"voucherprint"];
//    voucherCount++;
//    VoucherPrintViewController *voucherPrintVC = [[VoucherPrintViewController alloc] initWithNibName:@"VoucherPrintViewController" bundle:[NSBundle mainBundle]];
//    voucherPrintVC.modalPresentationStyle = UIModalPresentationFormSheet;
//    voucherPrintVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentModalViewController:voucherPrintVC animated:YES];
    [PrinterManager PrintImageWithPortname:printerAddress portSettings:printerPort imageToPrint:voucherImage maxWidth:480];
     PrinterManager *pm = (PrinterManager*)[PrinterManager shared];
    [pm openCashDrawerWithPortname:portName portSettings:portSettings];
}

+ (BOOL)checkReachabilityForHost:(NSString *)host{
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]];
    return ( URLString != NULL ) ? YES : NO;
}
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
	
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        NSLog(@"inised moved up ");
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        //rect.size.height += kOFFSET_FOR_KEYBOARD;
		pushedUp = YES;
    }
    else
    {
        NSLog(@"isnide moved down");
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        //rect.size.height -= kOFFSET_FOR_KEYBOARD;
		pushedUp = NO;
    }
    self.view.frame = rect;
	
    [UIView commitAnimations];
}



- (void)keyboardWillShow:(NSNotification *)notif
{
    //keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
	
    if (([self.creditCardNumberTextField isFirstResponder] || [self.creditCardExpiryTextField isFirstResponder] || [self.creditCardCVVTextField isFirstResponder] ) && self.view.frame.origin.y >= 0)
    {
        NSLog(@"move up"); 
        pushedUp = YES;
        [self setViewMovedUp:YES];
    }
   
}
-(IBAction)hideKeyboardForTextField:(id)sender{
    NSLog(@"y is : %f", self.view.frame.origin.y);
    if ([self.dancerPayTextField isFirstResponder]) {
        NSLog(@" abcd");
        return;
    }
    if (self.view.frame.origin.y >= 20) {
        NSLog(@"returned");
        return;
    }
	[self.creditCardNumberTextField resignFirstResponder];
	//self.textView.text = @"";
	NSLog(@"insiode hidekeyboardfortextfield");
	pushedUp = YES;
    //move the main view, so that the keyboard does not hide it.
        [self setViewMovedUp:NO];
    
}

#pragma mark -
#pragma mark MegTek
- (void) openDevice
{
    if([mtSCRALib getDeviceType]==MAGTEKIDYNAMO)
    {        
        [self.mtSCRALib setDeviceProtocolString:(PROTOCOLSTRING)]; 
        if(![mtSCRALib isDeviceOpened])
        {
            [mtSCRALib openDevice];
        }
        
    }
    else if([mtSCRALib getDeviceType]==MAGTEKAUDIOREADER)
        
    {
        if(![mtSCRALib isDeviceOpened])
        {
            [mtSCRALib openDevice];
        }
        
    }
    
    [self devConnStatusChange];   
    
}
- (void) closeDevice
{
    if([mtSCRALib isDeviceOpened])
    {
        [mtSCRALib closeDevice];
    }
    [mtSCRALib clearBuffers];
    [self devConnStatusChange];   
    
}
- (void)devConnStatusChange
{
    BOOL isDeviceConnected = [self.mtSCRALib isDeviceConnected];
    BOOL isDeviceOpened = [self.mtSCRALib isDeviceOpened];
    if (isDeviceConnected)
    {
        
        self.deviceStatus.text = @"Device Connected";
        self.deviceStatus.backgroundColor = [UIColor orangeColor];
        if(isDeviceOpened)
        {
            self.deviceStatus.text = @"Device Ready";
            self.deviceStatus.backgroundColor = [UIColor greenColor];
        }
        else 
        {
            self.deviceStatus.text = @"Device Not Ready";
            self.deviceStatus.backgroundColor = [UIColor redColor];
            
        }
        
    }
    else
    {
        self.deviceStatus.text = @"Device Not Ready";
        self.deviceStatus.backgroundColor = [UIColor redColor];
        
        
    }
}
- (void)trackDataReady:(NSNotification *)notification
{
    NSNumber *status = [[notification userInfo] valueForKey:@"status"];
    
    [self performSelectorOnMainThread:@selector(onDataEvent:) withObject:status waitUntilDone:NO];
}

- (void)displayData
{
    if(mtSCRALib !=NULL)
    {
        if([mtSCRALib getDeviceType]==MAGTEKAUDIOREADER)
        {
            NSString * pResponse = [NSString stringWithFormat:@"Response.Type=%@\nTrack.Status=%@\nCard.Status=%@\nOperation.Status=%@\nBattery.Level=%d\nSwipe.Count=%d\nTrack.Masked: %@\nTrack1.Masked: %@\nTrack2.Masked: %@\nTrack1.Encrypted: %@\nTrack2.Encrypted: %@\nTrack3.Encrypted: %@\nCard.IIN: %@\nCard.Name: %@\nCard.Last4: %@\nCard.ExpDate: %@\nCard.SvcCode: %@\nCard.PANLength: %d\nKSN: %@\nDevice.SerialNumber: %@\nTLV.CARDIIN: %@\nMagTek SN: %@\nFirmware Part Number: %@\nTLV Version: %@\nDevice Model Name: %@\nCapability MSR: %@\nCapability Tracks: %@\nCapability Encryption: %@\nConfig.TLVVersion: %@\nConfig.Discovery: %@\nConfig.CardName: %@\nConfig.CardIIN: %@\nConfig.CardLast4: %@\nConfig.CardExpDate: %@\nConfig.CardSvcCode: %@\nConfig.CardPANLength:%@\n",
                                    
                                    [mtSCRALib getResponseType],
                                    [mtSCRALib getTrackDecodeStatus],
                                    [mtSCRALib getCardStatus],
                                    [mtSCRALib getOperationStatus],
                                    [mtSCRALib getBatteryLevel],
                                    [mtSCRALib getSwipeCount],
                                    [mtSCRALib getMaskedTracks],
                                    [mtSCRALib getTrack1Masked],
                                    [mtSCRALib getTrack2Masked],
                                    [mtSCRALib getTrack1],
                                    [mtSCRALib getTrack2],
                                    [mtSCRALib getTrack3],
                                    [mtSCRALib getCardIIN],
                                    [mtSCRALib getCardName],
                                    [mtSCRALib getCardLast4],
                                    [mtSCRALib getCardExpDate],
                                    [mtSCRALib getCardServiceCode],
                                    [mtSCRALib getCardPANLength],
                                    [mtSCRALib getKSN],
                                    [mtSCRALib getDeviceSerial],
                                    [mtSCRALib getTagValue:TLV_CARDIIN],
                                    [mtSCRALib getMagTekDeviceSerial],
                                    [mtSCRALib getFirmware],
                                    [mtSCRALib getTLVVersion],
                                    [mtSCRALib getDeviceName],
                                    [mtSCRALib getCapMSR],
                                    [mtSCRALib getCapTracks],
                                    [mtSCRALib getCapMagStripeEncryption],
                                    [mtSCRALib getTagValue:TLV_CFGTLVVERSION],
                                    [mtSCRALib getTagValue:TLV_CFGDISCOVERY],
                                    [mtSCRALib getTagValue:TLV_CFGCARDNAME],
                                    [mtSCRALib getTagValue:TLV_CFGCARDIIN],
                                    [mtSCRALib getTagValue:TLV_CFGCARDLAST4],
                                    [mtSCRALib getTagValue:TLV_CFGCARDEXPDATE],
                                    [mtSCRALib getTagValue:TLV_CFGCARDSVCCODE],
                                    [mtSCRALib getTagValue:TLV_CFGCARDPANLEN]];
            //self.responseData.text =pResponse;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:[mtSCRALib getResponseData] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Success" message:pResponse delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert1 show];
           // self.rawResponseData.text = [mtSCRALib getResponseData];
        }
        else
        {
            NSString * pResponse = [NSString stringWithFormat:@"Track.Status=%@\nTrack.Masked: %@\nTrack1.Masked: %@\nTrack2.Masked: %@\nTrack1.Encrypted: %@\nTrack2.Encrypted: %@\nTrack3.Encrypted: %@\nCard.IIN: %@\nCard.Name: %@\nCard.Last4: %@\nCard.ExpDate: %@\nCard.SvcCode: %@\nCard.PANLength: %d\nKSN: %@\nDevice.SerialNumber: %@\nMagnePrint: %@\nMagnePrintStatus: %@\nSessionID: %@\nDevice Model Name: %@\n",
                                    [mtSCRALib getTrackDecodeStatus],
                                    [mtSCRALib getMaskedTracks],
                                    [mtSCRALib getTrack1Masked],
                                    [mtSCRALib getTrack2Masked],
                                    [mtSCRALib getTrack1],
                                    [mtSCRALib getTrack2],
                                    [mtSCRALib getTrack3],
                                    [mtSCRALib getCardIIN],
                                    [mtSCRALib getCardName],
                                    [mtSCRALib getCardLast4],
                                    [mtSCRALib getCardExpDate],
                                    [mtSCRALib getCardServiceCode],
                                    [mtSCRALib getCardPANLength],
                                    [mtSCRALib getKSN],
                                    [mtSCRALib getDeviceSerial],
                                    [mtSCRALib getMagnePrint],
                                    [mtSCRALib getMagnePrintStatus],
                                    [mtSCRALib getSessionID],
                                    [mtSCRALib getDeviceName]];
           // self.responseData.text =pResponse;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:pResponse delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Success" message:[mtSCRALib getResponseData] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert1 show];
         //   self.rawResponseData.text = [mtSCRALib getResponseData];
            self.signatureViewController = nil;
            self.signatureViewController = [[SignatureViewController alloc] initWithNibName:@"SignatureViewController" bundle:[NSBundle mainBundle]];
            self.signatureViewController.delegate = self;
            self.signatureViewController.modalPresentationStyle = UIModalPresentationFormSheet;
            self.signatureViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:self.signatureViewController animated:YES];
            isSwipe = YES;
            track1 = [mtSCRALib getResponseData];
        }
        [mtSCRALib clearBuffers];
        
        
    }
    
}

#pragma mark  -
#pragma mark MSRAccessory

- (void)onDataEvent:(id)status
{
	switch ([status intValue]) {
        case TRANS_STATUS_OK:{
            
#ifdef _DGBPRNT        
            NSLog(@"TRANS_STATUS_OK");
#endif            
           // self.transStatus.text = @"Transfer Completed";
            NSLog(@"Transfer Completed");
           
            [self displayData];
            //[self closeDevice];
            //TODO: uncomment above line after testing
            break;
        }
        case TRANS_STATUS_START:{
            // This should be used with caution. CPU intensive
            // tasks done after this events and before TRANS_STATUS_OK
            // may interfere with reader communication
#ifdef _DGBPRNT        
            NSLog(@"TRANS_STATUS_START");
#endif            
//            self.transStatus.text = @"Transfer Started";
            
            break;
        } 
        case TRANS_STATUS_ERROR:{
            
            if(mtSCRALib !=NULL)
            {
#ifdef _DGBPRNT        
                NSLog(@"TRANS_STATUS_ERROR");
#endif            
                
//                self.transStatus.text = @"Transfer Error";
                self.deviceStatus.backgroundColor = [UIColor redColor];
                [self devConnStatusChange];        
            }
            
            
            break;
        }    
        default:
            break;
    }
    
    
}

- (IBAction) setIDynamoSwitch:(id)sender
{
   
#ifdef _DGBPRNT        
        NSLog(@"setIDynamoSwitch:ON Not Demo");
#endif        
   
        [mtSCRALib setDeviceType:MAGTEKIDYNAMO];
        [self openDevice];
 
}
#pragma - Signature View Controller Delegates Methods
- (void)signatureViewControllerDidFinish:(SignatureViewController *)controller{
    NSLog(@"signatureViewControllerDidFinish");
    self.signatureImage = [controller captureView:controller.view inSize:CGSizeMake(controller.view.frame.size.width, controller.view.frame.size.height)];
    [self beginTransaction];
    
    
}

- (void) deductAndUpdateView{
    NSString *tempString = [dancerPayTextField.text stringByReplacingOccurrencesOfString:@"$"
                                                          withString:@""];
    int dancerPaid = [tempString intValue];
    if (dancerPaid == 0) return;
    int totalAmount = [self.currentDancer.totalFee intValue];
    
    totalAmount -= dancerPaid;
    totalAmountLabel.text = [NSString stringWithFormat:@"$ %d", totalAmount];
    NSString *paidDetails = nil;
    paidDetails = [NSString stringWithFormat:@"   %d           Dancer Paid                                        -$%d", [self.dancesPaymentDetails count] +1,  dancerPaid];
    if (!self.currentDancer.dancerPaid) {
        self.currentDancer.dancerPaid = [[NSMutableArray alloc] init];
    }
    [(NSMutableArray*)self.currentDancer.dancerPaid addObject:[NSString stringWithFormat:@"%d",dancerPaid]];
    [self.dancesPaymentDetails addObject:paidDetails];
    [self.dancesPaymentTable reloadData];
    totalAmountLabel.text = [NSString stringWithFormat:@"$ %d", totalAmount];
    self.currentDancer.totalFee = [NSNumber numberWithInt:totalAmount];
    NSLog(@"Now the total is %d", totalAmount);
    [self saveDancers];
   // dancerPayTextField.text = @"";
}

#pragma mark -
#pragma mark STAR SDK functions

+(NSString*)getPortName
{
    return portName;
}

+(void)setPortName:(NSString *)m_portName
{
    if (portName != m_portName) {
        [portName release];
        portName = [m_portName copy];
    }    
}

+(NSString *)getPortSettings
{
    return portSettings;
}

+(void)setPortSettings:(NSString *)m_portSettings
{
    if (portSettings != m_portSettings) {
        [portSettings release];
        portSettings = [m_portSettings copy];
    }
}

-(void)SetPortInfo
{
    NSString *localPortName = [NSString stringWithString: printerAddress];
    [ViewController setPortName:localPortName];
    
    NSString *localPortSettings = printerPort;
    [ViewController setPortSettings:localPortSettings];
}
-(IBAction)OpenCashDrawer
{
    
    
    NSString *portName = printerAddress;
    NSString *portSettings = printerPort;
    [PrinterFunctions OpenCashDrawerWithPortname:portName portSettings:portSettings];

}
-(IBAction)GetStatus
{
    
    NSString *portName = printerAddress;
    NSString *portSettings = printerPort;
    [PrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings];
}

-(IBAction)TextRasterPrinting
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
   // [self SetPortInfo];
    rasterPrinting *rasterPrintingVar = [[rasterPrinting alloc] initWithNibName:@"rasterPrinting-iPad" bundle:[NSBundle mainBundle]];
    NSMutableString *tempString = [NSMutableString stringWithString:@""];
    if (isMasterPrint) {
        rasterPrintingVar.isMasterPrint = YES;
        for(Dancer *dancer in self.dancersArray){
            NSString *houseFee = dancer.houseFee;
            NSString *vipFee = [NSString stringWithFormat:@"%d",[dancer.dances intValue] * [dancer.pricePerDance intValue] ];
            
            NSString *couchFee = [NSString stringWithFormat:@"%d", [dancer.totalFee intValue] - ([houseFee intValue] + [vipFee intValue])];
            [tempString appendString:[NSString stringWithFormat:@"1.    %@                                                         %@                     %@              %@                %@ \n", dancer.dancerName, houseFee, vipFee, couchFee, dancer.totalFee]];
        }
    }
    else {
      //  NSMutableString *tempString = [NSMutableString stringWithString:@""];
        Dancer *dancer = self.currentDancer;
        NSString *houseFee = dancer.houseFee;
        NSString *vipFee = [NSString stringWithFormat:@"%d",[dancer.dances intValue] * [dancer.pricePerDance intValue] ];
        
        NSString *couchFee = [NSString stringWithFormat:@"%d", [dancer.totalFee intValue] - ([houseFee intValue] + [vipFee intValue])];
        [tempString appendString:[NSString stringWithFormat:@"1.    %@                                                         %@                     %@              %@                %@ \n", dancer.dancerName, houseFee, vipFee, couchFee, dancer.totalFee]];
    }
   /* for(NSString *string in self.dancesPaymentDetails)
    {
        [tempString appendString:string];
        [tempString appendString:@"\n"];
    }*/
    
   // [tempString appendString:[NSString stringWithFormat:@"1.    %@                                                         %@                     %@              %@                %@", self.currentDancer.dancerName, houseFee, vipFee, couchFee, self.totalAmountLabel.text]];
    
    
    rasterPrintingVar.signatureImage = self.signatureImage;
    rasterPrintingVar.uitextview_texttoprint.text = tempString;
    rasterPrintingVar.texttoprint = tempString;
    rasterPrintingVar.viewContoller = self;
    [self.navigationController pushViewController:rasterPrintingVar animated:YES];
    [self presentModalViewController:rasterPrintingVar animated:YES];
    [rasterPrintingVar release];
    isMasterPrint = NO;
}

+(NSString *)HTMLCSS
{
    NSString *cssDefninition = @"<html>\
    <head>\
    <style type=\"text/css\">\
    Code {color:blue;}\n\
    CodeDef {color:blue;font-weight:bold}\n\
    TitleBold {font-weight:bold}\n\
    It1 {font-style:italic; font-size:12}\n\
    LargeTitle{font-size:20px}\n\
    SectionHeader{font-size:17;font-weight:bold}\n\
    UnderlineTitle {text-decoration:underline}\n\
    div_cutParam {position:absolute; top:100; left:30; width:200px;font-style:italic;}\n\
    div_cutParam0 {position:absolute; top:130; left:30; font-style:italic;}\n\
    div_cutParam1 {position:absolute; top:145; left:30; font-style:italic;}\n\
    div_cutParam2 {position:absolute; top:160; left:30; font-style:italic;}\n\
    div_cutParam3 {position:absolute; top:175; left:30; font-style:italic;}\n\
    .div-tableBarcodeWidth{display:table;}\n\
    .div-table-rowBarcodeWidth{display:table-row;}\n\
    .div-table-colBarcodeWidthHeader{display:table-cell;border:1px solid #000000;background: #800000;color:#ffffff}\n\
    .div-table-colBarcodeWidthHeader2{display:table-cell;border:1px solid #000000;background: #800000;color:#ffffff}\n\
    .div-table-colBarcodeWidth{display:table-cell;border:1px solid #000000;}\n\
    rightMov {position:absolute; left:30px; font-style:italic;}\n\
    rightMov_NOI {position:absolute; left:55px;}\n\
    rightMov_NOI2 {position:absolute; left:90px;}\n\
    StandardItalic {font-style:italic}\
    .div-tableCut{display:table;}\n\
    .div-table-rowCut{display:table-row;}\n\
    .div-table-colFirstCut{display:table-cell;width:40px}\n\
    .div-table-colCut{display:table-cell;}\n\
    .div-table-colRaster{display:table-cell; border:1px solid #000000;}\n\
    </style>\
    </head>";
    return cssDefninition;
}
@end
