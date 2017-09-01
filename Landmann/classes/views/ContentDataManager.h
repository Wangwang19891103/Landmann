//
//  ContentDataManager.h
//  Landmann
//
//  Created by Wang on 18.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"
#import "UserRecipe.h"


typedef enum {
    RecipeDifficultyAll = 0,
    RecipeDifficulty1 = 1,
    RecipeDifficulty2 = 2,
    RecipeDifficulty3 = 3,
    RecipeDifficulty4 = 4
} RecipeDifficulty;



@interface ContentDataManager : NSObject


+ (id) instance;


#pragma mark Recipes

- (NSArray*) recipesForCategory:(NSString*) category difficulty:(RecipeDifficulty) difficulty;

- (NSArray*) recipesWithFavoritesForDifficulty:(RecipeDifficulty) difficulty;

- (NSArray*) recipesOnShoppingList;

- (NSArray*) recipesSortedAlhpabetically;

- (Recipe*) recipeWithNumber:(uint) number;

- (void) addRecipe:(Recipe*) recipe toShoppingListWithScale:(uint) scale;

- (BOOL) isRecipeAddedToShoppingList:(Recipe*) recipe;

- (UserRecipe*) userRecipeForRecipe:(Recipe*) recipe;

- (NSArray*) recipesForKeywords:(NSArray*) keywords withDiffculty:(RecipeDifficulty) difficulty;

- (void) deleteRecipeFromShoppingListWithNumber:(uint) number;

- (uint) increaseScaleForRecipe:(Recipe*) recipe;

- (uint) decreaseScaleForRecipe:(Recipe*) recipe;

- (void) deleteShoppingEntries:(NSArray*) entries;

- (UserShoppingEntry*) insertCustomShoppingEntry;

- (void) setFavorite:(BOOL) favorite forRecipe:(Recipe*) recipe;

- (BOOL) isFavoriteForRecipe:(Recipe*) recipe;


#pragma mark Ingredients

- (NSArray*) ingredientsForRecipe:(Recipe*) recipe;


- (NSArray*) grilltips;
@end
