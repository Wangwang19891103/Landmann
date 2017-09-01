//
//  RecipeInfoBar.m
//  Landmann
//
//  Created by Wang on 26.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "RecipeInfoBar.h"


#define FORMAT_TIME @"%d Min."


@implementation RecipeInfoBar


@synthesize  background;
@synthesize time1Label;
@synthesize time2Label;
@synthesize priceLabel;
@synthesize difficultyImage;


- (id) init {
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"RecipeInfoBar" owner:self options:nil] firstElement];
    
    self.background.image = [resource(@"Images.Recipes.RecipeInfoBar.Background") stretchableImageWithLeftCapWidth:0 topCapHeight:0];

    return self;
}


- (void) setTime1:(uint)time {
    
    self.time1Label.text = [NSString stringWithFormat:FORMAT_TIME, time];
}


- (void) setTime2:(uint)time {
    
    self.time2Label.text = [NSString stringWithFormat:FORMAT_TIME, time];
}


- (void) setPriceLevel:(uint)price {

    NSString* string = @"";
    
    for (uint i = 0; i < price; ++i) {
        string = [string stringByAppendingString:@"+"];
    }

    self.priceLabel.text = string;
}


- (void) setDifficulty:(uint)difficulty {
    
    NSString* name = [NSString stringWithFormat:@"Images.Recipes.RecipeInfoBar.Difficulty.%d", difficulty];
    
    self.difficultyImage.image = resource(name);
}

@end
