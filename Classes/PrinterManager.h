//
//  PrinterManager.h
//  MagTekDemo
//
//  Created by Asad Khan on 6/2/12.
//  Copyright (c) 2012 Semantic Notion Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrinterManager : NSObject

+ (PrinterManager*) shared;

- (void) printTextWithPortname: (NSString*)      portName 
                  portSettings: (NSString*)      portSettings 
                      commands: (NSMutableData*) commands;

- (void) openCashDrawerWithPortname: (NSString*) portName 
                       portSettings: (NSString*) portSettings;
+(void)PrintImageWithPortname:(NSString *)portName portSettings: (NSString*)portSettings imageToPrint: (UIImage*)imageToPrint maxWidth: (int)maxWidth;
@end
