//
//  QDF417mini.h
//  IOS_SDK
//
//  Created by Tzvi on 8/24/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerPopup.h"


@interface PDF417mini : UIViewController <UITextFieldDelegate>{
    IBOutlet UITableView *uitableview_width;
    IBOutlet UITableView *uitableview_columnNumber;
    IBOutlet UITableView *uitableview_securityLevel;
    IBOutlet UITableView *uitableview_Ratio;
    IBOutlet UITextField *uitextfield_PDF427Data;
    IBOutlet UIScrollView *uiscrollview_main;
    
    NSMutableArray *array_width;
    NSMutableArray *array_columnNumber;
    NSMutableArray *array_securityLevel;
    NSMutableArray *array_ratio;
    
    PickerPopup *pickerpopup_width;
    PickerPopup *pickerpopup_columnNumber;
    PickerPopup *pickerpopup_securityLevel;
    PickerPopup *pickerpopup_ratio;
}

-(void)ResetTableData:(id)sender;
-(IBAction)backPDF417;
-(IBAction)showHelp;
-(IBAction)printPDF417;

@end
