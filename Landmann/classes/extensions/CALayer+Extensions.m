//
//  CALayer+Extensions.m
//  Landmann
//
//  Created by Wang on 03.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "CALayer+Extensions.h"

@implementation CALayer (Extensions)

+ (CALayer*) maskLayerWithSize:(CGSize)size roundedCornersTop:(BOOL)top bottom:(BOOL)bottom left:(BOOL)left right:(BOOL)right radius:(float)radius {
    
    CALayer* layer = [CALayer layer];
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    
//    CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
//    CGPathCloseSubpath(path);
    
    // top left
    if (top || left) {
        CGPathMoveToPoint(path, NULL, 0, radius);
        CGPathAddArcToPoint(path, NULL, 0, 0, radius, 0, radius);
    }
    else {
        CGPathMoveToPoint(path, NULL, 0, 0);
    }
    
    // top right
    if (top || right) {
        CGPathAddLineToPoint(path, NULL, size.width - radius, 0);
        CGPathAddArcToPoint(path, NULL, size.width, 0, size.width, radius, radius);
    }
    else {
        CGPathAddLineToPoint(path, NULL, size.width, 0);
    }

    // bottom right
    if (bottom || right) {
        CGPathAddLineToPoint(path, NULL, size.width, size.height - radius);
        CGPathAddArcToPoint(path, NULL, size.width, size.height, size.width - radius, size.height, radius);
    }
    else {
        CGPathAddLineToPoint(path, NULL, size.width, size.height);
    }

    // bottom left
    if (bottom || right) {
        CGPathAddLineToPoint(path, NULL, radius, size.height);
        CGPathAddArcToPoint(path, NULL, 0, size.height, 0, size.height - radius, radius);
    }
    else {
        CGPathAddLineToPoint(path, NULL, 0, size.height);
    }
    
    // back
    if (top || left) {
        CGPathAddLineToPoint(path, NULL, 0, radius);
    }
    else {
        CGPathAddLineToPoint(path, NULL, 0, 0);
    }

    CGPathCloseSubpath(path);

    
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextEOFillPath(context);
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    layer.contents = (id)image.CGImage;
    
    return layer;
}


@end
