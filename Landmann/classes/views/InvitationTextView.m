//
//  InvitationTextView.m
//  Landmann
//
//  Created by Wang on 30.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "InvitationTextView.h"

@implementation InvitationTextView


@synthesize delegate;
@synthesize background;
@synthesize textView;


- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = (InvitationTextView*)[super initWithCoder:aDecoder]) {
        
        _background = [resource(@"Images.Invitations.Edit.Form.TextField.Background") resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
        _backgroundSelected = [resource(@"Images.Invitations.Edit.Form.TextField.BackgroundSelected") resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    }
    
    return self;
}


- (id) awakeAfterUsingCoder:(NSCoder *)aDecoder {
    
    if (self.subviews.count == 0) {
        
        InvitationTextView* field = [[[NSBundle mainBundle] loadNibNamed:@"InvitationTextView" owner:nil options:nil] firstElement];
        
        field.frame = self.frame;
        field.autoresizingMask = self.autoresizingMask;
        field.tag = self.tag;
        // ...
        
        return field;
    }
    else
        return self;
}


- (void) setSelected:(BOOL) selected {
    
    UIImage* image = (selected) ? _backgroundSelected : _background;
    
    background.image = image;
}


- (void) didMoveToSuperview {
    
    [super didMoveToSuperview];
    
    if (self.superview) {
        
        background.image = _background;
        
    }
}


- (void) resignFirstResponder {
    
    if ([textView isFirstResponder]) {
        
        [textView resignFirstResponder];
    }
}


#pragma mark Delegate Methods

- (void) textViewDidBeginEditing:(UITextView *)p_textView {
    
    if ([delegate respondsToSelector:@selector(invitationTextViewDidBeginEditing:)]) {
        
        [delegate invitationTextViewDidBeginEditing:self];
    }
    
    [self setSelected:true];
    
    if (textView.text.length > 0) {
        
        [textView performSelector:@selector(selectAll:) withObject:self afterDelay:0.1];
    }
}


- (void) textViewDidEndEditing:(UITextView *)textView {

    if ([delegate respondsToSelector:@selector(invitationTextViewDidEndEditing:)]) {
        
        [delegate invitationTextViewDidEndEditing:self];
    }
    
    [self setSelected:false];
}


- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([delegate respondsToSelector:@selector(invitationTextViewDidChangeValue:)]) {
        
        [delegate invitationTextViewDidChangeValue:self];
    }
    
    return true;
}


@end
