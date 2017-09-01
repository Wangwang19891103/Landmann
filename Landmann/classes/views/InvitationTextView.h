//
//  InvitationTextView.h
//  Landmann
//
//  Created by Wang on 30.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvitationTextViewDelegate.h"

@interface InvitationTextView : UIView <UITextViewDelegate> {

UIImage* _background;
UIImage* _backgroundSelected;
    
}


@property (nonatomic, assign) IBOutlet id<InvitationTextViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIImageView* background;

@property (nonatomic, strong) IBOutlet UITextView* textView;


- (void) resignFirstResponder;
@end
