//
//  NotesView.h
//  Landmann
//
//  Created by Wang on 26.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotesViewDelegate.h"
#import "TouchViewObserver.h"


@interface NotesView : UIView <UITextViewDelegate, TouchViewObserver> {
    
    BOOL _isOut;
}

@property (nonatomic, strong) IBOutlet UITextView* textView;

@property (nonatomic, assign) IBOutlet id<NotesViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIButton* toggleButton;

@property (nonatomic, strong) IBOutlet UIImageView* indicator;

- (IBAction) handleTap;

- (void) resign;

- (void) updateIndicator;

@end
