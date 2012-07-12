//
//  JpKnjFormatingMini.m
//  IOS_SDK
//
//  Created by Koji on 12/09/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "JpKnjFormatingMini.h"
#import <QuartzCore/QuartzCore.h>
#import "StandardHelp.h"
#import "ViewController.h"
#import "MiniPrinterFunctions.h"


@implementation JpKnjFormatingMini

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        array_height = [[NSMutableArray alloc]initWithCapacity:8];
        [array_height addObject:@"1"];
        [array_height addObject:@"2"];
        [array_height addObject:@"3"];
        [array_height addObject:@"4"];
        [array_height addObject:@"5"];
        [array_height addObject:@"6"];
        [array_height addObject:@"7"];
        [array_height addObject:@"8"];
        
        array_width = [[NSMutableArray alloc]initWithCapacity:8];
        [array_width addObject:@"1"];
        [array_width addObject:@"2"];
        [array_width addObject:@"3"];
        [array_width addObject:@"4"];
        [array_width addObject:@"5"];
        [array_width addObject:@"6"];
        [array_width addObject:@"7"];
        [array_width addObject:@"8"];
        
        array_alignment = [[NSMutableArray alloc]initWithCapacity:3];
        [array_alignment addObject:@"Left"];
        [array_alignment addObject:@"Center"];
        [array_alignment addObject:@"Right"];
    }
    return self;
}

- (void)dealloc
{
    [array_height release];
    [array_width release];
    [array_alignment release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [uiview_main addSubview:uiscrollview_main];
    [uiscrollview_main setContentSize: CGSizeMake(320, 602)];
    [uiscrollview_main setScrollEnabled:TRUE];
    [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 460)];
    
    pickerpopup_height = [[PickerPopup alloc]init];
    [pickerpopup_height setDataSource:array_height];
    [pickerpopup_height setListener:@selector(ResetTableData:) :self];
    [uitableview_height setDataSource:pickerpopup_height];
    [uitableview_height setDelegate:pickerpopup_height];
    uitableview_height.layer.borderWidth = 1;
    
    pickerpopup_width = [[PickerPopup alloc]init];
    [pickerpopup_width setDataSource:array_width];
    [pickerpopup_width setListener:@selector(ResetTableData:) :self];
    [uitableview_width setDataSource:pickerpopup_width];
    [uitableview_width setDelegate:pickerpopup_width];
    uitableview_width.layer.borderWidth = 1;
    
    pickerpopup_alignment = [[PickerPopup alloc]init];
    [pickerpopup_alignment setDataSource:array_alignment];
    [pickerpopup_alignment setListener:@selector(ResetTableData:) :self];
    [uitableview_alignment setDataSource:pickerpopup_alignment];
    [uitableview_alignment setDelegate:pickerpopup_alignment];
    uitableview_alignment.layer.borderWidth = 1;
    
	uitextfield_leftMargin.keyboardType = UIKeyboardTypeNumberPad;
    [uitextfield_leftMargin setDelegate:self];
	uitextview_texttoprint.layer.borderWidth = 1;
	uitextview_texttoprint.keyboardType = UIKeyboardTypeDefault;
    [uitextview_texttoprint setDelegate:self];
}

- (void)viewDidUnload
{
    [pickerpopup_height release];
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
    [uitableview_height reloadData];
    [uitableview_width reloadData];
    [uitableview_alignment reloadData];
}

-(IBAction)backTextFormating
{
    [self dismissModalViewControllerAnimated:TRUE];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 230)];
    [uiscrollview_main setScrollEnabled:TRUE];
    [uiscrollview_main setContentOffset:CGPointMake(0, 100) animated:TRUE];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 230)];
    [uiscrollview_main setScrollEnabled:TRUE];
    [uiscrollview_main setContentOffset:CGPointMake(0, 385) animated:TRUE];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string length] == 0)
    {
        return TRUE;
    }
    
    if(([string characterAtIndex:0] >= '0') && ([string characterAtIndex:0] <= '9'))
    {
        return TRUE;
    }
    return FALSE;
}

-(IBAction)showHelp
{
    NSString *title = @"JP KANJI FORMATING";
    NSString *helpText = [ViewController HTMLCSS];
    helpText = [helpText stringByAppendingString: @"<UnderlineTitle>Specify / Cancel Shift JIS Kanji character mode</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>FS C $ <StandardItalic>n</StandardItalic></CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 24 </CodeDef><br/><br/>\n\
                <rightMov>n = 1 or 0 (on or off)</rightMov><br/><br/>\n\
				<UnderlineTitle>Underline Command</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC - <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 2D <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <rightMov>n</rightMov> <rightMov_NOI>= 0,1, or 2</rightMov_NOI><br/>\
                <rightMov>0</rightMov> <rightMov_NOI>= Turns off underline mode</rightMov_NOI><br/>\
                <rightMov>1</rightMov> <rightMov_NOI>= Turns on underline mode (1 dot thick)</rightMov_NOI><br/>\
                <rightMov>2</rightMov> <rightMov_NOI>= Turns on underline mode (2 dots thick)</rightMov_NOI><br/><br/><br/>\
                <UnderlineTitle>Emphasized Mode</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC E <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 45 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <rightMov>n</rightMov> <rightMov_NOI>= 1 or 0 (on or off)</rightMov_NOI><br/><br/>\
                <UnderlineTitle>Upside Down</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC { <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 7B <StandardItalic>n</StandardItalic></CodeDef></br/><br/>\
                <rightMov>n</rightMov><rightMov_NOI>= 1 or 0 (on or off)</rightMov_NOI><br/><br/>\
                <UnderlineTitle>Invert Color</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>GS B <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1D 42 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <rightMov>n</rightMov> <rightMov_NOI>= 1 or 0 (on or off)</rightMov_NOI><br/><br/>\
                <UnderlineTitle>Set character size</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>GS ! <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1D 21 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <rightMov>1&#8804;height multiple times normal font size&#8804;8</rightMov><br/>\
                <rightMov>1&#8804;width  multiple times normal font size&#8804;8</rightMov><br/>\
                <rightMov>n represents both height and width expansions.  Bit 0 to 2 sets the character width. Bit 4 to 6 sets the character height</rightMov><br/><br/<br/><br/>\
                <UnderlineTitle>Left Margin</UnderlineTitle><br/><br/>\
                <Code>ACSII:</Code> <CodeDef>GS L <StandardItalic>nL nH</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1D 4C <StandardItalic>nL nH</StandardItalic></CodeDef><br/><br/>\
                <rightMov>nL</rightMov> <rightMov_NOI>Lower order number for left margin.  Mathematically: margin % 256</rightMov_NOI><br/><br/>\
                <rightMov>nH</rightMov> <rightMov_NOI>Higher order number for left margin.  Mathematically: margin / 256</rightMov_NOI><br/><br/>\
                </body></html>"];
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:helpVar animated:YES];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

-(IBAction)printTextFormating
{
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    
    bool underline = [uiswitch_underline isOn];
    bool emphasized = [uiswitch_emphasized isOn];
    bool upsidedown = [uiswitch_upsizeddown isOn];
    bool inverColor = [uiswitch_invertcolor isOn];
    
    unsigned char heightExpansion = [pickerpopup_height getSelectedIndex];
    unsigned char widthExpansion = [pickerpopup_width getSelectedIndex];
    int leftMargin = [uitextfield_leftMargin.text intValue];
    
    Alignment alignment = [pickerpopup_alignment getSelectedIndex];
    NSData *textData = [uitextview_texttoprint.text dataUsingEncoding:NSShiftJISStringEncoding];
    
    unsigned char *textBytes = (unsigned char*)malloc([textData length]);
    [textData getBytes:textBytes];
    
    [MiniPrinterFunctions PrintJpKanji:portName 
                        PortSettings:portSettings 
                        Underline:underline 
                        Emphasized:emphasized
                        Upsideddown:upsidedown
                        InvertColor:inverColor
                        HeightExpansion:heightExpansion
                        WidthExpansion:widthExpansion
                        LeftMargin:leftMargin
                        Alignment:alignment
                        TextToPrint:textBytes
                    TextToPrintSize:[textData length]];
    
    free(textBytes);
}

@end
