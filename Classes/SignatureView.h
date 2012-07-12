//
//  SignatureView.h
//  test
//
//  Created by Asad Khan on 10/24/11.
//  Copyright (c) 2011 Semantic Notion Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TouchViewDelegate <NSObject>

@optional

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end
@interface SignatureView : UIView{
    id delegate;

}

@property (nonatomic, assign) id<TouchViewDelegate> delegate;
@end
