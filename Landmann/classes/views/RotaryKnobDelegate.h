//
//  RotaryKnobDelegate.h
//  Landmann
//
//  Created by Wang on 22.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RotaryKnob;


@protocol RotaryKnobDelegate <NSObject>

- (void) rotaryKnob:(RotaryKnob*) knob didChangeToValue:(uint) value;

@end
