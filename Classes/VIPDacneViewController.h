//
//  VIPDacneViewController.h
//  Palms
//
//  Created by Asad Khan on 5/21/12.
//  Copyright (c) 2012 Semantic Notion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface VIPDacneViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) IBOutlet UITableView *myTableView;
@property(nonatomic, retain) NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger selectedRow;
@property(nonatomic, assign) NSInteger vipSelectedRow;
@property(nonatomic, assign) NSInteger danceSelectedRow;
@property(nonatomic,retain) ViewController * parentController;
@property(nonatomic, assign) NSInteger tagNumber;
@property(nonatomic, retain) NSMutableArray *dancesPaymentArray;
@property(nonatomic, retain) NSMutableArray *vipRateArray;
@property(nonatomic, retain) Dancer *currentDancer;
@end
