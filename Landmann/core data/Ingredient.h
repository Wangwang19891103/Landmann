//
//  Ingredient.h
//  Landmann
//
//  Created by Wang on 20.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IngredientCategory, IngredientEntry;

@interface Ingredient : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic) int16_t number;
@property (nonatomic, retain) IngredientCategory *category;
@property (nonatomic, retain) NSSet *entries;
@end

@interface Ingredient (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(IngredientEntry *)value;
- (void)removeEntriesObject:(IngredientEntry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

@end
