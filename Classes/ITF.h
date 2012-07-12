//
//  ITF.h
//  IOS_SDK
//
//  Created by Tzvi on 8/5/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerPopup.h"

@interface ITF : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *uitextfield_barcodedata;
    IBOutlet UITextField *uitextfield_height;
    IBOutlet UIImageView *uiimagefield_barcode;
    IBOutlet UITableView *uitableview_width;
    IBOutlet UITableView *uitableview_layout;
    IBOutlet UIScrollView *uiscrollview_main;
    
    PickerPopup *narrowWidePicker;
    PickerPopup *layoutPicker;
    NSMutableArray *narrowWideArray;
    NSMutableArray *layoutArray;
}

-(void)ResetTableView: (id)sender;
-(IBAction)backITF;
-(IBAction)printBarcodeITF;
-(IBAction)showHelp;

@end
