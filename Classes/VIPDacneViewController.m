//
//  VIPDacneViewController.m
//  Palms
//
//  Created by Asad Khan on 5/21/12.
//  Copyright (c) 2012 Semantic Notion. All rights reserved.
//

#import "VIPDacneViewController.h"

@interface VIPDacneViewController ()

@end

@implementation VIPDacneViewController
@synthesize myTableView, dataArray, selectedRow, parentController, tagNumber, dancesPaymentArray, danceSelectedRow, currentDancer, vipRateArray, vipSelectedRow;
NSArray *myVoucherValuesArray;
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
    selectedRow = 0;
    danceSelectedRow = 0;
    vipSelectedRow = 0;
    myVoucherValuesArray = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"15", @"20", nil];
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"5", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55", @"60", @"65", @"70", @"75", @"80", @"85", @"90", @"95", @"100", nil];
    self.vipRateArray = [[NSMutableArray alloc] initWithObjects:@"0", @"2", @"3", @"5", nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // selectedRow = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tagNumber == 102) {
        NSLog(@"dance array count %d", [self.dancesPaymentArray count]);
        return [self.dancesPaymentArray count];
    }else if (tagNumber == 101){
        NSLog(@"data array count %d", [self.dataArray count]);
        return [self.dataArray count];
    }else if (tagNumber == 200){
        NSLog(@"data array count %d", [myVoucherValuesArray count]);
        return [myVoucherValuesArray count];
    }
    else {
        return [self.vipRateArray count];
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    if (tagNumber == 102) {
        cell.textLabel.text = [self.dancesPaymentArray objectAtIndex:indexPath.row];
        if (indexPath.row == danceSelectedRow) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }else if (tagNumber == 100) {
        cell.textLabel.text = [self.vipRateArray objectAtIndex:indexPath.row];
        if (indexPath.row == vipSelectedRow) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    else if (tagNumber == 200) {
        cell.textLabel.text = [myVoucherValuesArray objectAtIndex:indexPath.row];
//        if (indexPath.row == vipSelectedRow) {
//            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//        }
//        else
//        {
//            [cell setAccessoryType:UITableViewCellAccessoryNone];
//        }
    }
    else if(tagNumber == 101){
        cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        if (indexPath.row == selectedRow) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    
  //  NSLog(@"%@", [self.dataArray objectAtIndex:indexPath.row]);
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.tagNumber == 200) {
        self.parentController.labelAmountAboveCC.text = [NSString stringWithFormat:@"$ %d", [[myVoucherValuesArray objectAtIndex:indexPath.row] intValue] * 25];
        [self.parentController.vipPopOverController dismissPopoverAnimated:YES];
        [self.parentController.buttonAmountAboveCC setTitle:[NSString stringWithFormat:@"%d", indexPath.row + 1] forState:UIControlStateNormal];
        [self.parentController.buttonAmountAboveCC setBackgroundImage:[UIImage imageNamed:@"btn_amount_empty"] forState:UIControlStateNormal];
        return;
    }
    if (self.currentDancer == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select the dancer from left hand side first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    selectedRow = indexPath.row;
    
    [myTableView reloadData];
    [parentController.vipPopOverController dismissPopoverAnimated:YES];
    if (self.tagNumber == 100) {
        [parentController.vipDanceButton setTitle:[self.vipRateArray objectAtIndex:indexPath.row]  forState:UIControlStateNormal];
         self.currentDancer.pricePerDance = [self.vipRateArray objectAtIndex:indexPath.row];
        NSLog(@"self.currentDancer.pricePerDance = %@", self.currentDancer.pricePerDance);
       // [self.currentDancer.minsPerPrice addObject:[self.dataArray objectAtIndex:indexPath.row]];
        vipSelectedRow  = indexPath.row;
    }
    if (self.tagNumber == 101) {
        [parentController.houseFeeButton setTitle:[self.dataArray objectAtIndex:indexPath.row]  forState:UIControlStateNormal];
        self.currentDancer.houseFee = [self.dataArray objectAtIndex:indexPath.row];
        //[self.currentDancer.minsPerPrice addObject:[self.dataArray objectAtIndex:indexPath.row]];
        NSLog(@"self.currentDancer.houseFee = %@", self.currentDancer.houseFee);
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:MM"];
        NSDate *today = [NSDate date];
        NSString * todaysDate = [dateFormat stringFromDate:today];
        self.parentController.houseFeeLabel.text = [NSString stringWithFormat:@"Arrival %@", todaysDate];
    }
    if (self.tagNumber == 102) {
        [parentController.minsPerPriceButton setTitle:[self.dancesPaymentArray objectAtIndex:indexPath.row]  forState:UIControlStateNormal];
        danceSelectedRow = indexPath.row;
        if(!self.currentDancer.minsPerPrice){
            self.currentDancer.minsPerPrice = [[NSMutableArray alloc] init];
        }
        [self.currentDancer.minsPerPrice addObject:[self.dancesPaymentArray objectAtIndex:indexPath.row]];
        NSLog(@"self.currentDancer.minsPerPrice = %@", [self.currentDancer.minsPerPrice lastObject]);
    }
    
   // [self.parentController dismissPicker];
    [self.parentController saveDancers];
    [self.parentController calculatePaymentDetails];
    
}

@end
