//
//  QRCodeMini.h
//  IOS_SDK
//
//  Created by Tzvi on 8/23/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerPopup.h"


@interface QRCodeMini : UIViewController <UITextFieldDelegate> {
    IBOutlet UITableView *uitableview_correctionLevel;
    IBOutlet UITableView *uitableview_codeSize;
    IBOutlet UITableView *uitableview_modelSize;
    IBOutlet UITextField *uitextfield_qrcodeData;
    IBOutlet UIScrollView *uiscrollview_main;
    
    PickerPopup *pickerpopup_correctionLevel;
    PickerPopup *pickerpopup_codeSize;
    PickerPopup *pickerpopup_modelSize;
    
    NSMutableArray *array_correctionLevel;
    NSMutableArray *array_codeSize;
    NSMutableArray *array_modelSize;
}

-(void)ResetTableData:(id)sender;
-(void)ResetTableDataQrcodeSize:(id)sender;
-(void)LoadQrcodeSizeL;
-(void)LoadQrcodeSizeM;
-(void)LoadQrcodeSizeQ;
-(void)LoadQrcodeSizeH;
-(IBAction)backQRCode;
-(IBAction)showHelp;
-(IBAction)printQRCode;

@end
