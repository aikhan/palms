//
//  code93.m
//  IOS_SDK
//
//  Created by Tzvi on 8/5/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "code93.h"
#import <QuartzCore/QuartzCore.h>

#import "StandardHelp.h"
#import "ViewController.h"

@implementation code93

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        min_Mod_dotsArray = [[NSMutableArray alloc]init];
        [min_Mod_dotsArray addObject:@"2 dots"];
        [min_Mod_dotsArray addObject:@"3 dots"];
        [min_Mod_dotsArray addObject:@"4 dots"];
        
        layoutArray = [[NSMutableArray alloc] init];
        [layoutArray addObject:@"No under-bar char + line feed"];
        [layoutArray addObject:@"Add under-bar char + line feed"];
        [layoutArray addObject:@"No under-bar char + no line feed"];
        [layoutArray addObject:@"Add under-bar char + no line feed"];
    }
    return self;
}

- (void)dealloc
{
    [min_Mod_dotsArray release];
    [layoutArray release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"code39.gif"];
    [uiimageview_code93 setImage:image];
    
    min_Mod_Dots_PickerPopup = [[PickerPopup alloc] init];
    [min_Mod_Dots_PickerPopup setDataSource:min_Mod_dotsArray];
    [min_Mod_Dots_PickerPopup setListener:@selector(DismissActionSheet:) :self];
    
    [uitableview_min_mod_dots setDataSource:min_Mod_Dots_PickerPopup];
    [uitableview_min_mod_dots setDelegate:min_Mod_Dots_PickerPopup];
    uitableview_min_mod_dots.layer.borderWidth = 1;
    
    layoutPickerPopup = [[PickerPopup alloc] init];
    [layoutPickerPopup setDataSource:layoutArray];
    [layoutPickerPopup setListener:@selector(DismissActionSheet:) :self];
    
    [uitableview_layout setDataSource:layoutPickerPopup];
    [uitableview_layout setDelegate:layoutPickerPopup];
    uitableview_layout.layer.borderWidth = 1;
    
    uiscrollview_main.contentSize = CGSizeMake(320, 460);
    
    [uitextfield_barcodeData setDelegate:self];
    [uitextfield_height setDelegate:self];
}

- (void)viewDidUnload
{
    [min_Mod_Dots_PickerPopup release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)DismissActionSheet: (id) unusedID
{
    [uitableview_min_mod_dots reloadData];
    [uitableview_layout reloadData];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 280)];
    [uiscrollview_main setScrollEnabled:true];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{   
    if([string isEqualToString:@"\n"] == true)
    {
        [uitextfield_barcodeData resignFirstResponder];
        [uitextfield_height resignFirstResponder];
        [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 460)];
        [uiscrollview_main setScrollEnabled:false];
        return NO;
    }
    
    if(uitextfield_barcodeData == textField)
    {
        return YES;
    }
    
    if([string length] == 0)
    {
        return YES;
    }
    
    int digit = [string characterAtIndex:0];
    if((digit >= '0') && (digit <= '9'))
    {
        return YES;
    }
    
    return NO;
}

-(IBAction)printBarCode
{
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    
    NSString *barcodeDataString = uitextfield_barcodeData.text;
    NSData *data = [barcodeDataString dataUsingEncoding:NSWindowsCP1252StringEncoding];
    
    BarCodeOptions barcodeOption = [layoutPickerPopup getSelectedIndex];
    
    NSString *barcodeHeightString = uitextfield_height.text;
    unsigned int height = [barcodeHeightString intValue];
    
    Min_Mod_Size width = [min_Mod_Dots_PickerPopup getSelectedIndex];
    
    unsigned char *barcodeData = (unsigned char*)malloc([data length]);
    [data getBytes:barcodeData];
    
    [PrinterFunctions PrintCode93WithPortname:portName portSettings:portSettings barcodeData:barcodeData barcodeDataSize:[data length] barcodeOption:barcodeOption height:height min_module_dots:width];

    free(barcodeData);
}

-(IBAction)backCode93
{
    [self dismissModalViewControllerAnimated:true];
}

-(IBAction)showHelp
{
    NSString *title = @"Code 93 Barcode";
    NSString *helpText = [ViewController HTMLCSS];
    helpText = [helpText stringByAppendingString:@"<Body>\
                <Code>Ascii:</Code> <CodeDef>ESC b BEL <StandardItalic>n2 n3 n4 d1 ... dk</StandardItalic> RS</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 62 04 <StandardItalic>n2 n3 n4 d1 ... dk</StandardItalic> 1E</CodeDef><br/><br/>\
                <TitleBold>Code 93</TitleBold> can represent 0-9 & A-Z with its base spec but also can be extended \
                using shift codes to represent the entire ASCII set.\
                </body></html>"];
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:helpVar animated:YES];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

@end
