//
//  ExtendedButton.h
//  Palms
//
//  Created by Saleh Shah on 5/11/12.
//  Copyright (c) 2012 Semantic Notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dancer.h"

@interface ExtendedButton : UIButton {
    
    Dancer * dancer;
    UILabel * dancesLabel;
}

@property(nonatomic,retain) Dancer * dancer;
@property(nonatomic,retain) UILabel * dancesLabel;

@end
