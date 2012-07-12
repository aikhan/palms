//
//  QRCode.m
//  IOS_SDK
//
//  Created by Tzvi on 8/9/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "QRCode.h"
#import <QuartzCore/QuartzCore.h>
#import "StandardHelp.h"
#import "ViewController.h"

@implementation QRCode

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        array_correctionLevel = [[NSMutableArray alloc] init];
        [array_correctionLevel addObject:@"L 7%"];
        [array_correctionLevel addObject:@"M 15%"];
        [array_correctionLevel addObject:@"Q 25%"];
        [array_correctionLevel addObject:@"H 30%"];
        
        array_model = [[NSMutableArray alloc] init];
        [array_model addObject:@"Model 1"];
        [array_model addObject:@"Model 2"];
        
        array_cellSize = [[NSMutableArray alloc] init];
        [array_cellSize addObject:@"1"];
        [array_cellSize addObject:@"2"];
        [array_cellSize addObject:@"3"];
        [array_cellSize addObject:@"4"];
        [array_cellSize addObject:@"5"];
        [array_cellSize addObject:@"6"];
        [array_cellSize addObject:@"7"];
        [array_cellSize addObject:@"8"];
        [array_cellSize addObject:@"9"];
    }
    return self;
}

- (void)dealloc
{
    [array_correctionLevel release];
    [array_model release];
    [array_cellSize release];
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
    UIImage *qrcodeImage = [UIImage imageNamed:@"qrcode.gif"];
    [uiimageview_qrcode setImage:qrcodeImage];
    
    pickerPopup_correctionLevel = [[PickerPopup alloc] init];
    [pickerPopup_correctionLevel setDataSource:array_correctionLevel];
    [pickerPopup_correctionLevel setListener:@selector(ResetTableView:) :self];
    [uitableview_corectionLevel setDataSource:pickerPopup_correctionLevel];
    [uitableview_corectionLevel setDelegate:pickerPopup_correctionLevel];
    uitableview_corectionLevel.layer.borderWidth = 1;
    
    pickerPopup_model = [[PickerPopup alloc] init];
    [pickerPopup_model setDataSource:array_model];
    [pickerPopup_model setListener:@selector(ResetTableView:) :self];
    [uitableview_model setDataSource:pickerPopup_model];
    [uitableview_model setDelegate:pickerPopup_model];
    uitableview_model.layer.borderWidth = 1;
    
    pickerPopup_cellSize = [[PickerPopup alloc] init];
    [pickerPopup_cellSize setDataSource:array_cellSize];
    [pickerPopup_cellSize setListener:@selector(ResetTableView:) :self];
    [uitableview_cellSize setDataSource:pickerPopup_cellSize];
    [uitableview_cellSize setDelegate:pickerPopup_cellSize];
    uitableview_cellSize.layer.borderWidth = 1;
    
    [uitextfield_barcodeData setDelegate:self];
    uiscrollview_main.contentSize = CGSizeMake(320, 460);
}

- (void)viewDidUnload
{
    [pickerPopup_correctionLevel release];
    [pickerPopup_model release];
    [pickerPopup_cellSize release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)ResetTableView: (id)sender
{
    [uitableview_corectionLevel reloadData];
    [uitableview_model reloadData];
    [uitableview_cellSize reloadData];
}

-(IBAction)backQrcode
{
    [self dismissModalViewControllerAnimated:true];
}

-(IBAction)printQrcode
{
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    
    CorrectionLevelOption correctionLevel = [pickerPopup_correctionLevel getSelectedIndex];
    Model model = [pickerPopup_model getSelectedIndex];
    unsigned char cellSize = [pickerPopup_cellSize getSelectedIndex] + 1;
    
    NSString *barcodeDataString = uitextfield_barcodeData.text;
    NSData *data = [barcodeDataString dataUsingEncoding:NSWindowsCP1252StringEncoding];
    unsigned char* barcodeData = (unsigned char*)malloc([data length]);
    [data getBytes:barcodeData];
    
    [PrinterFunctions PrintQrcodeWithPortname:portName portSettings:portSettings correctionLevel:correctionLevel model:model cellSize:cellSize barcodeData:barcodeData barcodeDataSize:[data length]];
    
    free(barcodeData);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 280)];
    [uiscrollview_main setScrollEnabled:true];
    if(textField == uitextfield_barcodeData)
    {
        CGPoint scrollPoint = CGPointMake(0, 160);
        [uiscrollview_main  setContentOffset:scrollPoint animated:FALSE];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{   
    if([string isEqualToString:@"\n"] == true)
    {
        [uitextfield_barcodeData resignFirstResponder];
        [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 460)];
        [uiscrollview_main setScrollEnabled:false];
        return NO;
    }
    
    return YES;
}

-(IBAction)showHelp
{
    NSString *title = @"QR CODES";
    NSString *helpText = [ViewController HTMLCSS];
    helpText = [helpText stringByAppendingString: @"<body><p>StarMicronics supports all the latest high data density\
                for QR codes.  QR Codes  are handy for distributing URLs, Music, Images, E-Mails, \
                Contacts and much more.  Is is public domain and great for storing Japanese Kanji \
                and Kana characters.  They can be scanned with almost all smart phones which is great \
                if you want to for example, put a QR Code to hyperlink you company's Facebook profile on \
                the bottom of every receipt. <br/><br/>\
                <SectionHeader>(1) Set barcode model</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS y S 0 <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 79 53 30 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(2)Set error correction level</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS y S 1 <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDeF>1B 1D 79 53 31 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(3)Specify size of cell</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS y S 2 <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 79 53 32 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(4)Set barcode data</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS y D 1 NUL <StandardItalic>nL nH d1d2 ... dk</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 79 44 31 00 <StandardItalic>nL nH d1d2 ... dk</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(5)Print barcode</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS y P</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 79 50</CodeDef><br/></br>\
                * Note the QR code is a registered trademark of DENSO WEB\
                </body><html>"];
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:helpVar animated:YES];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

@end
