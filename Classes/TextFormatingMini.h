//
//  TextFormatingMini.h
//  IOS_SDK
//
//  Created by Tzvi on 8/25/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerPopup.h"


@interface TextFormatingMini : UIViewController <UITextFieldDelegate,UITextViewDelegate>{
    IBOutlet UISwitch *uiswitch_underline;
    IBOutlet UISwitch *uiswitch_emphasized;
    IBOutlet UISwitch *uiswitch_upsizeddown;
    IBOutlet UISwitch *uiswitch_invertcolor;
    IBOutlet UITableView *uitableview_height;
    IBOutlet UITableView *uitableview_width;
    IBOutlet UITextField *uitextfield_leftMargin;
    IBOutlet UITableView *uitableview_alignment;
    IBOutlet UITextView *uitextview_texttoprint;
    IBOutlet UIScrollView *uiscrollview_main;
    IBOutlet UIView *uiview_main;
    
    PickerPopup *pickerpopup_height;
    PickerPopup *pickerpopup_width;
    PickerPopup *pickerpopup_alignment;
    
    NSMutableArray *array_height;
    NSMutableArray *array_width;
    NSMutableArray *array_alignment;
}

-(void)ResetTableData:(id)sender;
-(IBAction)backTextFormating;
-(IBAction)printTextFormating;

@end
