//
//  rasterPrinting.m
//  IOS_SDK
//
//  Created by Tzvi on 8/17/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "rasterPrinting.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "StandardHelp.h"
#import "MagTekDemoAppDelegate.h"
#import "PrinterManager.h"

@interface rasterPrinting (hidden)

-(UIFont*)getSelectedFont: (int)multiple;

@end

@implementation rasterPrinting
static NSString *printerAddress = @"TCP:192.168.1.81";
static NSString *printerPort = @"9100";
@synthesize uitextview_texttoprint, texttoprint, viewContoller, signatureImage, isMasterPrint;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSArray *fonts = [UIFont familyNames];
        
        array_font = [[NSMutableArray alloc] init];
        [array_font addObjectsFromArray:fonts];
        
        array_fontStyle = [[NSMutableArray alloc] init];
        NSArray *fondSytlesArray = [UIFont fontNamesForFamilyName:[array_font objectAtIndex:0]];
        [array_fontStyle addObjectsFromArray:fondSytlesArray];
        
        array_printerSize = [[NSMutableArray alloc] init];
        [array_printerSize addObject:@"3 inch"];
        [array_printerSize addObject:@"4 inch"];
    }
    return self;
}

- (void)dealloc
{
    [array_font release];
    [array_fontStyle release];
    [array_printerSize release];
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
    pickerpopup_font = [[PickerPopup alloc] init];
    [pickerpopup_font setDataSource:array_font];
    [pickerpopup_font setListener:@selector(ResetTableView:) :self];
    [uitableview_font setDataSource:pickerpopup_font];
    [uitableview_font setDelegate:pickerpopup_font];
    uitableview_font.layer.borderWidth = 1;
    
    pickerpopup_fontStyle = [[PickerPopup alloc] init];
    [pickerpopup_fontStyle setDataSource:array_fontStyle];
    [pickerpopup_fontStyle setListener:@selector(ResetTableViewStyle:) :self];
    [uitableview_fontStyle setDataSource:pickerpopup_fontStyle];
    [uitableview_fontStyle setDelegate:pickerpopup_fontStyle];
    uitableview_fontStyle.layer.borderWidth = 1;
    
    pickerpopup_printerSize = [[PickerPopup alloc] init];
    [pickerpopup_printerSize setDataSource:array_printerSize];
    [pickerpopup_printerSize setListener:@selector(ResetTableViewPrinterSize:) :self];
    [uitableview_printWidth setDataSource:pickerpopup_printerSize];
    [uitableview_printWidth setDelegate:pickerpopup_printerSize];
    uitableview_printWidth.layer.borderWidth = 1;
    
    uitextview_texttoprint.layer.borderWidth = 1;
    UIFont *font = uitextview_texttoprint.font;
    UIFont *font2 = [UIFont fontWithName:font.familyName size:[UIFont labelFontSize]];
    [uitextview_texttoprint setFont:font2];
    double f = [UIFont labelFontSize];
    NSString *fontSize = [NSString stringWithFormat:@"%02.2f", f];
    [uitextfield_textsize setText:fontSize];
    
    
    uiscrollview_main.contentSize = CGSizeMake(320, 470);
    [uiscrollview_main setScrollEnabled:FALSE];
    self.uitextview_texttoprint.text = self.texttoprint;
    [uitextfield_textsize setDelegate:self];
    [uitextview_texttoprint setDelegate:self];
}
-(void)viewDidUnload
{
    [pickerpopup_font release];
    [pickerpopup_fontStyle release];
    [pickerpopup_printerSize release];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)ResetTableView:(id)sender
{
    [uitableview_font reloadData];
    
    NSArray *fondSytlesArray = [UIFont fontNamesForFamilyName:[array_font objectAtIndex:[pickerpopup_font getSelectedIndex]]];
    [array_fontStyle removeAllObjects];
    [array_fontStyle addObjectsFromArray:fondSytlesArray];
    [pickerpopup_fontStyle setDataSource:array_fontStyle];
    [uitableview_fontStyle reloadData];
    
    UIFont *font = [self getSelectedFont:1];
    [uitextview_texttoprint setFont:font];
}

-(void)ResetTableViewStyle:(id)sender
{
    [uitableview_fontStyle reloadData];
    
    UIFont *font = [self getSelectedFont:1];
    [uitextview_texttoprint setFont:font];
}
     
-(void)ResetTableViewPrinterSize:(id)sender
{
    [uitableview_printWidth reloadData];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 240)];
    [uiscrollview_main setScrollEnabled:true];
    
    CGPoint point = CGPointMake(0, 240);
    [uiscrollview_main setContentOffset:point animated:TRUE];
}

-(IBAction)sizeChanged
{
    UIFont *font = [self getSelectedFont:1];
    [uitextview_texttoprint setFont:font];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{   
    if([string length] == 0)
    {
        return YES;
    }
    
    if(([string characterAtIndex:0] >= '0') && ([string characterAtIndex:0] <= '9'))
    {
        return YES;
    }
    
    if([string characterAtIndex:0] == '.')
    {
        NSRange range = [uitextfield_textsize.text rangeOfString:@"."];
        if(range.length == 0)
        {
            return YES;
        }
    }
    
    if([string characterAtIndex:0] == '\n')
    {
        [uitextfield_textsize resignFirstResponder];
        [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 460)];
        [uiscrollview_main setScrollEnabled:FALSE];
        return YES;
    }
    
    return NO;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 240)];
    [uiscrollview_main setScrollEnabled:TRUE];
}

-(IBAction)backRasterPrinting
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"STOP" message:@"Do you want to go back" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
 //   [self dismissModalViewControllerAnimated:true];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"Cancel");
    }else {
        [self dismissModalViewControllerAnimated:true];
    }
}

-(IBAction)printRasterText
{
    NSAutoreleasePool *releasePool = [[NSAutoreleasePool alloc]init];
    NSString *textToPrint = uitextview_texttoprint.text;
    
    UIFont *font = [self getSelectedFont:2];
    CGSize size = CGSizeMake(576, 10000);
    CGSize messuredSize = [textToPrint sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    
    if(UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(messuredSize, NO, 0);
    else
        UIGraphicsBeginImageContext(messuredSize);
    
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    UIColor *color = [UIColor whiteColor];
    [color set];
    
    CGRect rect = CGRectMake(0, 0, messuredSize.width, messuredSize.height);
    CGContextFillRect(ctr, rect);
    
    color = [UIColor blackColor];
    [color set];
    
    [textToPrint drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap];
    
    UIImage *imageToPrint = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    
    int width = 576;
    if([pickerpopup_printerSize getSelectedIndex] == 0)
    {
        width = 576;
    }
    else if([pickerpopup_printerSize getSelectedIndex] == 1)
    {
        width = 832;
    }
    
    if([portSettings compare:@"mini" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        [MiniPrinterFunctions PrintBitmapWithPortName:portName portSettings:portSettings imageSource:imageToPrint printerWidth:width];
    }
    else
    {
        [PrinterFunctions PrintImageWithPortname:portName portSettings:portSettings imageToPrint:imageToPrint maxWidth:width];
    }
    //PrinterManager *pm = (PrinterManager*)[PrinterManager shared];
    [PrinterManager PrintImageWithPortname:printerAddress portSettings:printerPort imageToPrint:self.signatureImage maxWidth:480];
    if (self.isMasterPrint) {
        
    
    MagTekDemoAppDelegate * appDelegate = (MagTekDemoAppDelegate*) [UIApplication sharedApplication].delegate;
    for (Dancer *dancer in self.viewContoller.dancersArray) {
        dancer.dancerPaid = nil;
        dancer.totalFee = [NSNumber numberWithInt:0];
        dancer.pricePerDance = @"0";
        dancer.minsPerPrice = nil;
        dancer.dances = @"0";
        dancer.houseFee = @"0";
    } 
    self.viewContoller.dancesPaymentArray = nil;
    self.viewContoller.dancesPaymentDetails = nil;
    //dont forget to write
    self.viewContoller.totalAmountLabel.text = @"";
    appDelegate.dancersArray = self.viewContoller.dancersArray;
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <[appDelegate.dancersArray count] ; i++) {
        
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[appDelegate.dancersArray objectAtIndex:i]];
        [tempArray addObject:myEncodedObject];
    }
    
    NSArray * dancers = [NSArray arrayWithArray:tempArray];
    [[NSUserDefaults standardUserDefaults] setObject:dancers forKey:@"DancersArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [releasePool release];
}

-(UIFont*)getSelectedFont: (int)multiple;
{
    int fontIndex = [pickerpopup_fontStyle getSelectedIndex];
    NSString *fontName = [array_fontStyle objectAtIndex:fontIndex];
    
    double fontSize = [uitextfield_textsize.text floatValue];
    fontSize *= multiple;
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    
    return font;
}

-(IBAction)showHelp
{
    NSString *title = @"PRINTING RASTER IMAGES";
    NSString *portSettings = [ViewController getPortSettings];
    NSString *helpText = [ViewController HTMLCSS];
    if([portSettings compare:@"mini" options: NSCaseInsensitiveSearch] ==  NSOrderedSame)
    {
        helpText = [helpText stringByAppendingFormat:@"<UnderlineTitle>Define Bit Image</UnderlineTitle><br/><br/>\
                    <Code>ASCII:</Code> <CodeDef>ESC X 4 <StandardItalic>x y d1...dk</StandardItalic></CodeDef><br/>\
                    <Code>Hex:</Code> <CodeDef>1B 58 34 <StandardItalic>x y d1...dk</StandardItalic></CodeDef><br/><br/>\
                    <rightMov>x</rightMov> <rightMov_NOI>Width of the image divided by 8</rightMov_NOI><br/>\
                    <rightMov>y</rightMov> <rightMov_NOI>Vertical number of dots to be printed.  This value shouldn't exceed 24.  If you need to print an image taller than 24 then you should use this command multiple times</rightMov_NOI><br/><br/><br/><br/><br/>\
                    <rightMov>d1...dk</rightMov> <rightMov_NOI2>The dots that should be printed.  When all vertical dots are printed the head moves horizonaly to the next vertical set of dots</rightMov_NOI2><br/><br/><br/><br/>\
                    <UnderlineTitle>Print Bit Image</UnderlineTitle><br/><br/>\
                    <Code>ASCII:</Code> <CodeDef>ESC X 2 <StandardItalic>y</StandardItalic></CodeDef><br/>\
                    <Code>Hex:</Code> <CodeDef>1B 58 32<StandardItalics>y</StandardItalics></CodeDef><br/><br/>\
                    <rightMov>y</rightMov> <rightMov_NOI>The value y must be the same value that was used int eh ESC X 4 command for define a bit image</rightMov_NOI><br/><br/><br/><br/>\
                    Note: The command ESC X 2 must be used after each usage of ESC X 4 inorder to print images"];
    }
    else
    {
        helpText = [helpText stringByAppendingString: @"<UnderlineTitle>Enter Raster Mode</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC * r A</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 2A 72 41</CodeDef><br/><br/>\
                <UnderlineTitle>Initiallize raster mode</UnderlineTitle><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC * r R</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 2A 72 52</CodeDef><br/><br/>\
                <UnderlineTitle>Set Raster EOT mode</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC * r E <StandardItalic>n</StandardItalic> NUL</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 2A 72 45 <StandardItalic>n</StandardItalic> 00</CodeDef><br/>\
                <div class=\"div-tableCut\">\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colRaster\"><center>n</center></div>\
                        <div class=\"div-table-colRaster\"><center>FormFeed</center></div>\
                        <div class=\"div-table-colRaster\"><center>Cut Feed</center></div>\
                        <div class=\"div-table-colRaster\"><center>Cutter</center></div>\
                        <div class=\"div-table-colRaster\"><center>Presenter</center></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colRaster\"><center>0</center></div>\
                        <div class=\"div-table-colRaster\"><center>Default</center></div>\
                        <div class=\"div-table-colRaster\"><center>Default</center></div>\
                        <div class=\"div-table-colRaster\"><center>Default</center></div>\
                        <div class=\"div-table-colRaster\"><center>Default</center></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colRaster\"><center>1</center></div>\
                        <div class=\"div-table-colRaster\"><center>○</center></div>\
                        <div class=\"div-table-colRaster\"><center>-</center></div>\
                        <div class=\"div-table-colRaster\"><center>-</center></div>\
                        <div class=\"div-table-colRaster\"><center>-</center></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colRaster\"><center>2</center></div>\
                        <div class=\"div-table-colRaster\"><center>○</center></div>\
                        <div class=\"div-table-colRaster\"><center>○</center></div>\
                        <div class=\"div-table-colRaster\"><center>-</center></div>\
                        <div class=\"div-table-colRaster\"><center>-</center></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colRaster\"><center>3</center></div>\
                        <div class=\"div-table-colRaster\"><center>○</center></div>\
                        <div class=\"div-table-colRaster\"><center>TearBar</center></div>\
                        <div class=\"div-table-colRaster\"><center>-</center></div>\
                        <div class=\"div-table-colRaster\"><center>-</center></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colRaster\"><center>8</center></div>\
                        <div class=\"div-table-colRaster\"><center>○</center></div>\
                        <div class=\"div-table-colRaster\"><center>-</center></div>\
                        <div class=\"div-table-colRaster\"><center>Full Cut</center></div>\
                        <div class=\"div-table-colRaster\"><center>-</center></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colRaster\"><center>9</center></div>\
                        <div class=\"div-table-colRaster\"><center>○</center></div>\
                        <div class=\"div-table-colRaster\"><center>○</center></div>\
                        <div class=\"div-table-colRaster\"><center>Full Cut</center></div>\
                        <div class=\"div-table-colRaster\"><center>-</center></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colRaster\"><center>12</center></div>\
                        <div class=\"div-table-colRaster\"><center>○</center></div>\
                        <div class=\"div-table-colRaster\"><center>-</center></div>\
                        <div class=\"div-table-colRaster\"><center>Partial Cut</center></div>\
                        <div class=\"div-table-colRaster\"><center>-</center></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colRaster\"><center>13</center></div>\
                        <div class=\"div-table-colRaster\"><center>○</center></div>\
                        <div class=\"div-table-colRaster\"><center>○</center></div>\
                        <div class=\"div-table-colRaster\"><center>Partial Cut</center></div>\
                        <div class=\"div-table-colRaster\"><center>-</center></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colRaster\"><center>36</center></div>\
                        <div class=\"div-table-colRaster\"><center>○</center></div>\
                        <div class=\"div-table-colRaster\"><center>-</center></div>\
                        <div class=\"div-table-colRaster\"><center>Full Cut</center></div>\
                        <div class=\"div-table-colRaster\"><center>Eject</center></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colRaster\"><center>37</center></div>\
                        <div class=\"div-table-colRaster\"><center>○</center></div>\
                        <div class=\"div-table-colRaster\"><center>○</center></div>\
                        <div class=\"div-table-colRaster\"><center>Full Cut</center></div>\
                        <div class=\"div-table-colRaster\"><center>Eject</center></div>\
                    </div>\
                </div><br/><br/>\
                <UnderlineTitle>Set Raster FF mode</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC * r F <StandardItalic>n</StandardItalic> NUL</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 2A 72 46 <StandardItalic>n</StandardItalic> 00</CodeDef><br/>\
                <div class=\"div-tableCut\">\
                <div class=\"div-table-rowCut\">\
                <div class=\"div-table-colRaster\"><center>n</center></div>\
                <div class=\"div-table-colRaster\"><center>FormFeed</center></div>\
                <div class=\"div-table-colRaster\"><center>Cut Feed</center></div>\
                <div class=\"div-table-colRaster\"><center>Cutter</center></div>\
                <div class=\"div-table-colRaster\"><center>Presenter</center></div>\
                </div>\
                <div class=\"div-table-rowCut\">\
                <div class=\"div-table-colRaster\"><center>0</center></div>\
                <div class=\"div-table-colRaster\"><center>Default</center></div>\
                <div class=\"div-table-colRaster\"><center>Default</center></div>\
                <div class=\"div-table-colRaster\"><center>Default</center></div>\
                <div class=\"div-table-colRaster\"><center>Default</center></div>\
                </div>\
                <div class=\"div-table-rowCut\">\
                <div class=\"div-table-colRaster\"><center>1</center></div>\
                <div class=\"div-table-colRaster\"><center>○</center></div>\
                <div class=\"div-table-colRaster\"><center>-</center></div>\
                <div class=\"div-table-colRaster\"><center>-</center></div>\
                <div class=\"div-table-colRaster\"><center>-</center></div>\
                </div>\
                <div class=\"div-table-rowCut\">\
                <div class=\"div-table-colRaster\"><center>2</center></div>\
                <div class=\"div-table-colRaster\"><center>○</center></div>\
                <div class=\"div-table-colRaster\"><center>○</center></div>\
                <div class=\"div-table-colRaster\"><center>-</center></div>\
                <div class=\"div-table-colRaster\"><center>-</center></div>\
                </div>\
                <div class=\"div-table-rowCut\">\
                <div class=\"div-table-colRaster\"><center>3</center></div>\
                <div class=\"div-table-colRaster\"><center>○</center></div>\
                <div class=\"div-table-colRaster\"><center>TearBar</center></div>\
                <div class=\"div-table-colRaster\"><center>-</center></div>\
                <div class=\"div-table-colRaster\"><center>-</center></div>\
                </div>\
                <div class=\"div-table-rowCut\">\
                <div class=\"div-table-colRaster\"><center>8</center></div>\
                <div class=\"div-table-colRaster\"><center>○</center></div>\
                <div class=\"div-table-colRaster\"><center>-</center></div>\
                <div class=\"div-table-colRaster\"><center>Full Cut</center></div>\
                <div class=\"div-table-colRaster\"><center>-</center></div>\
                </div>\
                <div class=\"div-table-rowCut\">\
                <div class=\"div-table-colRaster\"><center>9</center></div>\
                <div class=\"div-table-colRaster\"><center>○</center></div>\
                <div class=\"div-table-colRaster\"><center>○</center></div>\
                <div class=\"div-table-colRaster\"><center>Full Cut</center></div>\
                <div class=\"div-table-colRaster\"><center>-</center></div>\
                </div>\
                <div class=\"div-table-rowCut\">\
                <div class=\"div-table-colRaster\"><center>12</center></div>\
                <div class=\"div-table-colRaster\"><center>○</center></div>\
                <div class=\"div-table-colRaster\"><center>-</center></div>\
                <div class=\"div-table-colRaster\"><center>Partial Cut</center></div>\
                <div class=\"div-table-colRaster\"><center>-</center></div>\
                </div>\
                <div class=\"div-table-rowCut\">\
                <div class=\"div-table-colRaster\"><center>13</center></div>\
                <div class=\"div-table-colRaster\"><center>○</center></div>\
                <div class=\"div-table-colRaster\"><center>○</center></div>\
                <div class=\"div-table-colRaster\"><center>Partial Cut</center></div>\
                <div class=\"div-table-colRaster\"><center>-</center></div>\
                </div>\
                <div class=\"div-table-rowCut\">\
                <div class=\"div-table-colRaster\"><center>36</center></div>\
                <div class=\"div-table-colRaster\"><center>○</center></div>\
                <div class=\"div-table-colRaster\"><center>-</center></div>\
                <div class=\"div-table-colRaster\"><center>Full Cut</center></div>\
                <div class=\"div-table-colRaster\"><center>Eject</center></div>\
                </div>\
                <div class=\"div-table-rowCut\">\
                <div class=\"div-table-colRaster\"><center>37</center></div>\
                <div class=\"div-table-colRaster\"><center>○</center></div>\
                <div class=\"div-table-colRaster\"><center>○</center></div>\
                <div class=\"div-table-colRaster\"><center>Full Cut</center></div>\
                <div class=\"div-table-colRaster\"><center>Eject</center></div>\
                </div>\
                </div><br/><br/>\
                <UnderlineTitle>Set raster page length</UnderlineTitle><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC * r P <StandardItalic>n</StandardItalic> NUL</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 2A 72 50 <StandardItalic>n</StandardItalic> NUL</CodeDef><br/><br/>\
                <rightMov>0 = Continuous print mode (no page length setting)</rightMov><br/><br/>\
                <rightMov>1&#60;n = Specify page length</rightMov><br/><br/>\
                <UnderlineTitle>Set raster print quality</UnderlineTitle><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC * r Q <StandardItalic>n</StandardItalic> NUL</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 2A 72 51 <StandardItalic>n</StandardItalic> 00</CodeDef><br/><br/>\
                <rightMov>0 = Specify high speed printing</rightMov><br/>\
                <rightMov>1 = Normal print quality</rightMov><br/>\
                <rightMov>2 = High print quality</rightMov><br/><br/>\
                <UnderlineTitle>Set raster left margin</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC * r m l <StandardItalic>n</StandardItalic> NUL</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 2A 72 6D 6C <StandardItalic>n</StandardItalic> 00</CodeDef><br/><br/>\
                <UnderlineTitle>Send raster data (auto line feed)</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>b <StandardItalic>n1 n2 d1 d2 ... dk</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>62 <StandardItalic>n1 n2 d1 d2 ... dk</StandardItalic></CodeDef><br/><br/>\
                <rightMov>n1 = (image width / 8) Mod 256</rightMov><br/>\
                <rightMov>n2 = image width / 256</rightMov><br/>\
                <rightMov>k = n1 + n2 * 256</rightMov><br/>\
                * Each byte send in d1 ... dk represents 8 horizontal bits.  The values n1 and n2 tell the printer how many byte are sent with d1 ... dk.  The printer automatically feeds when the last value for d1 ... dk is sent<br/><br/>\
                <UnderlineTitle>Quit raster mode</UnderlineTitle><br/></br>\
                <Code>ASCII:</Code> <CodeDef>ESC * r A</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 2A 72 41</CodeDef><br/><br/>\
                * This command automatically executes a EOT(cut) command before quiting.  Use the set EOT command to change the action of this command.\
                "];
    }
    
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:helpVar animated:YES];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}


@end
