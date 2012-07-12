//
//  TextFormating.h
//  IOS_SDK
//
//  Created by Koji on 12/08/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerPopup.h"


@interface JpKnjFormating : UIViewController  <UITextViewDelegate, UITextFieldDelegate> {
    IBOutlet UIView *uiview_main;
    IBOutlet UIScrollView *uiscrollview_main;
	IBOutlet UISegmentedControl *uisegment_kanjiMode;
//    IBOutlet UISwitch *uiswitch_slashedZero;
    IBOutlet UISwitch *uiswitch_underline;
    IBOutlet UISwitch *uiswitch_invertcolor;
    IBOutlet UISwitch *uiswitch_emphasized;
    IBOutlet UISwitch *uiswitch_upperline;
    IBOutlet UISwitch *uiswitch_upsizeDown;
    IBOutlet UITableView *uitableview_heightExpansion;
    IBOutlet UITableView *uitableview_widthExpansion;
    IBOutlet UITextField *uitextfield_leftMargin;
    IBOutlet UITableView *uitableview_alignment;
    IBOutlet UITextView *uitextview_texttoprint;
    
    PickerPopup *pickerpopup_heightExpansion;
    PickerPopup *pickerpopup_widthExpansion;
    PickerPopup *pickerpopup_alignment;
    
    NSMutableArray *array_hieghtExpansion;
    NSMutableArray *array_widthExpansion;
    NSMutableArray *array_alignment;
}

-(void)ResetTableView:(id)sender;
-(IBAction)backTextFormating;
-(IBAction)PrintText;
-(IBAction)showHelp;

@end
