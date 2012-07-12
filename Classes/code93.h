//
//  code93.h
//  IOS_SDK
//
//  Created by Tzvi on 8/5/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerPopup.h"


@interface code93 : UIViewController <UITextFieldDelegate>{
    IBOutlet UIImageView *uiimageview_code93;
    IBOutlet UITableView *uitableview_min_mod_dots;
    IBOutlet UITableView *uitableview_layout;
    IBOutlet UITextField *uitextfield_barcodeData;
    IBOutlet UITextField *uitextfield_height;
    IBOutlet UIScrollView *uiscrollview_main;
    
    PickerPopup *min_Mod_Dots_PickerPopup;
    PickerPopup *layoutPickerPopup;
    NSMutableArray *min_Mod_dotsArray;
    NSMutableArray *layoutArray;
}

-(void)DismissActionSheet: (id) unusedID;
-(IBAction)printBarCode;
-(IBAction)backCode93;
-(IBAction)showHelp;

@end
