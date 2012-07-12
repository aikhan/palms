//
//  ViewController.h
//  Palms
//
//  Created by Saleh Shah on 5/8/12.
//  Copyright (c) 2012 Semantic Notion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Dancer.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import "MTSCRA.h"
#import "SignatureViewController.h"
#import "MiniPrinterFunctions.h"

@class VIPDacneViewController;


@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPopoverControllerDelegate, UITextFieldDelegate, NSStreamDelegate, SignatureViewControllerDelegate> {
    
    IBOutlet UITableView * dancersTable;
    NSMutableArray * dancersArray;
    
    IBOutlet UISegmentedControl * segmentedControl;
    
    IBOutlet UITextField * dancerSearchField;
    //SignatureViewController * signatureViewController;
    
    IBOutlet UIButton * creditCardButton;
    IBOutlet UIButton * cashButton;
    IBOutlet UIButton * voucherButton;
    
    
    UIPopoverController * addDancerPopoverController;
    
    UITableViewCell *lastClickedCell;
    
    
    
    
    NSArray * minsPerDanceOptions;
    
    UIButton * currentButton;
    
    IBOutlet UIButton * pricePerDanceButton;
    IBOutlet UIButton * houseFeeButton;
    IBOutlet UIButton * minsPerPriceButton;
    
    IBOutlet UILabel * houseFeeLabel;
    IBOutlet UILabel * totalAmountLabel;
    
    IBOutlet UITableView * dancesPaymentTable;
    NSMutableArray * dancesPaymentArray;
    NSMutableArray * dancesPaymentDetails;
    
    Dancer * currentDancer;
    EAAccessory *acc;
    MTSCRA *mtSCRALib;
    MiniPrinterFunctions *miniPrinterFunctions;
    PrinterFunctions *printerFunctions;
}

@property(nonatomic,retain) IBOutlet UITableView * dancersTable;
@property(nonatomic,retain) NSMutableArray * dancersArray;
@property(nonatomic,retain) IBOutlet UISegmentedControl * segmentedControl;
@property(nonatomic,retain) IBOutlet UITextField * dancerSearchField;
@property(nonatomic,retain) SignatureViewController * signatureViewController;

@property(nonatomic,retain) IBOutlet UIButton * creditCardButton;
@property(nonatomic,retain) IBOutlet UIButton * cashButton;
@property(nonatomic,retain) IBOutlet UIButton * voucherButton;
@property(nonatomic,retain) UIPopoverController * addDancerPopoverController;
@property(nonatomic,retain) UITableViewCell *lastClickedCell;
@property(nonatomic,retain) IBOutlet UITextField *dancerPayTextField;

@property (nonatomic, retain) MTSCRA *mtSCRALib;


@property(nonatomic,retain) UIButton * currentButton;

@property(nonatomic,retain) IBOutlet UIButton * pricePerDanceButton;
@property(nonatomic,retain) IBOutlet UIButton * houseFeeButton;
@property(nonatomic,retain) IBOutlet UIButton * minsPerPriceButton;
@property(nonatomic,retain) IBOutlet UILabel * houseFeeLabel;
@property(nonatomic,retain) IBOutlet UILabel * labelAboveCC;
@property(nonatomic,retain) IBOutlet UILabel * labelAmountAboveCC;
@property(nonatomic,retain) IBOutlet UIButton * buttonAmountAboveCC;
@property(nonatomic,retain) IBOutlet UIButton * buttonPaynow;
@property(nonatomic,retain) IBOutlet UIButton * buttonPayByCC;
@property(nonatomic,retain) IBOutlet UIButton * buttonPayByCash;
@property(nonatomic,retain) IBOutlet UIImage * signatureImage;

@property(nonatomic,retain) IBOutlet UITextField * creditCardNumberTextField;
@property(nonatomic,retain) IBOutlet UITextField * creditCardExpiryTextField;
@property(nonatomic,retain) IBOutlet UITextField * creditCardCVVTextField;

@property(nonatomic,retain) IBOutlet UILabel * totalAmountLabel;

@property(nonatomic,retain) IBOutlet UITableView * dancesPaymentTable;
@property(nonatomic,retain) NSMutableArray * dancesPaymentArray;
@property(nonatomic,retain) NSMutableArray * selectedDancersArray;

@property(nonatomic,retain) NSArray * minsPerDanceOptions;

@property(nonatomic,retain) Dancer * currentDancer;

@property(nonatomic,retain) NSMutableArray * dancesPaymentDetails;
@property(nonatomic, strong)VIPDacneViewController *vipDanceViewController;
@property(nonatomic, strong)  UIPopoverController *vipPopOverController;
@property(nonatomic, retain) IBOutlet UIButton * vipDanceButton;
//@property(nonatomic, retain) IBOutlet UIButton * houseFeeButton;
@property(nonatomic, retain) NSMutableData *myMutableData;
@property(nonatomic,retain) IBOutlet UILabel * deviceStatus;
-(IBAction)didChangeSegmentControl:(UISegmentedControl *)control;
-(IBAction)payNowButtonPressed:(id)sender;

-(IBAction)creditCartButtonPressed:(id)sender;
-(IBAction)cashButtonPressed:(id)sender;
-(IBAction)voucherButtonPressed:(id)sender;
-(void) dismissAddDancerPopover;

-(void) minusDancerPriceButtonPressed:(id)sender;
-(void) addDancerPriceButtonPressed:(id)sender;
-(void) saveDancers;
-(IBAction) animatePicker:(id) sender;
-(void) dismissPicker;
-(void) calculatePaymentDetails;
- (void)beginTransaction;
- (IBAction)settingButtonTapped:(id)sender;

+ (BOOL)checkReachabilityForHost:(NSString *)host;
- (IBAction)vipDanceButtonTapped:(id)sender;

- (IBAction)MegTekDemoTapped:(id)sender;
- (IBAction)voucherAmountButtonTapped:(id)sender;
- (void) clearLabels;
- (void) openDevice;
- (void) closeDevice;
- (void) displayData;
- (void) devConnStatusChange;

+(NSString*)getPortName;
+(void)setPortName:(NSString *)m_portName;
+(NSString*)getPortSettings;
+(void)setPortSettings:(NSString *)m_portSettings;
+(NSString *)HTMLCSS;

-(IBAction)OpenCashDrawer;
-(IBAction)GetStatus;
-(IBAction)Barcode;
-(IBAction)Barcode2D;
-(IBAction)Cut;
-(IBAction)FormatedText;
-(IBAction)TextRasterPrinting;
-(IBAction)showHelp;
-(IBAction)DisablePortNumber;
-(IBAction)PreformMCR;
-(IBAction)FormatedJpKanji;
-(void)SetPortInfo;

@end
