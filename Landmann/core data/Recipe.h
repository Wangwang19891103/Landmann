//
//  Recipe.h
//  Landmann
//
//  Created by Wang on 04.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IngredientEntry, Keyword, Note, RecipeCategory;

@interface Recipe : NSManagedObject

@property (nonatomic) int16_t difficulty;
@property (nonatomic) int16_t grillType;
@property (nonatomic, retain) NSString * imageFull;
@property (nonatomic, retain) NSString * imageThumb;
@property (nonatomic) int16_t number;
@property (nonatomic) int16_t price;
@property (nonatomic, retain) NSString * text;
@property (nonatomic) float time1;
@property (nonatomic) float time2;
@property (nonatomic) float time3;
@property (nonatomic, retain) NSString * title;
@property (nonatomic) int16_t persons;
@property (nonatomic, retain) NSString * tip;
@property (nonatomic, retain) RecipeCategory *category;
@property (nonatomic, retain) NSSet *ingredients;
@property (nonatomic, retain) NSSet *keywords;
@property (nonatomic, retain) Note *note;
@end

@interface Recipe (CoreDataGeneratedAccessors)

- (void)addIngredientsObject:(IngredientEntry *)value;
- (void)removeIngredientsObject:(IngredientEntry *)value;
- (void)addIngredients:(NSSet *)values;
- (void)removeIngredients:(NSSet *)values;

- (void)addKeywordsObject:(Keyword *)value;
- (void)removeKeywordsObject:(Keyword *)value;
- (void)addKeywords:(NSSet *)values;
- (void)removeKeywords:(NSSet *)values;

@end
