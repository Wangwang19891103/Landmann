//
//  FavoriteView.m
//  Landmann
//
//  Created by Wang on 27.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "FavoriteView.h"


#define POSITION_IN_Y -44
#define POSITION_OUT_Y 0
#define ANIMATION_DURATION 0.3


@implementation FavoriteView

@synthesize delegate;



- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _isOut = false;
        
        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:recognizer];
        
        [self setFrameY:POSITION_IN_Y];
    }
    
    return self;
}


- (void) handleTap:(UIGestureRecognizer*) recognizer {
    
    [self toggle];
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated {

    if (selected == _isOut) return;
    
    
    float newY;
    
    if (!selected) {
        
        newY = POSITION_IN_Y;
        _isOut = false;
    }
    else {
        
        newY = POSITION_OUT_Y;
        _isOut = true;
    }

    
    if (animated) {

        [UIView animateWithDuration:ANIMATION_DURATION
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^(void) {
                             
                             [self setFrameY:newY];
                         }
                         completion:nil];

        if ([delegate respondsToSelector:@selector(favoriteViewDidGetSelected:)]) {
            
            [delegate favoriteViewDidGetSelected:selected];
        }
    }
    else {

        [self setFrameY:newY];
    }
}


- (void) toggle {
    
    [self setSelected:!_isOut animated:true];
}

@end
