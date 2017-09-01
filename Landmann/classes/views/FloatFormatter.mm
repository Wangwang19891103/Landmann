//
//  FloatFormatter.m
//  Landmann
//
//  Created by Wang on 05.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "FloatFormatter.h"


#define ONE_HALF                0x00BD  // 1/2
#define ONE_QUARTER             0x00BC  // 1/4
#define THREE_QUARTERS          0x00BE  // 3/4
#define ONE_THIRD               0x2153  // 1/3
#define TWO_THIRDS              0x2154  // 2/3
#define ONE_FIFTH               0x2155
#define TWO_FIFTHS              0x2156
#define THREE_FIFTHS            0x2157
#define FOUR_FIRTHS             0x2158
#define ONE_SIXTH               0x2159
#define FIVE_SIXTHS             0x215A
#define ONE_EIGHTH              0x215B
#define THREE_EIGHTHS           0x215C
#define FIVE_EIGHTHS            0x215D
#define SEVEN_EIGHTHS           0x215E
#define ONE_TENTH               0x2152

#define DEFAULT_FORMAT          @"%0.2f"

#define TRUNCATION_PRECISION    2


@implementation FloatFormatter


+ (NSString*) stringForFloat:(float)value {

    uint i = floor(value);
    float rest = value - i;
    rest = truncFloat(rest);
    
    if (rest == 0) return [NSString stringWithFormat:@"%d", i];
    
    unichar c = 0;
    
    if (rest == (float)1 / 2) c = ONE_HALF;
    else if (rest == truncFloat((float)1 / 3)) c = ONE_THIRD;
    else if (rest == truncFloat((float)2 / 3)) c = TWO_THIRDS;
    else if (rest == truncFloat((float)1 / 4)) c = ONE_QUARTER;
    else if (rest == truncFloat((float)3 / 4)) c = THREE_QUARTERS;
    else if (rest == truncFloat((float)1 / 5)) c = ONE_FIFTH;
    else if (rest == truncFloat((float)2 / 5)) c = TWO_FIFTHS;
    else if (rest == truncFloat((float)3 / 5)) c = THREE_FIFTHS;
    else if (rest == truncFloat((float)4 / 5)) c = FOUR_FIRTHS;
    else if (rest == truncFloat((float)1 / 6)) c = ONE_SIXTH;
    else if (rest == truncFloat((float)5 / 6)) c = FIVE_SIXTHS;
    else if (rest == truncFloat((float)1 / 8)) c = ONE_EIGHTH;
    else if (rest == truncFloat((float)3 / 8)) c = THREE_EIGHTHS;
    else if (rest == truncFloat((float)5 / 8)) c = FIVE_EIGHTHS;
    else if (rest == truncFloat((float)7 / 8)) c = SEVEN_EIGHTHS;

//    else if (rest == truncFloat((float)1 / 10)) c = ONE_TENTH;
    else {
     
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 2;
        formatter.minimumIntegerDigits = 1;
        
        return [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
    }
    
    if (i > 0) return [NSString stringWithFormat:@"%d%C", i, c];
    return [NSString stringWithFormat:@"%C", c];
}





+ (void) test {
    
    unichar chars[] = {
        ONE_HALF,
        ONE_THIRD,
        TWO_THIRDS,
        ONE_QUARTER,
        THREE_QUARTERS,
        ONE_FIFTH,
        TWO_FIFTHS,
        THREE_FIFTHS,
        FOUR_FIRTHS,
        ONE_SIXTH,
        FIVE_SIXTHS,
        ONE_TENTH
    };
    
    for (uint i = 0; i < 12; ++i) {
        
        NSLog(@"%C", chars[i]);
    }
}


+ (void) test2 {
    
    for (uint a = 1; a < 6; ++a) {
        
        for (uint b = 1; b < 6; ++b) {
         
            NSLog(@"%@ (%d / %d)", [FloatFormatter stringForFloat:(float)a / b], a , b);
        }
    }
}

@end


float truncFloat(float value) {
    
    uint i = pow(10, TRUNCATION_PRECISION);
    
    return roundf(value * i) / i;
}
