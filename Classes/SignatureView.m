//
//  SignatureView.m
//  test
//
//  Created by Asad Khan on 10/24/11.
//  Copyright (c) 2011 Semantic Notion Inc. All rights reserved.
//

#import "SignatureView.h"
#import "SignatureViewController.h"



@implementation SignatureView

@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        self.multipleTouchEnabled = NO;
        
    }
    return self;
}

//override the touch handler
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	if ([delegate respondsToSelector:@selector(touchesBegan:withEvent:)])
        [delegate touchesBegan:touches withEvent:event];
}



-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	if ([delegate respondsToSelector:@selector(touchesEnded:withEvent:)])
        [delegate touchesEnded:touches withEvent:event];    
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
 	[super touchesMoved:touches withEvent:event];
	if ([delegate respondsToSelector:@selector(touchesMoved:withEvent:)])
        [delegate touchesMoved:touches withEvent:event];
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
