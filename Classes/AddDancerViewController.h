//
//  AddDancerViewController.h
//  Palms
//
//  Created by Saleh Shah on 5/11/12.
//  Copyright (c) 2012 Semantic Notion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AddDancerViewController : UIViewController <UITextFieldDelegate> {
    
    IBOutlet UITextField * dancerField;
    ViewController * parentController;
    
}

@property(nonatomic,retain) IBOutlet UITextField * dancerField;
@property(nonatomic,retain) ViewController * parentController;

-(IBAction)addDancerButtonPressed:(id)sender;

@end
