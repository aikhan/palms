//
//  SettingsViewController.h
//  Palms
//
//  Created by Asad Khan on 5/17/12.
//  Copyright (c) 2012 Semantic Notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController


@property (nonatomic, retain) IBOutlet UITextField *portNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *portNumberTextField;
@property (nonatomic, retain) IBOutlet UISwitch *portablePrinterSwitch;

- (IBAction)backTapped:(id)sender;
@end
