//
//  RotaryKnob.h
//  Landmann
//
//  Created by Wang on 21.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RotaryKnobDelegate.h"

@interface RotaryKnob : UIView <UIGestureRecognizerDelegate> {
    
    UIImage* _knobImage;
    CGRect _knobRect;
    CGPoint _knobCenter;
    float _radius;
    float _maxDistance;
    float _beginDistance;
    float _currentRadians;
    float _rotationMin;
    float _rotationMax;
    float _angleDiff;
    float _majorTickDist;
    NSString* __strong * _majorTickLabels;
    float _majorTickLabelRadius;
    CGPoint* _majorTickLabelPositions;
    float _minorTickDist;
    float _minorTickAngleMin;
    float _minorTIckAngleMax;
    float _minorTickRadius;
    
    float _snapAngleOffset;
    
    uint _snapIndex;
}

@property (nonatomic, assign) IBOutlet id<RotaryKnobDelegate> delegate;

@property (nonatomic, readonly) uint value;


- (void) setAge:(uint) age;

@end
