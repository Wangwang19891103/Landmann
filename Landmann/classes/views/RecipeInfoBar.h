//
//  RecipeInfoBar.h
//  Landmann
//
//  Created by Wang on 26.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeInfoBar : UIView

@property (nonatomic, strong) IBOutlet UIImageView* background;

@property (nonatomic, strong) IBOutlet UILabel* time1Label;

@property (nonatomic, strong) IBOutlet UILabel* time2Label;

@property (nonatomic, strong) IBOutlet UILabel* priceLabel;

@property (nonatomic, strong) IBOutlet UIImageView* difficultyImage;


- (void) setTime1:(uint) time;

- (void) setTime2:(uint) time;

- (void) setPriceLevel:(uint) price;

- (void) setDifficulty:(uint) difficulty;

@end
