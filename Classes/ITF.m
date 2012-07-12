//
//  ITF.m
//  IOS_SDK
//
//  Created by Tzvi on 8/5/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "ITF.h"
#import <QuartzCore/QuartzCore.h>
#import "StandardHelp.h"
#import "ViewController.h"


@implementation ITF

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        narrowWideArray = [[NSMutableArray alloc] init];
        [narrowWideArray addObject:@"2:5"];
        [narrowWideArray addObject:@"4:10"];
        [narrowWideArray addObject:@"6:15"];
        [narrowWideArray addObject:@"2:4"];
        [narrowWideArray addObject:@"4:8"];
        [narrowWideArray addObject:@"6:12"];
        [narrowWideArray addObject:@"2:6"];
        [narrowWideArray addObject:@"3:9"];
        [narrowWideArray addObject:@"4:12"];
        
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
    [narrowWideArray release];
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
    UIImage *image = [UIImage imageNamed:@"itf.gif"];
    [uiimagefield_barcode setImage:image];
    
    narrowWidePicker = [[PickerPopup alloc] init];
    [narrowWidePicker setDataSource:narrowWideArray];
    [narrowWidePicker setListener:@selector(ResetTableView:) :self];
    [uitableview_width setDataSource:narrowWidePicker];
    [uitableview_width setDelegate:narrowWidePicker];
    uitableview_width.layer.borderWidth = 1;
    
    
    layoutPicker = [[PickerPopup alloc] init];
    [layoutPicker setDataSource:layoutArray];
    [layoutPicker setListener:@selector(ResetTableView:) :self];
    [uitableview_layout setDataSource:layoutPicker];
    [uitableview_layout setDelegate:layoutPicker];
    uitableview_layout.layer.borderWidth = 1;
    
    uiscrollview_main.contentSize = CGSizeMake(320, 460);
    [uiscrollview_main setScrollEnabled:false];
    
    [uitextfield_barcodedata setDelegate:self];
    [uitextfield_height setDelegate:self];
}

- (void)viewDidUnload
{
    [narrowWidePicker release];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)ResetTableView: (id)sender
{
    [uitableview_width reloadData];
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
        [uitextfield_barcodedata resignFirstResponder];
        [uitextfield_height resignFirstResponder];
        [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 460)];
        [uiscrollview_main setScrollEnabled:false];
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
    
    int digit = [string characterAtIndex:0];
    if((digit >= '0') && (digit <= '9'))
    {
        return YES;
    }
    
    return NO;
}

-(IBAction)backITF
{
    [self dismissModalViewControllerAnimated:true];
}

-(IBAction)printBarcodeITF
{
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    
    NSString *barcodeDataString = uitextfield_barcodedata.text;
    NSData *data = [barcodeDataString dataUsingEncoding:NSWindowsCP1252StringEncoding];
    unsigned char *barcodeData = (unsigned char*)malloc([data length]);
    [data getBytes:barcodeData];
    
    BarCodeOptions barcodeOption = [layoutPicker getSelectedIndex];
    NarrowWideV2 width = [narrowWidePicker getSelectedIndex];
    
    NSString *heightString = uitextfield_height.text;
    int height = [heightString intValue];
    
    [PrinterFunctions PrintCodeITFWithPortname:portName portSettings:portSettings barcodeData:barcodeData barcodeDataSize:[data length] barCodeOptions:barcodeOption height:height narrowWide:width];

    free(barcodeData);
}

-(IBAction)showHelp
{
    NSString *title = @"ITF Barcode";
    NSString *helpText = [ViewController HTMLCSS];
    helpText = [helpText stringByAppendingString: @"<body>\
                <Code>Ascii:</Code> <CodeDef>ESC b ENQ <StandardItalic>n2 n3 n4 d1 ... dk</StandardItalic> RS</CodeDef> \
                <Code>Hex:</Code> <CodeDef>1B 62 04 <StandardItalic>n2 n3 n4 d1 ... dk</StandardItalic> 1E</CodeDef><br/><br/>\
                <TitleBold>Interleaved 2 of 5</TitleBold> represents numbers 0 to 9 and the total digits must be even.  \
                Each pattern can hold 2 digits, one in the black bars and one in the white spaces.  \
                Higher density of characters is possible and with JIS and EAN, and printing to cardboard for distribution \
                has been standardized.\
                </body></html>"];
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:helpVar animated:YES];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

@end
