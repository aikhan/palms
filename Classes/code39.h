//
//  code39.h
//  IOS_SDK
//
//  Created by Tzvi on 8/2/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerPopup.h"


@interface code39 : UIViewController <UITextFieldDelegate>{
    IBOutlet UIImageView *uiimageview_code39;
    IBOutlet UITableView *uitableview_NarrowWide;
    IBOutlet UITableView *uitableview_Layout;
    IBOutlet UITextField *uitextfield_BarcodeData;
    IBOutlet UITextField *uitextfield_Height;
    IBOutlet UIScrollView *uiscrollview_Main;
    
    PickerPopup *narrowWidthPicker;
    PickerPopup *layoutPicker;
    NSMutableArray *narrowWideArray;
    NSMutableArray *layoutArray;
}

-(void)DismissActionSheet: (id) unusedID;
-(IBAction)printBarCode;
-(IBAction)backCode39;
-(IBAction)showHelp;

@end
