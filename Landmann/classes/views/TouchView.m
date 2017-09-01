//
//  TouchView.m
//  Landmann
//
//  Created by Wang on 26.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView


@synthesize forwardView;
@synthesize observers;


//- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    
//    NSLog(@"point inside");
//    
//    if (forwardView && [forwardView pointInside:point withEvent:event]) {
//            
//        NSLog(@"point inside: point is inside forwardview. returning no.");
//        
//        return false;
//    }
//    else {
//    
//        return [super pointInside:point withEvent:event];
//    }
//}


- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    NSLog(@"hittest");
    
    UIView* view = [super hitTest:point withEvent:event];
    
    if (forwardView) {
        
        NSLog(@"forwardView is set");
        
        CGPoint forwardPoint = [self convertPoint:point toView:forwardView];
        
        if ([forwardView pointInside:forwardPoint withEvent:event]) {
        
            NSLog(@"returning forwardView");
            
            return forwardView;
        }
        else {
            
            NSLog(@"returning nil");
            
            [self notifyObservers];
            
            return nil;
        }
    }
    else {
            
        return view;
    }
}


- (void) notifyObservers {
    
    for (id<TouchViewObserver> observer in self.observers) {
        
        if ([observer respondsToSelector:@selector(touchViewDidReceiveTouchOutside:)]) {
            
            [observer touchViewDidReceiveTouchOutside:self];
        }
    }
}

@end
