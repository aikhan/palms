//
//  EditDancerListViewController.h
//  Palms
//
//  Created by Saleh Shah on 5/14/12.
//  Copyright (c) 2012 Semantic Notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditDancerListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UITableView * dancersTable;
    NSArray * dancersArray;
}

@property(nonatomic,retain) IBOutlet UITableView * dancersTable;
@property(nonatomic,retain) NSArray * dancersArray;
@property(nonatomic,retain) NSMutableArray * selectedDancersArray;
@property(nonatomic,retain) IBOutlet UIToolbar *myToolBar;

- (IBAction)addDancerButtonTapped:(id)sender;
- (IBAction)removeDancerButtonTapped:(id)sender;
@end
