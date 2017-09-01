//
//  KeyboardWatcher.m
//  Landmann
//
//  Created by Wang on 30.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "KeyboardWatcher.h"

@implementation KeyboardWatcher


@synthesize delegate;


- (id) init {
    
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];

    }
    
    return self;
}


- (void) keyboardWillShow {
    
    if ([delegate respondsToSelector:@selector(keyboardWillShow)]) {
        
        [delegate keyboardWillShow];
    }
}


- (void) keyboardDidShow {

    if ([delegate respondsToSelector:@selector(keyboardDidShow)]) {
        
        [delegate keyboardDidShow];
    }
}


- (void) keyboardWillHide {
    
    if ([delegate respondsToSelector:@selector(keyboardWillHide)]) {
        
        [delegate keyboardWillHide];
    }
}


- (void) keyboardDidHide {
    
    if ([delegate respondsToSelector:@selector(keyboardDidHide)]) {
        
        [delegate keyboardDidHide];
    }
}


- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
