//
//  InvitationTextViewDelegate.h
//  Landmann
//
//  Created by Wang on 30.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InvitationTextView;



@protocol InvitationTextViewDelegate <NSObject>

- (void) invitationTextViewDidBeginEditing:(InvitationTextView*) textView;

- (void) invitationTextViewDidChangeValue:(InvitationTextView*) textView;

- (void) invitationTextViewDidEndEditing:(InvitationTextView*) textView;

@end
