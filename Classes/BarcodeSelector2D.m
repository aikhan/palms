//
//  BarcodeSelector2D.m
//  IOS_SDK
//
//  Created by Tzvi on 8/9/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "BarcodeSelector2D.h"
#import "QRCode.h"
#import "PDF417.h"

#import "QRCodeMini.h"
#import "PDF417mini.h"
#import "ViewController.h"


@implementation BarcodeSelector2D

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        options = [[NSMutableArray alloc] init];
        [options addObject:@"Back"];
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        options = [[NSMutableArray alloc] init];
        [options addObject:@"Back"];
        [options addObject:@"Qrcode"];
        [options addObject:@"PDF417"];
    }
    [self retain];
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return [options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        int index = indexPath.row;
        [cell.textLabel setText: [options objectAtIndex:index]];
    }
    
    // Configure the cell...
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *portSettings = [ViewController getPortSettings];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0)
    {
        [self dismissModalViewControllerAnimated:true];
        [options release];
    }
    else if(indexPath.row == 1)
    {
        if([portSettings compare:@"mini" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            QRCodeMini *QRcodevar = [[QRCodeMini alloc]initWithNibName:@"QRCodeMini" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:QRcodevar animated:YES];
            [self presentModalViewController:QRcodevar animated:YES];
            [QRcodevar release];
        }
        else
        {
            QRCode *QRCodevar = [[QRCode alloc] initWithNibName:@"QRCode" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:QRCodevar animated:YES];
            [self presentModalViewController:QRCodevar animated:YES];
            [QRCodevar release];
        }
    }
    else if(indexPath.row == 2)
    {
        if([portSettings compare:@"mini" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            PDF417mini *PDF417var = [[PDF417mini alloc] initWithNibName:@"PDF417mini" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:PDF417var animated:YES];
            [self presentModalViewController:PDF417var animated:YES];
            [PDF417var release];
        }
        else
        {
            PDF417 *PDF417var = [[PDF417 alloc] initWithNibName:@"PDF417" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:PDF417var animated:YES];
            [self presentModalViewController:PDF417var animated:YES];
            [PDF417var release];
        }
    }
    /*else if(indexPath.row == 2)
    {
        code93 *code93var = [[code93 alloc] initWithNibName:@"code93" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:code93var animated:YES];
        [self presentModalViewController:code93var animated:YES];
        [code93var release];
    }
    else if(indexPath.row == 3)
    {
        ITF *itfvar = [[ITF alloc] initWithNibName:@"ITF" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:itfvar animated:YES];
        [self presentModalViewController:itfvar animated:YES];
        [itfvar release];
    }
    else if(indexPath.row == 4)
    {
        code128 *code128var = [[code128 alloc] initWithNibName:@"code128" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:code128var animated:YES];
        [self presentModalViewController:code128var animated:YES];
        [code128var release];
    }*/
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
