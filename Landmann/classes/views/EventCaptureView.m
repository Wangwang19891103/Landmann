//
//  EventCaptureView.m
//  Landmann
//
//  Created by Wang on 29.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "EventCaptureView.h"


@implementation EventCaptureView


@synthesize delegate;


- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap)];
        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}


- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView* view = [super hitTest:point withEvent:event];

    NSLog(@"EventCaptureView hitTest, view = %@", view);
    
    return view;
}


- (void) actionTap {
    
    NSLog(@"EvenCaptureView tap");
    
    if ([delegate respondsToSelector:@selector(eventCaptureViewWasTapped:)]) {
        
        [delegate eventCaptureViewWasTapped:self];
    }
}





//- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    
//    NSLog(@"hittest");
//    
//    UIView* view = [super hitTest:point withEvent:event];
//    
//    if (forwardView) {
//        
//        NSLog(@"forwardView is set");
//        
//        CGPoint forwardPoint = [self convertPoint:point toView:forwardView];
//        
//        if ([forwardView pointInside:forwardPoint withEvent:event]) {
//            
//            NSLog(@"returning forwardView");
//            
//            return forwardView;
//        }
//        else {
//            
//            NSLog(@"returning nil");
//            
//            [self notifyObservers];
//            
//            return nil;
//        }
//    }
//    else {
//        
//        return view;
//    }
//}

@end
