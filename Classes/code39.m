//
//  code39.m
//  IOS_SDK
//
//  Created by Tzvi on 8/2/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "code39.h"
#import <QuartzCore/QuartzCore.h>
#import "PickerPopup.h"

#import "StandardHelp.h"
#import "ViewController.h"

#define kOFFSET_FOR_KEYBOARD 150.0

@implementation code39

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        narrowWideArray = [[NSMutableArray alloc]init];
        [narrowWideArray addObject:@"2:6"];
        [narrowWideArray addObject:@"3:9"];
        [narrowWideArray addObject:@"4:12"];
        [narrowWideArray addObject:@"2:5"];
        [narrowWideArray addObject:@"3:8"];
        [narrowWideArray addObject:@"4:10"];
        [narrowWideArray addObject:@"2:4"];
        [narrowWideArray addObject:@"3:6"];
        [narrowWideArray addObject:@"4:8"];
        
        layoutArray = [[NSMutableArray alloc]init];
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
    [uiimageview_code39 setImage:image];
    
    narrowWidthPicker = [[PickerPopup alloc] init];
    [narrowWidthPicker setListener:@selector(DismissActionSheet:): self];
    [narrowWidthPicker setDataSource:narrowWideArray];
    
    [uitableview_NarrowWide setDelegate:narrowWidthPicker];
    [uitableview_NarrowWide setDataSource:narrowWidthPicker];
    uitableview_NarrowWide.layer.borderWidth = 1;
    
    layoutPicker = [[PickerPopup alloc] init];
    [layoutPicker setListener:@selector(DismissActionSheet:) :self];
    [layoutPicker setDataSource:layoutArray];
    
    [uitableview_Layout setDelegate:layoutPicker];
    [uitableview_Layout setDataSource:layoutPicker];
    uitableview_Layout.layer.borderWidth = 1;
    
    uiscrollview_Main.contentSize = CGSizeMake(320, 460);
    //[uiscrollview_Main setFrame:CGRectMake(0, 0, 320, 360)];
    
    [uitextfield_BarcodeData setDelegate:self];
    [uitextfield_Height setDelegate:self];
}

- (void)viewDidUnload
{
    [narrowWidthPicker release];
    [layoutPicker release];
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
    [uitableview_NarrowWide reloadData];
    [uitableview_Layout reloadData];
}

-(void)printBarCode
{
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    
    NSString *barcodeDataString = uitextfield_BarcodeData.text;
    NSData *data = [barcodeDataString dataUsingEncoding:NSWindowsCP1252StringEncoding];
    
    BarCodeOptions option = [layoutPicker getSelectedIndex];
    
    NSString *heightString = uitextfield_Height.text;
    int height = [heightString intValue];
    
    NarrowWide width = [narrowWidthPicker getSelectedIndex];
    
    unsigned char *barcodeData = (unsigned char*)malloc([data length]);
    [data getBytes:barcodeData];
    
    
    [PrinterFunctions PrintCode39WithPortname:portName portSettings:portSettings barcodeData:barcodeData barcodeDataSize:[data length] barcodeOptions:option height:height narrowWide:width];

    free(barcodeData);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [uiscrollview_Main setFrame:CGRectMake(0, 0, 320, 280)];
    [uiscrollview_Main setScrollEnabled:true];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{    
    if([string isEqualToString:@"\n"] == true)
    {
        [uitextfield_BarcodeData resignFirstResponder];
        [uitextfield_Height resignFirstResponder];
        [uiscrollview_Main setFrame:CGRectMake(0, 0, 320, 460)];
        [uiscrollview_Main setScrollEnabled:false];
        return NO;
    }
    
    if(uitextfield_BarcodeData == textField)
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

-(IBAction)backCode39
{
     [self dismissModalViewControllerAnimated:true];
}

-(IBAction)showHelp
{
    NSString *title = @"Code 39 Barcode";
    NSString *helpText = [ViewController HTMLCSS];
    
    helpText = [helpText stringByAppendingFormat:@"<body>\
                <Code>ASCII:</Code> \
                <CodeDef>ESC b EOT <StandardItalic>n2 n3 n4 d1 ... dk</StandardItalic> RS</CodeDef></br>\
                <Code>Hex:</Code> <CodeDef>1B 62 04 <StandardItalic>n2 n3 n4 d1 ... nk</StandardItalic> 1E</CodeDef><br/><br/>\
                <TitleBold>Code 39</TitleBold> represents numbers 0 to 9 and the letters of the alphabet from A to Z.  \
                These are the symbols most frequently used today in industry.\
                </body></html>"];
    
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:helpVar animated:YES];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

@end
