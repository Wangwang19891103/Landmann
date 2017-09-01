//
//  ContentDataManager.m
//  Landmann
//
//  Created by Wang on 18.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "ContentDataManager.h"
#import "FloatFormatter.h"


#define CUSTOM_ENTRY_DEFAULT_TEXT @"Neuer Eintrag"



@implementation ContentDataManager


+ (id) instance {

    static ContentDataManager* _instance = nil;
    
    @synchronized(self) {
        
        if (!_instance) {
            
            _instance = [[ContentDataManager alloc] init];
        }
    }
    
    return _instance;
}



#pragma mark Recipes

- (NSArray*) recipesForCategory:(NSString *)category difficulty:(RecipeDifficulty)difficulty {
    
    NSPredicate* predicate = nil;
    
    if (difficulty == RecipeDifficultyAll) {
        
        predicate = [NSPredicate predicateWithFormat:@"category.title == %@", category];
    }
    else {
        
        predicate = [NSPredicate predicateWithFormat:@"category.title == %@ AND difficulty == %d", category, difficulty];
    }
    
    return [[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Recipe" withPredicate:predicate sortedBy:@"difficulty", @"number", nil];
}


- (NSArray*) recipesWithFavoritesForDifficulty:(RecipeDifficulty)difficulty {
    
    // fetch UserRecipes with favorite
    
    NSArray* userRecipes = [[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserRecipe" withPredicate:[NSPredicate predicateWithFormat:@"favorite == true"] sortedBy:@"number", nil];
    
    
    // find corresponding Recipes (number)

    NSMutableArray* recipes = [NSMutableArray array];

    for (UserRecipe* userRecipe in userRecipes) {
        
        NSPredicate* predicate = nil;

        predicate = [NSPredicate predicateWithFormat:@"number == %d", userRecipe.number];

//        if (difficulty == RecipeDifficultyAll) {
//            
//            predicate = [NSPredicate predicateWithFormat:@"number == %d", userRecipe.number];
//        }
//        else {
//            
//            predicate = [NSPredicate predicateWithFormat:@"number == %d && difficulty == %d", userRecipe.number, difficulty];
//        }
        
        Recipe* recipe = [[[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Recipe" withPredicate:predicate sortedBy:nil] firstElement];
        
        [recipes addObject:recipe];
    }

    [recipes filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary* bidings) {

        if (difficulty == RecipeDifficultyAll) return true;
        
        else if (((Recipe*)evaluatedObject).difficulty == difficulty) return true;
        else return false;
    }]];
    
    [recipes sortUsingDescriptors:@[
                                    [NSSortDescriptor sortDescriptorWithKey:@"difficulty" ascending:true],
                                    [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:true]
     ]];
    
    return recipes;
    
    // sort Recipes by Difficulty and Number
    
    
//    if (difficulty == RecipeDifficultyAll) {
//        
//        predicate = nil;
//    }
//    else {
//        
//        predicate = [NSPredicate predicateWithFormat:@"difficulty == %d", difficulty];
//    }
//    
//    return [[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Recipe" withPredicate:predicate sortedBy:@"difficulty", @"number", nil];
}


- (NSArray*) recipesOnShoppingList {
    
//    NSArray* userShoppingEntries = [[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserShoppingEntry" withPredicate:nil sortedBy:@"recipe.number", nil];
//    
//    NSMutableArray* recipes = [NSMutableArray array];
//    
//    for (UserShoppingEntry* entry in userShoppingEntries) {
//        
//        Recipe* recipe = [[[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Recipe" withPredicate:[NSPredicate predicateWithFormat:@"number == %d", entry.recipe.number] sortedBy:nil] firstElement];
//        
//
//        [recipes addObject:recipe];
//    }

    NSArray* userRecipes = [[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserRecipe" withPredicate:[NSPredicate predicateWithFormat:@"added == %d", 1] sortedBy:@"number", nil];

    NSMutableArray* recipes = [NSMutableArray array];
    
    for (UserRecipe* userRecipe in userRecipes) {
        
        Recipe* recipe = [[[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Recipe" withPredicate:[NSPredicate predicateWithFormat:@"number == %d", userRecipe.number] sortedBy:nil] firstElement];
        
        [recipes addObject:recipe];
    }
    
    return recipes;
}


- (Recipe*) recipeWithNumber:(uint)number {
    
    return [[[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Recipe" withPredicate:[NSPredicate predicateWithFormat:@"number == %d", number] sortedBy:nil] firstElement];
}


- (NSArray*) recipesSortedAlhpabetically {
    
    return [[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Recipe" withPredicate:nil sortedBy:@"title", nil];
}


- (void) addRecipe:(Recipe*)recipe toShoppingListWithScale:(uint)scale {
    
    UserRecipe* userRecipe = [[[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserRecipe" withPredicate:[NSPredicate predicateWithFormat:@"number == %d", recipe.number] sortedBy:nil] firstElement];
    
    if (!userRecipe) {
        
        userRecipe = [[DataManager instanceNamed:@"user"] insertNewObjectForEntityName:@"UserRecipe"];
        userRecipe.number = recipe.number;
    }

    userRecipe.added = true;
    userRecipe.scale = scale;
    userRecipe.baseScale = recipe.persons;
    
    // strip all shopping entries which might be there from previous adding
    uint deletedCount = 0;
    for (UserShoppingEntry* entry in userRecipe.shoppingEntries) {
        [[DataManager instanceNamed:@"user"] deleteObject:entry];
        ++deletedCount;
    }
//    alert(@"%d deleted", deletedCount);
    

    for (IngredientEntry* entry in recipe.ingredients) {
        
        NSLog(@"ingredient title: %@", entry.title);
        
        if (!entry.ingredient) continue; // if no ingredient is set -> ignore

        NSString* name = entry.ingredient.title;
        float amount = entry.amount;
        float amountMax = entry.amountMax;
        NSString* unit = entry.ingredient.unit;
        
        NSString* amountString = nil;
        NSString* unitString = @"";
        
        if (amount == 0) amountString = @"";
        else {
            if ([unit isEqualToString:@""]) unitString = @"";
            else unitString = [NSString stringWithFormat:@"%@ ", unit];

            if (amountMax == 0) amountString = [NSString stringWithFormat:@"%@ ", [FloatFormatter stringForFloat:amount]];
            else amountString = [NSString stringWithFormat:@"%@ - %@ ", [FloatFormatter stringForFloat:amount], [FloatFormatter stringForFloat:amountMax]];
        }
        
        
//        NSString* text = [NSString stringWithFormat:@"%@%@%@", amountString, unitString, name];
        NSString* text = [NSString stringWithFormat:@"%@%@", unitString, name];
        
        UserShoppingEntry* shoppingEntry = [[DataManager instanceNamed:@"user"] insertNewObjectForEntityName:@"UserShoppingEntry"];
        shoppingEntry.number = entry.number;
        shoppingEntry.text = text;
        shoppingEntry.recipe = userRecipe;
        shoppingEntry.ingredientNumber = entry.ingredient.number;
        shoppingEntry.amount = entry.amount;
        shoppingEntry.amountMax = entry.amountMax;
    }
    
//    UserShoppingEntry* entry = userRecipe.shoppingEntry;
//    
//    if (!entry) {
//        
//        entry = [[DataManager instanceNamed:@"user"] insertNewObjectForEntityName:@"UserShoppingEntry"];
//        entry.recipe = userRecipe;
//    }
//    
//    entry.scale = scale;
    
    [[DataManager instanceNamed:@"user"] save];
    
//    [self printRecipes];
}


- (BOOL) isRecipeAddedToShoppingList:(Recipe*) recipe {
    
    UserRecipe* userRecipe = [[[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserRecipe" withPredicate:[NSPredicate predicateWithFormat:@"number == %d", recipe.number] sortedBy:nil] firstElement];
    
    if (userRecipe && userRecipe.added) return true;
    else return false;
}


- (UserRecipe*) userRecipeForRecipe:(Recipe*) recipe {
    
    return [[[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserRecipe" withPredicate:[NSPredicate predicateWithFormat:@"number == %d", recipe.number] sortedBy:nil] firstElement];
}


- (NSArray*) recipesForKeywords:(NSArray *)keywords withDiffculty:(RecipeDifficulty)difficulty {
    
    NSPredicate* predicate = nil;
    
    if (difficulty != RecipeDifficultyAll) {

        predicate = [NSPredicate predicateWithFormat:@"difficulty == %d", difficulty];
    }
    
    NSArray* results = [[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Recipe" withPredicate:predicate sortedBy:@"number", nil];
    
    
    predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        Recipe* recipe = (Recipe*)evaluatedObject;
        
        for (NSString* search in keywords) {
            
            BOOL found = false;
            
            for (Keyword* keyword in recipe.keywords) {
                
                if ([[keyword.title lowercaseString] isEqualToString:[search lowercaseString]]) {
                    
                    found = true;
                    break;
                }
            }
            
            if (!found) return false;
        }
        
        return true;
    }];
    
    return [results filteredArrayUsingPredicate:predicate];
}


- (void) deleteRecipeFromShoppingListWithNumber:(uint) number {

    UserRecipe* recipe = [[[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserRecipe" withPredicate:[NSPredicate predicateWithFormat:@"number == %d", number] sortedBy:nil] firstElement];

    for (UserShoppingEntry* entry in recipe.shoppingEntries) {
        
        [[DataManager instanceNamed:@"user"] deleteObject:entry];
    }
    
    recipe.added = false;
    recipe.scale = 0;
    
    [[DataManager instanceNamed:@"user"] save];
}


- (uint) increaseScaleForRecipe:(Recipe *)recipe {
    
    UserRecipe* userRecipe = [self userRecipeForRecipe:recipe];
    
    userRecipe.scale = userRecipe.scale + 1;

    [[DataManager instanceNamed:@"user"] save];

    return userRecipe.scale;
}


- (uint) decreaseScaleForRecipe:(Recipe *)recipe {
    
    UserRecipe* userRecipe = [self userRecipeForRecipe:recipe];
    
    userRecipe.scale = MAX(1, userRecipe.scale - 1);

    [[DataManager instanceNamed:@"user"] save];

    return userRecipe.scale;
}


- (void) deleteShoppingEntries:(NSArray*) entries {
    
    for (UserShoppingEntry* entry in entries) {
        
        UserRecipe* recipe = entry.recipe;
        
        [[DataManager instanceNamed:@"user"] deleteObject:entry];
        
        
        // remove whole recipe if no more entries
        
        if (recipe && recipe.shoppingEntries.count == 1) {
            
            [self deleteRecipeFromShoppingListWithNumber:recipe.number];
        }
    }

    
    [[DataManager instanceNamed:@"user"] save];
}


- (UserShoppingEntry*) insertCustomShoppingEntry {
    
    // find next number
    
    UserShoppingEntry* maxEntry = [[[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserShoppingEntry" withPredicate:[NSPredicate predicateWithFormat:@"recipe == nil"] sortedBy:@"number", nil] lastObject];

    uint newNumber;
    
    if (maxEntry)
        newNumber = maxEntry.number + 1;
    else {
        newNumber = 0;
    }

    
    UserShoppingEntry* entry = [[DataManager instanceNamed:@"user"] insertNewObjectForEntityName:@"UserShoppingEntry"];
    entry.number = newNumber;
    entry.recipe = nil; // means its a custom entry
    entry.text = CUSTOM_ENTRY_DEFAULT_TEXT;
    
    // watch ingredientNumber that it isnt misinterpreted as ingredient 0
    // also custom entries are never summed up (over ingredientNumber 0)

    [[DataManager instanceNamed:@"user"] save];

    return entry;
}


- (void) setFavorite:(BOOL)favorite forRecipe:(Recipe *)recipe {
    
    UserRecipe* userRecipe = [self userRecipeForRecipe:recipe];
    
    if (!userRecipe) {
        
        userRecipe = [[DataManager instanceNamed:@"user"] insertNewObjectForEntityName:@"UserRecipe"];
        userRecipe.number = recipe.number;
    }
    
    userRecipe.favorite = favorite;
    
    [[DataManager instanceNamed:@"user"] save];
}


- (BOOL) isFavoriteForRecipe:(Recipe *)recipe {
    
    UserRecipe* userRecipe = [self userRecipeForRecipe:recipe];

    return userRecipe.favorite;
}



#pragma mark Ingredients

- (NSArray*) ingredientsForRecipe:(Recipe *)recipe {
    
    return [[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"IngredientEntry" withPredicate:[NSPredicate predicateWithFormat:@"recipe == %@", recipe] sortedBy:@"number", nil];
}


- (NSArray*) grilltips {
    
    return [[DataManager instanceInBundleNamed:@"content"] fetchDataForEntityName:@"Grilltip" withPredicate:nil sortedBy:@"number", nil];
}


- (void) printRecipes {
    
    LogM_purge(@"recipes");
    
    NSArray* recipes = [[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserRecipe" withPredicate:nil sortedBy:@"number", nil];
    
    for (UserRecipe* rec in recipes) {
        
        LogM(@"recipes", @"----- USERRECIPE BEGIN -----");
        
        LogM(@"recipes", @"USERRECIPE: number=%d", rec.number);
        
        NSArray* shoppingEntries = [[DataManager instanceNamed:@"user"] fetchDataForEntityName:@"UserShoppingEntry" withPredicate:[NSPredicate predicateWithFormat:@"recipe == %@", rec] sortedBy:@"number", nil];

        for (UserShoppingEntry* shoppingEntry in shoppingEntries) {
        
            LogM(@"recipes", @"USERSHOPPINGENTRY: number=%d, text=%@", shoppingEntry.number, shoppingEntry.text);
        }
        
        if (rec.note) LogM(@"recipes", @"USERNOTE: text=%@", rec.note.text);
        
        LogM(@"recipes", @"----- USERRECIPE END -----");
    }
    
    LogM_write2(@"recipes", @"user.txt");
}

@end
