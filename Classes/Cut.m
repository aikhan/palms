//
//  Cut.m
//  IOS_SDK
//
//  Created by Tzvi on 8/15/11.
//  Copyright 2011 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "Cut.h"
#import "PrinterFunctions.h"
#import "StandardHelp.h"
#import "ViewController.h"


@implementation Cut

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)FullCut
{
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    
    [PrinterFunctions PreformCutWithPortname:portName portSettings:portSettings cutType:FULL_CUT];
}

-(IBAction)ParcialCut
{
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    
    [PrinterFunctions PreformCutWithPortname:portName portSettings:portSettings cutType:PARCIAL_CUT];
}

-(IBAction)FullCUtFeed
{
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    
    [PrinterFunctions PreformCutWithPortname:portName portSettings:portSettings cutType:FULL_CUT_FEED];
}

-(IBAction)ParcialCutFeed
{
    NSString *portName = [ViewController getPortName];
    NSString *portSettings = [ViewController getPortSettings];
    
    [PrinterFunctions PreformCutWithPortname:portName portSettings:portSettings cutType:PARTIAL_CUT_FEED];
}

-(IBAction)backCut
{
    [self dismissModalViewControllerAnimated:true];
}

-(IBAction)showHelp
{
    NSString *title = @"Auto Cutter";
    NSString *helpText = [ViewController HTMLCSS];
    helpText = [helpText stringByAppendingString: @"<body><UnderlineTitle>CUT</UnderlineTitle><br/><br/>\
                <Code>ASCII:</code> <CodeDef>ESC d <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 54 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <div class=\"div-tableCut\">\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colFirstCut\"></div>\
                        <div class=\"div-table-colCut\"><It1>n =</It1></div>\
                        <div class=\"div-table-colCut\"><It1>0,1,2, or 3</It1></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colFirstCut\"></div>\
                        <div class=\"div-table-colCut\"><It1>0 =</It1></div>\
                        <div class=\"div-table-colCut\"><It1>Full cut at current position</It1></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colFirstCut\"></div>\
                        <div class=\"div-table-colCut\"><It1>1 =</It1></div>\
                        <div class=\"div-table-colCut\"><It1>Partial cut at current position</It1></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colFirstCut\"></div>\
                        <div class=\"div-table-colCut\"><It1>2 =</It1></div>\
                        <div class=\"div-table-colCut\"><It1>Paper is fed to cutting position, then full cut</It1></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colFirstCut\"></div>\
                        <div class=\"div-table-colCut\"><It1>3 =</It1></div>\
                        <div class=\"div-table-colCut\"><It1>Paper is fed to cutting position, then partial cut</It1></div>\
                        </div>\
                </div>"];
                
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:helpVar animated:YES];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

@end
