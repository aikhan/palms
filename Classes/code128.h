//
//  code128.h
//  IOS_SDK
//
//  Created by Tzvi on 8/8/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerPopup.h"


@interface code128 : UIViewController <UITextFieldDelegate>{
    IBOutlet UIScrollView *uiscrollview_main;
    IBOutlet UITextField *uitextfield_barcodeData;
    IBOutlet UITextField *uitextfield_height;
    IBOutlet UITableView *uitableview_min_mod_dots;
    IBOutlet UITableView *uitableview_layout;
    IBOutlet UIImageView *uiimageview_code128;
    
    PickerPopup *min_Mod_Dots_PickerPopup;
    PickerPopup *layoutPickerPopup;
    NSMutableArray *min_Mod_dotsArray;
    NSMutableArray *layoutArray;
    
}

-(void)ResetTableView: (id)sender;
-(IBAction)backCode128;
-(IBAction)printBarcode128;
-(IBAction)showHelp;

@end
