//
//  AppDelegate.m
//  LandmannImporter
//
//  Created by Wang on 20.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "AppDelegate.h"


#define DELIMITER @"|"

#define CAT_FILE @"Kategorien.csv"
#define ING_FILE @"Zutaten.csv"
#define REC_FILE @"Rezept %d"
#define TIP_FILE @"Grilltipps.csv"

#define CAT_BEGIN 1
#define CAT_REC 0
#define CAT_ING 1

#define ING_BEGIN 1
#define ING_NAME 0
#define ING_UNIT 1
#define ING_CAT 2

#define REC_BEGIN 1
#define REC_NUM 0
#define REC_NAME 1
#define REC_CAT 2
#define REC_TEXT 3
#define REC_DIFF 4
#define REC_TIME1 5
#define REC_TIME2 6
#define REC_GRILL 7
#define REC_PRICE 8
#define REC_KEYWORDS 9
#define REC_IMAGE_FULL 10
#define REC_IMAGE_THUMB 11
#define REC_ING_DETAILS 12
#define REC_ING_NAME 13
#define REC_ING_AMOUNT_MIN 14
#define REC_ING_AMOUNT_MAX 15
#define REC_PERSONS 16
#define REC_TIP 17

#define TIP_BEGIN 2
#define TIP_NUMBER 0
#define TIP_MENU 1
#define TIP_TITLE 2
#define TIP_TEXT 3
#define TIP_IMAGES 4


@implementation AppDelegate


static NSString* __strong * __recipeIgnoreList = new NSString*[4] {CAT_FILE, ING_FILE, TIP_FILE, @"Rezept_template.csv"};


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // test
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"content/csv" ofType:nil];
    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSLog(@"contents: %@", contents);
    
    // /test
    
    [[DataManager instanceNamed:@"content"] clearStore];
    
    [self importCategories];
    [self importIngredients];
    [self importRecipes];
    [self importGrilltips];
    
    [[DataManager instanceNamed:@"content"] save];

    [self printRecipes];
    
    
    // test calculation
    Recipe* rec1 = [[[DataManager instanceNamed:@"content"] fetchDataForEntityName:@"Recipe" withPredicate:[NSPredicate predicateWithFormat:@"number == %d", 1] sortedBy:nil] firstElement];
    Recipe* rec2 = [[[DataManager instanceNamed:@"content"] fetchDataForEntityName:@"Recipe" withPredicate:[NSPredicate predicateWithFormat:@"number == %d", 2] sortedBy:nil] firstElement];
    
    NSMutableArray* recArray = [NSMutableArray array];
    [recArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:rec1, @"recipe", [NSNumber numberWithInt:3], @"count", nil]];
    [recArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:rec2, @"recipe", [NSNumber numberWithInt:6], @"count", nil]];
    
    NSDictionary* shoppingDict = [self sumRecipes:recArray];
    
//    NSLog(@"%@", shoppingDict);
    
    [self printShoppingDict:shoppingDict];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void) printRecipes {
    
    NSArray* recipes = [[DataManager instanceNamed:@"content"] fetchDataForEntityName:@"Recipe" withPredicate:nil sortedBy:@"number", nil];
    
    for (Recipe* rec in recipes) {
        
        LogM(@"recipes", @"----- RECIPE BEGIN -----");

        // recipe
        
        LogM(@"recipes", @"RECIPE: number=%d, title=%@, text=%@, category=%@, difficulty=%d, time1=%f, time2=%f, time3=%f, grillType=%d, price=%d, imageFull=%@, imageThumb=%@", rec.number, rec.title, rec.text, rec.category.title, rec.difficulty, rec.time1, rec.time2, rec.time3, rec.grillType, rec.price, rec.imageFull, rec.imageThumb);
        
        
        // keywords
        
        NSArray* keywords = [[DataManager instanceNamed:@"content"] fetchDataForEntityName:@"Keyword" withPredicate:[NSPredicate predicateWithFormat:@"recipe == %@", rec] sortedBy:nil];

        for (Keyword* keyword in keywords) {
            
            LogM(@"recipes", @"KEYWORD: %@", keyword.title);
        }

        
        // ingredients
        
        NSArray* ingredients = [[DataManager instanceNamed:@"content"] fetchDataForEntityName:@"IngredientEntry" withPredicate:[NSPredicate predicateWithFormat:@"recipe == %@", rec] sortedBy:@"number", nil];
        
        for (IngredientEntry* entry in ingredients) {
            
            LogM(@"recipes", @"INGREDIENT: number=%d, details=%@, name=%@, category=%@, amount=%f, amountMax=%f, unit=%@", entry.number, entry.title, entry.ingredient.title, entry.ingredient.category.title, entry.amount, entry.amountMax, entry.ingredient.unit);
        }


        LogM(@"recipes", @"----- RECIPE END -----");
    }
    
    LogM_write2(@"recipes", @"recipes.txt");
}


- (void) importGrilltips {

    NSArray* lines = [self linesForFile:TIP_FILE];
    
    for (uint i = TIP_BEGIN; i < lines.count; ++i) {
        
        NSString* line = [lines objectAtIndex:i];
        
        NSArray* comps = [line componentsSeparatedByString:@"|"];
        
        if (comps.count < TIP_TEXT + 1) {
            
            NSLog(@"Importing Grilltips (%d): error", i);
        }
        
        uint number = [[comps objectAtIndex:TIP_NUMBER] integerValue];
        NSString* menuTitle = [comps objectAtIndex:TIP_MENU];
        NSString* title = [comps objectAtIndex:TIP_TITLE];
        NSString* text = [comps objectAtIndex:TIP_TEXT];
        
        Grilltip* tip = [[DataManager instanceNamed:@"content"] insertNewObjectForEntityName:@"Grilltip"];
        tip.number = number;
        tip.menuTitle = menuTitle;
        tip.title = title;
        tip.text = text;
        
        if (comps.count == TIP_IMAGES + 1) {
            
            tip.images = [comps objectAtIndex:TIP_IMAGES];
        }
    }
    
    [[DataManager instanceNamed:@"content"] save];
}


- (void) importRecipes {
    
    NSArray* lines = nil;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"content/csv" ofType:nil];
    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSArray* ignoreList = [NSArray arrayWithObjects:
                           __recipeIgnoreList[0],
                           __recipeIgnoreList[1],
                           __recipeIgnoreList[2],
                           __recipeIgnoreList[3],
                           nil];
    
    for (NSString* path in contents) {
        
        if ([ignoreList containsObject:path]) continue;
        
        lines = [self linesForFile:path];
        
        if (lines.count == 0) continue;
        

        NSLog(@"----------------------------------------------------");
        NSLog(@"Importing Recipe File: %@", path);
        
        Recipe* rec = [[DataManager instanceNamed:@"content"] insertNewObjectForEntityName:@"Recipe"];

        NSString* line = [lines objectAtIndex:REC_BEGIN];
        NSArray* comps = [line componentsSeparatedByString:DELIMITER];
        
        rec.number      = [[comps objectAtIndex:REC_NUM] integerValue];
        rec.title       = [comps objectAtIndex:REC_NAME];
        rec.category    = [[[DataManager instanceNamed:@"content"] fetchDataForEntityName:@"RecipeCategory" withPredicate:[NSPredicate predicateWithFormat:@"title == %@", [comps objectAtIndex:REC_CAT]] sortedBy:nil] firstElement];
        rec.text        = [comps objectAtIndex:REC_TEXT];
        rec.difficulty  = [[comps objectAtIndex:REC_DIFF] integerValue];
        rec.time1       = [[comps objectAtIndex:REC_TIME1] floatValue];
        rec.time2       = [[comps objectAtIndex:REC_TIME2] floatValue];
        rec.grillType   = [[comps objectAtIndex:REC_GRILL] isEqualToString:@"direkt"];
        rec.price       = [[comps objectAtIndex:REC_PRICE] integerValue];
        rec.imageFull   = [comps objectAtIndex:REC_IMAGE_FULL];
        rec.imageThumb  = [comps objectAtIndex:REC_IMAGE_THUMB];
        rec.tip         = [comps objectAtIndex:REC_TIP];
        rec.persons     = [[comps objectAtIndex:REC_PERSONS] integerValue];

        uint ingNumber = 1;
        
        // keywords and ingredients
        for (uint l = REC_BEGIN; l < lines.count; ++l) {
            
            NSString* line = [lines objectAtIndex:l];
            
            NSArray* comps = [line componentsSeparatedByString:DELIMITER];
            
            if (comps.count < REC_ING_AMOUNT_MIN + 1) {
                NSLog(@"error");
            }

            NSString* keyword   = [comps objectAtIndex:REC_KEYWORDS];
            NSString* ingDet    = [comps objectAtIndex:REC_ING_DETAILS];
            NSString* ingName   = [comps objectAtIndex:REC_ING_NAME];
            NSString* ingAmount = [comps objectAtIndex:REC_ING_AMOUNT_MIN];
            NSString* ingAmountMax = [comps objectAtIndex:REC_ING_AMOUNT_MAX];


//            // if has max amount
//            if (comps.count == REC_ING_AMOUNT_MAX + 1) {
//                
//                ingAmountMax = [comps objectAtIndex:REC_ING_AMOUNT_MAX];
//            }
            
            if (keyword.length != 0) {
                
                Keyword* kWord = [[DataManager instanceNamed:@"content"] insertNewObjectForEntityName:@"Keyword"];
                kWord.title = keyword;
                kWord.recipe = rec;
            }
            
            // if an entry for ingredients
            
//            NSLog(@"ingDet: _%@_, ingName: _%@_, ingAmount: _%@_", ingDet, ingName, ingAmount);
            
            if (ingDet.length != 0 || ingName.length != 0 || ingAmount.length != 0) {
                
                // details AND name must be set
                if (ingDet.length == 0 || ingName.length == 0) {
                    NSLog(@"error");
                }
                
                // if no amount is set -> split name into multiple strings and insert one ingredient per name without an amount
                if (ingAmount.length == 0) {

                    // insert ingredient details without a name or amount just for ingredients list, not shopping list
                    IngredientEntry* iEntry = [[DataManager instanceNamed:@"content"] insertNewObjectForEntityName:@"IngredientEntry"];
                    iEntry.title = ingDet;
                    iEntry.recipe = rec;
                    iEntry.number = ingNumber++;


                    NSArray* names = [ingName componentsSeparatedByString:@","];
                    
                    NSLog(@"names: %@", names);
                    
                    // insert each name without details for shopping list (without amount) not ingredient list
                    for (NSString* name in names) {
                        
                        IngredientEntry* iEntry = [[DataManager instanceNamed:@"content"] insertNewObjectForEntityName:@"IngredientEntry"];
                        iEntry.ingredient = [[[DataManager instanceNamed:@"content"] fetchDataForEntityName:@"Ingredient" withPredicate:[NSPredicate predicateWithFormat:@"title == %@", name] sortedBy:nil] firstElement];
                        iEntry.recipe = rec;
                        iEntry.number = ingNumber++;
                        
                        if (!iEntry.ingredient) {
                            NSLog(@"error: ingredient not found: %@", name);
//                            exit(1);
                        }
                    }
                    
                }
                
                // else if an amount is set -> insert the one name with the set amount
                else {
                
                    IngredientEntry* iEntry = [[DataManager instanceNamed:@"content"] insertNewObjectForEntityName:@"IngredientEntry"];
                    iEntry.title = ingDet;
                    iEntry.ingredient = [[[DataManager instanceNamed:@"content"] fetchDataForEntityName:@"Ingredient" withPredicate:[NSPredicate predicateWithFormat:@"title == %@", ingName] sortedBy:nil] firstElement];
                    iEntry.amount = [[[ingAmount componentsSeparatedByString:@" "] firstElement] floatValue];
                    iEntry.recipe = rec;
                    iEntry.number = ingNumber++;
                    iEntry.amountMax = [[[ingAmountMax componentsSeparatedByString:@" "] firstElement] floatValue];
                    
                    if (!iEntry.ingredient) {
                        NSLog(@"error: ingredient not found: %@", ingName);
//                        exit(1);
                    }
                }
            }
            
//            ++ingNumber;
            
        }

        NSLog(@"%@", rec);
        
    }
}


- (void) importIngredients {

    NSArray* lines = [self linesForFile:ING_FILE];
    
    uint count = 0;
    
    for (uint l = ING_BEGIN; l < lines.count; ++l) {
        
        NSString* line = [lines objectAtIndex:l];
        
        NSArray* comps = [line componentsSeparatedByString:DELIMITER];

        // name and cat must not be empty (unit can be empty)
        if (comps.count < ING_CAT + 1 || [[comps objectAtIndex:ING_NAME] length] == 0 || [[comps objectAtIndex:ING_CAT] length] == 0) {
            continue;
        }
        
        
        Ingredient* ing = [[DataManager instanceNamed:@"content"] insertNewObjectForEntityName:@"Ingredient"];
        ing.title = [comps objectAtIndex:ING_NAME];
        ing.unit = [comps objectAtIndex:ING_UNIT];
        ing.number = count++;
        
        IngredientCategory* iCat = [[[DataManager instanceNamed:@"content"] fetchDataForEntityName:@"IngredientCategory"
                                                                                     withPredicate:[NSPredicate predicateWithFormat:@"title == %@", [comps objectAtIndex:ING_CAT]]
        
                                                                                 sortedBy:nil] firstElement];
        
        if (!iCat) {
            
            NSLog(@"error: IngredientCategory not found: title=%@", [comps objectAtIndex:ING_CAT]);
        }
        
        ing.category = iCat;
    }
}


- (void) importCategories {

    NSArray* lines = [self linesForFile:CAT_FILE];
    
    uint catRecCount = 0;
    uint catIngCount = 0;
    
    for (uint l = CAT_BEGIN; l < lines.count; ++l) {
        
        NSString* line = [lines objectAtIndex:l];
        
        NSArray* comps = [line componentsSeparatedByString:DELIMITER];
        
        if (comps.count >= CAT_REC + 1 && ![[comps objectAtIndex:CAT_REC] isEqualToString:@""]) {

            RecipeCategory* rCat = [[DataManager instanceNamed:@"content"] insertNewObjectForEntityName:@"RecipeCategory"];
            rCat.title = [comps objectAtIndex:CAT_REC];
            rCat.number = catRecCount;
            
            NSLog(@"Category, Recipe: %@", [comps objectAtIndex:CAT_REC]);
            
            ++catRecCount;
        }

        if (comps.count >= CAT_ING + 1 && ![[comps objectAtIndex:CAT_ING] isEqualToString:@""]) {

            IngredientCategory* iCat = [[DataManager instanceNamed:@"content"] insertNewObjectForEntityName:@"IngredientCategory"];
            iCat.title = [comps objectAtIndex:CAT_ING];
            iCat.number = catIngCount;

            NSLog(@"Category, Ingredient: %@", [comps objectAtIndex:CAT_ING]);
            
            ++catIngCount;
        }
    }
}


- (NSArray*) linesForFile:(NSString*) file {
    
    NSString* path = [[NSBundle mainBundle] pathForResource:file
                                                     ofType:nil
                                                inDirectory:@"content/csv"];
    
    NSString* data = [NSString stringWithContentsOfFile:path
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    
    NSMutableArray* lines = [NSMutableArray arrayWithArray:[data componentsSeparatedByString:@"\n"]];
    
    if (((NSString*)[lines lastObject]).length == 0) {

        [lines removeLastObject];
    }

//    NSLog(@"path: %@ (%d lines)", path, lines.count);
    
    return lines;
}



// "recipes" structure:
// NSArray
// +--NSDictionary
//    +--"recipe": Recipe* object
//    +--"count": uint
- (NSDictionary*) sumRecipes:(NSArray*) recipes {
    
    NSMutableDictionary* shoppingDict = [NSMutableDictionary dictionary];
    // shoppingDict structure:
    // NSDictionary
    // +--"name": NSDictionary
    //    +--"amount" (opt.)
    //    +--"unit" (opt.)
    
    for (NSDictionary* recDict in recipes) {
        
        Recipe* rec = [recDict objectForKey:@"recipe"];
        uint count = [[recDict objectForKey:@"count"] integerValue];
        
        for (IngredientEntry* ing in rec.ingredients) {

            // cases:
            // 1. ing.ingredient == null --> ignore
            // 2. ing.ingredient != null --> use

            if (ing.ingredient) {
                
                NSMutableDictionary* ingDict = [shoppingDict objectForKey:ing.ingredient.title];
                
                if (!ingDict) {
                    ingDict = [NSMutableDictionary dictionary];
                    [shoppingDict setObject:ingDict forKey:ing.ingredient.title];

                    [ingDict setObject:ing.ingredient.unit forKey:@"unit"];
                }

                if (ing.amount) {
        
                    float newAmount = [[ingDict objectForKey:@"amount"] floatValue] + (ing.amount * count);
        
                    [ingDict setObject:[NSNumber numberWithFloat:newAmount] forKey:@"amount"];
                }
            }
        }
    }

    return shoppingDict;
}


- (void) printShoppingDict:(NSDictionary*) dict {
    
    for (NSString* key in dict.allKeys) {

        NSDictionary* ingDict = [dict objectForKey:key];
        
        LogM(@"shop", @"%@: %d %@", key, [[ingDict objectForKey:@"amount"] intValue], [ingDict objectForKey:@"unit"]);
    }
    
    LogM_write2(@"shop", @"shopping.txt");
}



@end



