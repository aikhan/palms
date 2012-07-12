//
//  QDF417mini.m
//  IOS_SDK
//
//  Created by Tzvi on 8/24/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "PDF417mini.h"
#import <QuartzCore/QuartzCore.h>
#import "StandardHelp.h"
#import "ViewController.h"


@implementation PDF417mini

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        array_width = [[NSMutableArray alloc]init];
        [array_width addObject:@"0.125"];
        [array_width addObject:@"0.25"];
        [array_width addObject:@"0.375"];
        [array_width addObject:@"0.5"];
        [array_width addObject:@"0.625"];
        [array_width addObject:@"0.75"];
        [array_width addObject:@"0.875"];
        [array_width addObject:@"1.0"];
        
        array_columnNumber = [[NSMutableArray alloc]init];
        for(int x = 1; x<=30; x++)
        {
            NSString *value = [NSString stringWithFormat:@"%i", x];
            [array_columnNumber addObject:value];
        }
        
        array_securityLevel = [[NSMutableArray alloc]init];
        [array_securityLevel addObject:@"0"];
        [array_securityLevel addObject:@"1"];
        [array_securityLevel addObject:@"2"];
        [array_securityLevel addObject:@"3"];
        [array_securityLevel addObject:@"4"];
        [array_securityLevel addObject:@"5"];
        [array_securityLevel addObject:@"6"];
        [array_securityLevel addObject:@"7"];
        [array_securityLevel addObject:@"8"];
        
        array_ratio = [[NSMutableArray alloc]init];
        [array_ratio addObject:@"2"];
        [array_ratio addObject:@"3"];
        [array_ratio addObject:@"4"];
        [array_ratio addObject:@"5"];
    }
    return self;
}

- (void)dealloc
{
    [array_width release];
    [array_columnNumber release];
    [array_securityLevel release];
    [array_ratio release];
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
    pickerpopup_width = [[PickerPopup alloc]init];
    [pickerpopup_width setDataSource:array_width];
    [pickerpopup_width setListener:@selector(ResetTableData:) :self];
    [uitableview_width setDataSource:pickerpopup_width];
    [uitableview_width setDelegate:pickerpopup_width];
    uitableview_width.layer.borderWidth = 1;
    
    pickerpopup_columnNumber = [[PickerPopup alloc]init];
    [pickerpopup_columnNumber setDataSource:array_columnNumber];
    [pickerpopup_columnNumber setListener:@selector(ResetTableData:) :self];
    [uitableview_columnNumber setDataSource:pickerpopup_columnNumber];
    [uitableview_columnNumber setDelegate:pickerpopup_columnNumber];
    uitableview_columnNumber.layer.borderWidth = 1;
    
    pickerpopup_securityLevel = [[PickerPopup alloc]init];
    [pickerpopup_securityLevel setDataSource:array_securityLevel];
    [pickerpopup_securityLevel setListener:@selector(ResetTableData:) :self];
    [uitableview_securityLevel setDataSource:pickerpopup_securityLevel];
    [uitableview_securityLevel setDelegate:pickerpopup_securityLevel];
    uitableview_securityLevel.layer.borderWidth = 1;
    
    pickerpopup_ratio = [[PickerPopup alloc]init];
    [pickerpopup_ratio setDataSource:array_ratio];
    [pickerpopup_ratio setListener:@selector(ResetTableData:) :self];
    [uitableview_Ratio setDataSource:pickerpopup_ratio];
    [uitableview_Ratio setDelegate:pickerpopup_ratio];
    uitableview_Ratio.layer.borderWidth = 1;
    
    [uiscrollview_main setContentSize:CGSizeMake(320, 460)];
    [uiscrollview_main setScrollEnabled:TRUE];
    [uitextfield_PDF427Data setDelegate:self];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string length] == 0)
    {
        return YES;
    }
    
    if([string characterAtIndex:0] == '\n')
    {
        [uitextfield_PDF427Data resignFirstResponder];
        [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 460)];
        [uiscrollview_main setScrollEnabled:FALSE];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 230)];
    [uiscrollview_main setScrollEnabled:TRUE];
    [uiscrollview_main setContentOffset:CGPointMake(0, 230) animated:TRUE];
}

- (void)viewDidUnload
{
    [pickerpopup_width release];
    [pickerpopup_columnNumber release];
    [pickerpopup_securityLevel release];
    [pickerpopup_ratio release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)ResetTableData:(id)sender
{
    [uitableview_Ratio reloadData];
    [uitableview_columnNumber reloadData];
    [uitableview_securityLevel reloadData];
    [uitableview_width reloadData];
}

-(IBAction)backPDF417
{
    [self dismissModalViewControllerAnimated:TRUE];
}

-(IBAction)showHelp
{
    NSString *title = @"PDF417 PRINTING";
    NSString *helpText = [ViewController HTMLCSS];
    helpText = [helpText stringByAppendingString: @"<UnderlineTitle>Set PDF417</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>GS Z NUL</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1D 5A 00</CodeDef><br/><br/>\
                * Note: This code must be used before the other QRcode command.  It sets the printer to use pdf417 code<br/><br/>\
                <UnderlineTitle>Print PDF417 codes</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC Z <StandardItalic>m n k dL dH d1 ... dk</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 5A <StandardItalic>m n k dL dH d1 ... dk</StandardItalic></CodeDef><br/><br/>\
                <rightMov>m</rightMov> <rightMov_NOI>specifies column number (1&#8804;m&#8804;30) see manual (pg 38) for more information</rightMov_NOI><br/><br/>\
                <rightMov>n</rightMov> <rightMov_NOI>specifies the security level (0&#8804;n&#8804;8)</rightMov_NOI><br/>\
                <rightMov>k</rightMov> <rightMov_NOI>defines the horizontal and vertical ratio (2&#8804;k&#8804;5)</rightMov_NOI><br/><br/>\
                <rightMov>dL</rightMov> <rightMov_NOI>Represents the lower byte describing the number of bytes in the pdf417 code.  Mathematically: dL = qrcode Length % 256</rightMov_NOI><br/><br/><br/><br/>\
                <rightMov>dH</rightMov> <rightMov_NOI>Represents the higher byte describing the number of bytes in the pdf417 code.  Mathematically: dH = qrcode = Length / 256</rightMov_NOI><br/><br/><br/><br/>\
                <rightMov>d1 ... dk</rightMov> <rightMov_NOI2>This is the text that will be placed in the pdf417 code.</rightMov_NOI2>\
                </body></html>"];
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:helpVar animated:YES];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

-(IBAction)printPDF417
{
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    BarcodeWidth width = [pickerpopup_width getSelectedIndex];
    int columnNumber = [pickerpopup_columnNumber getSelectedIndex] + 1;
    unsigned char securityLevel = [pickerpopup_securityLevel getSelectedIndex];
    unsigned char ratio = [pickerpopup_ratio getSelectedIndex] + 2;
    
    NSData *pdf417Data = [uitextfield_PDF427Data.text dataUsingEncoding:NSWindowsCP1252StringEncoding];
    unsigned char *pdf417Bytes = (unsigned char*)malloc([pdf417Data length]);
    
    [MiniPrinterFunctions PrintPDF417WithPortname:portName portSettings:portSettings width:width columnNumber:columnNumber securityLevel:securityLevel ratio:ratio barcodeData:pdf417Bytes barcodeDataSize:[pdf417Data length]];
    
    free(pdf417Bytes);
}

@end
