//
//  CALayer+Extensions.h
//  Landmann
//
//  Created by Wang on 03.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CALayer (Extensions)

+ (CALayer*) maskLayerWithSize:(CGSize) size roundedCornersTop:(BOOL) top                                     bottom:(BOOL) bottom                                       left:(BOOL) left                                      right:(BOOL) right
radius:(float) radius;

@end
