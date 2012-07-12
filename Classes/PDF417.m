//
//  PDF417.m
//  IOS_SDK
//
//  Created by Tzvi on 8/15/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "PDF417.h"
#import <QuartzCore/QuartzCore.h>

#import "StandardHelp.h"
#import "ViewController.h"


@implementation PDF417

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        array_barcodeSize = [[NSMutableArray alloc] init];
        [array_barcodeSize addObject:@"Use Limits"];
        [array_barcodeSize addObject:@"Use Fixed"];
        
        array_apectratio = [[NSMutableArray alloc] init];
        [array_apectratio addObject:@"1"];
        [array_apectratio addObject:@"2"];
        [array_apectratio addObject:@"3"];
        [array_apectratio addObject:@"4"];
        [array_apectratio addObject:@"5"];
        [array_apectratio addObject:@"6"];
        [array_apectratio addObject:@"7"];
        [array_apectratio addObject:@"8"];
        [array_apectratio addObject:@"9"];
        [array_apectratio addObject:@"10"];
        
        array_xdirection = [[NSMutableArray alloc] init];
        [array_xdirection addObject:@"1"];
        [array_xdirection addObject:@"2"];
        [array_xdirection addObject:@"3"];
        [array_xdirection addObject:@"4"];
        [array_xdirection addObject:@"5"];
        [array_xdirection addObject:@"6"];
        [array_xdirection addObject:@"7"];
        [array_xdirection addObject:@"8"];
        [array_xdirection addObject:@"9"];
        [array_xdirection addObject:@"10"];
        
        array_securitylevel = [[NSMutableArray alloc] init];
        [array_securitylevel addObject:@"0"];
        [array_securitylevel addObject:@"1"];
        [array_securitylevel addObject:@"2"];
        [array_securitylevel addObject:@"3"];
        [array_securitylevel addObject:@"4"];
        [array_securitylevel addObject:@"5"];
        [array_securitylevel addObject:@"6"];
        [array_securitylevel addObject:@"7"];
        [array_securitylevel addObject:@"8"];
    }
    return self;
}

- (void)dealloc
{
    [array_barcodeSize release];
    [array_apectratio release];
    [array_xdirection release];
    [array_securitylevel release];
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
    
    UIImage *uiimagepdf417 = [UIImage imageNamed:@"pdf417.gif"];
    [uiimageview_pdf417 setImage:uiimagepdf417];
    
    pickerPopup_barcodeSize = [[PickerPopup alloc]init];
    [pickerPopup_barcodeSize setDataSource:array_barcodeSize];
    [pickerPopup_barcodeSize setListener:@selector(ResetTableView:) :self];
    [uitableview_barcodeSize setDataSource:pickerPopup_barcodeSize];
    [uitableview_barcodeSize setDelegate:pickerPopup_barcodeSize];
    uitableview_barcodeSize.layer.borderWidth = 1;
    
    pickerPopup_aspectratio = [[PickerPopup alloc] init];
    [pickerPopup_aspectratio setDataSource:array_apectratio];
    [pickerPopup_aspectratio setListener:@selector(ResetTableView:) :self];
    [uitableview_aspectratio setDataSource:pickerPopup_aspectratio];
    [uitableview_aspectratio setDelegate:pickerPopup_aspectratio];
    uitableview_aspectratio.layer.borderWidth = 1;
    
    pickerPopup_xdirection = [[PickerPopup alloc]init];
    [pickerPopup_xdirection setDataSource:array_xdirection];
    [pickerPopup_xdirection setListener:@selector(ResetTableView:) :self];
    [uitableview_xdirection setDataSource:pickerPopup_xdirection];
    [uitableview_xdirection setDelegate:pickerPopup_xdirection];
    uitableview_xdirection.layer.borderWidth = 1;
    
    pickerPopup_securitylevel = [[PickerPopup alloc]init];
    [pickerPopup_securitylevel setDataSource:array_securitylevel];
    [pickerPopup_securitylevel setListener:@selector(ResetTableView:) :self];
    [uitableview_securitylevel setDataSource:pickerPopup_securitylevel];
    [uitableview_securitylevel setDelegate:pickerPopup_securitylevel];
    uitableview_securitylevel.layer.borderWidth = 1;
    
    uiscrollview_main.contentSize = CGSizeMake(320, 480);
    [uiscrollview_main setScrollEnabled:TRUE];
    
    [uitextfield_barcodedata setDelegate:self];
    [uitextfield_height setDelegate:self];
    [uitextfield_width setDelegate:self];
}

- (void)viewDidUnload
{
    [pickerPopup_barcodeSize release];
    [pickerPopup_aspectratio release];
    [pickerPopup_xdirection release];
    [pickerPopup_securitylevel release];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)ResetTableView:(id)sender
{
    [uitableview_barcodeSize reloadData];
    if([pickerPopup_barcodeSize getSelectedIndex] == 0)
    {
        [uilabel_width setText:@"width=1\u2264w\u226499"];
        [uilabel_height setText:@"height=1\u2264h\u226499"];
    }
    else
    {
        [uilabel_width setText:@"width=0,1\u2264w\u226430"];
        [uilabel_height setText:@"height=0,3\u2264h\u226490"];

    }
    [uitableview_aspectratio reloadData];
    [uitableview_xdirection reloadData];
    [uitableview_securitylevel reloadData];
}

-(IBAction)backPDF417
{
    [self dismissModalViewControllerAnimated:true];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 240)];
    [uiscrollview_main setScrollEnabled:true];
    if(textField == uitextfield_barcodedata)
    {
        if(uiscrollview_main.contentOffset.y < 160)
        {
           CGPoint scrollPoint = CGPointMake(0, 200);
           [uiscrollview_main  setContentOffset:scrollPoint animated:FALSE];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{   
    if([string isEqualToString:@"\n"] == true)
    {
        [uitextfield_barcodedata resignFirstResponder];
        [uitextfield_height resignFirstResponder];
        [uitextfield_width resignFirstResponder];
        [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 460)];
        [uiscrollview_main setScrollEnabled:TRUE];
        return NO;
    }
    
    if(uitextfield_barcodedata == textField)
    {
        return YES;
    }
    
    if([string length] == 0)
    {
        return YES;
    }
    
    if(([string characterAtIndex:0] >= '0') && ([string characterAtIndex:0] <= '9'))
    {
        return YES;
    }
    
    return NO;
}

-(IBAction)printBarcode
{
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    
    Limit limit = [pickerPopup_barcodeSize getSelectedIndex];
    NSString *heightString = uitextfield_height.text;
    unsigned char height = [heightString intValue];
    NSString *widthString = uitextfield_width.text;
    unsigned char width = [widthString intValue];
    
    unsigned char securityLevel = [pickerPopup_securitylevel getSelectedIndex];
    unsigned char setXDirection = [pickerPopup_xdirection getSelectedIndex] + 1;
    unsigned char setAspectRatio = [pickerPopup_aspectratio getSelectedIndex] + 1;
    
    NSString *barcodeDataString = uitextfield_barcodedata.text;
    NSData *barcodeData = [barcodeDataString dataUsingEncoding:NSWindowsCP1252StringEncoding];
    unsigned char *data = (unsigned char*)malloc([barcodeData length]);
    
    [PrinterFunctions PrintPDF417CodeWithPortname:portName portSettings:portSettings limit:limit p1:height p2:width securityLevel:securityLevel xDirection:setXDirection aspectRatio:setAspectRatio barcodeData:data barcodeDataSize:[barcodeData length]];
    
    free(data);
}

-(IBAction)showHelp
{
    NSString *title = @"PDF417 BARCODES";
    NSString *helpText = [ViewController HTMLCSS];
    helpText = [helpText stringByAppendingString: @"<body>\
                <p>PDF417 Barcodes are public domain.  They can contain a much \
                larger amount of data because it can link one barcode to another \
                to create one portable data file from many PDF417 barcodes.</p>\
                <SectionHeader>(1)Size setting<SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS x S 0 <StandardItalic>n p1 p2</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 78 53 30 <StandardItalic>n p1 p2</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(2)ECC (Security Level)</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS x S 1 <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 78 53 31 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(3)Module x direction size</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS x S 2 <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 78 53 32 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(4)Module aspect ratio</SectionHeader><br>\
                <Code>ASCII:</Code> <CodeDef>ESC GS x S 3 <StandardItalic>n</StandardItalic></CodeDef><br>\
                <Code>Hex:</Code> <CodeDef>1B 1D 78 53 33 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(5)Data setting</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS x D <StandardItalic>nL nH d1d2 ... dk</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 78 44 <StandardItalic>nL nH d1d2 ... dk</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(6)Printing</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS x P</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 78 50</CodeDef><br/><br/>\
                <SectionHeader>(7)Expansion Info</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS x 1</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 78 49</CodeDef><br/<br/>\
                For more information on PDF417 commands, please read 2d Barcode \
                PDF417 section in the Thermal Line Mode Command Specification Manual."];
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:helpVar animated:YES];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

@end
