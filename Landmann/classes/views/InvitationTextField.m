//
//  InvitationTextField.m
//  Landmann
//
//  Created by Wang on 29.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "InvitationTextField.h"

@implementation InvitationTextField


@synthesize delegate;
@synthesize background;
@synthesize textField;


- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = (InvitationTextField*)[super initWithCoder:aDecoder]) {
        
        _background = [resource(@"Images.Invitations.Edit.Form.TextField.Background") resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
        _backgroundSelected = [resource(@"Images.Invitations.Edit.Form.TextField.BackgroundSelected") resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    }
    
    return self;
}
        

- (id) awakeAfterUsingCoder:(NSCoder *)aDecoder {
    
    if (self.subviews.count == 0) {
        
        InvitationTextField* field = [[[NSBundle mainBundle] loadNibNamed:@"InvitationTextField" owner:nil options:nil] firstElement];
        
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
    
    if ([textField isFirstResponder]) {
    
        [textField resignFirstResponder];
    }
}


#pragma mark Delegate Methods

- (void) textFieldDidBeginEditing:(UITextField *)textField {

    if ([delegate respondsToSelector:@selector(invitationTextFieldDidBeginEditing:)]) {
        
        [delegate invitationTextFieldDidBeginEditing:self];
    }
    
    [self setSelected:true];
    
    if (textField.text.length > 0) {
        
        [textField selectAll:self];
    }
}


- (void) textFieldDidEndEditing:(UITextField *)textField {
    
    if ([delegate respondsToSelector:@selector(invitationTextFieldDidEndEditing:)]) {
        
        [delegate invitationTextFieldDidEndEditing:self];
    }
    
    [self setSelected:false];
}


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([delegate respondsToSelector:@selector(invitationTextFieldDidChangeValue:)]) {
        
        [delegate invitationTextFieldDidChangeValue:self];
    }
    
    return true;
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return true;
}


@end
