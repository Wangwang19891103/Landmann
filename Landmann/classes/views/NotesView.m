//
//  NotesView.m
//  Landmann
//
//  Created by Wang on 26.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "NotesView.h"


#define TOUCH_RECT CGRectMake(0, 119, 198, 38)
//#define POSITION_IN CGPointMake(14, 87)
//#define POSITION_OUT CGPointMake(14, 202)
#define POSITION_IN_Y ((is_ipad)?138:87)
#define POSITION_OUT_Y ((is_ipad)?343:202)
#define ANIMATION_DURATION 0.5


@implementation NotesView


@synthesize delegate;
@synthesize textView;
@synthesize toggleButton;
@synthesize indicator;


- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {

        _isOut = false;
        
//        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}


- (IBAction) handleTap {

    [self toggle];
}


- (void) toggle {
    
    CGPoint newPosition;
    
    if (_isOut) {
        
        newPosition = CGPointMake(self.frame.origin.x, POSITION_IN_Y);
        textView.userInteractionEnabled = false;
        _isOut = false;
    }
    else {
        
        newPosition = CGPointMake(self.frame.origin.x, POSITION_OUT_Y);
        textView.userInteractionEnabled = true;
        _isOut = true;
    }
    
    [delegate notesView:self willMoveToPosition:newPosition withDuration:ANIMATION_DURATION];
    
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void) {
                         
                         [self setFrameOrigin:newPosition];
                     }
                       completion:nil];
}


- (void) updateIndicator {
    
    BOOL visible = (textView.text.length > 0);
    
    indicator.hidden = !visible;
}




#pragma mark Delegate Methode

- (void) textViewDidBeginEditing:(UITextView *)textView {
    
    [delegate notesViewDidBeginEditing:self];
}


- (void) textViewDidEndEditing:(UITextView *)textView {
    
    [self updateIndicator];
    
    [delegate notesViewDidEndEditing:self];
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    
    return true;
}


- (BOOL) textViewShouldEndEditing:(UITextView *)textView {

    return true;
}


//- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//    return true;
//}


- (void) touchViewDidReceiveTouchOutside:(TouchView *)view {
    

}


- (void) resign {
    
    if ([self.textView isFirstResponder]) {
        
        [self.textView resignFirstResponder];
    }
}



@end
