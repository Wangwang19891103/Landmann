//
//  IngredientCategory.h
//  Landmann
//
//  Created by Wang on 19.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ingredient;

@interface IngredientCategory : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic) int16_t number;
@property (nonatomic, retain) NSSet *ingredients;
@end

@interface IngredientCategory (CoreDataGeneratedAccessors)

- (void)addIngredientsObject:(Ingredient *)value;
- (void)removeIngredientsObject:(Ingredient *)value;
- (void)addIngredients:(NSSet *)values;
- (void)removeIngredients:(NSSet *)values;

@end
