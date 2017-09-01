//
//  RotaryKnob.m
//  Landmann
//
//  Created by Wang on 21.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "RotaryKnob.h"
#import "RotaryKnobGestureRecognizer.h"
#import <QuartzCore/QuartzCore.h>


#define KNOB_SIZE CGSizeMake(131,131)
#define KNOB_BOTTOM_MARGIN 15
#define DOT_SIZE 4
#define DOT_COLOR [UIColor redColor]
#define DOT_DISTANCE 50
#define ROTATION_ANGLE_MIN 48 // degrees
#define ROTATION_ANGLE_MAX 138 // degrees
#define RADIUS_TOLERANCE_PERCENT 70
#define RADIUS_BEGIN_TOLERANCE_PERCENT 40
#define MAJOR_TICK_DIST (360.0 - 90.0) / 4
#define MINOR_TICK_ANGLE_MIN 135
#define MINOR_TICK_ANGLE_MAX 405
#define MINOR_TICK_DIST (360.0 - 90.0) / 20
#define MINOR_TICK_RADIUS_PERCENT 15
#define MINOR_TICK_WIDTH 2
#define MINOR_TICK_LENGTH 10
#define SNAP_ANGLE_OFFSET 1

#define COLOR_RED [UIColor colorWithRed:0.85 green:0 blue:0 alpha:1.0]
#define COLOR_BLACK [UIColor colorWithWhite:0.3 alpha:1.0]

#define FONT [UIFont fontWithName:@"Helvetica-Bold" size:13.0]
#define MAJOR_TICK_LABELS {@"20", @"30", @"40", @"50", @"60"}
#define MAJOR_TICK_LABEL_RADIUS_PERCENT 20
#define MAJOR_TICK_LABEL_POSITIONS {{60,172},{48,62},{144,3},{238,62},{228,172}}

#define DEFAULT_INDEX 1


float degreesToRadians(float degrees) {
    
    return (degrees / 360.0) * 2 * M_PI;
}



@implementation RotaryKnob


@synthesize delegate;
@synthesize value = _snapIndex;


- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _knobImage = [UIImage imageNamed:@"knob.png"];
        
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        CGSize knobSize = KNOB_SIZE;
        _knobRect = CGRectMake(
                               floor((self.bounds.size.width - knobSize.width) * 0.5),
                               self.bounds.size.height - knobSize.height - KNOB_BOTTOM_MARGIN,
                               KNOB_SIZE.width,
                               KNOB_SIZE.height
                               );
        _radius = floor(_knobRect.size.width * 0.5);
        _maxDistance = _radius * (1 + (RADIUS_TOLERANCE_PERCENT * 0.01));
        _beginDistance = _radius * (1 + (RADIUS_BEGIN_TOLERANCE_PERCENT * 0.01));
        _knobCenter = CGPointMake(
                                  _knobRect.origin.x + _knobRect.size.width * 0.5,
                                  _knobRect.origin.y + _knobRect.size.height * 0.5
                                  );
        _rotationMin = degreesToRadians(ROTATION_ANGLE_MIN);
        _rotationMax = degreesToRadians(ROTATION_ANGLE_MAX);
        _majorTickDist = degreesToRadians(MAJOR_TICK_DIST);
        _majorTickLabels = new NSString* [5] MAJOR_TICK_LABELS;
        _majorTickLabelRadius = _radius * (1 + (MAJOR_TICK_LABEL_RADIUS_PERCENT * 0.01));
        _majorTickLabelPositions = new CGPoint[5] MAJOR_TICK_LABEL_POSITIONS;
        _minorTickDist = degreesToRadians(MINOR_TICK_DIST);
        _minorTickRadius = _radius * (1 + (MINOR_TICK_RADIUS_PERCENT * 0.01));
        _minorTickAngleMin = degreesToRadians(MINOR_TICK_ANGLE_MIN);
        _minorTIckAngleMax = degreesToRadians(MINOR_TICK_ANGLE_MAX);
        
        _snapAngleOffset = degreesToRadians(SNAP_ANGLE_OFFSET);
        
//        NSLog(@"rotation min: %f, max: %f", _rotationMin, _rotationMax);
//        NSLog(@"major tick dst: %f", _majorTickDist);
        
        RotaryKnobGestureRecognizer* recognizer = [[RotaryKnobGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        
        _currentRadians = _rotationMax + (DEFAULT_INDEX * _majorTickDist);
        _snapIndex = DEFAULT_INDEX;
    }
    
    return self;
}


- (void) drawRect:(CGRect)rect {
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    CGSize knobSize = KNOB_SIZE;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);

    [_knobImage drawInRect:_knobRect];
    
    
    // dot position
    
    float sin = sinf(_currentRadians);
    float cos = cosf(_currentRadians);
    float dotDiffX = cos * (DOT_DISTANCE - DOT_SIZE * 0.5);
    float dotDiffY = sin * (DOT_DISTANCE - DOT_SIZE * 0.5);
    CGPoint dotPosition = {
        _knobCenter.x + dotDiffX,
        _knobCenter.y + dotDiffY
    };
    CGRect dotRect = {dotPosition, {DOT_SIZE, DOT_SIZE}};
    
    CGContextSetFillColorWithColor(context, COLOR_RED.CGColor);
    CGContextFillEllipseInRect(context, dotRect);
    
    
    // major ticks

    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);

    //////////
    CGSize positionOffset = CGSizeMake(-10, -3);
    //////////
    
    for (uint i = 0; i < 5; ++i) {
        
        float angle = _rotationMax + (i * _majorTickDist);
        
//        NSLog(@"angle: %f", angle);
        
        CGRect tickRect = {
            _knobCenter.x + cosf(angle) * _majorTickLabelRadius,
            _knobCenter.y + sinf(angle) * _majorTickLabelRadius,
            4,
            4
        };
        
//        CGContextFillEllipseInRect(context, tickRect);

        NSString* label = _majorTickLabels[i];
        CGPoint position = _majorTickLabelPositions[i];
        position.x += positionOffset.width;
        position.y += positionOffset.height;

//        CGColorRef color = (i == _snapIndex) ? COLOR_RED.CGColor : COLOR_BLACK.CGColor;
        
        CGColorRef color = COLOR_BLACK.CGColor;
        
        CGContextSetFillColorWithColor(context, color);

//        float radians = (_currentRadians < _rotationMin) ? _currentRadians + 2 * M_PI : _currentRadians;
//        
//        if (angle <= 2 * M_PI && angle < radians) {
//            
//            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
//        }
//        else if (angle > 2 * M_PI && angle < radians) {
//            
//            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
//        }
//        else {
//            
//            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
//        }
        
        [label drawAtPoint:position withFont:FONT];
        
    }
    
    
    // minor ticks
    
    CGContextSetLineWidth(context, MINOR_TICK_WIDTH);
//    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);

    
    for (uint i = 0; i <= 20; ++i) {
        
        float angle = _minorTickAngleMin + (i * _minorTickDist);

        CGPoint startPoint = CGPointMake(_knobCenter.x + cosf(angle) * _minorTickRadius, _knobCenter.y + sinf(angle) * _minorTickRadius);
        float sin = sinf(angle);
        float cos = cosf(angle);
        CGPoint endPoint;
        endPoint.x = startPoint.x + cos * MINOR_TICK_LENGTH;
        endPoint.y = startPoint.y + sin * MINOR_TICK_LENGTH;
        
        CGMutablePathRef linePath = CGPathCreateMutable();
        CGPathMoveToPoint(linePath, NULL, startPoint.x, startPoint.y);
        CGPathAddLineToPoint(linePath, NULL, endPoint.x, endPoint.y);
        
        float radians = (_currentRadians < _rotationMin) ? _currentRadians + 2 * M_PI : _currentRadians;
        
        if (angle <= 2 * M_PI && angle - _snapAngleOffset < radians) {
            
            CGContextSetStrokeColorWithColor(context, COLOR_RED.CGColor);
        }
        else if (angle > 2 * M_PI && angle - _snapAngleOffset < radians) {
            
            CGContextSetStrokeColorWithColor(context, COLOR_RED.CGColor);
        }
        else {
            
            CGContextSetStrokeColorWithColor(context, COLOR_BLACK.CGColor);
        }
        
//        NSLog(@"%d: angle: %f, currentRadians: %f, angle2: %f", i, angle, _currentRadians, (angle - (2 * M_PI)));
        
        
        CGContextAddPath(context, linePath);
        CGContextStrokePath(context);
        
//        CGRect tickRect = CGRectMake(
//                                     _knobCenter.x + cosf(angle) * _minorTickRadius,
//                                     _knobCenter.y + sinf(angle) * _minorTickRadius,
//                                     4,
//                                     4
//        );
//        
//        CGContextFillEllipseInRect(context, tickRect);

    }
}


#pragma mark

- (void) setAge:(uint)age {
    
    [self snapInForIndex:age];
}



#pragma mark Private methods 

- (BOOL) locationInsideKnob:(CGPoint) location {
    
    if ([self distanceToCenterForLocation:location] > _beginDistance) {
        
        return NO;
    }
    else return YES;
}


- (float) distanceToCenterForLocation:(CGPoint) location {


    
    float diffX = location.x - _knobCenter.x;
    float diffY = location.y - _knobCenter.y;
    float hypo = hypotf(diffX, diffY);
    
    return hypo;
}


- (BOOL) locationInsideTolerance:(CGPoint) location {
    
    if ([self distanceToCenterForLocation:location] > _maxDistance) {
        
        return NO;
    }
    else return YES;
}


- (void) touchLocationChanged:(CGPoint) location {
    
    float touchAngle = [self angleForLocation:location];

    float newAngle = touchAngle - _angleDiff;
    newAngle = fmodf(newAngle + 2 * M_PI, 2 * M_PI);
    
    if (newAngle > _rotationMin && newAngle < _rotationMax) {
        
        _angleDiff = [self angleDiffForLocation:location];
        
        return;
    }
    
//    NSLog(@"newAngle: %f", newAngle);

    _currentRadians = newAngle;

    [self setNeedsDisplay];
}


- (float) angleForLocation:(CGPoint) location {
    
    float diffX = location.x - _knobCenter.x;
    float diffY = location.y - _knobCenter.y;
    float hypo = hypotf(diffX, diffY);
    
    float radians = acosf(diffX / hypo);
    
    if (diffY < 0) {
        
        radians = M_PI + (M_PI - radians);
    }
    
    return radians;
}


- (float) angleDiffForLocation:(CGPoint) location {
    
    return fmodf([self angleForLocation:location] - _currentRadians, 2 * M_PI);
}


- (void) snapInForLocation:(CGPoint) location {
    
    float minDistance = MAXFLOAT;
    float snapAngle;
    float snapIndex;
    float radians;
    
    for (uint i = 0; i <= 20; ++i) {
        
        radians = (_currentRadians < _rotationMin) ? _currentRadians + 2 * M_PI : _currentRadians;

        float angle = _minorTickAngleMin + (i * _minorTickDist);
        float distance = ABS(angle - radians);
        
//        NSLog(@"angle: %f, distance: %f, radians: %f", angle, distance, radians);
        
        if (distance < minDistance) {
            
            minDistance = distance;
            snapAngle = angle;
            snapIndex = i;

//            NSLog(@"new snapAngle: %f", snapAngle);
        }
    }
    
    _currentRadians = fmodf(snapAngle, 2 * M_PI);
    _snapIndex = snapIndex;
    
    [self setNeedsDisplay];
    
    if ([delegate respondsToSelector:@selector(rotaryKnob:didChangeToValue:)]) {
        [delegate rotaryKnob:self didChangeToValue:snapIndex];
    }
}


- (void) snapInForIndex:(uint) index {
    
    float snapAngle = _minorTickAngleMin + (index * _minorTickDist);
    _currentRadians = fmodf(snapAngle, 2 * M_PI);
    _snapIndex = index;
    
    [self setNeedsDisplay];
}



#pragma mark Delegate Methods

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (gestureRecognizer.state == UIGestureRecognizerStatePossible &&
        [self locationInsideKnob:[touch locationInView:self]]) {
        
        return TRUE;
    }
    else if ((gestureRecognizer.state == UIGestureRecognizerStateBegan ||
              gestureRecognizer.state == UIGestureRecognizerStateChanged) &&
             [self locationInsideTolerance:[touch locationInView:self]]) {
        
        return TRUE;
    }
    else return FALSE;
}


- (void) handleGesture:(UIGestureRecognizer*) recognizer {
    
    switch (recognizer.state) {

        case UIGestureRecognizerStateBegan:
//            NSLog(@"began");
            _angleDiff = [self angleDiffForLocation:[recognizer locationInView:self]];
//            NSLog(@"touchAngle: %f, _currentRadians: %f, angleDiff: %f", [self angleForLocation:[recognizer locationInView:self]], _currentRadians, _angleDiff);
            break;
        
        case UIGestureRecognizerStateChanged:
//            NSLog(@"changed");
            [self touchLocationChanged:[recognizer locationInView:self]];
            break;
            
        case UIGestureRecognizerStateEnded:
//            NSLog(@"ended");
            [self snapInForLocation:[recognizer locationInView:self]];
            break;
            
        default:
            break;
    }
    
}


//- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    
//    
//}


@end
