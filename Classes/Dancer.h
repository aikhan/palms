//
//  Dancer.h
//  Palms
//
//  Created by Saleh Shah on 5/11/12.
//  Copyright (c) 2012 Semantic Notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dancer : NSObject <NSCoding> {
    
    NSString * dancerName;
    NSString * pricePerDance;
    NSMutableArray * minsPerPrice;
    NSString * dances;
    NSString * houseFee;
    NSMutableArray *dancerPaid;
    NSNumber *totalFee;
    
}

-(id) initWithDancerName:(NSString*)dName pricePerDance:(NSString*)price minsPerPrice:(NSMutableArray*)mins dances:(NSString*)dancesLocal houseFee:(NSString*)houseF withTotalFee:(NSNumber*)totalfee andDancerPaid:(NSMutableArray*)dancerPay;

@property(nonatomic,retain) NSString * dancerName;
@property(nonatomic,retain) NSString * pricePerDance;
@property(nonatomic,retain) NSMutableArray * minsPerPrice;
@property(nonatomic,retain) NSString * dances;
@property(nonatomic,retain) NSString * houseFee;
@property(nonatomic,retain) NSMutableArray * dancerPaid;
@property(nonatomic,retain) NSNumber *totalFee;

@end
