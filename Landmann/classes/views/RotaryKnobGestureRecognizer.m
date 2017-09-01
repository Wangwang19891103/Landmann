//
//  RotaryKnobGestureRecognizer.m
//  Landmann
//
//  Created by Wang on 21.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "RotaryKnobGestureRecognizer.h"

@implementation RotaryKnobGestureRecognizer


#pragma mark Subclass

- (void) reset {
    
    [super reset];
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    if ([self.delegate respondsToSelector:@selector(gestureRecognizer:shouldReceiveTouch:)] &&
        ![self.delegate gestureRecognizer:self shouldReceiveTouch:[touches anyObject]]) {       // bad
        
        return;
    }
    else if ([touches count] != 1) {
        
        self.state = UIGestureRecognizerStateFailed;
        
        return;
    }
    else {
        
        _startPoint = [[touches anyObject] locationInView:self.view];
        
        self.state = UIGestureRecognizerStateBegan;
    }
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesMoved:touches withEvent:event];
    
    if (self.state == UIGestureRecognizerStateFailed) {
        
        return;
    }
    else if ([self.delegate respondsToSelector:@selector(gestureRecognizer:shouldReceiveTouch:)] &&
             ![self.delegate gestureRecognizer:self shouldReceiveTouch:[touches anyObject]]) {       // bad
        
        self.state = UIGestureRecognizerStateEnded;
        
        return;
    }
    
    
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateEnded;
}


- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesCancelled:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateCancelled;
}


@end
