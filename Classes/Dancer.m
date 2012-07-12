//
//  Dancer.m
//  Palms
//
//  Created by Saleh Shah on 5/11/12.
//  Copyright (c) 2012 Semantic Notion. All rights reserved.
//

#import "Dancer.h"

@implementation Dancer

@synthesize dancerName,pricePerDance,minsPerPrice,dances,houseFee, totalFee, dancerPaid;

-(id) initWithDancerName:(NSString*)dName pricePerDance:(NSString*)price minsPerPrice:(NSMutableArray*)mins dances:(NSString*)dancesLocal houseFee:(NSString*)houseF withTotalFee:(NSNumber*)totalfee andDancerPaid:(NSMutableArray *)dancerPay
{
    self = [super init];
    if (self) {
        
        self.dancerName = dName;
        self.pricePerDance = price;
        self.minsPerPrice = mins;
        self.dances = dancesLocal;
        self.houseFee = houseF;
        self.totalFee = totalfee;
        self.dancerPaid = dancerPay;
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.dancerName forKey:@"dancerName"];
    [coder encodeObject:self.pricePerDance forKey:@"pricePerDance"];
    [coder encodeObject:self.minsPerPrice forKey:@"minsPerPrice"];
    [coder encodeObject:self.dances forKey:@"dances"];
    [coder encodeObject:self.houseFee forKey:@"houseFee"];
    [coder encodeObject:self.totalFee forKey:@"totalFee"];
    [coder encodeObject:self.dancerPaid forKey:@"dancerPaid"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[Dancer alloc] init];
    if (self != nil)
    {
        self.dancerName = [coder decodeObjectForKey:@"dancerName"];
        self.pricePerDance = [coder decodeObjectForKey:@"pricePerDance"];
        self.minsPerPrice = [coder decodeObjectForKey:@"minsPerPrice"];
        self.dances = [coder decodeObjectForKey:@"dances"];
        self.houseFee = [coder decodeObjectForKey:@"houseFee"];
        self.totalFee = [coder decodeObjectForKey:@"totalFee"];
        self.dancerPaid = [coder decodeObjectForKey:@"dancerPaid"];
    }   
    return self;
}

@end
