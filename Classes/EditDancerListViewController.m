//
//  EditDancerListViewController.m
//  Palms
//
//  Created by Saleh Shah on 5/14/12.
//  Copyright (c) 2012 Semantic Notion. All rights reserved.
//

#import "EditDancerListViewController.h"
#import "Dancer.h"
#import "MagTekDemoAppDelegate.h"
#import "AddDancerViewController.h"
@implementation EditDancerListViewController

@synthesize dancersArray,dancersTable, myToolBar, selectedDancersArray;

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
    // Do any additional setup after loading the view from its nib.
    
    MagTekDemoAppDelegate * appDelegate = (MagTekDemoAppDelegate*) [UIApplication sharedApplication].delegate;
    [self setContentSizeForViewInPopover:CGSizeMake(320, 480)];
    self.selectedDancersArray = appDelegate.selectedDancersArray;
    self.dancersArray = appDelegate.dancersArray;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Add Dancer"                                            
                                   style:UIBarButtonItemStyleBordered 
                                   target:self 
                                   action:@selector(addDancerButtonTapped:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
   // self.myToolBar.frame = CGRectMake(0, -20, 320, 44);
   // self.navigationController.navigationBarHidden = YES;
    [self.dancersTable reloadData];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dancersArray count];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"yes");
    
    MagTekDemoAppDelegate * appDelegate = (MagTekDemoAppDelegate*) [UIApplication sharedApplication].delegate;
    
    [appDelegate.dancersArray removeObjectAtIndex:indexPath.row];
    
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <[appDelegate.dancersArray count] ; i++) {
        
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[appDelegate.dancersArray objectAtIndex:i]];
        [tempArray addObject:myEncodedObject];
    }
    
    NSArray * dancers = [NSArray arrayWithArray:tempArray];
    [[NSUserDefaults standardUserDefaults] setObject:dancers forKey:@"DancersArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.dancersArray = appDelegate.dancersArray;
    
    [tableView reloadData];
}


- (IBAction)addDancerButtonTapped:(id)sender{
    AddDancerViewController *addDancerVC = [[AddDancerViewController alloc] init];
   // [self presentModalViewController:addDancerVC animated:YES];
    [self.navigationController pushViewController:addDancerVC animated:YES];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (IBAction)removeDancerButtonTapped:(id)sender{
    
}

@end
