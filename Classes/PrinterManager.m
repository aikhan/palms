//
//  PrinterManager.m
//  MagTekDemo
//
//  Created by Asad Khan on 6/2/12.
//  Copyright (c) 2012 Semantic Notion Inc. All rights reserved.
//

#import "PrinterManager.h"
#import <StarIO/Port.h>
#import <sys/time.h>
#import "RasterDocument.h"
#import "StarBitmap.h"

static PrinterManager* sharedInstance = nil;

@interface PrinterManager()

@property (nonatomic, retain) NSMutableData* commands;

@end

@implementation PrinterManager

@synthesize commands;

#pragma mark -
#pragma mark Initialization

+ (PrinterManager*) shared
{
    if (sharedInstance == nil)
		sharedInstance = [[PrinterManager alloc] init];
	
	return sharedInstance;
}

- (void) dealloc
{
    self.commands = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Printer Operations

- (void) printTextWithPortname: (NSString*)      portName 
                  portSettings: (NSString*)      portSettings 
                      commands: (NSMutableData*) _commands
{
    self.commands = _commands;
    int commandSize = [commands length];
    unsigned char* dataToSentToPrinter = (unsigned char*)malloc(commandSize);
    [commands getBytes:dataToSentToPrinter];
    
    Port *starPort = nil;
    @try {
        starPort = [Port getPort:portName :portSettings :5000];
        
        if(starPort == nil)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Fail to Open Port" 
                                                            message: @""
                                                           delegate: nil 
                                                  cancelButtonTitle: @"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
        
        struct timeval endTime;
        gettimeofday(&endTime, NULL);
        endTime.tv_sec += 30;
        
        int totalAmountWritten = 0;
        while(totalAmountWritten < commandSize)
        {
            int amountWritten = [starPort writePort:dataToSentToPrinter :totalAmountWritten :commandSize];
            totalAmountWritten += amountWritten;
            
            struct timeval now;
            gettimeofday(&now, NULL);
            if(now.tv_sec > endTime.tv_sec)
            {
                break;
            }
        }
        if(totalAmountWritten < commandSize)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Printer Error" 
                                                            message: @"Write port timed out"
                                                           delegate: nil 
                                                  cancelButtonTitle: @"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        
    }
    @catch (PortException* exception)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Printer Error" 
                                                        message: @"Write port timed out"
                                                       delegate: nil 
                                              cancelButtonTitle: @"OK" 
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    @finally
    {
        [Port releasePort:starPort];
    }
    free(dataToSentToPrinter);
}

- (void) openCashDrawerWithPortname: (NSString*) portName 
                       portSettings: (NSString*) portSettings
{
    Port *starPort = NULL;
    @try
    {
        starPort = [Port getPort:portName :portSettings :5000];
        if(starPort == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail to Open Port" 
                                                            message:@""
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
        unsigned char opencashdrawer_command[] = {0x07};
        int totalAmountWritten = [starPort writePort:opencashdrawer_command :0 :1];
        if(totalAmountWritten == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Printer Error" 
                                                            message:@"data not written out"
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        
    }
    @catch (PortException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Printer Error" 
                                                        message:@"Write port timed out"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    @finally 
    {
        [Port releasePort:starPort];
    }
}
/**
 * This function is used to print a uiimage directly to the printer.
 * There are 2 ways a printer can usually print images, one is through raster commands the other is through line mode commands
 * This function uses raster commands to print an image.  Raster is support on the tsp100 and all legacy thermal printers
 * The line mode printing is not supported by the tsp100 so its not used
 * portName - Port name to use for communication. This should be (TCP:<IPAddress>)
 * portSettings - Should be blank
 * source - the uiimage to convert to star raster data
 * maxWidth - the maximum with the image to print.  This is usually the page with of the printer.  If the image exceeds the maximum width then the image is scaled down.  The ratio is maintained. 
 */
+(void)PrintImageWithPortname:(NSString *)portName portSettings: (NSString*)portSettings imageToPrint: (UIImage*)imageToPrint maxWidth: (int)maxWidth
{
    RasterDocument *rasterDoc = [[RasterDocument alloc] initWithDefaults:RasSpeed_Medium endOfPageBehaviour:RasPageEndMode_FeedAndFullCut endOfDocumentBahaviour:RasPageEndMode_FeedAndFullCut topMargin:RasTopMargin_Standard pageLength:0 leftMargin:0 rightMargin:0];
    StarBitmap *starbitmap = [[StarBitmap alloc] initWithUIImage:imageToPrint :maxWidth :false];
    
    NSMutableData *commandsToPrint = [[NSMutableData alloc]init];
    NSData *shortcommand = [rasterDoc BeginDocumentCommandData];
    [commandsToPrint appendData:shortcommand];
    
    shortcommand = [starbitmap getImageDataForPrinting];
    [commandsToPrint appendData:shortcommand];
    
    shortcommand = [rasterDoc EndDocumentCommandData];
    [commandsToPrint appendData:shortcommand];
    
    int commandSize = [commandsToPrint length];
    unsigned char *dataToSentToPrinter = (unsigned char*)malloc(commandSize);
    [commandsToPrint getBytes:dataToSentToPrinter];
    
    Port *starPort = nil;
    @try {
        starPort = [Port getPort:portName :portSettings :5000];
        
        if(starPort == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail to Open Port" 
                                                            message:@""
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
        
        struct timeval endTime;
        gettimeofday(&endTime, NULL);
        endTime.tv_sec += 30;
        
        int totalAmountWritten = 0;
        while(totalAmountWritten < commandSize)
        {
            int amountWritten = [starPort writePort:dataToSentToPrinter :totalAmountWritten :commandSize];
            totalAmountWritten += amountWritten;
            
            struct timeval now;
            gettimeofday(&now, NULL);
            if(now.tv_sec > endTime.tv_sec)
            {
                break;
            }
        }
        if(totalAmountWritten < commandSize)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Printer Error" 
                                                            message:@"Write port timed out"
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        
    }
    @catch (PortException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Printer Error" 
                                                        message:@"Write port timed out"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    @finally
    {
        [Port releasePort:starPort];
    }
    
    free(dataToSentToPrinter);
    [commandsToPrint release];
    [starbitmap release];
    [rasterDoc release];
}

@end