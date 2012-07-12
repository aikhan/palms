//
//  PDF417.h
//  IOS_SDK
//
//  Created by Tzvi on 8/15/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerPopup.h"

@interface PDF417 : UIViewController <UITextFieldDelegate> {
    IBOutlet UIScrollView *uiscrollview_main;
    IBOutlet UIImageView *uiimageview_pdf417;
    IBOutlet UITableView *uitableview_barcodeSize;
    IBOutlet UITextField *uitextfield_height;
    IBOutlet UITextField *uitextfield_width;
    IBOutlet UITableView *uitableview_aspectratio;
    IBOutlet UITableView *uitableview_xdirection;
    IBOutlet UITableView *uitableview_securitylevel;
    IBOutlet UITextField *uitextfield_barcodedata;
    
    PickerPopup *pickerPopup_barcodeSize;
    PickerPopup *pickerPopup_aspectratio;
    PickerPopup *pickerPopup_xdirection;
    PickerPopup *pickerPopup_securitylevel;
    
    NSMutableArray *array_barcodeSize;
    NSMutableArray *array_apectratio;
    NSMutableArray *array_xdirection;
    NSMutableArray *array_securitylevel;
    
    IBOutlet UILabel *uilabel_height;
    IBOutlet UILabel *uilabel_width;
}

-(void)ResetTableView:(id)sender;
-(IBAction)backPDF417;
-(IBAction)printBarcode;
-(IBAction)showHelp;

@end
