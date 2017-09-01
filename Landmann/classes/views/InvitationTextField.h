//
//  InvitationTextField.h
//  Landmann
//
//  Created by Wang on 29.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvitationTextFieldDelegate.h"


@interface InvitationTextField : UIView <UITextFieldDelegate> {
    
    UIImage* _background;
    UIImage* _backgroundSelected;
}


@property (nonatomic, assign) IBOutlet id<InvitationTextFieldDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIImageView* background;

@property (nonatomic, strong) IBOutlet UITextField* textField;


- (void) resignFirstResponder;

@end
