//
//  InvitationTextFieldDelegate.h
//  Landmann
//
//  Created by Wang on 29.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@class InvitationTextField;



@protocol InvitationTextFieldDelegate <NSObject>

- (void) invitationTextFieldDidBeginEditing:(InvitationTextField*) textField;

- (void) invitationTextFieldDidChangeValue:(InvitationTextField*) textField;

- (void) invitationTextFieldDidEndEditing:(InvitationTextField*) textField;

@end
