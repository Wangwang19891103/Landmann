//
//  IngredientEntry.h
//  Landmann
//
//  Created by Wang on 15.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ingredient, Recipe;

@interface IngredientEntry : NSManagedObject

@property (nonatomic) float amount;
@property (nonatomic) int16_t number;
@property (nonatomic, retain) NSString * title;
@property (nonatomic) float amountMax;
@property (nonatomic, retain) Ingredient *ingredient;
@property (nonatomic, retain) Recipe *recipe;

@end
