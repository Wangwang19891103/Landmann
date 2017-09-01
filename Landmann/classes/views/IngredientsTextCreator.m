//
//  IngredientsTextCreator.m
//  Landmann
//
//  Created by Wang on 24.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "IngredientsTextCreator.h"
#import "FloatFormatter.h"


@implementation IngredientsTextCreator


+ (NSString*) textFromIngredients:(NSArray*) ingredients {

    NSMutableString* outputString = [NSMutableString string];
    
    for (NSArray* ingArray in ingredients) {

        NSString* rowString = @"";
        
        NSString* title = [ingArray objectAtIndex:0];
        float amount = [[ingArray objectAtIndex:1] floatValue];
        NSString* unit = [ingArray objectAtIndex:2];

        // COL 1
        
        NSString* string1 = nil;

        if (amount != 0) {

            string1 = [NSString stringWithFormat:@"%@%@", [FloatFormatter stringForFloat:amount], (unit.length > 0) ? [NSString stringWithFormat:@" %@", unit] : @""];
        }

//        rowString = [rowString stringByAppendingFormat:@"%@ %@\n", string1, title];
        
        NSMutableArray* comps = [NSMutableArray array];
        if (string1) [comps addObject:string1];
        [comps addObject:title];
        
        rowString = [rowString stringByAppendingFormat:@"%@\n",
                     [comps componentsJoinedByString:@" "]
                     ];
        
        [outputString appendString:rowString];
    }
    
    return outputString;
}





@end
