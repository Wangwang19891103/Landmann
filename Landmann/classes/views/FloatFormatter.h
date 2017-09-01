//
//  FloatFormatter.h
//  Landmann
//
//  Created by Wang on 05.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloatFormatter : NSObject

+ (NSString*) stringForFloat:(float) value;

+ (void) test;
+ (void) test2;

@end


float truncFloat(float value);
