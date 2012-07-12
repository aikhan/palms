//
//  AddDancerListViewController.m
//  Palms
//
//  Created by Asad Khan on 6/25/12.
//  Copyright (c) 2012 Semantic Notion Inc. All rights reserved.
//

#import "AddDancerListViewController.h"
#import "MagTekDemoAppDelegate.h"
#import "Dancer.h"
#import "ViewController.h"

@interface AddDancerListViewController ()

@end

@implementation AddDancerListViewController
@synthesize dancersArray, selectedDancersArray, parentVC;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.dancersArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    MagTekDemoAppDelegate * appDelegate = (MagTekDemoAppDelegate*) [UIApplication sharedApplication].delegate;
    [self setContentSizeForViewInPopover:CGSizeMake(320, 480)];
    self.dancersArray = appDelegate.dancersArray;
    self.selectedDancersArray = appDelegate.selectedDancersArray;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.dancersArray count];
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
    
    
    
    UIImageView * cellBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 316, 36)];
    cellBG.image = [UIImage imageNamed:@"bg_dancer_cell.png"];
    cell.backgroundView = (UIView*) cellBG;
    
    Dancer * dancer = [self.dancersArray objectAtIndex:indexPath.row];
    
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 270, 20)];
    nameLabel.textColor = [UIColor colorWithRed:106.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = UITextAlignmentLeft;
    
    
    nameLabel.text = [NSString stringWithFormat:@"%@",dancer.dancerName];
    
    [cell addSubview:nameLabel];
    
    return cell;

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.selectedDancersArray addObject:[self.dancersArray objectAtIndex:indexPath.row]];
    MagTekDemoAppDelegate * appDelegate = (MagTekDemoAppDelegate*) [UIApplication sharedApplication].delegate;
    appDelegate.selectedDancersArray = self.selectedDancersArray;
   /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Dancer has been added successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [alert show];
    [alert release];
    */
   // [self.parentVC.addDancerPopoverController dismissPopoverAnimated:YES];
    [self.parentVC dismissAddDancerPopover];
}

@end
