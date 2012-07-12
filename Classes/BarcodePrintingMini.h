//
//  BarcodePrintingMini.h
//  IOS_SDK
//
//  Created by Tzvi on 8/23/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerPopup.h"


@interface BarcodePrintingMini : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *uitextfield_height;
    IBOutlet UITableView *uitableview_width;
    IBOutlet UITableView *uitableview_barcode_type;
    IBOutlet UITextField *uitextfield_barcodeData;
    IBOutlet UIScrollView *uiscrollview_main;
    
    PickerPopup *pickerpopup_width;
    PickerPopup *pickerpopup_barcode_type;
    
    NSMutableArray *array_width;
    NSMutableArray *array_barcodeType;
}

-(void)ResetTableView:(id)sender;
-(IBAction)backBarcodeMini;
-(IBAction)showHelp;
-(IBAction)printBarcode;

@end
