//
//  BarcodePrintingMini.m
//  IOS_SDK
//
//  Created by Tzvi on 8/23/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "BarcodePrintingMini.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "StandardHelp.h"


@implementation BarcodePrintingMini

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        array_width = [[NSMutableArray alloc]init];
        [array_width addObject:@"0.125"];
        [array_width addObject:@"0.25"];
        [array_width addObject:@"0.375"];
        [array_width addObject:@"0.5"];
        [array_width addObject:@"0.625"];
        [array_width addObject:@"0.75"];
        [array_width addObject:@"0.875"];
        [array_width addObject:@"1.0"];
        
        array_barcodeType = [[NSMutableArray alloc]init];
        [array_barcodeType addObject:@"code39"];
        [array_barcodeType addObject:@"code93"];
        [array_barcodeType addObject:@"ITF"];
        [array_barcodeType addObject:@"code128"];
    }
    return self;
}

- (void)dealloc
{
    [array_width release];
    [array_barcodeType release];
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
    [pickerpopup_width setListener:@selector(ResetTableView:) :self];
    [uitableview_width setDataSource:pickerpopup_width];
    [uitableview_width setDelegate:pickerpopup_width];
    uitableview_width.layer.borderWidth = 1;
    
    pickerpopup_barcode_type = [[PickerPopup alloc]init];
    [pickerpopup_barcode_type setDataSource:array_barcodeType];
    [pickerpopup_barcode_type setListener:@selector(ResetTableView:) :self];
    [uitableview_barcode_type setDataSource:pickerpopup_barcode_type];
    [uitableview_barcode_type setDelegate:pickerpopup_barcode_type];
    uitableview_barcode_type.layer.borderWidth = 1;
    
    [uitextfield_height setDelegate:self];
    [uitextfield_barcodeData setDelegate:self];
    
    uiscrollview_main.contentSize = CGSizeMake(320, 430);
    [uiscrollview_main setScrollEnabled:FALSE];
}

- (void)viewDidUnload
{
    [pickerpopup_width release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)ResetTableView:(id)sender
{
    [uitableview_width reloadData];
    [uitableview_barcode_type reloadData];
}

-(IBAction)backBarcodeMini
{
    [self dismissModalViewControllerAnimated:true];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 240)];
    [uiscrollview_main setScrollEnabled:true];
    
    if(textField == uitextfield_barcodeData)
    {
        CGPoint point = CGPointMake(0, 190);
        [uiscrollview_main setContentOffset:point animated:TRUE];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string length] == 0)
    {
        return YES;
    }
    
    if(uitextfield_height == textField)
    {
        if(([string characterAtIndex:0] >= '0') && ([string characterAtIndex:0] <= '9'))
        {
            return YES;
        }
        else if([string characterAtIndex:0] == '\n')
        {
            [uitextfield_height resignFirstResponder];
            [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 480)];
            [uiscrollview_main setScrollEnabled:false];
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    if([string characterAtIndex:0] == '\n')
    {
        [uitextfield_barcodeData resignFirstResponder];
        [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 460)];
        [uiscrollview_main setScrollEnabled:FALSE];
        return YES;
    }
    
    return YES;
}

-(IBAction)showHelp
{
    NSString *title = @"BARCODE PRINTING PORTABLE";
    NSString *helpText = [ViewController HTMLCSS];
    helpText = [helpText stringByAppendingString: @"<UnderlineTitle>Set Barcode Height</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>GS h <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1D 68 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                * Note: <StandardItalic>n</StandardItalic> must be between 0 and 255<br/><br/>\
                <UnderlineTitle>Set barcode width</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>GS w <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1D 77 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <rightMov> 1&#60;n&#60;8</rightMov><br/><br/>\
                <table border=\"1\" BORDERCOLOR=\"black\" cellspacing=0 bgcolor=\"#FFFFCC\">\
                    <tr>\
                        <td rowspan=\"2\" width=\"30\" bgcolor=\"#800000\"><font color=\"white\"><center>n</center></font></td>\
                        <td rowspan=\"2\" width=\"125\" bgcolor=\"#800000\"><font color=\"white\"><center>Multi-Level Barcode Module width(mm)</center></font></td>\
                        <td rowspan=\"1\" colspan=\"2\" bgcolor=\"#800000\"><font color=\"white\"><center>Binary Level Barcode</center></font></td>\
                </tr>\
                <tr>\
                    <td bgcolor=\"#800000\"><font color=\"white\"><center>Thin Element width(mm)</center></font></td>\
                    <td bgcolor=\"#800000\"><font color=\"white\"><center>Thick Element width(mm)</center></font></td>\
                </tr>\
                <tr>\
                    <td><center>1</center></td>\
                    <td><center>0.125</center></td>\
                    <td><center>0.125</center></td>\
                    <td><center>0.375 (= 0.125 * 3 )</center></td>\
                </tr>\
                <tr>\
                    <td><center>2</center></td>\
                    <td><center>0.25</center></td>\
                    <td><center>0.25</center></td>\
                    <td><center>0.625 ( = 0.25 * 2.5 )</center></td>\
                </tr>\
                <tr>\
                    <td><center>3</center></td>\
                    <td><center>0.375</center></td>\
                    <td><center>0.375</center></td>\
                    <td><center>1.125 ( = 0.375 * 3 )</center></td>\
                </tr>\
                <tr>\
                    <td><center>4</center></td>\
                    <td><center>0.5</center></td>\
                    <td><center>0.5</center></td>\
                    <td><center>1.25 ( = 0.5 * 2.5 )</center></td>\
                </tr>\
                <tr>\
                    <td><center>5</center></td>\
                    <td><center>0.625</center></td>\
                    <td><center>0.625</center></td>\
                    <td><center>1.875 ( = 0.625 * 3 )</center></td>\
                </tr>\
                <tr>\
                    <td><center>6</center></td>\
                    <td><center>0.75</center></td>\
                    <td><center>0.75</center></td>\
                    <td><center>1.875 ( = 0.75 * 2.5 )</center></td>\
                </tr>\
                <tr>\
                    <td><center>7</center></td>\
                    <td><center>0.875</center></td>\
                    <td><center>0.875</center></td>\
                    <td><center>2.625 ( = 0.875 * 3 )</center></td>\
                </tr>\
                <tr>\
                    <td><center>8</center></td>\
                        <td><center>1.0</center></td>\
                    <td><center>1.0</center></td>\
                    <td><center>2.5 ( = 1.0 * 2.5 )</center></td>\
                </tr>\
            </table><br/>\
                <UnderlineTitle>Print barcode</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>GS k <StandardItalic>m d1 ... dk</StandardItalic> NUL</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1D 6B <StandardItalic>m d1 ... dk</StandardItalic> 00</CodeDef><br/><br/>\
                <rightMov>m = Barcode Type See manual (pg 35)</rightMov><br/>\
                <rightMov>d1 ... dk = Barcode data. see manual (pg 35) for supported characters</rightMov></body></html>"];
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:helpVar animated:YES];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

-(IBAction)printBarcode
{
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    
    NSString *heightString = uitextfield_height.text;
    unsigned char height = [heightString intValue];
    BarcodeWidth width = [pickerpopup_width getSelectedIndex];
    BarcodeType type = [pickerpopup_barcode_type getSelectedIndex];
    NSData *barcodeData = [uitextfield_barcodeData.text dataUsingEncoding:NSWindowsCP1252StringEncoding];
    
    unsigned char *barcodeBytes = (unsigned char*)malloc([barcodeData length]);
    [barcodeData getBytes:barcodeBytes];
    
    [MiniPrinterFunctions PrintBarcodeWithPortname:portName portSettings:portSettings height:height width:width barcodeType:type barcodeData:barcodeBytes barcodeDataSize:[barcodeData length]];
    
    free(barcodeBytes);
}

@end
