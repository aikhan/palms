//
//  QRCode.h
//  IOS_SDK
//
//  Created by Tzvi on 8/9/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerPopup.h"


@interface QRCode : UIViewController <UITextFieldDelegate>{
    IBOutlet UIImageView *uiimageview_qrcode;
    IBOutlet UIScrollView *uiscrollview_main;
    IBOutlet UITableView *uitableview_corectionLevel;
    IBOutlet UITableView *uitableview_model;
    IBOutlet UITableView *uitableview_cellSize;
    IBOutlet UITextField *uitextfield_barcodeData;
    
    PickerPopup *pickerPopup_correctionLevel;
    PickerPopup *pickerPopup_model;
    PickerPopup *pickerPopup_cellSize;
    NSMutableArray *array_correctionLevel;
    NSMutableArray *array_model;
    NSMutableArray *array_cellSize;
}

-(void)ResetTableView:(id)sender;
-(IBAction)backQrcode;
-(IBAction)printQrcode;
-(IBAction)showHelp;

@end
