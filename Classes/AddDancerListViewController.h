//
//  AddDancerListViewController.h
//  Palms
//
//  Created by Asad Khan on 6/25/12.
//  Copyright (c) 2012 Semantic Notion Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;


@interface AddDancerListViewController : UITableViewController


@property(nonatomic, strong) NSMutableArray *dancersArray;
@property(nonatomic,retain) NSMutableArray * selectedDancersArray;
@property(nonatomic,retain) ViewController * parentVC;
@end
