//
//  QRCodeMini.m
//  IOS_SDK
//
//  Created by Tzvi on 8/23/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "QRCodeMini.h"
#import <QuartzCore/QuartzCore.h>
#import "PrinterFunctions.h"

#import "StandardHelp.h"
#import "ViewController.h"


@implementation QRCodeMini

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        array_correctionLevel = [[NSMutableArray alloc] init];
        [array_correctionLevel addObject:@"L 7%"];
        [array_correctionLevel addObject:@"M 15%"];
        [array_correctionLevel addObject:@"Q 25%"];
        [array_correctionLevel addObject:@"H 30%"];
        
        array_codeSize = [[NSMutableArray alloc]init];
        [self LoadQrcodeSizeL];
        
        array_modelSize = [[NSMutableArray alloc]init];
        [array_modelSize addObject:@"1"];
        [array_modelSize addObject:@"2"];
        [array_modelSize addObject:@"3"];
        [array_modelSize addObject:@"4"];
        [array_modelSize addObject:@"5"];
        [array_modelSize addObject:@"6"];
        [array_modelSize addObject:@"7"];
        [array_modelSize addObject:@"8"];
    }
    return self;
}

-(void)LoadQrcodeSizeM
{
    [array_codeSize removeAllObjects];
    [array_codeSize addObject: @"Auto Size"];
    [array_codeSize addObject: @"16"];
    [array_codeSize addObject: @"28"];
    [array_codeSize addObject: @"44"];
    [array_codeSize addObject: @"64"];
    [array_codeSize addObject: @"86"];
    [array_codeSize addObject: @"108"];
    [array_codeSize addObject: @"124"];
    [array_codeSize addObject: @"154"];
    [array_codeSize addObject: @"182"];
    [array_codeSize addObject: @"216"];
    [array_codeSize addObject: @"254"];
    [array_codeSize addObject: @"290"];
    [array_codeSize addObject: @"334"];
    [array_codeSize addObject: @"365"];
    [array_codeSize addObject: @"415"];
    [array_codeSize addObject: @"453"];
    [array_codeSize addObject: @"507"];
    [array_codeSize addObject: @"563"];
    [array_codeSize addObject: @"627"];
    [array_codeSize addObject: @"669"];
    [array_codeSize addObject: @"714"];
    [array_codeSize addObject: @"782"];
    [array_codeSize addObject: @"860"];
    [array_codeSize addObject: @"914"];
    [array_codeSize addObject: @"1000"];
    [array_codeSize addObject: @"1062"];
    [array_codeSize addObject: @"1128"];
    [array_codeSize addObject: @"1193"];
    [array_codeSize addObject: @"1267"];
    [array_codeSize addObject: @"1373"];
    [array_codeSize addObject: @"1455"];
    [array_codeSize addObject: @"1541"];
    [array_codeSize addObject: @"1631"];
    [array_codeSize addObject: @"1725"];
    [array_codeSize addObject: @"1812"];
    [array_codeSize addObject: @"1914"];
    [array_codeSize addObject: @"1992"];
    [array_codeSize addObject: @"2102"];
    [array_codeSize addObject: @"2216"];
    [array_codeSize addObject: @"2334"];
}

-(void)LoadQrcodeSizeL
{
    [array_codeSize removeAllObjects];
    [array_codeSize addObject: @"Auto Size"];
    [array_codeSize addObject: @"19"];
    [array_codeSize addObject: @"34"];
    [array_codeSize addObject: @"55"];
    [array_codeSize addObject: @"80"];
    [array_codeSize addObject: @"108"];
    [array_codeSize addObject: @"136"];
    [array_codeSize addObject: @"156"];
    [array_codeSize addObject: @"194"];
    [array_codeSize addObject: @"232"];
    [array_codeSize addObject: @"274"];
    [array_codeSize addObject: @"324"];
    [array_codeSize addObject: @"370"];
    [array_codeSize addObject: @"428"];
    [array_codeSize addObject: @"461"];
    [array_codeSize addObject: @"523"];
    [array_codeSize addObject: @"589"];
    [array_codeSize addObject: @"647"];
    [array_codeSize addObject: @"721"];
    [array_codeSize addObject: @"795"];
    [array_codeSize addObject: @"861"];
    [array_codeSize addObject: @"932"];
    [array_codeSize addObject: @"1006"];
    [array_codeSize addObject: @"1094"];
    [array_codeSize addObject: @"1174"];
    [array_codeSize addObject: @"1276"];
    [array_codeSize addObject: @"1370"];
    [array_codeSize addObject: @"1468"];
    [array_codeSize addObject: @"1531"];
    [array_codeSize addObject: @"1631"];
    [array_codeSize addObject: @"1735"];
    [array_codeSize addObject: @"1843"];
    [array_codeSize addObject: @"1955"];
    [array_codeSize addObject: @"2071"];
    [array_codeSize addObject: @"2191"];
    [array_codeSize addObject: @"2306"];
    [array_codeSize addObject: @"2434"];
    [array_codeSize addObject: @"2566"];
    [array_codeSize addObject: @"2702"];
    [array_codeSize addObject: @"2812"];
    [array_codeSize addObject: @"2956"];
}

-(void)LoadQrcodeSizeQ
{
    [array_codeSize removeAllObjects];
    [array_codeSize addObject: @"Auto Size"];
    [array_codeSize addObject: @"13"];
    [array_codeSize addObject: @"22"];
    [array_codeSize addObject: @"34"];
    [array_codeSize addObject: @"48"];
    [array_codeSize addObject: @"62"];
    [array_codeSize addObject: @"76"];
    [array_codeSize addObject: @"88"];
    [array_codeSize addObject: @"110"];
    [array_codeSize addObject: @"132"];
    [array_codeSize addObject: @"154"];
    [array_codeSize addObject: @"180"];
    [array_codeSize addObject: @"206"];
    [array_codeSize addObject: @"244"];
    [array_codeSize addObject: @"261"];
    [array_codeSize addObject: @"295"];
    [array_codeSize addObject: @"325"];
    [array_codeSize addObject: @"367"];
    [array_codeSize addObject: @"397"];
    [array_codeSize addObject: @"445"];
    [array_codeSize addObject: @"485"];
    [array_codeSize addObject: @"512"];
    [array_codeSize addObject: @"568"];
    [array_codeSize addObject: @"614"];
    [array_codeSize addObject: @"664"];
    [array_codeSize addObject: @"718"];
    [array_codeSize addObject: @"754"];
    [array_codeSize addObject: @"808"];
    [array_codeSize addObject: @"871"];
    [array_codeSize addObject: @"911"];
    [array_codeSize addObject: @"985"];
    [array_codeSize addObject: @"1033"];
    [array_codeSize addObject: @"1115"];
    [array_codeSize addObject: @"1171"];
    [array_codeSize addObject: @"1231"];
    [array_codeSize addObject: @"1286"];
    [array_codeSize addObject: @"1354"];
    [array_codeSize addObject: @"1426"];
    [array_codeSize addObject: @"1502"];
    [array_codeSize addObject: @"1582"];
    [array_codeSize addObject: @"1666"];
}

-(void)LoadQrcodeSizeH
{
    [array_codeSize removeAllObjects];
    [array_codeSize addObject: @"Auto Size"];
    [array_codeSize addObject: @"9"];
    [array_codeSize addObject: @"16"];
    [array_codeSize addObject: @"26"];
    [array_codeSize addObject: @"36"];
    [array_codeSize addObject: @"46"];
    [array_codeSize addObject: @"60"];
    [array_codeSize addObject: @"66"];
    [array_codeSize addObject: @"86"];
    [array_codeSize addObject: @"100"];
    [array_codeSize addObject: @"122"];
    [array_codeSize addObject: @"140"];
    [array_codeSize addObject: @"158"];
    [array_codeSize addObject: @"180"];
    [array_codeSize addObject: @"197"];
    [array_codeSize addObject: @"223"];
    [array_codeSize addObject: @"253"];
    [array_codeSize addObject: @"283"];
    [array_codeSize addObject: @"313"];
    [array_codeSize addObject: @"341"];
    [array_codeSize addObject: @"385"];
    [array_codeSize addObject: @"406"];
    [array_codeSize addObject: @"442"];
    [array_codeSize addObject: @"464"];
    [array_codeSize addObject: @"514"];
    [array_codeSize addObject: @"538"];
    [array_codeSize addObject: @"596"];
    [array_codeSize addObject: @"628"];
    [array_codeSize addObject: @"661"];
    [array_codeSize addObject: @"701"];
    [array_codeSize addObject: @"745"];
    [array_codeSize addObject: @"793"];
    [array_codeSize addObject: @"845"];
    [array_codeSize addObject: @"901"];
    [array_codeSize addObject: @"961"];
    [array_codeSize addObject: @"986"];
    [array_codeSize addObject: @"1054"];
    [array_codeSize addObject: @"1096"];
    [array_codeSize addObject: @"1142"];
    [array_codeSize addObject: @"1222"];
    [array_codeSize addObject: @"1276"];
}

- (void)dealloc
{
    [array_correctionLevel release];
    [array_modelSize release];
    [array_codeSize release];
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
    pickerpopup_correctionLevel = [[PickerPopup alloc]init];
    [pickerpopup_correctionLevel setDataSource:array_correctionLevel];
    [pickerpopup_correctionLevel setListener:@selector(ResetTableData:) :self];
    [uitableview_correctionLevel setDataSource:pickerpopup_correctionLevel];
    [uitableview_correctionLevel setDelegate:pickerpopup_correctionLevel];
    uitableview_correctionLevel.layer.borderWidth = 1;
    
    pickerpopup_codeSize = [[PickerPopup alloc]init];
    [pickerpopup_codeSize setDataSource:array_codeSize];
    [pickerpopup_codeSize setListener:@selector(ResetTableDataQrcodeSize:) :self];
    [uitableview_codeSize setDataSource:pickerpopup_codeSize];
    [uitableview_codeSize setDelegate:pickerpopup_codeSize];
    uitableview_codeSize.layer.borderWidth = 1;
    
    pickerpopup_modelSize = [[PickerPopup alloc]init];
    [pickerpopup_modelSize setDataSource:array_modelSize];
    [pickerpopup_modelSize setListener:@selector(ResetTableDataQrcodeSize:) :self];
    [uitableview_modelSize setDataSource:pickerpopup_modelSize];
    [uitableview_modelSize setDelegate:pickerpopup_modelSize];
    uitableview_modelSize.layer.borderWidth = 1;
    
    [uiscrollview_main setContentSize:CGSizeMake(320, 400)];
    [uiscrollview_main setScrollEnabled:FALSE];
    
    [uitextfield_qrcodeData setDelegate:self];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 230)];
    [uiscrollview_main setScrollEnabled:TRUE];
    [uiscrollview_main setContentOffset:CGPointMake(0, 160) animated:TRUE];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string length] == 0)
    {
        return YES;
    }
    
    if([string characterAtIndex:0] == '\n')
    {
        [uitextfield_qrcodeData resignFirstResponder];
        [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 460)];
        [uiscrollview_main setScrollEnabled:FALSE];
    }
    
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [pickerpopup_correctionLevel release];
    [pickerpopup_codeSize release];
    [pickerpopup_modelSize release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)ResetTableData:(id)sender
{
    [uitableview_correctionLevel reloadData];
    CorrectionLevelOption selectedCorrectionLevel = [pickerpopup_codeSize getSelectedIndex];
    switch (selectedCorrectionLevel)
    {
        case Low:
            [self LoadQrcodeSizeL];
             break;
        case Middle:
            [self LoadQrcodeSizeM];
            break;
        case Q:
            [self LoadQrcodeSizeQ];
            break;
        case High:
            [self LoadQrcodeSizeH];
            break;
    }
    [pickerpopup_codeSize setDataSource:array_codeSize];
    [uitableview_codeSize reloadData];
}

-(void)ResetTableDataQrcodeSize:(id)sender
{
    [uitableview_codeSize reloadData];
    [uitableview_modelSize reloadData];
}

-(IBAction)backQRCode
{
    [self dismissModalViewControllerAnimated:TRUE];
}

-(IBAction)showHelp
{
    NSString *title = @"QRCODE PRINTING";
    NSString *helpText = [ViewController HTMLCSS];
    helpText = [helpText stringByAppendingString: @"<UnderlineTitle>Set Qrcode</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>GS Z STX</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1D 5A 02</CodeDef><br/><br/>\
                * Note: This code must be used before the other QRcode command.  It sets the printer to QRCode<br/><br/>\
                <UnderlineTitle>Print QRCode</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC Z <StandardItalic>m n k dL dH d1 ... dk</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 90 <StandardItalic>m n k dL dH d1 ... dk</StandardItalic></CodeDef><br/><br/>\
                <rightMov>m</rightMov> <rightMov_NOI>specifies verion symbol (1&#8804;m&#8804;40 or 0 is autosize) see manual (pg 41) for more information</rightMov_NOI><br/><br/><br/>\
                <rightMov>n</rightMov> <rightMov_NOI>specifies EC Level.  This value can be 4C, 4D, 51, or 48 in Hex.  It stands for L, M, Q, H respectively</rightMov_NOI><br/><br/><br/>\
                <rightMov>k</rightMov> <rightMov_NOI>specifies module size (1&#8804;k&#8804;8)</rightMov_NOI><br/>\
                <rightMov>dL</rightMov> <rightMov_NOI>Represents the lower byte describing the number of bytes in the qrcode.  Mathematically: dL = qrcode Length % 256</rightMov_NOI><br/><br/><br/><br/>\
                <rightMov>dH</rightMov> <rightMov_NOI>Represents the higher byte describing the number of bytes in the qrcode.  Mathematically: dH = qrcode Length / 256</rightMov_NOI><br/><br/><br/><br/>\
                <rightMov>d1 ... dk</rightMov> <rightMov_NOI2>This is the text that will be placed in the qrcode.</rightMov_NOI2>\
                </body></html>"];
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:helpVar animated:YES];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

-(IBAction)printQRCode
{
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    CorrectionLevelOption correctionLevel = [pickerpopup_correctionLevel getSelectedIndex];
    unsigned char ecsize = [pickerpopup_codeSize getSelectedIndex];
    unsigned char moduleSize = [pickerpopup_modelSize getSelectedIndex] + 1;
    
    NSData *qrcodeData = [uitextfield_qrcodeData.text dataUsingEncoding:NSWindowsCP1252StringEncoding];
    unsigned char *qrcodeBytes = (unsigned char*)malloc([qrcodeData length]);
    [qrcodeData getBytes:qrcodeBytes];
    
    [MiniPrinterFunctions PrintQrcodePortname:portName portSettings:portSettings correctionLevelOption:correctionLevel ECLevel:ecsize moduleSize:moduleSize barcodeData:qrcodeBytes barcodeDataSize:[qrcodeData length]];
    
    free(qrcodeBytes);
}

@end
