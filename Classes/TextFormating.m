//
//  TextFormating.m
//  IOS_SDK
//
//  Created by Tzvi on 8/16/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "TextFormating.h"
#import <QuartzCore/QuartzCore.h>

#import "StandardHelp.h"
#import "ViewController.h"

@implementation TextFormating

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        array_hieghtExpansion = [[NSMutableArray alloc] init];
        [array_hieghtExpansion addObject:@"1"];
        [array_hieghtExpansion addObject:@"2"];
        [array_hieghtExpansion addObject:@"3"];
        [array_hieghtExpansion addObject:@"4"];
        [array_hieghtExpansion addObject:@"5"];
        [array_hieghtExpansion addObject:@"6"];
        
        array_widthExpansion = [[NSMutableArray alloc] init];
        [array_widthExpansion addObject:@"1"];
        [array_widthExpansion addObject:@"2"];
        [array_widthExpansion addObject:@"3"];
        [array_widthExpansion addObject:@"4"];
        [array_widthExpansion addObject:@"5"];
        [array_widthExpansion addObject:@"6"];
        
        array_alignment = [[NSMutableArray alloc] init];
        [array_alignment addObject:@"Left"];
        [array_alignment addObject:@"Center"];
        [array_alignment addObject:@"Right"];
        
    }
    return self;
}

- (void)dealloc
{
    [array_hieghtExpansion release];
    [array_widthExpansion release];
    [array_alignment release];
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
    [uiview_main addSubview:uiscrollview_main];
    uiscrollview_main.contentSize = CGSizeMake(320, 706);
    [uiscrollview_main setScrollEnabled:TRUE];
    [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 460)];
    uitextview_texttoprint.layer.borderWidth = 1;
    [uitextview_texttoprint setDelegate:self];
    [uitextfield_leftMargin setDelegate:self];
    
    pickerpopup_heightExpansion = [[PickerPopup alloc] init];
    [pickerpopup_heightExpansion setDataSource:array_hieghtExpansion];
    [pickerpopup_heightExpansion setListener:@selector(ResetTableView:) :self];
    [uitableview_heightExpansion setDataSource:pickerpopup_heightExpansion];
    [uitableview_heightExpansion setDelegate:pickerpopup_heightExpansion];
    uitableview_heightExpansion.layer.borderWidth = 1;
    
    pickerpopup_widthExpansion = [[PickerPopup alloc] init];
    [pickerpopup_widthExpansion setDataSource:array_widthExpansion];
    [pickerpopup_widthExpansion setListener:@selector(ResetTableView:) :self];
    [uitableview_widthExpansion setDataSource:pickerpopup_widthExpansion];
    [uitableview_widthExpansion setDelegate:pickerpopup_widthExpansion];
    uitableview_widthExpansion.layer.borderWidth = 1;
    
    pickerpopup_alignment = [[PickerPopup alloc] init];
    [pickerpopup_alignment setDataSource:array_alignment];
    [pickerpopup_alignment setListener:@selector(ResetTableView:) :self];
    [uitableview_alignment setDataSource:pickerpopup_alignment];
    [uitableview_alignment setDelegate:pickerpopup_alignment];
    uitableview_alignment.layer.borderWidth = 1;
}

- (void)viewDidUnload
{
    [pickerpopup_heightExpansion release];
    [pickerpopup_widthExpansion release];
    [pickerpopup_alignment release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 230)];
    
    
    CGPoint scrollPoint = CGPointMake(0, 470);
    [uiscrollview_main  setContentOffset:scrollPoint animated:TRUE];
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [uiscrollview_main setFrame:CGRectMake(0, 0, 320, 230)];
    
    
    return YES;
}

-(void)ResetTableView:(id)sender
{
    [uitableview_heightExpansion reloadData];
    [uitableview_widthExpansion reloadData];
    [uitableview_alignment reloadData];
}

-(IBAction)backTextFormating
{
    [self dismissModalViewControllerAnimated:true];
}

-(IBAction)PrintText
{
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    bool slashedZero = [uiswitch_slashedZero isOn];
    bool underline = [uiswitch_underline isOn];
    bool invertColor = [uiswitch_invertcolor isOn];
    bool emphasized = [uiswitch_emphasized isOn];
    bool upperline = [uiswitch_upperline isOn];
    bool upsideDown = [uiswitch_upsizeDown isOn];
    
    int heightExpansion = [pickerpopup_heightExpansion getSelectedIndex];
    int widthExpansion = [pickerpopup_widthExpansion getSelectedIndex];
    
    int leftMargin = [uitextfield_leftMargin.text intValue];
    
    Alignment alignment = [pickerpopup_alignment getSelectedIndex];
    NSData *textNSData = [uitextview_texttoprint.text dataUsingEncoding:NSWindowsCP1252StringEncoding];
    unsigned char *textData = (unsigned char *)malloc([textNSData length]);
    [textNSData getBytes:textData];
    
    [PrinterFunctions PrintTextWithPortname:portName portSettings:portSettings slashedZero:slashedZero underline:underline invertColor:invertColor emphasized:emphasized upperline:upperline upsideDown:upsideDown heightExpansion:heightExpansion widthExpansion:widthExpansion leftMargin:leftMargin alignment:alignment textData:textData textDataSize:[textNSData length]];

    free(textData);
}

-(IBAction)showHelp
{
    NSString *title = @"TEXT FORMATTING";
    NSString *helpText = [ViewController HTMLCSS];
    helpText = [helpText stringByAppendingString: @"<UnderlineTitle>Specify / Cancel Slash Zero</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC / <StandardItalic>n</StandardItalic></CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 2F <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\n\
                <rightMov>n = 1 or 0 (on or off)</rightMov><br/><br/>\n\
                More info in section 3.8 of the Line Mode Manual<br/><br/>\n\
                <UnderlineTitle>Character Expansion Settings</UnderlineTitle><br/><br/>\n\
                Width Expansion<br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC W <StandardItalic>n</StandardItalic></CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 57 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\n\
                Height Expansion<br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC h <StandardItalic>n</StandardItalic></CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 68 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\n\
                <rightMov>n = 0 through 5 (Multiplier)</rightMov><br/><br/>\n\
                More info in section 3.3.2. of the Line Mode Manual.<br/><br/>\n\
                <UnderlineTitle>Emphasized Printing (Bold)</UnderlineTitle><br/><br/>\n\
                Start Bold Text<br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC E\n</CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 45\n</CodeDef><br/><br/>\n\
                Stop Bold Text<br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC F</CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 46</CodeDef><br/><br/>\n\
                More info in section 3.3.3 of the Line Mode Manual<br/><br/>\n\
                <UnderlineTitle>Underline Mode</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC - <StandardItalic>n</StandardItalic></CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 2D <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\n\
                <rightMov>n = 1 or 0 (on or off)</rightMov><br/><br/>\n\
                <UnderlineTitle>Upperline Mode</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC _ <StandardItalic>n</StandardItalic></CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 5F <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\n\
                <rightMov>n = 1 or 0 (on or off)</rightMov><br/><br/>\n\
                <UnderlineTitle>White/Black Inverted Color Mode</UnderlineTitle><br/><br/>\n\
                Start B/W Invert<br/>\
                <Code>ASCII:</Code> <CodeDef>ESC 4</CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 34</CodeDef><br/><br/>\n\
                Stop B/W Invert<br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC 5</CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1b 35</CodeDef><br/><br/>\n\
                <UnderlineTitle>Upside-Down Printing</UnderlineTitle><br/><br/>\n\
                Start B/W Invert<br/>\n\
                <Code>ASCII:</Code> <CodeDef>SI</CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>0F</CodeDef><br/><br/>\n\
                Stop B/W Invert<br/>\n\
                <Code>ASCII:</Code> <CodeDef>DC2</CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>12</CodeDef><br/><br/>\n\
                Note: When using the command, only use it at the start of a new line. Rightside-up and Upside-Down text cannot be on the same line.<br/><br/>\
                <UnderlineTitle>Set Left Margin</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC l <StandardItalic>n</StandardItalic></CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 6C <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\n\
                <rightMov>n = 0 through 255</rightMov><br/><br/>\n\
                More info in section 3.3.6 of the Line Model Manual.<br/><br/>\n\
                <UnderlineTitle>Set Text Alignment</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC GS a <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 61 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <rightMov>n = 0 (left) or 1 (center) or 2 (right)</rightMov>\
                </body></html>\
                "];
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:helpVar animated:YES];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

@end
